from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from typing import List
from app.database import get_db
from app.models import Feature, User, Vote
from app.schemas import FeatureCreate, FeatureResponse
from app.auth import get_current_user

router = APIRouter(prefix="/features", tags=["features"])

@router.post("/", response_model=dict)
def create_feature(
    feature: FeatureCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    db_feature = Feature(
        title=feature.title,
        description=feature.description,
        author_id=current_user.id
    )
    db.add(db_feature)
    db.commit()
    db.refresh(db_feature)
    
    # Load the feature with all relationships for proper serialization
    feature = db.query(Feature).options(
        joinedload(Feature.author),
        joinedload(Feature.votes)
    ).filter(Feature.id == db_feature.id).first()
    
    # Manually construct response to avoid serialization issues
    return {
        "id": feature.id,
        "title": feature.title,
        "description": feature.description,
        "author_id": feature.author_id,
        "created_at": feature.created_at,
        "author": {
            "id": feature.author.id,
            "name": feature.author.name,
            "email": feature.author.email,
            "created_at": feature.author.created_at
        },
        "vote_count": feature.vote_count
    }

@router.get("/", response_model=dict)
def list_features(
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db)
):
    offset = (page - 1) * limit
    
    # Get total count
    total = db.query(func.count(Feature.id)).scalar()
    
    # Get features with pagination and eager load relationships
    features = db.query(Feature).options(
        joinedload(Feature.author),
        joinedload(Feature.votes)
    ).offset(offset).limit(limit).all()
    
    # Manually construct response to avoid serialization issues
    feature_items = []
    for feature in features:
        feature_items.append({
            "id": feature.id,
            "title": feature.title,
            "description": feature.description,
            "author_id": feature.author_id,
            "created_at": feature.created_at,
            "author": {
                "id": feature.author.id,
                "name": feature.author.name,
                "email": feature.author.email,
                "created_at": feature.author.created_at
            },
            "vote_count": feature.vote_count
        })
    
    return {
        "items": feature_items,
        "total": total,
        "page": page,
        "limit": limit,
        "pages": (total + limit - 1) // limit
    }

@router.get("/{feature_id}", response_model=dict)
def get_feature(feature_id: int, db: Session = Depends(get_db)):
    feature = db.query(Feature).options(
        joinedload(Feature.author),
        joinedload(Feature.votes)
    ).filter(Feature.id == feature_id).first()
    if not feature:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Feature not found"
        )
    
    # Manually construct response to avoid serialization issues
    return {
        "id": feature.id,
        "title": feature.title,
        "description": feature.description,
        "author_id": feature.author_id,
        "created_at": feature.created_at,
        "author": {
            "id": feature.author.id,
            "name": feature.author.name,
            "email": feature.author.email,
            "created_at": feature.author.created_at
        },
        "vote_count": feature.vote_count
    }