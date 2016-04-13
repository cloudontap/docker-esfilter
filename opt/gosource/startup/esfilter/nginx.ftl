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
    
    set_real_ip_from ${configurationObject.ELB.CIDR};
    
    real_ip_header X-Forwarded-For;
    real_ip_recursive on;

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
        }

        location /_plugin/kibana/ {
	    satisfy any;
	    include ip_query.conf;
	    auth_basic "Restricted";
            auth_basic_user_file /etc/nginx/.htpasswd;
        }
    }

}
