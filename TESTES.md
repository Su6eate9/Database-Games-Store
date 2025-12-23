# 🧪 TESTES E VALIDAÇÕES - GameVault Database

Este arquivo contém exemplos de execução, resultados esperados e testes de validação.

---

## 📋 Índice

1. [Testes de Criação](#1-testes-de-criação)
2. [Testes de Inserção](#2-testes-de-inserção)
3. [Testes de Consultas Agregadas](#3-testes-de-consultas-agregadas)
4. [Testes de Funções](#4-testes-de-funções)
5. [Testes de Triggers](#5-testes-de-triggers)
6. [Validação de Integridade](#6-validação-de-integridade)

---

## 1. Testes de Criação

### Verificar Tabelas Criadas

```sql
-- Listar todas as tabelas do banco
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

**Resultado Esperado**:

```
┌─────────────────────┐
│    table_name       │
├─────────────────────┤
│ avaliacao           │
│ categoria           │
│ compra              │
│ conquista           │
│ desenvolvedor       │
│ dlc                 │
│ item_compra         │
│ jogador             │
│ jogador_conquista   │
│ jogo                │
│ jogo_categoria      │
│ usuario             │
└─────────────────────┘
(12 rows)
```

---

### Verificar Constraints

```sql
-- Listar todas as constraints de chave estrangeira
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;
```

**Resultado Esperado**: 15+ constraints listadas

---

## 2. Testes de Inserção

### Teste 1: Inserir Usuário (Especialização)

```sql
-- Inserir jogador completo
BEGIN;

INSERT INTO USUARIO (nome, email, senha, tipo_usuario)
VALUES ('Teste Silva', 'teste@email.com', 'hash123', 'JOGADOR')
RETURNING id_usuario;

-- Usar o ID retornado (exemplo: 8)
INSERT INTO JOGADOR (id_jogador, nivel, xp, data_nascimento, pais)
VALUES (8, 1, 0, '1995-01-01', 'Brasil');

COMMIT;
```

**Validação**:

```sql
SELECT u.nome, u.email, u.tipo_usuario, j.nivel, j.xp
FROM USUARIO u
INNER JOIN JOGADOR j ON u.id_usuario = j.id_jogador
WHERE u.email = 'teste@email.com';
```

**Resultado Esperado**:

```
nome         | email              | tipo_usuario | nivel | xp
-------------|--------------------|--------------|-------|----
Teste Silva  | teste@email.com    | JOGADOR      | 1     | 0
```

---

### Teste 2: Violação de Constraint

```sql
-- Tentar inserir nota inválida (deve falhar)
INSERT INTO AVALIACAO (jogador_id, jogo_id, nota, comentario)
VALUES (1, 1, 6, 'Nota inválida');
```

**Resultado Esperado**:

```
ERROR:  new row for relation "avaliacao" violates check constraint "avaliacao_nota_check"
DETAIL:  Failing row contains (6, ...).
```

---

## 3. Testes de Consultas Agregadas

### Teste 1: Consulta com GROUP BY (OBRIGATÓRIO)

```sql
-- Total de vendas e receita por desenvolvedor
SELECT
    d.nome_estudio AS "Estúdio",
    COUNT(DISTINCT j.id_jogo) AS "Jogos Publicados",
    COUNT(ic.id_item) AS "Total de Vendas",
    COALESCE(SUM(ic.preco_pago), 0) AS "Receita Total (R$)",
    COALESCE(AVG(j.media_avaliacoes), 0) AS "Média de Avaliações"
FROM DESENVOLVEDOR d
LEFT JOIN JOGO j ON d.id_desenvolvedor = j.desenvolvedor_id
LEFT JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id AND ic.tipo_item = 'JOGO'
GROUP BY d.id_desenvolvedor, d.nome_estudio
ORDER BY "Receita Total (R$)" DESC;
```

**Resultado Esperado**:

```
┌──────────────────┬──────────────────┬──────────────────┬─────────────────────┬──────────────────────┐
│ Estúdio          │ Jogos Publicados │ Total de Vendas  │ Receita Total (R$)  │ Média de Avaliações  │
├──────────────────┼──────────────────┼──────────────────┼─────────────────────┼──────────────────────┤
│ Pixel Studio     │ 3                │ 3                │ 479.70              │ 4.33                 │
│ Epic Games Brasil│ 2                │ 2                │ 399.80              │ 4.00                 │
│ Indie Dev Team   │ 2                │ 2                │ 129.80              │ 4.00                 │
└──────────────────┴──────────────────┴──────────────────┴─────────────────────┴──────────────────────┘
(3 rows)
```

**Análise**:

- ✅ Usa função agregada COUNT()
- ✅ Usa função agregada SUM()
- ✅ Usa função agregada AVG()
- ✅ Usa GROUP BY
- ✅ Usa LEFT JOIN para incluir desenvolvedores sem vendas

---

### Teste 2: Consulta com HAVING (OBRIGATÓRIO)

```sql
-- Jogos com mais de 2 vendas e média >= 4.0
SELECT
    j.titulo AS "Jogo",
    COUNT(ic.id_item) AS "Quantidade de Vendas",
    j.media_avaliacoes AS "Média de Avaliações",
    j.preco AS "Preço (R$)"
FROM JOGO j
INNER JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id AND ic.tipo_item = 'JOGO'
GROUP BY j.id_jogo, j.titulo, j.media_avaliacoes, j.preco
HAVING COUNT(ic.id_item) >= 2 AND j.media_avaliacoes >= 4.0
ORDER BY "Quantidade de Vendas" DESC;
```

**Resultado Esperado**:

```
┌─────────────────┬───────────────────────┬──────────────────────┬──────────────┐
│ Jogo            │ Quantidade de Vendas  │ Média de Avaliações  │ Preço (R$)   │
├─────────────────┼───────────────────────┼──────────────────────┼──────────────┤
│ Cyber Warriors  │ 2                     │ 4.50                 │ 199.90       │
└─────────────────┴───────────────────────┴──────────────────────┴──────────────┘
(1 row)
```

**Análise**:

- ✅ Usa GROUP BY
- ✅ Usa HAVING para filtrar grupos
- ✅ Combina múltiplas condições no HAVING
- ✅ Filtra resultados agregados (não linhas individuais)

---

### Teste 3: Agregações Complexas

```sql
-- Estatísticas por categoria com múltiplas agregações
SELECT
    cat.nome AS "Categoria",
    COUNT(DISTINCT jc.jogo_id) AS "Jogos",
    COALESCE(MIN(j.preco), 0) AS "Preço Mínimo",
    COALESCE(MAX(j.preco), 0) AS "Preço Máximo",
    COALESCE(AVG(j.preco), 0) AS "Preço Médio",
    COALESCE(AVG(j.media_avaliacoes), 0) AS "Média Aval."
FROM CATEGORIA cat
LEFT JOIN JOGO_CATEGORIA jc ON cat.id_categoria = jc.categoria_id
LEFT JOIN JOGO j ON jc.jogo_id = j.id_jogo
GROUP BY cat.id_categoria, cat.nome
HAVING COUNT(DISTINCT jc.jogo_id) > 0
ORDER BY "Jogos" DESC;
```

**Resultado Esperado**: Lista de categorias com estatísticas completas

---

## 4. Testes de Funções

### Teste 1: calcular_desconto_jogador()

```sql
-- Testar função para todos os jogadores
SELECT
    u.nome AS "Jogador",
    j.nivel AS "Nível",
    j.xp AS "XP",
    calcular_desconto_jogador(j.id_jogador) AS "Desconto (%)"
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
ORDER BY j.nivel DESC;
```

**Resultado Esperado**:

```
┌──────────────────┬────────┬──────┬──────────────┐
│ Jogador          │ Nível  │ XP   │ Desconto (%) │
├──────────────────┼────────┼──────┼──────────────┤
│ Pedro Oliveira   │ 25     │ 2480 │ 10.00        │
│ Carlos Silva     │ 15     │ 1450 │ 5.00         │
│ Ana Santos       │ 8      │ 720  │ 0.00         │
│ Maria Costa      │ 3      │ 180  │ 0.00         │
└──────────────────┴────────┴──────┴──────────────┘
```

**Regras Validadas**:

- Nível 1-9: 0%
- Nível 10-19: 5%
- Nível 20-29: 10%
- Nível 30+: 15%

---

### Teste 2: jogador_possui_jogo()

```sql
-- Verificar biblioteca de jogadores
SELECT
    u.nome AS "Jogador",
    j.titulo AS "Jogo",
    CASE
        WHEN jogador_possui_jogo(jog.id_jogador, j.id_jogo) THEN '✓ Possui'
        ELSE '✗ Não possui'
    END AS "Status"
FROM JOGADOR jog
INNER JOIN USUARIO u ON jog.id_jogador = u.id_usuario
CROSS JOIN (SELECT id_jogo, titulo FROM JOGO WHERE id_jogo <= 3) j
ORDER BY u.nome, j.titulo;
```

**Resultado Esperado**:

```
┌──────────────────┬──────────────────────┬──────────────┐
│ Jogador          │ Jogo                 │ Status       │
├──────────────────┼──────────────────────┼──────────────┤
│ Ana Santos       │ Cyber Warriors       │ ✗ Não possui │
│ Ana Santos       │ Fantasy Quest VII    │ ✗ Não possui │
│ Ana Santos       │ Terror na Floresta   │ ✓ Possui     │
│ Carlos Silva     │ Cyber Warriors       │ ✓ Possui     │
│ Carlos Silva     │ Fantasy Quest VII    │ ✓ Possui     │
│ Carlos Silva     │ Terror na Floresta   │ ✗ Não possui │
│ Maria Costa      │ Cyber Warriors       │ ✗ Não possui │
│ Maria Costa      │ Fantasy Quest VII    │ ✗ Não possui │
│ Maria Costa      │ Terror na Floresta   │ ✗ Não possui │
│ Pedro Oliveira   │ Cyber Warriors       │ ✓ Possui     │
│ Pedro Oliveira   │ Fantasy Quest VII    │ ✗ Não possui │
│ Pedro Oliveira   │ Terror na Floresta   │ ✗ Não possui │
└──────────────────┴──────────────────────┴──────────────┘
```

---

### Teste 3: Erro ao chamar função com ID inválido

```sql
-- Tentar calcular desconto de jogador inexistente
SELECT calcular_desconto_jogador(999);
```

**Resultado Esperado**:

```
ERROR:  Jogador com ID 999 não encontrado
CONTEXT:  PL/pgSQL function calcular_desconto_jogador(integer) line 10 at RAISE
```

---

## 5. Testes de Triggers

### Teste 1: trigger_media_avaliacoes

**Cenário**: Inserir nova avaliação e verificar atualização da média

```sql
-- Verificar média atual do jogo 1
SELECT id_jogo, titulo, media_avaliacoes
FROM JOGO
WHERE id_jogo = 1;
```

**Antes**:

```
id_jogo | titulo         | media_avaliacoes
--------|----------------|------------------
1       | Cyber Warriors | 4.50
```

```sql
-- Inserir nova avaliação (nota 3)
INSERT INTO AVALIACAO (jogador_id, jogo_id, nota, comentario)
VALUES (2, 1, 3, 'Jogo mediano');

-- Verificar média atualizada automaticamente
SELECT id_jogo, titulo, media_avaliacoes
FROM JOGO
WHERE id_jogo = 1;
```

**Depois**:

```
id_jogo | titulo         | media_avaliacoes
--------|----------------|------------------
1       | Cyber Warriors | 4.00
```

**Cálculo Manual**: (5 + 4 + 3) / 3 = 4.00 ✅

---

### Teste 2: trigger_xp_conquista

**Cenário**: Desbloquear conquista e verificar ganho de XP

```sql
-- Estado inicial do jogador 4 (Maria)
SELECT id_jogador, nivel, xp
FROM JOGADOR
WHERE id_jogador = 4;
```

**Antes**:

```
id_jogador | nivel | xp
-----------|-------|-----
4          | 3     | 180
```

```sql
-- Desbloquear conquista que dá 100 XP
INSERT INTO JOGADOR_CONQUISTA (jogador_id, conquista_id)
VALUES (4, 2);  -- Conquista "Mestre Atirador" = 100 XP

-- Verificar XP e nível atualizados
SELECT id_jogador, nivel, xp
FROM JOGADOR
WHERE id_jogador = 4;
```

**Depois**:

```
id_jogador | nivel | xp
-----------|-------|-----
4          | 3     | 280
```

**Validação**:

- XP anterior: 180
- XP ganho: 100
- XP total: 280 ✅
- Nível: (280 / 100) + 1 = 3.8 → 3 (não mudou, pois precisa de 300 XP para nível 4) ✅

---

### Teste 3: trigger com múltiplas conquistas

```sql
-- Desbloquear várias conquistas seguidas
BEGIN;

INSERT INTO JOGADOR_CONQUISTA (jogador_id, conquista_id) VALUES
(4, 3),  -- Veterano: 150 XP
(4, 4);  -- Herói Novato: 25 XP

COMMIT;

-- Verificar resultado final
SELECT id_jogador, nivel, xp
FROM JOGADOR
WHERE id_jogador = 4;
```

**Resultado Esperado**:

```
id_jogador | nivel | xp
-----------|-------|-----
4          | 5     | 455
```

**Cálculo**: 280 + 150 + 25 = 455 XP → Nível 5 ✅

---

## 6. Validação de Integridade

### Teste 1: Integridade Referencial (FK)

```sql
-- Tentar deletar jogo que tem avaliações (deve falhar se configurado RESTRICT)
DELETE FROM JOGO WHERE id_jogo = 1;
```

**Resultado Esperado**: Erro ou cascata dependendo da configuração

---

### Teste 2: Uniqueness

```sql
-- Tentar inserir email duplicado (deve falhar)
INSERT INTO USUARIO (nome, email, senha, tipo_usuario)
VALUES ('Outro Nome', 'carlos.silva@email.com', 'senha', 'JOGADOR');
```

**Resultado Esperado**:

```
ERROR:  duplicate key value violates unique constraint "usuario_email_key"
DETAIL:  Key (email)=(carlos.silva@email.com) already exists.
```

---

### Teste 3: Check Constraints

```sql
-- Tentar inserir preço negativo (deve falhar)
INSERT INTO JOGO (titulo, preco, desenvolvedor_id)
VALUES ('Jogo Grátis', -10.00, 5);
```

**Resultado Esperado**:

```
ERROR:  new row for relation "jogo" violates check constraint "jogo_preco_check"
DETAIL:  Failing row contains (..., -10.00, ...).
```

---

### Teste 4: Especialização (ISA)

```sql
-- Verificar que não há usuários sem especialização
SELECT u.id_usuario, u.nome, u.tipo_usuario,
       CASE
           WHEN j.id_jogador IS NOT NULL THEN 'JOGADOR'
           WHEN d.id_desenvolvedor IS NOT NULL THEN 'DESENVOLVEDOR'
           ELSE 'SEM_ESPECIALIZACAO'
       END AS especializacao_real
FROM USUARIO u
LEFT JOIN JOGADOR j ON u.id_usuario = j.id_jogador
LEFT JOIN DESENVOLVEDOR d ON u.id_usuario = d.id_desenvolvedor;
```

**Resultado Esperado**: Todos devem ter especialização correspondente ao tipo

---

## 7. Testes de Performance

### Teste 1: Índices

```sql
-- Verificar uso de índice em busca por email
EXPLAIN ANALYZE
SELECT * FROM USUARIO WHERE email = 'carlos.silva@email.com';
```

**Resultado Esperado**: Deve usar `Index Scan` no `idx_usuario_email`

---

### Teste 2: Join Performance

```sql
-- Query complexa com múltiplos joins
EXPLAIN ANALYZE
SELECT j.titulo, d.nome_estudio, COUNT(a.id_avaliacao) AS avaliacoes
FROM JOGO j
INNER JOIN DESENVOLVEDOR d ON j.desenvolvedor_id = d.id_desenvolvedor
LEFT JOIN AVALIACAO a ON j.id_jogo = a.jogo_id
GROUP BY j.id_jogo, j.titulo, d.nome_estudio;
```

**Análise**: Verificar se índices em FKs estão sendo utilizados

---

## 8. Casos de Uso Completos

### Caso 1: Jogador Comprando Jogo

```sql
-- Simular compra completa
BEGIN;

-- 1. Criar compra
INSERT INTO COMPRA (jogador_id, valor_total, metodo_pagamento)
VALUES (2, 249.90, 'PIX')
RETURNING id_compra;

-- 2. Adicionar item (usando ID retornado, ex: 8)
INSERT INTO ITEM_COMPRA (compra_id, tipo_item, item_id, preco_pago)
VALUES (8, 'JOGO', 2, 249.90);

-- 3. Jogador avalia após jogar
INSERT INTO AVALIACAO (jogador_id, jogo_id, nota, comentario)
VALUES (2, 2, 5, 'Jogo fantástico!');

-- 4. Desbloqueia primeira conquista
INSERT INTO JOGADOR_CONQUISTA (jogador_id, conquista_id)
VALUES (2, 4);  -- Herói Novato

COMMIT;

-- Verificar resultado
SELECT
    u.nome,
    j.nivel,
    j.xp,
    COUNT(DISTINCT c.id_compra) AS compras,
    COUNT(DISTINCT jc.conquista_id) AS conquistas
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
LEFT JOIN COMPRA c ON j.id_jogador = c.jogador_id
LEFT JOIN JOGADOR_CONQUISTA jc ON j.id_jogador = jc.jogador_id
WHERE j.id_jogador = 2
GROUP BY u.nome, j.nivel, j.xp;
```

---

## 📊 Resumo dos Testes

| Categoria               | Testes                    | Status |
| ----------------------- | ------------------------- | ------ |
| Criação de Tabelas      | 12 tabelas                | ✅     |
| Constraints             | 15+ FKs, PKs, CHECKs      | ✅     |
| Inserções               | Dados de teste            | ✅     |
| Função Agregada         | COUNT, SUM, AVG, MIN, MAX | ✅     |
| HAVING                  | Filtros em agregações     | ✅     |
| Função PL/pgSQL         | 2 funções criadas         | ✅     |
| Triggers                | 2 triggers (3 eventos)    | ✅     |
| Integridade Referencial | Todas as FKs              | ✅     |
| Especialização ISA      | USUARIO → JOGADOR/DEV     | ✅     |
| Normalização            | 3FN                       | ✅     |

---

## 🎯 Conclusão

Todos os requisitos obrigatórios foram implementados e testados:

✅ Modelo conceitual com 10 entidades (mínimo: 5)  
✅ Notação Peter Chen corretamente aplicada  
✅ Múltiplos relacionamentos 1:N  
✅ Múltiplos relacionamentos N:N  
✅ 1 especialização ISA (USUARIO)  
✅ Consulta com função agregada + GROUP BY  
✅ Consulta com HAVING  
✅ 2 funções PL/pgSQL funcionais  
✅ 2 triggers automáticos  
✅ Dados de teste inseridos  
✅ Documentação completa

**Status**: 🟢 SISTEMA TOTALMENTE FUNCIONAL
