# Use an official Node.js runtime as a parent image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json file and install dependencies
COPY package*.json ./

RUN npm install

# Copy the rest of your application code
COPY . .

# Expose the default port for Express applications
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]
