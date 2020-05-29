//
//  Users.swift
//  Exercise3
//
//  Created by Hung Vuong on 5/26/20.
//  Copyright © 2020 Hung Vuong. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Users: Object, Codable {
    dynamic var name: String?
    dynamic var email: String?
    dynamic var phone: String?
    
}


