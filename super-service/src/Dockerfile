# Use a multi-stage build for efficiency
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-stage
WORKDIR /app

# Copy project source code
COPY . ./

# Restore dependencies

RUN dotnet restore 

# Build the application (replace "SuperService.csproj" with your actual project file)
RUN dotnet publish -c Release -o out/ SuperService.csproj

# Use a slimmer runtime image for deployment
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime-stage
WORKDIR /app

# Copy published application from build stage
COPY --from=build-stage /app/out/ .

# Expose port (adjust if your application listens on a different port)
EXPOSE 80

# Set the entrypoint to start the application
ENTRYPOINT ["dotnet", "SuperService.dll"]
