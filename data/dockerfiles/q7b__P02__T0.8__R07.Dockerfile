# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Bundle app source
COPY . .

# Build the Next.js app
RUN npm run build

# Use nginx to serve the static files
FROM nginx:alpine

# Copy the Next.js build to the nginx public directory
COPY --from=0 /usr/src/app/.next /usr/share/nginx/html

# Expose the port that nginx listens on
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
