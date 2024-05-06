FROM mcr.microsoft.com/dotnet/aspnet:8.0-nanoserver-1809 AS base
WORKDIR /app
EXPOSE 5276

ENV ASPNETCORE_URLS=http://+:5276

FROM mcr.microsoft.com/dotnet/sdk:8.0-nanoserver-1809 AS build
ARG configuration=Release
WORKDIR /src
COPY ["HelloWorldApp.web/HelloWorldApp.web.csproj", "HelloWorldApp.web/"]
RUN dotnet restore "HelloWorldApp.web\HelloWorldApp.web.csproj"
COPY . .
WORKDIR "/src/HelloWorldApp.web"
RUN dotnet build "HelloWorldApp.web.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "HelloWorldApp.web.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloWorldApp.web.dll"]
