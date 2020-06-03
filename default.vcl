vcl 4.0;

import directors;
import std;

include "/etc/varnish/conf.d/badbots.vcl";
include "/etc/varnish/conf.d/blockip.vcl";
include "/etc/varnish/conf.d/nocache.vcl";

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "127.0.0.1";
    .port = "8080";
}

# Allow purge from localhost
acl purge {
    "localhost";
    "127.0.0.1";
}

# Define the director that determines how to distribute incoming requests.
sub vcl_init {
    new bar = directors.fallback();
    bar.add_backend(default);
}

sub vcl_recv {
    call badbots;
    call blockip;
    call nocache;

    set req.backend_hint = bar.backend();

    if (req.method == "PURGE") {
        if (!client.ip ~ purge) {
            return (synth(405, "Not allowed."));
        }
        return (purge);
    }
}

sub vcl_backend_response {
    if (beresp.status == 503 && bereq.retries < 5 ) {
        return(retry);
    }
}

sub vcl_backend_error {
    if (beresp.status == 503 && bereq.retries == 5) {
        synthetic(std.fileread("/etc/varnish/error503.html"));
        return(deliver);
    }
}

sub vcl_synth {
    if (resp.status == 503) {
        synthetic(std.fileread("/etc/varnish/error503.html"));
        return(deliver);
    }
}

sub vcl_deliver {
    if (resp.status == 503) {
        return(restart);
    }
}

sub vcl_pipe {
     # Note that only the first request to the backend will have
     # X-Forwarded-For set.  If you use X-Forwarded-For and want to
     # have it set for all requests, make sure to have:
     # set bereq.http.connection = "close";
     # here.  It is not set by default as it might break some broken web
     # applications, like IIS with NTLM authentication.

    set bereq.http.connection = "close";
    return (pipe);
}

# Routine used to determine the cache key if storing/retrieving a cached page.
sub vcl_hash {
    if (req.http.X-Forwarded-Proto) {
        hash_data(req.http.X-Forwarded-Proto);
    }
}
