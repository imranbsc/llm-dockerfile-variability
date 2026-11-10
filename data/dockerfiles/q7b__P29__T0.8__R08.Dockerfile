# Use an official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the source code and build the application
COPY . ./
RUN dotnet publish -c Release -o out

# Use an official .NET runtime image as the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/out ./

# Expose the command-line tool
ENTRYPOINT ["dotnet", "YourToolName.dll"]
