# Use an official Node.js runtime as a parent image
FROM node:16-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code into the container
COPY . .

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Define environment variable
ENV NODE_ENV=production

# Run the app
CMD ["node", "your-main-file.js"]
