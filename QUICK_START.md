# 🎮 GAMEVAULT - QUICK START

```
  ╔═══════════════════════════════════════════════════════════════╗
  ║                                                               ║
  ║   ██████╗  █████╗ ███╗   ███╗███████╗██╗   ██╗ █████╗ ██╗   ║
  ║  ██╔════╝ ██╔══██╗████╗ ████║██╔════╝██║   ██║██╔══██╗██║   ║
  ║  ██║  ███╗███████║██╔████╔██║█████╗  ██║   ██║███████║██║   ║
  ║  ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ╚██╗ ██╔╝██╔══██║██║   ║
  ║  ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗ ╚████╔╝ ██║  ██║███████╗
  ║   ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝  ╚═══╝  ╚═╝  ╚═╝╚══════╝
  ║                                                               ║
  ║           PLATAFORMA DE DISTRIBUIÇÃO DE JOGOS DIGITAIS       ║
  ║                    Database Project - UFMA                   ║
  ║                                                               ║
  ╚═══════════════════════════════════════════════════════════════╝
```

---

## 🚀 Início Rápido (3 minutos)

### 1️⃣ Instalar PostgreSQL

- **Download**: https://www.postgresql.org/download/
- **Versão mínima**: 12+

### 2️⃣ Executar Script

```bash
psql -U postgres -f database.sql
```

### 3️⃣ Conectar ao Banco

```bash
psql -U postgres -d gamevault_db
```

---

## 📚 Documentação Completa

| 📄 Documento                                                         | 📝 Descrição                     | ⏱️ Tempo |
| -------------------------------------------------------------------- | -------------------------------- | -------- |
| **[INDICE.md](INDICE.md)**                                           | 🗺️ Mapa completo da documentação | 5 min    |
| **[README.md](README.md)**                                           | 📖 Documentação principal        | 20 min   |
| **[RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)**                       | 📊 Visão geral do projeto        | 10 min   |
| **[INSTALACAO.md](INSTALACAO.md)**                                   | 🔧 Guia de instalação            | 15 min   |
| **[database.sql](database.sql)**                                     | 💾 Script SQL completo           | -        |
| **[TESTES.md](TESTES.md)**                                           | 🧪 Casos de teste                | 15 min   |
| **[EXEMPLOS_PRATICOS.md](EXEMPLOS_PRATICOS.md)**                     | 💡 Tutoriais práticos            | 20 min   |
| **[MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md)** | 🎨 Diagrama ER Peter Chen        | 20 min   |
| **[DIAGRAMAS.md](DIAGRAMAS.md)**                                     | 📊 Diagramas visuais             | 15 min   |

---

## 🎯 Acesso Rápido por Objetivo

### 👨‍🎓 **Sou Estudante - Quero Aprender**

1. Leia: [README.md](README.md) - Entenda o problema
2. Estude: [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) - Aprenda modelagem
3. Pratique: [INSTALACAO.md](INSTALACAO.md) + [EXEMPLOS_PRATICOS.md](EXEMPLOS_PRATICOS.md)

### 👨‍💻 **Sou Desenvolvedor - Quero Implementar**

1. Instale: [INSTALACAO.md](INSTALACAO.md)
2. Execute: [database.sql](database.sql)
3. Teste: [TESTES.md](TESTES.md)

### 👨‍🏫 **Sou Professor - Quero Avaliar**

1. Overview: [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)
2. Verificação: [README.md](README.md) - Todos os requisitos
3. Evidências: [TESTES.md](TESTES.md)

### 👨‍💼 **Quero Visão Geral Rápida**

1. **[RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)** ← Comece aqui!
2. [DIAGRAMAS.md](DIAGRAMAS.md) - Visualizações
3. [INDICE.md](INDICE.md) - Navegação completa

---

## 🎮 O Que Este Projeto Faz?

### Sistema Completo de Gerenciamento para:

✅ **Usuários**

- Jogadores com sistema de níveis e XP
- Desenvolvedores publicando jogos

✅ **Catálogo**

- Jogos organizados por categorias
- DLCs e conteúdos adicionais
- Sistema de conquistas (achievements)

✅ **Transações**

- Compras de jogos e DLCs
- Sistema de avaliações
- Histórico completo

✅ **Automação**

- Triggers calculando médias automaticamente
- Sistema de XP e níveis
- Funções de validação

---

## 📊 Números do Projeto

```
┌──────────────────────────────────────────────────┐
│  ✅ 10 Entidades                                 │
│  ✅ 12 Tabelas                                   │
│  ✅ 8+ Relacionamentos                           │
│  ✅ 2 Funções PL/pgSQL                           │
│  ✅ 2 Triggers Automáticos                       │
│  ✅ 15+ Constraints                              │
│  ✅ 10+ Índices                                  │
│  ✅ 88 Registros de Teste                        │
│  ✅ 700+ Linhas de SQL                           │
│  ✅ 100% Normalizado (3FN)                       │
└──────────────────────────────────────────────────┘
```

---

## ✅ Requisitos Acadêmicos

### Todos Implementados e Documentados

