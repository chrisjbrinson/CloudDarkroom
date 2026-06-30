FROM python:3.11-slim

WORKDIR /app

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app/app.py .
COPY common ./common
COPY scripts ./scripts

EXPOSE 5000

CMD ["ddtrace-run", "python", "app.py"]