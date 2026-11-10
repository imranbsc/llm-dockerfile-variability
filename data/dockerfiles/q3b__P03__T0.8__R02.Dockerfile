# Use an official Node.js runtime as a parent image
FROM node:16

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Make port 6379 available to the world outside this container
EXPOSE 6379

# Define environment variable
ENV REDIS_HOST=localhost

# Start the application
CMD ["node", "worker.js"]
