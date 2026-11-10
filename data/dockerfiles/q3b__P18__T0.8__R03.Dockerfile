# Use an official Go runtime as a parent image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in go.mod
RUN go get -v ./...

# Expose the port the application will run on
EXPOSE 6317

# Define environment variable for database URL
ENV DATABASE_URL=postgres://username:password@host:port/database?sslmode=disable

# Make port 6317 available to the world outside this container
CMD ["./worker"]
