package com.filmplatform.dao;

import com.filmplatform.model.*;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@Component
public class FilmsDAO {
    private final DataSource ds;

    public FilmsDAO(DataSource ds) {
        this.ds = ds;
    }

    public List<Film> findAll() {
        var list = new ArrayList<Film>();
        try (var c = ds.getConnection();
                var ps = c.prepareStatement("SELECT * FROM FILMS ORDER BY rating DESC");
                var rs = ps.executeQuery()) {
            while (rs.next())
                list.add(mapFilm(rs));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Film findById(Long id) {
        try (var c = ds.getConnection();
                var ps = c.prepareStatement("SELECT * FROM FILMS WHERE id = ?")) {
            ps.setLong(1, id);
            try (var rs = ps.executeQuery()) {
                if (rs.next())
                    return mapFilm(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public List<Film> findByCategory(String category) {
        var list = new ArrayList<Film>();
        try (var c = ds.getConnection();
                var ps = c.prepareStatement("SELECT * FROM FILMS WHERE category = ? ORDER BY rating DESC")) {
            ps.setString(1, category);
            try (var rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapFilm(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Film insert(Film f) {
        try (var c = ds.getConnection();
                var ps = c.prepareStatement(
                        "INSERT INTO FILMS (id, title, description, category, release_date, rating) VALUES (seq_films.NEXTVAL, ?, ?, ?, ?, ?)",
                        new String[] { "id" })) {
            ps.setString(1, f.getTitle());
            ps.setString(2, f.getDescription());
            ps.setString(3, f.getCategory());
            ps.setDate(4, f.getReleaseDate() != null ? java.sql.Date.valueOf(f.getReleaseDate()) : null);
            ps.setDouble(5, f.getRating() != null ? f.getRating() : 0.0);
            ps.executeUpdate();
            try (var rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    f.setId(rs.getLong(1));
            }
            return f;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Film update(Long id, Film f) {
        try (var c = ds.getConnection();
                var ps = c.prepareStatement(
                        "UPDATE FILMS SET title=?, description=?, category=?, release_date=?, rating=? WHERE id=?")) {
            ps.setString(1, f.getTitle());
            ps.setString(2, f.getDescription());
            ps.setString(3, f.getCategory());
            ps.setDate(4, f.getReleaseDate() != null ? java.sql.Date.valueOf(f.getReleaseDate()) : null);
            ps.setDouble(5, f.getRating() != null ? f.getRating() : 0.0);
            ps.setLong(6, id);
            ps.executeUpdate();
            f.setId(id);
            return f;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(Long id) {
        try (var c = ds.getConnection();
                var ps = c.prepareStatement("DELETE FROM FILMS WHERE id=?")) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<FilmVersion> findVersionsByFilmId(Long filmId) {
        var list = new ArrayList<FilmVersion>();
        try (var c = ds.getConnection();
                var ps = c.prepareStatement("SELECT * FROM FILM_VERSIONS WHERE film_id = ?")) {
            ps.setLong(1, filmId);
            try (var rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapFilmVersion(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<Actor> findActorsByFilmId(Long filmId) {
        var list = new ArrayList<Actor>();
        try (var c = ds.getConnection();
                var ps = c.prepareStatement(
                        "SELECT a.*, fa.performance_comment FROM ACTORS a JOIN FILM_ACTORS fa ON a.id = fa.actor_id WHERE fa.film_id = ?")) {
            ps.setLong(1, filmId);
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    var a = mapActor(rs);
                    //// comentariul din tabela de leg
                    a.setPerformanceComment(rs.getString("performance_comment"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public void updateActorComment(Long filmId, Long actorId, String comment) {
        try (var c = ds.getConnection();
                var ps = c.prepareStatement(
                        "UPDATE FILM_ACTORS SET performance_comment = ? WHERE film_id = ? AND actor_id = ?")) {
            ps.setString(1, comment);
            ps.setLong(2, filmId);
            ps.setLong(3, actorId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static final Map<String, String> TMDB_POSTER_MAP = new HashMap<>();
    static {
        TMDB_POSTER_MAP.put("Inception", "https://image.tmdb.org/t/p/w500/xlaY2zyzMfkhk0HSC5VUwzoZPU1.jpg");
        TMDB_POSTER_MAP.put("Interstellar", "https://image.tmdb.org/t/p/w500/yQvGrMoipbRoddT0ZR8tPoR7NfX.jpg");
        TMDB_POSTER_MAP.put("The Dark Knight", "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg");
        TMDB_POSTER_MAP.put("Oppenheimer", "https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg");
        TMDB_POSTER_MAP.put("Parasite", "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg");
        TMDB_POSTER_MAP.put("La La Land", "https://image.tmdb.org/t/p/w500/uDO8zWDhfWwoFdKS4fzkUJt0Rf0.jpg");
        TMDB_POSTER_MAP.put("Avengers Endgame", "https://image.tmdb.org/t/p/w500/ulzhLuWrPK07P1YkdWQLZnQh1JL.jpg");
        TMDB_POSTER_MAP.put("Shawshank Redemption", "https://image.tmdb.org/t/p/w500/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg");
        TMDB_POSTER_MAP.put("Forrest Gump", "https://image.tmdb.org/t/p/w500/Cw4hIUIAmSYfK9QfaUW5igp9La.jpg");
        TMDB_POSTER_MAP.put("The Matrix", "https://image.tmdb.org/t/p/w500/aOIuZAjPaRIE6CMzbazvcHuHXDc.jpg");
        TMDB_POSTER_MAP.put("Schindler's List", "https://image.tmdb.org/t/p/w500/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg");
        TMDB_POSTER_MAP.put("Spirited Away", "https://image.tmdb.org/t/p/w500/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg");
        TMDB_POSTER_MAP.put("Joker", "https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg");
        TMDB_POSTER_MAP.put("Titanic", "https://image.tmdb.org/t/p/w500/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg");
        TMDB_POSTER_MAP.put("Gladiator", "https://image.tmdb.org/t/p/w500/wN2xWp1eIwCKOD0BHTcErTBv1Uq.jpg");
    }

    public static String resolvePosterUrl(String title) {
        return TMDB_POSTER_MAP.getOrDefault(title != null ? title : "", "");
    }

    private Film mapFilm(ResultSet rs) throws SQLException {
        var f = new Film();
        f.setId(rs.getLong("id"));
        f.setTitle(rs.getString("title"));
        f.setDescription(rs.getString("description"));
        f.setCategory(rs.getString("category"));
        f.setRating(rs.getDouble("rating"));
        var d = rs.getDate("release_date");
        if (d != null)
            f.setReleaseDate(d.toLocalDate());
        f.setPosterUrl(TMDB_POSTER_MAP.getOrDefault(f.getTitle(), ""));
        return f;
    }

    private FilmVersion mapFilmVersion(ResultSet rs) throws SQLException {
        var fv = new FilmVersion();
        fv.setId(rs.getLong("id"));
        fv.setFilmId(rs.getLong("film_id"));
        fv.setFormat(rs.getString("format"));
        fv.setResolution(rs.getString("resolution"));
        fv.setLanguage(rs.getString("language"));
        fv.setIsAvailable(rs.getInt("is_available") == 1);
        return fv;
    }

    private Actor mapActor(ResultSet rs) throws SQLException {
        var a = new Actor();
        a.setId(rs.getLong("id"));
        a.setStageName(rs.getString("stage_name"));
        a.setFirstName(rs.getString("first_name"));
        a.setLastName(rs.getString("last_name"));
        var d = rs.getDate("birth_date");
        if (d != null)
            a.setBirthDate(d.toLocalDate());
        return a;
    }
}
