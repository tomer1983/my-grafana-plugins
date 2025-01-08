# Grafana Plugin Installer Docker Image

This project provides a streamlined way to create a custom Grafana Docker image with pre-installed plugins from a user-defined list. It is designed to simplify the setup of Grafana environments, enabling faster deployments with all required plugins ready to use.

## Key Features
- **Customizable Plugin Installation**: Specify desired Grafana plugins in a simple `plugins.txt` file.
- **Automated Plugin Handling**: Automatically cleans and installs plugins while handling common formatting issues.
- **Pre-Built Plugin Directory**: Plugins are stored in `/tmp/plugins` for easy verification and reuse.
- **Base on Grafana Enterprise**: Leverages the official Grafana Enterprise image for stability and compatibility.

## How It Works
1. **Provide Plugin List**: Populate the `plugins.txt` file with the desired plugins (one per line, ignoring lines starting with `#` or blank lines).
2. **Build the Image**: Use the provided Dockerfile to build your custom Grafana image.
3. **Deploy with Plugins**: The resulting Docker image includes all specified plugins, pre-installed and verified.

## Usage
1. Add your desired plugins to a `plugins.txt` file in the root of the project.
2. Build the Docker image:
   ```bash
   docker build -t custom-grafana .
3. Run the container:
   ```bash
   docker run -d -p 3000:3000 custom-grafana

