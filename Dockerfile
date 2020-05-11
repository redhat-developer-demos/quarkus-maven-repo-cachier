FROM quay.io/quarkus/centos-quarkus-maven:20.0.0-java11 as builder

ARG MAVEN_MIRROR_URL=http://repo1.maven.org/maven2
ARG QUARKUS_VERSION=1.4.2.Final

RUN cd /tmp \
    && mvn -B io.quarkus:quarkus-maven-plugin:$QUARKUS_VERSION:create \
      -DprojectGroupId="com.redhat.developers" \
      -DprojectArtifactId="maven-cache-setup" \
      -DprojectVersion="1.0-SNAPSHOT" \
      -DclassName="ExampleResource" \
      -Dextensions="quarkus-resteasy,quarkus-resteasy-jackson,quarkus-rest-client-jsonb,quarkus-resteasy-jsonb,quarkus-smallrye-opentracing,quarkus-resteasy-mutiny,quarkus-resteasy-jsonb,quarkus-rest-client,quarkus-smallrye-health,quarkus-vertx,quarkus-resteasy-jsonb,quarkus-smallrye-metrics,quarkus-smallrye-openapi,quarkus-swagger-ui,quarkus-hibernate-orm,quarkus-hibernate-orm-panache,quarkus-jdbc-h2,quarkus-jdbc-mariadb,quarkus-jdbc-postgresql,quarkus-spring-web,quarkus-spring-data-jpa,quarkus-smallrye-jwt,quarkus-kafka-client,quarkus-kafka-streams,quarkus-smallrye-reactive-messaging-kafka" \
      -Dpath="example" \
    && cd maven-cache-setup \
    && mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.2:resolve

FROM registry.access.redhat.com/ubi8/ubi-minimal

RUN mkdir -p  /work/m2repo

COPY --from=builder /home/quarkus/.m2/repository /work/m2repo

COPY che-entrypoint-run.sh /usr/local/bin

WORKDIR /work/volumes

CMD ["/usr/local/bin/che-entrypoint-run.sh"]