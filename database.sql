-- GAMEVAULT - PLATAFORMA DE DISTRIBUIÇÃO DE JOGOS DIGITAIS
-- Sistema de Banco de Dados para Gerenciamento de Jogos, Usuários e Transações
-- SGBD: PostgreSQL 12+
-- Autor: Database Games Store Project
-- Data: Dezembro 2025

-- INSTRUÇÕES DE USO:
-- OPÇÃO 1 - Via psql (Linha de Comando):
--   psql -U postgres -f database.sql
--
-- OPÇÃO 2 - Via pgAdmin ou outra ferramenta gráfica:
--   1. Crie manualmente o banco "gamevault_db"
--   2. Conecte-se ao banco "gamevault_db"
--   3. Execute este script SEM as linhas de DROP/CREATE DATABASE

-- Remover banco se existir e criar novo (apenas para psql)
-- Comente as 2 linhas abaixo se estiver usando pgAdmin ou ferramenta gráfica
-- DROP DATABASE IF EXISTS gamevault_db;
-- CREATE DATABASE gamevault_db;

-- Conectar ao banco (apenas funciona no psql)
-- Se estiver usando pgAdmin, conecte-se manualmente ao banco antes de executar
-- \c gamevault_db

-- PARTE 1: CRIAÇÃO DAS TABELAS

-- TABELA: USUARIO (Entidade Base)
-- Descrição: Armazena informações básicas de todos os usuários do sistema
CREATE TABLE USUARIO (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('JOGADOR', 'DESENVOLVEDOR'))
);

-- Índice para busca por email
CREATE INDEX idx_usuario_email ON USUARIO(email);

COMMENT ON TABLE USUARIO IS 'Tabela base para todos os usuários do sistema';
COMMENT ON COLUMN USUARIO.tipo_usuario IS 'Discriminador para especialização: JOGADOR ou DESENVOLVEDOR';



-- TABELA: JOGADOR (Especialização de USUARIO)
-- Descrição: Informações específicas de jogadores

