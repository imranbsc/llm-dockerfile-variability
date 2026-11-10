# Use an official Go runtime as a parent image
FROM golang:1.17 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the Go module and vendor files
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the application
RUN go build -o main .

# Use a lightweight image for the final stage
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root

# Copy the built Go binary from the builder stage
COPY --from=builder /app/main .

# Set the environment variable to enable the cron job
ENV CRON_SCHEDULE="* * * * *"  # This sets the cron schedule, change it as needed

# Install cron
RUN apk add --no-cache cron

# Create a cron job file
RUN echo "* * * * * /root/main >> /root/cron.log 2>&1" > /etc/cron.d/mycron

# Allow root to run cron
RUN chmod 0644 /etc/cron.d/mycron && \
    cron

# Expose the log file if needed
VOLUME /root/cron.log

# Start cron
CMD ["/usr/sbin/cron", "-f"]
