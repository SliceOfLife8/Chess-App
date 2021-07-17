//
//  BoardCell.swift
//  Chess App
//
//  Created by Christos Petimezas on 16/7/21.
//

import UIKit

enum BoardColorValues {
    case dark
    case light
    case white
    
    var color: UIColor {
        switch self {
        case .dark:
            return UIColor(hexString: "#966F33")
        case .light:
            return UIColor(hexString: "#dec5a0")
        case .white:
            return .purple
        }
    }
}

class BoardCell: UICollectionViewCell {
    
    var value: BoardColorValues?
    
    var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.tag = 8
        return overlayView
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chessIcon: UIImageView!
    
    override public var isSelected: Bool {
        didSet {
            if !isSelected {
                removeOverlay()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        value = nil
        chessIcon.image = nil
    }
    
    func setupCell(with value: BoardColorValues) {
        self.value = value
        containerView.backgroundColor = value.color
    }
    
    func addOverlayView(_ color: UIColor, knightAppeared: Bool = false) {
        overlayView.backgroundColor = color.withAlphaComponent(0.3)
        overlayView.frame = self.bounds
        self.addSubview(overlayView)
        if knightAppeared {
            chessIcon.image = UIImage(named: "chess")
        }
    }
    
    private func removeOverlay() {
        chessIcon.image = nil
        self.subviews.forEach { subview in
            if subview.tag == 8 {
                subview.removeFromSuperview()
            }
        }
    }
    
}
