# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Set the command to run the scheduled batch job
CMD ["node", "index.js"]

# Expose the port that the Node.js application will listen on
EXPOSE 3000

# Create a scheduled batch job using node-cron
RUN npm install -g node-cron

# Create a scheduled batch job file
RUN echo "*/5 * * * * * node index.js" > scheduledJob.js

# Set the permissions for the scheduled job file
RUN chmod +x scheduledJob.js

# Expose the port that the node-cron process will listen on
EXPOSE 3001
