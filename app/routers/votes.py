from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Vote, Feature, User
from app.schemas import VoteCreate, VoteResponse
from app.auth import get_current_user

router = APIRouter(prefix="/votes", tags=["votes"])

@router.post("/", response_model=VoteResponse)
def create_vote(
    vote: VoteCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Check if feature exists
    feature = db.query(Feature).filter(Feature.id == vote.feature_id).first()
    if not feature:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Feature not found"
        )
    
    # Check if user already voted for this feature
    existing_vote = db.query(Vote).filter(
        Vote.user_id == current_user.id,
        Vote.feature_id == vote.feature_id
    ).first()
    
    if existing_vote:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You have already voted for this feature"
        )
    
    # Check if user is trying to vote for their own feature
    if feature.author_id == current_user.id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You cannot vote for your own feature"
        )
    
    db_vote = Vote(
        user_id=current_user.id,
        feature_id=vote.feature_id
    )
    db.add(db_vote)
    db.commit()
    db.refresh(db_vote)
    return db_vote

@router.delete("/{feature_id}")
def remove_vote(
    feature_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    vote = db.query(Vote).filter(
        Vote.user_id == current_user.id,
        Vote.feature_id == feature_id
    ).first()
    
    if not vote:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Vote not found"
        )
    
    db.delete(vote)
    db.commit()
    return {"message": "Vote removed successfully"}