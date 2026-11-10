# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining project files and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image as the base image for the production environment
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build environment
COPY --from=build-env /app/out .

# Expose port 80 for HTTP traffic
EXPOSE 80

# Define the command to run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
