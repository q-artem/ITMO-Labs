DROP TABLE IF EXISTS color CASCADE;
DROP TABLE IF EXISTS pattern_element CASCADE;
DROP TABLE IF EXISTS pattern CASCADE;
DROP TABLE IF EXISTS special_color CASCADE;
DROP TABLE IF EXISTS texture CASCADE;
DROP TABLE IF EXISTS material CASCADE;
DROP TABLE IF EXISTS linguistic_form CASCADE;
DROP TABLE IF EXISTS world_expert CASCADE;
DROP TABLE IF EXISTS known_worlds CASCADE;
DROP TABLE IF EXISTS forms_of_inscriptions CASCADE;
DROP TABLE IF EXISTS contents_of_inscriptions CASCADE;
DROP TABLE IF EXISTS property CASCADE;
DROP TABLE IF EXISTS lookses CASCADE;
DROP TABLE IF EXISTS type_inscription CASCADE;
DROP TABLE IF EXISTS inscription CASCADE;
DROP TABLE IF EXISTS figurine CASCADE;
DROP TABLE IF EXISTS texture_to_special_color CASCADE;
DROP TABLE IF EXISTS pattern_to_special_color CASCADE;
DROP TABLE IF EXISTS linguistic_form_to_world_expert CASCADE;
DROP TABLE IF EXISTS property_to_lookses CASCADE;

-- 1
CREATE TABLE color (
                       id SERIAL PRIMARY KEY,
                       name VARCHAR(64) NOT NULL,
                       channel_R INT NOT NULL CHECK (channel_R BETWEEN 0 AND 255),
                       channel_G INT NOT NULL CHECK (channel_G BETWEEN 0 AND 255),
                       channel_B INT NOT NULL CHECK (channel_B BETWEEN 0 AND 255)
);

-- 2
CREATE TABLE pattern_element (
                                 id SERIAL PRIMARY KEY,
                                 name TEXT NOT NULL,
                                 size DECIMAL NOT NULL CHECK (size > 0),
                                 scale DECIMAL NOT NULL CHECK (scale > 0),
                                 luminous_intensity DECIMAL NOT NULL CHECK (luminous_intensity >= 0)
);

-- 3
CREATE TABLE pattern (
                         id SERIAL PRIMARY KEY,
                         pattern_element_id INT REFERENCES pattern_element(id) ON DELETE SET NULL
);

-- 4
CREATE TABLE special_color (
                               id SERIAL PRIMARY KEY,
                               name TEXT NOT NULL,
                               luminous_intensity DECIMAL NOT NULL CHECK (luminous_intensity >= 0),
                               reflection_intensity DECIMAL NOT NULL CHECK (reflection_intensity BETWEEN 0 AND 1)
);

-- 5
CREATE TABLE texture (
                         id SERIAL PRIMARY KEY,
                         name TEXT NOT NULL,
                         average_lenght DECIMAL NOT NULL CHECK (average_lenght > 0)
);

-- 6
CREATE TABLE material (
                          id SERIAL PRIMARY KEY,
                          type TEXT NOT NULL,
                          color_id INT REFERENCES color(id) ON DELETE SET NULL,
                          pattern_id INT REFERENCES pattern(id) ON DELETE SET NULL,
                          texture_id INT REFERENCES texture(id) ON DELETE SET NULL,
                          is_known BOOL NOT NULL
);

-- 7
CREATE TABLE linguistic_form (
                                 id SERIAL PRIMARY KEY,
                                 name TEXT,
                                 county TEXT
);

-- 8
CREATE TABLE world_expert (
                                                   id SERIAL PRIMARY KEY,
                                                   name TEXT NOT NULL,
                                                   surname TEXT NOT NULL,
                                                   county TEXT NOT NULL,
                                                   is_at_the_congress BOOL NOT NULL
);

-- 9
CREATE TABLE known_worlds (
                              id SERIAL PRIMARY KEY,
                              name TEXT
);

-- 10
CREATE TABLE forms_of_inscriptions (
                                       id SERIAL PRIMARY KEY,
                                       name TEXT NOT NULL,
                                       worlds_identity_id INT REFERENCES known_worlds(id) ON DELETE SET NULL
);

-- 11
CREATE TABLE contents_of_inscriptions (
                                          id SERIAL PRIMARY KEY,
                                          data TEXT NOT NULL,
                                          worlds_identity_id INT REFERENCES known_worlds(id) ON DELETE SET NULL
);

-- 12
CREATE TABLE property (
                          id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL
);

-- 13
CREATE TABLE lookses (
                         id SERIAL PRIMARY KEY,
                         type TEXT,
                         about TEXT,
                         worlds_identity_id INT REFERENCES known_worlds(id) ON DELETE SET NULL
);

-- 14
CREATE TABLE type_inscription (
                                  id SERIAL PRIMARY KEY,
                                  name TEXT NOT NULL,
                                  form_of_inscriptions_id INT REFERENCES forms_of_inscriptions(id) ON DELETE SET NULL,
                                  content_of_inscription_id INT REFERENCES contents_of_inscriptions(id) ON DELETE SET NULL,
                                  looks_id INT REFERENCES lookses(id) ON DELETE SET NULL
);

-- 15
CREATE TABLE inscription (
                             id SERIAL PRIMARY KEY,
                             position TEXT NOT NULL CHECK (position IN ('TOP', 'MIDDLE', 'BOTTOM')),
                             linguistic_form_id INT REFERENCES linguistic_form(id) ON DELETE SET NULL,
                             type_inscription_id INT REFERENCES type_inscription(id) ON DELETE SET NULL
);

