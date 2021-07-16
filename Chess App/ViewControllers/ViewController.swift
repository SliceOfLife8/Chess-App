//
//  ViewController.swift
//  Chess App
//
//  Created by Christos Petimezas on 16/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Vars
    internal lazy var cellIdentifier = "BoardCell"
    internal lazy var numberOfElementsInRow = 6
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    var selectedIndexPaths: [IndexPath: Bool] = [:] /// Track selected indexPaths. We need reference to selected cells as we don't have index of them when reuse automatically occrus. Bool refes to starting point.
    
    // MARK: - Outlets
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var chessBoardCV: UICollectionView!
    @IBOutlet weak var resetBtn: ContentButton!
    @IBOutlet weak var possiblePaths: ContentButton!
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .white
        setupViews()
        setupCollectionView()
    }
    
    private func setupViews() {
        resetBtn.isEnabled = false
        possiblePaths.isEnabled = true
        resetBtn.setTitle("Reset chessboard", for: .normal)
        resetBtn.setTitle("Find possible paths", for: .normal)
    }
    
    /// #Estimate size of cells depending on default paddings
    internal func estimateSizeOfCells() -> CGSize {
        let _numberOfElementsInRow = CGFloat(numberOfElementsInRow)
        let standardPaddings: CGFloat = 8 * 2 // 16 -> leading & trailing
        let remainingWidth = screenWidth - standardPaddings
        let itemSize = CGSize(width: remainingWidth / _numberOfElementsInRow, height: remainingWidth / _numberOfElementsInRow)
        
        return itemSize
    }
    
    
    // MARK: - Actions
    @IBAction func resetBtnTapped(_ sender: Any) {
        print("reset !!!")
    }
    
    @IBAction func possiblePathsTapped(_ sender: Any) {
        print("find paths")
    }
    
}
