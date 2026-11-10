# Use an official Golang runtime as a parent image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in go.mod
RUN go get -u github.com/robfig/cron/v3

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV NAME World

# Run app.go when the container launches
CMD ["go", "run", "app.go"]
