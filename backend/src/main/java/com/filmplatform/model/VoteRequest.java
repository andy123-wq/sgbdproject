package com.filmplatform.model;

import java.util.List;

public class VoteRequest {
    private Vote vote;
    private List<Long> tagIds;

    public VoteRequest() {}

    public VoteRequest(Vote vote, List<Long> tagIds) {
        this.vote = vote;
        this.tagIds = tagIds;
    }

    public Vote getVote() { return vote; }
    public void setVote(Vote vote) { this.vote = vote; }
    public List<Long> getTagIds() { return tagIds; }
    public void setTagIds(List<Long> tagIds) { this.tagIds = tagIds; }
}
