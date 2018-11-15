
FROM python:3.5
MAINTAINER chopenkoval@gmail.com

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY . .

RUN python manage.py migrate
RUN chmod +x set_server.sh
RUN ./set_server.sh

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

HEALTHCHECK --interval=5s \
  CMD curl --fail http://localhost:8000 || exit 1  
