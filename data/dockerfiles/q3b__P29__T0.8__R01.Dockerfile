# Use the official .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the csproj and all necessary dependencies to the build environment
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the project files and build the executable
COPY . ./
RUN dotnet publish -c Release -o out

# Create a new runtime image
FROM mcr.microsoft.com/dotnet/runtime:6.0 AS runtime-env

# Set the working directory in the container
WORKDIR /app

# Copy the published application files from the build environment to the runtime environment
COPY --from=build-env /app/out .

# Expose the port that the application is listening on
EXPOSE 5000

# Run the application
ENTRYPOINT ["./YourApplicationName"]
