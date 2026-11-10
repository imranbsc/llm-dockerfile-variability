# Use an official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in requirements.txt
# RUN dotnet restore

# Copy the current directory contents into the container at /app
COPY . .

# Run the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
