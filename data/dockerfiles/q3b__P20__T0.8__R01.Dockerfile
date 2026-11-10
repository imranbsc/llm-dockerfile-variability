# Use a base Go image
FROM golang:1.17-alpine as builder

# Set the working directory
WORKDIR /app

# Copy the Go application code
COPY . .

# Install the dependencies
RUN go get -v -d ./...

# Build the application
RUN CGO_ENABLED=0 go build -o app .

# Use a minimal runtime image
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/app .

# Expose the port the application listens on
EXPOSE 8080

# Run the application
CMD ["./app"]
