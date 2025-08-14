from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import auth, features, votes

app = FastAPI(title="MetaCTO API", version="1.0.0")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(features.router)
app.include_router(votes.router)

@app.get("/")
def read_root():
    return {"message": "Welcome to MetaCTO API"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}