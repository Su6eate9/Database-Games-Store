# 🚀 GUIA DE INSTALAÇÃO E EXECUÇÃO

Este guia fornece instruções passo a passo para instalar, configurar e executar o banco de dados GameVault.

---

## 📋 Pré-requisitos

### Software Necessário

1. **PostgreSQL 12 ou superior**

   - Download: https://www.postgresql.org/download/
   - Versões testadas: 12, 13, 14, 15, 16

2. **Cliente SQL** (escolha um):
   - **pgAdmin 4** (recomendado) - Interface gráfica
   - **psql** (linha de comando) - Incluído com PostgreSQL
   - **DBeaver** - Cliente universal
   - **VSCode** com extensão PostgreSQL

### Conhecimentos Recomendados

- SQL básico
- Conceitos de banco de dados relacional
- Linha de comando (opcional)

---

## 🔧 Instalação do PostgreSQL

### Windows

1. **Download**:

   - Acesse: https://www.postgresql.org/download/windows/
   - Baixe o instalador (PostgreSQL + pgAdmin)

2. **Instalação**:

   - Execute o instalador
   - Defina senha para o usuário `postgres` (anote essa senha!)
   - Porta padrão: `5434`
   - Instale Stack Builder (opcional)

3. **Verificar Instalação**:
   ```cmd
   psql --version
   ```
   Saída esperada: `psql (PostgreSQL) 16.x`

### Linux (Ubuntu/Debian)

```bash
# Atualizar repositórios
sudo apt update

# Instalar PostgreSQL
sudo apt install postgresql postgresql-contrib

# Verificar status
sudo systemctl status postgresql

# Criar senha para usuário postgres
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'sua_senha';"
```

### macOS

```bash
# Usando Homebrew
brew install postgresql@16

# Iniciar serviço
brew services start postgresql@16

# Verificar
psql --version
```

---

## 📦 Instalação do Banco GameVault

### Método 1: Usando pgAdmin (Recomendado para Iniciantes)

1. **Abrir pgAdmin**:

   - Inicie o pgAdmin 4
   - Conecte ao servidor PostgreSQL local
   - Senha: a que você definiu na instalação

2. **Criar Banco via Interface**:

   - Clique com botão direito em "Databases"
   - Selecione "Create" → "Database"
   - Nome: `gamevault_db`
   - Clique em "Save"

3. **Executar Script**:

   - Clique com botão direito em `gamevault_db`
   - Selecione "Query Tool"
   - Abra o arquivo `database.sql` (Ctrl+O)

   ⚠️ **IMPORTANTE**: As linhas 10-14 do arquivo contêm comandos específicos do psql. **Você tem 2 opções**:

   **Opção A (Recomendada)**: As linhas já estão comentadas, execute normalmente

   **Opção B**: Se as linhas não estiverem comentadas, delete ou comente estas linhas:

   ```sql
   -- DELETE ou COMENTE estas linhas no pgAdmin:
   DROP DATABASE IF EXISTS gamevault_db;
   CREATE DATABASE gamevault_db;
   -- \c gamevault_db;
   ```

   - Clique em "Execute" (F5)

4. **Verificar Criação**:
   - Navegue em: Databases → gamevault_db → Schemas → public → Tables
   - Deve ver 12 tabelas criadas

### Método 2: Usando psql (Linha de Comando)

```bash
# Navegar até a pasta do projeto
cd "C:\Users\aclau\Documents\Atlas\ufma\banco de dados\Database-Games-Store"

# Executar script completo
psql -U postgres -f database.sql

# Conectar ao banco
psql -U postgres -d gamevault_db

# Listar tabelas
\dt

# Sair
\q
```

### Método 3: Script Automatizado (Windows PowerShell)

Crie um arquivo `setup.ps1`:

