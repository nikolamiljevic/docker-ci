#ovo je proces koji ima vise koraka --- instaliramo prvo kontejner za web aplikaciju a zatim nginx server koji je povezan sa ovim prvim kontejnerom

#  prva faza je pravljenje image-a za web kontejner
FROM node:16-alpine as builder
USER node
RUN mkdir -p /home/node/app
WORKDIR /home/node/app
COPY --chown=node:node ./package.json ./
RUN npm install
COPY --chown=node:node . .
RUN npm run build

# druga faza je nginx
FROM nginx
#moramo da exposujemo port, jer kada radimo deploy nigde mu ne zadajemo komandu da to uradi, za razliku od lokalnog pokretanja kontejnera gde zadajemo port mapping
# ovo vazi kada koristimo EB na aws-u jer on ce uci u ovaj fajl i pogledati da li je exposovan port 
EXPOSE 80 
#kopiramo nesto iz ove faze iznad koju smo nazvali builder
COPY --from=builder /home/node/app/build /usr/share/nginx/html

#odradimo -- docker build .
# docker run -p 8080:80 <image id>