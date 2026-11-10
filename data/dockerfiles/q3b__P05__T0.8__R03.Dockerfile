# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code into the container
COPY . .

# Install any needed packages specified in package.json
RUN npm install

# Expose the default port your application runs on
EXPOSE 3000

# Define environment variables if needed
ENV NODE_ENV=production

# Start the application using the command specified in package.json
CMD ["node", "app.js"]
