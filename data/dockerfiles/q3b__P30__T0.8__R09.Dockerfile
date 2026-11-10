# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /src

# Copy the current directory contents into the container at /src
COPY . .

# Build the C# application
RUN dotnet restore
RUN dotnet publish -c Release -o /app

# Use a lightweight runtime as a final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the output of the build into the final image
COPY --from=build-env /app .

# Expose the default port for Quartz.NET's scheduler
EXPOSE 5000

# Run the Quartz.NET scheduler
CMD ["dotnet", "YourApp.dll"]
