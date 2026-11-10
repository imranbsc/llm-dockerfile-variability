# Use a base image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build
COPY . ./
RUN dotnet publish -c Release -o out

# Create a new runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0

# Set the working directory in the runtime image
WORKDIR /app

# Copy the published application from the build environment
COPY --from=build-env /app/out ./

# Expose the port the application runs on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "YourApplicationName.dll"]
