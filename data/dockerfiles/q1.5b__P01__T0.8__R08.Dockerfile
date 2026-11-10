# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /usr/src/app
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json file to the container at /usr/src/app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the container at /usr/src/app
COPY . .

# Expose the port that your application will listen on
EXPOSE 3000

# Start the application
CMD ["node", "index.js"]
