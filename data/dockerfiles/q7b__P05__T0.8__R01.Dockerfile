# Use an official Node.js runtime as a parent image
FROM node:14-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if any) to the working directory
COPY package*.json ./

# Install production dependencies
RUN npm install --only=production

# Bundle app source code
COPY . .

# Use a smaller image for the production environment
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies from the builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy the rest of the application code
COPY --from=builder /app ./

# Expose the port that your application runs on
EXPOSE 8080

# Command to run your application
CMD ["node", "your-entry-script.js"]
