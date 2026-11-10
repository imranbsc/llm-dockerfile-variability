# Use an official Node.js runtime as a parent image
FROM node:16

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files from the host to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code from the host to the container
COPY . .

# Build the application
RUN npm run build

# Expose the port that Next.js uses for serving
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
