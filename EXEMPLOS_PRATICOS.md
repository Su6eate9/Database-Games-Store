# 🎮 EXEMPLOS PRÁTICOS DE USO

Este documento contém exemplos práticos e tutoriais de como usar o banco de dados GameVault em cenários reais.

---

## 📋 Índice de Exemplos

1. [Cadastro de Novo Jogador](#1-cadastro-de-novo-jogador)
2. [Desenvolvedor Publicando Jogo](#2-desenvolvedor-publicando-jogo)
3. [Jogador Comprando Jogos](#3-jogador-comprando-jogos)
4. [Sistema de Avaliações](#4-sistema-de-avaliações)
5. [Desbloqueando Conquistas](#5-desbloqueando-conquistas)
6. [Relatórios Gerenciais](#6-relatórios-gerenciais)
7. [Análises Avançadas](#7-análises-avançadas)

---

## 1. Cadastro de Novo Jogador

### Cenário

Um novo usuário quer se registrar na plataforma como jogador.

### Passo a Passo

```sql
-- ============================================
-- EXEMPLO 1: Criar novo jogador completo
-- ============================================

BEGIN;

-- 1. Criar usuário base
INSERT INTO USUARIO (nome, email, senha, tipo_usuario)
VALUES ('Lucas Ferreira', 'lucas.ferreira@gmail.com', 'hash_senha_segura', 'JOGADOR')
RETURNING id_usuario;

-- Suponha que retornou id_usuario = 10

-- 2. Criar perfil de jogador
INSERT INTO JOGADOR (id_jogador, nivel, xp, data_nascimento, pais)
VALUES (10, 1, 0, '1998-06-15', 'Brasil');

COMMIT;

-- 3. Verificar cadastro
SELECT
    u.id_usuario,
    u.nome,
    u.email,
    j.nivel,
    j.xp,
    j.data_nascimento,
    j.pais
FROM USUARIO u
INNER JOIN JOGADOR j ON u.id_usuario = j.id_jogador
WHERE u.email = 'lucas.ferreira@gmail.com';
```

### Resultado Esperado

```
 id_usuario |      nome       |           email            | nivel | xp |  data_nasc | pais
------------+-----------------+----------------------------+-------+----+------------+--------
     10     | Lucas Ferreira  | lucas.ferreira@gmail.com   |   1   | 0  | 1998-06-15 | Brasil
```

---

## 2. Desenvolvedor Publicando Jogo

### Cenário

Um estúdio de jogos quer publicar um novo título na plataforma.

### Passo a Passo

```sql
-- ============================================
-- EXEMPLO 2: Publicar jogo completo com DLC
-- ============================================

BEGIN;

-- 1. Criar o jogo
INSERT INTO JOGO (titulo, descricao, preco, data_lancamento, classificacao_etaria, desenvolvedor_id)
VALUES (
    'Ninja Legends',
    'Jogo de ação ninja em terceira pessoa com gráficos realistas',
    159.90,
    '2024-03-15',
    '14+',
    5  -- Pixel Studio
)
RETURNING id_jogo;

-- Suponha que retornou id_jogo = 8

-- 2. Associar categorias (Ação e Aventura)
INSERT INTO JOGO_CATEGORIA (jogo_id, categoria_id) VALUES
(8, 1),  -- Ação
(8, 4);  -- Aventura

-- 3. Criar DLC
INSERT INTO DLC (nome, descricao, preco, data_lancamento, jogo_id)
VALUES (
    'Ninja Legends - Samurai Pack',
    'Adiciona 5 novos personagens samurais jogáveis',
    39.90,
    '2024-06-01',
    8
);

-- 4. Criar conquistas
INSERT INTO CONQUISTA (nome, descricao, xp_recompensa, jogo_id) VALUES
('Primeira Missão', 'Complete a primeira missão do jogo', 50, 8),
('Mestre Ninja', 'Complete todas as missões sem ser detectado', 200, 8),
('Colecionador', 'Colete todos os itens secretos', 150, 8);

COMMIT;

-- 5. Verificar publicação
SELECT
    j.titulo,
    j.preco,
    j.data_lancamento,
    d.nome_estudio,
    COUNT(DISTINCT c.id_categoria) AS num_categorias,
    COUNT(DISTINCT dlc.id_dlc) AS num_dlcs,
    COUNT(DISTINCT conq.id_conquista) AS num_conquistas
FROM JOGO j
INNER JOIN DESENVOLVEDOR d ON j.desenvolvedor_id = d.id_desenvolvedor
LEFT JOIN JOGO_CATEGORIA jc ON j.id_jogo = jc.jogo_id
LEFT JOIN CATEGORIA c ON jc.categoria_id = c.id_categoria
LEFT JOIN DLC dlc ON j.id_jogo = dlc.jogo_id
LEFT JOIN CONQUISTA conq ON j.id_jogo = conq.jogo_id
WHERE j.id_jogo = 8
GROUP BY j.id_jogo, j.titulo, j.preco, j.data_lancamento, d.nome_estudio;
```

### Resultado Esperado

```
     titulo      | preco  | data_lanc  |    estudio    | categorias | dlcs | conquistas
-----------------+--------+------------+---------------+------------+------+------------
 Ninja Legends   | 159.90 | 2024-03-15 | Pixel Studio  |     2      |  1   |     3
```

---

## 3. Jogador Comprando Jogos

### Cenário

Jogador quer comprar 2 jogos e 1 DLC em uma única transação.

### Passo a Passo

```sql
-- ============================================
-- EXEMPLO 3: Compra com múltiplos itens
-- ============================================

BEGIN;

-- 1. Verificar desconto do jogador
SELECT
    u.nome,
    j.nivel,
    calcular_desconto_jogador(j.id_jogador) AS desconto_pct
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
WHERE j.id_jogador = 1;

-- Resultado: Carlos Silva, nível 15, desconto 5%

-- 2. Calcular preços com desconto
SELECT
    id_jogo,
    titulo,
    preco,
    ROUND(preco * 0.95, 2) AS preco_com_desconto  -- 5% de desconto
FROM JOGO
WHERE id_jogo IN (5, 6);  -- Racing Champions e Puzzle Master

-- 3. Criar compra
INSERT INTO COMPRA (jogador_id, valor_total, metodo_pagamento)
VALUES (
    1,  -- Carlos Silva
    ROUND((179.90 + 39.90) * 0.95, 2),  -- Total com desconto
    'CARTAO_CREDITO'
)
RETURNING id_compra;

-- Suponha que retornou id_compra = 10

-- 4. Adicionar itens da compra
INSERT INTO ITEM_COMPRA (compra_id, tipo_item, item_id, preco_pago) VALUES
(10, 'JOGO', 5, ROUND(179.90 * 0.95, 2)),  -- Racing Champions
(10, 'JOGO', 6, ROUND(39.90 * 0.95, 2));    -- Puzzle Master

COMMIT;

-- 5. Confirmar compra e ver biblioteca atualizada
SELECT
    c.id_compra,
    c.data_compra,
    c.valor_total,
    COUNT(ic.id_item) AS itens_comprados,
    STRING_AGG(j.titulo, ', ') AS jogos
FROM COMPRA c
INNER JOIN ITEM_COMPRA ic ON c.id_compra = ic.compra_id
INNER JOIN JOGO j ON ic.item_id = j.id_jogo AND ic.tipo_item = 'JOGO'
WHERE c.id_compra = 10
GROUP BY c.id_compra, c.data_compra, c.valor_total;
```

### Resultado Esperado

```
 id_compra |    data_compra      | valor_total | itens | jogos
-----------+---------------------+-------------+-------+-----------------------------------
    10     | 2024-12-23 10:30:00 |   208.81    |   2   | Racing Champions, Puzzle Master
```

---

## 4. Sistema de Avaliações

### Cenário

Jogador quer avaliar um jogo que comprou.

### Passo a Passo

```sql
-- ============================================
-- EXEMPLO 4: Avaliar jogo e ver média atualizada
-- ============================================

-- 1. Verificar se o jogador possui o jogo
SELECT jogador_possui_jogo(1, 5) AS possui_jogo;
-- Resultado: true

-- 2. Ver média atual do jogo
SELECT titulo, media_avaliacoes, preco
FROM JOGO
WHERE id_jogo = 5;
-- Resultado: Racing Champions, 0.00, 179.90

BEGIN;

-- 3. Inserir avaliação
INSERT INTO AVALIACAO (jogador_id, jogo_id, nota, comentario)
VALUES (
    1,
    5,
    5,
    'Simulador de corrida sensacional! Gráficos realistas e física perfeita.'
);

COMMIT;

-- 4. Ver média atualizada (trigger atualizou automaticamente)
SELECT titulo, media_avaliacoes, preco
FROM JOGO
WHERE id_jogo = 5;
-- Resultado: Racing Champions, 5.00, 179.90

-- 5. Ver todas as avaliações do jogo
SELECT
    u.nome AS jogador,
    a.nota,
    a.comentario,
    a.data_avaliacao
FROM AVALIACAO a
INNER JOIN JOGADOR j ON a.jogador_id = j.id_jogador
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
WHERE a.jogo_id = 5
ORDER BY a.data_avaliacao DESC;
```

### Resultado Esperado

```
   jogador    | nota |                      comentario                        |   data_avaliacao
--------------+------+-------------------------------------------------------+---------------------
 Carlos Silva |  5   | Simulador de corrida sensacional! Gráficos realistas..| 2024-12-23 11:00:00
```

---

## 5. Desbloqueando Conquistas

### Cenário

Jogador desbloqueia conquistas e ganha XP automaticamente.

### Passo a Passo

```sql
-- ============================================
-- EXEMPLO 5: Sistema de conquistas e XP
-- ============================================

-- 1. Ver status atual do jogador
SELECT
    u.nome,
    j.nivel,
    j.xp,
    COUNT(jc.conquista_id) AS conquistas_desbloqueadas
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
LEFT JOIN JOGADOR_CONQUISTA jc ON j.id_jogador = jc.jogador_id
WHERE j.id_jogador = 2  -- Ana Santos
GROUP BY u.nome, j.nivel, j.xp;
-- Resultado: Ana Santos, nível 8, 720 XP, 2 conquistas

-- 2. Ver conquistas disponíveis em um jogo
SELECT
    c.id_conquista,
    c.nome,
    c.descricao,
    c.xp_recompensa,
    CASE
        WHEN jc.jogador_id IS NOT NULL THEN '✓ Desbloqueada'
        ELSE '✗ Bloqueada'
    END AS status
FROM CONQUISTA c
LEFT JOIN JOGADOR_CONQUISTA jc ON c.id_conquista = jc.conquista_id AND jc.jogador_id = 2
WHERE c.jogo_id = 4  -- Space Strategy
ORDER BY c.xp_recompensa DESC;

BEGIN;

-- 3. Desbloquear conquista (trigger adicionará XP automaticamente)
INSERT INTO JOGADOR_CONQUISTA (jogador_id, conquista_id)
VALUES (2, 9);  -- Conquistador Galáctico: 100 XP

COMMIT;

-- Mensagem do trigger: "Jogador 2 ganhou 100 XP! XP total: 820, Nível: 9"

-- 4. Ver status atualizado
SELECT
    u.nome,
    j.nivel,
    j.xp,
    calcular_desconto_jogador(j.id_jogador) AS desconto_pct,
    COUNT(jc.conquista_id) AS conquistas_totais
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
LEFT JOIN JOGADOR_CONQUISTA jc ON j.id_jogador = jc.jogador_id
WHERE j.id_jogador = 2
GROUP BY u.nome, j.nivel, j.xp, j.id_jogador;
```

### Resultado Esperado

```
    nome     | nivel | xp  | desconto | conquistas
-------------+-------+-----+----------+------------
 Ana Santos  |   9   | 820 |   0.00   |     3
```

---

## 6. Relatórios Gerenciais

### Exemplo 6.1: Dashboard de Vendas

```sql
-- ============================================
-- Dashboard completo de vendas
-- ============================================

SELECT
    'Total de Jogos Cadastrados' AS metrica,
    COUNT(*)::TEXT AS valor
FROM JOGO

UNION ALL

SELECT
    'Total de Vendas',
    COUNT(*)::TEXT
FROM COMPRA

UNION ALL

SELECT
    'Receita Total (R$)',
    TO_CHAR(SUM(valor_total), 'FM999,999.00')
FROM COMPRA

UNION ALL

SELECT
    'Ticket Médio (R$)',
    TO_CHAR(AVG(valor_total), 'FM999.00')
FROM COMPRA

UNION ALL

SELECT
    'Jogo Mais Vendido',
    (
        SELECT j.titulo
        FROM JOGO j
        INNER JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id AND ic.tipo_item = 'JOGO'
        GROUP BY j.id_jogo, j.titulo
        ORDER BY COUNT(*) DESC
        LIMIT 1
    )

UNION ALL

SELECT
    'Melhor Desenvolvedor (Receita)',
    (
        SELECT d.nome_estudio
        FROM DESENVOLVEDOR d
        INNER JOIN JOGO j ON d.id_desenvolvedor = j.desenvolvedor_id
        INNER JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id AND ic.tipo_item = 'JOGO'
        GROUP BY d.id_desenvolvedor, d.nome_estudio
        ORDER BY SUM(ic.preco_pago) DESC
        LIMIT 1
    );
```

### Exemplo 6.2: Análise de Jogadores

```sql
-- ============================================
-- Perfil dos jogadores
-- ============================================

SELECT
    'Total de Jogadores' AS metrica,
    COUNT(*)::TEXT AS valor
FROM JOGADOR

UNION ALL

SELECT
    'Nível Médio',
    TO_CHAR(AVG(nivel), 'FM999.0')
FROM JOGADOR

UNION ALL

SELECT
    'XP Médio',
    TO_CHAR(AVG(xp), 'FM9999')
FROM JOGADOR

UNION ALL

SELECT
    'Compras por Jogador',
    TO_CHAR(
        (SELECT COUNT(*) FROM COMPRA)::NUMERIC /
        NULLIF((SELECT COUNT(*) FROM JOGADOR), 0),
        'FM99.0'
    )

UNION ALL

SELECT
    'Jogador Mais Ativo',
    (
        SELECT u.nome
        FROM JOGADOR j
        INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
        ORDER BY j.xp DESC
        LIMIT 1
    );
```

---

## 7. Análises Avançadas

### Exemplo 7.1: Análise de Conversão

```sql
-- ============================================
-- Quais jogadores compraram e avaliaram?
-- ============================================

WITH jogadores_compradores AS (
    SELECT DISTINCT jogador_id
    FROM COMPRA
),
jogadores_avaliadores AS (
    SELECT DISTINCT jogador_id
    FROM AVALIACAO
)

SELECT
    (SELECT COUNT(*) FROM JOGADOR) AS total_jogadores,
    (SELECT COUNT(*) FROM jogadores_compradores) AS compradores,
    (SELECT COUNT(*) FROM jogadores_avaliadores) AS avaliadores,
    ROUND(
        (SELECT COUNT(*) FROM jogadores_compradores)::NUMERIC /
        (SELECT COUNT(*) FROM JOGADOR) * 100, 2
    ) AS taxa_conversao_compra,
    ROUND(
        (SELECT COUNT(*) FROM jogadores_avaliadores)::NUMERIC /
        (SELECT COUNT(*) FROM jogadores_compradores) * 100, 2
    ) AS taxa_avaliacao;
```

### Exemplo 7.2: Análise de Retenção

```sql
-- ============================================
-- Jogadores que compraram mais de uma vez
-- ============================================

SELECT
    u.nome AS jogador,
    j.nivel,
    COUNT(c.id_compra) AS total_compras,
    SUM(c.valor_total) AS valor_total_gasto,
    MIN(c.data_compra) AS primeira_compra,
    MAX(c.data_compra) AS ultima_compra,
    EXTRACT(DAY FROM (MAX(c.data_compra) - MIN(c.data_compra))) AS dias_como_cliente
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
INNER JOIN COMPRA c ON j.id_jogador = c.jogador_id
GROUP BY j.id_jogador, u.nome, j.nivel
HAVING COUNT(c.id_compra) > 1
ORDER BY total_compras DESC;
```

### Exemplo 7.3: Análise de Categorias Populares

```sql
-- ============================================
-- Categorias mais vendidas
-- ============================================

SELECT
    cat.nome AS categoria,
    COUNT(DISTINCT j.id_jogo) AS jogos_categoria,
    COUNT(ic.id_item) AS vendas,
    SUM(ic.preco_pago) AS receita_total,
    ROUND(AVG(j.media_avaliacoes), 2) AS media_avaliacoes,
    ROUND(AVG(ic.preco_pago), 2) AS preco_medio
FROM CATEGORIA cat
INNER JOIN JOGO_CATEGORIA jc ON cat.id_categoria = jc.categoria_id
INNER JOIN JOGO j ON jc.jogo_id = j.id_jogo
LEFT JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id AND ic.tipo_item = 'JOGO'
GROUP BY cat.id_categoria, cat.nome
HAVING COUNT(ic.id_item) > 0
ORDER BY vendas DESC;
```

### Exemplo 7.4: Ranking de Desenvolvedores

```sql
-- ============================================
-- Desenvolvedores mais bem avaliados
-- ============================================

SELECT
    d.nome_estudio,
    COUNT(DISTINCT j.id_jogo) AS jogos_publicados,
    COUNT(ic.id_item) AS vendas_totais,
    SUM(ic.preco_pago) AS receita_total,
    ROUND(AVG(j.media_avaliacoes), 2) AS media_avaliacoes,
    COUNT(DISTINCT a.id_avaliacao) AS total_avaliacoes
FROM DESENVOLVEDOR d
INNER JOIN JOGO j ON d.id_desenvolvedor = j.desenvolvedor_id
LEFT JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id AND ic.tipo_item = 'JOGO'
LEFT JOIN AVALIACAO a ON j.id_jogo = a.jogo_id
GROUP BY d.id_desenvolvedor, d.nome_estudio
ORDER BY media_avaliacoes DESC, vendas_totais DESC;
```

---

## 🎯 Casos de Uso Completos

### Caso 1: Campanha de Black Friday

```sql
-- ============================================
-- Aplicar desconto especial de 30% em todos os jogos
-- ============================================

-- 1. Criar tabela temporária com preços promocionais
CREATE TEMP TABLE precos_black_friday AS
SELECT
    id_jogo,
    titulo,
    preco AS preco_original,
    ROUND(preco * 0.70, 2) AS preco_promocional,
    ROUND(preco * 0.30, 2) AS desconto_valor
FROM JOGO;

-- 2. Ver ofertas
SELECT * FROM precos_black_friday ORDER BY desconto_valor DESC;

-- 3. Simular vendas na Black Friday
-- (Usar preco_promocional nas compras)
```

### Caso 2: Sistema de Recomendações

```sql
-- ============================================
-- Recomendar jogos baseado no histórico de compras
-- ============================================

WITH jogos_comprados AS (
    -- Jogos que o jogador já tem
    SELECT DISTINCT ic.item_id AS jogo_id
    FROM COMPRA c
    INNER JOIN ITEM_COMPRA ic ON c.id_compra = ic.compra_id
    WHERE c.jogador_id = 1 AND ic.tipo_item = 'JOGO'
),
categorias_preferidas AS (
    -- Categorias dos jogos que o jogador tem
    SELECT DISTINCT jc.categoria_id
    FROM jogos_comprados jc_inner
    INNER JOIN JOGO_CATEGORIA jc ON jc_inner.jogo_id = jc.jogo_id
)

-- Recomendar jogos das mesmas categorias que o jogador ainda não tem
SELECT
    j.id_jogo,
    j.titulo,
    j.preco,
    j.media_avaliacoes,
    STRING_AGG(c.nome, ', ') AS categorias
FROM JOGO j
INNER JOIN JOGO_CATEGORIA jc ON j.id_jogo = jc.jogo_id
INNER JOIN CATEGORIA c ON jc.categoria_id = c.id_categoria
WHERE jc.categoria_id IN (SELECT categoria_id FROM categorias_preferidas)
  AND j.id_jogo NOT IN (SELECT jogo_id FROM jogos_comprados)
GROUP BY j.id_jogo, j.titulo, j.preco, j.media_avaliacoes
ORDER BY j.media_avaliacoes DESC, j.preco ASC
LIMIT 5;
```

---

## 🔧 Manutenção e Administração

### Backup Completo

```sql
-- Via linha de comando
pg_dump -U postgres -d gamevault_db -F c -f gamevault_backup.dump
```

### Restauração

```sql
-- Via linha de comando
pg_restore -U postgres -d gamevault_db -c gamevault_backup.dump
```

### Limpeza de Dados Antigos

```sql
-- Deletar avaliações antigas (exemplo: mais de 1 ano)
DELETE FROM AVALIACAO
WHERE data_avaliacao < CURRENT_DATE - INTERVAL '1 year';
```

---

## 📊 Conclusão

Estes exemplos demonstram o uso prático do banco de dados GameVault em diversos cenários reais:

✅ Cadastros e registros  
✅ Transações comerciais  
✅ Sistema de gamificação  
✅ Relatórios gerenciais  
✅ Análises avançadas  
✅ Recomendações inteligentes

**Use estes exemplos como base para criar suas próprias funcionalidades!**
