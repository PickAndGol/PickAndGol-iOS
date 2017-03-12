//
//  NewItemViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 11/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {

    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var dateEvent: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var categoryEvent: UITextField!
    @IBOutlet weak var pubEvent: UITextField!
    
    var dictionary:JSONDictionary = [:]
    let viewModel = NewEventViewModel()
    
    
    @IBAction func sendEvent(_ sender: Any) {
        
        let session = userSessionManager.sharedInstance
        
        //TODO: Verificar que el usuario a iniciado sesion sino mandar al apartado de login
        
        eventName.text = session.getToken()
        dictionary["name"] = eventName.text as AnyObject?
        dictionary["date"] = dateEvent.text as AnyObject?
        dictionary["pub"] = "58c5036a92b33d06a10ca1e7" as AnyObject? //TODO: Seleccionar un bar
        dictionary["description"] = eventDescription.text as AnyObject?
        dictionary["category"] = categoryEvent.text as AnyObject?
        dictionary["token"] = session.getToken() as AnyObject?
        dictionary["photo_url"] = "test01.jgp" as AnyObject?
        
        /*let body: [String : Any] = [
            "category": "1",
            "date": "2017-03-12T16:03:49+00:00",
            "pub": "58bf2578fbbcf94b0710d809",
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU4YmYyMTQzZmJiY2Y5NGIwNzEwZDgwOCIsImlhdCI6MTQ4OTMzMjU0MCwiZXhwIjoxNDg5MzMzOTgwfQ.bFzdSvOaYxSVx8nF7RcrJF4ckiCFFgZV8ogNmVePH-s",
            "description": "A ver si funciona esta vez",
            "name": "3 Carrera de Caracoles",
            "url": "https://s3-eu-west-1.amazonaws.com/pickandgol/test01.jpg"
        ]*/
        
        viewModel.saveEvent(dictionary: dictionary)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
