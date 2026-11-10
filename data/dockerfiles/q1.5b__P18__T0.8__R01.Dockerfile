# Use an official Go runtime as a parent image
FROM golang:1.16 as build

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -u -t .

# Build the application
RUN go build -o app .

# Create a new stage called "deploy"
FROM scratch

# Copy the built application from the "build" stage into the "deploy" stage
COPY --from=build /app/app .

# Set the entrypoint of the container to the built application
ENTRYPOINT ["./app"]
