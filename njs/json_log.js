export default { debugLog };
function debugLog(r) {
    var connection = {
        "serial": Number(r.variables.connection),
        "request_count": Number(r.variables.connection_requests),
        "elapsed_time": Number(r.variables.request_time)
    }
    if (r.variables.pipe == "p") {
        connection.pipelined = true;
    } else {
        connection.pipelined = false;
    }
    if ( r.variables.ssl_protocol !== undefined ) {
        connection.ssl = sslInfo(r);
    }

    var request = {
        "client": r.variables.remote_addr,
        "port": Number(r.variables.server_port),
        "host": r.variables.host,
        "method": r.method,
        "uri": r.uri,
        "http_version": Number(r.httpVersion),
        "bytes_received": Number(r.variables.request_length)
    };
    request.headers = {};
    for (var h in r.headersIn) {
        request.headers[h] = r.headersIn[h];
    }

    var upstreams = [];
    if ( r.variables.upstream_status !== undefined ) {
        upstreams = upstreamArray(r);
    }

    var response = {
        "status": Number(r.variables.status),
        "bytes_sent": Number(r.variables.bytes_sent),
    }
    response.headers = {};
    for (var h in r.headersOut) {
        response.headers[h] = r.headersOut[h];
    }

    return JSON.stringify({
        "timestamp": r.variables.time_iso8601,
        "connection": connection,
        "request": request,
        "upstreams": upstreams,
        "response": response
    });
}

function sslInfo(r) {
    var ssl = {
        "protocol": r.variables.ssl_protocol,
        "cipher": r.variables.ssl_cipher,
        "session_id": r.variables.ssl_session_id
    }
    if ( r.variables.ssl_session_reused  == 'r' ) {
        ssl.session_reused = true;
    } else {
        ssl.session_reused = false;
    }
    if ( r.variables.ssl_protocol == 'TLSv1.3' ) {
        if ( r.variables.ssl_early_data == '1' ) {
            ssl.zero_rtt = true;
        } else {
            ssl.zero_rtt = false;
        }
    }
    ssl.client_cert = clientCert(r);
    return ssl;
}

function clientCert(r) {
    var clientCert = {};
    clientCert.status = r.variables.ssl_client_verify;
    clientCert.serial = r.variables.ssl_client_serial;
    clientCert.fingerprint = r.variables.ssl_client_fingerprint;
    clientCert.subject = r.variables.ssl_client_s_dn;
    clientCert.issuer = r.variables.ssl_client_i_dn;
    clientCert.starts = r.variables.ssl_client_v_start;
    clientCert.expires = r.variables.ssl_client_v_end;
    if ( r.variables.ssl_client_v_remain == 0 ) {
        clientCert.expired = true;
    } else if ( r.variables.ssl_client_v_remain > 0) {
        clientCert.expired = false;
    }
    clientCert.pem = r.variables.ssl_client_raw_cert;

    return clientCert;
}

function upstreamArray(r) {
    var addr = r.variables.upstream_addr.split(', ');
    var connect_time = r.variables.upstream_connect_time.split(', ');
    var header_time = r.variables.upstream_header_time.split(', ');
    var response_time = r.variables.upstream_response_time.split(', ');
    var bytes_received = r.variables.upstream_bytes_received.split(', ');
    var bytes_sent = r.variables.upstream_bytes_sent.split(', ');
    var status = r.variables.upstream_status.split(', ');

    var i, addr_port, upstream = [];
    for (i=0; i < status.length; i++) {
        upstream[i] = {};
        addr_port = addr[i].split(':');
        if (addr_port[0] == "unix") {
            upstream[i].unix_socket = addr_port[1];
        } else {
            upstream[i].server_addr = addr_port[0];
            upstream[i].server_port = Number(addr_port[1]);
        }
        upstream[i].connect_time = Number(connect_time[i]);
        if (isNaN(upstream[i].connect_time)) upstream[i].connect_time = null;
        upstream[i].header_time = Number(header_time[i]);
        if (isNaN(upstream[i].header_time)) upstream[i].header_time = null;
        upstream[i].response_time = Number(response_time[i]);
        if (isNaN(upstream[i].response_time)) upstream[i].response_time = null;
        upstream[i].bytes_sent = Number(bytes_sent[i]);
        upstream[i].bytes_received = Number(bytes_received[i]);
        upstream[i].status = Number(status[i]);

        if (upstream[i].status == 502 && upstream[i].connect_time === null && upstream[i].response_time > 0) {
            upstream[i].info = "Connection failed / SSL error";
        }
        if (upstream[i].status == 502 && upstream[i].connect_time === null && upstream[i].response_time == 0) {
            upstream[i].info = "Not attempted / temporarily disabled";
        }
    }

    return upstream;
}
