import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Film, FilmVersion, Actor, Vote, Client, ClientProfile, SentimentResult, Viewing, ClientCluster, SeasonalPrediction, VoteTag, VoteRequest } from '../models';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private http = inject(HttpClient);

  // Films
  private filmBase = 'http://localhost:8081/api/films';

  getFilms(): Observable<Film[]> { return this.http.get<Film[]>(this.filmBase); }
  getFilmById(id: number): Observable<Film> { return this.http.get<Film>(`${this.filmBase}/${id}`); }
  getFilmVersions(id: number): Observable<FilmVersion[]> { return this.http.get<FilmVersion[]>(`${this.filmBase}/${id}/versions`); }
  getFilmActors(id: number): Observable<Actor[]> { return this.http.get<Actor[]>(`${this.filmBase}/${id}/actors`); }
  getFilmVotes(id: number): Observable<Vote[]> { return this.http.get<Vote[]>(`${this.filmBase}/${id}/votes`); }
  getFilmsByCategory(cat: string): Observable<Film[]> { return this.http.get<Film[]>(`${this.filmBase}/category/${cat}`); }
  getPredictions(month: number): Observable<SeasonalPrediction[]> { return this.http.get<SeasonalPrediction[]>(`${this.filmBase}/predictions?month=${month}`); }
  createFilm(f: Film): Observable<Film> { return this.http.post<Film>(this.filmBase, f); }
  deleteFilm(id: number): Observable<void> { return this.http.delete<void>(`${this.filmBase}/${id}`); }
  addActorComment(filmId: number, actorId: number, comment: string): Observable<void> {
    return this.http.put<void>(`${this.filmBase}/${filmId}/actors/${actorId}/comment`, { comment });
  }
  // Clients
  private clientBase = 'http://localhost:8081/api/clients';

  getClients(): Observable<Client[]> { return this.http.get<Client[]>(this.clientBase); }
  getClientById(id: number): Observable<Client> { return this.http.get<Client>(`${this.clientBase}/${id}`); }
  getClientProfile(id: number): Observable<ClientProfile> { return this.http.get<ClientProfile>(`${this.clientBase}/${id}/profile`); }
  getSentiment(id: number, filmId?: number): Observable<SentimentResult> {
    return this.http.get<SentimentResult>(`${this.clientBase}/${id}/sentiment` + (filmId ? `?filmId=${filmId}` : ''));
  }
  getRecommendations(id: number): Observable<Film[]> { return this.http.get<Film[]>(`${this.clientBase}/${id}/recommendations`); }
  getClientViewings(id: number): Observable<Viewing[]> { return this.http.get<Viewing[]>(`${this.clientBase}/${id}/viewings`); }
  getClusters(): Observable<ClientCluster[]> { return this.http.get<ClientCluster[]>(`${this.clientBase}/clusters`); }
  createClient(c: Client): Observable<Client> { return this.http.post<Client>(this.clientBase, c); }

  // Interactions
  private interactionBase = 'http://localhost:8081/api';

  getTags(): Observable<VoteTag[]> { return this.http.get<VoteTag[]>(`${this.interactionBase}/vote-tags`); }
  submitVote(request: VoteRequest): Observable<void> { return this.http.post<void>(`${this.interactionBase}/votes`, request); }
  addViewing(v: Viewing): Observable<void> { return this.http.post<void>(`${this.interactionBase}/viewings`, v); }
}
