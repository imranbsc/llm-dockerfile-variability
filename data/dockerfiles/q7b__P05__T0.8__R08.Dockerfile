# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Install node-cron for scheduling tasks
RUN npm install node-cron

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define the command to run your application using node-cron
CMD ["node", "index.js"]
