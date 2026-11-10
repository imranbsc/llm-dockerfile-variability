# Use the official Node.js image as the base image
FROM node:14-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files into the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code into the container
COPY . .

# Expose the port your application listens on
EXPOSE 3000

# Start the application
CMD ["node", "index.js"]
