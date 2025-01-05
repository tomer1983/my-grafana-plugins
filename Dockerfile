ARG GRAFANA_VERSION=11.4.0

FROM grafana/grafana-enterprise:${GRAFANA_VERSION}

USER root

# Copy plugins list
COPY plugins.txt /tmp/plugins.txt

# Install plugins from the list
RUN cat /tmp/plugins.txt | xargs -n 1 grafana-cli plugins install

# Switch back to grafana user
USER grafana
