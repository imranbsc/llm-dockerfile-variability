# Use the official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /src

# Copy the csproj and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build it
COPY . ./
RUN dotnet publish -c Release -o out

# Use a multi-stage build to create a smaller final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /src/out .
ENTRYPOINT ["dotnet", "YourAppName.dll"]
