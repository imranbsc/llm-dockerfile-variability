# Use the official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0 AS base
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in the project file
RUN dotnet restore

# Build the app
RUN dotnet build --configuration Release

# Publish the app
RUN dotnet publish --configuration Release --output publish

# Use an official ASP.NET Core runtime as a child image
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the publish output from the previous stage
COPY --from=base /app/publish .

# Expose the default HTTP port
EXPOSE 80

# Run the app
ENTRYPOINT ["dotnet", "YourNamespace.YourProject.dll"]
