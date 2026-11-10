# Use a official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
COPY ./WorkerService /app

# Set the entrypoint for the container
ENTRYPOINT ["dotnet", "WorkerService.dll"]
