# Use an official Go runtime as a parent image
FROM golang:1.17 as build

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -v -t

# Build the Go app
RUN go build -o app

# Create a new container using the official Go runtime as the parent image
FROM golang:1.17 as deploy

# Set the working directory in the container
WORKDIR /app

# Copy the built Go app from the build stage into the container at /app
COPY --from=build /app/app .

# Define environment variables
ENV NAME World

# Expose the port the Go app is listening on
EXPOSE 8080

# Run the Go app when the container launches
CMD ["./app"]
