# Dockerfile de nio-gateway
FROM openjdk:8-jdk-alpine
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
COPY ./src/main/resources/static/secret.key /opt/secrets/

# SECCION PARA PRUEBAS INICIA
#COPY ./src/jonima2019.crt $JAVA_HOME/jre/lib/security
#VOLUME /tmp
#VOLUME /logs
#VOLUME /sslfiles
#ADD target/nio-gateway-1.0.9-SNAPSHOT.jar app.jar
#ENV JAVA_OPTS="-Xmx768m -Duser.timezone=America/Mexico_City"
#ENV JRE_KEYSTORE=$JAVA_HOME/jre/lib/security/cacerts
#ENV CER_DIR=$JAVA_HOME/jre/lib/security/jonima2019.crt
#RUN keytool -import -alias jonimacert -storepass changeit -noprompt -keystore $JRE_KEYSTORE -trustcacerts -file $CER_DIR
##RUN keytool  -list -storepass changeit -keystore $JRE_KEYSTORE
# SECCION PARA PRUEBAS TERMINA

# SECCION PARA PRODUCCION INICIA
COPY ./src/stre_red.crt $JAVA_HOME/jre/lib/security
VOLUME /tmp
VOLUME /logs
ADD target/nio-gateway-1.0.9-SNAPSHOT.jar app.jar
ENV JAVA_OPTS="-Duser.timezone=America/Mexico_City"
ENV JRE_KEYSTORE=$JAVA_HOME/jre/lib/security/cacerts
ENV CER_DIR=$JAVA_HOME/jre/lib/security/stre_red.crt
RUN keytool -import -alias stre.red -storepass changeit -noprompt -keystore $JRE_KEYSTORE -trustcacerts -file $CER_DIR
# SECCION PARA PRODUCCION TERMINA

ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar
