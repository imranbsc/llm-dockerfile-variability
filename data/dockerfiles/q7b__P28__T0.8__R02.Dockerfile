# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy project file and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the code and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# Run the application
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
