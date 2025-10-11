import os
import asyncio
import subprocess
from typing import List, Union
import json

from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse, FileResponse, StreamingResponse, JSONResponse

from manga_translator import Config
from manga_translator.translators import TRANSLATORS
from manga_translator.translators.common import VALID_LANGUAGES
from manga_translator.config import Translator

from server.instance import executor_instances, ExecutorInstance
from server.myqueue import task_queue
from server.request_extraction import (
    TranslateRequest,
    BatchTranslateRequest,
    get_ctx,
    get_batch_ctx,
    while_streaming,
)
from server.to_json import to_translation
from server.args import parse_arguments


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root() -> HTMLResponse:
    # Try local index.html first (root-level server directory)
    index_candidates = [
        os.path.join(os.path.dirname(__file__), "index.html"),
        # Fallback to package's server directory where index.html usually lives
        os.path.join(os.path.dirname(__file__), "..", "manga-image-translator", "server", "index.html"),
        os.path.join(os.path.dirname(__file__), "..", "manga-image-translator", "server", "index.html"),
    ]
    for index_path in index_candidates:
        try:
            if os.path.exists(index_path):
                return HTMLResponse(open(index_path, "r", encoding="utf-8").read())
        except Exception:
            pass
    return HTMLResponse("<h3>Manga Image Translator API</h3>")


@app.get("/api/status")
async def api_status():
    total_instances = len(executor_instances.list)
    free_instances = executor_instances.free_executors()
    queue_size = len(task_queue.queue)
    return {
        "running": True,
        "queue_size": queue_size,
        "instances_total": total_instances,
        "instances_free": free_instances,
    }


@app.post("/api/register_executor")
async def register_executor(body: dict):
    ip = body.get("ip")
    port = body.get("port")
    if not ip or not port:
        raise HTTPException(status_code=422, detail="Missing ip or port")
    try:
        port = int(port)
    except Exception:
        raise HTTPException(status_code=422, detail="Invalid port")
    executor_instances.register(ExecutorInstance(ip=ip, port=port))
    return {"registered": True, "ip": ip, "port": port, "instances_total": len(executor_instances.list)}


@app.get("/queue-size")
async def queue_size():
    return JSONResponse(len(task_queue.queue))


@app.get("/api/config")
async def api_config():
    def _name(k: Union[str, Translator]) -> str:
        return k.value if isinstance(k, Translator) else str(k)

    translators: List[str] = sorted(_name(k) for k in TRANSLATORS.keys())
    try:
        from manga_translator.translators.google import GoogleTranslator  # noqa: F401
        if 'google' not in translators:
            translators.append('google')
            translators.sort()
    except Exception:
        pass
    languages = {
        "codes": sorted(list(VALID_LANGUAGES.keys())),
        "names": VALID_LANGUAGES,
    }
    return {
        "languages": languages,
        "translators": translators,
        "result_dir": "results",
        "max_file_size": "16MB",
        "supported_formats": ["png", "jpg", "jpeg", "bmp", "tiff"],
    }


@app.get("/results/list")
async def results_list():
    results_path = os.path.join(os.path.dirname(__file__), "..", "results")
    results_path = os.path.abspath(results_path)
    if not os.path.isdir(results_path):
        return {"items": []}
    items = []
    for root, _, files in os.walk(results_path):
        for f in files:
            if f.lower().endswith((".png", ".jpg", ".jpeg")):
                rel = os.path.relpath(os.path.join(root, f), results_path)
                items.append(rel.replace("\\", "/"))
    return {"items": sorted(items)}


@app.get("/result/{subpath:path}")
async def get_result_file(subpath: str):
    results_path = os.path.join(os.path.dirname(__file__), "..", "results")
    file_path = os.path.abspath(os.path.join(results_path, subpath))
    if not file_path.startswith(os.path.abspath(results_path)):
        raise HTTPException(status_code=403, detail="Forbidden path")
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="File not found")
    return FileResponse(file_path)


@app.post("/translate/with-form/json")
async def translate_json(req: Request, body: TranslateRequest):
    ctx = await get_ctx(req, body.config, body.image)
    return to_translation(ctx)


@app.post("/translate/batch/json")
async def translate_batch(req: Request, body: BatchTranslateRequest):
    ctx = await get_batch_ctx(req, body.config, body.images, body.batch_size)
    return to_translation(ctx)


@app.post("/translate/with-form/image/stream/json")
async def translate_stream(req: Request, body: TranslateRequest):
    def transform_to_bytes(context):
        return to_translation(context).to_bytes()
    return await while_streaming(req, transform_to_bytes, body.config, body.image)

# Removed duplicate web streaming endpoint definition to avoid route conflicts


@app.post("/translate/with-form/image/stream/web")
async def translate_stream_web(req: Request):
    """Multipart/form-data streaming endpoint used by the web UI.

    Expects form fields:
    - image: file content
    - config: JSON string (optional)
    """
    form = await req.form()
    image_field = form.get("image")
    cfg_text = form.get("config")

    if image_field is None:
        raise HTTPException(status_code=400, detail="Missing 'image' file in form data")

    # Support UploadFile, raw bytes, or base64/url string
    try:
        if hasattr(image_field, "read"):
            image_bytes = await image_field.read()
        elif isinstance(image_field, (bytes, bytearray)):
            image_bytes = bytes(image_field)
        elif isinstance(image_field, str):
            image_bytes = image_field  # handled downstream (base64 or URL)
        else:
            raise HTTPException(status_code=415, detail="Unsupported image field type")
        # Guard against empty uploads
        if isinstance(image_bytes, (bytes, bytearray)) and len(image_bytes) == 0:
            raise HTTPException(status_code=422, detail="Empty image upload")
    except Exception as e:
        raise HTTPException(status_code=422, detail=str(e))

    # Parse config, allow empty for defaults
    try:
        if isinstance(cfg_text, str) and cfg_text.strip():
            cfg_dict = json.loads(cfg_text)
            # pydantic v2-compatible validation
            try:
                config = Config.model_validate(cfg_dict)  # type: ignore[attr-defined]
            except Exception:
                config = Config(**cfg_dict)
        else:
            config = Config()
    except Exception as e:
        raise HTTPException(status_code=422, detail=f"Invalid config JSON: {str(e)}")

    def transform_to_bytes(context):
        return to_translation(context).to_bytes()

    return await while_streaming(req, transform_to_bytes, config, image_bytes)


if __name__ == "__main__":
    import uvicorn
    args = parse_arguments()

    async def start_and_register_executor():
        try:
            executor_host = args.host
            executor_port = args.port + 1
            cmd = [
                os.environ.get("PYTHON_EXECUTABLE", os.getenv("PYTHON", "python")),
                "-m", "manga_translator",
                "shared",
                "--host", executor_host,
                "--port", str(executor_port),
            ]
            if getattr(args, "nonce", None):
                cmd.extend(["--nonce", args.nonce])
            cmd.extend(["--report", f"http://{args.host}:{args.port}/api/register_executor"])
            subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            executor_instances.register(ExecutorInstance(ip=executor_host, port=executor_port))
        except Exception:
            pass

    if getattr(args, "start_instance", False):
        try:
            asyncio.get_event_loop().run_until_complete(start_and_register_executor())
        except RuntimeError:
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
            loop.run_until_complete(start_and_register_executor())

    uvicorn.run(app, host=args.host, port=args.port)