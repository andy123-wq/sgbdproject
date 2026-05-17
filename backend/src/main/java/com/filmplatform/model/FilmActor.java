package com.filmplatform.model;

public class FilmActor {
    private Long id;
    private Long filmId;
    private Long actorId;
    private String roleDescription;
    private String performanceComment;

    public FilmActor() {}

    public FilmActor(Long id, Long filmId, Long actorId, String roleDescription, String performanceComment) {
        this.id = id;
        this.filmId = filmId;
        this.actorId = actorId;
        this.roleDescription = roleDescription;
        this.performanceComment = performanceComment;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getFilmId() { return filmId; }
    public void setFilmId(Long filmId) { this.filmId = filmId; }
    public Long getActorId() { return actorId; }
    public void setActorId(Long actorId) { this.actorId = actorId; }
    public String getRoleDescription() { return roleDescription; }
    public void setRoleDescription(String roleDescription) { this.roleDescription = roleDescription; }
    public String getPerformanceComment() { return performanceComment; }
    public void setPerformanceComment(String performanceComment) { this.performanceComment = performanceComment; }
}
