FROM python:3.12-slim

WORKDIR /app

# 复制 pyproject.toml 和 uv.lock（加速构建）
COPY pyproject.toml uv.lock ./

# 安装 uv 并同步依赖
RUN pip install uv && uv venv && uv sync

# 复制代码
COPY . .

# 允许非 root 用户
RUN adduser --disabled-password --gecos '' fastapiuser && chown -R fastapiuser /app
USER fastapiuser

# 直接使用虚拟环境的 uvicorn
CMD [".venv/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
