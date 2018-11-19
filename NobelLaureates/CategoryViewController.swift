//
//  CategoryViewController.swift
//  NobelLaureates
//
//  Created by Herbert Caller on 16/11/2018.
//  Copyright © 2018 hacaller. All rights reserved.
//

import UIKit

extension CategoryViewController: UICollectionViewDelegate {
    
    
}

extension CategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == physicsCollection){
            return physicsLaureates.count
        } else if (collectionView == medicineCollection) {
            return medicineLaureates.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == physicsCollection){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: laureateCellNib, for: indexPath) as! LaureateViewCell
            let urlPhoto = physicsLaureates[indexPath.row].photo
            // Solve sudden stops issue when scrolling photos
            DispatchQueue.global(qos: .utility).async {
                do {
                    if let urlImg = URL.init(string: urlPhoto) {
                        let data = try Data.init(contentsOf: urlImg)
                        DispatchQueue.main.async {
                            cell.imgPhoto?.image = UIImage.init(data: data)
                        }
                    }
                } catch {}
            }
            cell.lblName?.text = physicsLaureates[indexPath.row].name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: laureateCellNib, for: indexPath) as! LaureateViewCell
            let urlPhoto = medicineLaureates[indexPath.row].photo
            // Bad user experience
            do {
                if let urlImg = URL.init(string: urlPhoto) {
                    let data = try Data.init(contentsOf: urlImg)
                    cell.imgPhoto?.image = UIImage.init(data: data)
                }
            } catch {}
            cell.lblName?.text = medicineLaureates[indexPath.row].name
            return cell
        }
    }
    
}

class CategoryViewController: UIViewController, ApiServiceDelegate {
    
    var physicsLaureates: [LaureateResponse] = []
    var medicineLaureates: [LaureateResponse] = []
    
    let apiService = ApiService()
    let laureateCellNib = "LaureateViewCell"
    let physicsCellIdentifier = "PhysicsCellIdentifier"
    let medicineCellIdentifier = "MedicineCellIdentifier"
    let rowHeight: CGFloat = 80.0
    
    @IBOutlet weak var physicsCollection: UICollectionView?
    @IBOutlet weak var medicineCollection: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollections()
        apiService.queries = [LaureateQuery.Physics, LaureateQuery.Physiology]
        apiService.delegate = self
        apiService.findAllLaureates()
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func consumeLaureates(laureates: [LaureateResponse], query: LaureateQuery) {
        if (query == LaureateQuery.Physics) {
            self.physicsLaureates = laureates
            self.physicsCollection?.reloadData()
        } else if (query == LaureateQuery.Physiology) {
            self.medicineLaureates = laureates
            self.medicineCollection?.reloadData()
        }
    }
    
    func configureCollections() {
        physicsCollection?.register(UINib.init(nibName: laureateCellNib, bundle: nil), forCellWithReuseIdentifier: laureateCellNib)
        medicineCollection?.register(UINib.init(nibName: laureateCellNib, bundle: nil), forCellWithReuseIdentifier: laureateCellNib)
    }
    
}
