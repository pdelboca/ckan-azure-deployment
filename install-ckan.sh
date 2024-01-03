#!/bin/bash -e

# Install CKAN from upstream and apply patches

CKAN_INSTALL_TAG=ckan-2.10.3

echo "------ Checking out upstream CKAN: $CKAN_INSTALL_TAG ------"
git clone -b "$CKAN_INSTALL_TAG" "https://github.com/ckan/ckan.git" "ckan"

cd "ckan"

echo "------ Applying local patches to upstream CKAN code ------"
for f in `ls ../patches/*.diff | sort -g`; do \
    echo "$0: Applying patch $f to CKAN core";
    patch -N -p1 < "$f" ; \
done

echo "------ Installing requirements ------"
pip3 install -q -r requirements.txt

echo "------ Installing CKAN ------"
pip3 install .
