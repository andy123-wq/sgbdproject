-- SECTION A — DROP ALL
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CLIENT_TAG_SELECTIONS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE VOTES CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE VIEWINGS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FILM_ACTORS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FILM_VERSIONS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CLIENTS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ACTORS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FILMS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE VOTE_TAGS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- SECTION B — DROP SEQUENCES
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_films'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_film_versions'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_actors'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_film_actors'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_clients'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_viewings'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_votes'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_vote_tags'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_client_tag_selections'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- SECTION C — CREATE SEQUENCES
CREATE SEQUENCE seq_films START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_film_versions START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_actors START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_film_actors START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_clients START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_viewings START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_votes START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_vote_tags START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_client_tag_selections START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- SECTION D — CREATE TABLES

CREATE TABLE FILMS (
  id           NUMBER DEFAULT seq_films.NEXTVAL,
  title        VARCHAR2(255) NOT NULL,
  description  CLOB,
  category     VARCHAR2(100) NOT NULL,
  release_date DATE,
  rating       NUMBER(3,1) DEFAULT 0,
  CONSTRAINT pk_films PRIMARY KEY (id),
  CONSTRAINT chk_films_rating CHECK (rating BETWEEN 0 AND 10)
);

CREATE TABLE FILM_VERSIONS (
  id           NUMBER DEFAULT seq_film_versions.NEXTVAL,
  film_id      NUMBER NOT NULL,
  format       VARCHAR2(50)  NOT NULL,
  resolution   VARCHAR2(20),
  language     VARCHAR2(50)  NOT NULL,
  is_available NUMBER(1) DEFAULT 1,
  CONSTRAINT pk_film_versions PRIMARY KEY (id),
  CONSTRAINT fk_fv_film FOREIGN KEY (film_id) REFERENCES FILMS(id) ON DELETE CASCADE,
  CONSTRAINT chk_fv_available CHECK (is_available IN (0,1)),
  CONSTRAINT uq_film_version UNIQUE (film_id, format, language)
);

CREATE TABLE ACTORS (
  id         NUMBER DEFAULT seq_actors.NEXTVAL,
  stage_name VARCHAR2(100) NOT NULL,
  first_name VARCHAR2(100) NOT NULL,
  last_name  VARCHAR2(100) NOT NULL,
  birth_date DATE,
  CONSTRAINT pk_actors PRIMARY KEY (id),
  CONSTRAINT uq_actor_stage UNIQUE (stage_name)
);

CREATE TABLE FILM_ACTORS (
  id                  NUMBER DEFAULT seq_film_actors.NEXTVAL,
  film_id             NUMBER NOT NULL,
  actor_id            NUMBER NOT NULL,
  role_description    VARCHAR2(500),
  performance_comment VARCHAR2(1000),
  CONSTRAINT pk_film_actors PRIMARY KEY (id),
  CONSTRAINT fk_fa_film  FOREIGN KEY (film_id)  REFERENCES FILMS(id)  ON DELETE CASCADE,
  CONSTRAINT fk_fa_actor FOREIGN KEY (actor_id) REFERENCES ACTORS(id) ON DELETE CASCADE,
  CONSTRAINT uq_film_actor UNIQUE (film_id, actor_id)
);

CREATE TABLE CLIENTS (
  id           NUMBER DEFAULT seq_clients.NEXTVAL,
  first_name   VARCHAR2(100) NOT NULL,
  last_name    VARCHAR2(100) NOT NULL,
  phone_home   VARCHAR2(20)  NOT NULL,
  address      VARCHAR2(500),
  city         VARCHAR2(100) NOT NULL,
  email        VARCHAR2(255),
  phone_mobile VARCHAR2(20),
  CONSTRAINT pk_clients PRIMARY KEY (id),
  CONSTRAINT uq_client_email UNIQUE (email)
);

CREATE TABLE VIEWINGS (
  id               NUMBER DEFAULT seq_viewings.NEXTVAL,
  client_id        NUMBER NOT NULL,
  film_id          NUMBER NOT NULL,
  version_id       NUMBER NOT NULL,
  viewed_at        DATE DEFAULT SYSDATE NOT NULL,
  duration_minutes NUMBER(5),
  status           VARCHAR2(20) DEFAULT 'started',
  CONSTRAINT pk_viewings PRIMARY KEY (id),
  CONSTRAINT fk_vi_client  FOREIGN KEY (client_id)  REFERENCES CLIENTS(id)      ON DELETE CASCADE,
  CONSTRAINT fk_vi_film    FOREIGN KEY (film_id)    REFERENCES FILMS(id),
  CONSTRAINT fk_vi_version FOREIGN KEY (version_id) REFERENCES FILM_VERSIONS(id),
  CONSTRAINT chk_vi_status CHECK (status IN ('started','completed','paused'))
);

