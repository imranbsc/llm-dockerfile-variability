# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet build -c Release -o out

# Create an output directory for the Docker container
WORKDIR /app/out

# Copy the built application from the build environment to the output directory
COPY --from=build-env /app/out .

# Set the entry point for the container
ENTRYPOINT ["dotnet", "QuartzBatchJob.dll"]
