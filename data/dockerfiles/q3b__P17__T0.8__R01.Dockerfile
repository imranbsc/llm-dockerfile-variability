# Use an official Go image
FROM golang:1.17 AS builder

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go mod download

# Build the Go app
RUN go build -o app

# Use an official Nginx image
FROM nginx:latest

# Copy the pre-built Go app into the container at /usr/share/nginx/html
COPY --from=builder /app/app /usr/share/nginx/html

# Set environment variables
ENV SERVER_PORT 8080

# Expose the port the server will listen on
EXPOSE 8080

# Run the server
CMD ["nginx", "-g", "daemon off;"]
