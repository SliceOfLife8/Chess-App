//
//  NumberCell.swift
//  Chess App
//
//  Created by Christos Petimezas on 18/7/21.
//

import UIKit

public class NumberCell: UICollectionViewCell {
    
    weak public var number: UILabel?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
        let numberLbl = UILabel(frame: .zero)
        numberLbl.textColor = .black
        numberLbl.font = UIFont.boldSystemFont(ofSize: 18)
        numberLbl.textAlignment = .center
        numberLbl.addExclusiveConstraints(superview: contentView, top: (contentView.topAnchor, 0), bottom: (contentView.bottomAnchor, 0), left: (contentView.leadingAnchor, 0), right: (contentView.trailingAnchor, 0))
        self.number = numberLbl
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell(_ text: String) {
        self.number?.text = text
    }
    
}
