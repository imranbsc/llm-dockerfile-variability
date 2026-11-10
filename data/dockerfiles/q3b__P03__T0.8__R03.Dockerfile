# Use an official Node.js runtime as a parent image
FROM node:14-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container at /usr/src/app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the container at /usr/src/app
COPY . .

# Set environment variables
ENV NODE_ENV=production

# Expose the port the application will run on
EXPOSE 3000

# Define environment variable for the worker's name
ENV WORKER_NAME=background-worker

# Start the application
CMD ["node", "index.js"]
