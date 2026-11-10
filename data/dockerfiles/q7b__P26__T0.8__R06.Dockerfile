# Use the official .NET SDK image from Microsoft as the parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy all files and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the project files and build the project
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image from Microsoft as the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/out .

# Expose the port the app runs on
EXPOSE 80

# Run the application when the container launches
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
