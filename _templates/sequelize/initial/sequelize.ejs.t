---
to: app/src/config/sequelize.json
---
{
  "development": {
    "username": "<%= dbUser %>",
    "password": "<%= dbPassword %>",
    "database": "<%= dbName %>",
    "host": "<%= dbHost %>",
    "dialect": "mysql"
  },
  "test": {
    "username": "<%= dbUser %>",
    "password": "<%= dbPassword %>",
    "database": "<%= dbName %>",
    "host": "<%= dbHost %>",
    "dialect": "mysql"
  },
  "production": {
    "username": "<%= dbUser %>",
    "password": "<%= dbPassword %>",
    "database": "<%= dbName %>",
    "host": "<%= dbHost %>",
    "dialect": "mysql"
  },
}
