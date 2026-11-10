# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package*.json file into the container at /usr/src/app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code into the container at /usr/src/app
COPY . .

# Expose the port that your application is listening on
EXPOSE 3000

# Define the command to run when the container launches
CMD ["node", "server.js"]
