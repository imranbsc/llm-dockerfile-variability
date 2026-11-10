# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use a non-root user for the app to enhance security
RUN useradd -m myappuser
USER myappuser

# Switch to a minimal .NET runtime image for production
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build-env /app/out .

# Run the app
ENTRYPOINT ["dotnet", "YourAppName.dll"]
