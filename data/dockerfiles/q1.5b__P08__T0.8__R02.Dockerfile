# Use a Python runtime as the parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt ./

# Install the required packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Celery app to the container
COPY celery_app.py ./

# Set the Celery command to run in the container
CMD ["python", "celery_app.py"]
