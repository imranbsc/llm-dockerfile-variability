# Use a base image with .NET Core SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the csproj file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build the application
COPY . ./
RUN dotnet publish -c Release -o publish

# Use an official lightweight runtime as a final stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/publish .

# Expose the default ASP.NET Core port
EXPOSE 80

# Run the application
CMD ["dotnet", "run"]
