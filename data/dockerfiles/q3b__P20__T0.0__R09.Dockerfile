# Use an official Go runtime as a parent image
FROM golang:1.17-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -u github.com/robfig/cron/v3

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the app
CMD ["go", "run", "main.go"]