```powershell
# setup.ps1
$env:PGPASSWORD = "sua_senha_aqui"

Write-Host "🎮 Instalando GameVault Database..." -ForegroundColor Cyan

# Executar script SQL
psql -U postgres -f database.sql

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Banco de dados criado com sucesso!" -ForegroundColor Green
    Write-Host "📊 Conecte-se em: psql -U postgres -d gamevault_db" -ForegroundColor Yellow
} else {
    Write-Host "❌ Erro na criação do banco!" -ForegroundColor Red
}

Remove-Item Env:\PGPASSWORD
```

Execute:

```powershell
.\setup.ps1
```

---

## ✅ Verificação da Instalação

### Verificar Tabelas

```sql
-- Conectar ao banco
\c gamevault_db

-- Listar todas as tabelas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

**Esperado**: 12 tabelas

### Verificar Dados

```sql
-- Contar registros em cada tabela
SELECT 'USUARIO' AS tabela, COUNT(*) AS registros FROM USUARIO
UNION ALL
SELECT 'JOGADOR', COUNT(*) FROM JOGADOR
UNION ALL
SELECT 'DESENVOLVEDOR', COUNT(*) FROM DESENVOLVEDOR
UNION ALL
SELECT 'JOGO', COUNT(*) FROM JOGO
UNION ALL
SELECT 'CATEGORIA', COUNT(*) FROM CATEGORIA
UNION ALL
SELECT 'DLC', COUNT(*) FROM DLC
UNION ALL
SELECT 'CONQUISTA', COUNT(*) FROM CONQUISTA
UNION ALL
SELECT 'COMPRA', COUNT(*) FROM COMPRA
UNION ALL
SELECT 'ITEM_COMPRA', COUNT(*) FROM ITEM_COMPRA
UNION ALL
SELECT 'AVALIACAO', COUNT(*) FROM AVALIACAO
UNION ALL
SELECT 'JOGADOR_CONQUISTA', COUNT(*) FROM JOGADOR_CONQUISTA
UNION ALL
SELECT 'JOGO_CATEGORIA', COUNT(*) FROM JOGO_CATEGORIA;
```

**Esperado**: Múltiplos registros em cada tabela

### Verificar Funções

```sql
-- Listar funções criadas
SELECT proname, prosrc
FROM pg_proc
WHERE proname LIKE 'calcular%' OR proname LIKE 'jogador%';
```

**Esperado**: 2+ funções listadas

### Verificar Triggers

```sql
-- Listar triggers
SELECT trigger_name, event_object_table, action_timing, event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public';
```

**Esperado**: 3+ triggers listados

---

## 🎮 Executando Consultas de Exemplo

### 1. Top 5 Jogos Mais Vendidos

```sql
SELECT
    j.titulo AS "Jogo",
    COUNT(ic.id_item) AS "Vendas",
    j.preco AS "Preço",
    j.media_avaliacoes AS "Avaliação"
FROM JOGO j
LEFT JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id AND ic.tipo_item = 'JOGO'
GROUP BY j.id_jogo
ORDER BY "Vendas" DESC
LIMIT 5;
```

### 2. Ranking de Jogadores

```sql
SELECT
    u.nome AS "Jogador",
    jog.nivel AS "Nível",
    jog.xp AS "XP",
    COUNT(DISTINCT jc.conquista_id) AS "Conquistas",
    calcular_desconto_jogador(jog.id_jogador) AS "Desconto (%)"
FROM JOGADOR jog
INNER JOIN USUARIO u ON jog.id_jogador = u.id_usuario
LEFT JOIN JOGADOR_CONQUISTA jc ON jog.id_jogador = jc.jogador_id
GROUP BY jog.id_jogador, u.nome, jog.nivel, jog.xp
ORDER BY jog.xp DESC;
```

### 3. Estatísticas por Desenvolvedor

```sql
SELECT
    d.nome_estudio AS "Estúdio",
    COUNT(DISTINCT j.id_jogo) AS "Jogos",
    COUNT(ic.id_item) AS "Vendas",
    COALESCE(SUM(ic.preco_pago), 0) AS "Receita (R$)"