CREATE TABLE JOGADOR (
    id_jogador INTEGER PRIMARY KEY,
    nivel INTEGER DEFAULT 1 CHECK (nivel >= 1),
    xp INTEGER DEFAULT 0 CHECK (xp >= 0),
    data_nascimento DATE,
    pais VARCHAR(50),
    
    CONSTRAINT fk_jogador_usuario FOREIGN KEY (id_jogador) 
        REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

COMMENT ON TABLE JOGADOR IS 'Especialização de USUARIO para jogadores';
COMMENT ON COLUMN JOGADOR.nivel IS 'Nível do jogador (aumenta com XP)';
COMMENT ON COLUMN JOGADOR.xp IS 'Pontos de experiência acumulados';


-- TABELA: DESENVOLVEDOR (Especialização de USUARIO)
-- Descrição: Informações específicas de desenvolvedores/estúdios
CREATE TABLE DESENVOLVEDOR (
    id_desenvolvedor INTEGER PRIMARY KEY,
    nome_estudio VARCHAR(100) NOT NULL,
    website VARCHAR(200),
    cnpj VARCHAR(18) UNIQUE,
    data_fundacao DATE,
    
    CONSTRAINT fk_desenvolvedor_usuario FOREIGN KEY (id_desenvolvedor) 
        REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

COMMENT ON TABLE DESENVOLVEDOR IS 'Especialização de USUARIO para desenvolvedores';


-- TABELA: CATEGORIA
-- Descrição: Categorias de jogos (Ação, RPG, Estratégia, etc.)
CREATE TABLE CATEGORIA (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    descricao TEXT
);

COMMENT ON TABLE CATEGORIA IS 'Categorias para classificação de jogos';


-- TABELA: JOGO
-- Descrição: Catálogo de jogos disponíveis na plataforma
CREATE TABLE JOGO (
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    data_lancamento DATE,
    classificacao_etaria VARCHAR(10) CHECK (classificacao_etaria IN ('LIVRE', '10+', '12+', '14+', '16+', '18+')),
    desenvolvedor_id INTEGER NOT NULL,
    media_avaliacoes DECIMAL(3, 2) DEFAULT 0 CHECK (media_avaliacoes >= 0 AND media_avaliacoes <= 5),
    
    CONSTRAINT fk_jogo_desenvolvedor FOREIGN KEY (desenvolvedor_id) 
        REFERENCES DESENVOLVEDOR(id_desenvolvedor) ON DELETE RESTRICT
);

-- Índices para performance
CREATE INDEX idx_jogo_desenvolvedor ON JOGO(desenvolvedor_id);
CREATE INDEX idx_jogo_preco ON JOGO(preco);
CREATE INDEX idx_jogo_titulo ON JOGO(titulo);

COMMENT ON TABLE JOGO IS 'Catálogo de jogos disponíveis na plataforma';
COMMENT ON COLUMN JOGO.media_avaliacoes IS 'Média calculada automaticamente via trigger';

-- TABELA: JOGO_CATEGORIA (Relacionamento N:N)
-- Descrição: Associação entre jogos e categorias
CREATE TABLE JOGO_CATEGORIA (
    jogo_id INTEGER NOT NULL,
    categoria_id INTEGER NOT NULL,
    
    PRIMARY KEY (jogo_id, categoria_id),
    
    CONSTRAINT fk_jogo_cat_jogo FOREIGN KEY (jogo_id) 
        REFERENCES JOGO(id_jogo) ON DELETE CASCADE,
    CONSTRAINT fk_jogo_cat_categoria FOREIGN KEY (categoria_id) 
        REFERENCES CATEGORIA(id_categoria) ON DELETE CASCADE
);

COMMENT ON TABLE JOGO_CATEGORIA IS 'Tabela associativa N:N entre JOGO e CATEGORIA';

-- TABELA: DLC (Relacionamento 1:N com JOGO)
-- Descrição: Conteúdos adicionais (DLCs/Expansões) para jogos
CREATE TABLE DLC (
    id_dlc SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    data_lancamento DATE,
    jogo_id INTEGER NOT NULL,
    
    -- FK para JOGO (1:N)
    CONSTRAINT fk_dlc_jogo FOREIGN KEY (jogo_id) 
        REFERENCES JOGO(id_jogo) ON DELETE CASCADE
);
CREATE INDEX idx_dlc_jogo ON DLC(jogo_id);
COMMENT ON TABLE DLC IS 'Conteúdos adicionais (DLCs) vinculados a jogos';

-- TABELA: CONQUISTA (Relacionamento 1:N com JOGO)
-- Descrição: Achievements/Conquistas disponíveis em jogos
CREATE TABLE CONQUISTA (
    id_conquista SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    xp_recompensa INTEGER DEFAULT 10 CHECK (xp_recompensa >= 0),
    jogo_id INTEGER NOT NULL,
    
    -- FK para JOGO (1:N)
    CONSTRAINT fk_conquista_jogo FOREIGN KEY (jogo_id) 
        REFERENCES JOGO(id_jogo) ON DELETE CASCADE
);
CREATE INDEX idx_conquista_jogo ON CONQUISTA(jogo_id);
COMMENT ON TABLE CONQUISTA IS 'Conquistas (achievements) disponíveis em jogos';

-- TABELA: COMPRA (Relacionamento 1:N com JOGADOR)
-- Descrição: Transações de compra realizadas por jogadores

CREATE TABLE COMPRA (
    id_compra SERIAL PRIMARY KEY,
    jogador_id INTEGER NOT NULL,
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) NOT NULL CHECK (valor_total >= 0),
    metodo_pagamento VARCHAR(30) CHECK (metodo_pagamento IN ('CARTAO_CREDITO', 'CARTAO_DEBITO', 'PIX', 'BOLETO', 'PAYPAL')),
    
    -- FK para JOGADOR (1:N)
    CONSTRAINT fk_compra_jogador FOREIGN KEY (jogador_id) 
        REFERENCES JOGADOR(id_jogador) ON DELETE CASCADE
);

CREATE INDEX idx_compra_jogador ON COMPRA(jogador_id);
CREATE INDEX idx_compra_data ON COMPRA(data_compra);
COMMENT ON TABLE COMPRA IS 'Registro de transações de compra';

-- TABELA: ITEM_COMPRA (Relacionamento 1:N com COMPRA)
-- Descrição: Itens individuais de cada compra (jogos ou DLCs)
CREATE TABLE ITEM_COMPRA (
    id_item SERIAL PRIMARY KEY,
    compra_id INTEGER NOT NULL,
    tipo_item VARCHAR(10) NOT NULL CHECK (tipo_item IN ('JOGO', 'DLC')),
    item_id INTEGER NOT NULL,
    preco_pago DECIMAL(10, 2) NOT NULL CHECK (preco_pago >= 0),
    
    -- FK para COMPRA (1:N)
    CONSTRAINT fk_item_compra FOREIGN KEY (compra_id) 
        REFERENCES COMPRA(id_compra) ON DELETE CASCADE
);
CREATE INDEX idx_item_compra ON ITEM_COMPRA(compra_id);
COMMENT ON TABLE ITEM_COMPRA IS 'Itens individuais de cada transação (jogos ou DLCs)';
COMMENT ON COLUMN ITEM_COMPRA.item_id IS 'ID do jogo ou DLC (polimórfico)';

-- TABELA: AVALIACAO (Relacionamento N:N entre JOGADOR e JOGO)
-- Descrição: Avaliações de jogos feitas por jogadores
CREATE TABLE AVALIACAO (
    id_avaliacao SERIAL PRIMARY KEY,
    jogador_id INTEGER NOT NULL,
    jogo_id INTEGER NOT NULL,
    nota INTEGER NOT NULL CHECK (nota >= 1 AND nota <= 5),
    comentario TEXT,
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- FKs
    CONSTRAINT fk_avaliacao_jogador FOREIGN KEY (jogador_id) 
        REFERENCES JOGADOR(id_jogador) ON DELETE CASCADE,
    CONSTRAINT fk_avaliacao_jogo FOREIGN KEY (jogo_id) 
        REFERENCES JOGO(id_jogo) ON DELETE CASCADE,
    
    -- Restrição: Apenas uma avaliação por jogador/jogo
    CONSTRAINT uk_jogador_jogo UNIQUE (jogador_id, jogo_id)
);
CREATE INDEX idx_avaliacao_jogo ON AVALIACAO(jogo_id);
CREATE INDEX idx_avaliacao_jogador ON AVALIACAO(jogador_id);
COMMENT ON TABLE AVALIACAO IS 'Avaliações (reviews) de jogos feitas por jogadores';

-- TABELA: JOGADOR_CONQUISTA (Relacionamento N:N entre JOGADOR e CONQUISTA)
-- Descrição: Conquistas desbloqueadas por jogadores
CREATE TABLE JOGADOR_CONQUISTA (
    jogador_id INTEGER NOT NULL,
    conquista_id INTEGER NOT NULL,
    data_desbloqueio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (jogador_id, conquista_id),
    
    CONSTRAINT fk_jc_jogador FOREIGN KEY (jogador_id) 
        REFERENCES JOGADOR(id_jogador) ON DELETE CASCADE,
    CONSTRAINT fk_jc_conquista FOREIGN KEY (conquista_id) 
        REFERENCES CONQUISTA(id_conquista) ON DELETE CASCADE
);
COMMENT ON TABLE JOGADOR_CONQUISTA IS 'Tabela associativa N:N - conquistas desbloqueadas por jogadores';

-- PARTE 2: FUNÇÕES PL/PGSQL
-- FUNÇÃO 1: Calcular desconto baseado no nível do jogador
-- Descrição: Retorna a porcentagem de desconto que o jogador tem direito
-- Regra: Nível 1-9: 0%, Nível 10-19: 5%, Nível 20-29: 10%, Nível 30+: 15%

CREATE OR REPLACE FUNCTION calcular_desconto_jogador(p_jogador_id INTEGER)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_nivel INTEGER;
    v_desconto DECIMAL(5,2);
BEGIN
    -- Buscar o nível do jogador
    SELECT nivel INTO v_nivel
    FROM JOGADOR
    WHERE id_jogador = p_jogador_id;
    
    -- Verificar se o jogador existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Jogador com ID % não encontrado', p_jogador_id;
    END IF;
    
    -- Calcular desconto baseado no nível
    IF v_nivel < 10 THEN
        v_desconto := 0;
    ELSIF v_nivel < 20 THEN
        v_desconto := 5.00;
    ELSIF v_nivel < 30 THEN
        v_desconto := 10.00;
    ELSE
        v_desconto := 15.00;
    END IF;
    
    RETURN v_desconto;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION calcular_desconto_jogador IS 
'Calcula a porcentagem de desconto baseada no nível do jogador';

-- FUNÇÃO 2: Verificar se jogador possui um jogo
-- Descrição: Verifica se o jogador já comprou determinado jogo
-- Retorno: TRUE se possui, FALSE caso contrário
CREATE OR REPLACE FUNCTION jogador_possui_jogo(p_jogador_id INTEGER, p_jogo_id INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    v_count INTEGER;
BEGIN
    -- Contar compras do jogo pelo jogador
    SELECT COUNT(*) INTO v_count
    FROM COMPRA c
    INNER JOIN ITEM_COMPRA ic ON c.id_compra = ic.compra_id
    WHERE c.jogador_id = p_jogador_id 
      AND ic.tipo_item = 'JOGO' 
      AND ic.item_id = p_jogo_id;
    
    RETURN v_count > 0;
END;
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION jogador_possui_jogo IS 
'Verifica se o jogador possui determinado jogo em sua biblioteca';


-- PARTE 3: TRIGGERS
-- TRIGGER 1: Atualizar média de avaliações do jogo
-- Descrição: Recalcula a média de avaliações automaticamente quando uma 
--            avaliação é inserida, atualizada ou removida
CREATE OR REPLACE FUNCTION atualizar_media_avaliacoes()
RETURNS TRIGGER AS $$
DECLARE
    v_jogo_id INTEGER;
    v_nova_media DECIMAL(3,2);
BEGIN
    -- Determinar o ID do jogo afetado
    IF TG_OP = 'DELETE' THEN
        v_jogo_id := OLD.jogo_id;
    ELSE
        v_jogo_id := NEW.jogo_id;
    END IF;
    
    -- Calcular nova média
    SELECT COALESCE(AVG(nota), 0) INTO v_nova_media
    FROM AVALIACAO
    WHERE jogo_id = v_jogo_id;
    
    -- Atualizar a tabela JOGO
    UPDATE JOGO
    SET media_avaliacoes = v_nova_media
    WHERE id_jogo = v_jogo_id;
    
    -- Retornar o registro apropriado
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Criar triggers para INSERT, UPDATE e DELETE
CREATE TRIGGER trigger_media_avaliacoes_insert
AFTER INSERT ON AVALIACAO
FOR EACH ROW
EXECUTE FUNCTION atualizar_media_avaliacoes();

CREATE TRIGGER trigger_media_avaliacoes_update
AFTER UPDATE ON AVALIACAO
FOR EACH ROW
EXECUTE FUNCTION atualizar_media_avaliacoes();

CREATE TRIGGER trigger_media_avaliacoes_delete
AFTER DELETE ON AVALIACAO
FOR EACH ROW
EXECUTE FUNCTION atualizar_media_avaliacoes();

COMMENT ON FUNCTION atualizar_media_avaliacoes IS 
'Atualiza automaticamente a média de avaliações do jogo';

-- TRIGGER 2: Adicionar XP ao jogador ao desbloquear conquista
-- Descrição: Quando uma conquista é desbloqueada, adiciona XP automaticamente
--            ao jogador e recalcula seu nível
CREATE OR REPLACE FUNCTION adicionar_xp_conquista()
RETURNS TRIGGER AS $$
DECLARE
    v_xp_recompensa INTEGER;
    v_xp_atual INTEGER;
    v_novo_nivel INTEGER;
BEGIN
    -- Buscar XP da conquista
    SELECT xp_recompensa INTO v_xp_recompensa
    FROM CONQUISTA
    WHERE id_conquista = NEW.conquista_id;
    
    -- Adicionar XP ao jogador
    UPDATE JOGADOR
    SET xp = xp + v_xp_recompensa
    WHERE id_jogador = NEW.jogador_id
    RETURNING xp INTO v_xp_atual;
    
    -- Calcular novo nível (a cada 100 XP = 1 nível)
    v_novo_nivel := (v_xp_atual / 100) + 1;
    
    -- Atualizar nível se necessário
    UPDATE JOGADOR
    SET nivel = v_novo_nivel
    WHERE id_jogador = NEW.jogador_id AND nivel < v_novo_nivel;
    
    RAISE NOTICE 'Jogador % ganhou % XP! XP total: %, Nível: %', 
                 NEW.jogador_id, v_xp_recompensa, v_xp_atual, v_novo_nivel;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_xp_conquista
AFTER INSERT ON JOGADOR_CONQUISTA
FOR EACH ROW
EXECUTE FUNCTION adicionar_xp_conquista();

COMMENT ON FUNCTION adicionar_xp_conquista IS 
'Adiciona XP ao jogador quando uma conquista é desbloqueada';

-- PARTE 4: INSERÇÃO DE DADOS DE TESTE
-- INSERIR CATEGORIAS
INSERT INTO CATEGORIA (nome, descricao) VALUES
('Ação', 'Jogos focados em combate e reflexos rápidos'),
('RPG', 'Jogos de interpretação de papéis com progressão de personagem'),
('Estratégia', 'Jogos que requerem planejamento tático'),
('Aventura', 'Jogos focados em exploração e narrativa'),
('Terror', 'Jogos de horror e suspense'),
('Simulação', 'Simuladores realistas de diversas atividades'),
('Esportes', 'Jogos esportivos e competitivos'),
('Indie', 'Jogos desenvolvidos independentemente');

-- INSERIR USUÁRIOS (JOGADORES E DESENVOLVEDORES)
-- Inserir usuários base (3 jogadores + 3 desenvolvedores)
INSERT INTO USUARIO (nome, email, senha, tipo_usuario) VALUES
-- Jogadores
('Carlos Silva', 'carlos.silva@email.com', 'hash_senha_123', 'JOGADOR'),
('Ana Santos', 'ana.santos@email.com', 'hash_senha_456', 'JOGADOR'),
('Pedro Oliveira', 'pedro.oliveira@email.com', 'hash_senha_789', 'JOGADOR'),
('Maria Costa', 'maria.costa@email.com', 'hash_senha_abc', 'JOGADOR'),
-- Desenvolvedores
('João Mendes', 'joao@pixelstudio.com', 'hash_senha_dev1', 'DESENVOLVEDOR'),
('Laura Ferreira', 'laura@epicgames.com', 'hash_senha_dev2', 'DESENVOLVEDOR'),
('Roberto Lima', 'roberto@indiedev.com', 'hash_senha_dev3', 'DESENVOLVEDOR');

-- Inserir dados específicos de JOGADORES
INSERT INTO JOGADOR (id_jogador, nivel, xp, data_nascimento, pais) VALUES
(1, 15, 1450, '1995-05-20', 'Brasil'),
(2, 8, 720, '1998-08-15', 'Portugal'),
(3, 25, 2480, '1992-03-10', 'Brasil'),
(4, 3, 180, '2000-11-25', 'Brasil');

-- Inserir dados específicos de DESENVOLVEDORES
INSERT INTO DESENVOLVEDOR (id_desenvolvedor, nome_estudio, website, cnpj, data_fundacao) VALUES
(5, 'Pixel Studio', 'www.pixelstudio.com', '12.345.678/0001-90', '2015-06-01'),
(6, 'Epic Games Brasil', 'www.epicgames.com.br', '98.765.432/0001-10', '2010-03-15'),
(7, 'Indie Dev Team', 'www.indiedevteam.com', '11.222.333/0001-44', '2018-09-20');

-- INSERIR JOGOS
INSERT INTO JOGO (titulo, descricao, preco, data_lancamento, classificacao_etaria, desenvolvedor_id) VALUES
('Cyber Warriors', 'FPS futurista com gráficos incríveis', 199.90, '2023-05-15', '16+', 5),
('Fantasy Quest VII', 'RPG épico com mundo aberto', 249.90, '2023-03-20', '12+', 6),
('Terror na Floresta', 'Survival horror em primeira pessoa', 89.90, '2023-08-10', '18+', 7),
('Space Strategy', 'Jogo de estratégia espacial em tempo real', 149.90, '2022-11-05', '10+', 5),
('Racing Champions', 'Simulador de corridas realista', 179.90, '2023-01-25', 'LIVRE', 6),
('Puzzle Master', 'Jogo de quebra-cabeças relaxante', 39.90, '2023-06-30', 'LIVRE', 7),
('Battle Royale Ultimate', 'BR com 100 jogadores em mapa gigante', 0.00, '2023-04-01', '14+', 5);

-- ASSOCIAR JOGOS A CATEGORIAS (N:N)
INSERT INTO JOGO_CATEGORIA (jogo_id, categoria_id) VALUES
-- Cyber Warriors: Ação
(1, 1),
-- Fantasy Quest VII: RPG + Aventura
(2, 2), (2, 4),
-- Terror na Floresta: Terror + Aventura
(3, 5), (3, 4),
-- Space Strategy: Estratégia
(4, 3),
-- Racing Champions: Esportes + Simulação
(5, 7), (5, 6),
-- Puzzle Master: Indie
(6, 8),
-- Battle Royale Ultimate: Ação
(7, 1);

-- INSERIR DLCs
INSERT INTO DLC (nome, descricao, preco, data_lancamento, jogo_id) VALUES
('Cyber Warriors - Arsenal Expandido', 'Novas armas e equipamentos', 49.90, '2023-07-20', 1),
('Fantasy Quest VII - Terras Perdidas', 'Nova região explorável com 20h de gameplay', 79.90, '2023-09-15', 2),
('Terror na Floresta - Capítulo 2', 'Continuação da história principal', 39.90, '2023-11-01', 3),
('Space Strategy - Novas Civilizações', 'Adiciona 5 novas raças jogáveis', 59.90, '2023-02-10', 4),
('Battle Royale Ultimate - Passe de Temporada', 'Skins exclusivas e desafios', 29.90, '2023-05-01', 7);

-- INSERIR CONQUISTAS
INSERT INTO CONQUISTA (nome, descricao, xp_recompensa, jogo_id) VALUES
-- Cyber Warriors
('Primeira Vitória', 'Vença sua primeira partida', 50, 1),
('Mestre Atirador', 'Acerte 100 headshots', 100, 1),
('Veterano', 'Complete 50 partidas', 150, 1),
-- Fantasy Quest VII
('Herói Novato', 'Complete o tutorial', 25, 2),
('Explorador', 'Descubra todos os locais do mapa', 200, 2),
('Lenda Viva', 'Alcance o nível máximo', 500, 2),
-- Terror na Floresta
('Sobrevivente', 'Sobreviva à primeira noite', 75, 3),
('Sem Medo', 'Complete o jogo sem morrer', 300, 3),
-- Space Strategy
('Conquistador Galáctico', 'Conquiste 10 planetas', 100, 4),
-- Racing Champions
('Campeão', 'Vença todos os campeonatos', 250, 5),
-- Puzzle Master
('Mestre dos Puzzles', 'Complete todos os níveis', 150, 6),
-- Battle Royale
('Vitória Real', 'Vença uma partida', 100, 7),
('Top 10', 'Fique entre os 10 melhores em 20 partidas', 150, 7);

-- INSERIR COMPRAS
INSERT INTO COMPRA (jogador_id, data_compra, valor_total, metodo_pagamento) VALUES
(1, '2023-06-01 14:30:00', 199.90, 'PIX'),
(1, '2023-08-15 20:15:00', 249.90, 'CARTAO_CREDITO'),
(2, '2023-07-10 10:00:00', 89.90, 'CARTAO_DEBITO'),
(3, '2023-05-20 16:45:00', 329.80, 'CARTAO_CREDITO'),
(3, '2023-09-05 11:20:00', 79.90, 'PIX'),
(4, '2023-10-01 19:30:00', 39.90, 'PIX'),
(2, '2023-11-15 15:00:00', 149.90, 'CARTAO_CREDITO');

-- INSERIR ITENS DAS COMPRAS
INSERT INTO ITEM_COMPRA (compra_id, tipo_item, item_id, preco_pago) VALUES
-- Compra 1 (Carlos): Cyber Warriors
(1, 'JOGO', 1, 199.90),
-- Compra 2 (Carlos): Fantasy Quest VII
(2, 'JOGO', 2, 249.90),
-- Compra 3 (Ana): Terror na Floresta
(3, 'JOGO', 3, 89.90),
-- Compra 4 (Pedro): Cyber Warriors + DLC + Fantasy Quest VII
(4, 'JOGO', 1, 199.90),
(4, 'DLC', 1, 49.90),
(4, 'JOGO', 4, 79.90),
-- Compra 5 (Pedro): DLC Fantasy Quest
(5, 'DLC', 2, 79.90),
-- Compra 6 (Maria): Puzzle Master
(6, 'JOGO', 6, 39.90),
-- Compra 7 (Ana): Space Strategy
(7, 'JOGO', 4, 149.90);

-- INSERIR AVALIAÇÕES
INSERT INTO AVALIACAO (jogador_id, jogo_id, nota, comentario) VALUES
(1, 1, 5, 'Jogo incrível! Gráficos espetaculares e jogabilidade fluida.'),
(1, 2, 4, 'Muito bom, mas poderia ter mais conteúdo pós-game.'),
(2, 3, 5, 'O melhor jogo de terror que já joguei! Atmosfera perfeita.'),
(3, 1, 4, 'Ótimo FPS, mas precisa de mais mapas.'),
(3, 4, 5, 'Viciante! Já passei 100 horas jogando.'),
(4, 6, 3, 'Bom para relaxar, mas ficou repetitivo após alguns níveis.'),
(2, 4, 4, 'Estratégia complexa e desafiadora, recomendo!');

-- INSERIR CONQUISTAS DESBLOQUEADAS
INSERT INTO JOGADOR_CONQUISTA (jogador_id, conquista_id) VALUES
-- Carlos desbloqueou conquistas do Cyber Warriors
(1, 1), (1, 2),
-- Carlos desbloqueou conquista do Fantasy Quest
(1, 4),
-- Ana desbloqueou conquistas do Terror na Floresta
(2, 7), (2, 8),
-- Pedro desbloqueou várias conquistas
(3, 1), (3, 2), (3, 3), (3, 9),
-- Maria desbloqueou conquista do Puzzle Master
(4, 11);

-- PARTE 5: CONSULTAS OBRIGATÓRIAS
-- CONSULTA 1: FUNÇÃO AGREGADA com GROUP BY
-- Descrição: Total de vendas e receita por desenvolvedor
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

-- CONSULTA 2: HAVING
-- Descrição: Jogos com mais de 2 vendas e média de avaliação >= 4.0
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

-- PARTE 6: CONSULTAS ADICIONAIS DE EXEMPLO
-- Top 5 jogos mais vendidos
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

-- Ranking de jogadores por XP
SELECT 
    u.nome AS "Jogador",
    jog.nivel AS "Nível",
    jog.xp AS "XP Total",
    COUNT(DISTINCT jc.conquista_id) AS "Conquistas Desbloqueadas",
    calcular_desconto_jogador(jog.id_jogador) AS "Desconto (%)"
FROM JOGADOR jog
INNER JOIN USUARIO u ON jog.id_jogador = u.id_usuario
LEFT JOIN JOGADOR_CONQUISTA jc ON jog.id_jogador = jc.jogador_id
GROUP BY jog.id_jogador, u.nome, jog.nivel, jog.xp
ORDER BY jog.xp DESC;

-- Biblioteca de jogos de um jogador específico
SELECT 
    u.nome AS "Jogador",
    j.titulo AS "Jogo",
    c.data_compra AS "Data de Compra",
    ic.preco_pago AS "Preço Pago"
FROM JOGADOR jog
INNER JOIN USUARIO u ON jog.id_jogador = u.id_usuario
INNER JOIN COMPRA c ON jog.id_jogador = c.jogador_id
INNER JOIN ITEM_COMPRA ic ON c.id_compra = ic.compra_id
INNER JOIN JOGO j ON ic.item_id = j.id_jogo AND ic.tipo_item = 'JOGO'
WHERE jog.id_jogador = 3  -- Pedro
ORDER BY c.data_compra DESC;

-- Jogos por categoria com estatísticas
SELECT 
    cat.nome AS "Categoria",
    COUNT(DISTINCT jc.jogo_id) AS "Quantidade de Jogos",
    COALESCE(AVG(j.preco), 0) AS "Preço Médio",
    COALESCE(AVG(j.media_avaliacoes), 0) AS "Avaliação Média"
FROM CATEGORIA cat
LEFT JOIN JOGO_CATEGORIA jc ON cat.id_categoria = jc.categoria_id
LEFT JOIN JOGO j ON jc.jogo_id = j.id_jogo
GROUP BY cat.id_categoria, cat.nome
ORDER BY "Quantidade de Jogos" DESC;

-- DLCs disponíveis para jogos que o jogador possui
SELECT 
    j.titulo AS "Jogo Base",
    d.nome AS "DLC",
    d.preco AS "Preço",
    CASE 
        WHEN dlc_comprada.id_item IS NOT NULL THEN 'Já possui'
        ELSE 'Disponível para compra'
    END AS "Status"
FROM JOGADOR jog
INNER JOIN COMPRA c ON jog.id_jogador = c.jogador_id
INNER JOIN ITEM_COMPRA ic ON c.id_compra = ic.compra_id AND ic.tipo_item = 'JOGO'
INNER JOIN JOGO j ON ic.item_id = j.id_jogo
INNER JOIN DLC d ON j.id_jogo = d.jogo_id
LEFT JOIN (
    SELECT ic2.item_id, ic2.id_item
    FROM COMPRA c2
    INNER JOIN ITEM_COMPRA ic2 ON c2.id_compra = ic2.compra_id
    WHERE c2.jogador_id = 3 AND ic2.tipo_item = 'DLC'
) dlc_comprada ON d.id_dlc = dlc_comprada.item_id
WHERE jog.id_jogador = 3  -- Pedro
ORDER BY j.titulo;

-- PARTE 7: TESTES DAS FUNÇÕES
-- Teste da função calcular_desconto_jogador
SELECT 
    u.nome AS "Jogador",
    j.nivel AS "Nível",
    calcular_desconto_jogador(j.id_jogador) AS "Desconto (%)"
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
ORDER BY j.nivel DESC;

-- Teste da função jogador_possui_jogo
SELECT 
    u.nome AS "Jogador",
    jogo.titulo AS "Jogo",
    CASE 
        WHEN jogador_possui_jogo(j.id_jogador, jogo.id_jogo) THEN '✓ Possui'
        ELSE '✗ Não possui'
    END AS "Status"
FROM JOGADOR j
INNER JOIN USUARIO u ON j.id_jogador = u.id_usuario
CROSS JOIN (SELECT id_jogo, titulo FROM JOGO LIMIT 3) jogo
ORDER BY u.nome, jogo.titulo;

-- PARTE 8: RELATÓRIOS E ESTATÍSTICAS
-- Estatísticas gerais da plataforma
SELECT 
    (SELECT COUNT(*) FROM JOGADOR) AS "Total de Jogadores",
    (SELECT COUNT(*) FROM DESENVOLVEDOR) AS "Total de Desenvolvedores",
    (SELECT COUNT(*) FROM JOGO) AS "Total de Jogos",
    (SELECT COUNT(*) FROM COMPRA) AS "Total de Compras",
    (SELECT COALESCE(SUM(valor_total), 0) FROM COMPRA) AS "Receita Total (R$)",
    (SELECT COUNT(*) FROM AVALIACAO) AS "Total de Avaliações";

-- Avaliações recentes com informações completas
SELECT 
    u.nome AS "Jogador",
    j.titulo AS "Jogo",
    a.nota AS "Nota",
    a.comentario AS "Comentário",
    a.data_avaliacao AS "Data"
FROM AVALIACAO a
INNER JOIN JOGADOR jog ON a.jogador_id = jog.id_jogador
INNER JOIN USUARIO u ON jog.id_jogador = u.id_usuario
INNER JOIN JOGO j ON a.jogo_id = j.id_jogo
ORDER BY a.data_avaliacao DESC
LIMIT 10;

SELECT '✅ Banco de dados GameVault criado com sucesso!' AS "Status",
       'Execute as consultas acima para testar o sistema' AS "Próximo Passo";
