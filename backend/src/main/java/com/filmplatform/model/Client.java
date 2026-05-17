package com.filmplatform.model;

public class Client {
    private Long id;
    private String firstName;
    private String lastName;
    private String phoneHome;
    private String address;
    private String city;
    private String email;
    private String phoneMobile;

    public Client() {}

    public Client(Long id, String firstName, String lastName, String phoneHome, String address, String city, String email, String phoneMobile) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phoneHome = phoneHome;
        this.address = address;
        this.city = city;
        this.email = email;
        this.phoneMobile = phoneMobile;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getPhoneHome() { return phoneHome; }
    public void setPhoneHome(String phoneHome) { this.phoneHome = phoneHome; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhoneMobile() { return phoneMobile; }
    public void setPhoneMobile(String phoneMobile) { this.phoneMobile = phoneMobile; }
}
