# Use the official .NET SDK image to build and publish your application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image to create a slim image for your app
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose the port that your app runs on
EXPOSE 5000

# Start the app
ENTRYPOINT ["dotnet", "YourAppName.dll"]
