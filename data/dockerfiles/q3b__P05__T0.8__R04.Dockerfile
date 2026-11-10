# Use an official Node.js runtime as a parent image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Install node-cron
RUN npm install node-cron

# Define environment variable for CRON schedule
ENV CRON_SCHEDULE="0 0 * * *" # Example: Every day at midnight

# Define the command to run the scheduled batch job
CMD ["node", "index.js"] # Replace "index.js" with your script's name
