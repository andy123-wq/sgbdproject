package com.filmplatform.dao;

import com.filmplatform.model.*;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Component
public class ClientsDAO {
    private final DataSource ds;

    public ClientsDAO(DataSource ds) {
        this.ds = ds;
    }

    public List<Client> findAll() {
        var list = new ArrayList<Client>();
        try (var c = ds.getConnection();
                var ps = c.prepareStatement("SELECT * FROM CLIENTS ORDER BY id ASC");
                var rs = ps.executeQuery()) {
            while (rs.next())
                list.add(mapClient(rs));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Client findById(Long id) {
        try (var c = ds.getConnection();
                var ps = c.prepareStatement("SELECT * FROM CLIENTS WHERE id = ?")) {
            ps.setLong(1, id);
            try (var rs = ps.executeQuery()) {
                if (rs.next())
                    return mapClient(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public Client insert(Client cl) {
        try (var c = ds.getConnection();
                var ps = c.prepareStatement(
                        "INSERT INTO CLIENTS (id, first_name, last_name, phone_home, address, city, email, phone_mobile) VALUES (seq_clients.NEXTVAL, ?, ?, ?, ?, ?, ?, ?)",
                        new String[] { "id" })) {
            ps.setString(1, cl.getFirstName());
            ps.setString(2, cl.getLastName());
            ps.setString(3, cl.getPhoneHome());
            ps.setString(4, cl.getAddress());
            ps.setString(5, cl.getCity());
            ps.setString(6, cl.getEmail());
            ps.setString(7, cl.getPhoneMobile());
            ps.executeUpdate();
            try (var rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    cl.setId(rs.getLong(1));
            }
            return cl;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Client update(Long id, Client cl) {
        try (var c = ds.getConnection();
                var ps = c.prepareStatement(
                        "UPDATE CLIENTS SET first_name=?, last_name=?, phone_home=?, address=?, city=?, email=?, phone_mobile=? WHERE id=?")) {
            ps.setString(1, cl.getFirstName());
            ps.setString(2, cl.getLastName());
            ps.setString(3, cl.getPhoneHome());
            ps.setString(4, cl.getAddress());
            ps.setString(5, cl.getCity());
            ps.setString(6, cl.getEmail());
            ps.setString(7, cl.getPhoneMobile());
            ps.setLong(8, id);
            ps.executeUpdate();
            cl.setId(id);
            return cl;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ClientProfile getProfile(Long clientId) {
        var p = new ClientProfile();
        int count = 0;
        try (var c = ds.getConnection();
                var cs = c.prepareCall("{call proc_get_client_profile(?,?)}")) {
            cs.setLong(1, clientId);
            cs.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
            cs.execute();
            try (var rs = (ResultSet) cs.getObject(2)) {
                while (rs.next()) {
                    if (count == 0) {
                        p.setMostWatchedCategory(rs.getString("top_category"));
                        p.setAverageVoteScore(rs.getDouble("avg_score"));
                        p.setTopActor(rs.getString("top_actor"));
                        p.setTopTag(rs.getString("top_tag"));
                    }
                    count++;
                }
                p.setTotalViewings(count);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return p;
    }

    public SentimentResult getSentiment(Long clientId, Long filmId) {
        var s = new SentimentResult();
        try (var c = ds.getConnection();
                var cs = c.prepareCall("{call proc_analyze_sentiment(?,?,?,?)}")) {
            cs.setLong(1, clientId);
            if (filmId != null)
                cs.setLong(2, filmId);
            else
                cs.setNull(2, java.sql.Types.NUMERIC);

            cs.registerOutParameter(3, java.sql.Types.VARCHAR);
            cs.registerOutParameter(4, java.sql.Types.NUMERIC);
            cs.execute();

            s.setSentiment(cs.getString(3));
            s.setScore(cs.getInt(4));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return s;
    }

    public List<Film> getRecommendations(Long clientId) {
        var list = new ArrayList<Film>();
        try (var c = ds.getConnection();
                var cs = c.prepareCall("{call proc_recommend_films(?,?)}")) {
            cs.setLong(1, clientId);
            cs.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
            cs.execute();
            try (var rs = (ResultSet) cs.getObject(2)) {
                while (rs.next()) {
                    var f = new Film();
                    f.setId(rs.getLong("id"));
                    f.setTitle(rs.getString("title"));
                    f.setCategory(rs.getString("category"));
                    f.setRating(rs.getDouble("rating"));
                    f.setPosterUrl(FilmsDAO.resolvePosterUrl(f.getTitle()));
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<SeasonalPrediction> getSeasonalPredictions(int month) {
        var list = new ArrayList<SeasonalPrediction>();
        try (var c = ds.getConnection();
                var cs = c.prepareCall("{call proc_seasonal_predictions(?,?)}")) {
            cs.setInt(1, month);
            cs.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
            cs.execute();
            try (var rs = (ResultSet) cs.getObject(2)) {
                while (rs.next()) {
                    var s = new SeasonalPrediction();
                    s.setFilmId(rs.getLong("id"));
                    s.setTitle(rs.getString("title"));
                    s.setCategory(rs.getString("category"));
                    s.setRating(rs.getDouble("rating"));
                    s.setViewCount(rs.getLong("view_count"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<ClientCluster> getClusters() {
        var list = new ArrayList<ClientCluster>();
        try (var c = ds.getConnection();
                var cs = c.prepareCall("{call proc_cluster_clients(?)}")) {
            cs.registerOutParameter(1, oracle.jdbc.OracleTypes.CURSOR);
            cs.execute();
            try (var rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    var s = new ClientCluster();
                    s.setClientId(rs.getLong("client_id"));
                    s.setClientName(rs.getString("client_name"));
                    s.setDominantCategory(rs.getString("dominant_category"));
                    s.setClusterLabel(rs.getString("cluster_label"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    private Client mapClient(ResultSet rs) throws SQLException {
        var c = new Client();
        c.setId(rs.getLong("id"));
        c.setFirstName(rs.getString("first_name"));
        c.setLastName(rs.getString("last_name"));
        c.setPhoneHome(rs.getString("phone_home"));
        c.setAddress(rs.getString("address"));
        c.setCity(rs.getString("city"));
        c.setEmail(rs.getString("email"));
        c.setPhoneMobile(rs.getString("phone_mobile"));
        return c;
    }
}
