# Use a official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

# Set the working directory in the container
WORKDIR /app

# Copy the csproj file into the container
COPY *.csproj ./

# Restore the NuGet packages
RUN dotnet restore

# Copy the rest of the application into the container
COPY . .

# Use the official ASP.NET Core SDK as a build image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the csproj file into the container
COPY *.csproj ./

# Restore the NuGet packages
RUN dotnet restore

# Copy the rest of the application into the container
COPY . .

# Build the application
RUN dotnet build -c Release -o /app

# Use an official nginx image as a base image
FROM nginx:latest

# Copy the built application into the nginx server
COPY /app /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
