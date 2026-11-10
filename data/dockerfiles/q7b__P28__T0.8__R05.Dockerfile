# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the csproj file and restore the dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining files and build the application
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build-env /app/out .

# Run the application
ENTRYPOINT ["dotnet", "YourWorkerService.dll"]
