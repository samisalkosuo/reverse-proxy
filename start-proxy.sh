

if [[ "$PROXY_PASS" == "" ]]; then
  #set apache logs as links to system out and system error
  echo "PROXY_PASS environment variable not set."
  echo "Set PROXY_PASS to backend host."
  exit 1
else
   sed -i "s|PROXY_PASS|${PROXY_PASS}|g" /usr/local/apache2/conf/sites/reverse_proxy.conf
fi

if [[ "$LOG" == "true" ]]; then
  #set apache logs as links to system out and system error
  ln -sf /proc/self/fd/1 /usr/local/apache2/logs/access_log && \
  ln -sf /proc/self/fd/1 /usr/local/apache2/logs/error_log
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
