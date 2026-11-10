# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set the environment variable for APScheduler
ENV APSCHEDULER_CONFIG_FILE=/app/scheduler.cfg

# Expose the port that your application listens on
EXPOSE 5000

# Define the command to run your scheduled batch job
CMD ["python", "-m", "apscheduler.schedulers.background.BackgroundScheduler", "--loglevel=info", "your_script.py"]
