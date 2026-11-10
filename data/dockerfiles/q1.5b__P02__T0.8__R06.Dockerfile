# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container to /usr/src/app
WORKDIR /usr/src/app

# Copy the package.json file into the container
COPY package*.json ./

# Install any needed packages specified in the package.json file
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Set the environment variable NODE_ENV to production
ENV NODE_ENV=production

# Run the Next.js build command to create the production bundle
RUN npm run build

# Expose port 3000 which is the default port for Next.js applications
EXPOSE 3000

# Run the Next.js server using the built bundle
CMD ["npm", "start"]
