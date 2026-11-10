# Use a base image
FROM mcr.microsoft.com/dotnet/sdk:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the solution file and its contents into the container
COPY *.sln ./
COPY . .

# Restore the NuGet packages
RUN dotnet restore

# Publish the application
RUN dotnet publish -c Release -o /app/publish

# Expose the application port
EXPOSE 80

# Set the command to run the application
CMD ["dotnet", "app.dll"]
