import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import  { environment } from './../../../environments/environment';
@Injectable({
  providedIn: 'root'
})
export class SalesService {

  url = "/salesmanager/userpurchases"
  constructor(private httpClient: HttpClient) { }
  
  getPurchases() {
    let auth_token = localStorage.getItem('token');
    if (auth_token) {
      const headers = new HttpHeaders({
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${auth_token}`
      });
      return this.httpClient.get((environment.url)+this.url, {headers: headers});
    }
    else {
      const headers = new HttpHeaders({
        'Content-Type': 'application/json'
      });
      return this.httpClient.get((environment.url)+this.url, {headers: headers});
    }
  }
}
