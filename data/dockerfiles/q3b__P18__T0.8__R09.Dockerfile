# Use an official Go image as the base image
FROM golang:1.17-alpine as build

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files to the container
COPY go.mod go.sum .

# Install Go dependencies
RUN go mod download

# Copy the rest of your application code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 go build -o asynq-worker main.go

# Use an official Alpine image as the final image
FROM alpine:3.15

# Set the working directory in the container
WORKDIR /app

# Copy the built Go application from the build stage
COPY --from=build /app/asynq-worker .

# Expose the port that your application uses
EXPOSE 8080

# Run the application
CMD ["./asynq-worker"]
