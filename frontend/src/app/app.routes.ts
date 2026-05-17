import { Routes } from '@angular/router';
import { FilmsListComponent } from './components/films-list/films-list.component';
import { FilmDetailComponent } from './components/film-detail/film-detail.component';
import { ClientsListComponent } from './components/clients-list/clients-list.component';
import { ClientProfileComponent } from './components/client-profile/client-profile.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';

export const routes: Routes = [
  { path: '', redirectTo: 'films', pathMatch: 'full' },
  { path: 'films', component: FilmsListComponent },
  { path: 'films/:id', component: FilmDetailComponent },
  { path: 'clients', component: ClientsListComponent },
  { path: 'clients/:id', component: ClientProfileComponent },
  { path: 'dashboard', component: DashboardComponent },
  { path: '**', redirectTo: 'films' }
];
