##################################################################
# Define opencpu-server servers
# NOTE: we assume that all backends share the same R object store.
#

backend cpu1 {
  .host = "127.0.0.1";
  .port = "80";
  .max_connections = 20;
  .probe = {
    .url = "/R";
    .interval = 30s;
    .timeout = 2s;
    .window = 5;
    .threshold = 3;
  }
}

#Fake second backend that is always down :-)
backend cpu2 {
  .host = "123.123.123.123";
  .port = "80";
  .max_connections = 20;
  .probe = {
    .url = "/R";
    .interval = 30s;
    .timeout = 2s;
    .window = 5;
    .threshold = 3;
  }
}

director cpu_director round-robin {
  {
    .backend = cpu1;
  }
  {
    .backend = cpu2;
  }
}

sub vcl_recv {

  # The actual OpenCPU R backend it set here
  set req.backend = cpu_director;

  # For now we assume OpenCPU does support cookies
  if ( req.url ~ "^/R" ) {
    unset req.http.Cookie;
  }

  # Weird methods are directly piped through
  if (req.request != "GET" &&
    req.request != "HEAD" &&
    req.request != "PUT" &&
    req.request != "POST" &&
    req.request != "TRACE" &&
    req.request != "OPTIONS" &&
    req.request != "DELETE") {
    return (pipe);
  }

  # GET and HEAD requests are cached
  if (req.request != "GET" && req.request != "HEAD") {
    return (pass);
  }

  # Other methods are not cached.
  remove req.http.cookie;
  return (lookup);
}

### Error handling:
sub vcl_error {
  set obj.http.Content-Type = "text/plain; charset=utf-8";
  synthetic {"No R backends available... Please try again later."};
  return (deliver);
}

### Actual fetching of the backend
sub vcl_fetch {
  #Fetch from the opencpu backend:
  if ( beresp.status == 400 ) {
    set beresp.ttl = 1m;
    set beresp.http.cache-control = "public";
  }
  return (deliver);
}