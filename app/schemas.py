from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional, List

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: int
    name: str
    email: str
    created_at: datetime
    
    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None

class FeatureCreate(BaseModel):
    title: str
    description: Optional[str] = None

class FeatureResponse(BaseModel):
    id: int
    title: str
    description: Optional[str]
    author_id: int
    created_at: datetime
    author: UserResponse
    vote_count: Optional[int] = 0
    
    class Config:
        from_attributes = True

class VoteCreate(BaseModel):
    feature_id: int

class VoteResponse(BaseModel):
    id: int
    user_id: int
    feature_id: int
    created_at: datetime
    
    class Config:
        from_attributes = True