# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Expose port 5000 for HTTP traffic
EXPOSE 5000

# Run the ASP.NET Core app
ENTRYPOINT ["dotnet", "YourNamespace.YourProject.dll"]
