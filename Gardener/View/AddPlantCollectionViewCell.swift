//
//  AddPlantCollectionViewCell.swift
//  Watering
//
//  Created by Ehtisham Khalid on 18.01.21.
//  Copyright © 2021 Macbook. All rights reserved.
//

import UIKit

class AddPlantCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var frequencyLbl: UILabel!
    @IBOutlet weak var addPlantImage: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.shadowColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 2
        
        itemImage.layer.cornerRadius = itemImage.frame.height/2
        itemImage.layer.borderWidth = 1.5
        itemImage.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        itemImage.layer.masksToBounds = true
    }
}
