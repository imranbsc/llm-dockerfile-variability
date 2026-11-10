# Use the official .NET Core image as the base image
FROM mcr.microsoft.com/dotnet/aspnet:5.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the web application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
