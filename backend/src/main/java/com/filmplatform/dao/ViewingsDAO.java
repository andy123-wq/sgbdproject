package com.filmplatform.dao;

import com.filmplatform.exception.InvalidVersionException;
import com.filmplatform.model.Viewing;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
//import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Component
public class ViewingsDAO {
    private final DataSource ds;

    public ViewingsDAO(DataSource ds) {
        this.ds = ds;
    }

    public List<Viewing> findByClientId(Long clientId) {
        var list = new ArrayList<Viewing>();
        try (var c = ds.getConnection();
             var ps = c.prepareStatement("SELECT v.*, f.title as film_title FROM VIEWINGS v JOIN FILMS f ON v.film_id = f.id WHERE v.client_id = ? ORDER BY v.viewed_at DESC")) {
            ps.setLong(1, clientId);
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    var v = new Viewing();
                    v.setId(rs.getLong("id"));
                    v.setClientId(rs.getLong("client_id"));
                    v.setFilmId(rs.getLong("film_id"));
                    v.setVersionId(rs.getLong("version_id"));
                    var d = rs.getDate("viewed_at");
                    if (d != null) v.setViewedAt(d.toLocalDate());
                    v.setDurationMinutes(rs.getInt("duration_minutes"));
                    v.setStatus(rs.getString("status"));
                    v.setFilmTitle(rs.getString("film_title"));
                    list.add(v);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public void insert(Viewing v) {
        try (var c = ds.getConnection();
             var ps = c.prepareStatement("INSERT INTO VIEWINGS (id, client_id, film_id, version_id, viewed_at, duration_minutes, status) VALUES (seq_viewings.NEXTVAL, ?, ?, ?, SYSDATE, ?, ?)")) {
            ps.setLong(1, v.getClientId());
            ps.setLong(2, v.getFilmId());
            ps.setLong(3, v.getVersionId());
            ps.setObject(4, v.getDurationMinutes());
            ps.setString(5, v.getStatus() != null ? v.getStatus() : "started");
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == 20002) {
                throw new InvalidVersionException();
            }
            throw new RuntimeException(e);
        }
    }
}
