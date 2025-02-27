ARG GRAFANA_VERSION=11.4.0

FROM grafana/grafana-enterprise:${GRAFANA_VERSION}

USER root

# Copy plugins list
COPY plugins.txt /tmp/plugins.txt

RUN mkdir -p /tmp/plugins 

VOLUME ['/tmp/plugins']
# Clean up plugins.txt and install plugins
RUN sed -i 's/\r//g' /tmp/plugins.txt && \
    grep -v '^#' /tmp/plugins.txt | \
    sed '/^[[:space:]]*$/d' | \
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' > /tmp/plugins-clean.txt && \
    echo "Starting plugin installation..." && \
    while IFS= read -r plugin || [ -n "$plugin" ]; do \
        echo "Attempting to install plugin: $plugin" && \
        if grafana cli plugins install "$plugin"; then \
            echo "✅ Successfully installed plugin: $plugin"; \
        else \
            echo "❌ Failed to install plugin: $plugin"; \
        fi; \
    done < /tmp/plugins-clean.txt
RUN cp -R /var/lib/grafana/plugins/* /tmp/plugins/ 
RUN chmod 777 /tmp/plugins
# List installed plugins for verification
RUN ls -latr /tmp/plugins

# Switch back to grafana user
USER grafana
