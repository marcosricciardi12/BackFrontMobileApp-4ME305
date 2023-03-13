import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(
    private router: Router
  ) { }

  logout() {
    
    localStorage.removeItem('token');
    Swal.fire({
      position: 'center',
      icon: 'success',
      title: 'Logged out!',
      showConfirmButton: false,
      timer: 1500
    })
    this.router.navigate(['home']);
    
  }

}
