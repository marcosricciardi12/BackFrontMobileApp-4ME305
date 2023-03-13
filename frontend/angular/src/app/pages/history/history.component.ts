import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { SalesService } from 'src/app/services/sales/sales.service';


function delay(ms: number) {
  return new Promise( resolve => setTimeout(resolve, ms) );
}

@Component({
  selector: 'app-history',
  templateUrl: './history.component.html',
  styleUrls: ['./history.component.css']
})
export class HistoryComponent implements OnInit {

  arrayPurchases:any;
  cant:any
  menu:any
  total_price:any;
  price_detail:any
  arrayDetails:any;
  saleID:any;
  constructor(
    private router: Router,
    private salesService: SalesService,
  ) { }

  async ngOnInit(): Promise<void> {
    let token = localStorage.getItem("token") || "";
    if(token) {
      if (this.tokenExpired(token)) {
        localStorage.removeItem('token');
        this.router.navigate(['/home']);
      }
    }
    else {
      this.router.navigate(['/home']);
    }
    this.getPurchases()
    
  }


  getPurchases(){
    this.salesService.getPurchases().subscribe((data:any) =>{
      console.log('JSON data: ', data);
      this.arrayPurchases = data.purchases;
      console.log('Paginacion actual: ', this.arrayPurchases);
    })
  }

  getitemDetails(detail:any, purchaseID:any, totalprice:any) {
    this.saleID = purchaseID
    this.arrayDetails = detail
    this.total_price = totalprice

  }

  tokenExpired(token: string) {
    const expiry = (JSON.parse(atob(token.split('.')[1]))).exp;
    return (Math.floor((new Date).getTime() / 1000)) >= expiry;
  }

}