| ✅  | Requisito                    | Localização                                                                               |
| --- | ---------------------------- | ----------------------------------------------------------------------------------------- |
| ✅  | Modelo Conceitual Peter Chen | [README.md](README.md) + [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) |
| ✅  | 5+ Entidades                 | 10 implementadas                                                                          |
| ✅  | Relacionamento 1:N           | 5 implementados                                                                           |
| ✅  | Relacionamento N:N           | 3 implementados                                                                           |
| ✅  | Especialização ISA           | USUARIO → JOGADOR/DESENVOLVEDOR                                                           |
| ✅  | Modelo Lógico 3FN            | [README.md](README.md#3-modelo-lógico)                                                    |
| ✅  | Script SQL                   | [database.sql](database.sql)                                                              |
| ✅  | Função Agregada + GROUP BY   | [database.sql](database.sql#L461)                                                         |
| ✅  | Consulta com HAVING          | [database.sql](database.sql#L478)                                                         |
| ✅  | Função PL/pgSQL              | [database.sql](database.sql#L239)                                                         |
| ✅  | Trigger                      | [database.sql](database.sql#L302)                                                         |

---

## 🔥 Destaques Técnicos

### 🎯 Especialização ISA

```
USUARIO
   ├── JOGADOR (joga, compra, avalia)
   └── DESENVOLVEDOR (publica, vende)
```

### ⚡ Triggers Automáticos

- **Média de Avaliações**: Atualiza automaticamente ao inserir/editar avaliação
- **Sistema de XP**: Adiciona XP e recalcula nível ao desbloquear conquista

### 🔧 Funções Úteis

- `calcular_desconto_jogador()`: Retorna desconto baseado no nível
- `jogador_possui_jogo()`: Verifica se jogador tem o jogo

---

## 🛠️ Comandos Essenciais

### Instalar

```bash
psql -U postgres -f database.sql
```

### Conectar

```bash
psql -U postgres -d gamevault_db
```

### Verificar Tabelas

```sql
\dt
```

### Consulta Rápida

```sql
SELECT * FROM JOGO LIMIT 5;
```

---

## 💡 Primeiras Consultas

### Ver Jogos Mais Vendidos

```sql
SELECT j.titulo, COUNT(*) AS vendas
FROM JOGO j
INNER JOIN ITEM_COMPRA ic ON j.id_jogo = ic.item_id
GROUP BY j.id_jogo
ORDER BY vendas DESC
LIMIT 5;
```

### Ver Ranking de Jogadores

```sql
SELECT u.nome, j.nivel, j.xp
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
ORDER BY j.xp DESC;
```

### Ver Estatísticas Gerais

```sql
SELECT
    (SELECT COUNT(*) FROM JOGADOR) AS jogadores,
    (SELECT COUNT(*) FROM JOGO) AS jogos,
    (SELECT COUNT(*) FROM COMPRA) AS compras,
    (SELECT SUM(valor_total) FROM COMPRA) AS receita_total;
```

---

## 🎓 Para Trabalhos Acadêmicos

### Citação Sugerida

```
GameVault Database - Sistema de Gerenciamento para Plataforma de Jogos Digitais
Projeto de Banco de Dados - UFMA
Modelagem Conceitual, Lógica e Física Completa
PostgreSQL 12+ | Notação Peter Chen | Normalização 3FN
2025
```

---

## 🆘 Precisa de Ajuda?

| Problema                    | Solução                                                               |
| --------------------------- | --------------------------------------------------------------------- |
| ❓ Não sei por onde começar | Leia [INDICE.md](INDICE.md)                                           |
| 🔧 Erro na instalação       | Veja [INSTALACAO.md](INSTALACAO.md#solução-de-problemas)              |
| 📖 Não entendi o modelo     | Leia [MODELO_CONCEITUAL_DETALHADO.md](MODELO_CONCEITUAL_DETALHADO.md) |
| 🧪 Como testar?             | Veja [TESTES.md](TESTES.md)                                           |
| 💻 Quero exemplos práticos  | Veja [EXEMPLOS_PRATICOS.md](EXEMPLOS_PRATICOS.md)                     |

---

## 🏆 Status do Projeto

```
╔══════════════════════════════════════════════════════╗
║                                                      ║
║            ✅ PROJETO 100% COMPLETO                  ║
║                                                      ║
║  ✓ Todos os requisitos atendidos                    ║
║  ✓ Código testado e funcional                       ║
║  ✓ Documentação completa                            ║
║  ✓ Pronto para uso e avaliação                      ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
```

---

## 📞 Informações

**Projeto**: GameVault Database  
**Instituição**: UFMA (Universidade Federal do Maranhão)  
**Disciplina**: Banco de Dados  
**Ano**: 2025  
**Status**: ✅ Completo e Funcional

---

## 🚀 Próximos Passos

1. **[INSTALACAO.md](INSTALACAO.md)** - Instale o banco de dados
2. **[EXEMPLOS_PRATICOS.md](EXEMPLOS_PRATICOS.md)** - Execute exemplos práticos
3. **[TESTES.md](TESTES.md)** - Teste todas as funcionalidades
4. **Explore e modifique** - O sistema é seu!

---

**Desenvolvido com 💙 para o curso de Banco de Dados**

**Bons estudos! 🎓**
