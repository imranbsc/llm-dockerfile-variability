# Use a base image with .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the csproj file into the container
COPY *.csproj .

# Restore the NuGet packages
RUN dotnet restore

# Copy the source code into the container
COPY . .

# Build the application
RUN dotnet publish -c Release -o /app/publish

# Create a new stage for the runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/publish .

# Expose the default port for the application
EXPOSE 5000

# Run the application
CMD ["dotnet", "run"]
