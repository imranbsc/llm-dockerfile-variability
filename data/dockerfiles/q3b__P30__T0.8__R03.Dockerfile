# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy the current directory contents into the container at /src
COPY . .

# Build the application
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Create a non-root user
RUN useradd -r --no-create-home appuser
USER appuser

# Use the official .NET runtime as a final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build environment
COPY --from=build-env /src/out ./

# Expose the port the application runs on
EXPOSE 80

# Run the application
CMD ["dotnet", "YourApp.dll"]
