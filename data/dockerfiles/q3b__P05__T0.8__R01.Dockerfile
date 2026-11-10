# Use the official Node.js image as the base image
FROM node:14-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files to the container
COPY . .

# Define the command to run the application
CMD ["node", "cronJob.js"]

# Define a cron job to run every minute
ENTRYPOINT ["cron", "* * * * *", "node", "cronJob.js"]
