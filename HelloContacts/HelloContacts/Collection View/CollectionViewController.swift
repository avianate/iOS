//
//  CollectionViewController.swift
//  HelloContacts
//
//  Created by Nate Graham on 8/14/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit
import Contacts

class CollectionViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var contacts = [HCContact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = ContactsCollectionViewLayout()
        
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        if authorizationStatus == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { [weak self] authorized, error in
                if authorized {
                    self?.retrieveContacts(fromStore: store)
                }
            })
        } else if authorizationStatus == .authorized {
            retrieveContacts(fromStore: store)
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.receivedLongPress(gestureRecognizer:)))
        collectionView.addGestureRecognizer(longPressRecognizer)
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    @objc func receivedLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let tappedPoint = gestureRecognizer.location(in: collectionView)
        
        guard let tappedIndexPath = collectionView.indexPathForItem(at: tappedPoint), let tappedCell = collectionView.cellForItem(at: tappedIndexPath) else { return }
        
        if isEditing {
            reorderContact(withCell: tappedCell, atIndexPath: tappedIndexPath, gesture: gestureRecognizer)
        } else {
            deleteContact(withCell: tappedCell, atIndexPath: tappedIndexPath)
        }
        
        
    }
    
    func reorderContact(withCell cell: UICollectionViewCell, atIndexPath indexPath: IndexPath, gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: indexPath)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: nil)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func deleteContact(withCell cell: UICollectionViewCell, atIndexPath indexPath: IndexPath) {
        
        guard let tappedCell = collectionView.cellForItem(at: indexPath) else { return }
        
        let confirmDialog = UIAlertController(title: "Delete this contact?", message: "Are you sure you want tot delete this contact?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.contacts.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
        })
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        confirmDialog.addAction(deleteAction)
        confirmDialog.addAction(cancelAction)
        
        if let popOver = confirmDialog.popoverPresentationController {
            popOver.sourceView = tappedCell
            
            if let cell = tappedCell as? ContactCollectionViewCell {
                let imageFrame = cell.contactImage.frame
                
                let popOverX = imageFrame.origin.x + imageFrame.size.width / 2
                let popOverY = imageFrame.origin.y + imageFrame.size.height / 2
                
                popOver.sourceRect = CGRect(x: popOverX, y: popOverY, width: 0, height: 0)
            }
        }
        
        present(confirmDialog, animated: true, completion: nil)
    }
    
    func retrieveContacts(fromStore store: CNContactStore) {
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                           CNContactFamilyNameKey as CNKeyDescriptor,
                           CNContactImageDataKey as CNKeyDescriptor,
                           CNContactImageDataAvailableKey as CNKeyDescriptor]
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).map { contact in
            return HCContact(contact: contact)
        }
        
        collectionView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        for visibleCell in collectionView.visibleCells {
            guard let cell = visibleCell as? ContactCollectionViewCell else { continue }
            
            if editing {
                UIView.animate(withDuration: 0.07, delay: 0, options: [.curveEaseOut], animations: {
                    cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                    cell.backgroundColor = UIColor.clear
                }, completion: nil)
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedContact = contacts.remove(at: sourceIndexPath.row)
        contacts.insert(movedContact, at: destinationIndexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCollectionViewCell
        let contact = contacts[indexPath.row]
        
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        contact.fetchImageIfNeeded()
        
        if let image = contact.contactImage {
            cell.contactImage.image = image
        }
        
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        guard let cell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            cell.contactImage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finished) in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
                cell.contactImage.transform = .identity
            }, completion: { finished in
                self.performSegue(withIdentifier: "detailViewSegue", sender: self)
        })
        }
    }
}