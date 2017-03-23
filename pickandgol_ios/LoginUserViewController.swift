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
import LocalAuthentication

class LoginUserViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var viewModel = LoginViewModel()
    
    var contextSecurity = LAContext()
    
    var touchID = TouchIDAutentication()
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var touchIDButton: UIButton!
    
    @IBAction func touchID(_ sender: Any) {
        
        if  (contextSecurity.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:nil)){
            
            contextSecurity.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login PickAndGol", reply: { (success, error) in
                
                if (success) {
                    print("Con tuouhc")
                }
                
                if (error != nil) {
                    print("ERROR")
                }
                
            })
            
        }
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        viewModel.login(email: email.text!, pass: password.text!).subscribe(onNext: { (element) in
            if(element){
                
               self.loginOk()
                
            }else{
                self.showAlert("Usuario o Contraseña incorrecta")
            }
            
        }).addDisposableTo(disposeBag)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRxSwit()
        activarTouchID()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(_ message:String){
        let alertController = UIAlertController(title: "PickandGol", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func loginOk() {
         self.dismiss(animated: true, completion: nil)
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
        
        

        
        //activateTouch.bindTo(touchIDButton.rx.isHidden)
        
        
    }
    
    func activarTouchID(){
        touchID.isTouchIDPossible().subscribe( onNext: { (element) in
            
           self.touchIDButton.isHidden = !element
        }).addDisposableTo(disposeBag)

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
