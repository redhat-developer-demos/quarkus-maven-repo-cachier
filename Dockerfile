FROM quay.io/rhdevelopers/tutorial-tools:0.0.2 as builder

ARG MAVEN_MIRROR_URL=http://repo1.maven.org/maven2
ARG QUARKUS_VERSION=0.23.2

USER 10001

RUN cd /tmp \
    && /usr/local/bin/run.sh \
    && mvn -B io.quarkus:quarkus-maven-plugin:$QUARKUS_VERSION:create \
      -DprojectGroupId="com.redhat.developers" \
      -DprojectArtifactId="maven-cache-setup" \
      -DprojectVersion="1.0-SNAPSHOT" \
      -DclassName="ExampleResource" \
      -Dextensions="quarkus-smallrye-opentracing,quarkus-jsonb,quarkus-rest-client,quarkus-smallrye-health,quarkus-vertx,quarkus-resteasy-jsonb,quarkus-smallrye-metrics,quarkus-smallrye-openapi,quarkus-swagger-ui,quarkus-hibernate-orm,quarkus-hibernate-orm-panache,quarkus-jdbc-h2,quarkus-jdbc-mariadb,quarkus-jdbc-postgresql" \
      -Dpath="example" \
    && cd maven-cache-setup \
    && mvn clean -DskipTests install 

# Copy the maven repo to data container
FROM registry.access.redhat.com/ubi8/ubi-minimal

USER 0
# Set permissions on /etc/passwd and /home to allow arbitrary users to write
COPY [--chown=0:0] entrypoint.sh /

COPY --from=builder /opt/developer/.m2/repository /data/m2/repository/

RUN mkdir -p /home/user && chgrp -R 0 /home /data \
  && chmod -R g=u /etc/passwd /home /data \
  && chmod +x /entrypoint.sh

VOLUME [ "/data" ]

ENV HOME=/home/user

USER 10001
WORKDIR /data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["tail", "-f", "/dev/null"]

