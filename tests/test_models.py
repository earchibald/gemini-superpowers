# tests/test_models.py
import pytest
import bcrypt
from src.models import User # This will cause an error initially, as src.models doesn't exist yet

def test_user_creation_and_password_hashing():
    password = "securepassword"
    user = User(username="testuser", email="test@example.com", password=password)

    assert user.username == "testuser"
    assert user.email == "test@example.com"
    assert user.password is not None
    assert user.password != password # Stored password should be hashed
    assert bcrypt.checkpw(password.encode('utf-8'), user.password)

def test_user_password_verification():
    password = "securepassword"
    user = User(username="testuser", email="test@example.com", password=password)

    assert user.check_password(password)
    assert not user.check_password("wrongpassword")
