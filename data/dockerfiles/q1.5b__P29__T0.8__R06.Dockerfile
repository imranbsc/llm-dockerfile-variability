# Use an official .NET SDK runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container to /app
WORKDIR /app

# Copy the csproj file to the container
COPY *.csproj ./app/

# Restore the NuGet packages
RUN dotnet restore

# Copy the rest of the project files to the container
COPY . ./app/

# Publish the application
RUN dotnet publish -c Release -o /app/publish

# Define the final image name
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container to /app
WORKDIR /app

# Copy the published application from the build-env container to the final image
COPY --from=build-env /app/publish .

# Expose the default HTTP port
EXPOSE 80

# Define the command to run the application
CMD ["dotnet", "YourApplicationName.dll"]
