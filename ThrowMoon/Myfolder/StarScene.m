//
//  StarScene.m
//  SpriteKitSimpleGame
//
//  Created by 小雨科技 on 2017/9/7.
//  Copyright © 2017年 jiajianhao. All rights reserved.

#import "StarScene.h"
#import "GameOverScene.h"
#define DegreesToAngles(angle) (angle)/ 180.0 * M_PI
@implementation StarScene


static inline CGPoint vectorAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint vectorSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint vectorMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float vectorLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

//长度为1的标准向量
static inline CGPoint vectorNormalize(CGPoint a) {
    float length = vectorLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

-(instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        NSLog(@"initWithSize");

        self.backgroundColor=[SKColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        
//        NSString *burstPath =
//        [[NSBundle mainBundle] pathForResource:@"Snow" ofType:@"sks"];
//         SKEmitterNode *burstEmitter =
//        [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
//         burstEmitter.position = CGPointMake(100, 400);
//        burstEmitter.numParticlesToEmit=30;
//        burstEmitter.speed=2;
//         [self addChild:burstEmitter];
        
        
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"sun"];
        self.player.position = CGPointMake(self.player.size.width/2, self.frame.size.height/2);
        [self addChild:self.player];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate=self;
        
        
    }
    return self;
}


-(void)update:(NSTimeInterval)currentTime{
    NSLog(@"update");
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];

    
}

-(void)didEvaluateActions{
    NSLog(@"didEvaluateActions");

}
-(void)didSimulatePhysics{
    NSLog(@"didSimulatePhysics");
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
 
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
     if ((firstBody.categoryBitMask & moonCategory) != 0 &&
        (secondBody.categoryBitMask & starCategory) != 0)
    {
        //处理撞击
        [self theMoon:(SKSpriteNode*)firstBody.node DidContactTheStar:(SKSpriteNode*)secondBody.node];
    }
}
-(void)didEndContact:(SKPhysicsContact *)contact{
    
}
#pragma mark -- Touch Action

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //手指触摸屏幕，扔月亮
    UITouch * touch = [touches anyObject];
//    [self handleTouchEvent:touch];
    [self handleTouchEvent:touch AndDegree:0];
    [self handleTouchEvent:touch AndDegree:10];
    [self handleTouchEvent:touch AndDegree:20];
    [self handleTouchEvent:touch AndDegree:30];
    [self handleTouchEvent:touch AndDegree:40];
    [self handleTouchEvent:touch AndDegree:50];
    [self handleTouchEvent:touch AndDegree:60];
    [self handleTouchEvent:touch AndDegree:-10];
    [self handleTouchEvent:touch AndDegree:-20];
    [self handleTouchEvent:touch AndDegree:-30];
    [self handleTouchEvent:touch AndDegree:-40];
    [self handleTouchEvent:touch AndDegree:-50];
    [self handleTouchEvent:touch AndDegree:-60];

}

#pragma mark -- Private Method
-(void)addStar{
    // 创建星星节点
    SKSpriteNode * star = [SKSpriteNode spriteNodeWithImageNamed:@"star"];
    star.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:star.size]; // 1
    star.physicsBody.dynamic = YES; // 2
    star.physicsBody.categoryBitMask = starCategory; // 3
    star.physicsBody.contactTestBitMask = moonCategory; // 4
    star.physicsBody.collisionBitMask = 0; // 5
    
    // Y轴上，星星初始出现的地方
    int minY = star.size.height / 2;
    int maxY = self.frame.size.height - star.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    //y轴上，屏幕内，随机位置
    star.position = CGPointMake(self.frame.size.width + star.size.width/2, actualY);
    [self addChild:star];
    
    // 星星移动的速度
    int minDuration = 3.0;
    int maxDuration = 6.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // 添加动作
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-star.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * loseAction = [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
        [self.view presentScene:gameOverScene transition: reveal];
    }];
    [star runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    
}
-(void)theMoon:(SKSpriteNode*)moonNode DidContactTheStar:(SKSpriteNode*)starNode{
    NSLog(@"Hit");
    [moonNode removeFromParent];
    [starNode removeFromParent];
    self.starDestroyed++;
    if (self.starDestroyed > 30) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
        [self.view presentScene:gameOverScene transition: reveal];
    }
}
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addStar];
    }
}

-(void)handleTouchEvent:(UITouch*)touch{
    CGPoint location = [touch locationInNode:self];
    
    // 2 - 初始化月亮
    SKSpriteNode * moon = [SKSpriteNode spriteNodeWithImageNamed:@"moon"];
    moon.position = self.player.position;
    moon.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:moon.size.width/2];
    moon.physicsBody.dynamic = YES;
    moon.physicsBody.categoryBitMask = moonCategory;
    moon.physicsBody.contactTestBitMask = starCategory;
    moon.physicsBody.collisionBitMask = 0;
    moon.physicsBody.usesPreciseCollisionDetection = YES;
    
    // 3- 计算位置偏移
    CGPoint offset = vectorSub(location, moon.position);
    
    // 4 - 在左边发射的月亮，就不看了（默认往右边发，因为星星只在右边发射）
    if (offset.x <= 0) return;
    
    // 5 - 加入月亮
    [self addChild:moon];
    
    // 6 - 获得扔出去路径的单位向量
    CGPoint direction = vectorNormalize(offset);
    
    // 7 - 向量变大，保证扔出的距离足够远
    CGPoint shootAmount = vectorMult(direction, 1000);
    
    // 8 - 添加扔出路径到月亮的位置
    CGPoint realDest = vectorAdd(shootAmount, moon.position);
    
    // 9 - 执行动作
    float velocity = 480.0/1.0;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [moon runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}


-(void)handleTouchEvent:(UITouch*)touch AndDegree:(CGFloat)degree{
    
    CGPoint targetlocation =self.player.position;
    targetlocation.x = self.player.position.x+10;
    targetlocation.y = self.player.position.y+10*tan(DegreesToAngles(degree));

    //获取水平直线方向上的路径
    CGPoint offsetHorizonal = vectorSub(targetlocation, self.player.position);
     //获得扔出去路径的单位向量
    CGPoint directionHorizonal = vectorNormalize(offsetHorizonal);
     //向量变大，保证扔出的距离足够远
    CGPoint shootAmountHorizonal = vectorMult(directionHorizonal, 1000);
     //添加扔出路径到月亮的位置
    CGPoint realDestHorizonal= vectorAdd(shootAmountHorizonal, self.player.position);

    //添加月亮
    SKSpriteNode * moon = [SKSpriteNode spriteNodeWithImageNamed:@"moon"];
    moon.position = self.player.position;
    moon.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:moon.size.width/2];
    moon.physicsBody.dynamic = YES;
    moon.physicsBody.categoryBitMask = moonCategory;
    moon.physicsBody.contactTestBitMask = starCategory;
    moon.physicsBody.collisionBitMask = 0;
    moon.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:moon];
    // 执行动作
    float velocity = 480.0/1.0;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDestHorizonal duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [moon runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
    
    
    
}
 @end
