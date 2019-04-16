//
//  ModalViewController.swift
//  MemoryPuzzle
//
//  Created by Taiga Hashimoto on 2019/02/27.
//  Copyright © 2019 Geeksalon. All rights reserved.
//

import UIKit
import Accounts
import LINEActivity
import SAConfettiView


class ModalViewController: UIViewController {

    var confettiView: SAConfettiView!
    // シェアする関数
    @objc func share(_ sender: UIButton) {
        
        // appDelegateからパズル写真の受け渡し
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let shareImage = appDelegate.shareImage
 
        // シェアするデータ
        let activityItems = [shareImage]
        
        // シェア先にLINEを追加
        let LineKit = LINEActivity()
        let myApplicationActivities = [LineKit]
        let activityVC = UIActivityViewController(activityItems: activityItems as [Any], applicationActivities: myApplicationActivities)
        
        // 使用しないアクティビティタイプを取り除く
        let excludedActivityTypes = [UIActivity.ActivityType.message, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.print, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.mail]
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    // 最初の画面に戻る関数
    @objc func home(_ sender: UIButton) {
        
        // 4つ前のviewControllerに遷移
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    // カメラロールに保存する関数
    @objc func saveImage(_ sender: UIButton) {
        
        // appDelegateからパズル写真の受け渡し
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let shareImage = appDelegate.shareImage
        let image = shareImage
        
       // UIImage の画像をカメラロールに画像を保存
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {
        
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create confetti view
        confettiView = SAConfettiView(frame: self.view.bounds)
        
        // Add subview
        view.addSubview(confettiView)
        confettiView.startConfetti()

        // appDelegateからテーマカラーを受け渡し
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let selectedColor = appDelegate.selectedColor
        
        self.view.backgroundColor = selectedColor
        
        // ラベルの表示
        let label = UILabel()
        label.text = "おめでとう！"
        label.font = UIFont(name: "Tanuki-Permanent-Marker", size: 30)
        label.textAlignment = NSTextAlignment.center
        label.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.shadowColor = UIColor.lightGray
        self.view.addSubview(label)
        
        // トロフィーアイコンの表示
        let winImageView = UIImageView()
        winImageView.image = UIImage(named: "win.png")
        self.view.addSubview(winImageView)
        
        // ボタンのインスタンス生成
        let shareButton = CustomButton()
        let homeButton = CustomButton()
        let saveButton = CustomButton()
        // ボタンの背景色
        shareButton.backgroundColor = UIColor.init(
            red:0, green: 0, blue: 0, alpha: 0)
        homeButton.backgroundColor = UIColor.init(
            red:0, green: 0, blue: 0, alpha: 0)
        saveButton.backgroundColor = UIColor.init(
            red:0, green: 0, blue: 0, alpha: 0)
        // タップされたときのaction
        shareButton.addTarget(self,
                         action: #selector(share),
                         for: .touchUpInside)
        homeButton.addTarget(self,
                              action: #selector(home),
                              for: .touchUpInside)
        saveButton.addTarget(self,
                             action: #selector(saveImage),
                             for: .touchUpInside)
        // ボタンに画像を貼る
        shareButton.setImage(UIImage(named: "share.png"), for: .normal)
        homeButton.setImage(UIImage(named: "back.png"), for: .normal)
        saveButton.setImage(UIImage(named: "save.png"), for: .normal)
        
        // Viewにボタンを追加
        self.view.addSubview(shareButton)
        self.view.addSubview(homeButton)
        self.view.addSubview(saveButton)
        
        // オートレイアウト準備
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        winImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // ボタンのオートレイアウト
        // shareButton
        // 横軸の位置
        shareButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height/6).isActive = true
        // 幅の倍率
        shareButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        // 正方形
        shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor, multiplier: 1.0).isActive = true
        // 縦軸の位置
        shareButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -self.view.frame.width*0.3).isActive = true
        
        // homeButton
        homeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height/6).isActive = true
        homeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        homeButton.heightAnchor.constraint(equalTo: homeButton.widthAnchor, multiplier: 1.0).isActive = true
        homeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width*0.3).isActive = true
        
        // saveButton
        saveButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height/6).isActive = true
        saveButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 1.0).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        // アイコンのオートレイアウト
        winImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height*0.1).isActive = true
        winImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        winImageView.heightAnchor.constraint(equalTo: winImageView.widthAnchor, multiplier: 1.0).isActive = true
        winImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
 
        // ラベルのオートレイアウト
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height*0.07).isActive = true
        label.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        label.heightAnchor.constraint(equalTo: label.widthAnchor, multiplier: 0.3).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width*0.05).isActive = true
 
    }

}