CREATE TABLE VOTES (
  id           NUMBER DEFAULT seq_votes.NEXTVAL,
  client_id    NUMBER NOT NULL,
  film_id      NUMBER NOT NULL,
  score        NUMBER(2) NOT NULL,
  comment_text CLOB,
  voted_at     DATE DEFAULT SYSDATE NOT NULL,
  CONSTRAINT pk_votes PRIMARY KEY (id),
  CONSTRAINT fk_vo_client FOREIGN KEY (client_id) REFERENCES CLIENTS(id) ON DELETE CASCADE,
  CONSTRAINT fk_vo_film   FOREIGN KEY (film_id)   REFERENCES FILMS(id),
  CONSTRAINT chk_vo_score CHECK (score BETWEEN 1 AND 10),
  CONSTRAINT uq_client_film_vote UNIQUE (client_id, film_id)
);

CREATE TABLE VOTE_TAGS (
  id       NUMBER DEFAULT seq_vote_tags.NEXTVAL,
  tag_name VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_vote_tags PRIMARY KEY (id),
  CONSTRAINT uq_tag_name UNIQUE (tag_name)
);

CREATE TABLE CLIENT_TAG_SELECTIONS (
  id      NUMBER DEFAULT seq_client_tag_selections.NEXTVAL,
  vote_id NUMBER NOT NULL,
  tag_id  NUMBER NOT NULL,
  CONSTRAINT pk_cts PRIMARY KEY (id),
  CONSTRAINT fk_cts_vote FOREIGN KEY (vote_id) REFERENCES VOTES(id)      ON DELETE CASCADE,
  CONSTRAINT fk_cts_tag  FOREIGN KEY (tag_id)  REFERENCES VOTE_TAGS(id),
  CONSTRAINT uq_vote_tag UNIQUE (vote_id, tag_id)
);

-- SECTION E — INDEXES
CREATE INDEX idx_fv_film     ON FILM_VERSIONS(film_id);
CREATE INDEX idx_fa_film     ON FILM_ACTORS(film_id);
CREATE INDEX idx_fa_actor    ON FILM_ACTORS(actor_id);
CREATE INDEX idx_vi_client   ON VIEWINGS(client_id);
CREATE INDEX idx_vi_film     ON VIEWINGS(film_id);
CREATE INDEX idx_vi_version  ON VIEWINGS(version_id);
CREATE INDEX idx_vo_client   ON VOTES(client_id);
CREATE INDEX idx_vo_film     ON VOTES(film_id);
CREATE INDEX idx_cts_vote    ON CLIENT_TAG_SELECTIONS(vote_id);
CREATE INDEX idx_cts_tag     ON CLIENT_TAG_SELECTIONS(tag_id);

-- SECTION F — TRIGGERS

CREATE OR REPLACE TRIGGER trg_update_film_rating
AFTER INSERT OR UPDATE OR DELETE ON VOTES FOR EACH ROW
DECLARE v_film_id NUMBER;
BEGIN
  v_film_id := CASE WHEN DELETING THEN :OLD.film_id ELSE :NEW.film_id END;
  UPDATE FILMS SET rating=(SELECT NVL(ROUND(AVG(score),1),0) FROM VOTES WHERE film_id=v_film_id)
  WHERE id=v_film_id;
END trg_update_film_rating;
/

CREATE OR REPLACE TRIGGER trg_validate_viewing
BEFORE INSERT ON VIEWINGS FOR EACH ROW
DECLARE v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM FILM_VERSIONS WHERE id=:NEW.version_id AND film_id=:NEW.film_id;
  IF v_cnt=0 THEN RAISE_APPLICATION_ERROR(-20002,'Versiunea nu apartine acestui film'); END IF;
END trg_validate_viewing;
/

CREATE OR REPLACE TRIGGER trg_votes_duplicate
BEFORE INSERT ON VOTES FOR EACH ROW
DECLARE v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM VOTES WHERE client_id=:NEW.client_id AND film_id=:NEW.film_id;
  IF v_cnt>0 THEN RAISE_APPLICATION_ERROR(-20001,'Clientul a votat deja acest film'); END IF;
