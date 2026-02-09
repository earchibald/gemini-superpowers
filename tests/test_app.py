# tests/test_app.py
import pytest
from src.app import app, users_db, dummy_user
from src.models import User

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_login_success(client):
    response = client.post('/login', json={
        'username': 'testuser',
        'password': 'password123'
    })
    assert response.status_code == 200
    assert 'access_token' in response.json

def test_login_failure_wrong_password(client):
    response = client.post('/login', json={
        'username': 'testuser',
        'password': 'wrongpassword'
    })
    assert response.status_code == 401
    assert 'message' in response.json
    assert response.json['message'] == 'Invalid credentials'

def test_login_failure_user_not_found(client):
    response = client.post('/login', json={
        'username': 'nonexistentuser',
        'password': 'password123'
    })
    assert response.status_code == 401
    assert 'message' in response.json
    assert response.json['message'] == 'Invalid credentials'
