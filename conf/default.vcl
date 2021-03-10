vcl 4.0;
import std;

backend default {
  .host="host:port";
  .connect_timeout=30s;
}

acl local {
    "localhost";
    "172.17.0.2"/24;
}

sub vcl_recv {
  set req.http.x-method = req.method;
  if (req.method == "PURGE") {
    if (client.ip ~ local) {
       return(purge);
    } else {
       return(synth(403, "Access denied."));
    }
  }
  
  if (req.method == "GET" && req.url ~ "\.(js|css|jpg|jpeg|png|bmp|tif|svg|webp|gif|mp4|mp3|ts|m3u8)$") {
    unset req.http.Cookie;    
  }

  if (req.method == "GET" && req.url ~ "\.(ashx|aspx)") {
    unset req.http.Cookie;
  }

  if (req.method == "OPTIONS") {
    return (pass);
  }
 
  if (req.method == "POST" &&  req.url ~ "\.(jpeg|jpg|png|bmp|tif|svg|webp|gif|mp4|mp3|avi|txt|doc|docx|ppt|pptx|xls|xlsx|pdf)$") {
    unset req.http.Content-Type;
    set req.method = "GET";
  }

  if (req.http.Range ~ "bytes=") {
    set req.http.x-range = req.http.Range;
  }
}

sub vcl_hash {
  if (req.http.x-range ~ "bytes=") {
    hash_data(req.http.x-range);
    unset req.http.Range;
  }
}

sub vcl_backend_fetch {
  if (bereq.http.x-method == "POST" &&  bereq.url ~ "\.(jpeg|jpg|png|bmp|tif|svg|webp|gif|mp4|mp3|avi|txt|doc|docx|ppt|pptx|xls|xlsx|pdf)$") {
    unset bereq.body;
    unset bereq.http.Content-Type;
  }
  if (bereq.http.x-range) {
    set bereq.http.Range = bereq.http.x-range;
  }
}

sub vcl_backend_response {

  if ( beresp.status == 404 ) {
    set beresp.ttl = 60s;
    set beresp.uncacheable = true;
    return (deliver);
  }

  unset beresp.http.Cache-Control;
  unset beresp.http.Set-Cookie;
  set beresp.http.Cache-Control = "public";

  if (bereq.method == "GET" && bereq.url ~ "\.(js|css|jpeg|jpg|png|bmp|tif|svg|webp|gif)$") {
    set beresp.ttl = 2d;
  }
  elseif (bereq.method == "GET" && bereq.url ~ "\.(mp4|mp3|m3u8)$") {
    set beresp.ttl = 10d;
  }
  
  if (bereq.http.x-range ~ "bytes=" && beresp.status == 206) {
    set beresp.ttl = 2d;
    set beresp.http.CR = beresp.http.content-range;
  }
}

sub vcl_deliver {
  set resp.http.X-Hits = obj.hits;
  set resp.http.Cache-Control = "private";
  unset resp.http.X-Varnish;
  unset resp.http.Via;
  set resp.http.Expires = "" + (now + std.duration(resp.http.x-obj-ttl, 3600s));
  
  set resp.http.Access-Control-Allow-Origin = "*";
  set resp.http.Access-Control-Allow-Credentials = "true";

  if (resp.http.CR) {
    set resp.http.Content-Range = resp.http.CR;
    unset resp.http.CR;
  }
}

