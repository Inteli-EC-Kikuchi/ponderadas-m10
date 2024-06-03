import logging
from fastapi import FastAPI, Request
import routes.image_processor as image_processor_routes

app = FastAPI(redirect_slashes=False)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.middleware("http")
async def log_requests(request: Request, call_next):
    logger.info(f"Request: {request.method} {request.url}")
    response = await call_next(request)
    logger.info(f"Response status: {response.status_code}")
    return response

app.include_router(image_processor_routes.router, prefix="/image-processor", tags=["image-processor"])
