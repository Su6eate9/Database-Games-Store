# 📑 ÍNDICE GERAL DO PROJETO

Guia de navegação completo da documentação do **GameVault Database**.

---

## 🎯 Início Rápido

### Para Implementar o Banco

1. **[INSTALACAO.md](INSTALACAO.md)** - Siga o guia de instalação passo a passo
2. Execute o **[database.sql](database.sql)** no PostgreSQL
3. Teste com os exemplos em **[TESTES.md](TESTES.md)**

### Para Entender o Projeto

1. **[README.md](README.md)** - Visão geral e definição do problema
2. **[RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)** - Resumo completo
3. **[DIAGRAMAS.md](DIAGRAMAS.md)** - Visualizações do modelo

---

## 📚 Documentação por Tópico

### 📖 Conceitos e Teoria

| Documento                                                        | Conteúdo                                           | Para Quem            |
| ---------------------------------------------------------------- | -------------------------------------------------- | -------------------- |
| [README.md](README.md)                                           | Definição do problema, contexto, requisitos        | Todos                |
| [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) | Diagrama ER Peter Chen, entidades, relacionamentos | Modelagem            |
| [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)                       | Visão geral, métricas, análise                     | Gestores/Avaliadores |

### 🎨 Visualizações

| Documento                                                        | Conteúdo                           | Para Quem        |
| ---------------------------------------------------------------- | ---------------------------------- | ---------------- |
| [DIAGRAMAS.md](DIAGRAMAS.md)                                     | Diagramas visuais, fluxos de dados | Visual learners  |
| [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) | ER detalhado, legenda completa     | Estudantes de BD |

### 💻 Implementação

| Documento                      | Conteúdo                             | Para Quem            |
| ------------------------------ | ------------------------------------ | -------------------- |
| [database.sql](database.sql)   | Script SQL completo e executável     | DBAs/Desenvolvedores |
| [INSTALACAO.md](INSTALACAO.md) | Guia de instalação e configuração    | Iniciantes           |
| [TESTES.md](TESTES.md)         | Casos de teste, validações, exemplos | Testadores/QA        |

---

## 🗂️ Organização por Fase do Projeto

### Fase 1: Análise e Modelagem

```
1. README.md (Seção 1: DEFINIÇÃO DO PROBLEMA)
   └─ Contexto, funcionalidades, requisitos

2. README.md (Seção 2: MODELO CONCEITUAL)
   └─ Diagrama ER inicial

3. MODELO_CONCEITUAL_DETALHADO.md
   └─ Detalhamento completo do ER

4. DIAGRAMAS.md
   └─ Visualizações e fluxos
```

### Fase 2: Projeto Lógico

```
1. README.md (Seção 3: MODELO LÓGICO)
   └─ Esquemas relacionais

2. MODELO_CONCEITUAL_DETALHADO.md
   └─ Descrição detalhada das entidades
   └─ Documentação dos relacionamentos

3. RESUMO_EXECUTIVO.md
   └─ Análise da normalização
```

### Fase 3: Implementação Física

```
1. database.sql
   └─ Criação de tabelas
   └─ Constraints e índices
   └─ Inserção de dados

2. database.sql (Funções e Triggers)
   └─ Funções PL/pgSQL
   └─ Triggers automáticos

3. database.sql (Consultas)
   └─ Queries obrigatórias
   └─ Relatórios e análises
```

### Fase 4: Testes e Validação

```
1. TESTES.md
   └─ Casos de teste
   └─ Validações de integridade
   └─ Testes de performance

2. INSTALACAO.md
   └─ Verificação da instalação
   └─ Troubleshooting
```

---

## 🎓 Documentação por Requisito Acadêmico

### Requisitos Obrigatórios

