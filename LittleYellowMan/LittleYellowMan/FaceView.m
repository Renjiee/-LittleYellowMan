//
//  FaceView.m
//  LittleYellowMan
//
//  Created by ChangRJey on 2017/7/14.
//  Copyright © 2017年 RenJiee. All rights reserved.
//

#import "FaceView.h"


@implementation FaceView

#pragma mark -------------------- 在layoutSubviews方法中设置子控件的frame --------------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.faceImage];
    [self addSubview:self.glassesImage];
    
    self.faceImage.bounds = self.bounds;
    self.glassesImage.bounds = self.bounds;
}

#pragma mark -------------------- 懒加载控件 --------------------
- (UIImageView *) faceImage{
    if(!_faceImage){
        _faceImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"minions_background"]];
    }
    return _faceImage;
}

- (UIImageView *) glassesImage{
    if(!_glassesImage){
        _glassesImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"minions_grass"]];
    }
    return _glassesImage;
}

@end
