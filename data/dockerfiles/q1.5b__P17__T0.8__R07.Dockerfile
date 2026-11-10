# Use an official Go runtime as a parent image
FROM golang:1.17 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN go mod download

# Build the server-rendered web application
RUN go build -o server-rendered-app

# Create a new stage for the final image
FROM scratch

# Copy the built server-rendered web application from the builder stage
COPY --from=builder /app/server-rendered-app /app/server-rendered-app

# Set the environment variable for the application port
ENV PORT=8080

# Expose the application port
EXPOSE $PORT

# Run the server-rendered web application
CMD ["./server-rendered-app"]
