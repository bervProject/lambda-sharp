FROM mcr.microsoft.com/dotnet/sdk:6.0 as build
WORKDIR /app
COPY . .
RUN dotnet restore
RUN dotnet build -c Release --no-restore -o build

FROM public.ecr.aws/lambda/dotnet:6

WORKDIR /var/task

# This COPY command copies the .NET Lambda project's build artifacts from the host machine into the image.
# The source of the COPY should match where the .NET Lambda project publishes its build artifacts. If the Lambda function is being built
# with the AWS .NET Lambda Tooling, the `--docker-host-build-output-dir` switch controls where the .NET Lambda project
# will be built. The .NET Lambda project templates default to having `--docker-host-build-output-dir`
# set in the aws-lambda-tools-defaults.json file to "bin/Release/lambda-publish".
#
# Alternatively Docker multi-stage build could be used to build the .NET Lambda project inside the image.
# For more information on this approach checkout the project's README.md file.
COPY --from=build /app/build .

CMD [ "SimpleAPI::SimpleAPI.LambdaEntryPoint::FunctionHandlerAsync" ]
