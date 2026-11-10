# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Expose the default port for the application
EXPOSE 3000

# Define environment variable for Redis connection
ENV REDIS_URL=redis://redis:6379

# Command to start the application
CMD ["node", "index.js"]
