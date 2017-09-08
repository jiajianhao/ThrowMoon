//
//  GameViewController.m
//  ThrowMoon
//
//  Created by 小雨科技 on 2017/9/8.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "StarScene.h"
@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the SKScene from 'GameScene.sks'
    //    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    //
    //    // Set the scale mode to scale to fit the window
    //    scene.scaleMode = SKSceneScaleModeAspectFill;
    //
    //    SKView *skView = (SKView *)self.view;
    //
    //    // Present the scene
    //    [skView presentScene:scene];
    //
    //    skView.showsFPS = YES;
    //    skView.showsNodeCount = YES;
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        StarScene * scene = [StarScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
