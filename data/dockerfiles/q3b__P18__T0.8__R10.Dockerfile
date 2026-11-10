# Use an official Golang image as the base image
FROM golang:1.17-alpine as builder

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the Go application source code into the container
COPY . .

# Install dependencies
RUN go get -u -v ./...

# Build the Go application
RUN CGO_ENABLED=0 go build -o asynq_worker

# Use an official Alpine image as the final image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the built Go application from the builder stage
COPY --from=builder /go/src/app/asynq_worker .

# Expose the port on which the application runs
EXPOSE 6379

# Run the application
CMD ["./asynq_worker"]
