# Use the official ASP.NET core runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["dotnet-jenkins-v2.csproj", "./"]
RUN dotnet restore "dotnet-jenkins-v2.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "dotnet-jenkins-v2.csproj" -c Release -o /app/build

# Publish the app to the /app/publish directory
FROM build AS publish
RUN dotnet publish "dotnet-jenkins-v2.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Use the base image to run the app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-jenkins-v2.dll"]