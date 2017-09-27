# Aerostat

## Development

Start server:
```
docker-compose up app
```

## Deploy

Make sure Docker daemon is running.

```
eval $(docker-machine env <production-server>)
docker-compose -f containers/production/docker-compose.yml --project-directory . build app
docker-compose down
docker-compose -f containers/production/docker-compose.yml --project-directory . up -d
```
