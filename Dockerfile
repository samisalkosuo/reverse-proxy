FROM httpd:2.4.54

#default hostname and domain for certificate
ENV DEFAULT_HOSTNAME=reverseproxy
ENV DEFAULT_DOMAIN=local.net

WORKDIR /app

COPY certs/* ./certs/
#generate default certificate
RUN cd certs && sh create-cert.sh $DEFAULT_HOSTNAME $DEFAULT_DOMAIN

COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir -p /usr/local/apache2/conf/sites/
COPY reverse-proxy.conf /usr/local/apache2/conf/sites/
COPY start-proxy.sh ./

#expose http port
EXPOSE 8080
#expose https port
EXPOSE 8443

#CMD ["/bin/bash"]
CMD ["/bin/bash", "/app/start-proxy.sh"]
