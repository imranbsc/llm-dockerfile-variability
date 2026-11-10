# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code into the working directory
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NODE_ENV=production

# Start the application
CMD ["node", "index.js"]
