FROM python:3.9

WORKDIR /PowerProbe

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["sh", "-c", "python manage.py runserver 0.0.0.0:8000 && python manage.py makemigrations && python manage.py migrate"]
