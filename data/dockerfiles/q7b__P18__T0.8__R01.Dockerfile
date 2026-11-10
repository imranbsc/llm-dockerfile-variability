# Use an official Go runtime as a parent image
FROM golang:1.17-alpine AS builder

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files don't change.
RUN go mod download

# Copy the content of the local src directory to the working directory
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Use a smaller base image for the production environment
FROM alpine:latest

# Create a working directory in the container
WORKDIR /root/

# Copy the binary file from the builder stage
COPY --from=builder /go/src/app/main .

# Expose the port on which the app will run
EXPOSE 8080

# Run the Go app
CMD ["./main"]
