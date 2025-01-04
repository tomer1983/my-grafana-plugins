#!/bin/bash
set -eo pipefail

GRAFANA_VERSION="11.4"
GRAFANA_API_URL="https://grafana.com/api/plugins"  
PLUGINS_FILE="$1"
PLUGINS_DIR="grafana-plugins"


git config --global user.email "tomer1983@gmail.com"
git config --global user.name "tomer1983"

process_plugins(){
    
    PLUGINS=$(cat $PLUGINS_FILE)
    mkdir -p $PLUGINS_DIR

    for plugin in $PLUGINS; do
        echo "Installing plugin: $plugin"
        get_plugin_info=$(curl -s "$GRAFANA_API_URL/$plugin" || echo "plugin "$plugin not found)
        get_arc_info=$(echo $get_plugin_info | jq -r 'if .packages[].packageName == "any" then "any" else "linux-amd64" end')
        get_version_info=$(echo $get_plugin_info | jq -r '.version')

        if [[ "$get_arc_info" == "any" ]]; 
        then
            echo -e "plugin $plugin arc is any"
            download_url="$GRAFANA_API_URL/$plugin/versions/$get_version_info/download"
        else
            echo -e "plugin $plugin arc is linux-amd64"
            download_url="$GRAFANA_API_URL/$plugin/versions/$get_version_info/download?os=linux&arch=amd64"
        fi
        
        curl -L -o "$PLUGINS_DIR/$plugin.zip" "$download_url" 
        # curl -L -o "$PLUGINS_DIR/$plugin.zip" "$download_url" || echo "Failed to download $plugin"
        echo "$PLUGINS_DIR/$plugin.zip"
    done
    # zip -r ./grafana-plugins.zip "$PLUGINS_DIR"
    du -h *
    rm -rf "$PLUGINS_DIR"
    ls -latr
}

commit_plugins(){
    git add "$1"
    git commit -m "Update Grafana plugin $(cat $1 | awk '{print $1}') [skip ci]"
    git push https://oauth2:$GITLAB_TOKEN@$CI_SERVER_HOST/$CI_PROJECT_PATH.git HEAD:$CI_COMMIT_REF_NAME
}

process_plugins