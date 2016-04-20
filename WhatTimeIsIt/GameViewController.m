//
//  GameViewController.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/14/16.
//  Copyright (c) 2016 Kevin Bloom. All rights reserved.
//

#import "GameViewController.h"
#import "MainMenu.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    //TODO - change to menu scene so the player can select gameplay options
    MainMenu *scene = [MainMenu unarchiveFromFile:@"MainMenu"];
    
    // Present the scene.
    [skView presentScene:scene];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)pauseCurrentScene {
    SKView * skView = (SKView *)self.view;
    skView.scene.speed = 0.0f;
}
-(void)resumeCurrentScene {
    SKView * skView = (SKView *)self.view;
    skView.scene.speed = 1.0f;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - App State
-(void)willResignActive:(NSNotification*)notif {
    [self pauseCurrentScene];
}

-(void)willBecomeActive:(NSNotification*)notif {
    [self resumeCurrentScene];
}

@end
