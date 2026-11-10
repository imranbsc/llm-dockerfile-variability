# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container at /usr/src/app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code to the container at /usr/src/app
COPY . .

# Build the Next.js app
RUN npm run build

# Set the environment variable to use the built application
ENV NODE_ENV production

# Run the Next.js app in production mode
CMD ["npm", "start"]
