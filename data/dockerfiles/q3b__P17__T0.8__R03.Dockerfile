# Use an official Go runtime as a parent image
FROM golang:1.17-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache git

# Build the Go app
RUN go build -o app main.go

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV PORT 8080

# Run the app
CMD ["./app"]
