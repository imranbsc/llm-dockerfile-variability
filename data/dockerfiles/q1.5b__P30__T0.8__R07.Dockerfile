# Use a base image for .NET Core
FROM mcr.microsoft.com/dotnet/core/runtime:6.0 AS base
WORKDIR /app
COPY ./bin/Release/net6.0 ./bin/Release/net6.0

# Use a base image for scheduling
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0 AS build
WORKDIR /app
COPY ./ ./app
RUN dotnet restore
COPY --from=base /app .
RUN dotnet build -c Release -o /app/build

# Use a base image for the scheduled job
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .
COPY ./bin/Release/net6.0/*.dll .
COPY ./bin/Release/net6.0/*.exe .

# Copy the Quartz.NET scheduler configuration file
COPY quartz.config /app/quartz.config

# Run the Quartz.NET scheduler
CMD ["dotnet", "Quartz.SchedulerHost", "-config", "quartz.config", "-logto", "console"]
