package com.filmplatform.model;

public class FilmVersion {
    private Long id;
    private Long filmId;
    private String format;
    private String resolution;
    private String language;
    private Boolean isAvailable;

    public FilmVersion() {}

    public FilmVersion(Long id, Long filmId, String format, String resolution, String language, Boolean isAvailable) {
        this.id = id;
        this.filmId = filmId;
        this.format = format;
        this.resolution = resolution;
        this.language = language;
        this.isAvailable = isAvailable;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getFilmId() { return filmId; }
    public void setFilmId(Long filmId) { this.filmId = filmId; }
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
    public String getResolution() { return resolution; }
    public void setResolution(String resolution) { this.resolution = resolution; }
    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }
    public Boolean getIsAvailable() { return isAvailable; }
    public void setIsAvailable(Boolean isAvailable) { this.isAvailable = isAvailable; }
}
