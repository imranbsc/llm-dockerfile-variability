# Use an official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in the requirements.txt file
RUN dotnet restore

# Run the application
ENTRYPOINT ["dotnet", "run", "--urls", "http://localhost:5000"]
