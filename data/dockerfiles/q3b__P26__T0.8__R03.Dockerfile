# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o out

# Use the official runtime image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Copy the output of the build process from the build-env container
COPY --from=build-env /app/out .

# Expose the port that the application runs on
EXPOSE 80

# Run the app
ENTRYPOINT ["dotnet", "YourAppName.dll"]
