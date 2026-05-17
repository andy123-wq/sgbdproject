package com.filmplatform.controller;

import com.filmplatform.dao.FilmsDAO;
import com.filmplatform.dao.VotesDAO;
import com.filmplatform.dao.ClientsDAO;
import com.filmplatform.model.Actor;
import com.filmplatform.model.Film;
import com.filmplatform.model.FilmVersion;
import com.filmplatform.model.SeasonalPrediction;
import com.filmplatform.model.Vote;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/films")
@CrossOrigin("http://localhost:4200")
public class FilmController {

    private final FilmsDAO filmsDAO;
    private final VotesDAO votesDAO;
    private final ClientsDAO clientsDAO;

    public FilmController(FilmsDAO filmsDAO, VotesDAO votesDAO, ClientsDAO clientsDAO) {
        this.filmsDAO = filmsDAO;
        this.votesDAO = votesDAO;
        this.clientsDAO = clientsDAO;
    }

    @GetMapping
    public List<Film> getAllFilms() {
        return filmsDAO.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Film> getFilmById(@PathVariable Long id) {
        var f = filmsDAO.findById(id);
        return f != null ? ResponseEntity.ok(f) : ResponseEntity.notFound().build();
    }

    @GetMapping("/{id}/versions")
    public List<FilmVersion> getVersions(@PathVariable Long id) {
        return filmsDAO.findVersionsByFilmId(id);
    }

    @GetMapping("/{id}/actors")
    public List<Actor> getActors(@PathVariable Long id) {
        return filmsDAO.findActorsByFilmId(id);
    }

    @GetMapping("/{id}/votes")
    public List<Vote> getVotes(@PathVariable Long id) {
        return votesDAO.findByFilmId(id);
    }

    @GetMapping("/category/{cat}")
    public List<Film> getByCategory(@PathVariable String cat) {
        return filmsDAO.findByCategory(cat);
    }

    @GetMapping("/predictions")
    public List<SeasonalPrediction> getPredictions(@RequestParam int month) {
        return clientsDAO.getSeasonalPredictions(month);
    }

    @PostMapping
    public ResponseEntity<Film> createFilm(@RequestBody Film film) {
        return ResponseEntity.status(HttpStatus.CREATED).body(filmsDAO.insert(film));
    }

    @PutMapping("/{id}")
    public Film updateFilm(@PathVariable Long id, @RequestBody Film film) {
        return filmsDAO.update(id, film);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFilm(@PathVariable Long id) {
        filmsDAO.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{filmId}/actors/{actorId}/comment")
    public ResponseEntity<Void> addActorComment(
            @PathVariable Long filmId,
            @PathVariable Long actorId,
            @RequestBody java.util.Map<String, String> payload) {
        filmsDAO.updateActorComment(filmId, actorId, payload.get("comment"));
        return ResponseEntity.ok().build();
    }
}