FROM DESENVOLVEDOR d
LEFT JOIN JOGO j ON d.id_desenvolvedor = j.desenvolvedor_id
LEFT JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id AND ic.tipo_item = 'JOGO'
GROUP BY d.id_desenvolvedor, d.nome_estudio
ORDER BY "Receita (R$)" DESC;
```

---

## 🧪 Executando Testes

### Teste 1: Inserir Novo Jogador

```sql
BEGIN;

-- Criar usuário
INSERT INTO USUARIO (nome, email, senha, tipo_usuario)
VALUES ('Seu Nome', 'seu.email@example.com', 'hash_senha', 'JOGADOR')
RETURNING id_usuario;

-- Usar o ID retornado (exemplo: 8)
INSERT INTO JOGADOR (id_jogador, nivel, xp, data_nascimento, pais)
VALUES (8, 1, 0, '2000-01-01', 'Brasil');

COMMIT;

-- Verificar
SELECT u.nome, u.email, j.nivel, j.xp
FROM USUARIO u
INNER JOIN JOGADOR j ON u.id_usuario = j.id_jogador
WHERE u.email = 'seu.email@example.com';
```

### Teste 2: Simular Compra

```sql
BEGIN;

-- Criar compra para o jogador ID 8
INSERT INTO COMPRA (jogador_id, valor_total, metodo_pagamento)
VALUES (8, 199.90, 'PIX')
RETURNING id_compra;

-- Adicionar jogo à compra (usar ID retornado)
INSERT INTO ITEM_COMPRA (compra_id, tipo_item, item_id, preco_pago)
VALUES (9, 'JOGO', 1, 199.90);

COMMIT;

-- Verificar biblioteca
SELECT j.titulo, c.data_compra, ic.preco_pago
FROM COMPRA c
INNER JOIN ITEM_COMPRA ic ON c.id_compra = ic.compra_id
INNER JOIN JOGO j ON ic.item_id = j.id_jogo
WHERE c.jogador_id = 8;
```

### Teste 3: Testar Trigger de Conquista

```sql
-- Estado antes
SELECT nivel, xp FROM JOGADOR WHERE id_jogador = 8;

-- Desbloquear conquista
INSERT INTO JOGADOR_CONQUISTA (jogador_id, conquista_id)
VALUES (8, 1);  -- Primeira Vitória: 50 XP

-- Estado depois
SELECT nivel, xp FROM JOGADOR WHERE id_jogador = 8;
```

---

## 🛠️ Comandos Úteis do psql

```sql
-- Listar bancos de dados
\l

-- Conectar a um banco
\c gamevault_db

-- Listar tabelas
\dt

-- Descrever estrutura de uma tabela
\d JOGO

-- Listar funções
\df

-- Listar triggers
SELECT * FROM pg_trigger;

-- Executar arquivo SQL
\i database.sql

-- Exportar resultado para CSV
\copy (SELECT * FROM JOGO) TO 'jogos.csv' CSV HEADER

-- Limpar tela
\! clear  (Linux/Mac)
\! cls    (Windows)

-- Sair
\q
```

---

## 🔄 Resetar o Banco de Dados

### Método 1: Recriar do Zero

```sql
-- Deletar banco existente
DROP DATABASE IF EXISTS gamevault_db;

-- Executar script novamente
\i database.sql
```

### Método 2: Limpar Apenas os Dados

```sql
-- Desabilitar constraints temporariamente
SET session_replication_role = 'replica';

-- Truncar todas as tabelas
TRUNCATE TABLE
    JOGADOR_CONQUISTA, AVALIACAO, ITEM_COMPRA, COMPRA,
    JOGO_CATEGORIA, CONQUISTA, DLC, JOGO, CATEGORIA,
    JOGADOR, DESENVOLVEDOR, USUARIO
RESTART IDENTITY CASCADE;

