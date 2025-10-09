FROM kong:3.7.1-ubuntu

# Copy configuration files
COPY kong.yml.template /etc/kong/kong.yml.template
COPY ./custom-auth /usr/local/share/lua/5.1/kong/plugins/custom-auth
COPY --chown=kong:kong startup.sh /startup.sh

# Make startup script executable
RUN chmod +x /startup.sh

# Environment variables
ENV KONG_DATABASE=off \
  KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yml \
  KONG_PLUGINS=bundled,custom-auth

# Use startup script as entrypoint
ENTRYPOINT ["/startup.sh"]