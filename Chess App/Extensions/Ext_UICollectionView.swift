//
//  Ext_UICollectionView.swift
//  Chess App
//
//  Created by Christos Petimezas on 17/7/21.
//

import UIKit

extension UICollectionView {
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}
