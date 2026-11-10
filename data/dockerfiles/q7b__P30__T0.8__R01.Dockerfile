# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use a different stage to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["YourProjectName.csproj", "./"]
RUN dotnet restore
COPY . .
WORKDIR "/src/."
RUN dotnet build "YourProjectName.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "YourProjectName.csproj" -c Release -o /app/publish

# Final stage to create a lightweight runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
