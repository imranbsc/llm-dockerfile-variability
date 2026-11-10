# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /usr/src/app
WORKDIR /usr/src/app

# Copy the package.json file to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the code to the working directory
COPY . .

# Define environment variable
ENV PORT 3000

# Define the command to run the app
CMD ["npm", "start"]

# Expose the port that the app is running on
EXPOSE 3000
