# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json into the container at /usr/src/app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of your application code into the container
COPY . .

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Define environment variable
ENV PORT 3000

# Run the app using node
CMD ["node", "app.js"]
