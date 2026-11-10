# Use a Node.js runtime as the base image
FROM node:16

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json into the container
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the source code into the container
COPY . .

# Set the environment variable for BullMQ URL
ENV BULLMQ_URL=redis://localhost:6379

# Expose the port that the background worker listens on
EXPOSE 3000

# Start the BullMQ worker
CMD ["npm", "start"]
