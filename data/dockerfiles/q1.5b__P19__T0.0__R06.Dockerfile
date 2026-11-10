# Use an official Go runtime as a parent image
FROM golang:1.16

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -v -t ./...

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run the app when the container launches
CMD ["go", "run", "main.go"]
