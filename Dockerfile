FROM node:12.2.0 as build-step
WORKDIR /app

COPY . .

RUN npm install
RUN npm run protractor-version
RUN npm run e2e
# CMD ["npm", "run", "e2e"]
RUN npm run build-prod

FROM nginx:1.16.1-alpine as prod-stage
COPY --from=build-step /app/dist /usr/share/nginx/html




############## steps to run  #################

#1 run the compose file first
   # docker-compose up -d
#2 build the image using the docker-file
   # docker build -t [image-name]:[version] .
   # example : docker build -t ng-e2e:80 .
#3 find the network-name & container-id of your selenium grid container
   # docker network ls & docker ps
#4 run the image which you created in step-2 and link the selenium-grid container and the angular-image container
   # docker run -p [port]:[container-port] --link [container-id] --net [network-name] [image-name]:[version]
   # exammple : docker run -p 80:80 --link seleniumhub --net protractor-docker-image_progrid_grid_internal ng-e2e:80
#5 Inspect whether your container is successfully linked to selenium grid or not
   # docker network inspect [network-name]
   # example : docker network inspect protractor-docker-image_progrid_grid_internal