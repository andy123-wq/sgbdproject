-- 1. FILMS (15 rows)
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Inception', 'A thief who steals corporate secrets through the use of dream-sharing technology.', 'Sci-Fi', TO_DATE('2010-07-16', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Interstellar', 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity''s survival.', 'Sci-Fi', TO_DATE('2014-11-07', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'The Dark Knight', 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham.', 'Action', TO_DATE('2008-07-18', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Oppenheimer', 'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.', 'Biography', TO_DATE('2023-07-21', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Parasite', 'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.', 'Drama', TO_DATE('2019-11-08', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'La La Land', 'While navigating their careers in Los Angeles, a pianist and an actress fall in love while attempting to reconcile their aspirations for the future.', 'Drama', TO_DATE('2016-12-09', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Avengers Endgame', 'After the devastating events of Infinity War, the universe is in ruins.', 'Action', TO_DATE('2019-04-26', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Shawshank Redemption', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 'Drama', TO_DATE('1994-09-23', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Forrest Gump', 'The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate and other historical events unfold through the perspective of an Alabama man with an IQ of 75.', 'Drama', TO_DATE('1994-07-06', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'The Matrix', 'When a beautiful stranger leads computer hacker Neo to a forbidding underworld, he discovers the shocking truth--the life he knows is the elaborate deception of an evil cyber-intelligence.', 'Sci-Fi', TO_DATE('1999-03-31', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Schindler''s List', 'In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.', 'Biography', TO_DATE('1993-12-15', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Spirited Away', 'During her family''s move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches, and spirits, and where humans are changed into beasts.', 'Animation', TO_DATE('2001-07-20', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Joker', 'In Gotham City, mentally troubled comedian Arthur Fleck is disregarded and mistreated by society.', 'Thriller', TO_DATE('2019-10-04', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Titanic', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', 'Drama', TO_DATE('1997-12-19', 'YYYY-MM-DD'));
INSERT INTO FILMS (id, title, description, category, release_date) VALUES (seq_films.NEXTVAL, 'Gladiator', 'A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery.', 'Action', TO_DATE('2000-05-05', 'YYYY-MM-DD'));

-- 2. VOTE_TAGS (10)
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'mi-a placut');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'nu mi-a placut');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'interesant');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'emotionant');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'plictisitor');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'as recomanda');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'as mai viziona');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'actor principal apreciat');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'scenariu slab');
INSERT INTO VOTE_TAGS (id, tag_name) VALUES (seq_vote_tags.NEXTVAL, 'recomandat prietenilor');

-- 3. FILM_VERSIONS (30+, min 2 per film)
BEGIN
  FOR i IN 1..15 LOOP
    INSERT INTO FILM_VERSIONS (id, film_id, format, resolution, language) VALUES (seq_film_versions.NEXTVAL, i, '4K', '2160p', 'English');
    INSERT INTO FILM_VERSIONS (id, film_id, format, resolution, language) VALUES (seq_film_versions.NEXTVAL, i, 'HD', '1080p', 'Subtitrat RO');
    INSERT INTO FILM_VERSIONS (id, film_id, format, resolution, language) VALUES (seq_film_versions.NEXTVAL, i, 'SD', '480p', 'Romanian');
  END LOOP;
END;
/

-- 4. ACTORS (15)
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Leo DiCapri', 'Leonardo', 'DiCaprio', TO_DATE('1974-11-11', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Matty McC', 'Matthew', 'McConaughey', TO_DATE('1969-11-04', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Christian Bale', 'Christian', 'Bale', TO_DATE('1974-01-30', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Cillian Murphy', 'Cillian', 'Murphy', TO_DATE('1976-05-25', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Song Kang-ho', 'Kang-ho', 'Song', TO_DATE('1967-01-17', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Emma Stone', 'Emma', 'Stone', TO_DATE('1988-11-06', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Robert Downey Jr.', 'Robert', 'Downey', TO_DATE('1965-04-04', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Morgan Freeman', 'Morgan', 'Freeman', TO_DATE('1937-06-01', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Tom Hanks', 'Tom', 'Hanks', TO_DATE('1956-07-09', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Keanu Reeves', 'Keanu', 'Reeves', TO_DATE('1964-09-02', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Liam Neeson', 'Liam', 'Neeson', TO_DATE('1952-06-07', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Rumi Hiiragi', 'Rumi', 'Hiiragi', TO_DATE('1987-08-01', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Joaquin Phoenix', 'Joaquin', 'Phoenix', TO_DATE('1974-10-28', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Kate Winslet', 'Kate', 'Winslet', TO_DATE('1975-10-05', 'YYYY-MM-DD'));
INSERT INTO ACTORS (id, stage_name, first_name, last_name, birth_date) VALUES (seq_actors.NEXTVAL, 'Russell Crowe', 'Russell', 'Crowe', TO_DATE('1964-04-07', 'YYYY-MM-DD'));

-- 5. FILM_ACTORS (25+)
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 1, 1, 'Cobb', 'Exceptional lead');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 2, 2, 'Cooper', 'Great acting');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 3, 3, 'Bruce Wayne', 'Iconic');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 4, 4, 'J. Robert Oppenheimer', 'Masterpiece');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 5, 5, 'Ki-taek', 'Brilliant');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 6, 6, 'Mia', 'Beautiful');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 7, 7, 'Tony Stark', 'Legendary');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 8, 8, 'Ellis Boyd Redding', 'Classic');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 9, 9, 'Forrest Gump', 'Timeless');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 10, 10, 'Neo', 'Groundbreaking');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 11, 11, 'Oskar Schindler', 'Moving');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 12, 12, 'Chihiro', 'Magical');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 13, 13, 'Arthur Fleck', 'Intense');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 14, 1, 'Jack Dawson', 'Romantic');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 14, 14, 'Rose DeWitt Bukater', 'Stunning');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 15, 15, 'Maximus', 'Epic');
-- Add a few more overlapping actors
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 1, 4, 'Fischer', 'Solid');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 3, 8, 'Lucius Fox', 'Great support');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 7, 3, 'Cameo', 'Fun');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 4, 7, 'Lewis Strauss', 'Intense performance');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 2, 4, 'Scientist', 'Good');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 9, 8, 'Narrator', 'Voice');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 15, 13, 'Commodus', 'Villainous');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 6, 1, 'Producer', 'Cameo');
INSERT INTO FILM_ACTORS (id, film_id, actor_id, role_description, performance_comment) VALUES (seq_film_actors.NEXTVAL, 10, 15, 'Programmer', 'Extra');

