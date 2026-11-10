# Use a base image that provides Go environment
FROM golang:1.16

# Set the working directory in the container
WORKDIR /app

# Copy the Go source files into the container
COPY . /app

# Install any necessary dependencies
RUN go get -v ./...

# Define the command to run the scheduled batch job
CMD ["go", "run", "your-go-script.go"]

# Define the environment variable for cron job schedule
ENV CRON_SCHEDULE "0 0 * * *" # Adjust as needed

# Schedule the batch job using cron
CMD ["cron", "-f", "--environment", "CRON_SCHEDULE", "/bin/bash", "-c", "go run your-go-script.go"]
