#!/bin/bash


if [[ -n $1 ]]; then
  curl ipinfo.io/$1
else
  curl ipinfo.io
fi

