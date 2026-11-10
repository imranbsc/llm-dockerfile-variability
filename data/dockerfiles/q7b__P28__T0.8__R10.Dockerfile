# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the csproj file and restore any dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image for the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app

# Copy the published app from the build-env stage
COPY --from=build-env /app/out .

# Set the command to run the worker
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
