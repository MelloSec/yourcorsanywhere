# Test if it's requiring anything to proxy
curl http://127.0.0.1:8080/

# Test without Headers
curl http://127.0.0.1:8080/https://s3cur3th1ssh1t.github.io/

# Give S3cur3Th1sSh1t some love
curl -H "straylight: value" -H "security: value" http://127.0.0.1:8080/https://s3cur3th1ssh1t.github.io/
