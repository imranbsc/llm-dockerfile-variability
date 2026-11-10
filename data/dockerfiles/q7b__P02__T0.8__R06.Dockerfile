# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Bundle app source inside Docker image
COPY . .

# Build the application
RUN npm run build

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
