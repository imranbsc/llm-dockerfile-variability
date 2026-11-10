# Use an official Go runtime as a parent image
FROM golang:1.16 as build-env

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go mod download

# Build the Go application
RUN go build -o app .

# Create a new container from the official Node.js runtime image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy the build artifacts from the previous stage to the container at /app
COPY --from=build-env /app/app .

# Install any dependencies listed in package.json
RUN npm install

# Build the application using npm
RUN npm run build

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["node", "dist/app.js"]
