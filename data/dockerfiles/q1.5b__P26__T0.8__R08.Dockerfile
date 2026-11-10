# Use the official Microsoft .NET Core SDK as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container to /app
WORKDIR /app

# Copy the csproj file to the container
COPY *.csproj ./app/

# Restore the NuGet packages
RUN dotnet restore

# Copy the rest of the project files to the container
COPY . ./

# Publish the application to a directory called publish
RUN dotnet publish -c Release -o publish

# Use an official ASP.NET Core runtime as the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container to /app
WORKDIR /app

# Copy the publish output from the build-env stage to the runtime stage
COPY --from=build-env /app/publish .

# Expose the default ASP.NET Core port
EXPOSE 80

# Run the ASP.NET Core application
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
