package com.filmplatform.controller;

import com.filmplatform.dao.ViewingsDAO;
import com.filmplatform.dao.VotesDAO;
import com.filmplatform.model.Viewing;
import com.filmplatform.model.VoteRequest;
import com.filmplatform.model.VoteTag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin("http://localhost:4200")
public class InteractionController {

    private final ViewingsDAO viewingsDAO;
    private final VotesDAO votesDAO;

    public InteractionController(ViewingsDAO viewingsDAO, VotesDAO votesDAO) {
        this.viewingsDAO = viewingsDAO;
        this.votesDAO = votesDAO;
    }

    @PostMapping("/viewings")
    public ResponseEntity<Void> addViewing(@RequestBody Viewing viewing) {
        viewingsDAO.insert(viewing);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PostMapping("/votes")
    public ResponseEntity<Void> submitVote(@RequestBody VoteRequest request) {
        var v = votesDAO.insertVote(request.getVote());
        votesDAO.insertTags(v.getId(), request.getTagIds());
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @GetMapping("/vote-tags")
    public List<VoteTag> getVoteTags() {
        return votesDAO.findAllTags();
    }
}
