# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the project files to the container
COPY . .

# Install the .NET Worker Service runtime
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o publish

# Run the application
ENTRYPOINT ["dotnet", "publish\worker.dll"]
