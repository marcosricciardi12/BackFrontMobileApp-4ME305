import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import  { environment } from './../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class LoginService {
  url = 'login/qrcode'

  constructor(
    private httpClient: HttpClient
  ) { }

  getQrcode() {
    return  this.httpClient.get((environment.url)+this.url);
  }

}
