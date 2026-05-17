package com.filmplatform.model;

public class SeasonalPrediction {
    private Long filmId;
    private String title;
    private String category;
    private Double rating;
    private Long viewCount;

    public SeasonalPrediction() {}

    public SeasonalPrediction(Long filmId, String title, String category, Double rating, Long viewCount) {
        this.filmId = filmId;
        this.title = title;
        this.category = category;
        this.rating = rating;
        this.viewCount = viewCount;
    }

    public Long getFilmId() { return filmId; }
    public void setFilmId(Long filmId) { this.filmId = filmId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
    public Long getViewCount() { return viewCount; }
    public void setViewCount(Long viewCount) { this.viewCount = viewCount; }
}
