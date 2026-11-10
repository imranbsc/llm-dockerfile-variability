# Use an official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5001

# Copy the project and restore dependencies
COPY . .
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o /app

# Finally, run the app
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
