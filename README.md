# varnish-cache-run
This project can be used as an out-of-the-box module, quickly use Varnish to build a reference http cache module.

# Quick Start
1 Configuration  
start.sh: see note  
conf/default.vcl: config .host

2 Install, start, close, reload configuration
```
>> sh install.sh
>> sh start.sh # Start the service
>> sh stop.sh # Shut down the service
>> ps -ef | grep varnish # Confirm whether the service process is started
>> docker logs varnish # Start failed to view the log
>> sh reload-vcl.sh # Reload configuration
```

# Help
1 View service status (common indicators have been filtered)  
```
>> sh stat.sh
```

2 How to confirm whether the request is cached or obtained from the source?  
1) View the response: header X-Hits hit age
2) Monitoring network traffic

3 How to delete the designated cache?  
curl http://localhost:8080/jpeg/35179a49-eade-4fae-8957-1a7da24259c9.jpeg -XPURGE

4 What happens if the amount of cached files exceeds the cache setting size?  
When the cache space is not enough, it will automatically trigger the deletion of expired files first. If the space is not enough, use lru to delete inactive cache files.

5 Varnish memory usage?  
In the file mode, the file itself is cached on the disk, but in addition to the file itself, there are similar metadata structures that will be stored in the memory. According to the official statement, each file object occupies about 1k of memory.

6 Is the cache effective after varnish restarts?  
After varnish restarts, the cache is all invalid. If you need to modify the vcl file, it is recommended to use sh reload-vcl.sh to reload the configuration to avoid the cache invalidation caused by the restart

7 Open the log  
varnishlog or varnishncsa -a -w /etc/varnish/log/varnishncsa.log -D -c