# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json file into the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Expose the port that the command-line tool listens on
EXPOSE 3000

# Define environment variable
ENV NAME World

# Run the command to start the command-line tool
CMD ["node", "app.js"]
