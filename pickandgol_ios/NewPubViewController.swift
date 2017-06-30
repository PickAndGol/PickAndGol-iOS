//
//  NewPubViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import MapKit
import RxRealm
import RxSwift


class NewPubViewController: UIViewController, UICollectionViewDelegate {

    let viewModel = NewPubViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.initLocationUser()
        photoCollection.delegate = self
        photoCollection.dataSource = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var namePUB: UITextField!
    @IBOutlet weak var webUrl: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveNewPub(_ sender: Any) {
        
        //self.dismiss(animated: true, completion: nil)
        
        viewModel.savePub(name: namePUB.text!, url: webUrl.text!, phone: phone.text!).subscribe(
        
            onNext:{element in
               
                let title = "Result"
                let result = element["result"] as! String
                if (element["result"] as! String == "nok") {
                    
                }
                
                let alert = UIAlertController(title: title, message: element["description"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ action in
                     self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion:nil)
                
        }
        
        ).addDisposableTo(disposeBag)
        
    }
    
    @IBAction func savePUB(_ sender: Any) {
        
        var datapub:JSONDictionary = [:]
        datapub["name"] = namePUB.text as AnyObject
        datapub["url"] = webUrl.text as AnyObject
        datapub["phone"] = phone.text as AnyObject
    
        
        
        
        viewModel.savePub(name: namePUB.text!, url: webUrl.text!, phone: phone.text!).subscribe(
            
            onNext:{element in
                print(element)
                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
            
            ).addDisposableTo(disposeBag)

        //navigationController?.popViewController(animated: true)
        
    }
    
    

    @IBOutlet weak var map: MKMapView!
    
    
     func takePhoto(){
         let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
         let pickerPhoto = UIImagePickerController()
         let photo = UIAlertAction(title: "Hacer FOTO", style: .default) { (action) in
         
         
         if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
         pickerPhoto.sourceType = .camera
         } else {
         pickerPhoto.sourceType = .photoLibrary
         }
         pickerPhoto.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
         self.present(pickerPhoto, animated: true, completion: nil)
         }
         let library = UIAlertAction(title: "Elige las fotos", style: .default) { (action) in
         pickerPhoto.sourceType = .photoLibrary
         pickerPhoto.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
         self.present(pickerPhoto, animated: true, completion: nil)
         }
         let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
         
         }
         alert.addAction(photo)
         alert.addAction(library)
         alert.addAction(cancel)
         self.present(alert, animated: true, completion: nil)
     
     }
    
    func savePhoto(_ photo:UIImage){
        let urlPhoto = String.random(ofLength: 20)+".jpg"
        
        photo.savePhotoJPG(urlPhoto)?.savePhotoS3(urlPhoto).subscribe(
            onNext:{ result in
                print(result)
        },
            onError:{error in
                print(error)
        }
            ).addDisposableTo(disposeBag)
    
    
     self.viewModel.savePhoto(urlPhoto)
     self.photoCollection.reloadData()   
    
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

extension NewPubViewController:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = viewModel.photoAtIndex(indexPath.row)
        let cell: NewPubCollectionViewCell = self.photoCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewPubCollectionViewCell
        
        if (photo != "dummmy") {
            self.viewModel.downLoadImage(image: photo).bindTo(cell.pubimage.rx.image).addDisposableTo(disposeBag)
        }else{
            cell.pubimage.image = UIImage(named: "takephoto")
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        takePhoto()
        
    }
    
}

extension NewPubViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.savePhoto((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        self.dismiss(animated:true)
    }
    
    
}




