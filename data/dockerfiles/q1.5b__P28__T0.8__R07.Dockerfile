# Use the official .NET Worker Service image as the base image
FROM mcr.microsoft.com/dotnet/worker:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any dependencies required by the application
RUN dotnet restore

# Set the command to run the application
ENTRYPOINT ["dotnet", "run", "--no-interactive"]
