# Use a .NET SDK as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the source code
COPY . .

# Build the application
RUN dotnet publish -c Release -o out

# Use a minimal .NET runtime image for the final container
FROM mcr.microsoft.com/dotnet/runtime:6.0 AS final

# Set the working directory in the container
WORKDIR /app

# Copy the output from the build-env image
COPY --from=build-env /app/out .

# Expose the port the application runs on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
