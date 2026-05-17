import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';
import { ToastService } from '../../services/toast.service';
import { Film, FilmVersion, Actor, Vote, SentimentResult, VoteTag, VoteRequest, Viewing } from '../../models';
import { forkJoin } from 'rxjs';

@Component({
  selector: 'app-film-detail',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="page" *ngIf="film">
      <button class="back-btn" (click)="goBack()">← Înapoi</button>
      
      <div class="hero">
        <h1 style="margin: 0">{{ film?.title }}</h1>
        <p class="hero-meta">{{ film?.category }} · {{ getStars(film?.rating) }} · {{ getYear(film?.releaseDate) }}</p>
        <p class="hero-desc">{{ film?.description }}</p>
      </div>

      <p class="section-title">Distribuție</p>
     <div class="chips" style="display: flex; flex-direction: column; gap: 12px; align-items: flex-start;">
        @for (actor of actors; track actor.id) {
          <div style="background: var(--surface); border: 1px solid var(--border); border-radius: 6px; padding: 12px; width: 100%; max-width: 500px;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <span style="font-weight: bold; color: var(--text);">{{ actor.stageName }}</span>
              <button class="btn-ghost" style="padding: 4px 8px; font-size: 0.8rem; cursor: pointer; color: var(--accent);" (click)="openActorModal(actor)">
                {{ actor.performanceComment ? '✎ Editează recenzia' : '+ Adaugă recenzie' }}
              </button>
            </div>
            @if (actor.performanceComment) {
              <p style="margin: 8px 0 0 0; font-size: 0.9rem; color: var(--muted); border-top: 1px dashed var(--border); padding-top: 8px;">
                "{{ actor.performanceComment }}"
              </p>
            }
          </div>
        }
      </div>

      <p class="section-title">Versiuni disponibile</p>
      <table>
        <thead>
          <tr><th>Format</th><th>Rezoluție</th><th>Limbă</th><th>Status</th></tr>
        </thead>
        <tbody>
          @for (v of versions; track v.id) {
            <tr>
              <td>{{ v.format }}</td>
              <td>{{ v.resolution }}</td>
              <td>{{ v.language }}</td>
              <td>
                <span [class.avail-yes]="v.isAvailable" [class.avail-no]="!v.isAvailable">
                  {{ v.isAvailable ? '✓ Disponibil' : '✗ Indisponibil' }}
                </span>
              </td>
            </tr>
          }
        </tbody>
      </table>

      <div class="sentiment-section">
        <span>Sentiment recenzii: </span>
        <span class="badge" [ngClass]="getBadgeClass(sentiment?.sentiment)">
          {{ sentiment?.sentiment || 'NEUTRU' }}
        </span>
      </div>

      <div style="display:flex; gap:12px; margin-top:24px;">
        <button class="btn-primary" (click)="showViewModal=true">▶ Vizualizează</button>
        <button class="btn-primary" (click)="showVoteModal=true">✎ Recenzează</button>
      </div>

      @if (votes.length > 0) {
        <p class="section-title">Recenzii</p>
        @for (vote of votes; track vote.id) {
          <div style="border-bottom: 1px solid var(--border); padding: 12px 0;">
            <div style="display: flex; gap: 12px; margin-bottom: 8px;">
              <span class="badge badge-pos">{{ vote.score }}/10</span>
              <span class="muted" style="font-size: 0.875rem">{{ vote.votedAt }}</span>
            </div>
            <p style="margin: 0">{{ vote.commentText }}</p>
          </div>
        }
      }

      @if (showViewModal) {
        <div class="overlay" (click)="showViewModal=false">
          <div class="modal" (click)="$event.stopPropagation()">
            <h2 style="margin-top: 0">Selectează versiunea</h2>
            <div class="field">
              <label>Versiune</label>
              <select [(ngModel)]="selectedVersionId">
                @for (v of versions; track v.id) {
                  <option [ngValue]="v.id">{{ v.format }} - {{ v.language }}</option>
                }
              </select>
            </div>
            <div class="modal-footer">
              <button class="btn-secondary" (click)="showViewModal=false">Anulează</button>
              <button class="btn-primary" (click)="confirmView()">Confirmă</button>
            </div>
          </div>
        </div>
      }

      @if (showVoteModal) {
        <div class="overlay" (click)="showVoteModal=false">
          <div class="modal" (click)="$event.stopPropagation()">
            <h2 style="margin-top: 0">Adaugă recenzie</h2>
            <div class="field">
              <label>Scor</label>
              <input type="range" min="1" max="10" [(ngModel)]="voteScore">
              <div style="text-align: right; margin-top: 4px; font-weight: bold; color: var(--accent);">
                {{ voteScore }}/10
              </div>
            </div>
            <div class="field">
              <label>Comentariu</label>
              <textarea [(ngModel)]="voteComment" rows="3"></textarea>
            </div>
            <div class="field">
              <label>Caracterizări</label>
              <div class="tags-grid">
                @for (t of allTags; track t.id) {
                  <div class="tag-option">
                    <input type="checkbox" [id]="'tag-'+t.id" (change)="toggleTag(t.id, $event)">
                    <label [for]="'tag-'+t.id">{{ t.tagName }}</label>
                  </div>
                }
              </div>
            </div>
            <div class="modal-footer">
              <button class="btn-secondary" (click)="showVoteModal=false">Anulează</button>
              <button class="btn-primary" (click)="submitVote()">Trimite</button>
            </div>
          </div>
        </div>
      }
        @if (showActorModal && selectedActor) {
        <div class="overlay" (click)="showActorModal=false">
          <div class="modal" (click)="$event.stopPropagation()">
            <h2 style="margin-top: 0">Recenzie prestație</h2>
            <p style="margin-top: -10px; margin-bottom: 20px; color: var(--muted);">Cum a jucat <strong>{{ selectedActor.stageName }}</strong> în acest film?</p>
            <div class="field">
              <textarea [(ngModel)]="actorComment" rows="3" placeholder="Scrie părerea ta despre rol..."></textarea>
            </div>
            <div class="modal-footer">
              <button class="btn-secondary" (click)="showActorModal=false">Anulează</button>
              <button class="btn-primary" (click)="submitActorComment()">Salvează</button>
            </div>
          </div>
        </div>
      }
    </div>
  `,
  styleUrls: []
})
export class FilmDetailComponent implements OnInit {
  private api = inject(ApiService);
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private toast = inject(ToastService);

  filmId!: number;
  film: Film | null = null;
  versions: FilmVersion[] = [];
  actors: Actor[] = [];
  votes: Vote[] = [];
  sentiment: SentimentResult | null = null;
  allTags: VoteTag[] = [];

  showViewModal = false;
  showVoteModal = false;

  selectedVersionId: number | null = null;
  voteScore = 7;
  voteComment = '';
  selectedTagIds: number[] = [];

  clientId = 1; // Simulated authenticated user

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      this.filmId = Number(params.get('id'));
      this.loadData();
    });
  }

  loadData() {
    forkJoin({
      film: this.api.getFilmById(this.filmId),
      versions: this.api.getFilmVersions(this.filmId),
      actors: this.api.getFilmActors(this.filmId),
      votes: this.api.getFilmVotes(this.filmId),
      sentiment: this.api.getSentiment(this.clientId, this.filmId),
      tags: this.api.getTags()
    }).subscribe({
      next: (res) => {
        this.film = res.film;
        this.versions = res.versions;
        this.actors = res.actors;
        this.votes = res.votes;
        this.sentiment = res.sentiment;
        this.allTags = res.tags;

        if (this.versions.length > 0) {
          this.selectedVersionId = this.versions[0].id;
        }
      }
    });
  }

  goBack() {
    this.router.navigate(['/films']);
  }

  getStars(rating: number | undefined): string {
    if (rating === undefined) return '';
    const stars = Math.round(rating / 2);
    return '★'.repeat(stars) + '☆'.repeat(5 - stars);
  }

  getYear(date: string | undefined): string {
    return date ? date.substring(0, 4) : '';
  }

  getBadgeClass(sent: string | undefined): string {
    if (sent === 'POZITIV') return 'badge-pos';
    if (sent === 'NEGATIV') return 'badge-neg';
    return 'badge-neu';
  }

  toggleTag(id: number, event: any) {
    if (event.target.checked) {
      this.selectedTagIds.push(id);
    } else {
      this.selectedTagIds = this.selectedTagIds.filter(tid => tid !== id);
    }
  }

  confirmView() {
    if (!this.selectedVersionId) return;

    const viewing: Viewing = {
      id: 0,
      clientId: this.clientId,
      filmId: this.filmId,
      versionId: this.selectedVersionId,
      durationMinutes: 120,
      status: 'completed'
    };

    this.api.addViewing(viewing).subscribe({
      next: () => {
        this.showViewModal = false;
        this.toast.show('Vizionare înregistrată cu succes!');
      }
    });
  }

  submitVote() {
    const vote: Vote = {
      id: 0,
      clientId: this.clientId,
      filmId: this.filmId,
      score: this.voteScore,
      commentText: this.voteComment
    };

    const request: VoteRequest = {
      vote: vote,
      tagIds: this.selectedTagIds
    };

    this.api.submitVote(request).subscribe({
      next: () => {
        this.showVoteModal = false;
        this.toast.show('Recenzie adăugată cu succes!');
        this.loadData(); // Reload votes
      }
    });
  }
  //Actor Modal Logic 
  showActorModal = false;
  selectedActor: Actor | null = null;
  actorComment = '';

  openActorModal(actor: Actor) {
    this.selectedActor = actor;
    this.actorComment = '';
    this.showActorModal = true;
  }

  submitActorComment() {
    if (!this.selectedActor) return;

    this.api.addActorComment(this.filmId, this.selectedActor.id, this.actorComment).subscribe({
      next: () => {
        this.showActorModal = false;
        this.toast.show(`Comentariu salvat pentru ${this.selectedActor?.stageName}!`);
      },
      error: () => this.toast.show('Eroare la salvarea recenziei.')
    });
  }
}
