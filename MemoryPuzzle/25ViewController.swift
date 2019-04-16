//
//  25ViewController.swift
//  MemoryPuzzle
//
//  Created by Taiga Hashimoto on 2019/02/27.
//  Copyright © 2019 Geeksalon. All rights reserved.
//

import UIKit
import PuzzleMaker
import BottomPopup

class _5ViewController: UIViewController {
    
    // 変数の初期化
    var correctCount = 0
    var answerAreaAray:[UIView] = []
    var tapCount = 0
    
    let baseImg = UIImageView()
    let beforeImg = UIImageView()
    
    var height: CGFloat = 300
    var topCornerRadius: CGFloat = 35
    var presentDuration: Double = 1.5
    var dismissDuration: Double = 1.5
    
    // プレビューボタン
    @IBOutlet weak var preView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // appDelegateからテーマカラーの受け渡し
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let selectedColor = appDelegate.selectedColor
        self.view.backgroundColor = selectedColor
        
        // baseImgを表示
        self.view.addSubview(baseImg)
        self.view.sendSubviewToBack(baseImg)
        
        // baseImgのオートレイアウト
        baseImg.translatesAutoresizingMaskIntoConstraints = false
        //縦軸が一致
        baseImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //幅が0.8倍
        baseImg.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        //高さが幅と同じ
        baseImg.heightAnchor.constraint(equalTo: baseImg.widthAnchor, multiplier: 1.0).isActive = true
        //横軸が中心から100px
        baseImg.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive  = true
        
        // baseImgの背景色
        baseImg.backgroundColor = UIColor.lightGray
        // baseImgの枠線
        baseImg.layer.borderWidth = 0.5
        baseImg.layer.borderColor = UIColor.black.cgColor
        
        // beforeImgのレイアウト
        self.view.addSubview(beforeImg)
        // 最背面に表示
        self.view.sendSubviewToBack(beforeImg)
        // beforeImgの無効化
        beforeImg.alpha = 0.0
        beforeImg.backgroundColor = UIColor.white
        
        // beforeImgのオートレイアウト
        beforeImg.translatesAutoresizingMaskIntoConstraints = false
        //topが一致
        beforeImg.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        //leftが一致
        beforeImg.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        //幅が0.8倍
        beforeImg.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        //高さが幅と同じ
        beforeImg.heightAnchor.constraint(equalTo: beforeImg.widthAnchor, multiplier: 1.0).isActive = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        // ピース数の設定
        let numColumns = 5
        let numRows = 5
        
        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height
        
        // appDelegateから選択された写真の受け渡し
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let selectedImage = appDelegate.selectedImage
        var image = selectedImage
        
        //ピースの数(1~25)を入れる配列
        var pieceAray:[Int] = []
        
        for i in 0...numColumns*numRows {
            pieceAray.append(i+1)
        }
        
