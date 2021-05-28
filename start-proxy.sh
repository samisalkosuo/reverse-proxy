

if [[ "$BACKEND_HOST" == "" ]]; then
  echo "BACKEND_HOST environment variable not set."
  echo "Set BACKEND_HOST to backend host."
  echo "For example:"
  echo "  BACKEND_HOST=server.internal.net"
  exit 1
fi

if [[ "$BACKEND_PROTOCOL" == "" ]]; then
  echo "BACKEND_PROTOCOL environment variable not set."
  echo "Set BACKEND_PROTOCOL to 'http' or 'https'."
  exit 1
fi

sed -i "s|BACKEND_HOST|${BACKEND_HOST}|g" /usr/local/apache2/conf/sites/reverse_proxy.conf
sed -i "s|BACKEND_PROTOCOL|${BACKEND_PROTOCOL}|g" /usr/local/apache2/conf/sites/reverse_proxy.conf

if [[ "$LOG" == "true" ]]; then
  #set apache logs as links to system out and system error
  ln -sf /proc/self/fd/1 /usr/local/apache2/logs/access_log && \
  ln -sf /proc/self/fd/2 /usr/local/apache2/logs/error_log
else
  echo "Access logs: /usr/local/apache2/logs/access_log"
fi

__log_format=""
case $LOG_FORMAT in
  combined)
    __log_format=combined
    ;;
  combinedio)
    __log_format=combinedio
    ;;
  *)
    __log_format=common
    ;;

esac
#set log format
sed -i "s|LOG_FORMAT|${__log_format}|g" /usr/local/apache2/conf/httpd.conf

exec httpd -D FOREGROUND
