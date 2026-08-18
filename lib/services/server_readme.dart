const String serverReadme = '''Servidor de integração (skeleton)

Este servidor é um POC para armazenar chaves de API em variáveis de ambiente e criar jobs mock para orquestração.

Como usar:
1. Na pasta server: npm install
2. Defina variável de ambiente ADMIN_TOKEN com um token secreto.
3. Rode: node index.js
4. Endpoints:
   - POST /api/keys { provider, key }  -> salvar chave (Authorization: Bearer ADMIN_TOKEN)
   - GET /api/keys -> listar chaves (Authorization)
   - POST /api/generate { provider, type, payload } -> criar job mock (Authorization)

Observação de segurança: este exemplo grava chaves em memória e nas variáveis do processo; em produção, utilize Secret Manager e um armazenamento seguro.
''';
