[#ftl]
[#assign configurationObject = configuration?eval]
[#list (configuration?eval).AddressBlocks[list] as entry]
	allow ${entry.IP};
[/#list]
deny all;
proxy_pass https://elasticsearch;
proxy_http_version 1.1;
proxy_set_header Connection "Keep-Alive";
proxy_set_header Proxy-Connection "Keep-Alive";
if ($http_x_forwarded_proto != "https") {
  rewrite ^(.*)$ https://$host$1 permanent;
}

