netsh advfirewall firewall add rule name="8090 TCP" dir=in action=allow protocol=TCP localport=8090
cls
netsh advfirewall firewall add rule name="8090 UDP" dir=in action=allow protocol=UDP localport=8090
cls
netsh advfirewall firewall add rule name="8090 TCP" dir=out action=allow protocol=TCP localport=8090
cls
netsh advfirewall firewall add rule name="8090 UDP" dir=out action=allow protocol=UDP localport=8090
cls