END trg_votes_duplicate;
/

-- SECTION G — PROCEDURES

CREATE OR REPLACE PROCEDURE proc_get_client_profile(
  p_client_id IN NUMBER, p_cursor OUT SYS_REFCURSOR
) AS BEGIN
  OPEN p_cursor FOR
    SELECT f.id AS film_id, f.title, f.category,
      TO_CHAR(v.viewed_at,'YYYY-MM-DD') AS viewed_at,
      v.status, v.duration_minutes,
      NVL(vo.score,0) AS vote_score,
      (SELECT fi2.category FROM VIEWINGS vi2 JOIN FILMS fi2 ON vi2.film_id=fi2.id
       WHERE vi2.client_id=p_client_id GROUP BY fi2.category
       ORDER BY COUNT(*) DESC FETCH FIRST 1 ROWS ONLY) AS top_category,
      (SELECT NVL(ROUND(AVG(score),1),0) FROM VOTES WHERE client_id=p_client_id) AS avg_score,
      (SELECT a.stage_name FROM FILM_ACTORS fa JOIN ACTORS a ON fa.actor_id=a.id
       JOIN VIEWINGS vi3 ON vi3.film_id=fa.film_id WHERE vi3.client_id=p_client_id
       GROUP BY a.stage_name ORDER BY COUNT(*) DESC FETCH FIRST 1 ROWS ONLY) AS top_actor,
      (SELECT vt.tag_name FROM CLIENT_TAG_SELECTIONS cts
       JOIN VOTE_TAGS vt ON cts.tag_id=vt.id JOIN VOTES vo2 ON cts.vote_id=vo2.id
       WHERE vo2.client_id=p_client_id GROUP BY vt.tag_name
       ORDER BY COUNT(*) DESC FETCH FIRST 1 ROWS ONLY) AS top_tag
    FROM VIEWINGS v JOIN FILMS f ON v.film_id=f.id
    LEFT JOIN VOTES vo ON vo.film_id=f.id AND vo.client_id=p_client_id
    WHERE v.client_id=p_client_id ORDER BY v.viewed_at DESC;
END proc_get_client_profile;
/

CREATE OR REPLACE PROCEDURE proc_analyze_sentiment(
  p_client_id IN NUMBER, p_film_id IN NUMBER DEFAULT NULL,
  p_sentiment OUT VARCHAR2, p_score OUT NUMBER
) AS
  v_pos NUMBER:=0; v_neg NUMBER:=0; v_tags NUMBER:=0; v_txt VARCHAR2(32767);
BEGIN
  FOR rec IN (SELECT NVL(UPPER(TO_CHAR(comment_text)),'') AS txt FROM VOTES
    WHERE client_id=p_client_id AND (p_film_id IS NULL OR film_id=p_film_id)) LOOP
    v_txt:=rec.txt;
    IF INSTR(v_txt,'EXCELENT')>0 OR INSTR(v_txt,'SUPERB')>0 OR
       INSTR(v_txt,'MINUNAT')>0 OR INSTR(v_txt,'FANTASTIC')>0 OR
       INSTR(v_txt,'RECOMANDAT')>0 OR INSTR(v_txt,'EXTRAORDINAR')>0 OR
       INSTR(v_txt,'PERFECT')>0 OR INSTR(v_txt,'GENIAL')>0 OR
       INSTR(v_txt,'FRUMOS')>0 OR INSTR(v_txt,'CAPTIVANT')>0
    THEN v_pos:=v_pos+1; END IF;
    IF INSTR(v_txt,'SLAB')>0 OR INSTR(v_txt,'PLICTISITOR')>0 OR
       INSTR(v_txt,'DEZAMAGITOR')>0 OR INSTR(v_txt,'GROAZNIC')>0 OR
       INSTR(v_txt,'PROST')>0 OR INSTR(v_txt,'ORIBIL')>0 OR
       INSTR(v_txt,'BANAL')>0 OR INSTR(v_txt,'STUPID')>0
    THEN v_neg:=v_neg+1; END IF;
  END LOOP;
  SELECT NVL(SUM(CASE
    WHEN vt.tag_name IN ('mi-a placut','emotionant','interesant','as recomanda',
      'as mai viziona','actor principal apreciat','recomandat prietenilor') THEN 1
    WHEN vt.tag_name IN ('nu mi-a placut','plictisitor','scenariu slab') THEN -1
    ELSE 0 END),0) INTO v_tags
  FROM CLIENT_TAG_SELECTIONS cts JOIN VOTE_TAGS vt ON cts.tag_id=vt.id
  JOIN VOTES vo ON cts.vote_id=vo.id
  WHERE vo.client_id=p_client_id AND (p_film_id IS NULL OR vo.film_id=p_film_id);
  p_score:=v_pos-v_neg+v_tags;
  IF p_score>0 THEN p_sentiment:='POZITIV';
  ELSIF p_score<0 THEN p_sentiment:='NEGATIV';
  ELSE p_sentiment:='NEUTRU'; END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN p_score:=0; p_sentiment:='NEUTRU';
