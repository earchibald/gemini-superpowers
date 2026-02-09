# src/app.py
from flask import Flask, request, jsonify
from src.models import User
import jwt
import datetime
import os

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'your_super_secret_key') # Consider loading from environment

# In-memory user store for demonstration. Replace with a proper database in a real application.
users_db = {}
# Create a dummy user for testing
dummy_password = "password123"
dummy_user = User(username="testuser", email="test@example.com", password=dummy_password)
users_db[dummy_user.username] = dummy_user

@app.route('/')
def home():
    return "Welcome to the authentication API!"

if __name__ == '__main__':
    app.run(debug=True)
