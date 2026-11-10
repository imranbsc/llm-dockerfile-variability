# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 5001 available to the world outside this container
EXPOSE 5001

# Run the application
ENTRYPOINT ["dotnet", "YourWorkerServiceName.dll"]
