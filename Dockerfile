FROM debian:buster

COPY ./src/install.sh ./
COPY ./src/autoindex.sh ./
COPY ./src/site.conf ./tmp/
COPY ./src/config.inc.php ./tmp/
COPY ./src/wp-config.php ./tmp/wp-config.php

CMD bash ./install.sh && bash