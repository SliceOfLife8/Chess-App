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
    
    var color: UIColor {
        switch self {
        case .dark:
            return UIColor(hexString: "#966F33")
        case .light:
            return UIColor(hexString: "#dec5a0")
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
        chessIcon.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        value = nil
        chessIcon.alpha = 0
    }
    
    func setupCell(with value: BoardColorValues) {
        self.value = value
        containerView.backgroundColor = value.color
    }
    
    func addOverlayView(_ color: UIColor = .green, knightAppeared: Bool = false) {
        overlayView.backgroundColor = color.withAlphaComponent(0.3)
        overlayView.frame = self.bounds
        self.addSubview(overlayView)
        if knightAppeared {
            chessIcon.alpha = 1
        }
    }
    
    private func removeOverlay() {
        chessIcon.fadeOut()
        self.subviews.forEach { subview in
            if subview.tag == 8 {
                subview.removeFromSuperview()
            }
        }
    }
    
    /// - For multiple animations I use Timer scheduler because DispatchQueue asyncAfter is inaccurate for multiple uses.
    func knightMoved(_ duration: TimeInterval, entryPoint: Bool = false) {
        if entryPoint {
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
                self.chessIcon.fadeOut()
            })
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
            self.chessIcon.fadeIn(duration: 1, delay: 0) { _ in
                self.chessIcon.fadeOut()
            }
        })
    }
    
    func restoreKnightPosition(_ duration: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
            self.chessIcon.fadeIn()
        })
    }
    
}
