-- =========================================================
--  Italian Brainrots — Schéma SQL PostgreSQL
--  Remarque: adapte les ENUM / récompenses selon ton game design
-- =========================================================
-- ---------------------------------------------------------
-- Types
-- ---------------------------------------------------------
DO $$ BEGIN IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'rarete'
) THEN CREATE TYPE rarete AS ENUM (
  'commun',
  'rare',
  'epique',
  'legendaire',
  'mythique'
);
END IF;
END $$;
-- ---------------------------------------------------------
-- Utilisateurs
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  login TEXT NOT NULL,
  -- Stocke un hash (ex: bcrypt/argon2). NE JAMAIS stocker le mot de passe en clair.
  password_hash TEXT NOT NULL,
  soft_currency BIGINT NOT NULL DEFAULT 0,
  -- monnaie de base gagnée en aventure
  hard_currency BIGINT NOT NULL DEFAULT 0,
  -- optionnel: premium
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (login)
);
-- Déclencheur simple pour updated_at
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS TRIGGER LANGUAGE plpgsql AS $$ BEGIN NEW.updated_at := now();
RETURN NEW;
END $$;
CREATE TRIGGER users_set_updated_at BEFORE
UPDATE ON users FOR EACH ROW EXECUTE FUNCTION set_updated_at();
-- Unicité insensible à la casse sur login (sans extension citext)
CREATE UNIQUE INDEX IF NOT EXISTS users_login_lower_idx ON users (LOWER(login));
-- ---------------------------------------------------------
-- Capacités (facultatif, pour relier une carte à une capacité)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS capacities (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nom TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT ''
);
-- ---------------------------------------------------------
-- Cartes
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS cards (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nom TEXT NOT NULL,
  puissance INTEGER NOT NULL CHECK (puissance >= 0),
  rarete rarete NOT NULL,
  id_capacite BIGINT NULL REFERENCES capacities(id) ON DELETE
  SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (nom)
);
-- Insertion des 150 cartes Alpha
INSERT INTO cards (nom, puissance, rarete, id_capacite)
VALUES ('Bluberini Octopusini', 0, 'commun', NULL),
  ('Tirilicalica Tirilicalaco', 0, 'commun', NULL),
  ('Coccodrillo Formaggioso', 0, 'commun', NULL),
  ('Panbroncio Al Latte', 0, 'commun', NULL),
  ('Marco Pollo', 0, 'commun', NULL),
  ('Oca Del Rover Lunare', 0, 'commun', NULL),
  ('Gangster Footera', 0, 'commun', NULL),
  ('Cacto Ippopotamo', 0, 'commun', NULL),
  ('Raparrapa Che Para', 0, 'commun', NULL),
  ('Cervello Pudding', 0, 'commun', NULL),
  ('Gnammo Slammo E Sgommo', 0, 'commun', NULL),
  ('Aeromucca Armata', 0, 'commun', NULL),
  ('Caprampante Sottopanca', 0, 'commun', NULL),
  ('Frulli Frulla', 0, 'commun', NULL),
  ('Crocodilo Potatino', 0, 'commun', NULL),
  ('Boneca Ambalabu', 0, 'commun', NULL),
  (
    'Trippa Troppa Tralala Larila Tung Tung Sahur Boneca Tung Tung Tralalelo Trippi Troppa Crocodina',
    0,
    'commun',
    NULL
  ),
  ('Rugginato Lupogt', 0, 'commun', NULL),
  ('Ballerino Lololo', 0, 'commun', NULL),
  ('La Vacca Atomo Atomita', 0, 'commun', NULL),
  ('Trikitrakatelas', 0, 'commun', NULL),
  ('Apollino Cappuccino', 0, 'commun', NULL),
  ('Ballerina Nicotina', 0, 'commun', NULL),
  ('Pararell Bararell', 0, 'commun', NULL),
  ('Buraburra Burattinaro', 0, 'commun', NULL),
  ('Luminaria Fiorenza', 0, 'commun', NULL),
  ('Ratatino Rottamino', 0, 'commun', NULL),
  ('Chimpanzini Bananini', 0, 'commun', NULL),
  ('Tralalita Tralalelita', 0, 'commun', NULL),
  ('Mangga Terkuat', 0, 'commun', NULL),
  ('Pastarugo Calamarello', 0, 'commun', NULL),
  ('Evil Baby Octi Triplets', 0, 'commun', NULL),
  ('Sgommabirillo Brillo', 0, 'commun', NULL),
  (
    'Tracotucotulu Delapeladustuz',
    0,
    'commun',
    NULL
  ),
  ('Tric Trac Baraboom', 0, 'commun', NULL),
  ('Matteo', 0, 'commun', NULL),
  ('Trr Trr Patepim', 0, 'commun', NULL),
  ('Lirili Larila', 0, 'commun', NULL),
  ('Platypus Boos Boos Boos', 0, 'commun', NULL),
  (
    'Garam Mararam Raraman Mararaman',
    0,
    'commun',
    NULL
  ),
  ('Tiktarugo Ritardone', 0, 'commun', NULL),
  ('Tung tung Tung…Sahur', 0, 'commun', NULL),
  ('Apellone Di Pollopelle', 0, 'commun', NULL),
  ('Dissatrullo Canniballo', 0, 'commun', NULL),
  ('Mousarini Pistolini', 0, 'commun', NULL),
  ('Tacchitacchi Attaccaticcio', 0, 'commun', NULL),
  ('Budinaccio Del Disgusto', 0, 'commun', NULL),
  ('Cagnoilno Insaponato', 0, 'commun', NULL),
  ('Ping Pong Pongaro', 0, 'commun', NULL),
  ('Giraffa Celeste', 0, 'commun', NULL),
  ('Skibidetto Toaletto', 0, 'commun', NULL),
  (
    'Batatoso Peloso, Strambo e Guloso',
    0,
    'commun',
    NULL
  ),
  ('Piccione Macchina', 0, 'commun', NULL),
  ('Melanini Pandanini', 0, 'commun', NULL),
  ('Los Lirilitos Dicen Larila!', 0, 'commun', NULL),
  ('Tangerini Octopusini', 0, 'commun', NULL),
  ('Phone Selfone', 0, 'commun', NULL),
  ('Strand Bier', 0, 'commun', NULL),
  ('Fomo Sapiens', 0, 'commun', NULL),
  ('Ballerina Cappuccina', 0, 'commun', NULL),
  ('Tralalito Boccioso', 0, 'commun', NULL),
  ('Bitburger Coin', 0, 'commun', NULL),
  ('Raccrapappiccicante', 0, 'commun', NULL),
  ('Grattacielo Letterale', 0, 'commun', NULL),
  ('Graipussi Medussi', 0, 'commun', NULL),
  ('Nuclearo Dinosauro', 0, 'commun', NULL),
  (
    'Rupipipipipipi Streamimimimimimi',
    0,
    'commun',
    NULL
  ),
  ('Zampatigna Zoppicante', 0, 'commun', NULL),
  ('Babbobombo Caramello', 0, 'commun', NULL),
  ('Frr Frr Chimpanifriti', 0, 'commun', NULL),
  ('Kotletino Merkatino', 0, 'commun', NULL),
  ('Scio Scio Champignon', 0, 'commun', NULL),
  ('Belerick', 0, 'commun', NULL),
  ('Bomboclat Crococlat', 0, 'commun', NULL),
  ('Bombaristo Sealsto Seal', 0, 'commun', NULL),
  ('Tralalero Tralala', 0, 'commun', NULL),
  ('Bearorito Applepitolirotito', 0, 'commun', NULL),
  ('Frigo Camelo', 0, 'commun', NULL),
  ('Margeriti Octopusini', 0, 'commun', NULL),
  ('Pecorini Lanusini', 0, 'commun', NULL),
  ('Glorbo Fruttodrillo', 0, 'commun', NULL),
  ('Merluzzini Marraquetini', 0, 'commun', NULL),
  ('Lolzilla', 0, 'commun', NULL),
  ('Squitti-Squittio Tossichio', 0, 'commun', NULL),
  ('Il Mago Tiramisu', 0, 'commun', NULL),
  ('Seam Salad Bean', 0, 'commun', NULL),
  ('Bombardino Aquilino', 0, 'commun', NULL),
  ('Gambero Spero', 0, 'commun', NULL),
  ('Bombombini Gusini', 0, 'commun', NULL),
  ('El Maialino Candito', 0, 'commun', NULL),
  ('Fritticci Capricci', 0, 'commun', NULL),
  ('Mucca Mokka Ravanello', 0, 'commun', NULL),
  ('Glitchus Memoji', 0, 'commun', NULL),
  ('Astrobarista Shampista', 0, 'commun', NULL),
  ('Managero Uccello', 0, 'commun', NULL),
  ('Bulbosauro Arrossato', 0, 'commun', NULL),
  ('Ganganzeli Trulala', 0, 'commun', NULL),
  ('Patapum Patapa', 0, 'commun', NULL),
  ('Bruto Gialutto', 0, 'commun', NULL),
  ('Boomerauro Rex', 0, 'commun', NULL),
  ('Pink Pony Scrub', 0, 'commun', NULL),
  ('Brr Brr Patapim', 0, 'commun', NULL),
  ('Petozzo Rimbalbalbalbalzino', 0, 'commun', NULL),
  ('Burbaloni Luliloli', 0, 'commun', NULL),
  (
    'Los Tralaleritos Dicen Tralala!',
    0,
    'commun',
    NULL
  ),
  ('Tankitanka Tarlone', 0, 'commun', NULL),
  ('Bombardino Bearino', 0, 'commun', NULL),
  ('Fratmadrillo Flexoso', 0, 'commun', NULL),
  ('Thortellino Fulminato', 0, 'commun', NULL),
  ('Picciopicchio Impiccione', 0, 'commun', NULL),
  ('Frullafrutti Frattale Ninja', 0, 'commun', NULL),
  ('Trulimero Trulicina', 0, 'commun', NULL),
  ('Frusciorso Cagasotto', 0, 'commun', NULL),
  ('Bombardiro Crocodillo', 0, 'commun', NULL),
  ('La Vaca Saturno Saturnita', 0, 'commun', NULL),
  ('Bicicletta Del Gatto Santo', 0, 'commun', NULL),
  ('Linguicine Serpentine', 0, 'commun', NULL),
  ('Palla Gialla', 0, 'commun', NULL),
  ('Trippi Troppi', 0, 'commun', NULL),
  ('Legeni Peshkaqeni', 0, 'commun', NULL),
  ('Trenos Truzzo Turbo 3000', 0, 'commun', NULL),
  ('Sbrocco Se Tocco', 0, 'commun', NULL),
  ('Orangutini Ananasini', 0, 'commun', NULL),
  ('Cocco Bello Sala Mello', 0, 'commun', NULL),
  (
    'Tukitukitukituki Tukitukitukita',
    0,
    'commun',
    NULL
  ),
  ('Tracotocutulo', 0, 'commun', NULL),
  ('Felice Volantino', 0, 'commun', NULL),
  ('Bungoletti Spaghettini', 0, 'commun', NULL),
  ('Geladrone Attack!', 0, 'commun', NULL),
  ('Catpuccino Cactonino', 0, 'commun', NULL),
  ('Formichiazzo Pazzo', 0, 'commun', NULL),
  ('Clickatopo Zummoso', 0, 'commun', NULL),
  ('Tralachicko Jockerito', 0, 'commun', NULL),
  ('Followello Pecorello', 0, 'commun', NULL),
  ('Bombasticcia Salsiccia', 0, 'commun', NULL),
  ('Polpetta Erbivora', 0, 'commun', NULL),
  (
    'Luguanluguanlulushijiandaole',
    0,
    'commun',
    NULL
  ),
  ('Malame Amarale', 0, 'commun', NULL),
  (
    'Bobrini Cactusini Su Saturno',
    0,
    'commun',
    NULL
  ),
  ('Mostrillo Masticamozziconi', 0, 'commun', NULL),
  ('Cocofanto Elefanto', 0, 'commun', NULL),
  ('Fishano Shoebano', 0, 'commun', NULL),
  ('Gattino Aereoplanino', 0, 'commun', NULL),
  ('Coccodrillo Robloxino', 0, 'commun', NULL),
  ('Kiwiquello Chevuoi', 0, 'commun', NULL),
  ('Gallina Galletta Galeotta', 0, 'commun', NULL),
  ('Ghiacciopuzzo Pupazzo', 0, 'commun', NULL),
  ('Trombonini Linguini', 0, 'commun', NULL),
  ('Capuchino Assassino', 0, 'commun', NULL),
  ('Olegolini, der Zauberini', 0, 'commun', NULL);
