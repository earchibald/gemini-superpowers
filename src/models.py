# src/models.py
import bcrypt

class User:
    def __init__(self, username, email, password):
        self.username = username
        self.email = email
        self.password = self._hash_password(password)

    def _hash_password(self, password):
        # bcrypt.hashpw expects bytes, so encode the password
        hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
        return hashed
