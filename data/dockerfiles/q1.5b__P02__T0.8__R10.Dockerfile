# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files into the container
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application into the container
COPY . .

# Expose the port that Next.js will run on
EXPOSE 3000

# Start the Next.js server
CMD ["npm", "start"]
