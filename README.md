# Cups-Server

Platform: arm64/v8

## Portainer:

* Registry details
Provider : Custom
Name : Chris591
Registry URL : ghcr.io/chris591
Authentication : No

* Container details
Registry : Chris591
Image Name : cups-server:main
...


## Configuration

### Volumes:
* `/config`: where the persistent printer configs will be stored
* `/services`: where the Avahi service files will be generated

### Variables:
* `CUPSADMIN`: the CUPS admin user you want created
* `CUPSPASSWORD`: the password for the CUPS admin user

### Ports:
* `631`: the TCP port for CUPS must be exposed

