# Use an official Node.js runtime as a parent image
FROM node:14-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json file to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run the command when the container launches
CMD ["node", "app.js"]
