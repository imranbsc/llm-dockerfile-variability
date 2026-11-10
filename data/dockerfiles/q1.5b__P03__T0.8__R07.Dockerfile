# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package*.json file from the current directory to the working directory in the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the files from the current directory to the working directory in the container
COPY . .

# Define the environment variable for BullMQ
ENV QUEUE_URL=http://localhost:6379

# Define the environment variable for BullMQ connection string
ENV QUEUE_URL_STR=redis://localhost:6379/0

# Run the app
CMD ["node", "worker.js"]
