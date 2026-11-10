# Use a base image with .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy the project files and restore dependencies
COPY . .

# Build the project
RUN dotnet build -c Release -o /app

# Use a minimal base image for the runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0-slim

# Set the working directory in the runtime container
WORKDIR /app

# Copy the output from the build container to the runtime container
COPY --from=build-env /app .

# Expose the port that the service is running on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "YourWorkerService.dll"]
