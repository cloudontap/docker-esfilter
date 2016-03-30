[#ftl]
[#assign configurationObject = configuration?eval]
user www-data;
worker_processes 4;
pid /run/nginx.pid;

events {
    worker_connections 768;
    # multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    gzip_disable "msie6";
    
    server_tokens off;
    
    real_ip_header X-Forwarded-For;

    upstream elasticsearch {
      server ${configurationObject.ElasticSearch.EndPoint};

      keepalive 15;
    }

    server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;
        underscores_in_headers on;
        root /usr/share/nginx/html;
        index index.html index.htm;
    
        # Make site accessible from http://localhost/
        server_name localhost;
    
        location /healthcheck {
            allow all;
	    return 200 'Everything is ok';
        }
 
        location / {
            include ip_data.conf;
            proxy_pass https://elasticsearch;
            proxy_http_version 1.1;
            proxy_set_header Connection "Keep-Alive";
            proxy_set_header Proxy-Connection "Keep-Alive";
            if ($http_x_forwarded_proto != "https") {
     		 rewrite ^(.*)$ https://$host$1 permanent;
            }
            
        }
    }

}
