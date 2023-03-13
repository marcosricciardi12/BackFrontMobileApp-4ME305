import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import  { environment } from './../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class LoginService {
  url = 'login/qrcode'
  url2 = 'login/'

  constructor(
    private httpClient: HttpClient
  ) { }

  getQrcode() {
    return  this.httpClient.get((environment.url)+this.url);
  }

  gettoken(randomID:any) {
    return  this.httpClient.get((environment.url)+this.url2+randomID);
  }

}
