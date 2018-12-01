//
//  HorizontalViewController.swift
//  CollectionView InfiniteScroll
//
//  Created by Nate Graham on 8/7/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit

class HorizontalViewController: UIViewController {

    let size = 4
    lazy var colorList: [UIColor] = {
        var colors = [UIColor]()
        
        for hue in stride(from: 0, to: 1.0, by: 0.25) {
            let color = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 1, alpha: 1)
            colors.append(color)
        }
        
        return colors
    }()
    var selection: IndexPath?
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width - 10
        let height = view.frame.size.height
        let layout = colorCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        
        colorCollectionView.showsVerticalScrollIndicator = false
        colorCollectionView.showsHorizontalScrollIndicator = false
        colorCollectionView.alpha = 0.0
        
        if let selectedItem = selection {
            print("count: \(colorList.count)")
            print("selected item: \(selectedItem)")
            colorCollectionView.scrollToItem(at: selectedItem, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        colorCollectionView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.colorCollectionView.alpha = 1.0
        }

        if let selectedItem = selection {
            print("count: \(colorList.count)")
            print("selected item: \(selectedItem)")
            colorCollectionView.scrollToItem(at: selectedItem, at: .centeredHorizontally, animated: false)
        }
    }
}

extension HorizontalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath)
        
        cell.backgroundColor = colorList[indexPath.item]
        
        return cell
    }
}
