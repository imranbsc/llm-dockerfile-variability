# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the project file and restore dependencies
COPY ["MyScheduledBatchJob.csproj", "./"]
RUN dotnet restore

# Copy the rest of the project files and build
COPY . .
RUN dotnet build --no-restore

# Build the Docker image
FROM mcr.microsoft.com/dotnet/runtime:6.0
WORKDIR /app
COPY --from=build-env /app/bin/Release/net6.0/publish .

# Expose the port the batch job runs on
EXPOSE 5000

# Define environment variables
ENV QUARTZ_LOGGING_LEVEL=info
ENV QUARTZ_LOGGING_PROVIDER=Console

# Start the batch job
CMD ["dotnet", "MyScheduledBatchJob.dll"]
