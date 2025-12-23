# 🎨 MODELO CONCEITUAL DETALHADO - Notação Peter Chen

## Diagrama Entidade-Relacionamento Completo

### Representação Visual Detalhada

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           GAMEVAULT - MODELO CONCEITUAL                         │
│                              Notação Peter Chen                                 │
└─────────────────────────────────────────────────────────────────────────────────┘


                                 ┌─────────────────┐
                              ╔══╡    USUARIO     ╞══╗
                              ║  └─────────────────┘  ║
                              ║                       ║
                    ┌─────────╨─────────┐   ┌────────╨──────────┐
                    │  ⬭ id_usuario     │   │  ○ nome           │
                    │    (PK)           │   │                   │
                    └───────────────────┘   └───────────────────┘

                    ┌───────────────────┐   ┌───────────────────┐
                    │  ○ email          │   │  ○ senha          │
                    │    (UNIQUE)       │   │                   │
                    └───────────────────┘   └───────────────────┘

                    ┌───────────────────┐   ┌───────────────────┐
                    │  ○ data_cadastro  │   │  ○ tipo_usuario   │
                    │                   │   │  (discriminador)  │
                    └───────────────────┘   └───────────────────┘


                              ║                       ║
                              ║    Especialização     ║
                              ║         ISA           ║
                              ║   (Total, Disjunta)   ║
                              ║                       ║
              ┌───────────────┼───────────────────────┼───────────────┐
              │               │                       │               │
              ▼               │                       │               ▼
    ┌─────────────────┐      │                       │      ┌─────────────────┐
    │    JOGADOR      │◄─────┘                       └─────►│ DESENVOLVEDOR   │
    └─────────────────┘                                     └─────────────────┘

    ○ nivel                                                  ○ nome_estudio
    ○ xp                                                     ○ website
    ○ data_nascimento                                        ○ cnpj (UNIQUE)
    ○ pais                                                   ○ data_fundacao

         │                                                         │
         │                                                         │
         │                                                         │
         │                                                         │
         │ compra                                                  │ publica
         │   (N)                                                   │   (1)
         │                                                         │
         │                                                         ▼
         │                ┌─────────────────────────────────────────────┐
         │                │                  JOGO                       │
         │                └─────────────────────────────────────────────┘
         │
         │                ⬭ id_jogo (PK)              ○ preco
         │                ○ titulo                    ○ data_lancamento
         │                ○ descricao                 ○ classificacao_etaria
         │                ⊙ media_avaliacoes          ● desenvolvedor_id (FK)
         │                  (derivado)
         │
         │                         │
         │                         │ possui (1:N)
         │                         ▼
         │                ┌─────────────────┐
         │                │      DLC        │
         │                └─────────────────┘
         │
         │                ⬭ id_dlc (PK)
         │                ○ nome
         │                ○ descricao
         │                ○ preco
         │                ○ data_lancamento
         │                ● jogo_id (FK)
         │
         │                         │
         │                         │ possui (1:N)
         │                         ▼
         │                ┌─────────────────┐
         │                │   CONQUISTA     │
         │                └─────────────────┘
         │
         │                ⬭ id_conquista (PK)
         │                ○ nome
         │                ○ descricao
         │                ○ xp_recompensa
         │                ● jogo_id (FK)
         │
         │                         │
         └─────────────────────────┤
                                   │
                 ┌─────────────────┼─────────────────┬─────────────────┐
                 │                 │                 │                 │
                 │ avalia          │ desbloqueia     │ pertence        │
                 │   (N:N)         │   (N:N)         │   (N:N)         │
                 ▼                 ▼                 ▼                 │
         ┌──────────────┐  ┌───────────────┐  ┌──────────────┐      │
         │  AVALIACAO   │  │   JOGADOR_    │  │  CATEGORIA   │◄─────┘
         │              │  │  CONQUISTA    │  │              │
         └──────────────┘  └───────────────┘  └──────────────┘

         ⬭ id_avaliacao      ⬭⬭ jogador_id     ⬭ id_categoria
         ● jogador_id (FK)      conquista_id   ○ nome (UNIQUE)
         ● jogo_id (FK)         (PK composta)  ○ descricao
         ○ nota (1-5)        ○ data_desbloq.
         ○ comentario
         ○ data_avaliacao                      ┌──────────────────┐
                                               │ JOGO_CATEGORIA   │
                                               │  (Associativa)   │
         ┌──────────────┐                      └──────────────────┘
         │   COMPRA     │
         └──────────────┘                      ⬭⬭ jogo_id
                                                  categoria_id
         ⬭ id_compra (PK)                        (PK composta)
         ● jogador_id (FK)
         ○ data_compra
         ○ valor_total
         ○ metodo_pagamento

              │
              │ contém (1:N)
              ▼
         ┌──────────────┐
         │ ITEM_COMPRA  │
         └──────────────┘

         ⬭ id_item (PK)
         ● compra_id (FK)
         ○ tipo_item (JOGO/DLC)
         ○ item_id (polimórfico)
         ○ preco_pago


