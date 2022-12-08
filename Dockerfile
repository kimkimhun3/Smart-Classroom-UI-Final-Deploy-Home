
# /* ========================================= */
                # BUILD STAGE #
# /* ========================================= */

FROM node:14.17-alpine as build-stage 

WORKDIR /app

COPY ./package.json .

RUN npm install

COPY . .

RUN npm run build

# /* ========================================= */
                # CONFIG NGINX #
# /* ========================================= */

FROM nginx:1.15.8-alpine as production-stage

WORKDIR /app

COPY --from=build-stage /app/dist /app

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8000