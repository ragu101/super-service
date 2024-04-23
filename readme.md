# Instructions to follow to test the solution
## Pre-requisites 
1. Docker Desktop or Docker Engine running on your machine 
2. Install .NET framework 3.1.0 on your machine 
    https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-3.1.100-windows-x64-installer

## Run powershell script `Deploy.ps1` to compile, test & build docker image
```
cd super-service\src
pwsh Deploy.ps1
 (or)
./Deploy.ps1
```
Following is the expected output
![output](images/build.png)

## Vulnerability details in the image 
if `docker scout` installed on your system, you can check the vulnerabilities by running below command
```
docker scout cves super-service:latest
```
The main image has 1 Critical, 3 High, 2 Medium & 25 Low vulnerabilities 
![vunerability](images/docker-image-vulnerability.png)

## Cloud Design overview
![design](./images/axi.png)

### Design description:
1. web-app & internal-asset are deployed into two different virtual networks, web-app especially deployed onto `Azure Kubernetes service`.
2. web-app is securely exposed to internet through `Azure Application Gateway` & `Web Application Firewall`.
3. web-app can access internal-asset through `Azure Private link` (or through `Express route` or `vnet peering`) configuration without traffic being routed through internet.
4. `Azure monitor` service can provide metrics, logs, and alerts for monitoring network traffic, bandwidth usage, latency, and availability of Private Link endpoints and ExpressRoute circuits. We can use this to alert the respective teams that depend on web-app endpoint.
5. Office network is connected to Azure cloud using `Azure VPN Gateway`, through which developer can access azure devops components such as `azure repos & azure pipelines`.
6. Office network traffic to azure devops should be whitelisted through a `proxy server` otherwise a potential code leak is possible if access token or ssh key is compromised.
7. Both vnets can be configured in `azure devops pipeline`, so that developer can build & deploy automatically.