# Use a base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the csproj file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the source code
COPY . .

# Set the environment variable for Quartz.NET
ENV Quartz.SchedulerFactoryName="Quartz.Spi.XmlJobStore, Quartz"
ENV Quartz.Plugin.PluginDirectory="plugins"
ENV Quartz.Plugin.PluginName="Quartz.Plugins.FilePlugin"

# Create a directory for Quartz.NET plugins
RUN mkdir -p plugins

# Copy Quartz.NET plugins
COPY plugins/*.dll plugins/

# Expose the Quartz.NET port
EXPOSE 5672

# Define the entry point of the container
ENTRYPOINT ["dotnet", "YourNamespace.YourJob.dll"]
