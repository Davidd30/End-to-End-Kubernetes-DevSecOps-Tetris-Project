FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install --production --silent
COPY . .
# If a build script exists, run it (works for CRA or similar)
RUN if grep -q "\"build\"" package.json 2>/dev/null; then npm run build; fi

FROM nginx:stable-alpine AS runner
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]