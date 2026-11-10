# Use an official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory inside the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the entire project source code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Use a smaller .NET runtime image as the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory inside the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/out .

# Make the application executable
ENTRYPOINT ["dotnet", "YourAppName.dll"]
