# Use an official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in the project file
RUN dotnet restore

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV ASPNETCORE_URLS http://*:80

# Run the app
CMD ["dotnet", "run"]
