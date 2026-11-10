# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the APScheduler library
COPY apscheduler /app/apscheduler

# Define the scheduled job script
COPY run_job.py /app/run_job.py

# Set the command to run your script
CMD ["python", "run_job.py"]
