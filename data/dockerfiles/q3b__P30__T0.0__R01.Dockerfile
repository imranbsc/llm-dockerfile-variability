# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o out

# Use a multi-stage build to create a smaller final image
FROM mcr.microsoft.com/dotnet/aspnet:5.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build-env container
COPY --from=build-env /app/out .

# Expose the port the application runs on
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "YourApp.dll"]