-- 6. CLIENTS (15)
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Andrei', 'Popescu', '0232111222', 'Str. Unirii 10', 'Iasi', 'andrei@yahoo.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Elena', 'Ionescu', '0232333444', 'Str. Cuza Voda 5', 'Iasi', 'elena@gmail.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Mihai', 'Radu', '0211223344', 'Bd. Magheru 1', 'Bucuresti', 'mihai@gmail.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Ioana', 'Dumitrescu', '0264112233', 'Piața Unirii 2', 'Cluj', 'ioana@yahoo.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Alex', 'Stan', '0256111222', 'Str. Vasile Alecsandri 8', 'Timisoara', 'alex@gmail.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Maria', 'Gheorghe', '0232555666', 'Bd. Stefan cel Mare 15', 'Iasi', 'maria@hotmail.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Cristi', 'Munteanu', '0211555666', 'Str. Lipscani 10', 'Bucuresti', 'cristi@yahoo.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Ana', 'Badea', '0264555666', 'Str. Memorandumului 5', 'Cluj', 'ana@gmail.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Vlad', 'Diaconu', '0232777888', 'Str. Pacurari 20', 'Iasi', 'vlad@yahoo.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Florin', 'Ciobanu', '0256777888', 'Piața Victoriei 3', 'Timisoara', 'florin@gmail.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Laura', 'Marin', '0232999000', 'Str. Independentei 12', 'Iasi', 'laura@hotmail.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'George', 'Ilie', '0211999000', 'Bd. Unirii 30', 'Bucuresti', 'george@yahoo.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Diana', 'Avram', '0264999000', 'Bd. Eroilor 11', 'Cluj', 'diana@gmail.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Stefan', 'Dima', '0232222333', 'Str. Copou 40', 'Iasi', 'stefan@yahoo.com');
INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email) VALUES (seq_clients.NEXTVAL, 'Roxana', 'Stoica', '0256222333', 'Str. Alba Iulia 7', 'Timisoara', 'roxana@gmail.com');

-- 7. VIEWINGS (50+) - Ensure version_id matches film_id
BEGIN
  FOR c_id IN 1..15 LOOP
    FOR f_id IN 1..5 LOOP
      -- Insert 5 viewings per client
      INSERT INTO VIEWINGS (id, client_id, film_id, version_id, viewed_at, duration_minutes, status)
      VALUES (
        seq_viewings.NEXTVAL, 
        c_id, 
        f_id + MOD(c_id, 10), -- vary the films slightly
        (SELECT id FROM FILM_VERSIONS WHERE film_id = (f_id + MOD(c_id, 10)) AND ROWNUM = 1),
        SYSDATE - MOD(c_id * f_id, 60), 
        120, 
        'completed'
      );
    END LOOP;
  END LOOP;
END;
/

-- 8. VOTES (15)
-- We will insert exactly 1 vote per client to ensure no unique constraint violation
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 1, 1, 10, 'Un film excelent, recomandat tuturor!', SYSDATE - 10);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 2, 2, 9, 'Superb, captivant si foarte interesant.', SYSDATE - 9);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 3, 3, 10, 'Perfect, genial! Actor principal apreciat maxim.', SYSDATE - 8);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 4, 4, 8, 'Frumos, dar putin lung.', SYSDATE - 7);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 5, 5, 9, 'Minunat, extraordinar scenariu.', SYSDATE - 6);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 6, 6, 7, 'Destul de banal, dar interesant pe alocuri.', SYSDATE - 5);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 7, 7, 10, 'Fantastic, efecte incredibile!', SYSDATE - 4);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 8, 8, 10, 'Cel mai bun film, extraordinar.', SYSDATE - 3);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 9, 9, 8, 'Emotionant si placut.', SYSDATE - 2);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 10, 10, 3, 'Dezamagitor, un scenariu slab si plictisitor.', SYSDATE - 1);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 11, 11, 10, 'O capodopera, trist si emotionant.', SYSDATE);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 12, 12, 9, 'Animatie superba, magic.', SYSDATE - 15);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 13, 13, 2, 'Groaznic, o pierdere de timp si oribil.', SYSDATE - 20);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 14, 14, 8, 'Un clasic frumos, dar putin sirop.', SYSDATE - 25);
INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, 15, 15, 9, 'Actiune buna, excelent.', SYSDATE - 30);

-- 9. CLIENT_TAG_SELECTIONS (30+)
BEGIN
  FOR v_id IN 1..15 LOOP
    -- Randomly assign 2 tags to each vote
    INSERT INTO CLIENT_TAG_SELECTIONS (id, vote_id, tag_id) VALUES (seq_client_tag_selections.NEXTVAL, v_id, MOD(v_id, 10) + 1);
    INSERT INTO CLIENT_TAG_SELECTIONS (id, vote_id, tag_id) VALUES (seq_client_tag_selections.NEXTVAL, v_id, MOD(v_id + 3, 10) + 1);
  END LOOP;
END;
/
