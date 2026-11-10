# Use an official Go runtime as a parent image
FROM golang:1.21.5-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go mod download

# Build the Go app
RUN CGO_ENABLED=0 go build -o app main.go

# Use an official lightweight runtime as a parent image
FROM alpine:3.17

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the builder stage to the new image
COPY --from=builder /app/app .

# Expose the default port for Gin
EXPOSE 8080

# Define environment variable
ENV PORT=8080

# Run the app
CMD ["./app"]
