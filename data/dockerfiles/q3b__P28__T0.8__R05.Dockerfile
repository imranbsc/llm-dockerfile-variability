# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# Set the working directory
WORKDIR /app

# Copy the project file and restore packages
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application source code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime

# Set the working directory
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/out .

# Expose the port your application runs on
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "WorkerServiceApplication.dll"]
