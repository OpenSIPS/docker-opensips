# OpenSIPS Docker Image
http://www.opensips.org/

Docker recipe for building and starting an OpenSIPS image from git sources

## Building the image
You can build the docker image by running:
```
make build
```

This command will build a docker image with OpenSIPS master version taken from
the git repository. To build a different git version, you can run:
```
OPENSIPS_VERSION=4754e12bb make build
```

To build with MySQL support:
```
OPENSIPS_BUILD_MODULES=db_mysql OPENSIPS_BUILD_PKGS=default-libmysqlclient-dev make build
```

To start the image, simply run:
```
make start
```

## Variables
You can set different variables to tune your deployment:
 * `OPENSIPS_VERSION` - sets the opensips git version (Default: `master`)
 * `OPENSIPS_BUILD_ARGS` - specifies the build extra arguments to be passed at build (Default: none)
 * `OPENSIPS_BUILD_PKGS` - specifies the extra packages to be installed for the build (Default: none)
 * `OPENSIPS_BUILD_MODULES` - specifies the extra modules to be included in the build (Default: none)
 * `OPENSIPS_DOCKER_TAG` - indicates the docker tag (Default: `latest`)

## Packages on DockerHub

Released docker packages are visible on DockerHub
https://hub.docker.com/r/opensips/opensips
