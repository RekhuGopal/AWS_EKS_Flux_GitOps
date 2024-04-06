FROM node:20-bullseye-slim

WORKDIR /app

ARG USER=node_svc
ARG GROUP=node_svc

ENV NODE_PORT=5000

COPY . .

RUN apt-get update \
    && apt-get upgrade -y \
	&& rm -rf /var/lib/apt/lists/* \
    && useradd -rm -d /home/$USER -s /bin/bash $USER \
    && npm install \
    && npm install serve \
    && npm run build \
    && chown -R $USER:$GROUP /app \
    && chmod +x ./entrypoint.sh

EXPOSE $NODE_PORT

USER node_svc

CMD ["sh", "entrypoint.sh" ]
