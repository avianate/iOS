//
//  ViewController.swift
//  CollectionView InfiniteScroll
//
//  Created by Nate Graham on 8/7/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit

class VerticalViewController: UIViewController {
    
    let size = 4

    lazy var colorList: [UIColor] = {
        var colors = [UIColor]()
        
        for hue in stride(from: 0, to: 1.0, by: 0.25) {
            let color = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 1, alpha: 1)
            colors.append(color)
        }
        
        return colors
    }()
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.size.width
        let height = (view.frame.size.height - 10) / 2
        let layout = colorCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        
        colorCollectionView.showsVerticalScrollIndicator = false
        colorCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let midIndexPath = IndexPath(row: size / 2, section: 0)
        colorCollectionView.scrollToItem(at: midIndexPath, at: .centeredVertically, animated: false)
    }
}

extension VerticalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        
        cell.backgroundColor = colorList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItemSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowItemSegue" {
            let destinationVC = segue.destination as! HorizontalViewController
            
            if let index = sender as? IndexPath {
                destinationVC.colorList = colorList
                destinationVC.selection = index
            }
        }
    }
}
