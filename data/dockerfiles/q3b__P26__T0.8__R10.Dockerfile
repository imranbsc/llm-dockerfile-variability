# Use an official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in package.json
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o out

# Final stage for the container
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
WORKDIR /app
COPY --from=build-env /app/out .
COPY --from=build-env /app/publishing .
RUN dotnet publish -c Release -o publish

# Run the containerized application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
