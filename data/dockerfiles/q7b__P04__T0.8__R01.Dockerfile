# Use an official Node.js runtime as a parent image
FROM node:14 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Bundle app source inside Docker image
COPY . .

# Build the application (if needed)
# RUN npm run build

# Switch to a non-root user
USER node

# Define environment variable
ENV NODE_ENV=production

# Expose the port the app runs on
EXPOSE 3000

# Command to run the app
CMD ["node", "index.js"]
