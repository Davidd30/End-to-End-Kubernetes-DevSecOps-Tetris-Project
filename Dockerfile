
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install --silent
COPY . .
# Build with PUBLIC_URL=/ so assets are referenced relatively for nginx
RUN if grep -q "\"build\"" package.json 2>/dev/null; then \
	PUBLIC_URL=/ npm run build; \
	fi

FROM nginx:stable-alpine AS runner
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
