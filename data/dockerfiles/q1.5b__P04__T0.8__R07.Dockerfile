# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package*.json file and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Define the command to run the application
CMD ["node", "app.js"]
