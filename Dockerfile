# Use python:3.10-alpine as base image
FROM python:3.10-alpine

# Set the working directory
WORKDIR /

# Copy package.json and package-lock.json
COPY package*.json ./

# Install Node.js packages
RUN apk add --no-cache nodejs npm
RUN npm ci

# Copy the rest of the application code
COPY . .

# Install python packages
RUN apk add --no-cache python3 \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --upgrade pip setuptools  \
    && ln -s pip3 /usr/bin/pip \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && rm -r /root/.cache

# install python packages
COPY requirements.txt .
RUN pip install -r requirements.txt

# Build the React application
RUN npm run build

# Collect the Django static files
RUN python manage.py collectstatic --noinput

# Expose the port the application will run on
EXPOSE 8000

# Run the application
CMD ["gunicorn", "todo.wsgi:application", "-b", "0.0.0.0:8000"]
