# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files from the host to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code from the host to the container
COPY . .

# Build the Next.js application
RUN npm run build

# Expose the port the application will listen on
EXPOSE 3000

# Run the Next.js application
CMD ["npm", "start"]
