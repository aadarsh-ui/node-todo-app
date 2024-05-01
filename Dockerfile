# -------------------------- Stage 1: Build Stage ---------------------------
FROM node:12.2.0-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json
#COPY . .
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Run tests
RUN npm run test

# ------------------------- Stage 2: Final Stage ---------------------------
FROM node:12.2.0-alpine

WORKDIR /app

# Copy built dependencies from the builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy application code from the builder stage
COPY --from=builder /app .

# Expose port 8000
EXPOSE 8000

# Command to run the application
CMD ["node", "app.js"]
