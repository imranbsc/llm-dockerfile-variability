# Use a base image for .NET Core
FROM mcr.microsoft.com/dotnet/core/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the csproj file to the container
COPY *.csproj ./

# Restore the dependencies
RUN dotnet restore

# Copy the rest of the project files to the container
COPY . .

# Build the application
RUN dotnet publish -c Release -o publish

# Use a lightweight runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build-env container
COPY --from=build-env /app/publish .

# Expose the application port
EXPOSE 5000

# Run the application
CMD ["dotnet", "run"]
