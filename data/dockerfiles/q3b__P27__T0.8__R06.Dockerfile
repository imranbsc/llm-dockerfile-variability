# Use the official Microsoft ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Build the application
RUN dotnet restore
RUN dotnet publish -c Release -o /app/out

# Expose the application port
EXPOSE 80

# Define environment variable
ENV ASPNETCORE_ENVIRONMENT=Production

# Run the containerized application
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
