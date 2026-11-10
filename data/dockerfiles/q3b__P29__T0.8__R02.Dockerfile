# Use the official .NET runtime as the base image
FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the csproj and restore the dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build
COPY . ./
RUN dotnet publish -c Release -o /app/publish

# Expose the port your application runs on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "publish/YourAppName.dll"]
