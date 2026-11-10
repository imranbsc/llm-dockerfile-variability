# Use the official Golang image as the base image
FROM golang:1.16-alpine AS build-env

# Set the working directory in the container
WORKDIR /go/src/github.com/yourusername/yourtool

# Copy the go.mod and go.sum files to the container
COPY go.mod go.sum .

# Download all dependencies specified in go.mod
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 go build -o yourtool

# Use the official Alpine image as the final image
FROM alpine:3.12

# Copy the binary from the build-env to the final image
COPY --from=build-env /go/src/github.com/yourusername/yourtool/yourtool /usr/local/bin/yourtool

# Set the default command to run when the container starts
CMD ["yourtool"]
