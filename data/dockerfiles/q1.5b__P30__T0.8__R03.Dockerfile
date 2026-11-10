# Use a base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the csproj file
COPY *.csproj .

# Restore the NuGet packages
RUN dotnet restore

# Copy the rest of the project files
COPY . .

# Add the Quartz.NET package
RUN dotnet add package Quartz

# Set the environment variable for Quartz.NET configuration
ENV QUARTZ_JOBSTORE_TYPE=Memory

# Set the Quartz.NET job data
ENV QUARTZ_JOB_DATA_FORMAT=JSON

# Create a scheduled task in Quartz.NET
RUN dotnet add Quartz job --name "MyJob" --type MyNamespace.MyJob --config MyJob.config

# Expose the Quartz.NET scheduler
EXPOSE 5000

# Run the scheduled batch job
CMD ["dotnet", "QuartzScheduler.dll"]
