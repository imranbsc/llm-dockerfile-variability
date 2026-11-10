# Use an official .NET SDK as a parent image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use a smaller, non-debug image to host the app
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "YourToolName.dll"]
