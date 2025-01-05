ARG GRAFANA_VERSION=latest

FROM grafana/grafana:${GRAFANA_VERSION}

USER root

# Copy plugins list
COPY plugins.txt /tmp/plugins.txt

# Install plugins from the list with error handling
RUN while IFS= read -r plugin || [ -n "$plugin" ]; do \
    if [ ! -z "$plugin" ]; then \
        echo "Installing plugin: $plugin" && \
        grafana-cli --pluginsDir "/var/lib/grafana/plugins" plugins install "$plugin" || exit 1; \
    fi \
done < /tmp/plugins.txt

# Verify installations
RUN grafana-cli plugins ls

# Switch back to grafana user
USER grafana
