FROM registry.access.redhat.com/ubi9/openjdk-17 as builder

ARG MAVEN_MIRROR_URL=http://repo1.maven.org/maven2

RUN cd /tmp \
    && mvn -B io.quarkus:quarkus-maven-plugin:create \
      -DprojectGroupId="com.redhat.developers" \
      -DprojectArtifactId="maven-cache-setup" \
      -DprojectVersion="1.0-SNAPSHOT" \
      -DclassName="ExampleResource" \
      -Dextensions="quarkus-resteasy-reactive,quarkus-resteasy-reactive-jackson,quarkus-rest-client-reactive-jsonb,quarkus-resteasy-reactive-jsonb,quarkus-opentelemetry,quarkus-rest-client-reactive,quarkus-smallrye-health,quarkus-vertx,,quarkus-smallrye-metrics,quarkus-smallrye-openapi,quarkus-hibernate-orm,quarkus-hibernate-orm-panache,quarkus-jdbc-h2,quarkus-jdbc-mariadb,quarkus-jdbc-postgresql,quarkus-spring-web,quarkus-spring-data-jpa,quarkus-smallrye-jwt,quarkus-kafka-client,quarkus-kafka-streams,quarkus-smallrye-reactive-messaging-kafka" \
      -Dpath="example" \
    && cd maven-cache-setup \
    && mvn org.apache.maven.plugins:maven-dependency-plugin:3.6.0:resolve

FROM registry.access.redhat.com/ubi9/ubi-minimal

RUN mkdir -p  /work/m2repo

COPY --from=builder /home/default/.m2/repository /work/m2repo

COPY che-entrypoint-run.sh /usr/local/bin

WORKDIR /work/volumes

CMD ["/usr/local/bin/che-entrypoint-run.sh"]