# Use an official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the solution file to the container
COPY *.sln ./

# Restore the dependencies
RUN dotnet restore

# Copy the source code to the container
COPY . .

# Build the application
RUN dotnet publish -c Release -o /app

# Use an official Node.js runtime as a parent image
FROM node:14 AS runtime

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build-env stage
COPY --from=build-env /app ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the built application to the runtime stage
COPY --from=build-env /app .

# Run the application
CMD ["npm", "start"]
