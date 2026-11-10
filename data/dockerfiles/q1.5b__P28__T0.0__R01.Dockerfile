# Use the official .NET Worker Service template as a parent image
FROM mcr.microsoft.com/dotnet/worker:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in the project file
RUN dotnet restore

# Set the entry point for the container to run the worker service
ENTRYPOINT ["dotnet", "run", "--service-type", "Worker"]
