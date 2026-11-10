# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files from the host to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code from the host to the container
COPY . .

# Set the environment variable for the BullMQ instance
ENV BULLMQ_URL=http://bullmq:6379

# Run the app in the background
CMD ["node", "app.js"]
