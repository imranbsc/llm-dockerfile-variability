# Use an official Go runtime as a parent image
FROM golang:1.17.6 as build-env

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in go.mod and go.sum
RUN go mod download

# Build the Go application
RUN go build -o batch_job

# Create a new stage for production
FROM scratch

# Set the working directory in the container to /app
WORKDIR /app

# Copy the built binary from the build-env stage
COPY --from=build-env /app/batch_job /app/batch_job

# Run the batch_job at startup
CMD ["./batch_job"]
