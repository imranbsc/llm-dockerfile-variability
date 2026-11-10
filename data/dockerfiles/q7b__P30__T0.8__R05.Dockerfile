# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

# Use a different stage to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["YourProject.csproj", "./"]
RUN dotnet restore
COPY . .
WORKDIR "/src/."
RUN dotnet build "YourProject.csproj" -c Release -o /app/build

# Build the Quartz.NET job
COPY . .
RUN dotnet publish "YourProject.csproj" -c Release -o /app/publish

# Publish the application
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "YourProject.dll"]
