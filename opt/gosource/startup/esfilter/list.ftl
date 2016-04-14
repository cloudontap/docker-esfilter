[#ftl]
satisfy any;
[#assign configurationObject = configuration?eval]
[#list (configuration?eval).AddressBlocks[list] as entry]
	allow ${entry.IP};
[/#list]
deny all;
auth_basic "Restricted";
auth_basic_user_file /etc/nginx/.htpasswd;
proxy_pass https://elasticsearch;
proxy_http_version 1.1;
proxy_pass_request_headers off;
proxy_set_header Connection "Keep-Alive";
proxy_set_header Proxy-Connection "Keep-Alive";
if ($http_x_forwarded_proto != "https") {
  rewrite ^(.*)$ https://$host$1 permanent;
}

