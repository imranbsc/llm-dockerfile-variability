# Use a base image with .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore the necessary dependencies
COPY . .

# Build the project
RUN dotnet build --configuration Release

# Use a base image with .NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the output from the build environment
COPY --from=build-env /app/bin/Release/net6.0/publish .

# Run the application
ENTRYPOINT ["dotnet", "MyWorkerService.dll"]
