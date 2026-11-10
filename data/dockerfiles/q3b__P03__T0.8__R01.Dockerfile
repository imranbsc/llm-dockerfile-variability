# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code into the container
COPY . .

# Expose the port your application listens on
EXPOSE 3000

# Define environment variables
ENV NODE_ENV=production

# Start the application
CMD ["node", "app.js"]
