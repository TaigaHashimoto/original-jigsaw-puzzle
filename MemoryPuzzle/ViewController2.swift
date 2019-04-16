//
//  ViewController2.swift
//  MemoryPuzzle
//
//  Created by Taiga Hashimoto on 2019/02/26.
//  Copyright © 2019 Geeksalon. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()

        //デフォルトの写真を設定
        imageView.image = UIImage(named: "default.png")

        // 最背面に表示
        self.view.sendSubviewToBack(backGroundView)
        
        // appDelegateからテーマカラーの受け渡し
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let selectedColor = appDelegate.selectedColor
        
        // 背景色
        self.view.backgroundColor = selectedColor
        
        // 画像の枠線の変更
        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.borderWidth = 3

    }

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var backGroundView: UIView!
    
    // カメラロールから写真を選択
    @IBAction func ChoosePicture(_ sender: UIButton) {
  
        //カメラロールが利用可能かどうか
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //写真を選ぶ
            let pickerView = UIImagePickerController()
            //写真の選択元をカメラロールにする
            pickerView.sourceType = .photoLibrary
            //デリゲート
            pickerView.delegate = self
            //トリミング
            pickerView.allowsEditing = true
            //ビューに表示
            self.present(pickerView, animated: true)

        }
        
    }
    
    //写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //選択した写真を取得する
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        //ビューに表示する
        self.imageView.image = selectedImage
        
        // appDelegateのインスタンスを取得
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        // appDelegateの変数を操作
        appDelegate.selectedImage = selectedImage
        
        //写真を選ぶビューを引っ込める
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // 画像決定時の処理
    @IBAction func finishPicture(_ sender: Any) {
        
        if imageView.image == UIImage(named: "default.png") {
            
            // アラートを表示
            let alert = UIAlertController(title: "確認", message: "画像を選択してください", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          
            // アラートにボタン追加
            alert.addAction(okButton)
            
            // アラート表示
            present(alert, animated: true, completion: nil)
            
        } else {
            
            // 画面遷移
            self.performSegue(withIdentifier: "toViewController3", sender: nil)
            
        }
 
    }
   
    @IBAction func backToTop(_ sender: CustomButton) {
        // 1つ前のviewControllerに遷移
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
