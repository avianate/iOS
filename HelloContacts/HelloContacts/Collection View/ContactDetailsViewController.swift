//
//  ContactDetailsViewController.swift
//  HelloContacts
//
//  Created by Nate Graham on 8/30/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    
    var compactWidthConstraint: NSLayoutConstraint!
    var compactHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        let views: [String: Any] = ["contactImage": contactImage, "contatNameLabel": contactNameLabel]
        var allConstraints = [NSLayoutConstraint]()
        
        compactWidthConstraint = contactImage.widthAnchor.constraint(equalToConstant: 60)
        compactHeightConstraint = contactImage.heightAnchor.constraint(equalToConstant: 60)
        
        let verticalPositioningConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[contactImage]-[contactNameLabel]", options: [NSLayoutFormatOptions.alignAllCenterX], metrics: nil, views: views)
        
        allConstraints += verticalPositioningConstraints
        let centerXConstraint = contactImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        allConstraints.append(centerXConstraint)
        allConstraints.append(compactWidthConstraint)
        allConstraints.append(compactHeightConstraint) NSLayoutConstraint.activate(allConstraints)
        
        
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
