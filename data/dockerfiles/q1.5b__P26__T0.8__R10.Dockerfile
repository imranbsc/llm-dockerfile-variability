# Use the official .NET SDK as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container to /app
WORKDIR /app

# Copy the csproj file to the container
COPY *.csproj ./

# Restore the NuGet packages
RUN dotnet restore

# Copy the rest of the project files to the container
COPY . ./

# Publish the API
RUN dotnet publish -c Release -o publish

# Use an official nginx image as the base image
FROM nginx:1.19.5

# Copy the published API to the nginx container
COPY --from=build-env /app/publish /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
