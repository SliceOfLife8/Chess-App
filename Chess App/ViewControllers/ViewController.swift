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
    internal lazy var boardSize = 6
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    var selectedIndexPaths: [IndexPath: Bool] = [:] /// Track selected indexPaths. We need reference to selected cells as we don't have index of them when reuse automatically occrus. Bool refes to starting point.
    var startingPoint: Point?
    var finishingPoint: Point?
    var knightPaths: [[Point]] = []
    // Below arrays detail all eight possible movements for a knight.
    var xMove = [2, 1, -1, -2, -2, -1, 1, 2]
    var yMove = [1, 2, 2, 1, -1, -2, -2, -1]
    var knightMoves: [Point] = []
    
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
        setupViews()
        setupCollectionView()
        initializeMoves()
    }
    
    private func setupViews() {
        resetBtn.isEnabled = false
        possiblePaths.isEnabled = true
        resetBtn.setTitle("Reset chessboard", for: .normal)
        possiblePaths.setTitle("Find possible paths", for: .normal)
    }
    
    private func initializeMoves() {
        for i in 0..<xMove.count {
            knightMoves.append(Point(x: xMove[i], y: yMove[i]))
        }
    }
    
    ///  Call this method in order to find all possible paths between a starting & an ending point on specific steps
    /// - returns: If we find at least one path or not.
    @discardableResult
    func findPaths() -> Bool {
        guard let entryPoint = startingPoint, let endPoint = finishingPoint else {
            return false
        }
        /// Initialize all knight fixed steps
        var firstMove: Point = entryPoint
        var secondMove: Point = Point(x: 0, y: 0)
        var thirdMove: Point = Point(x: 0, y: 0)
        var status = false
        /// We iterate through all possible moves & set firstMove as new Point with 8 possible values.
        for first_step in knightMoves {
            /// Find firstMove & check the validation of it
            firstMove = nextMove(current: entryPoint, move: first_step)
            guard firstMove.isValid(boardSize) else { continue }
            /// Repeat the same process for second step but now secondMove has currentStep the previous one -- firstMove
            for second_step in knightMoves {
                secondMove = nextMove(current: firstMove, move: second_step)
                guard secondMove.isValid(boardSize) else { continue }
                /// Repeat the same process for third step but now thirdMove has currentStep the previous one -- secondMove
                for third_step in knightMoves {
                    thirdMove = nextMove(current: secondMove, move: third_step)
                    guard thirdMove.isValid(boardSize) else { continue }
                    /// Now we are ready to check the equality between `finishingPoint` & `thirdMove` aka lastMove
                    let path: [Point] = [entryPoint, firstMove, secondMove, thirdMove]
                    if endPoint == thirdMove && !knightPaths.contains(path) {
                        status = true
                        knightPaths.append(path)
                        print("path: \(path)")
                    }
                }
            }
        }
        
        return status
    }
    
    /// - parameter current: The current position of knight in chessboard.
    /// - parameter move: The movement of knight according to possible moves aka 'knightMoves'
    /// - returns `Point`:  Returns the new Point
    private func nextMove(current: Point, move: Point) -> Point {
        return Point(x: current.x + move.x, y: current.y + move.y)
    }
    
    func restore() {
        startingPoint = nil
        finishingPoint = nil
        knightPaths.removeAll()
        selectedIndexPaths.removeAll()
        chessBoardCV.deselectAllItems(animated: true)
        possiblePaths.isHidden = true
        resetBtn.isEnabled = false
    }
    
    // MARK: - Actions
    @IBAction func resetBtnTapped(_ sender: Any) {
        self.restore()
    }
    
    @IBAction func possiblePathsTapped(_ sender: Any) {
        self.findPaths()
    }
    
}
