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
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.itemSize = CGSize(width: itemSize.width, height: itemSize.height)
        
        chessBoardCV.register(UINib(nibName: boardCellIdentifier, bundle: nil), forCellWithReuseIdentifier: boardCellIdentifier)
        chessBoardCV.allowsMultipleSelection = true
        chessBoardCV.backgroundColor = .clear
        chessBoardCV.delegate = self
        chessBoardCV.dataSource = self
        /// Alphabet CV
        alphabetCV.register(NumberCell.self, forCellWithReuseIdentifier: numbersCellIdentifier)
        (alphabetCV.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: itemSize.width, height: itemSize.height)
        alphabetCVHeight.constant = itemSize.height + 1
         /// Fix warning by making collectionView height greater than cells: The behavior of the UICollectionViewFlowLayout is not defined because the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values.
        alphabetCV.delegate = self
        alphabetCV.dataSource = self
        /// Numbers CV
        numbersCV.register(NumberCell.self, forCellWithReuseIdentifier: numbersCellIdentifier)
        (numbersCV.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: 30, height: itemSize.height)
        numbersCV.delegate = self
        numbersCV.dataSource = self
        numbers = Array(1...boardSize).sorted { $0 > $1 }
    }
    
    /// #Estimate size of cells depending on default paddings
    private func estimateSizeOfCells() -> CGSize {
        let numberOfElementsInRow = CGFloat(boardSize)
        let standardPaddings: CGFloat = 8 + 30 // 8 -> trailing, 30 -> numbersCV width
        let remainingWidth = screenWidth - standardPaddings
        let itemSize = CGSize(width: remainingWidth / numberOfElementsInRow, height: remainingWidth / numberOfElementsInRow)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardSize
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == chessBoardCV {
            return boardSize
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == chessBoardCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: boardCellIdentifier, for: indexPath) as! BoardCell
            let value = findCellFormat(indexPath.row + indexPath.section)
            cell.setupCell(with: value)
            
            return cell
        } else if collectionView == alphabetCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: numbersCellIdentifier, for: indexPath) as! NumberCell
            cell.setupCell(alphabetChars[indexPath.row].uppercased())
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: numbersCellIdentifier, for: indexPath) as! NumberCell
            let num = (indexPath.row < numbers.count) ? String(numbers[indexPath.row]) : ""
            cell.setupCell(num)
            
            return cell
        }
    }
    
    func findCellFormat(_ index: Int) -> BoardColorValues {
        var value: BoardColorValues
        value = (index.isMultiple(of: 2) ? .light : .dark)
        
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let cell = collectionView.cellForItem(at: indexPath) as? BoardCell {
            let isFirst = selectedIndexPaths.count == 0
            if selectedIndexPaths.count.oneOf(other: 0, 1) {
                cell.addOverlayView(isFirst ? .green : .red, knightAppeared: isFirst)
                selectedIndexPaths[indexPath] = isFirst
                if selectedIndexPaths.count == 2 {
                    possiblePaths.isHidden = false
                    resetBtn.isEnabled = true
                }
                /// Add points
                /// #Important: We need reference to chessBoard coordinate system as (x,y) of cells. For example cell -> (row: 2, section: 3) is actually (x: 3, y: 2) of coordinate system.
                if isFirst {
                    startingPoint = Point(x: indexPath.section, y: indexPath.row)
                } else {
                    finishingPoint = Point(x: indexPath.section, y: indexPath.row)
                }
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
            
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if selectedIndexPaths.keys.contains(indexPath) {
            if selectedIndexPaths[indexPath] == true {
                collectionView.deselectAllItems(animated: true)
                selectedIndexPaths.removeAll()
                restore()
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
                selectedIndexPaths.removeValue(forKey: indexPath)
                finishingPoint = nil
            }
            possiblePaths.isHidden = true
            resetBtn.isEnabled = false
            
            return false
        }
        return true
    }
    
}


extension Equatable {
    func oneOf(other: Self...) -> Bool {
        return other.contains(self)
    }
}
