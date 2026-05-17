import { Component, inject } from '@angular/core';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-toast',
  standalone: true,
  template: `
    <div class="toast" [class.show]="!!toast.msg()">
      {{ toast.msg() }}
    </div>
  `,
  styleUrls: []
})
export class ToastComponent {
  toast = inject(ToastService);
}
