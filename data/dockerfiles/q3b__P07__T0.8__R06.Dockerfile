# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install any needed packages specified in requirements.txt
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the application
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:80", "my_django_app.wsgi"]
