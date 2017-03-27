//
//  UserDetailViewController.swift
//  pickandgol_ios
//
//  Created by Edu González on 15/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwifterSwift
import SwiftKeychainWrapper


class UserDetailViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!

    @IBOutlet weak var userEmail: UILabel!
    
    let viewModel = UserViewModel()
    let disposeBag = DisposeBag()
    let usersesion = userSessionManager.sharedInstance
    let client = Client()
    let touchID = TouchIDAutentication()
    
    @IBAction func registerButtonTapped(_ sender: Any) {

        openMainLogin()
    }
    @IBAction func saveUser(_ sender: Any) {
        
        viewModel.saveProfileUser(user: userNameLabel.text!, userEmail: userEmail.text!, userPhoto: userPhoto.image!)
    }
   
    
    override func viewDidLoad() {

        login()
        photoGestureRecognize()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateFieldsView()
        
    }
    

    func openMainLogin() {
        
        let navVC = UINavigationController()
        let loginVC: MainLoginViewController = UIStoryboard(storyboard: .login).instantiateViewController()
        navVC.viewControllers = [loginVC]
        self.present(navVC, animated: true, completion: nil)
        
    }
    
    func imageTapped(){
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Hacer FOTO", style: .default) { (action) in
              let pickerPhoto = UIImagePickerController()
            
            if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
                pickerPhoto.sourceType = .camera
            } else {
                pickerPhoto.sourceType = .photoLibrary
            }
            pickerPhoto.delegate = self
            self.present(pickerPhoto, animated: true, completion: nil)
        }
        let library = UIAlertAction(title: "Elige las fotos", style: .default) { (action) in
            print("Libreria")
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            print("Libreria")
        }
        alert.addAction(photo)
        alert.addAction(library)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
   
    func updateFieldsView(){
    
        if(userSessionManager.sharedInstance.logged){
            if let photo = retrievePhoto(usersesion.getUrlPhoto()){
                 self.userPhoto.image = photo
            }else {
                self.userPhoto.image = UIImage(named: "ackbar.jpg")
            }
            userPhoto.roundImage()
            userNameLabel.text = usersesion.getUser()
            userEmail.text = usersesion.getEmail()
        }
    }
    
    func retrievePhoto(_ namePhoto:String) -> UIImage? {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let namePhoto = namePhoto.lastPathComponent
        let imageUrl = paths[0].appendingPathComponent(namePhoto)
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image
        
    }
    
    func login(){
        if (!usersesion.logged){
            guard let email = KeychainWrapper.standard.string(forKey: "pickangol-email"), let pass = KeychainWrapper.standard.string(forKey: "pickangol-pass") else {
                openMainLogin()
                return
            }
            
            client.login(email: email, password: pass).subscribe( onNext: { (element) in
                let session = userSessionManager.sharedInstance
                session.initWithLogin(dict: element.result() as! JSONDictionary)
                self.updateFieldsView()
            }).addDisposableTo(self.disposeBag)
            
            
            /*let touchRx = touchID.autenticateWithTouchID().subscribe(onNext: { (element) in
                
                if(element) {
                    self.updateFieldsView()
                } else{
                    self.openMainLogin()
                }
                
                
            }).addDisposableTo(self.disposeBag)*/
            
            
            

            
        }
    }
    
    func photoGestureRecognize() {
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userPhoto.isUserInteractionEnabled = true
        userPhoto.addGestureRecognizer(tapImage)
    }


}


extension UserDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        userPhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated:true)
        
    }
    
    
}

