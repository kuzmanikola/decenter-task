FROM python:3.11-alpine AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.11-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    apk add --no-cache wget

WORKDIR /app

COPY --from=builder /root/.local /home/appuser/.local

COPY main.py .

RUN chown -R appuser:appgroup /app

USER appuser

ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 -O /dev/null http://localhost:3000/health || exit 1

CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000", "--log-level", "info", "--access-log"]

