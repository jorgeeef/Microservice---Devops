FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy .csproj file and restore dependencies
COPY ["Microservice-project.csproj", "./"]
RUN dotnet restore "Microservice-project.csproj"

# Copy the rest of the files
COPY . .

WORKDIR "/src/"
RUN dotnet build "Microservice-project.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
RUN dotnet publish "Microservice-project.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM base AS final
COPY --from=publish /app/publish . 
ENTRYPOINT ["dotnet", "Microservice-project.dll"]
