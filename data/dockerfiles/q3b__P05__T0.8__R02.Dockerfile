# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code
COPY . .

# Expose the port your application listens on
EXPOSE 3000

# Define environment variables (if any)
ENV NODE_ENV=production

# Define the command to run your application
CMD ["node", "index.js"]
