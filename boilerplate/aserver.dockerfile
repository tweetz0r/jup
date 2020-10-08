FROM node:12-alpine AS base
WORKDIR /usr/src/%%PROJECTNAME%%
COPY package*.json ./

# Builder image used only for compiling Typescript files
FROM base as builder
RUN npm ci
COPY . .
RUN npm run compile

# Lean production image that just contains the dist directory (copied to the root of the workdir) and runtime dependencies
FROM base as prod
RUN npm ci --only=production
COPY --from=builder /usr/src/%%PROJECTNAME%%/dist .
ENV NODE_ENV=production
EXPOSE 8081 8081
CMD ["npm", "start"]