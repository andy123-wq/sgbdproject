package com.filmplatform.model;

public class SentimentResult {
    private String sentiment;
    private Integer score;

    public SentimentResult() {}

    public SentimentResult(String sentiment, Integer score) {
        this.sentiment = sentiment;
        this.score = score;
    }

    public String getSentiment() { return sentiment; }
    public void setSentiment(String sentiment) { this.sentiment = sentiment; }
    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }
}
