#!/bin/bash
podman build --layers=false --format=docker \
  --tag picker24/nuisance:debian_stretch \
  .

podman tag localhost/picker24/nuisance:debian_stretch docker.io/picker24/nuisance:debian_stretch
podman tag localhost/picker24/nuisance:debian_stretch docker.io/picker24/nuisance:latest