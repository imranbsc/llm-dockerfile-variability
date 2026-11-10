# Use the official .NET runtime image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o out

# Use a minimal runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-slim

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build-env container
COPY --from=build-env /app/out .

# Expose the port the application runs on
EXPOSE 5000

# Run the application
CMD ["dotnet", "your-app-name.dll"]
