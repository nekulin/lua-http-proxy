require "socket"require "serialize3"--OEM866local url, host, port, pathrepeat	io.write("�ਬ�� URL: http://example.com\n")	io.write("������ URL: ")	url = io.read("*l")	_, _, host, port, path = url:find("http://([a-z0-9%.-]+):?([0-9]*)(/?.*)")	until hostport = tonumber((#port > 0 and port) or 80)if not (#path > 0) then	path = "/"end print("Host: ", host)print("Port: ", port)print("Path: ", path)print""print("IP ����.")print ""local ip, ip_info = socket.dns.toip(host)if not ip then	print("�� 㤠����")	print(ip_info)	print("����� DNS �� 8.8.8.8 ����� ������")	returnendprint(ip, serialize(ip_info))print ""print "OK"print ""local server, err, good_ipfor index, ip in ipairs(ip_info.ip) do	print("�஡㥬 ����������� �� ip:", ip)	server, err = socket.connect(ip, port)	if server then		good_ip = ip		print("OK")		break	else		print(err)		print"�� ����稫���"		print""	endendif not server then	print(err)	print "��ᯮ������ ���譨� �ப��ࢥ஬ ��� ����������஬."	returnendconnect_headers10 = [[CONNECT %s HTTP/1.1Host: %s]]headers10 = ([[HEAD %s HTTP/1.1Host: %sConnection: close]])connect_headers = connect_headers10:gsub("(\10)","\13\10")headers = headers10:gsub("(\10)","\13\10")r = string.format(headers, path, host)socket.udp():sendto(r, good_ip, port) --udp testlocal try = 0local data, err, partlocal msg, description = "0. C⠭����� �����", ""local test_try repeat	if test_try then		try = test_try	end		if try==1 then		msg = "1. ������� ᫥�"		description = string.format("\n"..[[� ���᭮� ��ப� ��㧥� �����筮 ��᫥ ����� ��� 㢮��� ᫥�(/).		http://%s:%s/%s]], host, port, path)		r = string.format(headers, "/"..path, host)	elseif try==2 then		msg = "2. C�ࢥ� ��� �ப�"		description = string.format("\n"..[[� ��㧥� � ����⢥ �ப� �ࢥ� ��� ��� ����室��� 㪠���� ip � ���� ���. %s %s]], ip, port)				r = string.format(headers, url, host)	elseif try==3 then		msg = "3. �ᯮ��㥬 �������� rnd85454"		description = string.format("\n"..[[� ��㧥� � ����� ������ ���� �������� rnd85454http://rnd85454.%s:%s%s]], host, port, path)				r = string.format(headers, path, "rnd85454."..host)	elseif try==4 then		msg = "4. ��窠 � ���� ������"		description = string.format("\n"..[[� ��㧥� � ����� ������ ���� �������� � ���� "."http://%s.:%s%s]], host, port, path)				r = string.format(headers, path, host..".")	elseif try==5 then		msg = "5. �ᯮ��㥬 ip ������"		description = string.format("\n"..[[� ��㧥� ����� ����� ������ ���� �ᯮ�짮���� iphttp://%s:%s%s]], ip, port, path)				r = string.format(headers, path, ip)	elseif try==6 then		msg = "6. LF ����� CRLF � ���� ��ப�"		description = string.format("\n"..[[� ������ ��砥 �ப��ࢥ� ����� ����� ��ப� 奤��]], host, host)		r = string.format(headers10, path, host)			elseif try==7 then		msg = "7. Host �� host"		description = string.format("\n"..[[� ������ ��砥 �ப��ࢥ� ����� 奤��Host: %s�� host: %s]], host, host)		r = string.format(headers:gsub("\nHost: ", "\nhost: ", 1), path, host)		elseif try==9 then		msg = "7. GET �� get"		description = string.format("\n"..[[� ������ ��砥 �ப��ࢥ� ����� 奤��GET %s HTTP/1.1�� get %s HTTP/1.1]], path, path)		r = string.format(headers:gsub("^GET", "get", 1), path, host)			elseif try==8 then		msg = "8. ���������� �� ������"		description = "\n"..[[�ப��ࢥ� ��ࠢ��� 奤��� �६� �⤥��묨 ����⠬�]]		r = string.format(headers, path, host)		elseif try==13 then		msg = "13. ����ୠ⨢�� ����"		port = 80		description = "\n"..[[�ப��ࢥ� ��ࠢ��� 奤��� � ����ୠ⨢�� ���⮬ � ����]]		r = string.format(headers, "http://"..host..":8080"..path, host.."")	elseif try==11 then		msg = "11. ip � host"		description = "\n"..[[�ப��ࢥ� ��ࠢ��� ����� � GET � IP � Host:]]		r = string.format(headers, "http://"..host..":"..port..path, ip)		elseif try==10 then		msg = "10. ip � path"		description = "\n"..[[�ப��ࢥ� ��ࠢ��� IP � GET � ����� � Host:]]		r = string.format(headers, "http://"..ip..":"..port..path, host)			elseif try==12 then		msg = "12. CONNECT"		description = "\n"..[[�ப��ࢥ� ��ࠢ��� CONNECT ��। ��ࠢ��� �����]]		local ip_port = ip..":"..port;		c = string.format(connect_headers, ip_port, ip_port)		r = string.format(headers, path, host)		end		print ("-------------------------------------------")	print (msg, description)		if try > 0 then		print "��१ 5 ᥪ㭤 ����"		socket.sleep(5)		server, err = socket.connect(good_ip, port)		if not server then			print(err)			print "�� 㤠���� ������ ᮥ�������� � �ࢥ஬."			return		end	end		print "��ࠢ�塞 �����"	print ""			if try==8 then		print(r)		index, err, index2 = server:send(r:sub(1,6))		print(r:sub(1,6))		index, err, index2 = server:send(r:sub(7, -26))		print(r:sub(7, -26))		r = r:sub(-25)		print(r)	elseif try == 12 then		print(c)		index, err, index2 = server:send(c)		server:settimeout(1)		data, err, part = server:receive("*a")		packet = (data or part)		print(packet)--:sub(1, 100))		print(r)	else		print(r)	end		local index, err, index2 = server:send(r)	if err then		print(err, index2)		print "�� 㤠���� ��ࠢ��� ����� ���� �� ��ࠢ���� ���筮."		return	end	server:settimeout(20)	data, err, part = server:receive("*a")	packet = (data or part)	print(packet)--:sub(1, 100))	_, _, location = packet:find("(Location: [^\n\r]*)")	if location then		print (location)	end	print ""	if not data and err then			print(err)		print"�� 㤠����"		print ""	end		server:close()		if not test_try then		try = try + 1	end	until  (try >= 14) or test_try	