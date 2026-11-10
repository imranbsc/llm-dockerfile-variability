# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy the current directory contents into the container at /src
COPY . .

# Restore any dependencies specified in your project file
RUN dotnet restore

# Build the application
RUN dotnet build --output ../output

# Use a runtime environment based on the official .NET runtime
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the built output from the build-env container
COPY --from=build-env /src/output .

# Expose the port on which your application will run
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "YourApp.dll"]
