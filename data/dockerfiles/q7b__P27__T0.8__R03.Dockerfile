# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official ASP.NET Core SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["YourProjectName.csproj", "./"]
RUN dotnet restore
COPY . .
WORKDIR "/src/."
RUN dotnet build "YourProjectName.csproj" -c Release -o /app/build

# Publish the app to a temporary directory
FROM build AS publish
RUN dotnet publish "YourProjectName.csproj" -c Release -o /app/publish

# Use the base image for the final stage and copy the published app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
