# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy the package.json and package-lock.json files from the current directory to the /app directory in the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the files from the current directory to the /app directory in the container
COPY . .

# Set the environment variable for the BullMQ queue name
ENV BULLMQ_QUEUE=myQueue

# Define the command to run the background worker
CMD ["node", "worker.js"]
