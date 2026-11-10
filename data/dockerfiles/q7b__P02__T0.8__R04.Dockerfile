# Use an official Node.js runtime as a parent image
FROM node:14 as builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Bundle app source inside Docker image
COPY . .

# Build the application for production
RUN npm run build

# Create a production server image using a smaller base image
FROM node:14-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/out .

# Define the port number for the server
EXPOSE 3000

# Command to run the server
CMD ["node", "out/server.js"]
