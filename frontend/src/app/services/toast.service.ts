import { Injectable, signal } from '@angular/core';

@Injectable({providedIn: 'root'})
export class ToastService {
  msg = signal<string | null>(null);
  
  show(m: string, ms = 3000) { 
    this.msg.set(m); 
    setTimeout(() => this.msg.set(null), ms); 
  }
}
