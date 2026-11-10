# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container to /app
WORKDIR /app

# Copy the requirements file and install any needed packages specified in it
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Define environment variable
ENV DJANGO_SETTINGS_MODULE=myproject.settings

# Make port 80 available to the world outside this container
EXPOSE 80

# Run Django development server when the container launches
CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]
