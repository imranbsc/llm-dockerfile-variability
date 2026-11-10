# Use an official .NET SDK runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use an official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# Install Quartz.NET
RUN dotnet add package Quartz
RUN dotnet add package Quartz.Extensions.Hosting

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
