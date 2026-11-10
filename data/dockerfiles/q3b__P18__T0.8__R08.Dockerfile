# Use an official Go runtime as a parent image
FROM golang:1.17-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -u github.com/hibiken/asynq

# Make port 6379 available to the world outside this container
EXPOSE 6379

# Run the application as a non-root user
USER asynq

# Command to run the application
CMD ["asynq", "worker", "redis://localhost:6379/0", "app.processTask"]
