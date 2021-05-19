//
//  PlantModel.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 16.05.21.
//

import Foundation
import UIKit

struct PlantModel {
    var id = String()
    var filePath = String()
    var fileName = String()
    var primaryName = String()
    var secoundryName = String()
    var amountOfWater = String()
    var frequencyOfWater = String()
    var sunlight = String()
    var location = String()
    var userId = String()
    var createdDate = String()
    var categoryName = String()
    var categoryId = String()
    var image = UIImage()
}

protocol getPlantData {
    func push(_ data: PlantModel)
}
