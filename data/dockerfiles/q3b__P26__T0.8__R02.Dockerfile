# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy csproj and restore packages
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . .

# Build the application
RUN dotnet build -c Release -o /app

# Use a multi-stage build to create a smaller final image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime-env

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build environment
COPY --from=build-env /app .

# Expose the port that the application is listening on
EXPOSE 5001

# Run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