-- Index sur le nom en minuscules pour recherche insensible a la casse
CREATE INDEX IF NOT EXISTS idx_cards_nom_lower ON cards (LOWER(nom));
-- ---------------------------------------------------------
-- Collection d’un utilisateur (inventaire)
-- ---------------------------------------------------------
-- "position_dans_aventure": comme tu l’as demandé.
-- Si tu préfères suivre la progression au niveau utilisateur (recommandé),
-- vois la table user_adventure_progress plus bas.
CREATE TABLE IF NOT EXISTS user_card_collection (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  card_id BIGINT NOT NULL REFERENCES cards(id) ON DELETE RESTRICT,
  qty INTEGER NOT NULL DEFAULT 1 CHECK (qty > 0),
  position_dans_aventure INTEGER NULL,
  -- libre d’usage selon ton gameplay
  acquired_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, card_id)
);
CREATE INDEX IF NOT EXISTS idx_ucc_user ON user_card_collection(user_id);
CREATE INDEX IF NOT EXISTS idx_ucc_card ON user_card_collection(card_id);
-- ---------------------------------------------------------
-- Adventure / Combats (campagne PVE en succession de combats)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS adventure_battles (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  titre TEXT NOT NULL,
  -- Ordre principal; tu peux aussi n’utiliser que required_battle_id pour les verrous
  sequence_ordre INTEGER NOT NULL,
  required_battle_id BIGINT NULL REFERENCES adventure_battles(id) ON DELETE
  SET NULL,
    reward_soft INTEGER NOT NULL DEFAULT 0 CHECK (reward_soft >= 0),
    -- monnaie gagnée
    reward_hard INTEGER NOT NULL DEFAULT 0 CHECK (reward_hard >= 0),
    -- optionnel
    is_boss BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (sequence_ordre)
);
CREATE INDEX IF NOT EXISTS idx_adv_required ON adventure_battles(required_battle_id);
-- Deck ennemi pour chaque combat (quelles cartes et en quelle quantité)
CREATE TABLE IF NOT EXISTS battle_enemy_deck (
  battle_id BIGINT NOT NULL REFERENCES adventure_battles(id) ON DELETE CASCADE,
  card_id BIGINT NOT NULL REFERENCES cards(id) ON DELETE RESTRICT,
  quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
  PRIMARY KEY (battle_id, card_id)
);
-- ---------------------------------------------------------
-- Progression d’aventure par utilisateur (recommandé)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_adventure_progress (
  user_id BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  highest_unlocked_battle BIGINT NULL REFERENCES adventure_battles(id) ON DELETE
  SET NULL,
    last_completed_battle BIGINT NULL REFERENCES adventure_battles(id) ON DELETE
  SET NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TRIGGER uap_set_updated_at BEFORE
UPDATE ON user_adventure_progress FOR EACH ROW EXECUTE FUNCTION set_updated_at();
-- ---------------------------------------------------------
-- Historique des combats joués (logs)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS battle_runs (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  battle_id BIGINT NOT NULL REFERENCES adventure_battles(id) ON DELETE CASCADE,
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  ended_at TIMESTAMPTZ,
  result TEXT NOT NULL CHECK (result IN ('win', 'loss', 'abandon')),
  reward_soft INTEGER NOT NULL DEFAULT 0 CHECK (reward_soft >= 0),
  reward_hard INTEGER NOT NULL DEFAULT 0 CHECK (reward_hard >= 0)
);
CREATE INDEX IF NOT EXISTS idx_battleruns_user ON battle_runs(user_id);
CREATE INDEX IF NOT EXISTS idx_battleruns_battle ON battle_runs(battle_id);
-- ---------------------------------------------------------
-- Boutique / Paquets (optionnel mais pratique)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS packs (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nom TEXT NOT NULL,
  price_soft INTEGER NOT NULL CHECK (price_soft >= 0),
  price_hard INTEGER NOT NULL CHECK (price_hard >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Répartition de rareté / cartes dans un pack (poids de tirage)
CREATE TABLE IF NOT EXISTS pack_card_pool (
  pack_id BIGINT NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  card_id BIGINT NOT NULL REFERENCES cards(id) ON DELETE RESTRICT,
  weight INTEGER NOT NULL DEFAULT 1 CHECK (weight > 0),
  PRIMARY KEY (pack_id, card_id)
);
-- Achats de packs par les utilisateurs (journalisation)
CREATE TABLE IF NOT EXISTS pack_purchases (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pack_id BIGINT NOT NULL REFERENCES packs(id) ON DELETE RESTRICT,
  paid_soft INTEGER NOT NULL DEFAULT 0 CHECK (paid_soft >= 0),
  paid_hard INTEGER NOT NULL DEFAULT 0 CHECK (paid_hard >= 0),
  purchased_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_pack_purchases_user ON pack_purchases(user_id);
-- ---------------------------------------------------------
-- Vues/Contraintes utiles
-- ---------------------------------------------------------
-- Débloquer automatiquement un combat suivant par défaut sur la base de sequence_ordre:
-- (à gérer plutôt côté logique applicative; ici on s’assure juste des clés)
-- Exemple de vue simple pour l’état de l’aventure d’un user
CREATE OR REPLACE VIEW v_user_adventure_state AS
SELECT u.id AS user_id,
  u.login,
  u.soft_currency,
  u.hard_currency,
  p.highest_unlocked_battle,
  p.last_completed_battle
FROM users u
  LEFT JOIN user_adventure_progress p ON p.user_id = u.id;
-- ---------------------------------------------------------
-- Données de démo minimales (facultatif)
-- ---------------------------------------------------------
-- Capacités
INSERT INTO capacities (nom, description)
VALUES (
    'Mamma Mia',
    'Double la puissance pendant un tour'
  ) ON CONFLICT DO NOTHING;
-- Combats
INSERT INTO adventure_battles (
    titre,
    sequence_ordre,
    required_battle_id,
    reward_soft,
    is_boss
  )
VALUES ('Ruelle de Napoli', 1, NULL, 50, FALSE),
  ('Pont de Firenze', 2, 1, 75, FALSE),
  ('Duomo Showdown', 3, 2, 150, TRUE) ON CONFLICT DO NOTHING;
-- Decks ennemis (exemple)
INSERT INTO battle_enemy_deck (battle_id, card_id, quantity)
SELECT b.id,
  c.id,
  1
FROM adventure_battles b
  JOIN cards c ON c.nom IN ('Capo Di Pasta', 'Nonna Sprint')
WHERE b.sequence_ordre = 1 ON CONFLICT DO NOTHING;
-- ---------------------------------------------------------
-- Bonnes pratiques supplémentaires (notes):
-- - Stocke les mots de passe avec bcrypt/argon2 et mets le hash dans users.password_hash.
-- - Gère le déblocage de combats et l’attribution des récompenses dans ton backend
--   (transactions: UPDATE users SET soft_currency = soft_currency + reward_soft ...).
-- - Utilise des transactions pour les achats de packs + tirage + ajout à la collection.
-- - Ajoute des CHECK/CONSTRAINT selon tes règles métier (ex: progression monotone).
-- =========================================================