# pull down the pode image (Alpine)
FROM badgerati/pode:latest

# Install packages

# copy over the local files to the container
COPY server.ps1 /usr/src/app/
COPY package.json /usr/src/app/

# expose the port
EXPOSE 8080

# run the server
CMD [ "pwsh", "-c", "cd /usr/src/app; ./server.ps1" ]
