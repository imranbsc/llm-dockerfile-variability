# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy the package*.json file to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port your application is listening on
EXPOSE 3000

# Start your application
CMD ["node", "server.js"]
