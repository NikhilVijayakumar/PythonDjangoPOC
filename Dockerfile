FROM python:3.9-alpine3.13
LABEL maintainer="nikhil.vijaykumar@gmail.com"

ENV PYTHONUNBUFFERED 1

COPY ./app /app
WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

EXPOSE 8000
ARG DEV=false
#&& \
RUN python -m venv /py && \
 /py/bin/pip install --upgrade pip && \
 apk add --update --no-cache postgresql-client jpeg-dev && \
 apk add --update --no-cache --virtual .tmp-build-deps\
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
 /py/bin/pip install -r /tmp/requirements.txt && \
 if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
 rm -rf /tmp && \
 apk del .tmp-build-deps && \
 adduser \
        --disabled-password \
        --no-create-home \
        nikhil && \
 mkdir -p /vol/web/media && \
 mkdir -p /vol/web/static && \
 chown -R nikhil:nikhil /vol && \
 chmod -R 755 /vol
#RUN chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"

USER nikhil

CMD ["sh", "-c", "python manage.py runserver 0.0.0.0:8000 && python manage.py makemigrations && python manage.py migrate"]
