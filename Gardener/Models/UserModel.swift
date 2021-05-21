//
//  UserModel.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import Foundation
import UIKit

struct UserModel: Codable {
    var userId = String()
    var firstName = String()
    var lastName = String()
    var email = String()
    var countryCode = String()
    var phoneNumber = String()
    var isPhoneVerified = Bool()
    var city = String()
    var state = String()
    var country = String()
    var postalCode = String()
    var address = String()
    var fileName = String()
    var filePath = String()
    var role = String()
    var isUserVerified = Bool()
    var isProfileCompleted = Bool()
    var skills = [String]()
    var Availability = [String]()
    var rates = [String]()
    var ratings = Int()
    var reviews = Int()
    var headline = String()
    var description = String()
    var date = String()
    var DOB = String()
    var jobType = String()
    var notification = Bool()
    var password = String()
    var longitude = Double()
    var latitude = Double()
}

