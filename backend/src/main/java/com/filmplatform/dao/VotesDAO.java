package com.filmplatform.dao;

import com.filmplatform.exception.DuplicateVoteException;
import com.filmplatform.model.Vote;
import com.filmplatform.model.VoteTag;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Component
public class VotesDAO {
    private final DataSource ds;

    public VotesDAO(DataSource ds) {
        this.ds = ds;
    }

    public List<Vote> findByFilmId(Long filmId) {
        var list = new ArrayList<Vote>();
        try (var c = ds.getConnection();
             var ps = c.prepareStatement("SELECT * FROM VOTES WHERE film_id = ? ORDER BY voted_at DESC")) {
            ps.setLong(1, filmId);
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    var v = new Vote();
                    v.setId(rs.getLong("id"));
                    v.setClientId(rs.getLong("client_id"));
                    v.setFilmId(rs.getLong("film_id"));
                    v.setScore(rs.getInt("score"));
                    v.setCommentText(rs.getString("comment_text"));
                    var d = rs.getDate("voted_at");
                    if (d != null) v.setVotedAt(d.toLocalDate());
                    list.add(v);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<VoteTag> findAllTags() {
        var list = new ArrayList<VoteTag>();
        try (var c = ds.getConnection();
             var ps = c.prepareStatement("SELECT * FROM VOTE_TAGS ORDER BY id ASC");
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                var t = new VoteTag();
                t.setId(rs.getLong("id"));
                t.setTagName(rs.getString("tag_name"));
                list.add(t);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Vote insertVote(Vote v) {
        try (var c = ds.getConnection();
             var ps = c.prepareStatement("INSERT INTO VOTES (id, client_id, film_id, score, comment_text, voted_at) VALUES (seq_votes.NEXTVAL, ?, ?, ?, ?, SYSDATE)", new String[]{"id"})) {
            ps.setLong(1, v.getClientId());
            ps.setLong(2, v.getFilmId());
            ps.setInt(3, v.getScore());
            ps.setString(4, v.getCommentText());
            ps.executeUpdate();
            try (var rs = ps.getGeneratedKeys()) {
                if (rs.next()) v.setId(rs.getLong(1));
            }
            return v;
        } catch (SQLException e) {
            if (e.getErrorCode() == 20001) {
                throw new DuplicateVoteException();
            }
            throw new RuntimeException(e);
        }
    }

    public void insertTags(Long voteId, List<Long> tagIds) {
        if (tagIds == null || tagIds.isEmpty()) return;
        try (var c = ds.getConnection();
             var ps = c.prepareStatement("INSERT INTO CLIENT_TAG_SELECTIONS (id, vote_id, tag_id) VALUES (seq_client_tag_selections.NEXTVAL, ?, ?)")) {
            for (Long tid : tagIds) {
                ps.setLong(1, voteId);
                ps.setLong(2, tid);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
