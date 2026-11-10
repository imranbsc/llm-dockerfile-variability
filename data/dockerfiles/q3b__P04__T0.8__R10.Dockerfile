# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your project files to the working directory
COPY . .

# Expose the default port your application uses
EXPOSE 3000

# Make port 3000 available to the world outside this container
CMD ["node", "index.js"]
