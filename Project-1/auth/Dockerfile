#docker file for the auth service
FROM python:3.9-slim
#adding the path
WORKDIR /app
#copying the requirements to default
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "auth_service.py"]

