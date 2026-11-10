# Use a base image for .NET Core
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy the project files into the container
COPY . .

# Build the project
RUN dotnet build --configuration Release

# Create a runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the runtime image
WORKDIR /app

# Copy the built application from the build-env to the runtime image
COPY --from=build-env /src/bin/Release/net6.0/publish .

# Expose the default port for the command-line tool
EXPOSE 5000

# Define the entry point for the container
ENTRYPOINT ["./your-tool.exe"]
