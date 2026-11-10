# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the next.js project files to the working directory
COPY . .

# Build the Next.js app
RUN npm run build

# Define the environment variable for the Next.js build directory
ENV NEXT_BUILD_DIR=/app/.next/build

# Serve the Next.js app in the container
EXPOSE 3000

# Run the Next.js app
CMD ["npm", "start"]
