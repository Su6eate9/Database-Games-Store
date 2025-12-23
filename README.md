# 🎮 Database Games Store - Plataforma de Distribuição de Jogos Digitais

Modelagem completa de banco de dados para uma plataforma de distribuição de jogos digitais similar a Steam/Epic Games Store.

---

## 📋 1. DEFINIÇÃO DO PROBLEMA

### Contexto

A **GameVault** é uma plataforma de distribuição digital de jogos que conecta desenvolvedores e jogadores. A plataforma permite que desenvolvedores publiquem seus jogos, gerenciem DLCs e acompanhem vendas, enquanto jogadores podem comprar jogos, avaliar títulos, desbloquear conquistas e gerenciar sua biblioteca pessoal.

### Principais Funcionalidades

#### Para Jogadores:

- **Biblioteca Pessoal**: Comprar e gerenciar jogos adquiridos
- **Sistema de Avaliações**: Avaliar jogos com notas e comentários
- **Sistema de Conquistas**: Desbloquear achievements em jogos
- **Sistema de Níveis**: Ganhar XP com compras e conquistas
- **Wishlist**: Criar lista de desejos de jogos

#### Para Desenvolvedores:

- **Publicação de Jogos**: Adicionar jogos ao catálogo
- **Gerenciamento de DLCs**: Criar conteúdo adicional para jogos
- **Definição de Conquistas**: Criar achievements para engajar jogadores
- **Acompanhamento de Vendas**: Visualizar estatísticas de vendas

#### Sistema Geral:

- **Catálogo de Jogos**: Organização por categorias (Ação, RPG, Estratégia, etc.)
- **Sistema de Transações**: Registro completo de compras
- **Histórico de Atividades**: Rastreamento de ações dos usuários
- **Sistema de Preços**: Suporte a diferentes moedas e promoções

### Requisitos do Sistema

#### Funcionais:

- RF01: Sistema deve diferenciar entre Jogadores e Desenvolvedores
- RF02: Jogadores devem poder comprar múltiplos itens (jogos e DLCs)
- RF03: Jogos podem pertencer a múltiplas categorias
- RF04: Sistema deve calcular média de avaliações automaticamente
- RF05: Jogadores devem ganhar XP ao comprar jogos e desbloquear conquistas
- RF06: Desenvolvedores podem publicar múltiplos jogos
- RF07: Jogos podem ter múltiplas DLCs
- RF08: Conquistas devem ser rastreadas por jogador

#### Não Funcionais:

- RNF01: Integridade referencial garantida por FKs
- RNF02: Performance otimizada com índices apropriados
- RNF03: Consistência de dados através de triggers
- RNF04: Normalização até 3FN

### Escopo do Banco de Dados

O banco de dados gerencia:

- **Usuários**: Informações base de jogadores e desenvolvedores
- **Catálogo**: Jogos, DLCs, categorias e conquistas
- **Transações**: Compras e itens vendidos
- **Interações**: Avaliações, desbloqueio de conquistas
- **Métricas**: Tempo de jogo, nível de jogador, estatísticas

---

## 🗺️ 2. MODELO CONCEITUAL (Notação Peter Chen)

### Diagrama Entidade-Relacionamento

```
                    ┌─────────────┐
                    │   USUARIO   │
                    └──────┬──────┘
                           │
                           │ ISA (Especialização)
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
      ┌───────────────┐         ┌──────────────┐
      │   JOGADOR     │         │DESENVOLVEDOR │
      └───────┬───────┘         └──────┬───────┘
              │                        │
              │                        │
              │                        │ publica
              │ compra                 │ (1:N)
              │ (N:N)                  │
              │                        ▼
              │                ┌──────────────┐
              │                │     JOGO     │◄──────┐
              │                └──────┬───────┘       │
              │                       │               │ pertence
              └───────────────────────┘               │ (N:N)
                       │                              │
                       │ possui                       │
                       │ (1:N)                        ▼
                       │                      ┌──────────────┐
                       ▼                      │  CATEGORIA   │
              ┌──────────────┐               └──────────────┘
              │     DLC      │
              └──────────────┘
                       │
                       │
                       │ avalia
       ┌───────────────┼───────────────┐
       │               │               │
       │ (N:N)         │ (N:N)         │ (N:N)
       │               │               │
       ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│  AVALIACAO  │ │  CONQUISTA  │ │   COMPRA    │
└─────────────┘ └─────────────┘ └─────────────┘
       │               │               │
       │               │               │
       │ desbloqueia   │               │ contém
       │ (N:N)         │               │ (1:N)
       │               │               │
       └───────────────┘               ▼
                                ┌─────────────┐
                                │ITEM_COMPRA  │
                                └─────────────┘
```

### Entidades Principais

#### 1. USUARIO (Entidade Base)

- **id_usuario** (PK) - Identificador único
- nome - Nome completo
- email - Email (único)
- senha - Senha criptografada
- data_cadastro - Data de registro
- tipo_usuario - Tipo (Jogador/Desenvolvedor)

