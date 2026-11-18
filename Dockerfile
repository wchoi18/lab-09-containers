
FROM python:3.13-slim

LABEL org.opencontainers.image.title="book-analysis" \
      org.opencontainers.image.description="Lab 07 book analysis"

COPY --from=ghcr.io/astral-sh/uv:0.9.12 /uv /uvx /bin/

RUN useradd --create-home app

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-dev --no-install-project --no-cache --python /usr/local/bin/python

COPY src/ ./src/

ENV PATH="/app/.venv/bin:$PATH"

ENV PYTHONPATH="/app/src"

USER app

ENTRYPOINT ["python", "-m", "book_analysis.analyze"]

CMD ["--help"]
