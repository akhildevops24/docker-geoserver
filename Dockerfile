FROM tomcat:9-jre11

ADD startup.sh /usr/local/bin/start.sh
CMD start.sh

EXPOSE 8080