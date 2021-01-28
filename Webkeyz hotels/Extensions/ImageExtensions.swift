//
//  ImageExtensions.swift
//  Webkeyz hotels
//
//  Created by Amr Fawzy on 1/27/21.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    //MARK:- Kingfisher
    
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        self.kf.setImage(with: url, completionHandler:  { result in
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                self.image = UIImage(named: "SplashScreen")
                print("Error: \(error)")
            }
        })
    }
    
    
    
    
    //MARK:- RoundCorners
    
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
    
    
}
