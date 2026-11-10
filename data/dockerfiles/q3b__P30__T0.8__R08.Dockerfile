# Use a base image with .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project and dependencies to the working directory
COPY . /app

# Build the project
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Use a lightweight runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application to the container
COPY --from=build-env /app/out .

# Expose the default port for Quartz.NET
EXPOSE 5000

# Set the entry point to start the application
ENTRYPOINT ["dotnet", "ScheduledBatchJob.dll"]
