# Use the official Microsoft .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in requirements.txt
RUN dotnet restore

# Build the app
RUN dotnet build -c Release -o /app/out

# Copy the output of the build to the root directory
COPY --from=build /app/out .

# Expose the port the app runs on
EXPOSE 5000

# Run the app
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
