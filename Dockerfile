FROM python:3.6.5-slim-stretch as builder
MAINTAINER Rémy Greinhofer <remy.greinhofer@requestyoracks.org>

# Update the package list.
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Switch to the directory containing the code.
WORKDIR /usr/src/app

# Copy the code base.
COPY . .

# Build the packages.
RUN python setup.py bdist_wheel

###
# Create the release image.
FROM python:3.6.5-slim-stretch
MAINTAINER Rémy Greinhofer <remy.greinhofer@requestyoracks.org>

# Copy the package and install it.
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/dist /usr/src/app
RUN pip install --no-cache-dir api-*-py3-none-any.whl

# Create unprivileged user for celery.
# RUN adduser --disabled-password --gecos '' celery

# Copy entry point.
COPY docker/docker-entrypoint.sh /

# Define entrypoint.
ENTRYPOINT ["/docker-entrypoint.sh"]
