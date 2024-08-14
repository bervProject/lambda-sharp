FROM public.ecr.aws/lambda/dotnet:8 AS base

FROM mcr.microsoft.com/dotnet/sdk:8.0-bookworm-slim as build
WORKDIR /src
COPY ["SimpleAPI.csproj", "SimpleAPI/"]
RUN dotnet restore "SimpleAPI/SimpleAPI.csproj"

WORKDIR "/src/SimpleAPI"
COPY . .
RUN dotnet build "SimpleAPI.csproj" --configuration Release --output /app/build

FROM build AS publish
RUN dotnet publish "SimpleAPI.csproj" \
  --configuration Release \
  --runtime linux-x64 \
  --self-contained false \
  --output /app/publish \
  -p:PublishReadyToRun=true

FROM base AS final
WORKDIR /var/task
COPY --from=publish /app/publish .
CMD [ "SimpleAPI::SimpleAPI.LambdaEntryPoint::FunctionHandlerAsync" ]
