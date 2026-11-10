# Use a lightweight base image
FROM golang:1.19-alpine as build

# Set the working directory in the container
WORKDIR /app

# Copy the Go source code into the container
COPY . .

# Install the go-cron library
RUN go get github.com/robfig/cron/v3

# Build the Go application
RUN go build -o app

# Use a minimal base image for the final image
FROM alpine:3.16

# Set the working directory in the container
WORKDIR /app

# Copy the compiled binary from the build stage
COPY --from=build /app/app .

# Set the default command to run the application
CMD ["./app"]
