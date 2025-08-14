FROM node:18-alpine

WORKDIR /app

# Install OS dependencies for building native Node modules
RUN apk add --no-cache g++ make python3

# Copy package.json first
COPY package.json ./

# Install dependencies
RUN npm install

# Copy app source
COPY . .

EXPOSE 3000

# Run with hot reload
CMD ["npm", "run", "dev"]