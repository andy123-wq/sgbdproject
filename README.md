# CineTrack

Acest proiect reprezintă o platformă de gestiune a vizionărilor și voturilor pentru filme, creată cu o arhitectură strictă:
- **Database:** Oracle XE 21c (PL/SQL proceduri, triggere)
- **Backend:** Spring Boot 3 (Raw JDBC, Fără ORM)
- **Frontend:** Angular 18 (Standalone, Fără librării CSS)

### Structură
- `/db`: Scripturile SQL de generare a schemei și populare automată a datelor (minim 15 rânduri pe tabelă, 9 tabele).
- `/backend`: API-ul Java ce interacționează cu DB-ul prin `DataSource` și `CallableStatement`.
- `/frontend`: Aplicația web client.

## Cerințe sistem
- Oracle Database XE 21c (sau compatibil, ascultând pe localhost:1521, user: SYSTEM / pass: oracle)
- Java JDK 17
- Node.js 18+ și Angular CLI 18
- Maven 3.8+

## Instalare și Rulare

### 1. Baza de Date
1. Conectați-vă la Oracle Database.
2. Executați fișierul `db/schema.sql` complet.
3. Executați fișierul `db/populate.sql` complet.

### 2. Backend (Spring Boot)
1. Navigați în folderul backend: `cd backend`
2. Compilați proiectul: `mvn clean compile`
3. Porniți serverul: `mvn spring-boot:run`
*Serverul va porni pe `http://localhost:8080`*

### 3. Frontend (Angular)
Dacă proiectul nu a fost generat complet prin CLI (fișierele de configurare ng/node), rulați următoarele comenzi în root-ul folderului:
1. `npx -y @angular/cli@18 new frontend --directory ./frontend --style css --routing true --standalone true --skip-git true`
2. Suprascrieți fișierele generate cu cele aflate deja în `frontend/src/` (celelalte comenzi au făcut asta).
3. `cd frontend`
4. `npm install`
5. `ng build` (pentru a asigura că sunt 0 erori)
6. `ng serve` (Aplicația va porni pe `http://localhost:4200`)/// & "C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.2\plugins\maven\lib\maven3\bin\mvn.cmd" spring-boot:run

## Contribuții
Proiect realizat conform specificațiilor stricte academice pentru cursul de Baze de Date.
