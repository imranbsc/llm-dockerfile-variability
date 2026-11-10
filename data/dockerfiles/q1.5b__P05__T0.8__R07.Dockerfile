# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package*.json file and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Set the environment variable NODE_ENV to 'production'
ENV NODE_ENV=production

# Expose the port on which the application will run
EXPOSE 3000

# Define the command to run the application
CMD ["node", "index.js"]

# Schedule the batch job using node-cron
# This is a placeholder for the actual command you might use
# For example, to run the batch job every day at 10 AM, you might use:
# CMD ["node", "index.js", "--cron", "0 10 * * *"]
