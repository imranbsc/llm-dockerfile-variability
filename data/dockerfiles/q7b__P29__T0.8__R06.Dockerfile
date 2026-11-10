# Use an official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build the project
COPY . ./
RUN dotnet publish -c Release -o out

# Use a smaller, non-sdk base image to create the final container
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/out ./

# Make the application executable
RUN chmod +x MyCommandLineTool

# Set the entry point to run the application
ENTRYPOINT ["./MyCommandLineTool"]
