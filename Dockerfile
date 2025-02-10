FROM node:18-alpine

WORKDIR /app

# Copy root package files
COPY package.json pnpm-workspace.yaml ./
COPY packages/components/package.json ./packages/components/
COPY packages/shared/package.json ./packages/shared/
COPY packages/web/package.json ./packages/web/

# Install pnpm and dependencies
RUN npm install -g pnpm && \
    pnpm install

# Copy source code
COPY packages/components ./packages/components
COPY packages/shared ./packages/shared
COPY packages/web ./packages/web

# Build dependencies
RUN cd packages/components && pnpm run build && \
    cd ../shared && pnpm run build

# Build web
WORKDIR /app/packages/web
RUN pnpm run build

# Install serve to host the static files
RUN npm install -g serve

# Expose port
EXPOSE 3000

# Start the server
CMD ["serve", "-s", "dist", "-l", "tcp://0.0.0.0:3000"]
