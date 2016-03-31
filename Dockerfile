FROM java:8-jre

# install plugin dependencies
RUN apt-get update && apt-get install -y --no-install-recommends nginx

COPY opt/ /opt/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

