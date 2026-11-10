# Use the official .NET Worker Service as a parent image
FROM mcr.microsoft.com/dotnet/worker:6.0 as base

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Set the environment variables
ENV ASPNETCORE_ENVIRONMENT=Production

# Set the health check command to run dotnet watch
HEALTHCHECK --interval=5s --timeout=5s --command dotnet watch run

# Expose the port your service is listening on
EXPOSE 5000

# Run the worker service
CMD ["dotnet", "Run"]
