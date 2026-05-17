package com.filmplatform.model;

import java.time.LocalDate;

public class Viewing {
    private Long id;
    private Long clientId;
    private Long filmId;
    private Long versionId;
    private LocalDate viewedAt;
    private Integer durationMinutes;
    private String status;
    private String filmTitle; // DTO field for viewings list

    public Viewing() {}

    public Viewing(Long id, Long clientId, Long filmId, Long versionId, LocalDate viewedAt, Integer durationMinutes, String status) {
        this.id = id;
        this.clientId = clientId;
        this.filmId = filmId;
        this.versionId = versionId;
        this.viewedAt = viewedAt;
        this.durationMinutes = durationMinutes;
        this.status = status;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public Long getFilmId() { return filmId; }
    public void setFilmId(Long filmId) { this.filmId = filmId; }
    public Long getVersionId() { return versionId; }
    public void setVersionId(Long versionId) { this.versionId = versionId; }
    public LocalDate getViewedAt() { return viewedAt; }
    public void setViewedAt(LocalDate viewedAt) { this.viewedAt = viewedAt; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getFilmTitle() { return filmTitle; }
    public void setFilmTitle(String filmTitle) { this.filmTitle = filmTitle; }
}
