import { Component, HostListener } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [RouterModule],
  template: `
    <nav class="navbar">
      <a routerLink="/films" class="navbar-logo">CineTrack</a>

      <div class="nav-dropdown-wrapper" [class.is-open]="menuOpen">
        <button class="nav-trigger" (click)="toggleMenu()">
          Navigare
          <span class="nav-trigger-icon">▾</span>
        </button>
        <div class="nav-dropdown">
          <a routerLink="/films" routerLinkActive="nav-active" class="nav-item" (click)="menuOpen=false">
            <span class="nav-item-icon">🎬</span>
            Filme
          </a>
          <a routerLink="/clients" routerLinkActive="nav-active" class="nav-item" (click)="menuOpen=false">
            <span class="nav-item-icon">👥</span>
            Clienți
          </a>
          <a routerLink="/dashboard" routerLinkActive="nav-active" class="nav-item" (click)="menuOpen=false">
            <span class="nav-item-icon">📊</span>
            Dashboard
          </a>
        </div>
      </div>
    </nav>
  `,
  styleUrls: []
})
export class NavbarComponent {
  menuOpen = false;

  toggleMenu() {
    this.menuOpen = !this.menuOpen;
  }

  @HostListener('document:click', ['$event'])
  onDocumentClick(event: MouseEvent) {
    const target = event.target as HTMLElement;
    if (!target.closest('.nav-dropdown-wrapper')) {
      this.menuOpen = false;
    }
  }
}