-- 16
CREATE TABLE figurine (
                          id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL,
                          material_id  INT REFERENCES material(id) ON DELETE SET NULL,
                          inscription_id  INT REFERENCES inscription(id) ON DELETE SET NULL
);

-- 17
CREATE TABLE texture_to_special_color (
                                          texture_id INTEGER REFERENCES texture(id),
                                          special_color_id INTEGER REFERENCES special_color(id),
                                          PRIMARY KEY (texture_id, special_color_id)
);

-- 18
CREATE TABLE pattern_to_special_color (
                                          pattern_id INTEGER REFERENCES pattern(id),
                                          special_color_id INTEGER REFERENCES special_color(id),
                                          PRIMARY KEY (pattern_id, special_color_id)
);

-- 19
CREATE TABLE linguistic_form_to_world_expert (
                                                                      linguistic_form_id INTEGER REFERENCES linguistic_form(id),
                                                                      world_expert_id INTEGER REFERENCES world_expert(id),
                                                                      PRIMARY KEY (linguistic_form_id, world_expert_id)
);

-- 20
CREATE TABLE property_to_lookses (
                                     property_id INTEGER REFERENCES property(id),
                                     lookses_id INTEGER REFERENCES lookses(id),
                                     PRIMARY KEY (property_id, lookses_id)
);

INSERT INTO color (name, channel_R, channel_G, channel_B) VALUES ('Зеленовато-чёрный', 17, 31, 13);
INSERT INTO color (name, channel_R, channel_G, channel_B) VALUES ('Зеленый', 0, 255, 0);
INSERT INTO color (name, channel_R, channel_G, channel_B) VALUES ('Красный', 255, 0, 0);
INSERT INTO color (name, channel_R, channel_G, channel_B) VALUES ('Синий', 0, 0, 255);

INSERT INTO pattern_element (name, size, scale, luminous_intensity) VALUES ('Крапинка', 3.12, 70.7, 10);

INSERT INTO pattern (pattern_element_id) VALUES (1);

INSERT INTO special_color (name, luminous_intensity, reflection_intensity) VALUES ('Золотой', 24.41, 0.03);
INSERT INTO special_color (name, luminous_intensity, reflection_intensity) VALUES ('Радужный', 67.92, 0.27);
INSERT INTO special_color (name, luminous_intensity, reflection_intensity) VALUES ('Серобуромалиновый', 0.0001, 0.12);
INSERT INTO special_color (name, luminous_intensity, reflection_intensity) VALUES ('Буросеромалиновый', 0.321, 0.4562);

INSERT INTO texture (name, average_lenght) VALUES ('Прожилки', 13.21);

INSERT INTO material (type, color_id, pattern_id, texture_id, is_known) VALUES ('Камень', 1, 1, 1, FALSE);

INSERT INTO linguistic_form (name, county) VALUES (NULL, NULL);
INSERT INTO linguistic_form (name, county) VALUES ('Иероглифическая', 'Китай');
INSERT INTO linguistic_form (name, county) VALUES ('Кириллическая', 'Старославянское царство');

INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('Иван', 'Петров', 'Россия', FALSE);
INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('Emily', 'Johnson', 'USA', FALSE);
INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('Дмитрий', 'Преображенский', 'Россия', FALSE);
INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('Екатерина', 'Кузнецова', 'Казахстан', FALSE);
INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('Daniel', 'Wilson', 'Italy', FALSE);
INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('Olivia', 'Martinez', 'India', FALSE);
INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('Maria', 'Soker', 'Japan', FALSE);
INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('James', 'Clark', 'Mexica', FALSE);
INSERT INTO world_expert (name, surname, county, is_at_the_congress) VALUES ('Ava', 'Anderson', 'Brasilia', FALSE);

INSERT INTO known_worlds (name) VALUES (NULL);
INSERT INTO known_worlds (name) VALUES ('Человечество');
INSERT INTO known_worlds (name) VALUES ('Природа');

INSERT INTO forms_of_inscriptions (name, worlds_identity_id) VALUES ('Иероглифы', 1);

INSERT INTO contents_of_inscriptions (data, worlds_identity_id) VALUES ('m80;90r№;y8%;h9x:?', 1);

INSERT INTO property (name) VALUES ('Древность');
INSERT INTO property (name) VALUES ('Непосвящённость');

INSERT INTO lookses (type, about, worlds_identity_id) VALUES ('Напоминание', 'циклы жизни', 1);

INSERT INTO type_inscription (name, form_of_inscriptions_id, content_of_inscription_id, looks_id) VALUES ('Иероглифы', 1, 1, 1);

INSERT INTO inscription (position, linguistic_form_id, type_inscription_id) VALUES ('BOTTOM', 1, 1);

INSERT INTO figurine (name, material_id, inscription_id) VALUES ('Фигурка', 1, 1);

INSERT INTO texture_to_special_color (texture_id, special_color_id) VALUES (1, 3);
INSERT INTO texture_to_special_color (texture_id, special_color_id) VALUES (1, 4);

INSERT INTO pattern_to_special_color (pattern_id, special_color_id) VALUES (1, 1);
INSERT INTO pattern_to_special_color (pattern_id, special_color_id) VALUES (1, 2);

INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (2, 1);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (3, 1);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (2, 3);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (2, 2);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (3, 4);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (2, 9);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (3, 5);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (2, 5);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (2, 7);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (3, 8);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (2, 8);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (3, 6);
INSERT INTO linguistic_form_to_world_expert (linguistic_form_id, world_expert_id) VALUES (2, 6);

INSERT INTO property_to_lookses (property_id, lookses_id) VALUES (1, 1);
INSERT INTO property_to_lookses (property_id, lookses_id) VALUES (2, 1);