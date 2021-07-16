//
//  ViewController+UICollectionView.swift
//  Chess App
//
//  Created by Christos Petimezas on 16/7/21.
//

import UIKit

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setupCollectionView() {
        let itemSize = estimateSizeOfCells()
        let flowLayout = chessBoardCV.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: itemSize.width, height: itemSize.height)
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0
        
        chessBoardCV.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        chessBoardCV.allowsMultipleSelection = true
        chessBoardCV.backgroundColor = .clear
        chessBoardCV.delegate = self
        chessBoardCV.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfElementsInRow*numberOfElementsInRow
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BoardCell
        
        let value = findCellFormat(indexPath.row)
        cell.setupCell(with: value)
        
        return cell
    }
    
    func findCellFormat(_ index: Int) -> BoardColorValues {
        var value: BoardColorValues
        
        let chessRow = index / numberOfElementsInRow
        if chessRow % 2 == 0 {
            if index % 2 == 0 {
                value = .light
            }else{
                value = .dark
            }
        } else{
            if index % 2 == 0 {
                value = .dark
            }else{
                value = .light
            }
        }
        
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let cell = collectionView.cellForItem(at: indexPath) as? BoardCell {
            if selectedIndexPaths.count.oneOf(other: 0, 1) {
                cell.addOverlayView((selectedIndexPaths.count == 0) ? .green : .red)
                selectedIndexPaths[indexPath] = selectedIndexPaths.count == 0
                if selectedIndexPaths.count == 2 {
                    possiblePaths.isHidden = false
                }
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
            
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                if selectedIndexPaths[indexPath] == true {
                    collectionView.deselectAllItems(animated: true)
                    selectedIndexPaths.removeAll()
                } else {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    selectedIndexPaths.removeValue(forKey: indexPath)
                }
                possiblePaths.isHidden = true
                
                return false
            }
        }
        return true
    }
    
    
    /// #Explicit formula for sequence 7,15,23... Currently not used!
    fileprivate func arithmeticSequence(_ candidate: Int) -> Bool {
        let firstMember = 7
        let numOfMembers = 1...8
        let difference = 8
        
        for i in numOfMembers {
            let a = firstMember + (i - 1) * difference
            if candidate == a {
                return true
            }
        }
        
        return false
    }
    
}


extension Equatable {
    func oneOf(other: Self...) -> Bool {
        return other.contains(self)
    }
}

extension UICollectionView {
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}
