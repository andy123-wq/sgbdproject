import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Film } from '../../models';

@Component({
  selector: 'app-films-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="page">
      <div class="page-header">
        <h1>Filme</h1>
        <input class="input-pill" type="text" placeholder="Caută film..." [value]="searchQuery()" (input)="searchQuery.set($any($event.target).value)" />
      </div>
      <div class="tabs">
        @for (cat of categories(); track cat) {
          <button class="tab" [class.active]="selectedCategory() === cat" (click)="selectedCategory.set(cat)">
            {{ cat }}
          </button>
        }
      </div>
      @if (loading()) {
        <p class="muted">Se încarcă...</p>
      } @else {
        <div class="grid">
          @for (film of filteredFilms(); track film.id) {
            <div class="card film-card" [routerLink]="['/films', film.id]">
              <div class="poster">
                <span class="badge-cat">{{ film.category }}</span>
                @if (film.posterUrl) {
                  <img
                    [src]="film.posterUrl"
                    [alt]="film.title"
                    class="film-poster-img"
                    loading="lazy"
                    width="240"
                    height="320"
                  />
                } @else {
                  <div class="film-poster-fallback">
                    <span>🎬</span>
                  </div>
                }
              </div>
              <div class="card-body">
                <h3 class="card-title">{{ film.title }}</h3>
                <div class="stars">
                  <span class="star-icon">★</span>
                  <span class="rating-value">{{ film.rating | number:'1.1-1' }}</span>
                  <span class="rating-max">/ 10</span>
                </div>
              </div>
            </div>
          }
          
          @if (filteredFilms().length === 0) {
            <div class="empty-state">
              <span>🎬</span>
              <p>Niciun film găsit pentru "{{ searchQuery() }}"</p>
            </div>
          }
        </div>
      }
    </div>
  `,
  styleUrls: []
})
export class FilmsListComponent implements OnInit {
  private api = inject(ApiService);
  
  films = signal<Film[]>([]);
  loading = signal<boolean>(true);
  
  searchQuery = signal<string>('');
  selectedCategory = signal<string>('ALL');
  
  categories = computed<string[]>(() => ['ALL', ...new Set(this.films().map(f => f.category))]);
  
  filteredFilms = computed<Film[]>(() => {
    const query = this.searchQuery().toLowerCase().trim();
    const films = this.selectedCategory() === 'ALL'
      ? this.films()
      : this.films().filter(f => f.category === this.selectedCategory());
    
    if (!query) return films;
    return films.filter(f =>
      f.title.toLowerCase().includes(query) ||
      f.category.toLowerCase().includes(query)
    );
  });

  ngOnInit(): void {
    this.api.getFilms().subscribe({
      next: (data: Film[]) => {
        this.films.set(data);
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }
}
