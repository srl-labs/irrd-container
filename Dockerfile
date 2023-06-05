FROM python:3.9-alpine as builder

RUN apk add --virtual .build-deps \
    build-base linux-headers musl-dev gcc postgresql-dev

RUN pip install -U pip && pip install wheel

WORKDIR /wheels

ARG IRRD_VERSION
RUN pip wheel irrd==${IRRD_VERSION} --wheel-dir .

# Final image
FROM python:3.9-alpine
COPY --from=builder /wheels /wheels

RUN pip install --no-cache-dir /wheels/*

CMD ["/usr/local/bin/irrd"]
