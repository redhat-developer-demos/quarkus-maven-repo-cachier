FROM quay.io/quarkus/centos-quarkus-maven:20.0.0-java11 as builder

ARG MAVEN_MIRROR_URL=http://repo1.maven.org/maven2
ARG QUARKUS_VERSION=1.4.2.Final

USER 10001

RUN cd /tmp \
    && mvn -B io.quarkus:quarkus-maven-plugin:$QUARKUS_VERSION:create \
      -DprojectGroupId="com.redhat.developers" \
      -DprojectArtifactId="maven-cache-setup" \
      -DprojectVersion="1.0-SNAPSHOT" \
      -DclassName="ExampleResource" \
      -Dextensions="quarkus-resteasy,quarkus-resteasy-jackson,quarkus-rest-client-jsonb,quarkus-resteasy-jsonb,quarkus-smallrye-opentracing,quarkus-resteasy-mutiny,quarkus-resteasy-jsonb,quarkus-rest-client,quarkus-smallrye-health,quarkus-vertx,quarkus-resteasy-jsonb,quarkus-smallrye-metrics,quarkus-smallrye-openapi,quarkus-swagger-ui,quarkus-hibernate-orm,quarkus-hibernate-orm-panache,quarkus-jdbc-h2,quarkus-jdbc-mariadb,quarkus-jdbc-postgresql,quarkus-spring-web,quarkus-spring-data-jpa,quarkus-smallrye-jwt,quarkus-kafka-client,quarkus-kafka-streams,quarkus-smallrye-reactive-messaging-kafka" \
      -Dpath="example" \
    && cd maven-cache-setup \
    && mvn clean install 

FROM registry.access.redhat.com/ubi8/ubi-minimal

RUN mkdir -p  mkdir -p /work/volumes/.m2/repository

COPY --from=builder /opt/developer/.m2/repository/ /work/volumes/.m2/repository/

WORKDIR /work/volumes

CMD ["tail","-f","/dev/null"]