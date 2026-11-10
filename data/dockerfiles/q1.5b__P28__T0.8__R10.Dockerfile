# Use the official .NET Core SDK runtime as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the solution file and restore the dependencies
COPY *.sln ./
COPY . .

# Restore the dependencies
RUN dotnet restore

# Build the solution
RUN dotnet build -c Release

# Create a directory to hold the output
RUN mkdir /app/out

# Copy the built output to the output directory
COPY --from=build-env /app/bin/Release/net6.0/*.dll /app/out

# Use the official .NET Core runtime as a child image
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Set the working directory in the container
WORKDIR /app

# Copy the runtime and the output DLL to the container
COPY --from=build-env /app/out/dotnet-worker.dll .
COPY --from=build-env /app/out/worker.exe .

# Expose the default port for the Worker Service
EXPOSE 5001

# Run the Worker Service
CMD ["worker.exe"]