#### 2. JOGADOR (Especialização de USUARIO)

- **id_jogador** (PK, FK)
- nivel - Nível do jogador
- xp - Pontos de experiência
- data_nascimento - Data de nascimento
- pais - País de origem

#### 3. DESENVOLVEDOR (Especialização de USUARIO)

- **id_desenvolvedor** (PK, FK)
- nome_estudio - Nome do estúdio
- website - Site oficial
- cnpj - CNPJ do estúdio
- data_fundacao - Data de fundação

#### 4. JOGO

- **id_jogo** (PK)
- titulo - Título do jogo
- descricao - Descrição
- preco - Preço
- data_lancamento - Data de lançamento
- classificacao_etaria - Classificação (Livre, 10+, 12+, etc.)
- desenvolvedor_id (FK) - Referência ao desenvolvedor
- media_avaliacoes - Média de avaliações (calculada)

#### 5. CATEGORIA

- **id_categoria** (PK)
- nome - Nome da categoria (Ação, RPG, etc.)
- descricao - Descrição da categoria

#### 6. DLC (Conteúdo Adicional)

- **id_dlc** (PK)
- nome - Nome da DLC
- descricao - Descrição
- preco - Preço
- data_lancamento - Data de lançamento
- jogo_id (FK) - Jogo base

#### 7. CONQUISTA (Achievement)

- **id_conquista** (PK)
- nome - Nome da conquista
- descricao - Descrição
- xp_recompensa - XP concedido
- jogo_id (FK) - Jogo relacionado

#### 8. COMPRA (Transação)

- **id_compra** (PK)
- jogador_id (FK) - Jogador que comprou
- data_compra - Data/hora da compra
- valor_total - Valor total pago
- metodo_pagamento - Forma de pagamento

#### 9. ITEM_COMPRA (Itens da Compra)

- **id_item** (PK)
- compra_id (FK) - Compra relacionada
- tipo_item - Tipo (JOGO/DLC)
- item_id - ID do jogo ou DLC
- preco_pago - Preço pago no momento

#### 10. AVALIACAO

- **id_avaliacao** (PK)
- jogador_id (FK)
- jogo_id (FK)
- nota - Nota (1-5)
- comentario - Texto da avaliação
- data_avaliacao - Data da avaliação

### Relacionamentos

#### 1:N (Um para Muitos)

1. **DESENVOLVEDOR publica JOGO**

   - Um desenvolvedor pode publicar vários jogos
   - Um jogo pertence a um desenvolvedor

2. **JOGO possui DLC**

   - Um jogo pode ter várias DLCs
   - Uma DLC pertence a um jogo base

3. **JOGO possui CONQUISTA**

   - Um jogo pode ter várias conquistas
   - Uma conquista pertence a um jogo

4. **JOGADOR realiza COMPRA**

   - Um jogador pode fazer várias compras
   - Uma compra pertence a um jogador

5. **COMPRA contém ITEM_COMPRA**
   - Uma compra pode ter vários itens
   - Um item pertence a uma compra

#### N:N (Muitos para Muitos)

1. **JOGADOR compra JOGO** (via COMPRA/ITEM_COMPRA)

   - Um jogador pode comprar vários jogos
   - Um jogo pode ser comprado por vários jogadores

2. **JOGO pertence CATEGORIA** (via JOGO_CATEGORIA)

   - Um jogo pode pertencer a várias categorias
   - Uma categoria pode ter vários jogos

3. **JOGADOR avalia JOGO** (via AVALIACAO)

   - Um jogador pode avaliar vários jogos
   - Um jogo pode ser avaliado por vários jogadores

4. **JOGADOR desbloqueia CONQUISTA** (via JOGADOR_CONQUISTA)
   - Um jogador pode desbloquear várias conquistas
   - Uma conquista pode ser desbloqueada por vários jogadores

#### Especialização ISA (É-UM)

**USUARIO → {JOGADOR, DESENVOLVEDOR}**

- Especialização total e disjunta
- Todo usuário é JOGADOR ou DESENVOLVEDOR (não ambos)
- Implementação: Tabelas separadas com FK para USUARIO

---

## 📐 3. MODELO LÓGICO

### Esquemas Relacionais (3FN)

#### Tabela de Usuários Base

```
USUARIO (<u>id_usuario</u>, nome, email, senha, data_cadastro, tipo_usuario)
```

#### Especializações

```
JOGADOR (<u>id_jogador</u>, nivel, xp, data_nascimento, pais)
  - id_jogador referencia USUARIO(id_usuario)

DESENVOLVEDOR (<u>id_desenvolvedor</u>, nome_estudio, website, cnpj, data_fundacao)
  - id_desenvolvedor referencia USUARIO(id_usuario)
```

#### Catálogo de Jogos

