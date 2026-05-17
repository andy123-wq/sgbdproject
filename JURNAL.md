# CineTrack JURNAL DE DECIZII

## Arhitectură și Constrângeri
Acest document detaliază deciziile arhitecturale luate pentru proiectul CineTrack, respectând cu strictețe cerințele academice (fără ORM, implementare pură JDBC, utilizare intensivă PL/SQL).

### 1. Renunțarea la ORM (Hibernate / JPA)
S-a decis utilizarea exclusivă a `java.sql.Connection`, `PreparedStatement` și `CallableStatement`. 
**Motivație:** Cerința academică interzice maparea obiectual-relațională automată pentru a demonstra înțelegerea la nivel de bază a interacțiunii dintre Java și baza de date. Toate DAOs sunt create implementând manual mapările ResultSet -> POJO.

### 2. Secvențe (Sequences) în loc de Identity/Auto-Increment
S-au utilizat 9 secvențe explicite Oracle (`seq_films`, `seq_clients` etc.) și `DEFAULT seq_name.NEXTVAL` direct în schema.sql.
**Motivație:** Oracle recomandă utilizarea secvențelor pentru performanță și scalabilitate în mediul concurențial. De asemenea, oferă un control mai precis al generării PK-urilor înainte de inserturi dacă este necesar.

### 3. Logica de Business plasată în Triggere
S-au implementat 3 triggere (`trg_update_film_rating`, `trg_validate_viewing`, `trg_votes_duplicate`).
**Motivație:** 
- `trg_update_film_rating` garantează consistența datelor: indiferent cum se face un insert/update/delete pe VOTES (prin Java sau direct în SQL Plus), ratingul filmului va fi corect și mereu actualizat sincron.
- `trg_validate_viewing` adaugă o constrângere complexă care nu se poate exprima simplu prin FOREIGN KEY (validarea că `version_id` aparține de fapt filmului cu `film_id` selectat).
- `trg_votes_duplicate` lansează un cod explicit `-20001` ce este preluat exact de backendul Java pentru un mesaj custom de interfață grafică.

### 4. Prelucrări analitice via Proceduri Stocate (PL/SQL)
Au fost create 5 proceduri (`proc_get_client_profile`, `proc_analyze_sentiment`, `proc_recommend_films`, `proc_seasonal_predictions`, `proc_cluster_clients`).
**Motivație:** Minimizarea transferului de date masive pe rețea către serverul de aplicație (Backend). Operatori SQL complecși (functii agregat, JOIN-uri multiple, window functions) rulează nativ în baza de date Oracle optimizat, returnând aplicației direct rezultatul rafinat prin `SYS_REFCURSOR`.

### 5. Exceptii Custom Java Interconectate cu PL/SQL
**Motivație:** Arhitectură curată de Error Handling. Prin maparea erorii de PL/SQL `20001` pe `DuplicateVoteException` se realizează legătura între logica DB (Trigger) și logica de rețea (Controller - HTTP 409 Conflict) fără string matching periculos pe mesaje de eroare.

### 6. Arhitectură Frontend Modernă (Angular 18)
S-a utilizat noua sintaxă de control flow (`@if`, `@for`) și componente de tip `standalone: true`.
**Motivație:** Reduce mărimea bundle-ului, curăță importurile, oferă performanță sporită la compilare. Stilurile au fost unificate prin variabile de sistem într-un singur fișier (`styles.css`) pentru a respecta constrângerile proiectului (fără framework-uri CSS).

### 7. Rezolvarea Problemelor de Compatibilitate Oracle 11g
**MotivaE>ie:** Baza de date din sistemul de dezvoltare s-a dovedit a fi Oracle 11g XE, nu versiunea 21c așa cum se speculase inițial. S-a realizat o adaptare arhitecturală completă:
- A fost creat un nou script schema_11g.sql unde s-au eliminat construcțiile de tip FETCH FIRST X ROWS ONLY (inexistente în 11g) cu subquery-uri ce folosesc ROWNUM <= X.
- Eroarea de tip \"Mutating Table\" din triggerul de voturi (	rg_update_film_rating) a fost corectată eficient utilizând un **COMPOUND TRIGGER** cu stări AFTER EACH ROW și AFTER STATEMENT, specific avansat Oracle 11g.
- Sistemul de autoincrementare (DEFAULT seq.NEXTVAL din Oracle 12c+) a fost retrasat manual prin blocuri de triggere de intercepție la nivel de linie (BEFORE INSERT).

