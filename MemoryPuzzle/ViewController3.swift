//
//  ViewController3.swift
//  MemoryPuzzle
//
//  Created by Taiga Hashimoto on 2019/02/26.
//  Copyright © 2019 Geeksalon. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    
    // インスタンス
    let pieceNumberArray = ["9", "16", "25"]
    var currentValue: String = ""
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var pieceNumberLabel: UILabel!
    @IBOutlet weak var pieceLabel: UILabel!
    
    // スライダーの処理
    @IBAction func pieceSlider(_ sender: UISlider) {
        
        slider.value = roundf(slider.value)
        currentValue = pieceNumberArray[Int(sender.value)]
        pieceNumberLabel.text = "\(currentValue)"
        
        // appDelegateのインスタンスを取得
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        // appDelegateのcurrentValueを操作
        appDelegate.currentValue = currentValue
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // appDelegateからテーマカラーの受け渡し
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let selectedColor = appDelegate.selectedColor
        self.view.backgroundColor = selectedColor

        // appDelegateから選択された写真の受け渡し
        let selectedImage = appDelegate.selectedImage
        backGroundImage.image = selectedImage
        
        // 画像の枠線の変更
        self.backGroundImage.layer.borderColor = UIColor.black.cgColor
        self.backGroundImage.layer.borderWidth = 3
        
        // sliderの初期値
        currentValue = pieceNumberArray[1]

        // appDelegateのcurrentValueを操作
        appDelegate.currentValue = currentValue
        
    }
    
    // スタートボタンの処理
    @IBAction func gameStart(_ sender: Any) {
     
        // appDelegateからスライダーの値の受け渡し
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentValue = appDelegate.currentValue
        
        // ピース数での分岐遷移
        if currentValue == pieceNumberArray[0] {
            self.performSegue(withIdentifier: "toNine", sender: nil)
        }
        if currentValue == pieceNumberArray[1] {
            self.performSegue(withIdentifier: "toFour", sender: nil)
        }
        if currentValue == pieceNumberArray[2] {
            self.performSegue(withIdentifier: "toTwentyFive", sender: nil)
        } else {
            self.performSegue(withIdentifier: "toFour", sender: nil)
        }
        
    }
    
}
