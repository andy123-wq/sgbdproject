package com.filmplatform.exception;

public class DuplicateVoteException extends RuntimeException {
    public DuplicateVoteException() {
        super("Clientul a votat deja acest film");
    }
}
