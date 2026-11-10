# Use an official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sSL https://dotnet.microsoft.com/sdk/dotnet-install-script | dotnet-install.sh --channel 5.0 && \
    dotnet restore

# Build the application
RUN dotnet build --no-restore

# Run the application
ENTRYPOINT ["dotnet", "your-project-name.dll"]
