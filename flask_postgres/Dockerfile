FROM python:3.8.11-alpine3.14

RUN apk update 
RUN apk add --no-cache postgresql-dev gcc python3-dev musl-dev

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app/

EXPOSE 8081

ENTRYPOINT ["python"]

CMD ["app.py"]
