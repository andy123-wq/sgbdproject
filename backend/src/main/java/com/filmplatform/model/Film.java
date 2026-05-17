package com.filmplatform.model;

import java.time.LocalDate;

public class Film {
    private Long id;
    private String title;
    private String description;
    private String category;
    private LocalDate releaseDate;
    private Double rating;
    private String posterUrl;

    public Film() {}

    public Film(Long id, String title, String description, String category, LocalDate releaseDate, Double rating) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.category = category;
        this.releaseDate = releaseDate;
        this.rating = rating;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public LocalDate getReleaseDate() { return releaseDate; }
    public void setReleaseDate(LocalDate releaseDate) { this.releaseDate = releaseDate; }
    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
    public String getPosterUrl() { return posterUrl; }
    public void setPosterUrl(String posterUrl) { this.posterUrl = posterUrl; }
}
