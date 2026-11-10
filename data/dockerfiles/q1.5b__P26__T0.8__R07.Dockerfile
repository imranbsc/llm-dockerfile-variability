# Use the official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Expose the default ASP.NET Core port
EXPOSE 5000

# Run the app when the container launches
CMD ["dotnet", "YourWebApplication.dll"]
