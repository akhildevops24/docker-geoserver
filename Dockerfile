FROM tomcat:9-jre11

ENV GEOSERVER_VERSION 2.15.2
ENV GEOSERVER_DATA_DIR /var/local/geoserver
ENV GEOSERVER_INSTALL_DIR /usr/local/geoserver

RUN set -x \
	&& apt-get update \
	&& apt-get install unzip

ADD conf/geoserver.xml /usr/local/tomcat/conf/Catalina/localhost/geoserver.xml
RUN mkdir ${GEOSERVER_DATA_DIR} \
	&& mkdir ${GEOSERVER_INSTALL_DIR} \
	&& cd ${GEOSERVER_INSTALL_DIR} \
	&& wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip \
	&& unzip geoserver-${GEOSERVER_VERSION}-war.zip \
	&& unzip geoserver.war \
	&& mv data/* ${GEOSERVER_DATA_DIR} \
	&& rm -rf geoserver-${GEOSERVER_VERSION}-war.zip geoserver.war target *.txt


# Tomcat environment
ENV CATALINA_OPTS "-server -Djava.awt.headless=true \
	-Xms768m -Xmx1560m -XX:+UseConcMarkSweepGC -XX:NewSize=48m \
	-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR}"

ADD start.sh /usr/local/bin/start.sh
CMD start.sh

EXPOSE 8080

