% base config
server_auth_disk(120).
server_auth_ram(100).
server_auth_cpu(200).
server_storage_disk(4000).
server_storage_ram(85).
server_storage_cpu(75).
server_script_disk(70).
server_script_ram(400).
server_script_cpu(1000).

% hardware
spd_slot_price(50).
ssd_slot_price(30).
server_auth_price(1000).
server_storage_price(1800).
server_script_price(2800).
disk_unit(250).
ram_unit(400).
cpu_unit(300).
disk_price(100).
ram_price(250).
cpu_price(420).

% tasks
routing_spd_time(100).
routing_ssd_time(250).
delegation_time(50).
auth_request_time(400).
storage_request_time(850).
script_request_time(100).

% resources
auth_request_disk(50).
auth_request_ram(80).
auth_request_cpu(75).
storage_request_disk(120).
storage_request_ram(40).
storage_request_cpu(30).
script_request_disk(30).
script_request_ram(150).
script_request_cpu(220).

% other
scripts_to_auth_servers_ratio(2).
budget(20000).
requests(1000).
auth_percentage(25).
scripts_percentage(60).
storage_percentage(15).
