# Use an official Node.js runtime as a parent image
FROM node:16-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Expose the port Next.js is serving on
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start"]
