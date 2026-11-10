# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files from the host to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the files from the host to the container
COPY . .

# Set the cron job in the Dockerfile
RUN echo '* * * * * npm run batch-job' > /cronjob

# Set the entrypoint for the container to run the cron job
ENTRYPOINT ["sh", "-c", "cat /cronjob && crontab /cronjob && npm run batch-job"]
