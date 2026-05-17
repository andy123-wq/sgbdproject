package com.filmplatform.model;

public class ClientProfile {
    private String mostWatchedCategory;
    private Double averageVoteScore;
    private String topActor;
    private String topTag;
    private Integer totalViewings;

    public ClientProfile() {}

    public ClientProfile(String mostWatchedCategory, Double averageVoteScore, String topActor, String topTag, Integer totalViewings) {
        this.mostWatchedCategory = mostWatchedCategory;
        this.averageVoteScore = averageVoteScore;
        this.topActor = topActor;
        this.topTag = topTag;
        this.totalViewings = totalViewings;
    }

    public String getMostWatchedCategory() { return mostWatchedCategory; }
    public void setMostWatchedCategory(String mostWatchedCategory) { this.mostWatchedCategory = mostWatchedCategory; }
    public Double getAverageVoteScore() { return averageVoteScore; }
    public void setAverageVoteScore(Double averageVoteScore) { this.averageVoteScore = averageVoteScore; }
    public String getTopActor() { return topActor; }
    public void setTopActor(String topActor) { this.topActor = topActor; }
    public String getTopTag() { return topTag; }
    public void setTopTag(String topTag) { this.topTag = topTag; }
    public Integer getTotalViewings() { return totalViewings; }
    public void setTotalViewings(Integer totalViewings) { this.totalViewings = totalViewings; }
}
