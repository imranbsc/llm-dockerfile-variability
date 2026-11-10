# Use an official Go runtime as a parent image
FROM golang:1.19

# Set the working directory in the container
WORKDIR /app

# Copy the Go application source code into the container
COPY . /app

# Install the robfig/cron package
RUN go get github.com/robfig/cron/v3

# Install dependencies
RUN go mod download

# Expose the port where the application will listen
EXPOSE 8080

# Define the command to run the batch job
CMD ["go", "run", "main.go"]
