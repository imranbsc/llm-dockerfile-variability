# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy the package*.json file to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Set the environment variable to run the Node.js application
ENV NODE_ENV production

# Set the environment variable to run the scheduled job
ENV SCHEDULED_JOB true

# Run the scheduled job using node-cron
CMD ["node", "cron.js"]
