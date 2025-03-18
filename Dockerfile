# Step 1: Build the React app
FROM node:18 AS builder
WORKDIR /app
COPY package.json ./

COPY package-lock.json ./  

RUN test -f package-lock.json || (echo "package-lock.json missing!" && exit 1)

# Install dependencies
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

# Step 2: Serve the React app using Nginx
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]