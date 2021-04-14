# Start from the code-server Debian base image
FROM codercom/code-server:latest 

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# You can add custom software and dependencies for your environment here. Some examples:

# RUN code-server --install-extension esbenp.prettier-vscode
# RUN sudo apt-get install -y build-essential
# RUN COPY myTool /home/coder/myTool

# Install NodeJS
RUN sudo curl -fsSL https://deb.nodesource.com/setup_12.x | sudo bash -
RUN sudo apt-get install -y nodejs && sudo npm install -g yarn

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Port
ENV PORT=8080

# Install Extension
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension streetsidesoftware.code-spell-checker
RUN code-server --install-extension pkief.material-icon-theme
RUN code-server --install-extension amatiasq.sort-imports
RUN code-server --install-extension mhutchie.git-graph
RUN code-server --install-extension coenraads.bracket-pair-colorizer
RUN code-server --install-extension sdras.night-owl
RUN code-server --install-extension james-yu.latex-workshop

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
