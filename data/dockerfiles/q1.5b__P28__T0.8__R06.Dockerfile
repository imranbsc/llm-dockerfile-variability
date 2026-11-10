# Use a base image for .NET Worker Service
FROM mcr.microsoft.com/dotnet/worker:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any dependencies if necessary
RUN dotnet restore

# Publish the application
RUN dotnet publish -c Release -o /app/publish

# Expose the port the application will listen on
EXPOSE 5000

# Set the entry point
ENTRYPOINT ["dotnet", "YourWorkerName.dll", "--host-args", "--server.urls=http://0.0.0.0:5000"]
