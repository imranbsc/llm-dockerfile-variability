# Use a base image
FROM mcr.microsoft.com/dotnet/sdk:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the source code into the container
COPY src /app/src

# Install any dependencies
RUN dotnet restore

# Build the application
RUN dotnet build

# Expose the port on which the application will run
EXPOSE 5000

# Define the entry point for the application
ENTRYPOINT ["dotnet", "YourNamespace.YourClass"]
