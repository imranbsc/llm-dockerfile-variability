# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Expose the port the application runs on
EXPOSE 80

# Define environment variable
ENV ASPNETCORE_ENVIRONMENT Production

# Run the app
ENTRYPOINT ["dotnet", "yourapp.dll"]
