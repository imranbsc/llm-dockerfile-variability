# Use an official Go runtime as a parent image
FROM golang:1.16

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the Go app
RUN go build -o app

# Run the app in the background
CMD ["./app"]