| Requisito                          | Onde Encontrar                                                                            |
| ---------------------------------- | ----------------------------------------------------------------------------------------- |
| **Modelo Conceitual (Peter Chen)** | [README.md](README.md) + [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) |
| **5+ Entidades**                   | [README.md](README.md#entidades-principais) (10 entidades)                                |
| **Relacionamento 1:N**             | [README.md](README.md#relacionamentos) (5 implementados)                                  |
| **Relacionamento N:N**             | [README.md](README.md#relacionamentos) (3 implementados)                                  |
| **Especialização ISA**             | [README.md](README.md#especialização-isa)                                                 |
| **Modelo Lógico**                  | [README.md](README.md#3-modelo-lógico)                                                    |
| **Normalização 3FN**               | [README.md](README.md#normalização)                                                       |
| **Script SQL**                     | [database.sql](database.sql)                                                              |
| **Função Agregada + GROUP BY**     | [database.sql](database.sql#L461-L471)                                                    |
| **Consulta com HAVING**            | [database.sql](database.sql#L478-L488)                                                    |
| **Função PL/pgSQL**                | [database.sql](database.sql#L239-L265)                                                    |
| **Trigger**                        | [database.sql](database.sql#L302-L361)                                                    |

### Documentação Complementar

| Aspecto                  | Onde Encontrar                                                  |
| ------------------------ | --------------------------------------------------------------- |
| **Dados de Teste**       | [database.sql](database.sql#L368-L549)                          |
| **Consultas de Exemplo** | [database.sql](database.sql#L553-L681) + [TESTES.md](TESTES.md) |
| **Validação e Testes**   | [TESTES.md](TESTES.md)                                          |
| **Guia de Instalação**   | [INSTALACAO.md](INSTALACAO.md)                                  |
| **Diagramas Visuais**    | [DIAGRAMAS.md](DIAGRAMAS.md)                                    |

---

## 🔍 Busca Rápida por Conceito

### Entidades

- **USUARIO**: [README.md](README.md#1-usuario-entidade-base)
- **JOGADOR**: [README.md](README.md#2-jogador-especialização-de-usuario)
- **DESENVOLVEDOR**: [README.md](README.md#3-desenvolvedor-especialização-de-usuario)
- **JOGO**: [README.md](README.md#4-jogo)
- **CATEGORIA**: [README.md](README.md#5-categoria)
- **DLC**: [README.md](README.md#6-dlc-conteúdo-adicional)
- **CONQUISTA**: [README.md](README.md#7-conquista-achievement)
- **COMPRA**: [README.md](README.md#8-compra-transação)
- **ITEM_COMPRA**: [README.md](README.md#9-item_compra-itens-da-compra)
- **AVALIACAO**: [README.md](README.md#10-avaliacao)

### Funcionalidades SQL

- **CREATE TABLE**: [database.sql](database.sql#L15-L216)
- **Constraints**: [database.sql](database.sql) (espalhadas pelas tabelas)
- **Índices**: [database.sql](database.sql) (após cada CREATE TABLE)
- **Funções**: [database.sql](database.sql#L239-L300)
- **Triggers**: [database.sql](database.sql#L302-L361)
- **INSERT**: [database.sql](database.sql#L368-L549)
- **Consultas**: [database.sql](database.sql#L553-L681)

### Testes

- **Testes de Criação**: [TESTES.md](TESTES.md#1-testes-de-criação)
- **Testes de Inserção**: [TESTES.md](TESTES.md#2-testes-de-inserção)
- **Testes de Agregação**: [TESTES.md](TESTES.md#3-testes-de-consultas-agregadas)
- **Testes de Funções**: [TESTES.md](TESTES.md#4-testes-de-funções)
- **Testes de Triggers**: [TESTES.md](TESTES.md#5-testes-de-triggers)
- **Validação de Integridade**: [TESTES.md](TESTES.md#6-validação-de-integridade)

---

## 🚀 Fluxos de Trabalho Recomendados

### Para Estudantes (Aprendizado)

1. Leia [README.md](README.md) - Entenda o problema
2. Estude [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) - Aprenda modelagem
3. Analise [DIAGRAMAS.md](DIAGRAMAS.md) - Visualize as estruturas
4. Instale seguindo [INSTALACAO.md](INSTALACAO.md) - Mão na massa
5. Execute testes em [TESTES.md](TESTES.md) - Valide o aprendizado

### Para Implementadores (Prática)

1. Leia [INSTALACAO.md](INSTALACAO.md) - Configure o ambiente
2. Execute [database.sql](database.sql) - Crie o banco
3. Valide com [TESTES.md](TESTES.md) - Confirme funcionamento
4. Consulte [README.md](README.md) - Referência rápida
5. Use [DIAGRAMAS.md](DIAGRAMAS.md) - Entenda as estruturas

### Para Avaliadores (Correção)

1. Leia [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md) - Visão geral
2. Verifique [README.md](README.md) - Todos os requisitos
3. Analise [database.sql](database.sql) - Implementação
4. Confira [TESTES.md](TESTES.md) - Evidências de funcionamento
5. Revise [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) - Notação Peter Chen

---

## 📊 Métricas do Projeto

| Categoria                | Quantidade    | Arquivo Relacionado                                   |
| ------------------------ | ------------- | ----------------------------------------------------- |
| **Documentos**           | 7 arquivos    | Todos                                                 |
| **Linhas de Código SQL** | 700+          | [database.sql](database.sql)                          |
| **Entidades**            | 10            | [README.md](README.md)                                |
| **Tabelas**              | 12            | [database.sql](database.sql)                          |
| **Relacionamentos**      | 8+            | [README.md](README.md)                                |
| **Funções**              | 2             | [database.sql](database.sql)                          |
| **Triggers**             | 2 (3 eventos) | [database.sql](database.sql)                          |
| **Constraints**          | 15+           | [database.sql](database.sql)                          |
| **Índices**              | 10+           | [database.sql](database.sql)                          |
| **Registros de Teste**   | 88            | [database.sql](database.sql)                          |
| **Consultas de Exemplo** | 10+           | [database.sql](database.sql) + [TESTES.md](TESTES.md) |
| **Casos de Teste**       | 20+           | [TESTES.md](TESTES.md)                                |

---

## 🗺️ Mapa de Dependências entre Arquivos

```
README.md (Principal)
    │
    ├─▶ database.sql (Implementação)
    │   └─▶ TESTES.md (Validação)
    │       └─▶ INSTALACAO.md (Guia)
    │
    ├─▶ MODELO_CONCEITUAL_DETALHADO.md (Teoria)
    │   └─▶ DIAGRAMAS.md (Visualização)
    │
    └─▶ RESUMO_EXECUTIVO.md (Overview)
        └─▶ Referencia todos os outros
```

---

## 🎯 Guias Específicos

### Como Entender a Especialização ISA

1. [README.md](README.md#especialização-isa) - Explicação conceitual
2. [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md#especialização-isa) - Detalhes
3. [DIAGRAMAS.md](DIAGRAMAS.md#diagrama-principal) - Visualização
4. [database.sql](database.sql#L15-L61) - Implementação SQL
5. [TESTES.md](TESTES.md#teste-4-especialização-isa) - Validação

### Como Entender os Triggers

1. [README.md](README.md) - Menção aos triggers
2. [database.sql](database.sql#L302-L361) - Código completo
3. [TESTES.md](TESTES.md#5-testes-de-triggers) - Testes práticos
4. [DIAGRAMAS.md](DIAGRAMAS.md#diagrama-de-triggers) - Fluxo visual
5. [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md#triggers) - Resumo

### Como Entender as Consultas

1. [README.md](README.md) - Requisitos das consultas
2. [database.sql](database.sql#L461-L488) - Consultas obrigatórias
3. [database.sql](database.sql#L553-L681) - Consultas adicionais
4. [TESTES.md](TESTES.md#3-testes-de-consultas-agregadas) - Resultados esperados
5. [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md#consultas-sql-obrigatórias) - Análise

---

## 📞 Ajuda e Suporte

### Problemas Comuns

| Problema             | Solução                                                              |
| -------------------- | -------------------------------------------------------------------- |
| Erro na instalação   | Ver [INSTALACAO.md](INSTALACAO.md#solução-de-problemas)              |
| Erro ao executar SQL | Ver [TESTES.md](TESTES.md#6-validação-de-integridade)                |
| Dúvida sobre modelo  | Ver [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) |
| Entender diagrama    | Ver [DIAGRAMAS.md](DIAGRAMAS.md)                                     |

### Recursos de Aprendizado

- **Modelagem**: [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md)
- **SQL**: [database.sql](database.sql) com comentários
- **PL/pgSQL**: [database.sql](database.sql#L239-L300)
- **Normalização**: [README.md](README.md#normalização)

---

## ✅ Checklist de Leitura Completa

- [ ] Li [README.md](README.md) - Visão geral
- [ ] Li [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md) - Resumo
- [ ] Estudei [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) - Modelagem
- [ ] Analisei [DIAGRAMAS.md](DIAGRAMAS.md) - Visualizações
- [ ] Instalei conforme [INSTALACAO.md](INSTALACAO.md) - Prática
- [ ] Executei [database.sql](database.sql) - Implementação
- [ ] Testei com [TESTES.md](TESTES.md) - Validação

---

## 🎓 Para Professores/Avaliadores

### Ordem de Avaliação Sugerida

1. **[RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)** - Entenda o escopo (5 min)
2. **[README.md](README.md)** - Verifique requisitos (10 min)
3. **[MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md)** - Avalie modelagem (15 min)
4. **[database.sql](database.sql)** - Revise implementação (20 min)
5. **[TESTES.md](TESTES.md)** - Confira evidências (10 min)

**Tempo total**: ~60 minutos

### Pontos de Verificação

| Critério            | Localização                                                      |
| ------------------- | ---------------------------------------------------------------- |
| Notação Peter Chen  | [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) |
| 5+ Entidades        | [README.md](README.md#entidades-principais)                      |
| Relacionamentos 1:N | [README.md](README.md#1n-um-para-muitos)                         |
| Relacionamentos N:N | [README.md](README.md#nn-muitos-para-muitos)                     |
| Especialização ISA  | [README.md](README.md#especialização-isa)                        |
| Normalização 3FN    | [README.md](README.md#normalização)                              |
| Função Agregada     | [database.sql](database.sql#L461-L471)                           |
| HAVING              | [database.sql](database.sql#L478-L488)                           |
| Função PL/pgSQL     | [database.sql](database.sql#L239-L300)                           |
| Trigger             | [database.sql](database.sql#L302-L361)                           |

---

## 🎉 Conclusão

Este índice fornece navegação completa pela documentação do projeto **GameVault Database**. Use os links para acessar rapidamente qualquer seção desejada.

**Status**: ✅ Documentação 100% completa

**Desenvolvido para**: Banco de Dados - UFMA - 2025
