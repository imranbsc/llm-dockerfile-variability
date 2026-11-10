# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package*.json file and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Build the Next.js app
RUN npm run build

# Expose the port that Next.js will run on
EXPOSE 3000

# Start the Next.js server
CMD ["npm", "start"]
