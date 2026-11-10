# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use an official .NET SDK as a parent image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["YourProjectName/YourProjectName.csproj", "YourProjectName/"]
RUN dotnet restore
COPY . .
WORKDIR "/src/YourProjectName"
RUN dotnet build "YourProjectName.csproj" -c Release -o /app/build

# Build the app for production
FROM build AS publish
RUN dotnet publish "YourProjectName.csproj" -c Release -o /app/publish

# Final stage to run the application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
