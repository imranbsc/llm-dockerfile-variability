# Use the official .NET SDK image as the parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the csproj file and restore the dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build the app
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image as the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Copy the published app from the build-env stage
COPY --from=build-env /app/out .

# Command to run the application
ENTRYPOINT ["dotnet", "YourWorkerService.dll"]