═══════════════════════════════════════════════════════════════════════════════

LEGENDA - Notação Peter Chen:

    FORMAS:
    ┌─────────┐
    │ENTIDADE │  = Retângulo (entidades)
    └─────────┘

       ◇        = Losango (relacionamentos)

       ○        = Elipse simples (atributo simples)

       ⬭        = Elipse sublinhada (atributo chave/PK)

       ⊙        = Elipse tracejada (atributo derivado)

       ●        = Elipse preenchida (FK - representação simplificada)

       ⬭⬭       = Chave composta (múltiplos atributos chave)

    CARDINALIDADES:
       1        = Um (lado 1 do relacionamento)
       N ou M   = Muitos (lado N do relacionamento)

    ESPECIALIZAÇÃO:
       ISA      = "É um" (herança/especialização)
       ║        = Linha de especialização
       Total    = Todo elemento da superclasse está em alguma subclasse
       Disjunta = Um elemento não pode estar em mais de uma subclasse

═══════════════════════════════════════════════════════════════════════════════
```

---

## 📊 Descrição Detalhada dos Elementos

### 🔷 ENTIDADES

#### 1. USUARIO (Superclasse)

**Tipo**: Entidade base para especialização  
**Descrição**: Representa qualquer usuário cadastrado no sistema

**Atributos**:

- ⬭ `id_usuario` - Chave primária, identificador único
- ○ `nome` - Nome completo do usuário
- ○ `email` - Email único para login
- ○ `senha` - Senha criptografada
- ○ `data_cadastro` - Timestamp de registro
- ○ `tipo_usuario` - Discriminador (JOGADOR/DESENVOLVEDOR)

---

#### 2. JOGADOR (Subclasse de USUARIO)

**Tipo**: Especialização  
**Descrição**: Usuários que compram e jogam

**Atributos específicos**:

- ○ `nivel` - Nível atual (calculado a partir do XP)
- ○ `xp` - Pontos de experiência acumulados
- ○ `data_nascimento` - Data de nascimento
- ○ `pais` - País de origem

**Regras**:

- Nível aumenta a cada 100 XP
- Nível determina desconto em compras
- Ganha XP comprando jogos e desbloqueando conquistas

---

#### 3. DESENVOLVEDOR (Subclasse de USUARIO)

**Tipo**: Especialização  
**Descrição**: Estúdios/empresas que publicam jogos

**Atributos específicos**:

- ○ `nome_estudio` - Nome do estúdio de desenvolvimento
- ○ `website` - Site oficial
- ○ `cnpj` - CNPJ único do estúdio
- ○ `data_fundacao` - Data de fundação da empresa

---

#### 4. JOGO

**Tipo**: Entidade forte  
**Descrição**: Produtos (jogos) disponíveis para compra

**Atributos**:

- ⬭ `id_jogo` - Chave primária
- ○ `titulo` - Nome do jogo
- ○ `descricao` - Descrição detalhada
- ○ `preco` - Preço atual
- ○ `data_lancamento` - Data de lançamento
- ○ `classificacao_etaria` - Faixa etária (Livre, 10+, 12+, etc.)
- ⊙ `media_avaliacoes` - **Atributo derivado** (calculado via trigger)
- ● `desenvolvedor_id` - FK para DESENVOLVEDOR

---

#### 5. CATEGORIA

**Tipo**: Entidade forte  
**Descrição**: Gêneros/categorias de jogos

**Atributos**:

- ⬭ `id_categoria` - Chave primária
- ○ `nome` - Nome da categoria (único)
- ○ `descricao` - Descrição da categoria

**Exemplos**: Ação, RPG, Estratégia, Terror, Simulação

---

#### 6. DLC

**Tipo**: Entidade fraca (depende de JOGO)  
**Descrição**: Conteúdo adicional para jogos

**Atributos**:

- ⬭ `id_dlc` - Chave primária
- ○ `nome` - Nome da DLC
- ○ `descricao` - Descrição do conteúdo
- ○ `preco` - Preço da DLC
- ○ `data_lancamento` - Data de lançamento
- ● `jogo_id` - FK obrigatória para JOGO base

---

#### 7. CONQUISTA

**Tipo**: Entidade fraca (depende de JOGO)  
**Descrição**: Achievements/conquistas de jogos

**Atributos**:

- ⬭ `id_conquista` - Chave primária
- ○ `nome` - Nome da conquista
- ○ `descricao` - Como desbloquear
- ○ `xp_recompensa` - XP concedido ao desbloquear
- ● `jogo_id` - FK para JOGO

---

#### 8. COMPRA

**Tipo**: Entidade forte  
**Descrição**: Transação de compra realizada

**Atributos**:

- ⬭ `id_compra` - Chave primária
- ● `jogador_id` - FK para JOGADOR
- ○ `data_compra` - Timestamp da transação
- ○ `valor_total` - Valor total pago
- ○ `metodo_pagamento` - Forma de pagamento

---

#### 9. ITEM_COMPRA

**Tipo**: Entidade fraca (depende de COMPRA)  
**Descrição**: Itens individuais de uma compra

**Atributos**:

- ⬭ `id_item` - Chave primária
- ● `compra_id` - FK para COMPRA
- ○ `tipo_item` - JOGO ou DLC
- ○ `item_id` - ID do jogo ou DLC (polimórfico)
- ○ `preco_pago` - Preço no momento da compra

---

#### 10. AVALIACAO

**Tipo**: Entidade associativa (relacionamento N:N)  
**Descrição**: Avaliações de jogos por jogadores

**Atributos**:

- ⬭ `id_avaliacao` - Chave primária
- ● `jogador_id` - FK para JOGADOR
- ● `jogo_id` - FK para JOGO
- ○ `nota` - Nota de 1 a 5
- ○ `comentario` - Texto da avaliação
- ○ `data_avaliacao` - Timestamp

**Restrição**: Um jogador só pode avaliar cada jogo uma vez

---

### 🔗 RELACIONAMENTOS

#### 1. ISA (Especialização/Generalização)

**Tipo**: Herança  
**Relacionamento**: USUARIO → {JOGADOR, DESENVOLVEDOR}

**Características**:

- **Total**: Todo usuário é JOGADOR ou DESENVOLVEDOR
- **Disjunta**: Não pode ser ambos simultaneamente
- **Implementação**: Tabelas separadas com FK

---

#### 2. DESENVOLVEDOR publica JOGO

**Cardinalidade**: 1:N (Um para Muitos)

- Um desenvolvedor pode publicar vários jogos
- Cada jogo tem exatamente um desenvolvedor
- **FK**: `jogo.desenvolvedor_id → desenvolvedor.id_desenvolvedor`
- **Restrição**: ON DELETE RESTRICT (não pode deletar dev com jogos)

---

#### 3. JOGO possui DLC

**Cardinalidade**: 1:N

- Um jogo pode ter várias DLCs
- Cada DLC pertence a um jogo base
- **FK**: `dlc.jogo_id → jogo.id_jogo`
- **Restrição**: ON DELETE CASCADE (deletar jogo remove DLCs)

---

#### 4. JOGO possui CONQUISTA

**Cardinalidade**: 1:N

- Um jogo pode ter várias conquistas
- Cada conquista pertence a um jogo
- **FK**: `conquista.jogo_id → jogo.id_jogo`
- **Restrição**: ON DELETE CASCADE

---

#### 5. JOGADOR realiza COMPRA

**Cardinalidade**: 1:N

- Um jogador pode fazer várias compras
- Cada compra é de um jogador
- **FK**: `compra.jogador_id → jogador.id_jogador`

---

#### 6. COMPRA contém ITEM_COMPRA

**Cardinalidade**: 1:N

- Uma compra pode ter vários itens
- Cada item pertence a uma compra
- **FK**: `item_compra.compra_id → compra.id_compra`

---

#### 7. JOGO pertence CATEGORIA

**Cardinalidade**: N:N (Muitos para Muitos)  
**Tabela Associativa**: JOGO_CATEGORIA

- Um jogo pode pertencer a várias categorias
- Uma categoria pode ter vários jogos
- **PKs**: `(jogo_id, categoria_id)` - chave composta

---

#### 8. JOGADOR avalia JOGO

**Cardinalidade**: N:N  
**Tabela Associativa**: AVALIACAO (com atributos)

- Um jogador pode avaliar vários jogos
- Um jogo pode ser avaliado por vários jogadores
- **Restrição**: Cada jogador avalia cada jogo no máximo uma vez

---

#### 9. JOGADOR desbloqueia CONQUISTA

**Cardinalidade**: N:N  
**Tabela Associativa**: JOGADOR_CONQUISTA

- Um jogador pode desbloquear várias conquistas
- Uma conquista pode ser desbloqueada por vários jogadores
- **Atributo**: `data_desbloqueio`

---

## 🎯 Requisitos Atendidos

### ✅ Checklist de Completude

| Requisito           | Status | Quantidade                          |
| ------------------- | ------ | ----------------------------------- |
| Entidades           | ✅     | 10 (mínimo: 5)                      |
| Relacionamento 1:N  | ✅     | 5 implementados                     |
| Relacionamento N:N  | ✅     | 3 implementados                     |
| Especialização ISA  | ✅     | 1 (USUARIO → JOGADOR/DESENVOLVEDOR) |
| Atributo Derivado   | ✅     | 1 (media_avaliacoes)                |
| Chaves Primárias    | ✅     | Todas as tabelas                    |
| Chaves Estrangeiras | ✅     | Todos os relacionamentos            |

---

## 🔐 Restrições de Integridade

1. **Integridade de Entidade**: Todas as tabelas têm PK única e não-nula
2. **Integridade Referencial**: Todas as FKs referenciam PKs válidas
3. **Integridade de Domínio**:
   - `nota` ∈ [1, 5]
   - `preco` ≥ 0
   - `tipo_usuario` ∈ {JOGADOR, DESENVOLVEDOR}
   - `classificacao_etaria` ∈ {LIVRE, 10+, 12+, 14+, 16+, 18+}
4. **Restrições Customizadas**:
   - Email único
   - CNPJ único
   - Jogador avalia jogo apenas uma vez
   - Nível ≥ 1, XP ≥ 0

---

## 📈 Atributos Derivados e Calculados

### media_avaliacoes (JOGO)

- **Fórmula**: `AVG(nota)` de todas as avaliações do jogo
- **Atualização**: Automática via trigger
- **Justificativa**: Performance em queries (evita recalcular a cada consulta)

### nivel (JOGADOR)

- **Fórmula**: `(xp / 100) + 1`
- **Atualização**: Automática via trigger ao ganhar XP
- **Regra de Negócio**: A cada 100 XP, sobe 1 nível

---

**Desenvolvido seguindo rigorosamente a notação de Peter Chen**
