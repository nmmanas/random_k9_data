# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt first (if you have it)
COPY ./requirements.txt requirements.txt

# Install any necessary dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY ./app.py ./app.py

# Command to run the Flask app
CMD ["python", "app.py"]