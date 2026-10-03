# ============================================================================
#  Blue Knight Gate — Render edition, Docker build
#
#  render.yaml deploys this project with Render's native Node runtime, which is
#  the simplest path and needs nothing from this file.
#
#  Use this Dockerfile only if you prefer an image build (for example to pin the
#  OS or add packages). To switch: in render.yaml change
#      runtime: node   ->   runtime: docker
#  and delete the buildCommand / startCommand lines (Docker ignores them).
# ============================================================================
FROM node:22-bookworm-slim

# tar        -> unpacking the sing-box release archive (spawned by the app)
# ca-certificates -> HTTPS downloads of sing-box / Xray-core from GitHub
RUN apt-get update \
 && apt-get install -y --no-install-recommends tar ca-certificates \
 && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY index.js ./
COPY assets ./assets

# Render injects PORT (10000 by default) and expects the service to bind it on 0.0.0.0.
# The app reads PORT itself; this is only a sensible default for local `docker run`.
ENV PORT=10000
EXPOSE 10000

CMD ["node", "index.js"]
