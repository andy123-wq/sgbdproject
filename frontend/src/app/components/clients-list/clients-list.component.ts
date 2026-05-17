import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Client } from '../../models';

@Component({
  selector: 'app-clients-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="page">
      <div class="page-header">
        <h1 class="page-title" style="margin: 0">Clienți</h1>
        <input class="input-pill" [value]="searchQuery()" (input)="searchQuery.set($any($event.target).value)" placeholder="Caută client...">
      </div>
      
      <div class="grid">
        @for (c of filteredClients(); track c.id) {
          <div class="card client-card" [routerLink]="['/clients', c.id]">
            <div class="client-avatar">
  <img
    [src]="'https://ui-avatars.com/api/?name=' + c.firstName + '+' + c.lastName + '&background=01696f&color=fff&size=80&bold=true'"
    [alt]="c.firstName + ' ' + c.lastName"
    style="width:100%;height:100%;border-radius:50%;object-fit:cover;"
  >
</div>
            <div class="client-info">
              <h3 class="client-name">{{ c.firstName }} {{ c.lastName }}</h3>
              <p class="client-city-email">{{ c.city }} • {{ c.email || '-' }}</p>
              <p class="client-phone">{{ c.phoneHome }}</p>
            </div>
            <button class="btn-primary" style="margin-top: auto;">Profil →</button>
          </div>
        }
      </div>

      @if (filteredClients().length === 0) {
        <div class="empty-state">
          <span>👤</span>
          <p>Niciun client găsit pentru "{{ searchQuery() }}"</p>
        </div>
      }
    </div>
  `,
  styleUrls: []
})
export class ClientsListComponent implements OnInit {
  private api = inject(ApiService);
  
  clients = signal<Client[]>([]);
  searchQuery = signal<string>('');
  
  filteredClients = computed<Client[]>(() => {
    const q = this.searchQuery().toLowerCase().trim();
    if (!q) return this.clients();
    return this.clients().filter(c =>
      c.firstName.toLowerCase().includes(q) ||
      c.lastName.toLowerCase().includes(q) ||
      c.city.toLowerCase().includes(q) ||
      (c.email ?? '').toLowerCase().includes(q)
    );
  });

  ngOnInit() {
    this.api.getClients().subscribe({
      next: (data) => this.clients.set(data)
    });
  }
}
