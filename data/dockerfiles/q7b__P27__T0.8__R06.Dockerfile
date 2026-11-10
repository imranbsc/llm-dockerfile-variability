# Use the official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET Core SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["YourProject.csproj", "./"]
RUN dotnet restore
COPY . .
WORKDIR "/src/."
RUN dotnet build "YourProject.csproj" -c Release -o /app/build

# Publish the application to a temporary directory
FROM build AS publish
RUN dotnet publish "YourProject.csproj" -c Release -o /app/publish

# Use the base image again to create a slim image with the published application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YourProject.dll"]
