FROM node:22.17.1-alpine

# Variáveis de ambiente (opcionalmente usadas pelo Puppeteer/WPPConnect)
ENV CHROME_BIN=/usr/bin/chromium-browser \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    NODE_ENV=production

# Instala dependências
RUN apk update && apk add --no-cache \
  chromium \
  nss \
  freetype \
  harfbuzz \
  ca-certificates \
  ttf-freefont \
  yarn \
  git \
  nodejs \
  npm \
  udev \
  dumb-init

# Clona o projeto WPPConnect
RUN git clone https://github.com/yurirssilva/medicina-back.git
WORKDIR /medicina-back

# Instala dependências
RUN yarn install

RUN yarn add -D tsx prom-client 

# Porta padrão do WPPConnect
EXPOSE 21465

# Comando de inicialização (substitui CMD padrão do Node por dumb-init)
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "app.js", "--no-sandbox"]
