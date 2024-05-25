import uvicorn
import logging
from fastapi import FastAPI, Request
from database.database import Base, engine
import routes.users as user_routes
import routes.image_processor as image_processor_routes

Base.metadata.create_all(bind=engine)

app = FastAPI(redirect_slashes=False)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.middleware("http")
async def log_requests(request: Request, call_next):
    logger.info(f"Request: {request.method} {request.url}")
    response = await call_next(request)
    logger.info(f"Response status: {response.status_code}")
    return response

app.include_router(user_routes.router, prefix="/users", tags=["users"])
app.include_router(image_processor_routes.router, prefix="/image-processor", tags=["image-processor"])

@app.get("/")
def read_root():
    return {"message": "Welcome to the FastAPI application"}
