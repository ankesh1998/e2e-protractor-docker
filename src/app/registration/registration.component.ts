﻿import { OnInit, Component } from "@angular/core";
import { User } from '../models/user.model';

@Component({
  selector: 'app-registration',
  templateUrl: './registration.component.html',
  styleUrls: ['./registration.component.css']
})
export class RegistrationComponent implements OnInit {
  user = new User();
  confirmPassword;
  passwordText;
  constructor() {
  }

  ngOnInit() {
  }

  register(user: User): void{
    console.log(user);
  }
}


