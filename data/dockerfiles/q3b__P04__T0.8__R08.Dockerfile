# Use an official Node.js runtime as a parent image
FROM node:14-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application code to the container
COPY . .

# Expose the port your application runs on
EXPOSE 3000

# Define environment variables (if any)
ENV NODE_ENV=production

# Command to run the application
CMD ["node", "app.js"]
