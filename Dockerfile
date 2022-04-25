FROM golang:alpine3.14

ENV CRAWL_GIT_REPO=https://github.com/manifoldfinance/discv4-dns-lists.git \
    CRAWL_GIT_BRANCH=master \
    CRAWL_GIT_PUSH=false \
    CRAWL_GIT_USER=crawler \
    CRAWL_GIT_EMAIL=janitor@manifoldfinance.com \
    CRAWL_DNS_DOMAIN=nodes.example.local \
    CRAWL_TIMEOUT=30m \
    CRAWL_INTERVAL=300 \
    CRAWL_RUN_ONCE=false \
    CRAWL_DNS_SIGNING_KEY=/secrets/key.json \
    CRAWL_DNS_PUBLISH_ROUTE53=false \
    ROUTE53_ZONE_ID="" \
    AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY="" \
    CRAWL_DNS_PUBLISH_CLOUDFLARE=false \
    CLOUDFLARE_API_TOKEN="" \
    CLOUDFLARE_ZONE_ID="" \
    CRAWL_PUBLISH_METRICS=false \
    INFLUXDB_URL=http://localhost:8086 \
    INFLUXDB_DB=metrics \
    INFLUXDB_USER=user \
    INFLUXDB_PASSWORD=password

RUN apk add --no-cache make gcc musl-dev linux-headers git curl jq

WORKDIR /crawler
COPY *.sh .

RUN /bin/sh /crawler/test.sh
CMD ["./entrypoint.sh"]