END proc_analyze_sentiment;
/

CREATE OR REPLACE PROCEDURE proc_recommend_films(
  p_client_id IN NUMBER, p_cursor OUT SYS_REFCURSOR
) AS BEGIN
  OPEN p_cursor FOR
    SELECT DISTINCT f.id, f.title, f.category, f.rating,
      (SELECT COUNT(*) FROM VIEWINGS WHERE film_id=f.id) AS total_views
    FROM FILMS f
    WHERE f.id NOT IN (SELECT DISTINCT film_id FROM VIEWINGS WHERE client_id=p_client_id)
    AND f.category IN (
      SELECT category FROM (
        SELECT fi.category FROM VIEWINGS vi JOIN FILMS fi ON vi.film_id=fi.id
        WHERE vi.client_id=p_client_id GROUP BY fi.category ORDER BY COUNT(*) DESC
      ) WHERE ROWNUM<=3
    )
    AND f.id IN (
      SELECT DISTINCT v2.film_id FROM VIEWINGS v2 WHERE v2.client_id IN (
        SELECT client_id FROM (
          SELECT vi2.client_id, COUNT(DISTINCT fi2.category) AS cc
          FROM VIEWINGS vi2 JOIN FILMS fi2 ON vi2.film_id=fi2.id
          WHERE fi2.category IN (
            SELECT category FROM (
              SELECT fi3.category FROM VIEWINGS vi3 JOIN FILMS fi3 ON vi3.film_id=fi3.id
              WHERE vi3.client_id=p_client_id GROUP BY fi3.category ORDER BY COUNT(*) DESC
            ) WHERE ROWNUM<=3
          ) AND vi2.client_id!=p_client_id GROUP BY vi2.client_id
        ) WHERE cc>=2
      )
    )
    ORDER BY f.rating DESC, total_views DESC FETCH FIRST 10 ROWS ONLY;
END proc_recommend_films;
/

CREATE OR REPLACE PROCEDURE proc_seasonal_predictions(
  p_month IN NUMBER, p_cursor OUT SYS_REFCURSOR
) AS BEGIN
  OPEN p_cursor FOR
    SELECT f.id, f.title, f.category, f.rating, COUNT(*) AS view_count
    FROM VIEWINGS v JOIN FILMS f ON v.film_id=f.id
    WHERE EXTRACT(MONTH FROM v.viewed_at)=p_month
    GROUP BY f.id, f.title, f.category, f.rating
    ORDER BY view_count DESC, f.rating DESC FETCH FIRST 10 ROWS ONLY;
END proc_seasonal_predictions;
/

CREATE OR REPLACE PROCEDURE proc_cluster_clients(
  p_cursor OUT SYS_REFCURSOR
) AS BEGIN
  OPEN p_cursor FOR
    SELECT c.id AS client_id, c.first_name||' '||c.last_name AS client_name,
      dom.dominant_category,
      CASE WHEN dom.dominant_category IN ('Action','Thriller','Horror') THEN 'ACTION_LOVER'
           WHEN dom.dominant_category IN ('Drama','Romance','Biography') THEN 'DRAMA_FAN'
           ELSE 'MIXED' END AS cluster_label
    FROM CLIENTS c JOIN (
      SELECT client_id, category AS dominant_category FROM (
        SELECT vi.client_id, fi.category,
          RANK() OVER(PARTITION BY vi.client_id ORDER BY COUNT(*) DESC) AS rnk
        FROM VIEWINGS vi JOIN FILMS fi ON vi.film_id=fi.id GROUP BY vi.client_id, fi.category
      ) WHERE rnk=1
    ) dom ON c.id=dom.client_id ORDER BY cluster_label, client_name;
END proc_cluster_clients;
/
