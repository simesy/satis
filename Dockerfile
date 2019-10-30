# The image updated in quay.io/govcms/satis automatically when branches are updated in github.
# This image is referenced by Lagoon.

FROM amazeeio/nginx:latest

COPY app/ /app/
