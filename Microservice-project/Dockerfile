# Use the base image for running the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
# Optionally define USER (can be removed if not needed)
# ARG APP_UID=1000
# USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Use SDK image for building the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
# Copy only necessary files to restore dependencies
COPY ["Microservice-project.csproj", "./"]
RUN dotnet restore "Microservice-project.csproj"
# Copy the rest of the files for building the app
COPY . .
WORKDIR "/src/"
RUN dotnet build "Microservice-project.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish "Microservice-project.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final stage: Set up runtime environment and copy published app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Microservice-project.dll"]
