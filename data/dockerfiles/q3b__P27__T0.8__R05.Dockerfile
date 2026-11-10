# Use the official Microsoft ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV ASPNETCORE_ENVIRONMENT Development

# Build the application
RUN dotnet publish -c Release -o /app

# Run the application
ENTRYPOINT ["dotnet", "YourWebApplicationName.dll"]
