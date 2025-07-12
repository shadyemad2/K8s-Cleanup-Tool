FROM bitnami/kubectl:latest

# Copy script with proper permissions
USER root
COPY cleanup.sh /opt/cleanup.sh
RUN chmod +x /opt/cleanup.sh

USER 1001
ENTRYPOINT ["/opt/cleanup.sh"]

