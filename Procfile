web: gunicorn todo.wsgi --bind 0.0.0.0:$PORT
worker: cd frontend && npm run build && cd ..