# Use a base image with .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use a minimal base image for the runtime
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build environment
COPY --from=build-env /app/out .

# Expose the port the application runs on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
