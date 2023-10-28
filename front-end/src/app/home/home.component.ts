import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { faMobile, faTint, faWindowRestore, faEnvelope, faPhone } from '@fortawesome/free-solid-svg-icons';


@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})

export class HomeComponent implements OnInit {

  faMobile = faMobile
  faTint = faTint
  faWindowRestore = faWindowRestore
  faEnvelope = faEnvelope
  faPhone = faPhone

  count: any;

  constructor(private http: HttpClient) { }

  ngOnInit(): void {
    this.updateCountOnLoad('site_id');
  }

  updateCountOnLoad(siteId: string) {
    const postUrl = 'https://iig2epa9xb.execute-api.us-east-1.amazonaws.com/postprod/postapiresource?';

    // Include the 'site_id' query parameter using HttpParams
    const params = new HttpParams().set('site_id', siteId);
    this.http.post(postUrl, {}, { params }).subscribe(
      () => {
        this.fetchCount(siteId); // Pass the site_id to the next function
      },
      (error) => {
        console.error('Failed to update the count', error);
      }
    );
  }

  fetchCount(siteId: string) {
    const getUrl = 'https://6fqciaodra.execute-api.us-east-1.amazonaws.com/getprod/getapiresource?';

    // Include the 'site_id' query parameter using HttpParams
    const params = new HttpParams().set('site_id', siteId);
    this.http.get(getUrl, { params }).subscribe(
      (data: any) => {
        const count = data.count;
        this.count = count;
      },
      (error) => {
        console.error('Failed to fetch the count', error);
      }
    );
  }
}
