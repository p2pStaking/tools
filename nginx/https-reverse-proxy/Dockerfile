FROM nginx 
COPY nginx.conf /etc/nginx/nginx.conf
COPY reverse-proxy-https.conf /etc/nginx/templates/reverse-proxy-https.conf.template
RUN rm /etc/nginx/conf.d/default.conf && touch /etc/nginx/conf.d/default.conf 
