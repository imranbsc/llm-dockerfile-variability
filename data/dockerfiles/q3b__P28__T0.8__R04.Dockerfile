# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the application
RUN dotnet build -c Release -o /app/build

# Copy the built application from the container to the output directory
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
WORKDIR /app
COPY --from=build-env /app/build .
# Expose the default port
EXPOSE 5000
# Run the application
ENTRYPOINT ["dotnet", "YourApp.dll"]
