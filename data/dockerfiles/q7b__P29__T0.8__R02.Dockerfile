# Use an official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the C# project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build the application
COPY . ./
RUN dotnet publish -c Release -o out

# Create a non-root user and switch to it (optional but recommended for security)
RUN useradd -m myapp
USER myapp

# Use a smaller image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build-env /app/out .

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
