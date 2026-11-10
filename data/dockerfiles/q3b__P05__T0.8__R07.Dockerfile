# Use the official Node.js runtime as a parent image
FROM node:16-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files from the host to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code from the host to the container
COPY . .

# Expose the port the application will run on
EXPOSE 3000

# Set the default command to run when the container starts
CMD ["node", "index.js"]

# Add a cron job to run every minute
RUN echo "* * * * * node /usr/src/app/index.js" > /etc/crontabs/root

# Schedule the cron job to run
RUN crontab /etc/crontabs/root
