# Use an official Node.js runtime as a parent image
FROM node:14-slim

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code to the working directory
COPY . .

# Expose the port your application listens to
EXPOSE 3000

# Command to run the application
CMD ["node", "app.js"]
