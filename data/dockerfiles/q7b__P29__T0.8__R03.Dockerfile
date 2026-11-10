# Use an official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use a lightweight runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/out .

# Set the command to run the application
ENTRYPOINT ["dotnet", "YourToolName.dll"]
