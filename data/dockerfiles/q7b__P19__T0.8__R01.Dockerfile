# Use an official Go runtime as a parent image
FROM golang:1.17 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o myapp

# Use a smaller image to serve the Go application
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/myapp .

# Make the application executable
RUN chmod +x myapp

# Set the command to run the application
CMD ["./myapp"]
