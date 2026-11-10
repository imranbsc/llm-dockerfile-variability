# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files into the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code into the container
COPY . .

# Create a BullMQ queue connection
ENV REDIS_URL=redis://redis

# Command to run the background worker
CMD ["node", "worker.js"]
