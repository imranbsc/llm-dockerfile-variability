# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the Go module configuration files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o batchjob .

# Create a lightweight image to run the application
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the built Go application from the builder stage
COPY --from=builder /app/batchjob .

# Install cron
RUN apk add --no-cache cron

# Create a cron job file
RUN echo "* * * * * root /usr/local/bin/batchjob >> /var/log/batchjob.log 2>&1" > /etc/crontabs/root

# Expose the cron log file
VOLUME /var/log/batchjob.log

# Start the cron service
CMD ["crond", "-f", "-l", "1"]
