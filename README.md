# fluent bit 🐦 

Логер для отправки логов напрямую в ElasticSearch или Loki

Для развертывания используются GitLab CI/CD переменные

### Режим работы docker

Необходимо указать в ручном режиме данные docker соединения:

- `LOGGER_PREFIX` - регион/префикс для формирования индекса логов
- `DOCKER_TLS_VERIFY` - при использовании TLS соединения значение `true`
- `DOCKER_HOST` - хост docker машины в формате `tcp://[HOST]:[PORT]`
- `DOCKER_TLS_CA` - корневой сертификат docker машины
- `DOCKER_TLS_CERT` - сертификат клиента docker машины
- `DOCKER_TLS_KEY` - ключ клиента docker машины

### Режим работы pm2

Необходимо указать все переменные для работы логера:

- `LOGGER_PREFIX` - регион/префикс для формирования индекса логов
- `LOGGER_FILE` - файл для парсинга логов в режиме `tail`
- `LOGGER_SERVICE` - метка сервиса логов в поле `service`
- `LOGGER_HOST` - конечный хост ElasticSearch для приема логов в формате `domain.example`
- `LOGGER_PASSWORD` - ключ доступа до ElasticSearch через BasicAuth
