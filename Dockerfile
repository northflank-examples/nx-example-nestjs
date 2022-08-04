FROM node:lts-alpine as builder
WORKDIR /app
RUN npm install nx -g
COPY package.json .
COPY package-lock.json .
COPY nx.json .
RUN npm install
COPY . .
RUN npm run build

FROM node:lts-alpine as runtime
WORKDIR /app
COPY --from=builder /app/dist/apps/nx-test .
ENV PORT=3333
EXPOSE ${PORT}
COPY package.json .
COPY package-lock.json .
RUN npm install --omit=dev
CMD node ./main.js
