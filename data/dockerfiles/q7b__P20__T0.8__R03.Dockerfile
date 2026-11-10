# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .

# Use an official lightweight base image
FROM alpine:latest

# Copy the built application from the builder stage
COPY --from=builder /app/main /app/main

# Set the working directory in the container
WORKDIR /app

# Set environment variables
ENV CRON_SCHEDULE="0 * * * *"  # Every hour

# Create a cron directory
RUN mkdir /etc/cron.d

# Copy the cron job configuration
COPY crontab /etc/cron.d/mycron

# Allow the cron daemon to write to /var/log/cron
RUN touch /var/log/cron

# Install cron
RUN apk update && apk add --no-cache cron

# Run the cron job
CMD ["/usr/sbin/crond", "-f", "-l", "2"]
