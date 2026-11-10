# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5672 available to the world outside this container
EXPOSE 5672

# Define environment variable
ENV CELERY_BROKER_URL=redis://redis:6379/0

# Run the command to start the Celery worker
CMD ["celery", "worker", "--app=your_app_name", "--loglevel=info"]
