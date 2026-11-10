# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project and build it
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image as the base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory
WORKDIR /app

# Copy the published application from the build environment
COPY --from=build-env /app/out .

# Expose the port on which the application will run
EXPOSE 80

# Set the command to run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