        // Resize image for given device.
        UIGraphicsBeginImageContextWithOptions(CGSize(width: baseImg.frame.width, height: baseImg.frame.width), _: false, _: 0.0)
        image!.draw(in: CGRect(x: 0, y: 0, width: baseImg.frame.width, height: baseImg.frame.width))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Make puzzle.
        let puzzleMaker = PuzzleMaker(image: image!, numRows: numRows, numColumns: numColumns)
        puzzleMaker.generatePuzzles { (throwableClosure) in
            do {
                let puzzleElements = try throwableClosure()
                for row in 0 ..< numRows {
                    for column in 0 ..< numColumns {
                        
                        let index = Int(row*numColumns+column)
                        let num = pieceAray[index]
                        
                        let puzzleElement = puzzleElements[row][column]
                        let position = puzzleElement.position
                        let image = puzzleElement.image
                        let pieces = UIImageView(frame: CGRect(x: position.x, y: position.y, width: image.size.width, height: image.size.height))
                        pieces.image = image
                        pieces.tag = num
                        self.view.addSubview(pieces)
                        
                        // answerViewの移動量を求める
                        let movePointx:CGFloat = self.baseImg.center.x - self.beforeImg.center.x
                        let movePointy:CGFloat = self.baseImg.center.y - self.beforeImg.center.y
                        
                        //正解エリアを作っておく
                        let answerArea = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.053, height: self.view.frame.width*0.053))
                        answerArea.center = CGPoint(x: pieces.center.x + movePointx, y: pieces.center.y + movePointy)
                        answerArea.backgroundColor = UIColor.clear
                        self.answerAreaAray.append(answerArea)
                        self.view.addSubview(answerArea)
                        
                        //ピースをばら撒いた状態にする
                        let yoko = Int(arc4random_uniform(UInt32(screenWidth*0.7)))
                        let tate = Int(arc4random_uniform(UInt32(screenHeight))/3)
                        
                        var point:CGPoint = pieces.center
                        point.x = CGFloat(yoko)
                        point.y = CGFloat(tate)
                        pieces.center = CGPoint(x: point.x + screenWidth*0.15, y: point.y + screenHeight*0.5)
                        
                        //UIPanGestureRecognizerを使用
                        let movePieces:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.dragPieces))
                        pieces.addGestureRecognizer(movePieces)
                        pieces.isUserInteractionEnabled = true
                        
                    }
                }
                
            } catch let error {
                debugPrint(error)
            }
        }
    }
    
    // ピースを移動させる関数
    @objc func dragPieces(sender:UIPanGestureRecognizer) {
       self.view.bringSubviewToFront(sender.view!)
        
        // ピースをドラッグし終わったら
        if sender.state == UIGestureRecognizer.State.ended {
            let targetImg:UIView = sender.view!
            
            // 正解判定
            for _ in 0..<answerAreaAray.count {
                
                let answerView = answerAreaAray[targetImg.tag-1]
                
                if (answerView.frame.contains(targetImg.center)) {
                    
                    //正解座標に移動
                    targetImg.center = CGPoint(x: answerView.center.x, y: answerView.center.y)
                    //正解後は動かないようにする
                    targetImg.isUserInteractionEnabled = false
                    //正解数をカウント
                    correctCount += 1
                    //全ピース正解したら
                    if correctCount == 25 {
                        
                        print("Congratulations!")
                        
                        // 画面遷移
                        let modalViewController = ModalViewController()
                        modalViewController.modalPresentationStyle = .custom
                        modalViewController.transitioningDelegate = self  
                        present(modalViewController, animated: true, completion: nil)
                        
                        // シェア写真のインスタンス
                        let capturedImage: UIImage!
                        let trimImage: UIImage!
                        capturedImage = getScreenShot()
                        
                        // トリミングする範囲
                        trimImage = trimmingImage(capturedImage!, trimmingArea: CGRect(x: baseImg.frame.origin.x*2, y: baseImg.frame.origin.y*2, width: beforeImg.frame.width*2, height: beforeImg.frame.height*2))
                        
                        // appDelegateのインスタンスを取得
                        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        // appDelegateのshareImageを操作
                        appDelegate.shareImage = trimImage
                        
                    } else {
                       
                        break
                    }
                    
                }
                
            }
            
        } else {
            
            let point: CGPoint = sender.translation(in: self.view)
            let movedPoint: CGPoint = CGPoint(x: sender.view!.center.x + point.x, y: sender.view!.center.y + point.y)
            sender.view!.center = movedPoint
            sender.setTranslation(CGPoint.zero, in: self.view)
            
        }
        
    }
    
    // スクショする関数
    private func getScreenShot() -> UIImage {
        let rect = self.view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.view.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
    // トリミングする関数
    func trimmingImage(_ image: UIImage, trimmingArea: CGRect) -> UIImage {
        let imgRef = image.cgImage?.cropping(to: trimmingArea)
        let trimImage = UIImage(cgImage: imgRef!, scale: image.scale, orientation: image.imageOrientation)
        
        return trimImage
    }
    
    // プレビューを表示する関数
    @IBAction func preViewButton(_ sender: Any) {
        
        tapCount += 1
        
        if tapCount == 1 {
            
            // appDelegateから選択された写真の受け渡し
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let selectedImage = appDelegate.selectedImage
            
            // 半透明で表示
            preView.image = selectedImage
            preView.alpha = 0.5
            
        } else {
            
            preView.image = nil
            tapCount = 0
            
        }
        
    }

 }

extension _5ViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
        
    }
    
}
