# Use the official ASP.NET Core runtime image as the base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official ASP.NET Core SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["YourProjectName/YourProjectName.csproj", "YourProjectName/"]
RUN dotnet restore
COPY . .
WORKDIR "/src/YourProjectName"
RUN dotnet build "YourProjectName.csproj" -c Release -o /app/build

# Publish the application to a directory that will be used in the final stage
FROM build AS publish
RUN dotnet publish "YourProjectName.csproj" -c Release -o /app/publish

# Use the base image to create a lean, production-ready container
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
