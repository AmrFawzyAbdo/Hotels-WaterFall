//
//  HotelsViewController.swift
//  Webkeyz hotels
//
//  Created by Amr Fawzy on 1/27/21.
//

import UIKit
import Kingfisher

class HotelsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var hotelsData = [Hotel]()
    
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
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        layout.headerInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
//        layout.headerHeight = 50
//        layout.footerHeight = 20
        layout.minimumColumnSpacing = 5
        layout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = layout
//        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
//        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        getHotels()
    }
    
    
    func getHotels(){
        self.view.makeToastActivity(.center)
        APIClient().GetHotels { (res) in
            self.view.hideToastActivity()
            print(res)
            self.hotelsData = res
            self.collectionView.reloadData()
        } onError: { (error) in
            self.view.hideToastActivity()
            self.view.makeToast(error)
            print(error)
        }
    }
    
}

    
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
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let reusableView: UICollectionReusableView?
//
//        switch kind {
//        case CollectionViewWaterfallElementKindSectionHeader:
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
//            header.backgroundColor = .black
//            header.largeContentTitle = "Hotels"
//            reusableView = header
//        case CollectionViewWaterfallElementKindSectionFooter:
//            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
//            footer.backgroundColor = .clear
//            reusableView = footer
//        default:
//            reusableView = nil
//        }
//
//        return reusableView!
//    }
}


// MARK: - CollectionViewWaterfallLayoutDelegate
extension HotelsViewController: CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}
    




extension UIImageView {
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        var kf = self.kf
        kf.indicatorType = .activity
        self.kf.setImage(with: resource)
    }
}

extension UIImageView {
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
              self.layer.cornerRadius = radius
              self.layer.maskedCorners = [CACornerMask]
        }
}
