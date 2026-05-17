import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';
import { Film, ClientCluster, SeasonalPrediction } from '../../models';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="page">
      <h2 class="page-title" style="margin-top: 0">Top 10 filme după rating</h2>
      <div class="dashboard-card">
        @for (film of allFilms.slice(0, 10); track film.id; let i = $index) {
          <div class="bar-row">
            <span class="bar-num">{{ i + 1 }}</span>
            <span class="bar-title">{{ film.title }}</span>
            <div class="bar-wrap">
              <div class="bar-fill" [style.width]="(film.rating / 10 * 100) + '%'"></div>
            </div>
            <span style="font-weight: bold">{{ film.rating | number:'1.1-1' }}</span>
          </div>
        }
      </div>

      <h2 class="page-title" style="margin-top: 48px">Predicții sezoniere</h2>
      <div style="display: flex; gap: 16px; align-items: center; margin-bottom: 20px;">
        <label style="color: var(--text-secondary)">Selectează luna:</label>
        <select class="input-pill" [(ngModel)]="selectedMonth" (change)="loadPredictions()" style="width: 200px">
          @for (m of months; track m) {
            <option [ngValue]="m">{{ m }}</option>
          }
        </select>
      </div>
      
      <div class="dashboard-card" style="padding: 0; overflow: hidden;">
        <table class="dashboard-table">
          <thead>
            <tr>
              <th>FILM</th>
              <th>CATEGORIE</th>
              <th>VIZIONĂRI ESTIMATE</th>
            </tr>
          </thead>
          <tbody>
            @for (p of predictions; track p.filmId) {
              <tr>
                <td style="font-weight: bold; color: var(--text)">{{ p.title }}</td>
                <td><span class="badge-cat" style="position: static; margin: 0">{{ p.category }}</span></td>
                <td>{{ p.viewCount }}</td>
              </tr>
            }
            @if (predictions.length === 0) {
              <tr><td colspan="3" class="empty-state" style="padding: 40px 0;">Nu există date pentru această lună.</td></tr>
            }
          </tbody>
        </table>
      </div>

      <h2 class="page-title" style="margin-top: 48px">Grupuri clienți (Clustering)</h2>
      <div class="dashboard-card" style="padding: 0; overflow: hidden;">
        <table class="dashboard-table">
          <thead>
            <tr>
              <th>CLIENT</th>
              <th>CATEGORIE DOMINANTĂ</th>
              <th>CLUSTER ASSIGNAT</th>
            </tr>
          </thead>
          <tbody>
            @for (c of clusters; track c.clientId) {
              <tr>
                <td>{{ c.clientName }}</td>
                <td><span class="badge-cat" style="position: static; margin: 0" *ngIf="c.dominantCategory">{{ c.dominantCategory }}</span><span *ngIf="!c.dominantCategory">-</span></td>
                <td>
                  <span [class]="'cluster-badge cluster-' + c.clusterLabel.toLowerCase()">
                    {{ c.clusterLabel }}
                  </span>
                </td>
              </tr>
            }
          </tbody>
        </table>
      </div>
    </div>
  `,
  styleUrls: []
})
export class DashboardComponent implements OnInit {
  private api = inject(ApiService);
  
  allFilms: Film[] = [];
  clusters: ClientCluster[] = [];
  predictions: SeasonalPrediction[] = [];
  
  months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  selectedMonth = new Date().getMonth() + 1;

  ngOnInit() {
    this.api.getFilms().subscribe(data => this.allFilms = data);
    this.api.getClusters().subscribe(data => this.clusters = data);
    this.loadPredictions();
  }

  loadPredictions() {
    this.api.getPredictions(this.selectedMonth).subscribe({
      next: (data) => this.predictions = data
    });
  }
}
