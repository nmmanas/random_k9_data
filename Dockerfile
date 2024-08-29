# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt first (if you have it)
COPY requirements.txt requirements.txt

# Install any necessary dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Set a default PORT if not provided
ENV PORT 5000

# Command to run the Flask app
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:flask_app"]
