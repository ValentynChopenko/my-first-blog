
FROM python:3.5
MAINTAINER chopenkoval@gmail.com

WORKDIR /usr/src/app
COPY app/requirements.txt .
RUN apt-get update && pip install -r requirements.txt
COPY app/ .

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

HEALTHCHECK --interval=5s \
  CMD curl --fail http://localhost:8000 || exit 1
