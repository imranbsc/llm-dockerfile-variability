# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build the application
COPY . ./
RUN dotnet publish -c Release -o out

# Create a new runtime container
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build environment
COPY --from=build-env /src/out .

# Set the default command to run the application
CMD ["dotnet", "YourNamespace.YourApp.dll"]
