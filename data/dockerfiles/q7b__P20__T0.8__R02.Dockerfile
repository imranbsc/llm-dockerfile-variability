# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files don't change
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .

# Use a lightweight, non-root user
RUN useradd -m -u 1001 appuser && chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Expose port 8080
EXPOSE 8080

# Set environment variables
ENV CRON_SCHEDULE="0 0 * * *" # Example cron schedule: every day at midnight

# Run the application with a cron scheduler
CMD ["sh", "-c", "while true; do /usr/local/bin/cron -f -L 2 /etc/cron.d/schedule; sleep 60; done"]
