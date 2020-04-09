FROM docker.io/tomcat/tomcat85:31-j151
MAINTAINER vabsnanoti@gmail.com


#COPY *.war /apache-tomcat/webapps/
#COPY genprop.sh /

RUN useradd -ms /bin/bash deployer && \
   chown -R deployer:deployer /apache-tomcat

# fix time zone (allow change)
RUN rm -rf /etc/localtime && \
   mkdir /config && \
   touch timezone && \
   chmod 666 /etc/timezone && \
   chmod 775 /genprop.sh && \
   chown -R deployer:deployer /config && \ln -snf /config/timezone /etc/localtime

RUN ln -s /usr/local/tomcat /apache-tomcat

USER deployer
RUN echo "export TERM=xterm" >> /home/deployer/.bashrc

EXPOSE 8080/tcp
CMD ["/genprop.sh"]
