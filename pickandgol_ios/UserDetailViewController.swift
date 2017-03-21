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


class UserDetailViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!

    @IBOutlet weak var userEmail: UILabel!
    
    let viewModel = UserViewModel()
    
    @IBAction func registerButtonTapped(_ sender: Any) {

        openMainLogin()
    }
    @IBAction func saveUser(_ sender: Any) {
     
        
        viewModel.saveProfileUser(user: userNameLabel.text!, userEmail: userEmail.text!, userPhoto: userPhoto.image!)
        
    }
   
    
    override func viewDidLoad() {

        let usersesion = userSessionManager.sharedInstance
        if (!usersesion.logged){
            openMainLogin()
        }
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userPhoto.isUserInteractionEnabled = true
        userPhoto.addGestureRecognizer(tapImage)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let usersesion = userSessionManager.sharedInstance
        if(userSessionManager.sharedInstance.logged){
            //userPhoto.image = UIImage(named: "ackbar.jpg")
            userPhoto.roundImage()
            userNameLabel.text = usersesion.getUser()
            userEmail.text = usersesion.getEmail()
        }
        
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
    

}


extension UserDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        userPhoto.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        
        self.dismiss(animated:true)
    }
    
    
}

