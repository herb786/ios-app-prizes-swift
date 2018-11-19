//
//  CountryViewController.swift
//  NobelLaureates
//
//  Created by Herbert Caller on 16/11/2018.
//  Copyright © 2018 hacaller. All rights reserved.
//

import UIKit

extension CountryViewController: UICollectionViewDelegate {
    
}

extension CountryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == japanCollection){
            return japanLaureates.count
        } else if (collectionView == italyCollection) {
            return italyLaureates.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == japanCollection){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: laureateCellNib, for: indexPath) as! LaureateViewCell
            let urlPhoto = japanLaureates[indexPath.row].photo
            DispatchQueue.global(qos: .background).async {
                do {
                    if let urlImg = URL.init(string: urlPhoto) {
                        let data = try Data.init(contentsOf: urlImg)
                        DispatchQueue.main.async {
                            cell.imgPhoto?.image = UIImage.init(data: data)
                        }
                    }
                } catch {}
            }
            cell.lblName?.text = japanLaureates[indexPath.row].name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: laureateCellNib, for: indexPath) as! LaureateViewCell
            let urlPhoto = italyLaureates[indexPath.row].photo
            do {
                if let urlImg = URL.init(string: urlPhoto) {
                    let data = try Data.init(contentsOf: urlImg)
                    cell.imgPhoto?.image = UIImage.init(data: data)
                }
            } catch {}
            cell.lblName?.text = italyLaureates[indexPath.row].name
            return cell
        }
    }
    
}

class CountryViewController: UIViewController, ApiServiceDelegate {
    
    var japanLaureates: [LaureateResponse] = []
    var italyLaureates: [LaureateResponse] = []
    
    let apiService = ApiService()
    let laureateCellNib = "LaureateViewCell"
    @IBOutlet weak var japanCollection: UICollectionView?
    @IBOutlet weak var italyCollection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollections()
        apiService.queries = [LaureateQuery.Italy, LaureateQuery.Japan]
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
        if (query == LaureateQuery.Italy) {
            self.italyLaureates = laureates
            self.italyCollection?.reloadData()
        } else if (query == LaureateQuery.Japan) {
            self.japanLaureates = laureates
            self.japanCollection?.reloadData()
        }
    }
    
    func configureCollections() {
        japanCollection?.register(UINib.init(nibName: laureateCellNib, bundle: nil), forCellWithReuseIdentifier: laureateCellNib)
        italyCollection?.register(UINib.init(nibName: laureateCellNib, bundle: nil), forCellWithReuseIdentifier: laureateCellNib)
    }

}
