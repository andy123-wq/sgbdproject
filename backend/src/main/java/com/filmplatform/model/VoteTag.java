package com.filmplatform.model;

public class VoteTag {
    private Long id;
    private String tagName;

    public VoteTag() {}

    public VoteTag(Long id, String tagName) {
        this.id = id;
        this.tagName = tagName;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTagName() { return tagName; }
    public void setTagName(String tagName) { this.tagName = tagName; }
}
