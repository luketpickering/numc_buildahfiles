#!/bin/bash
podman build --layers=false --format=docker --tag picker24/lhapdf_5_9_1:debian_stretch .
podman tag localhost/picker24/lhapdf_5_9_1:debian_stretch docker.io/picker24/lhapdf_5_9_1:debian_stretch
podman tag localhost/picker24/lhapdf_5_9_1:debian_stretch docker.io/picker24/lhapdf_5_9_1:latest
