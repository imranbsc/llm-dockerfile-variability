# Use the latest .NET SDK as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the csproj file and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the application source code
COPY . .

# Build the application
RUN dotnet build -c Release -o out

# Use a separate runtime image for the final application
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build environment
COPY --from=build-env /app/out .

# Expose the port your application listens on
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "YourWorkerProject.dll"]
