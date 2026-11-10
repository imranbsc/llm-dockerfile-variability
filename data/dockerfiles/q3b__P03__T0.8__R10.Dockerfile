# Use the official Node.js runtime as a parent image
FROM node:16-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code to the working directory
COPY . .

# Expose the port your application is running on
EXPOSE 3000

# Define environment variables (if needed)
ENV NODE_ENV=production

# Start the application
CMD ["node", "server.js"]
