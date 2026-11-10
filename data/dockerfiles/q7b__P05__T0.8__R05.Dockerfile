# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Bundle app source
COPY . .

# Define the scheduled task using node-cron
ENV CRON_JOB="0 0 * * *" # This sets the cron job to run daily at midnight

# Run the cron job using bash and node-cron
CMD ["bash", "-c", "while true; do cron && node app.js; sleep 1; done"]