```
JOGO (<u>id_jogo</u>, titulo, descricao, preco, data_lancamento, classificacao_etaria,
      *desenvolvedor_id*, media_avaliacoes)
  - desenvolvedor_id referencia DESENVOLVEDOR(id_desenvolvedor)

CATEGORIA (<u>id_categoria</u>, nome, descricao)

JOGO_CATEGORIA (<u>*jogo_id*, *categoria_id*</u>)
  - jogo_id referencia JOGO(id_jogo)
  - categoria_id referencia CATEGORIA(id_categoria)

DLC (<u>id_dlc</u>, nome, descricao, preco, data_lancamento, *jogo_id*)
  - jogo_id referencia JOGO(id_jogo)

CONQUISTA (<u>id_conquista</u>, nome, descricao, xp_recompensa, *jogo_id*)
  - jogo_id referencia JOGO(id_jogo)
```

#### Sistema de Compras

```
COMPRA (<u>id_compra</u>, *jogador_id*, data_compra, valor_total, metodo_pagamento)
  - jogador_id referencia JOGADOR(id_jogador)

ITEM_COMPRA (<u>id_item</u>, *compra_id*, tipo_item, item_id, preco_pago)
  - compra_id referencia COMPRA(id_compra)
```

#### Interações

```
AVALIACAO (<u>id_avaliacao</u>, *jogador_id*, *jogo_id*, nota, comentario, data_avaliacao)
  - jogador_id referencia JOGADOR(id_jogador)
  - jogo_id referencia JOGO(id_jogo)
  - UNIQUE(jogador_id, jogo_id) - Apenas uma avaliação por jogador/jogo

JOGADOR_CONQUISTA (<u>*jogador_id*, *conquista_id*</u>, data_desbloqueio)
  - jogador_id referencia JOGADOR(id_jogador)
  - conquista_id referencia CONQUISTA(id_conquista)
```

### Normalização

#### 1FN ✅

- Todos os atributos são atômicos
- Sem atributos multivalorados
- Cada coluna contém apenas um valor

#### 2FN ✅

- Está em 1FN
- Todos os atributos não-chave dependem completamente da chave primária
- Tabelas associativas (JOGO_CATEGORIA, JOGADOR_CONQUISTA) têm chaves compostas apropriadas

#### 3FN ✅

- Está em 2FN
- Não há dependências transitivas
- Exemplo: `media_avaliacoes` em JOGO é calculada via trigger (valor derivado mantido por performance)

---

## 💾 4. MODELO FÍSICO (PostgreSQL)

Veja o arquivo [database.sql](database.sql) para o script SQL completo com:

- ✅ CREATE DATABASE
- ✅ CREATE TABLE (todas as tabelas)
- ✅ INSERT (dados de teste)
- ✅ Consulta com Função Agregada + GROUP BY
- ✅ Consulta com HAVING
- ✅ CREATE FUNCTION (PL/pgSQL)
- ✅ CREATE TRIGGER

### 📚 Documentação Adicional

| Arquivo                                                          | Descrição                                             |
| ---------------------------------------------------------------- | ----------------------------------------------------- |
| [database.sql](database.sql)                                     | 🗄️ **Script SQL completo** - Executável no PostgreSQL |
| [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) | 🎨 **Diagrama ER detalhado** - Notação Peter Chen     |
| [DIAGRAMAS.md](DIAGRAMAS.md)                                     | 📊 **Diagramas visuais** - Fluxos e estruturas        |
| [TESTES.md](TESTES.md)                                           | 🧪 **Casos de teste** - Validações e exemplos         |
| [INSTALACAO.md](INSTALACAO.md)                                   | 🚀 **Guia de instalação** - Passo a passo completo    |
| [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)                       | 📋 **Resumo do projeto** - Visão geral executiva      |

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

- [x] Modelo conceitual tem 10 entidades (>5 requerido)
- [x] Modelo conceitual usa notação Peter Chen
- [x] Tem múltiplos relacionamentos 1:N
- [x] Tem múltiplos relacionamentos N:N
- [x] Tem 1 especialização (ISA: USUARIO → JOGADOR/DESENVOLVEDOR)
- [x] Modelo lógico completo e normalizado (3FN)
- [x] Todas as tabelas criadas no SQL
- [x] Dados de teste inseridos
- [x] Consulta com função agregada implementada
- [x] Consulta com HAVING implementada
- [x] Função PL/pgSQL implementada
- [x] Trigger implementado
- [x] Código SQL funcional no PostgreSQL
- [x] Documentação completa

---

## 🚀 Como Executar

1. Instale o PostgreSQL (versão 12+)
2. Execute o script:
   ```bash
   psql -U postgres -f database.sql
   ```
3. Conecte-se ao banco:
   ```bash
   psql -U postgres -d gamevault_db
   ```
4. Teste as queries e funções incluídas no script

---

## 📊 Estrutura do Banco

- **10 Tabelas principais**
- **15+ Constraints** (PKs, FKs, UNIQUEs, CHECKs)
- **2 Triggers** (atualização automática de médias e XP)
- **2 Funções** (cálculo de desconto e verificação de propriedade)
- **10+ Queries de exemplo** (com agregações, joins, subqueries)

---

**Desenvolvido para o curso de Banco de Dados - UFMA**
