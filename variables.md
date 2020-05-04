Please refer to the table below for currently defined variables :
```text
  +---+------+-----------------------------------------------+-------------+
  | R | var  | field name (8.2.2 and 8.2.3 for description)  | type        |
  +---+------+-----------------------------------------------+-------------+
  |   | %o   | special variable, apply flags on all next var |             |
  +---+------+-----------------------------------------------+-------------+
  |   | %B   | bytes_read           (from server to client)  | numeric     |
  | H | %CC  | captured_request_cookie                       | string      |
  | H | %CS  | captured_response_cookie                      | string      |
  |   | %H   | hostname                                      | string      |
  | H | %HM  | HTTP method (ex: POST)                        | string      |
  | H | %HP  | HTTP request URI without query string (path)  | string      |
  | H | %HQ  | HTTP request URI query string (ex: ?bar=baz)  | string      |
  | H | %HU  | HTTP request URI (ex: /foo?bar=baz)           | string      |
  | H | %HV  | HTTP version (ex: HTTP/1.0)                   | string      |
  |   | %ID  | unique-id                                     | string      |
  |   | %ST  | status_code                                   | numeric     |
  |   | %T   | gmt_date_time                                 | date        |
  |   | %Ta  | Active time of the request (from TR to end)   | numeric     |
  |   | %Tc  | Tc                                            | numeric     |
  |   | %Td  | Td = Tt - (Tq + Tw + Tc + Tr)                 | numeric     |
  |   | %Tl  | local_date_time                               | date        |
  |   | %Th  | connection handshake time (SSL, PROXY proto)  | numeric     |
  | H | %Ti  | idle time before the HTTP request             | numeric     |
  | H | %Tq  | Th + Ti + TR                                  | numeric     |
  | H | %TR  | time to receive the full request from 1st byte| numeric     |
  | H | %Tr  | Tr (response time)                            | numeric     |
  |   | %Ts  | timestamp                                     | numeric     |
  |   | %Tt  | Tt                                            | numeric     |
  |   | %Tw  | Tw                                            | numeric     |
  |   | %U   | bytes_uploaded       (from client to server)  | numeric     |
  |   | %ac  | actconn                                       | numeric     |
  |   | %b   | backend_name                                  | string      |
  |   | %bc  | beconn      (backend concurrent connections)  | numeric     |
  |   | %bi  | backend_source_ip       (connecting address)  | IP          |
  |   | %bp  | backend_source_port     (connecting address)  | numeric     |
  |   | %bq  | backend_queue                                 | numeric     |
  |   | %ci  | client_ip                 (accepted address)  | IP          |
  |   | %cp  | client_port               (accepted address)  | numeric     |
  |   | %f   | frontend_name                                 | string      |
  |   | %fc  | feconn     (frontend concurrent connections)  | numeric     |
  |   | %fi  | frontend_ip              (accepting address)  | IP          |
  |   | %fp  | frontend_port            (accepting address)  | numeric     |
  |   | %ft  | frontend_name_transport ('~' suffix for SSL)  | string      |
  |   | %lc  | frontend_log_counter                          | numeric     |
  |   | %hr  | captured_request_headers default style        | string      |
  |   | %hrl | captured_request_headers CLF style            | string list |
  |   | %hs  | captured_response_headers default style       | string      |
  |   | %hsl | captured_response_headers CLF style           | string list |
  |   | %ms  | accept date milliseconds (left-padded with 0) | numeric     |
  |   | %pid | PID                                           | numeric     |
  | H | %r   | http_request                                  | string      |
  |   | %rc  | retries                                       | numeric     |
  |   | %rt  | request_counter (HTTP req or TCP session)     | numeric     |
  |   | %s   | server_name                                   | string      |
  |   | %sc  | srv_conn     (server concurrent connections)  | numeric     |
  |   | %si  | server_IP                   (target address)  | IP          |
  |   | %sp  | server_port                 (target address)  | numeric     |
  |   | %sq  | srv_queue                                     | numeric     |
  | S | %sslc| ssl_ciphers (ex: AES-SHA)                     | string      |
  | S | %sslv| ssl_version (ex: TLSv1)                       | string      |
  |   | %t   | date_time      (with millisecond resolution)  | date        |
  | H | %tr  | date_time of HTTP request                     | date        |
  | H | %trg | gmt_date_time of start of HTTP request        | date        |
  | H | %trl | local_date_time of start of HTTP request      | date        |
  |   | %ts  | termination_state                             | string      |
  | H | %tsc | termination_state with cookie status          | string      |
  +---+------+-----------------------------------------------+-------------+

    R = Restrictions : H = mode http only ; S = SSL only
```