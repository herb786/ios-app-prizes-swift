//
//  CountryViewController.swift
//  NobelLaureates
//
//  Created by Herbert Caller on 16/11/2018.
//  Copyright © 2018 hacaller. All rights reserved.
//

import UIKit

let laureateCellNib = "LaureateViewCell"
let japanCellIdentifier = "JapanCellIdentifier"
let germanyCellIdentifier = "GermanyCellIdentifier"
let rowHeight: CGFloat = 80.0

extension CountryViewController {
    func configureCollections() {
        japanCollection?.register(UINib.init(nibName: laureateCellNib, bundle: nil), forCellWithReuseIdentifier: japanCellIdentifier)
        germanyCollection?.register(UINib.init(nibName: laureateCellNib, bundle: nil), forCellWithReuseIdentifier: germanyCellIdentifier)
    }
}

extension CountryViewController: UICollectionViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
}

extension CountryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: japanCellIdentifier, for: indexPath) as! LaureateViewCell
        return cell
    }
    
}

class CountryViewController: UIViewController {
    
    @IBOutlet weak var japanCollection: UICollectionView?
    @IBOutlet weak var germanyCollection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollections()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
