# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o /app/publish

# Run the application
ENTRYPOINT ["dotnet", "WorkerServiceApp.dll"]
