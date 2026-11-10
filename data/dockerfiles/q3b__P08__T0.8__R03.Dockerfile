# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install Celery
RUN pip install celery

# Create the Celery beat schedule
RUN mkdir /usr/src/app/beat_schedule

# Define environment variables for Celery (e.g., broker URL)
ENV CELERY_BROKER_URL=redis://localhost:6379/0

# Define environment variables for Celery beat (e.g., schedule filename)
ENV CELERY_BEAT_SCHEDULE=beat_schedule.yml

# Expose the default Celery port
EXPOSE 5672

# Run the Celery worker
CMD ["celery", "worker", "--loglevel=info"]
