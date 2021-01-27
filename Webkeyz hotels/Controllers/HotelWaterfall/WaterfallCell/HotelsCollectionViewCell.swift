//
//  HotelsCollectionViewCell.swift
//  Webkeyz hotels
//
//  Created by Amr Fawzy on 1/27/21.
//

import UIKit

class HotelsCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Corner radius image
        hotelImage.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner], radius: 10)
    }

}
