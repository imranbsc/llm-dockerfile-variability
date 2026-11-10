# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the project source code and build the project
COPY . ./
RUN dotnet publish -c Release -o out

# Use a lightweight runtime image to host the application
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/out .

# Expose the port the application will run on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "YourApplicationName.dll"]
