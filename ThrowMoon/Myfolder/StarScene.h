//
//  StarScene.h
//  SpriteKitSimpleGame
//
//  Created by 小雨科技 on 2017/9/7.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//  太阳扔月亮砸星星

#import <SpriteKit/SpriteKit.h>

//类别标识码
static const uint32_t  moonCategory  =  0x1 << 0;
static const uint32_t  starCategory  =  0x1 << 1;

@interface StarScene : SKScene <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int starDestroyed;



@end
