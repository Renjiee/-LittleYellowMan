//
//  ViewController.m
//  xiaoHuangRen
//
//  Created by CFS on 2017/7/6.
//  Copyright © 2017年 CFS. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "EyesImage.h"
#import "FaceView.h"

/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
/** define:屏幕的宽高比 */
#define CURRENT_SIZE(_size) _size / 375.0 * SCREEN_SIZE.width


@interface ViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic,weak) EyesImage * leftEye;
@property (nonatomic,weak) EyesImage * rightEye;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property ( nonatomic, strong) FaceView * faceView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceView = [[FaceView alloc]initWithFrame:CGRectMake(0, 0, CURRENT_SIZE(200), CURRENT_SIZE(200))];
    self.faceView.center = self.view.center;
    [self.view addSubview:self.faceView];
    
    
    [self initEyes];
    
    [self SetCoreMotion];
    [self SetAccelerometer];
}

- (void) initEyes{
    //左眼
    EyesImage * leftEye = [[EyesImage alloc] initWithFrame:CGRectMake(CURRENT_SIZE(150), CURRENT_SIZE(300), CURRENT_SIZE(20), CURRENT_SIZE(20))];
    leftEye.image = [UIImage imageNamed:@"minions_eyes"];
    leftEye.layer.masksToBounds = YES;
    leftEye.layer.cornerRadius = 10;
    leftEye.contentMode = UIViewContentModeScaleAspectFit;
    leftEye.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
    [self.view addSubview:leftEye];
    self.leftEye = leftEye;
    
    //右眼
    EyesImage * rightEye = [[EyesImage alloc] initWithFrame:CGRectMake(CURRENT_SIZE(210), CURRENT_SIZE(300), CURRENT_SIZE(20), CURRENT_SIZE(20))];
    rightEye.image = [UIImage imageNamed:@"minions_eyes"];
    rightEye.layer.masksToBounds = YES;
    rightEye.layer.cornerRadius = 10;
    rightEye.contentMode = UIViewContentModeScaleAspectFit;
    rightEye.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
    [self.view addSubview:rightEye];
    
    self.rightEye = rightEye;
}

- (void)SetCoreMotion{
    //  设置重力并纪录
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    gravity.magnitude = 1;
    [gravity addItem:self.leftEye];
    [gravity addItem:self.rightEye];
    [self.animator addBehavior:gravity];
    self.gravity = gravity;
    
    //设置摩擦力
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:self.leftEye];
    [collision addItem:self.rightEye];
    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[self.leftEye, self.rightEye]];
    //摩擦力
    item.friction = 100;
    [self.animator addBehavior:item];
    // 3.开始仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
    
    
    //    画出边界
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:
                          CGRectMake(CURRENT_SIZE(128),CURRENT_SIZE(280), CURRENT_SIZE(50), CURRENT_SIZE(45))];
    
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
                           CGRectMake(CURRENT_SIZE(186),CURRENT_SIZE(280), CURRENT_SIZE(50), CURRENT_SIZE(45))];
    
    [collision addBoundaryWithIdentifier:@"circle" forPath:path2];
}


- (void)SetAccelerometer{
    CMMotionManager *motionManager = [[CMMotionManager alloc]init];
    motionManager.accelerometerUpdateInterval = 0.01; // 告诉manager，更新频率是100Hz
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAccelerometerData *newestAccel = motionManager.accelerometerData;
        double accelerationX = newestAccel.acceleration.x;
        double accelerationY = newestAccel.acceleration.y;
        self.gravity.gravityDirection = CGVectorMake(accelerationX, -accelerationY);
    }];
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        // 创建一个物理仿真器
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
