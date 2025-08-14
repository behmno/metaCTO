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

def test_create_feature_success(client: TestClient):
    headers = get_auth_headers(client)
    
    response = client.post(
        "/features/",
        json={
            "title": "New Feature",
            "description": "A great new feature"
        },
        headers=headers
    )
    
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "New Feature"
    assert data["description"] == "A great new feature"
    assert "id" in data
    assert "author_id" in data
    assert "created_at" in data

def test_create_feature_without_auth(client: TestClient):
    response = client.post(
        "/features/",
        json={
            "title": "New Feature",
            "description": "A great new feature"
        }
    )
    
    assert response.status_code == 401

def test_create_feature_without_description(client: TestClient):
    headers = get_auth_headers(client)
    
    response = client.post(
        "/features/",
        json={
            "title": "New Feature"
        },
        headers=headers
    )
    
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "New Feature"
    assert data["description"] is None

def test_list_features(client: TestClient):
    headers = get_auth_headers(client)
    
    # Create a feature
    client.post(
        "/features/",
        json={
            "title": "Feature 1",
            "description": "First feature"
        },
        headers=headers
    )
    
    response = client.get("/features/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 1
    assert data[0]["title"] == "Feature 1"
    assert "vote_count" in data[0]

def test_get_feature_by_id(client: TestClient):
    headers = get_auth_headers(client)
    
    # Create a feature
    create_response = client.post(
        "/features/",
        json={
            "title": "Feature 1",
            "description": "First feature"
        },
        headers=headers
    )
    feature_id = create_response.json()["id"]
    
    response = client.get(f"/features/{feature_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Feature 1"
    assert data["id"] == feature_id
    assert "vote_count" in data

def test_get_nonexistent_feature(client: TestClient):
    response = client.get("/features/999")
    assert response.status_code == 404
    assert response.json()["detail"] == "Feature not found"