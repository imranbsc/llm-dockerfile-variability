# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/runtime:6.0-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run the app
CMD ["dotnet", "YourAppName.dll"]
