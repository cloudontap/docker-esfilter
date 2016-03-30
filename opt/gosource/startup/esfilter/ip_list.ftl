[#ftl]
[#assign configurationObject = configuration?eval]
[#list (configuration?eval).AddressBlocks[list] as entry]
	allow ${entry.IP};
[/#list]
deny all;
