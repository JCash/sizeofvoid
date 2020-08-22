#!/usr/bin/env bash

CDN_DISTRIBUTION_ID=E3GGXA0G5G8HYG
aws cloudfront create-invalidation --distribution-id $CDN_DISTRIBUTION_ID --paths "/*"
