//
//  TimelineViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

class TimelineViewModel {
    
  
    public lazy var  myevents: Observable<[Response]> = Client().listAllEvent()
    
    
   
    
}
