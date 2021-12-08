FROM docker.elastic.co/logstash/logstash-oss:7.14.2

# JDBC drivers required by the JDBC output plugin
RUN mkdir /usr/share/logstash/vendor/jar
COPY lib/jdbc/ /usr/share/logstash/vendor/jar/jdbc/

# Jakarta EE JAXB libraries that were removed in Java 11; used for (De-)Serialization
# (See: https://stackoverflow.com/questions/43574426/how-to-resolve-java-lang-noclassdeffounderror-javax-xml-bind-jaxbexception)
COPY lib/jaxb/* /usr/share/logstash/logstash-core/lib/jars/

RUN cd /opt/logstash/
RUN bin/logstash-plugin install logstash-output-jdbc
