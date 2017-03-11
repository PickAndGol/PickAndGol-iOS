//
//  LoginUserViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 11/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

class LoginUserViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var viewModel = UserViewModel()
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        viewModel.login(email: email.text!, pass: password.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRxSwit()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func bindRxSwit(){
        
       let userEmail = email
        .rx
        .text
        .throttle(0.3, scheduler: MainScheduler.instance)
        .map { (value) -> Bool in
            guard let val = value else{
                return false
            }
            return val.isEmail
        }
        
        
        let userPass = password
        .rx
        .text
        .throttle(0.3, scheduler: MainScheduler.instance)
        .map { (value) -> Bool in
                guard let val = value else{
                    return false
                }
                self.password.textColor = self.viewModel.qualityPassword(val: val)
                return val.length > 1
        }

        
        let activateButtonLogin = Observable.combineLatest(userPass,userEmail){
            $0 && $1
        }
        
        activateButtonLogin.bindTo(loginButton.rx.isEnabled).addDisposableTo(disposeBag)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
