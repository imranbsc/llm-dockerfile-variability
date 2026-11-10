# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container at /usr/src/app
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application code to the container
COPY . .

# Expose the default port for your application
EXPOSE 3000

# Define environment variables
ENV NODE_ENV=production

# Define a command to run your application
CMD ["node", "index.js"]

# Define a job to run periodically using node-cron
SHELL ["crontab", "-l"]
RUN (echo "0 0 * * *" && # Run this job at midnight every day
     echo "*/5 * * * *" && # Run this job every 5 minutes
     echo "*/10 * * * *") | # Run this job every 10 minutes
RUN crontab -

# Define a startup script to start node-cron
ENTRYPOINT ["node-cron", "start"]
