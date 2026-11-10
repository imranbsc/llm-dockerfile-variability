# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files from the host machine to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application source code to the container
COPY . .

# Build the Next.js application
RUN npm run build

# Run the Next.js application
CMD ["node", "./build/server.js"]
