# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Bundle app source inside Docker image
COPY . .

# Install node-cron for scheduling
RUN npm install node-cron

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "app.js"]
