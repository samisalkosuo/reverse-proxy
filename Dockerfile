FROM httpd:2.4.48

 
WORKDIR /app

COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir -p /usr/local/apache2/conf/sites/
COPY reverse_proxy.conf /usr/local/apache2/conf/sites/
COPY start-proxy.sh ./

EXPOSE 8080

CMD ["/bin/bash", "/app/start-proxy.sh"]
#CMD ["httpd", "-D", "FOREGROUND"]
#CMD ["/bin/bash"]