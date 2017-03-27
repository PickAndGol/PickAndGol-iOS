//
//  NewPubViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import MapKit

class NewPubViewController: UIViewController {

    let viewModel = NewPubViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.initLocationUser()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBOutlet weak var namePUB: UITextField!
    
    @IBAction func savePUB(_ sender: Any) {
        
      viewModel.savePub(namePUB.text!)
        navigationController?.popViewController(animated: true)
        
    }
    
    

    @IBOutlet weak var map: MKMapView!
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
