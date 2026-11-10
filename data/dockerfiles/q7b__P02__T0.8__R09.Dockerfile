# Use an official Node.js runtime as a parent image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files first
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Bundle app source inside Docker image
COPY . .

# Build the app for production
RUN npm run build

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Command to run the app
CMD ["npm", "start"]
