# Use the official Golang image as the base image
FROM golang:1.17

# Set the working directory in the container
WORKDIR /app

# Copy the Go source code into the container
COPY . .

# Install any required packages specified in the Gopkg.toml file
RUN go get -v -u ./...

# Build the Go application
RUN go build -o app .

# Set the environment variable to specify the application name
ENV APP_NAME=my-cli-app

# Expose the application port
EXPOSE 8080

# Define the command to run the application
CMD ["./app"]
