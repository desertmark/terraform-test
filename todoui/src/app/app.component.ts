import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent implements OnInit {
  constructor(private $http: HttpClient) {}
  title = 'todoui';
  public todos$: Observable<any> = of([]);

  ngOnInit() {
    this.todos$ = this.$http.get('/api/todo');
  }
}
