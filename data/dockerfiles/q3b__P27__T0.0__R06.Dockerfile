# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet build --configuration Release

# Run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