-- Reabilitar constraints
SET session_replication_role = 'origin';

-- Executar apenas a parte de INSERT do script
-- (copiar comandos INSERT do database.sql)
```

---

## 🐛 Solução de Problemas

### Problema: "psql: command not found"

**Solução Windows**:

1. Adicionar PostgreSQL ao PATH:
   - Painel de Controle → Sistema → Variáveis de Ambiente
   - Adicionar: `C:\Program Files\PostgreSQL\16\bin`

**Solução Linux/Mac**:

```bash
# Adicionar ao ~/.bashrc ou ~/.zshrc
export PATH="/usr/local/opt/postgresql@16/bin:$PATH"
source ~/.bashrc
```

### Problema: "FATAL: password authentication failed"

**Solução**:

```bash
# Resetar senha do postgres
sudo -u postgres psql
ALTER USER postgres PASSWORD 'nova_senha';
\q
```

### Problema: "database already exists"

**Solução**:

```sql
-- Forçar recriação
DROP DATABASE IF EXISTS gamevault_db;
CREATE DATABASE gamevault_db;
\c gamevault_db
\i database.sql
```

### Problema: Porta 5432 em uso

**Solução**:

```bash
# Verificar processo
netstat -ano | findstr :5432   # Windows
lsof -i :5432                  # Linux/Mac

# Parar PostgreSQL
sudo systemctl stop postgresql  # Linux
brew services stop postgresql   # Mac
```

### Problema: Permissão negada

**Solução**:

```bash
# Dar permissões ao usuário
sudo -u postgres psql
GRANT ALL PRIVILEGES ON DATABASE gamevault_db TO seu_usuario;
\q
```

---

## 📚 Recursos Adicionais

### Documentação Oficial

- PostgreSQL: https://www.postgresql.org/docs/
- PL/pgSQL: https://www.postgresql.org/docs/current/plpgsql.html
- Triggers: https://www.postgresql.org/docs/current/trigger-definition.html

### Tutoriais Recomendados

- PostgreSQL Tutorial: https://www.postgresqltutorial.com/
- W3Schools SQL: https://www.w3schools.com/sql/
- SQLBolt: https://sqlbolt.com/

### Ferramentas Complementares

- **Mockaroo**: Gerar dados de teste - https://www.mockaroo.com/
- **dbdiagram.io**: Criar diagramas ER - https://dbdiagram.io/
- **PostgreSQL Exercises**: Praticar SQL - https://pgexercises.com/

---

## 📞 Suporte

### Erros Comuns

| Erro                        | Causa                 | Solução                    |
| --------------------------- | --------------------- | -------------------------- |
| `relation does not exist`   | Tabela não criada     | Executar script completo   |
| `duplicate key value`       | Chave única duplicada | Usar dados diferentes      |
| `violates check constraint` | Valor inválido        | Verificar regras da tabela |
| `permission denied`         | Sem permissão         | Executar como postgres     |

### Contato

- GitHub Issues: [Abrir issue](https://github.com)
- Documentação: Ver arquivos `.md` do projeto

---

## ✅ Checklist de Instalação

- [ ] PostgreSQL instalado e funcionando
- [ ] Senha do usuário `postgres` definida
- [ ] Arquivo `database.sql` baixado
- [ ] Banco `gamevault_db` criado
- [ ] Script executado sem erros
- [ ] 12 tabelas criadas
- [ ] Dados de teste inseridos
- [ ] Funções e triggers criados
- [ ] Consultas de exemplo testadas
- [ ] Backup criado (opcional)

---

## 🎉 Conclusão

Se você conseguiu executar todos os passos:

✅ Banco de dados instalado com sucesso!  
✅ Pronto para uso e testes  
✅ Documentação completa disponível

**Próximos passos**:

1. Explorar as consultas em `TESTES.md`
2. Criar suas próprias queries
3. Modificar e expandir o sistema
4. Adicionar novas funcionalidades

**Bom trabalho! 🚀**
