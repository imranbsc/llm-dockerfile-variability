# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5672 available to the world outside this container
EXPOSE 5672

# Define environment variable
ENV CELERY_BROKER_URL=redis://redis:6379/0

# Define environment variable
ENV CELERY_RESULT_BACKEND=postgresql://user:password@db:5432/celerydb

# Define environment variable
ENV CELERY_BEAT_SCHEDULE_FILENAME=/usr/src/app/celery_beat_schedule.json

# Set the default command to run the Celery worker
CMD ["celery", "worker", "-A", "worker_app", "--loglevel=info"]
