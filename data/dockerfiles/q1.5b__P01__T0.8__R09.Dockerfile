# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package*.json file to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the project files to the working directory
COPY . .

# Define environment variable
ENV NAME World

# Expose the default HTTP port for Node.js
EXPOSE 3000

# Run the app when the container launches
CMD ["node", "app.js"]
