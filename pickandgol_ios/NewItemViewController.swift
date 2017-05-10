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

    
    var dictionary:JSONDictionary = [:]
    let viewModel = NewEventViewModel()
    var pubName:JSONDictionary=[:]
    var itemSelected:IndexPath?
    var categorySelected:JSONDictionary = [:]
    
    
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var dateEvent: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var pubEvent: UITextField!
    @IBOutlet weak var photo1: UIButton!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindRx()
        observerTap()
        self.pubEvent.isUserInteractionEnabled = false
        viewModel.login(controller: self)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func button1(_ sender: Any) {
       takePhoto()
    }
    
    @IBOutlet weak var selectCategory: UICollectionView!
    
    @IBAction func showDatePicker(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    
    
    @IBAction func chooseCategory(_ sender: UITextField) {
        
        let pickerCategoryView:UIPickerView = UIPickerView()
       
        
        sender.inputView = pickerCategoryView
        
    }
    
   
    @IBAction func SaveEvent(_ sender: Any) {
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
        self.dictionary["date"] = viewModel.dateToMogo(date: self.dateEvent.text!) as AnyObject?
        self.dictionary["pub"] = pubName["_id"] as AnyObject?
        self.dictionary["description"] = self.eventDescription.text as AnyObject?
        self.dictionary["category"] = self.categorySelected["_id"]
        self.dictionary["token"] = session.getToken() as AnyObject?
        self.dictionary["photo_url"] = "https://pickandgol.s3.amazonaws.com/"+urlPhoto as AnyObject?
        
        self.viewModel.saveEvent(dictionary: self.dictionary).subscribe(
        
            onNext:{ result in
                if(result){
                    self.cleanFieldAndNotifty()
                }else{
                    self.dontSavePub()
                }
        },
            onError:{error in
            print(error)
        },
            onCompleted: nil,
            onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takePhoto(){
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        let pickerPhoto = UIImagePickerController()
        let photo = UIAlertAction(title: "Hacer FOTO", style: .default) { (action) in
            
            
            if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
                pickerPhoto.sourceType = .camera
            } else {
                pickerPhoto.sourceType = .photoLibrary
            }
            pickerPhoto.delegate = self
            self.present(pickerPhoto, animated: true, completion: nil)
        }
        let library = UIAlertAction(title: "Elige las fotos", style: .default) { (action) in
            pickerPhoto.sourceType = .photoLibrary
            pickerPhoto.delegate = self
            self.present(pickerPhoto, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            
        }
        alert.addAction(photo)
        alert.addAction(library)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func cleanFieldAndNotifty(){
        
        let pubSave = UIAlertController(title: "PickAndGol", message: "Pub Guardado", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
           self.cleanField()
        }
        pubSave.addAction(okAction)
        self.present(pubSave, animated: true, completion: nil)
        
    }
    
    func cleanField(){
        for view in self.view.subviews {
            
            guard let textFieldData = view as? UITextField else{
                return
            }
            textFieldData.text = ""
            
        }
        
        if let oldCellItem = self.itemSelected {
            let oldCell = self.selectCategory.cellForItem(at: oldCellItem) as?categoryPubCollectionViewCell
            self.viewModel.changeSelect(cell: oldCell!, type: cellStatus.deselect)
        }
        
        photo1.imageForNormal = UIImage(named: "default_placeholder")
    }
    
    func dontSavePub(){
        let pubNotSave = UIAlertController(title: "PickAndGol", message: "El Pub no se ha guardado", preferredStyle: .alert)
        self.present(pubNotSave, animated: true, completion: nil)
    }
    
    func setPubName(dataPub:JSONDictionary){
        self.pubName = dataPub
    }
    
    func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY HH:MM"
        dateEvent.text = dateFormatter.string(from: sender.date)
    }
    
    
    
    func bindRx(){
        viewModel.listCategory().bindTo(selectCategory.rx.items) { collectionView, row, event in
            
            let indexPath = IndexPath(item: row, section: 0)
            
            guard let cell = self.selectCategory.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as?categoryPubCollectionViewCell else {
                fatalError("missing cell")
            }
            
            let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
            cell.layer.borderColor = bcolor.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 3
            cell.nameCategory.text = event["name"] as? String
            return cell
            }
            .addDisposableTo(disposeBag)
    }
    
    func observerTap(){
        selectCategory.rx.modelSelected(JSONDictionary.self).subscribe(onNext: { value in
            self.categorySelected = value
        }).addDisposableTo(disposeBag)
        
        selectCategory.rx.itemSelected.subscribe(onNext: { value in
            
            // Select old cell
            
            if let oldCellItem = self.itemSelected {
                let oldCell = self.selectCategory.cellForItem(at: oldCellItem) as?categoryPubCollectionViewCell
                self.viewModel.changeSelect(cell: oldCell!, type: cellStatus.deselect)
            }
            self.itemSelected = value
            let cell = self.selectCategory.cellForItem(at: value) as?categoryPubCollectionViewCell
            self.viewModel.changeSelect(cell: cell!, type: cellStatus.select)
            
        }).addDisposableTo(disposeBag)
        
    }
    
    
   
    

    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SelectPubViewController
        
        nextVC.selectedPub.subscribe(
        
            onNext:{value in
                    self.pubEvent.text = value
        }
        
        ).addDisposableTo(disposeBag)
        
    }

}

extension NewItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        photo1.imageForNormal = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated:true)
    }
    
    
}



