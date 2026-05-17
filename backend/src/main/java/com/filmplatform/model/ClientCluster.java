package com.filmplatform.model;

public class ClientCluster {
    private Long clientId;
    private String clientName;
    private String dominantCategory;
    private String clusterLabel;

    public ClientCluster() {}

    public ClientCluster(Long clientId, String clientName, String dominantCategory, String clusterLabel) {
        this.clientId = clientId;
        this.clientName = clientName;
        this.dominantCategory = dominantCategory;
        this.clusterLabel = clusterLabel;
    }

    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
    public String getDominantCategory() { return dominantCategory; }
    public void setDominantCategory(String dominantCategory) { this.dominantCategory = dominantCategory; }
    public String getClusterLabel() { return clusterLabel; }
    public void setClusterLabel(String clusterLabel) { this.clusterLabel = clusterLabel; }
}
