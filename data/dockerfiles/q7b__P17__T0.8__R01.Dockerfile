# Use an official Go runtime as a parent image
FROM golang:1.17-alpine AS builder

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Use an official lightweight Alpine image for the runtime
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the built Go app from the builder stage
COPY --from=builder /go/src/app/main .

# Expose port 8080
EXPOSE 8080

# Run the app when the container launches
CMD ["./main"]
