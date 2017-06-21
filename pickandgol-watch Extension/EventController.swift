//
//  EventController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 6/6/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import WatchKit
import Foundation



class EventController: WKInterfaceController {
    @IBOutlet var eventTable: WKInterfaceTable!
    //private let viewModel = TimelineViewModel()
    
    var network = networkManagerForWatch(URL(string:"http://pickandgol.com/api/v1/")!)


    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
     
        
        self.loadData()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func loadData(){
        network.executeJsonRequest(endPoint: "events/", method: .get){ dictionary, error in
            
            self.populateTable((dictionary?.results())!)
        }
    }
    
    func loadCategory(completion: @escaping (_ categoryList:[String:String]) -> Void){
        network.executeJsonRequest(endPoint: "categories/", method: .get){ dictionary, error in
            
            var category:[String:String] = [:]
            for dataCategory in (dictionary?.results())! {
               
               let dataValue = [dataCategory] as Array<JSONDictionary>
                category[dataValue[0]["_id"]! as! String] = dataValue[0]["name"]! as! String
            }
            
            completion(category)
        }
        
    }
    
    
    func populateTable(_ dataResponse:[JSONDictionary]){

        // Clean Row
        let numberRows = eventTable.numberOfRows
        if numberRows > 0 {
            eventTable.removeRows(at: IndexSet(integersIn: NSMakeRange(0, numberRows).toRange()!))
        }

        // Load Category before insert rows
        loadCategory{ listOfCategories in
        var i = 0
        for data in dataResponse {
            
            self.eventTable.insertRows(at: NSIndexSet(index: i) as IndexSet, withRowType: "eventRowCellType")
            let controller = self.eventTable.rowController(at: i)
            
            if let controller = controller as? eventRowController {
                
                
                controller.eventName.setText(data["name"] as? String)
                controller.eventDate.setText(self.zuluToDate((data["date"] as? String)!))
        
                 let nameFileCategory = self.nameOfCategory(listOfCategory: listOfCategories, idOfCategory: data["category"] as? Array<String>)
                 controller.eventImage.setImage(UIImage(named: nameFileCategory))
                
                
            } else {
                print("ERROR")
            }
            
            i += 1
        }
        
    }
    }
    
    func nameOfCategory(listOfCategory:[String:String]?, idOfCategory:Array<String>?) -> String{
        
         let typeCategories = ["Football":"soccer","Formula One":"formula1","Motorcycling":"moto","Cycling":"bicycle","Tennis":"tennis"]
        
        guard let listCategory = listOfCategory, let idCategory = idOfCategory?[0] else {
            return "other"
        }
        
        guard let nameOfCategory = listCategory[idCategory] else {
            return "other"
        }
        
        guard let fileOfCategory = typeCategories[nameOfCategory] else {
            return "other"
        }
        
        return fileOfCategory
        
    }
    
    func zuluToDate(_ dateString:String) -> String{
        
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: dateString)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date!)
        
    }
    

   

}
