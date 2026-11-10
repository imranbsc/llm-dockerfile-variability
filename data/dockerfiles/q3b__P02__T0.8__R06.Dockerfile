# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files from the host to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application source code from the host to the container
COPY . .

# Build the Next.js application
RUN npm run build

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run the application
CMD ["node", "server.js"]
