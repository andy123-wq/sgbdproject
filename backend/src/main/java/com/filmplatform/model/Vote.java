package com.filmplatform.model;

import java.time.LocalDate;

public class Vote {
    private Long id;
    private Long clientId;
    private Long filmId;
    private Integer score;
    private String commentText;
    private LocalDate votedAt;

    public Vote() {}

    public Vote(Long id, Long clientId, Long filmId, Integer score, String commentText, LocalDate votedAt) {
        this.id = id;
        this.clientId = clientId;
        this.filmId = filmId;
        this.score = score;
        this.commentText = commentText;
        this.votedAt = votedAt;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public Long getFilmId() { return filmId; }
    public void setFilmId(Long filmId) { this.filmId = filmId; }
    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }
    public String getCommentText() { return commentText; }
    public void setCommentText(String commentText) { this.commentText = commentText; }
    public LocalDate getVotedAt() { return votedAt; }
    public void setVotedAt(LocalDate votedAt) { this.votedAt = votedAt; }
}
