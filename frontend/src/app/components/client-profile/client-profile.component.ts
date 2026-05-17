import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Client, ClientProfile, SentimentResult, Film, Viewing } from '../../models';
import { forkJoin } from 'rxjs';

@Component({
  selector: 'app-client-profile',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="page" *ngIf="client">
      <button class="back-btn" (click)="goBack()">← Înapoi</button>

      <div class="page-header" style="align-items: flex-start; flex-direction: column;">
        <h1 style="margin: 0; display: flex; align-items: center; gap: 16px;">
          {{ client?.firstName }} {{ client?.lastName }}
          @if (sentiment) {
            <span class="badge" [ngClass]="getBadgeClass(sentiment?.sentiment)">
              {{ sentiment?.sentiment }}
            </span>
          }
        </h1>
        <p class="muted" style="margin-top: 8px;">
          {{ client?.email || 'Fără email' }} · {{ client?.city }}
        </p>
      </div>

      <div class="stats-grid">
        <div class="stat-card">
          <p class="stat-label">Categorie preferată</p>
          <p class="stat-value">{{ profile?.mostWatchedCategory || '-' }}</p>
        </div>
        <div class="stat-card">
          <p class="stat-label">Media voturilor</p>
          <p class="stat-value">{{ profile?.averageVoteScore || 0 | number:'1.1-1' }}/10</p>
        </div>
        <div class="stat-card">
          <p class="stat-label">Total vizionări</p>
          <p class="stat-value">{{ profile?.totalViewings || 0 }}</p>
        </div>
        <div class="stat-card">
          <p class="stat-label">Actor preferat</p>
          <p class="stat-value" style="font-size: 1.2rem;">{{ profile?.topActor || '-' }}</p>
        </div>
      </div>

      <p class="section-title">Recomandări</p>
      <div class="grid">
        @for (film of recommendations.slice(0, 6); track film.id) {
          <div class="card film-card" [routerLink]="['/films', film.id]">
            <div class="poster">
              @if (film.posterUrl) {
                <img [src]="film.posterUrl" [alt]="film.title" class="film-poster-img">
              } @else {
                <div class="film-poster-fallback">{{ getInitials(film.title) }}</div>
              }
            </div>
            <div class="card-body">
              <span class="badge-cat">{{ film.category }}</span>
              <h3 style="margin: 0 0 8px 0; font-size: 1rem">{{ film.title }}</h3>
              <div class="stars">★ {{ film.rating | number:'1.1-1' }}</div>
            </div>
          </div>
        }
        @if (recommendations.length === 0) {
          <p class="muted">Nu există recomandări suficiente momentan.</p>
        }
      </div>

      <p class="section-title" style="margin-top: 48px">Istoric vizionări</p>
      <table>
        <thead>
          <tr>
            <th>FILM</th>
            <th>DATĂ</th>
            <th>DURATĂ</th>
            <th>STATUS</th>
          </tr>
        </thead>
        <tbody>
          @for (v of viewings; track v.id) {
            <tr>
              <td style="font-weight: 500">{{ v.filmTitle }}</td>
              <td>{{ v.viewedAt }}</td>
              <td>{{ v.durationMinutes }} min</td>
              <td>
                <span [class]="'status-' + v.status">
                  {{ v.status }}
                </span>
              </td>
            </tr>
          }
        </tbody>
      </table>
    </div>
  `,
  styleUrls: []
})
export class ClientProfileComponent implements OnInit {
  private api = inject(ApiService);
  private route = inject(ActivatedRoute);
  private router = inject(Router);

  clientId!: number;
  client: Client | null = null;
  profile: ClientProfile | null = null;
  sentiment: SentimentResult | null = null;
  recommendations: Film[] = [];
  viewings: Viewing[] = [];

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      this.clientId = Number(params.get('id'));
      this.loadData();
    });
  }

  loadData() {
    forkJoin({
      client: this.api.getClientById(this.clientId),
      profile: this.api.getClientProfile(this.clientId),
      sentiment: this.api.getSentiment(this.clientId),
      recommendations: this.api.getRecommendations(this.clientId),
      viewings: this.api.getClientViewings(this.clientId)
    }).subscribe({
      next: (res) => {
        this.client = res.client;
        this.profile = res.profile;
        this.sentiment = res.sentiment;
        this.recommendations = res.recommendations;
        this.viewings = res.viewings;
      }
    });
  }

  goBack() {
    this.router.navigate(['/clients']);
  }

  getBadgeClass(sent: string | undefined): string {
    if (sent === 'POZITIV') return 'badge-pos';
    if (sent === 'NEGATIV') return 'badge-neg';
    return 'badge-neu';
  }

  getInitials(title: string): string {
    const words = title.split(' ');
    if (words.length >= 2) {
      return (words[0].charAt(0) + words[1].charAt(0)).toUpperCase();
    }
    return title.substring(0, 2).toUpperCase();
  }
}