### 8. Revizuirea InterfeE>ei Grafice (Design System Premium)
**MotivaE>ie:** S-a trecut de la un layout CRUD rudimentar la o estetică de tip \"Streaming Platform Dark Mode\" (inspirată de Linear/Netflix).
- S-a unificat totul prin variabile CSS globale (--bg, --surface, --accent, --glow-shadow).
- S-au înlocuit iconițele placeholder cu stilizări 3D (hover glow, 	ranslateY), iar bara de căutare a fost programată complet folosind Angular Signals (computed si signal) integrând direct inputurile user-ului în mecanismul de filtrare.
- Întreaga navigare din Navbar și din listele de clienți funcționează fluid.

### 9. Implementare Recenzii Prestație Actori

**Decizie arhitecturală:**
Pentru a respecta cerința de business care solicită „înregistrarea în baza de date a unor comentarii referitoare la rolul interpretat de actor într-un anumit film”, am extins aplicația pentru a permite salvarea acestor recenzii specifice direct în tabela de asociere (M:N) `FILM_ACTORS`, folosind coloana `performance_comment`. Această decizie respectă gradul de normalizare al bazei de date, legând comentariul strict de perechea unică (film, actor).

**Detalii tehnice privind implementarea:**
1. **Stratul de Acces la Date (DAO):** Am implementat metoda `updateActorComment` în `FilmsDAO`, utilizând JDBC pur (`PreparedStatement`). Interogarea folosită este un `UPDATE FILM_ACTORS SET performance_comment = ? WHERE film_id = ? AND actor_id = ?`. Această abordare garantează siguranța împotriva atacurilor de tip SQL Injection și evită supraîncărcarea memoriei, nemafiind necesar un apel ORM greoi.

2. **Stratul de Control (REST API):** Am expus operațiunea prin endpoint-ul `PUT /api/films/{filmId}/actors/{actorId}/comment`. Pentru a optimiza transferul de date și a evita crearea unor clase DTO (Data Transfer Object) nenecesare pentru un singur câmp text, payload-ul cererii HTTP este capturat eficient folosind structura dinamică `java.util.Map<String, String>`.

3. **Interfața Grafică (Angular 18):**
   - Am adăugat funcționalitate interactivă elementelor grafice care reprezintă distribuția (actor *chips*).
   - Am conceput un component de tip modal în `film-detail.component.ts` pentru capturarea input-ului de la client.
   - Cererea către server se face asincron, folosind `HttpClient` și `Observable`-uri din RxJS.
   - Feedback-ul vizual pentru succesul sau eșecul operațiunii este gestionat de un serviciu global custom (`ToastService`).
   **Actualizare ulterioară: Sincronizarea Modelului pentru Afișarea Recenziilor**
* **Problema identificată:** Deși salvarea datelor în backend funcționa (înregistrarea comentariilor actorilor în `FILM_ACTORS`), interfața clientului nu reflecta aceste schimbări, deoarece modelul de date transferat nu includea și acest nou câmp.
* **Soluția implementată:** Am modificat arhitectura aplicației pe verticală (End-to-End). 
  1. În backend, am extins modelul `Actor` cu atributul `performanceComment`.
  2. Am rescris metoda `findActorsByFilmId` din `FilmsDAO` pentru a executa un `JOIN` care extrage `performance_comment` direct din tabela de legătură.
  3. În frontend, am actualizat interfața TypeScript și am adăugat o secțiune dinamică în template-ul HTML folosind noua sintaxă de control flow din Angular 18 (`@if`). 
Astfel, se demonstrează trasabilitatea completă a datelor din baza de date Oracle direct în DOM-ul aplicației.