# Use an official Go image as a base image
FROM golang:1.17

# Set the working directory in the container
WORKDIR /app

# Copy the Go code into the container
COPY . .

# Install any dependencies
RUN go mod tidy

# Build the Go binary
RUN go build -o main .

# Set the command to run the Go binary
CMD ["./main"]

# Install robfig/cron
RUN go get -u github.com/robfig/cron/v3
