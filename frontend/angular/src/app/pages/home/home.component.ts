import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { LoginService } from 'src/app/services/login/login.service';
import { DomSanitizer } from '@angular/platform-browser';
import { interval, mergeMap } from 'rxjs';
import { json } from 'stream/consumers';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  status:any;
  randomID:any;
  encoded_img:any;
  imagePath:any;
  jsontoken:any;

  constructor(
    private loginService: LoginService,
    private http: HttpClient,
    private router: Router,
    private _sanitizer: DomSanitizer
  ) { }

  ngOnInit(): void {
    let token = localStorage.getItem("token") || "";
    if(token) {
      if (this.tokenExpired(token)) {
        localStorage.removeItem('token');
      }
    }
    this.get_qrcode()
    interval(1 * 1000)
    .pipe(
        mergeMap(() => this.loginService.gettoken(this.randomID))
    )
    .subscribe(data => {
      this.jsontoken = data;
      if (this.jsontoken.tokenID != null) {
        console.log("EL TOKEN ES: " + this.jsontoken.tokenID.toString())
        localStorage.setItem('token',this.jsontoken.tokenID.toString());
        this.router.navigate(['history']);
      }
      
      

    })
  }

  get isToken() {
    return localStorage.getItem('token') || undefined;
 }

 tokenExpired(token: string) {
  const expiry = (JSON.parse(atob(token.split('.')[1]))).exp;
  return (Math.floor((new Date).getTime() / 1000)) >= expiry;
}

  get_qrcode(){
    this.loginService.getQrcode().subscribe((data:any) =>{
      this.status = data.status;
      this.randomID = data.randomID;
      this.encoded_img = data.imageBytes;
      this.imagePath = this._sanitizer.bypassSecurityTrustResourceUrl('data:image/png;base64,' 
                 + this.encoded_img);
      console.log(data)
    })
  }

}
