FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["QuartzJob/QuartzJob.csproj", "QuartzJob/"]
RUN dotnet restore "QuartzJob/QuartzJob.csproj"
COPY . .
WORKDIR "/src/QuartzJob"
RUN dotnet build "QuartzJob.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "QuartzJob.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "QuartzJob.dll"]
