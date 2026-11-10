# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Ensure the Python environment is ready to run the APScheduler job
RUN python -m spacy download en_core_web_sm

# Command to run the script
CMD ["python", "scheduler.py"]
