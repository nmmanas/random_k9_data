import os

# Bind to the port provided by Docker Compose or fallback to 5000
bind = f"0.0.0.0:{os.getenv('PORT', '5000')}"

# Number of worker processes
workers = 2
