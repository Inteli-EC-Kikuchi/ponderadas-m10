from fastapi import APIRouter, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
import logging
from PIL import Image
import io

router = APIRouter()
logger = logging.getLogger(__name__)

@router.get("/")
def read_root():
    return {"message": "Welcome to the image processor"}

@router.post("/process-image")
async def process_image(file: UploadFile = File(...)):
    if file.content_type not in ["image/jpeg", "image/png"]:
        logger.warning(f"Unsupported file type: {file.content_type}")
        raise HTTPException(status_code=400, detail="Unsupported file type")

    try:
        # Read the image file
        contents = await file.read()
        image = Image.open(io.BytesIO(contents))

        # Process the image here (e.g., remove background)
        # For demonstration, just log the image size
        logger.info(f"Received image with size: {image.size}")

        # Return a response
        return JSONResponse(content={"message": "Image processed successfully"}, status_code=200)
    except Exception as e:
        logger.error(f"Error processing image: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")

