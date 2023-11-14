FROM node:18-alpine

WORKDIR /workdir

COPY package.json .
COPY package-lock.json .

RUN npm install

COPY . .

CMD ["npm", "run", "dev"]

EXPOSE 3000