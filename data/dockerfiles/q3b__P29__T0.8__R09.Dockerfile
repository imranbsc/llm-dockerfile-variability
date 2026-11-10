# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy the project file and dependencies
COPY *.csproj .
COPY ./tools/*.csproj ./tools/
COPY ./properties/*.csproj ./properties/

# Restore all dependencies
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o out

# Use a multi-stage build to create a smaller final image
FROM mcr.microsoft.com/dotnet/runtime:5.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build-env container
COPY --from=build-env /src/out .

# Expose the port that your application listens on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "YourToolName.dll"]
