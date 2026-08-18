FROM node:18-bullseye

# Install ffmpeg and fonts
RUN apt-get update && apt-get install -y ffmpeg libfreetype6 libfreetype6-dev fonts-dejavu-core && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci --production

COPY . .

EXPOSE 4000
CMD ["node", "index.js"]
