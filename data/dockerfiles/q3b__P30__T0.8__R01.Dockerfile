# Use a base image with a runtime environment for .NET Core
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o out

# Run the published application
ENTRYPOINT ["dotnet", "out/YourApplication.dll"]
