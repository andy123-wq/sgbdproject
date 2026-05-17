package com.filmplatform.controller;

import com.filmplatform.dao.ClientsDAO;
import com.filmplatform.dao.ViewingsDAO;
import com.filmplatform.model.Client;
import com.filmplatform.model.ClientCluster;
import com.filmplatform.model.ClientProfile;
import com.filmplatform.model.Film;
import com.filmplatform.model.SentimentResult;
import com.filmplatform.model.Viewing;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/clients")
@CrossOrigin("http://localhost:4200")
public class ClientController {

    private final ClientsDAO clientsDAO;
    private final ViewingsDAO viewingsDAO;

    public ClientController(ClientsDAO clientsDAO, ViewingsDAO viewingsDAO) {
        this.clientsDAO = clientsDAO;
        this.viewingsDAO = viewingsDAO;
    }

    @GetMapping
    public List<Client> getAllClients() {
        return clientsDAO.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Client> getClientById(@PathVariable Long id) {
        var c = clientsDAO.findById(id);
        return c != null ? ResponseEntity.ok(c) : ResponseEntity.notFound().build();
    }

    @GetMapping("/{id}/profile")
    public ClientProfile getProfile(@PathVariable Long id) {
        return clientsDAO.getProfile(id);
    }

    @GetMapping("/{id}/sentiment")
    public SentimentResult getSentiment(@PathVariable Long id, @RequestParam(required = false) Long filmId) {
        return clientsDAO.getSentiment(id, filmId);
    }

    @GetMapping("/{id}/recommendations")
    public List<Film> getRecommendations(@PathVariable Long id) {
        return clientsDAO.getRecommendations(id);
    }

    @GetMapping("/{id}/viewings")
    public List<Viewing> getViewings(@PathVariable Long id) {
        return viewingsDAO.findByClientId(id);
    }

    @GetMapping("/clusters")
    public List<ClientCluster> getClusters() {
        return clientsDAO.getClusters();
    }

    @PostMapping
    public ResponseEntity<Client> createClient(@RequestBody Client client) {
        return ResponseEntity.status(HttpStatus.CREATED).body(clientsDAO.insert(client));
    }

    @PutMapping("/{id}")
    public Client updateClient(@PathVariable Long id, @RequestBody Client client) {
        return clientsDAO.update(id, client);
    }
}
