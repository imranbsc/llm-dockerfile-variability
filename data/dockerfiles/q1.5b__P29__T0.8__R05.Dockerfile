# Use an official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet:6.0 AS base
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the app
CMD ["dotnet", "run", "--server", "kestrel", "--server.port", "80"]
