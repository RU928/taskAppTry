//
//  GameScene.swift
//  taskappTry
//
//  Created by 田村崚 on 2017/04/30.
//  Copyright © 2017年 ryo.tamura. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var scrollNode: SKNode!
    var wallNode: SKNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(colorLiteralRed: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        
        scrollNode = SKNode()
        addChild(scrollNode)
        
        wallNode = SKNode()
        scrollNode.addChild(wallNode)
        
        setupGround()
        setupCloud()
        setupWall()
    }
    
    func setupGround(){
        let groundTexture = SKTexture(imageNamed: "ground")
        groundTexture.filteringMode = SKTextureFilteringMode.nearest
        
        let needNumber = 2.0 + (frame.size.width / groundTexture.size().width)
        
        let moveGround = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 4.0)
        let backGround = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0.0)
        
        let repeatScroll = SKAction.repeatForever(SKAction.sequence([moveGround, backGround]))
        
        stride(from: 0.0, to: needNumber, by: 1.0).forEach{ i in
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.position = CGPoint(x: i * sprite.size.width, y: groundTexture.size().height / 2 )
            sprite.run(repeatScroll)
            
            scrollNode.addChild(sprite)
        }
    }
    
    
    func setupCloud() {
        let cloudTexture = SKTexture(imageNamed: "cloud")
        cloudTexture.filteringMode = SKTextureFilteringMode.nearest
        
        let needNumver = 2.0 + (frame.size.width / cloudTexture.size().width)
        
        let moveCloud = SKAction.moveBy(x: -cloudTexture.size().width, y: 0, duration: 20.0)
        let backCloud = SKAction.moveBy(x: cloudTexture.size().width, y: 0, duration: 0.0)
        
        let repeatScroll = SKAction.repeatForever(SKAction.sequence([moveCloud, backCloud]))
        
        stride(from: 0.0, to: needNumver, by: 1.0).forEach{i in
            let sprite = SKSpriteNode(texture: cloudTexture)
            sprite.position = CGPoint(x: i * sprite.size.width, y: frame.size.height - sprite.size.height/2)
            sprite.run(repeatScroll)
            
            scrollNode.addChild(sprite)
        }
    }
    
    func setupWall(){
        let wallTexture = SKTexture(imageNamed: "wall")
        wallTexture.filteringMode = SKTextureFilteringMode.linear
        
        let movingDistance = CGFloat(wallTexture.size().width + frame.size.width)
        let moveWall = SKAction.moveBy(x: movingDistance, y: 0.0, duration: 4.0)
        let disapper = SKAction.removeFromParent()
        let wallScroll = SKAction.sequence([moveWall, disapper])
        
        let createWallAnimation = SKAction.run({
            let wall = SKNode()
            wall.position = CGPoint(x: self.frame.size.width + wallTexture.size().width / 2, y: 0.0)
            wall.zPosition = -50.0 // 雲より手前、地面より奥
            
            // 画面のY軸の中央値
            let center_y = self.frame.size.height / 2
            // 壁のY座標を上下ランダムにさせるときの最大値
            let random_y_range = self.frame.size.height / 4
            // 下の壁のY軸の下限
            let under_wall_lowest_y = UInt32( center_y - wallTexture.size().height / 2 -  random_y_range / 2)
            // 1〜random_y_rangeまでのランダムな整数を生成
            let random_y = arc4random_uniform( UInt32(random_y_range) )
            // Y軸の下限にランダムな値を足して、下の壁のY座標を決定
            let under_wall_y = CGFloat(under_wall_lowest_y + random_y)

            // キャラが通り抜ける隙間の長さ
            let slit_length = self.frame.size.height / 6
            
            // 下側の壁を作成
            let under = SKSpriteNode(texture: wallTexture)
            under.position = CGPoint(x: 0.0, y: under_wall_y)
            wall.addChild(under)
            
            // 上側の壁を作成
            let upper = SKSpriteNode(texture: wallTexture)
            upper.position = CGPoint(x: 0.0, y: under_wall_y + wallTexture.size().height + slit_length)
            
            wall.addChild(upper)
            wall.run(wallScroll)
            
            self.wallNode.addChild(wall)
            })
        
        // 次の壁作成までの待ち時間のアクションを作成
        let waitAnimation = SKAction.wait(forDuration: 2)
        
        // 壁を作成->待ち時間->壁を作成を無限に繰り替えるアクションを作成
        let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([createWallAnimation, waitAnimation]))
        
        wallNode.run(repeatForeverAnimation)
    }
    
    
    
    
}
