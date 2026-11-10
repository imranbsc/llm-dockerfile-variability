# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy the package*.json file into the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the code into the container
COPY . .

# Expose the port that your BullMQ worker will listen on
EXPOSE 3000

# Start the BullMQ worker
CMD ["node", "worker.js"]
