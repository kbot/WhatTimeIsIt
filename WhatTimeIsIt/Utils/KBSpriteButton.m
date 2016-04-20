//
//  KBSpriteButton.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 4/10/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import "KBSpriteButton.h"
#import "KBGeneralUtils.h"

@interface KBSpriteButton ()
@property (nonatomic,strong) SKLabelNode* titleLabel;
@property (nonatomic,strong) SKSpriteNode* iconImage;
@property (nonatomic,strong) SKNode* backgroundImage;
@property (nonatomic,strong) SKNode* selectedBackgroundImage;
@property (nonatomic,strong) SKNode* highlightedBackgroundImage;
@end

@implementation KBSpriteButton

+(KBSpriteButton*)buttonWithTitle:(NSString*)title backgroundColor:(UIColor*)bgColor {
    KBSpriteButton* button = [KBSpriteButton new];
    button.backgroundImage = [[SKSpriteNode alloc] initWithColor:bgColor size:CGSizeMake(40, 40)];
    button.highlightedBackgroundImage = [[SKSpriteNode alloc] initWithColor:[KBGeneralUtils darkenedColorFromColor:bgColor] size:CGSizeMake(40, 40)];
    button.titleLabel = [[SKLabelNode alloc] initWithFontNamed:@"CaviarDreams.ttf"];
    button.titleLabel.text = title;
    [button disableAllTouchableSubNodes];
    return button;
}

+(KBSpriteButton*)buttonWithIconImage:(NSString*)filename backgroundColor:(UIColor*)bgColor {
    KBSpriteButton* button = [KBSpriteButton new];
    button.backgroundImage = [[SKSpriteNode alloc] initWithColor:bgColor size:CGSizeMake(40, 40)];
    button.iconImage = [[SKSpriteNode alloc] initWithImageNamed:filename];
    [button disableAllTouchableSubNodes];
    return button;
}

+(KBSpriteButton*)buttonWithIconImage:(NSString*)filename backgroundColor:(UIColor*)bgColor shape:(SKShapeNode*)shape {
    KBSpriteButton* button = [KBSpriteButton new];
    button.backgroundImage = shape;
    shape.fillColor = bgColor;
    shape.strokeColor = [UIColor clearColor];
    SKShapeNode* highlightShapeNode = [shape copy];
    button.highlightedBackgroundImage = highlightShapeNode;
    highlightShapeNode.fillColor = [KBGeneralUtils darkenedColorFromColor:bgColor];
    
    button.iconImage = [[SKSpriteNode alloc] initWithImageNamed:filename];
    button.iconImage.size = shape.frame.size;
    [button disableAllTouchableSubNodes];
    return button;
}

-(void)disableAllTouchableSubNodes {
    for (SKNode* node in self.children) {
        node.userInteractionEnabled = NO;
    }
    self.userInteractionEnabled = YES;
}

#pragma mark - Touch Handling
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //highlight
    self.backgroundImage.hidden = YES;
    self.highlightedBackgroundImage.hidden = NO;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //un-highlight
    //call touch handler
    self.backgroundImage.hidden = NO;
    self.highlightedBackgroundImage.hidden = YES;
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //un-highlight
    self.backgroundImage.hidden = NO;
    self.highlightedBackgroundImage.hidden = YES;
}

#pragma mark - Custom Setters
-(void)setTitleLabel:(SKLabelNode *)titleLabel {
    if (_titleLabel) {
        [_titleLabel removeFromParent];
        [_titleLabel removeAllActions];
    }
    _titleLabel = titleLabel;
    [self addChild:_titleLabel];
}

-(void)setIconImage:(SKSpriteNode *)iconImage {
    if (_iconImage) {
        [_iconImage removeFromParent];
        [_iconImage removeAllActions];
    }
    _iconImage = iconImage;
    [self addChild:_iconImage];
}

-(void)setBackgroundImage:(SKSpriteNode *)backgroundImage {
    if (_backgroundImage) {
        [_backgroundImage removeFromParent];
        [_backgroundImage removeAllActions];
    }
    _backgroundImage = backgroundImage;
    [self addChild:_backgroundImage];
}

-(void)setHighlightedBackgroundImage:(SKSpriteNode *)highlightedBackgroundImage {
    if (_highlightedBackgroundImage) {
        [_highlightedBackgroundImage removeFromParent];
        [_highlightedBackgroundImage removeAllActions];
    }
    _highlightedBackgroundImage = highlightedBackgroundImage;
    _highlightedBackgroundImage.hidden = YES;
    [self addChild:_highlightedBackgroundImage];
}

-(void)setSelectedBackgroundImage:(SKSpriteNode *)selectedBackgroundImage {
    if (_selectedBackgroundImage) {
        [_selectedBackgroundImage removeFromParent];
        [_selectedBackgroundImage removeAllActions];
    }
    _selectedBackgroundImage = selectedBackgroundImage;
    _selectedBackgroundImage.hidden = YES;
    [self addChild:_selectedBackgroundImage];
}


@end
