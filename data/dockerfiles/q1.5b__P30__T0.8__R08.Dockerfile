# Use a stable base image
FROM microsoft/dotnet:6.0-runtime AS base

# Set the working directory in the container
WORKDIR /app

# Copy the solution file into the container
COPY *.sln ./

# Restore the dependencies
RUN dotnet restore

# Copy the project and its dependencies to the container
COPY . .

# Set environment variables
ENV Quartz.QS_LOGGING_LEVEL=INFO

# Expose the Quartz.NET scheduler service
EXPOSE 8080

# Run the Quartz.NET scheduler service
CMD ["dotnet", "Quartz.SchedulerHost", "--config-file", "Quartz.config"]
