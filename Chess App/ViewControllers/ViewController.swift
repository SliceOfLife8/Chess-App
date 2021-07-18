//
//  ViewController.swift
//  Chess App
//
//  Created by Christos Petimezas on 16/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Vars
    var boardCellIdentifier = "BoardCell"
    var numbersCellIdentifier = "NumberCell"
    var boardSize: Int = [6,7,8,9,10,11,12,13,14,15,16].randomElement() ?? 6 // chessboard size based on a range of integers, 6<=N<=16 where N is the size
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    let alphabetChars = (97...122).map({Character(UnicodeScalar($0))})
    var numbers: [Int] = []
    
    var selectedIndexPaths: [IndexPath: Bool] = [:] /// Track selected indexPaths. We need reference to selected cells as we don't have index of them when reuse automatically occrus. Bool refes to starting point.
    var startingPoint: Point?
    var finishingPoint: Point?
    var knightPaths: [[Point]] = []
    var knightPathsDescription: [String] = []
    // Below arrays detail all eight possible movements for a knight.
    var xMove = [2, 1, -1, -2, -2, -1, 1, 2]
    var yMove = [1, 2, 2, 1, -1, -2, -2, -1]
    var knightMoves: [Point] = []
    
    // MARK: - Outlets
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var chessBoardCV: UICollectionView!
    @IBOutlet weak var alphabetCVHeight: NSLayoutConstraint!
    @IBOutlet weak var alphabetCV: UICollectionView!
    @IBOutlet weak var numbersCV: UICollectionView!
    @IBOutlet weak var resetBtn: ContentButton!
    @IBOutlet weak var possiblePaths: ContentButton!
    @IBOutlet weak var currentPathLbl: UILabel!
    
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
    
    ///  Call this method in order to find all possible paths between a starting & an ending point on specific steps.
    ///  Complexity O(n*n*n) where n is the boardSize.
    /// - returns: If we find at least one path or not.
    func findPaths() -> Bool {
        guard let entryPoint = startingPoint, let endPoint = finishingPoint else {
            return false
        }
        knightPaths.removeAll()
        knightPathsDescription.removeAll()
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
                    let positionOfKnight: String = "\(entryPoint.convertPoint(boardSize)) -> \(firstMove.convertPoint(boardSize)) -> \(secondMove.convertPoint(boardSize)) -> \(thirdMove.convertPoint(boardSize))"
                    if endPoint == thirdMove && !knightPaths.contains(path) {
                        status = true
                        knightPaths.append(path)
                        knightPathsDescription.append(positionOfKnight)
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
        knightPathsDescription.removeAll()
        selectedIndexPaths.removeAll()
        chessBoardCV.deselectAllItems(animated: true)
        possiblePaths.isHidden = true
        resetBtn.isEnabled = false
    }
    
    private func startAnimationOfKnight() {
        let indexPaths = transformKnightPathIntoIndexPaths()
        var duration: TimeInterval = 0
        guard let entryPoint = startingPoint else { return }
        
        for(index, item) in indexPaths.enumerated() {
            showCurrentPath(index: index, duration: duration)
            for (item_idx, element) in item.enumerated() {
                self.chessBoardCV.performBatchUpdates({
                    if let myCell = self.chessBoardCV.cellForItem(at: element) as? BoardCell {
                        myCell.knightMoved(duration, entryPoint: item_idx == 0)
                    }
                }, completion: nil)
                
                duration += 1
                /// Only for the last item of every path. Restore knight piece image.
                /// endIndex is the array’s “past the end” position—that is, the position one greater than the last valid subscript argument.
                if item_idx == item.endIndex - 1 {
                    self.chessBoardCV.performBatchUpdates({
                        if let myCell = self.chessBoardCV.cellForItem(at: IndexPath(row: entryPoint.y, section: entryPoint.x)) as? BoardCell {
                            myCell.restoreKnightPosition(duration)
                        }
                    }, completion: nil)
                }
            } /// end inner for-loop
            duration += 1
        } /// end outer for-loop
        
    }
    
    /// #Transform knightPaths into collectionView indexPaths
    private func transformKnightPathIntoIndexPaths() -> [[IndexPath]] {
        var paths: [[IndexPath]] = []
        
        for(_, item) in knightPaths.enumerated() {
            var path: [IndexPath] = []
            for point in item {
                path.append(IndexPath(row: point.y, section: point.x))
            }
            paths.append(path)
        }
        
        return paths
    }
    
    /// #Show label for current path between starting & finishing points
    private func showCurrentPath(index: Int, duration: TimeInterval) {
        let waitAnimation = "\nWait until animation is over!"
        if index == 0 { /// First
            currentPathLbl.isHidden = false
            currentPathLbl.text = "\(knightPathsDescription.first ?? "") \(waitAnimation)"
            if knightPaths.count == 1 { /// Stop animation when knightPaths is exactly one.
                stopAnimation()
            }
        } else if index == knightPathsDescription.count - 1 { /// Last
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
                self.currentPathLbl.text = "\(self.knightPathsDescription.last ?? "") \(waitAnimation)"
                self.stopAnimation()
            })
        } else {
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
                self.currentPathLbl.text = "\(self.knightPathsDescription[index]) \(waitAnimation)"
            })
        }
    }
    
    /// Hide currentPath after 4 seconds & restore interaction with view
    private func stopAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.currentPathLbl.isHidden = true
            self.view.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - Actions
    @IBAction func resetBtnTapped(_ sender: Any) {
        self.restore()
    }
    
    @IBAction func possiblePathsTapped(_ sender: Any) {
        if findPaths() { /// success scenario
            // Present every single path & start animation of knight piece
            self.showSuccessPrompt(completion: { withAnimation in
                if withAnimation {
                    self.view.isUserInteractionEnabled = false /// Disable all actions until animations are over
                    self.startAnimationOfKnight()
                } else {
                    self.showAvailablePaths()
                }
            })
        } else { // Show proper message
            showFailurePrompt()
        }
    }
    
}

// MARK: - UIAlertController helper funcs
extension ViewController {
    private func showFailurePrompt() {
        let alert = UIAlertController(title: nil, message: "No solution has been found for this entry points. Please try again!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
            self.restore()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessPrompt(completion: @escaping ((Bool) ->Void)) {
        let alert = UIAlertController(title: "Available paths found!", message: "Check them with animation or without", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "With", style: .default, handler: { _ in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Without", style: .default, handler: { _ in
            completion(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAvailablePaths() {
        let paths = knightPathsDescription.joined(separator: "\n")
        let alert = UIAlertController(title: "Available paths", message: paths, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
