# Use an official Golang runtime as a parent image
FROM golang:1.16

# Set the working directory in the container
WORKDIR /go/src/github.com/yourusername/yourproject

# Copy the current directory contents into the container at /go/src/github.com/yourusername/yourproject
COPY . /go/src/github.com/yourusername/yourproject

# Install any needed packages specified in go.mod
RUN go mod download

# Build the Go app. This will create an executable called "yourproject" in the current directory
RUN go build -o yourproject

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the command inside the container
CMD ["./yourproject"]
