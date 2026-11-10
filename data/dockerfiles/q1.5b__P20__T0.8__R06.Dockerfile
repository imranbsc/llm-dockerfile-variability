# Use an official Go runtime as a parent image
FROM golang:1.17

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in Go.mod
RUN go mod download

# Run the cron job when the container starts
CMD ["cron", "-f"]
ENTRYPOINT ["/cron"]
