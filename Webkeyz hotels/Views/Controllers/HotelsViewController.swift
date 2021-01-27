//
//  HotelsViewController.swift
//  Webkeyz hotels
//
//  Created by Amr Fawzy on 1/27/21.
//

import UIKit
import Kingfisher

class HotelsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    //Contains array of Hotel data
    var hotelsData = [Hotel]()
    
    // Random cell size
    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
        
        for _ in 0...100 {
            let random = Int(arc4random_uniform((UInt32(100))))
            
            cellSizes.append(CGSize(width: 140, height: 50 + random))
        }
        
        return cellSizes
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout of collectionView
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumColumnSpacing = 5
        layout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = layout
        
        getHotels()
        
    }
    
    //MARK:- Calling API that retrive hotels data
    
    func getHotels(){
        //Make a toast
        self.view.makeToastActivity(.center)
        APIClient().GetHotels { (res) in
            self.view.hideToastActivity()
            print(res)
            self.hotelsData = res
            
            // Reload tableView
            self.collectionView.reloadData()
        } onError: { (error) in
            self.view.hideToastActivity()
            self.view.makeToast(error)
            print(error)
        }
    }
    
}

    
//MARK:- UICollectionViewDataSource and, UICollectionViewDelegate

extension HotelsViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelsCollectionViewCell", for: indexPath) as! HotelsCollectionViewCell
        cell.hotelName.text = hotelsData[indexPath.item].summary?.hotelName ?? ""
        cell.hotelImage.setImage(with: hotelsData[indexPath.item].image.first?.url ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellItem = hotelsData[indexPath.row]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HotelDetailsViewController") as? HotelDetailsViewController
        vc!.data = cellItem
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}


// MARK: - CollectionViewWaterfallLayoutDelegate
extension HotelsViewController: CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}
    


