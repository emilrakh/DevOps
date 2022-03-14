FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ./KoshelekTestTask.Api/KoshelekTestTask.Api.csproj KoshelekTestTask.Api/
COPY ./KoshelekTestTask.Core/KoshelekTestTask.Core.csproj KoshelekTestTask.Core/
COPY ./KoshelekTestTask.Infrastructure/KoshelekTestTask.Infrastructure.csproj KoshelekTestTask.Infrastructure/
RUN dotnet restore "KoshelekTestTask.Api/KoshelekTestTask.Api.csproj"

# Copy everything else and build
COPY ./KoshelekTestTask.Api ./KoshelekTestTask.Api
COPY ./KoshelekTestTask.Core ./KoshelekTestTask.Core
COPY ./KoshelekTestTask.Infrastructure ./KoshelekTestTask.Infrastructure
RUN dotnet publish "KoshelekTestTask.Api/KoshelekTestTask.Api.csproj" -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine AS app
WORKDIR /app
COPY --from=build /app/out .
ENV ASPNETCORE_URLS http://*:80
ENV ASPNETCORE_ENVIRONMENT Docker
ENTRYPOINT ["dotnet", "KoshelekTestTask.Api.dll"]