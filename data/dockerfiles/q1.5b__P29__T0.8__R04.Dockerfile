# Use an official .NET SDK runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Restore any dependencies in the project
RUN dotnet restore

# Publish the application to a folder named "publish"
RUN dotnet publish -c Release -o publish

# Build the Docker image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime-env

# Set the working directory in the container to /app
WORKDIR /app

# Copy the published application from the build-env stage
COPY --from=build-env /app/publish .

# Expose the application port
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "MyCommandLineTool.dll"]
