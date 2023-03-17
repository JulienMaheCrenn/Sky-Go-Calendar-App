//
//  DatabaseReferenceProtocol.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 16/03/2023.
//

import Foundation
import FirebaseDatabase


protocol DatabaseReferenceProtocol: AnyObject {
    func child (_ name:String) ->  DatabaseReference
}


extension DatabaseReference: DatabaseReferenceProtocol {
    
}
