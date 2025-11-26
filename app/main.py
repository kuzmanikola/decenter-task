from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from datetime import datetime
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = FastAPI()

request_count = 0

@app.middleware("http")
async def count_requests(request: Request, call_next):
    """Middleware to count all incoming requests"""
    global request_count
    request_count += 1
    response = await call_next(request)
    return response

@app.get("/health")
async def health():
    """
    Health check endpoint that returns the status and current timestamp
    """
    logger.info("Health check endpoint called")
    return JSONResponse(
        content={
            "status": "ok",
            "timestamp": datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
        }
    )

@app.get("/metrics")
async def metrics():
    """
    Metrics endpoint that returns the total number of requests since startup
    """
    return JSONResponse(
        content={
            "total_requests": request_count
        }
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000)

