FROM python:3.12-slim AS build
WORKDIR /app
COPY requirements.txt .
COPY app/app.py .
COPY test/. ./test/
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim AS runner
RUN groupadd -r appuser && useradd -r -g appuser -m appuser
WORKDIR /app
COPY --chown=appuser:appuser . .
COPY --from=build /app/app.py .
USER appuser
EXPOSE 8080
CMD ["python", "app.py"]