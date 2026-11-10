# Use an official ASP.NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the ASP.NET application for production
RUN dotnet publish -c Release -o /app/publish

# Expose the port the application runs on
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
