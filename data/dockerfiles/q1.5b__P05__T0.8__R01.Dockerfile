# Use an official Node.js runtime as a parent image
FROM node:14-slim

# Set the working directory in the container to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container at /app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the container at /app
COPY . .

# Set the environment variable for node-cron
ENV CRON_EXPRESSION "0 0 * * *"  # Run the job every day at midnight

# Run the scheduled batch job
CMD ["node", "your-script.js"]
