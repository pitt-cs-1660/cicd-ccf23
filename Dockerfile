# Stage 1: Builder
FROM python:3.11-buster AS builder

# Set working directory
WORKDIR /app

COPY . .

# Install
RUN pip install --upgrade pip && pip install poetry

# Copy the application files to the builder
COPY pyproject.toml .
COPY poetry.lock .

# Build application
RUN poetry config virtualenvs.create false \
 && poetry install --no-root --no-interaction --no-ansi

# Stage 2: App
FROM python:3.11-buster AS app

# Set working directory
WORKDIR /app

# Copy the code from the /app directory in builder stage to the /app stage
COPY --from=builder /app /app

ENV PATH=$PATH:/app/.venv/bin/
# Command to run the application
CMD ["uvicorn", "cc_compose.server:app","--reload", "--host", "0.0.0.0", "--port", "8000"]
