#!/bin/bash

curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key=${TS_KEY}