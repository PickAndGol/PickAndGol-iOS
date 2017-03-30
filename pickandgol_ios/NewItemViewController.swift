//
//  NewItemViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 11/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxSwift

class NewItemViewController: UIViewController {

    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var dateEvent: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var categoryEvent: UITextField!
    @IBOutlet weak var pubEvent: UITextField!
    
    @IBOutlet weak var photo1: UIButton!
    
    let disposeBag = DisposeBag()

    
    @IBAction func button1(_ sender: Any) {
       takePhoto()
    }
    
    var dictionary:JSONDictionary = [:]
    let viewModel = NewEventViewModel()
    var pubName:JSONDictionary=[:]
    
    @IBAction func sendEvent(_ sender: Any) {
        
        let session = userSessionManager.sharedInstance
        
        //TODO: Verificar que el usuario a iniciado sesion sino mandar al apartado de login
        
        // Guardo la imagen en S3
        
        let urlPhoto = String.random(ofLength: 20)+".jpg"
        photo1.imageForNormal?.savePhotoJPG(urlPhoto)?.savePhotoS3(urlPhoto).subscribe(
            onNext:{ result in
        },
            onError:{error in
                print(error)
        },
            onCompleted: nil,
            onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.dictionary["name"] = self.eventName.text as AnyObject?
        self.dictionary["date"] = self.dateEvent.text as AnyObject?
        self.dictionary["pub"] = pubName["_id"] as AnyObject?
        self.dictionary["description"] = self.eventDescription.text as AnyObject?
        self.dictionary["category"] = self.categoryEvent.text as AnyObject?
        self.dictionary["token"] = session.getToken() as AnyObject?
        self.dictionary["photo_url"] = urlPhoto as AnyObject?
        
        self.viewModel.saveEvent(dictionary: self.dictionary)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takePhoto(){
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
    
    func setPubName(dataPub:JSONDictionary){
        self.pubName = dataPub
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SelectPubViewController
        nextVC.delegate = self
    }

}

extension NewItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        photo1.imageForNormal = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated:true)
    }
    
    
}

extension NewItemViewController:SelectPubViewControllerDelegate {
    func pubSelectedItem(pubSelct: JSONDictionary) {
        pubName = pubSelct
        pubEvent.text = pubName["name"] as! String
        
    }
}

