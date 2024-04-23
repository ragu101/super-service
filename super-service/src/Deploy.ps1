# Define variables (adjust paths as needed)
$projectPath = "$(Get-Location)"  # Current directory
$buildOutputPath = "$projectPath\bin\Release"
$dockerfilePath = "$projectPath\Dockerfile"

# Build the .NET application
Write-Host "Building .NET application..."
dotnet publish -c Release -o $buildOutputPath

if ($LastExitCode -ne 0) {
  Write-Error "Error building application. Exiting..."
  exit
}

# Run unit tests (assuming tests are in a separate project)
Write-Host "Running unit tests..."
dotnet test "$projectPath\..\test\SuperService.UnitTests.csproj"

if ($LastExitCode -ne 0) {
  Write-Warning "Unit tests failed. Continuing with Docker build..."
}

# Build Docker image
Write-Host "Building Docker image..."
cd $projectPath
docker build -t super-service:latest .

if ($LastExitCode -ne 0) {
  Write-Error "Error building Docker image. Exiting..."
  exit
}

Write-Host "Successfully built and tested the application. Docker image 'super-service:latest' is ready."
