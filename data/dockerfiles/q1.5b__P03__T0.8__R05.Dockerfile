# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container at /usr/src/app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the container at /usr/src/app
COPY . .

# Expose the port used by BullMQ
EXPOSE 5672

# Define the command to run the background worker
CMD ["node", "worker.js"]
