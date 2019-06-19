
*Build*

```php
$ docker build -t speech-to-text -f Dockerfile ./
```

*Launch master*

```php
$ docker run -p 8989:8989 --name speech-to-text -it --privileged speech-to-text \
    sh -c 'cd /opt/kaldi-gstreamer-server && python kaldigstserver/master_server.py --port=8989'
```

*Launch worker*

```php
$ export MASTERIP=`docker exec -it speech-to-text ip -4 addr show scope global dev eth0 | grep inet | awk '{print $2}' | cut -d / -f 1`
$ docker run --name speech-to-text-worker -it --privileged speech-to-text \
    sh -c "cd /opt/kaldi-gstreamer-server && python kaldigstserver/worker.py -u ws://${MASTERIP}:8989/worker/ws/speech -c sample_english_nnet2.yaml"
```

*Speech To Text*

```php
$ wget https://raw.githubusercontent.com/alumae/kaldi-gstreamer-server/master/test/data/bill_gates-TED.mp3 -P /tmp
$ curl -T /tmp/bill_gates-TED.mp3 "http://localhost:8989/client/dynamic/recognize"
```

More example:

- client.py( **need to install python package** ): https://github.com/alumae/kaldi-gstreamer-server#server-usage
- REST API: https://github.com/alumae/kaldi-gstreamer-server#alternative-usage-through-a-http-api
