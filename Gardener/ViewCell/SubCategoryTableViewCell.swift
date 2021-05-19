//
//  SubCategoryTableViewCell.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 16.05.21.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountOfWaterLbl: UILabel!
    @IBOutlet weak var sunlightLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.addShadow()
        cardView.layer.cornerRadius = 10
        
        itemImage.layer.cornerRadius = itemImage.frame.height/2
        itemImage.layer.borderWidth = 1.5
        itemImage.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        itemImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
