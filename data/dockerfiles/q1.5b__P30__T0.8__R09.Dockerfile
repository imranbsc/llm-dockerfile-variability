# Use a base image with .NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any dependencies specified in the project file
RUN dotnet restore

# Expose the port that the batch job will run on
EXPOSE 80

# Run the Quartz.NET batch job as a Windows service
CMD ["dotnet", " QuartzJob.dll"]
