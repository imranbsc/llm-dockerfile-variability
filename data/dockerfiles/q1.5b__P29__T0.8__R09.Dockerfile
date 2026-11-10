# Use a base image with .NET Core SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory in the container
WORKDIR /src

# Copy the code from the current directory into the container at /src
COPY . /src

# Restore the NuGet packages
RUN dotnet restore

# Build the application
RUN dotnet build --configuration Release

# Publish the application
RUN dotnet publish -c Release --no-self-contained

# Create a new layer for the runtime
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build layer
COPY --from=build /src/bin/Release/net6.0/publish ./

# Expose the default HTTP port
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
