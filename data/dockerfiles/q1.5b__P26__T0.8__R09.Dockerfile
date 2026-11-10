# Use the official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/core/aspnet:7.0 AS base
WORKDIR /app
COPY . /app

# Install dependencies
RUN dotnet restore

# Build the application
RUN dotnet build --no-csc

# Publish the application
RUN dotnet publish --no-csc

# Expose the port your application listens on
EXPOSE 5000

# Set the entry point for the application
CMD ["dotnet", "YourNamespace.YourApplication.dll"]
