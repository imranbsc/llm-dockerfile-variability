# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files to the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Install node-cron and any other dependencies
RUN npm install node-cron

# Define environment variable
ENV CRON_EXPRESSION="* * * * *"

# Define the command to run the batch job
CMD ["node", "your_script.js"]

# Set the environment variable for the cron expression
ENV CRON_EXPRESSION="${CRON_EXPRESSION}"

# Expose the port that your application listens to
EXPOSE 3000

# Start the application
CMD ["node-cron", "--schedule", "${CRON_EXPRESSION}", "your_script.js"]
