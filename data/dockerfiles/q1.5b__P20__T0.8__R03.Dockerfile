# Use an official Go runtime as a parent image
FROM golang:1.16 as build-env

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go mod download

# Build the Go application
RUN go build -o app .

# Create a non-root user with sudo privileges
RUN adduser -D -u 1000 app

# Copy the built application to the user's home directory
COPY --chown=app:app app /home/app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variables
ENV NAME="World"

# Run the app when the container launches
CMD ["sh", "-c", "export NAME=$NAME && go run app"]
