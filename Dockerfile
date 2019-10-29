FROM quay.io/rhdevelopers/tutorial-tools:0.0.2 as builder

ARG MAVEN_MIRROR_URL=http://repo1.maven.org/maven2
ARG QUARKUS_VERSION=0.26.1

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
    && mvn clean install 

# Copy the maven repo to data container
# TODO use UBI ???
FROM busybox

COPY --from=builder /opt/developer/.m2/repository /data/m2/repository/

VOLUME [ "/data" ]

WORKDIR /data

CMD ["tail","-f","/dev/null"]