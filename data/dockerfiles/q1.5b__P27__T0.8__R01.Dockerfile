# Use a stable ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in the project.json file
RUN dotnet restore

# Publish the application for production ready output
RUN dotnet publish -c Release -o publish

# Expose the application port
EXPOSE 80

# Run the application
CMD ["dotnet", "publish", "--self-contained", "true", "--output", "publish", "/p:PublishWebRootFileGroups=true", "/p:PublishWebRoot=wwwroot"]
