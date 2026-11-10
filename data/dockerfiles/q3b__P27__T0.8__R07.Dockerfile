# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the ASP.NET application for production
RUN dotnet publish -c Release -o out

# Copy the published application from the container to the output directory
WORKDIR /app/out

# Expose the port the application is running on
EXPOSE 80

# Run the application
CMD ["dotnet", "YourAppName.dll"]
