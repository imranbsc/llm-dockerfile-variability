# Use the official Microsoft .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o /app/out

# Expose the port the application runs on
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "/app/out/YourWorkerApp.dll"]
