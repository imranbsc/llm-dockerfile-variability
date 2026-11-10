# Use an official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Expose the default HTTP port
EXPOSE 5000

# Run the app when the container launches
CMD ["dotnet", "run"]
