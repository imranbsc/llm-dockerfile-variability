# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy the project file and dependencies
COPY ["YourProject.csproj", "."]
COPY ["YourProject.sln", "."]

# Restore the NuGet packages
RUN dotnet restore

# Build the application
RUN dotnet build --configuration Release

# Create a runtime container
FROM mcr.microsoft.com/dotnet/runtime:6.0 AS runtime-env

# Set the working directory in the container
WORKDIR /app

# Copy the built application from the build environment
COPY --from=build-env /src/bin/Release/net6.0/YourProject /app

# Expose the port the application listens on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "YourProject.dll"]
