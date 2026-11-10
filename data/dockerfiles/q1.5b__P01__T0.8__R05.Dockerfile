# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container at /usr/src/app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest API code to the container at /usr/src/app
COPY . .

# Expose the default port for your REST API
EXPOSE 3000

# Define the command to run the REST API
CMD ["npm", "start"]
