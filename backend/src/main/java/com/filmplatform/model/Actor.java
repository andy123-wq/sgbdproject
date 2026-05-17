package com.filmplatform.model;

import java.time.LocalDate;

public class Actor {
    private Long id;
    private String stageName;
    private String firstName;
    private String lastName;
    private LocalDate birthDate;
    private String performanceComment;

    public Actor() {
    }

    public Actor(Long id, String stageName, String firstName, String lastName, LocalDate birthDate) {
        this.id = id;
        this.stageName = stageName;
        this.firstName = firstName;
        this.lastName = lastName;
        this.birthDate = birthDate;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getStageName() {
        return stageName;
    }

    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public String getPerformanceComment() {
        return performanceComment;
    }

    public void setPerformanceComment(String performanceComment) {
        this.performanceComment = performanceComment;
    }
}
