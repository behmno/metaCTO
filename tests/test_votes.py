import pytest
from fastapi.testclient import TestClient

def get_auth_headers(client: TestClient, email: str = "test@example.com", password: str = "testpassword123"):
    # Register and login user
    client.post(
        "/auth/register",
        json={
            "name": "Test User",
            "email": email,
            "password": password
        }
    )
    
    login_response = client.post(
        "/auth/login",
        data={
            "username": email,
            "password": password
        }
    )
    token = login_response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}

def create_feature(client: TestClient, headers: dict, title: str = "Test Feature") -> int:
    response = client.post(
        "/features/",
        json={
            "title": title,
            "description": "A test feature"
        },
        headers=headers
    )
    return response.json()["id"]

def test_vote_for_feature_success(client: TestClient):
    # Create author user and feature
    author_headers = get_auth_headers(client, "author@example.com")
    feature_id = create_feature(client, author_headers)
    
    # Create voter user
    voter_headers = get_auth_headers(client, "voter@example.com")
    
    # Vote for the feature
    response = client.post(
        "/votes/",
        json={"feature_id": feature_id},
        headers=voter_headers
    )
    
    assert response.status_code == 200
    data = response.json()
    assert data["feature_id"] == feature_id
    assert "user_id" in data
    assert "created_at" in data

def test_vote_without_auth(client: TestClient):
    response = client.post(
        "/votes/",
        json={"feature_id": 1}
    )
    
    assert response.status_code == 401

def test_vote_for_nonexistent_feature(client: TestClient):
    headers = get_auth_headers(client)
    
    response = client.post(
        "/votes/",
        json={"feature_id": 999},
        headers=headers
    )
    
    assert response.status_code == 404
    assert response.json()["detail"] == "Feature not found"

def test_vote_for_own_feature(client: TestClient):
    headers = get_auth_headers(client)
    feature_id = create_feature(client, headers)
    
    # Try to vote for own feature
    response = client.post(
        "/votes/",
        json={"feature_id": feature_id},
        headers=headers
    )
    
    assert response.status_code == 400
    assert response.json()["detail"] == "You cannot vote for your own feature"

def test_duplicate_vote(client: TestClient):
    # Create author user and feature
    author_headers = get_auth_headers(client, "author@example.com")
    feature_id = create_feature(client, author_headers)
    
    # Create voter user
    voter_headers = get_auth_headers(client, "voter@example.com")
    
    # Vote for the feature first time
    client.post(
        "/votes/",
        json={"feature_id": feature_id},
        headers=voter_headers
    )
    
    # Try to vote again
    response = client.post(
        "/votes/",
        json={"feature_id": feature_id},
        headers=voter_headers
    )
    
    assert response.status_code == 400
    assert response.json()["detail"] == "You have already voted for this feature"

def test_remove_vote_success(client: TestClient):
    # Create author user and feature
    author_headers = get_auth_headers(client, "author@example.com")
    feature_id = create_feature(client, author_headers)
    
    # Create voter user and vote
    voter_headers = get_auth_headers(client, "voter@example.com")
    client.post(
        "/votes/",
        json={"feature_id": feature_id},
        headers=voter_headers
    )
    
    # Remove vote
    response = client.delete(
        f"/votes/{feature_id}",
        headers=voter_headers
    )
    
    assert response.status_code == 200
    assert response.json()["message"] == "Vote removed successfully"

def test_remove_nonexistent_vote(client: TestClient):
    # Create author user and feature
    author_headers = get_auth_headers(client, "author@example.com")
    feature_id = create_feature(client, author_headers)
    
    # Create voter user but don't vote
    voter_headers = get_auth_headers(client, "voter@example.com")
    
    # Try to remove vote that doesn't exist
    response = client.delete(
        f"/votes/{feature_id}",
        headers=voter_headers
    )
    
    assert response.status_code == 404
    assert response.json()["detail"] == "Vote not found"

def test_feature_vote_count(client: TestClient):
    # Create author user and feature
    author_headers = get_auth_headers(client, "author@example.com")
    feature_id = create_feature(client, author_headers)
    
    # Create multiple voters
    for i in range(3):
        voter_headers = get_auth_headers(client, f"voter{i}@example.com")
        client.post(
            "/votes/",
            json={"feature_id": feature_id},
            headers=voter_headers
        )
    
    # Check feature vote count
    response = client.get(f"/features/{feature_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["vote_count"] == 3