# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Restore the NuGet packages
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o out

# Use a multi-stage build to create a smaller final image
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build-env container
COPY --from=build-env /app/out .

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
