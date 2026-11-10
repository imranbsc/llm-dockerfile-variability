# Use the official Microsoft .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the app
RUN dotnet publish -c Release -o /app/out

# Use a multi-stage build to create a smaller final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the previously built application from the build-env container
COPY --from=build-env /app/out .

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the application when the container launches
ENTRYPOINT ["dotnet", "YourAppName.dll"]
