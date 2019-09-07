# Quarkus Maven Repo Cachier

A data container image that caches maven artifacts that are used in [Quarkus Tutorial](https://github.com/redhat-developer-demos).

You can mount this image as data volume to make the `$HOME/.m2/repository` mounted using data from `/data/m2/repository`.

This image is available at [quarkus-maven-repo-cache](https://quay.io/repository/rhdevelopers/quarkus-maven-repo-cache)and can be pulled using the command `docker pull quay.io/repository/rhdevelopers/quarkus-maven-repo-cache:0.21.2`
