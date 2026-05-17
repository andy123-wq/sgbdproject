package com.filmplatform.exception;

public class InvalidVersionException extends RuntimeException {
    public InvalidVersionException() {
        super("Versiunea nu apartine acestui film");
    }
}
