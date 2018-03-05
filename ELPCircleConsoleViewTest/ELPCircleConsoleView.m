//
//  ELPCircleConsoleView.m
//  ELPCircleConsoleViewTest
//
//  Created by 彭成龙 on 2018/3/2.
//  Copyright © 2018年 ElsonPeng. All rights reserved.
//

#import "ELPCircleConsoleView.h"

#import "UIView+Sizes.h"

@interface ELPCircleConsoleView ()

@property (nonatomic, strong) UIImageView *consoleBGImageView;

@property (nonatomic, strong) UIButton *rotateButton; // 旋转按钮

@property (nonatomic, strong) UIView *traceView; // 旋转轨迹

@property (nonatomic, assign) ELPCircleConsoleMoveDirection direction;

@property (nonatomic, assign) ELPCircleConsoleMoveDirection preDirection;

@property (nonatomic, assign) CGPoint tempPoint;

@property (nonatomic, assign) CGFloat deltaRadius;

//图片相关
@property (nonatomic, strong) UIImage *rotateBackgroundImage_normal;
@property (nonatomic, strong) UIImage *rotateBackgroundImage_active_up;
@property (nonatomic, strong) UIImage *rotateBackgroundImage_active_down;
@property (nonatomic, strong) UIImage *rotateBackgroundImage_active_left;
@property (nonatomic, strong) UIImage *rotateBackgroundImage_active_right;
@property (nonatomic, strong) UIImage *rotateCenterButtonImage_normal;
@property (nonatomic, strong) UIImage *rotateCenterButtonImage_active;

@end


@implementation ELPCircleConsoleView{
    ELPCircleConsoleMoveDirection currentDirection;
    CGPoint currentPoint;
    NSOperationQueue *queue;
    CGFloat centerViewX;
    CGFloat centerViewY;
    
    NSInteger xAxisSpeed;
    NSInteger yAxisSpeed;
    
    NSInteger initxAxisSpeed;
    NSInteger inityAxisSpeed;
    
    CGFloat timeInterval;
    
    //判断当前是不是正在发送stop指令
    BOOL isSendOnlyStopCmd;
    
}

-(instancetype)init{
    return [self initWithOritention:YES];
}

-(instancetype)initWithOritention:(BOOL)isProtrait {
    self = [super init];
    if (self) {
        self.isPortrait = isProtrait;
        
        self.consoleBGImageView = [[UIImageView alloc] init];
        self.consoleBGImageView.userInteractionEnabled = YES;
        [self addSubview:self.consoleBGImageView];
        
        self.rotateButton = [[UIButton alloc] init];
        self.rotateButton.adjustsImageWhenHighlighted = NO;
        [self.rotateButton addTarget:self action:@selector(rotateButtonImgChange) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.rotateButton];
        
        // 运动轨迹view
        self.traceView = [[UIView alloc] init];
        [self addSubview:self.traceView];
        
        self.consoleBGImageView.image = self.rotateBackgroundImage_normal;
        
        [self.rotateButton setImage:self.rotateCenterButtonImage_normal forState:UIControlStateNormal];
        [self.rotateButton setImage:_rotateCenterButtonImage_active forState:UIControlStateHighlighted];
        self.rotateButton.size = self.rotateCenterButtonImage_normal.size;
        
        // 添加拖动手势
        UIPanGestureRecognizer *panPressGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveInCircle:)];
        panPressGes.minimumNumberOfTouches = 0.1;
        [self.rotateButton addGestureRecognizer:panPressGes];
    }
    return self;
}


-(void) rotateButtonImgChange {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _preDirection =ELPCircleConsoleMoveDirectionNone;
    
    self.consoleBGImageView.left = 0;
    self.consoleBGImageView.top = 0;
    
    self.rotateButton.centerX = self.consoleBGImageView.centerX;
    self.rotateButton.centerY = self.consoleBGImageView.centerY;
    
    self.traceView.centerX = self.consoleBGImageView.centerX;
    self.traceView.centerY = self.consoleBGImageView.centerY;
    
    CGFloat radiusBig =  ( self.consoleBGImageView.width + self.consoleBGImageView.height ) * 0.5  * 0.5;
    CGFloat radiusSmall = (self.rotateButton.width + self.rotateButton.height) * 0.5 * 0.5;
    self.deltaRadius = (radiusBig - radiusSmall) * (radiusBig - radiusSmall);
    
    centerViewX = self.rotateButton.centerX;
    centerViewY = self.rotateButton.centerY;
    
    xAxisSpeed = 50;
    yAxisSpeed = 20;
    timeInterval = 0.3;
}

#pragma mark - 在触摸方面开发时，只针对touches进行处理
#pragma mark - 触摸开始 在一次触摸事件中 只会执行一次
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint currentP = [touch locationInView:self];
    
    _tempPoint = currentP;
    [UIView animateWithDuration:0.3 animations:^{
        [self rotateLocation:currentP];
    }];
}

#pragma mark - 触摸移动  在一次触摸事件中会执行多次
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    //要知道手指触摸的位置
    CGPoint pLocation = [touch locationInView:self];
    //对位置进行修正
    [self rotateLocation:pLocation];
}

-(void)rotateLocation:(CGPoint)pLocation {
    if([self IfYuntaiViewIsIntheBigView:pLocation]){
        self.rotateButton.center = CGPointMake(pLocation.x, pLocation.y);
        
        CGPoint tranPoint = CGPointMake(pLocation.x - centerViewX, pLocation.y - centerViewY);
        ELPCircleConsoleMoveDirection direction = [self determineCameraDirection:tranPoint];
        currentDirection = direction;
    } else {
        CGFloat radius = self.traceView.size.width * 0.5;
        CGPoint pointc = self.consoleBGImageView.center;
        CGPoint changePoint = [self CirclePoint:radius withCenterCircle:pointc withCurrentPoint:pLocation];
        
        self.rotateButton.center = CGPointMake(changePoint.x, changePoint.y);
        
        CGPoint tranPoint = CGPointMake(changePoint.x - centerViewX, changePoint.y - centerViewY);
        ELPCircleConsoleMoveDirection direction = [self determineCameraDirection:tranPoint];
        currentDirection = direction;
    }
    
    CGFloat xValue = fabs(self.rotateButton.centerX - centerViewX);
    CGFloat yValue = fabs(self.rotateButton.centerY - centerViewY);
    
    CGFloat currentRadiusValue = xValue * xValue + yValue * yValue;
    CGFloat bgImgRadiusWith = self.consoleBGImageView.width * 0.5 * 0.5;
    if(currentRadiusValue > bgImgRadiusWith * bgImgRadiusWith * 0.6) {
        [self sendRotateButtonRotateCmd];
    } else {
        [self resumBackgroundImgToNormal];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.consoleBGImageView setImage:self.rotateBackgroundImage_normal];
    [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.rotateButton.center = CGPointMake(self.consoleBGImageView.centerX, self.consoleBGImageView.centerY);
    } completion:nil];
    
    [self.rotateButton setImage:self.rotateCenterButtonImage_normal forState:UIControlStateNormal];
    self.rotateButton.highlighted = NO;
    _preDirection =ELPCircleConsoleMoveDirectionNone;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
        [self.delegate rotateCircleView:self didRotateWithValueX:nil valueY:nil stop:YES moveDirection:ELPCircleConsoleMoveDirectionStop];
    }
    isSendOnlyStopCmd = YES;
}

- (void)rotateButtonClickedCancel {
    _preDirection =ELPCircleConsoleMoveDirectionNone;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
        [self.delegate rotateCircleView:self didRotateWithValueX:nil valueY:nil stop:YES moveDirection:ELPCircleConsoleMoveDirectionStop];
    }
    isSendOnlyStopCmd = YES;
    
    [self.rotateButton setImage:self.rotateCenterButtonImage_normal forState:UIControlStateNormal];
    [self.consoleBGImageView setImage:self.rotateBackgroundImage_normal];
    
    self.rotateButton.centerX = self.consoleBGImageView.centerX;
    self.rotateButton.centerY = self.consoleBGImageView.centerY;
    
}

- (void)moveInCircle:(UIPanGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self rotateButtonClickedCancel];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGPoint locationP = [gesture locationInView:self];
        ELPCircleConsoleMoveDirection direction = [self determineCameraDirection:translation];
        currentPoint = translation;
        currentDirection = direction;
        
        //判断当前内部 云台 旋转 是否在大圆范围内
        if([self IfYuntaiViewIsIntheBigView:locationP]) {
            self.rotateButton.centerX = locationP.x;
            self.rotateButton.centerY = locationP.y;
        } else {
            CGFloat radius = self.traceView.size.width * 0.5;
            CGPoint pointc = self.consoleBGImageView.center;
            CGPoint changePoint = [self CirclePoint:radius withCenterCircle:pointc withCurrentPoint:locationP];
            
            self.rotateButton.centerX = changePoint.x;
            self.rotateButton.centerY = changePoint.y;
        }
        CGFloat xValue = fabs(self.rotateButton.centerX - centerViewX);
        CGFloat yValue = fabs(self.rotateButton.centerY - centerViewY);
        
        CGFloat currentRadiusValue = xValue * xValue + yValue * yValue;
        CGFloat bgImgRadiusWith = self.consoleBGImageView.width * 0.5 * 0.5;
        
        if(currentRadiusValue > bgImgRadiusWith * bgImgRadiusWith * 0.6) {
            [self sendRotateButtonRotateCmd];
        } else {
            [self resumBackgroundImgToNormal];
        }
    } else if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.rotateButton setImage:self.rotateCenterButtonImage_active forState:UIControlStateNormal];
    }
}

-(void)setConsoleBackgroundImage {
    if(currentDirection ==ELPCircleConsoleMoveDirectionUp) {
        [self.consoleBGImageView setImage:self.rotateBackgroundImage_active_up];
    } else if(currentDirection ==ELPCircleConsoleMoveDirectionDown) {
        [self.consoleBGImageView setImage:self.rotateBackgroundImage_active_down];
    } else if(currentDirection ==ELPCircleConsoleMoveDirectionLeft) {
        [self.consoleBGImageView setImage:self.rotateBackgroundImage_active_left];
    } else if(currentDirection ==ELPCircleConsoleMoveDirectionRight) {
        [self.consoleBGImageView setImage:self.rotateBackgroundImage_active_right];
    }
}

-(BOOL)IfYuntaiViewIsIntheBigView:(CGPoint)mPoint {
    CGFloat delX = fabs(mPoint.x - centerViewX);
    CGFloat delY = fabs(mPoint.y - centerViewY);
    
    if((delX * delX + delY * delY) < self.deltaRadius) {
        return YES;
    }
    return NO;
}

-(void)sendRotateButtonRotateCmd {
    [self setConsoleBackgroundImage];
    
    xAxisSpeed = initxAxisSpeed;
    yAxisSpeed = inityAxisSpeed;
    
    NSString *xPositive = [NSString stringWithFormat:@"%ld",(long)xAxisSpeed];
    NSString *xNegative = [NSString stringWithFormat:@"%ld",-(long)xAxisSpeed];
    
    NSString *yPositive = [NSString stringWithFormat:@"%ld",(long)yAxisSpeed];
    NSString *yNegative = [NSString stringWithFormat:@"%ld",-(long)yAxisSpeed];
    
    isSendOnlyStopCmd = NO;
    if(currentDirection ==ELPCircleConsoleMoveDirectionRight) {
        //直接向右转动
        if(_preDirection == currentDirection || _preDirection ==ELPCircleConsoleMoveDirectionNone) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
                [self.delegate rotateCircleView:self didRotateWithValueX:xPositive valueY:@"0" stop:NO moveDirection:ELPCircleConsoleMoveDirectionRight];
            }
        }
        //前一个方向停止，向右转动
        else {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
                [self.delegate rotateCircleView:self didRotateWithValueX:xPositive valueY:@"0" stop:YES moveDirection:ELPCircleConsoleMoveDirectionRightStop];
            }
        }
    } else if(currentDirection ==ELPCircleConsoleMoveDirectionUp) {
        if(_preDirection == currentDirection || _preDirection ==ELPCircleConsoleMoveDirectionNone) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
                [self.delegate rotateCircleView:self didRotateWithValueX:@"0" valueY:yPositive stop:NO moveDirection:ELPCircleConsoleMoveDirectionUp];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
                [self.delegate rotateCircleView:self didRotateWithValueX:@"0" valueY:yPositive stop:YES moveDirection:ELPCircleConsoleMoveDirectionUpStop];
            }
        }
    } else if(currentDirection ==ELPCircleConsoleMoveDirectionLeft) {
        if(_preDirection == currentDirection || _preDirection ==ELPCircleConsoleMoveDirectionNone) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
                [self.delegate rotateCircleView:self didRotateWithValueX:xNegative valueY:@"0" stop:NO moveDirection:ELPCircleConsoleMoveDirectionLeft];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
                [self.delegate rotateCircleView:self didRotateWithValueX:xNegative valueY:@"0" stop:YES moveDirection:ELPCircleConsoleMoveDirectionLeftStop];
            }
        }
    } else if(currentDirection ==ELPCircleConsoleMoveDirectionDown) {
        if(_preDirection == currentDirection || _preDirection ==ELPCircleConsoleMoveDirectionNone) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
                [self.delegate rotateCircleView:self didRotateWithValueX:@"0" valueY:yNegative stop:NO moveDirection:ELPCircleConsoleMoveDirectionDown];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(rotateCircleView:didRotateWithValueX:valueY:stop:moveDirection:)]) {
                [self.delegate rotateCircleView:self didRotateWithValueX:@"0" valueY:yNegative stop:YES moveDirection:ELPCircleConsoleMoveDirectionDownStop];
            }
        }
    }
    _preDirection = currentDirection;
}

-(void)resumBackgroundImgToNormal {
    [self.consoleBGImageView setImage:self.rotateBackgroundImage_normal];
}

// 获取 当前拖动的点于圆心构成的直线  和运动轨迹圆的相交点
- (CGPoint)CirclePoint:(CGFloat)radius withCenterCircle:(CGPoint)centerCircle withCurrentPoint:(CGPoint)curPoint {
    CGPoint cPoint;
    CGFloat x = curPoint.x;
    CGFloat y = curPoint.y;
    //圆的X坐标轨迹
    CGFloat cX ;
    //圆的Y坐标轨迹
    CGFloat cY ;
    // 圆心到转动按钮的距离的平方
    CGFloat daX;
    // 圆心到转动按钮的距离
    CGFloat aX;
    // 圆心水平方向与转动按钮形成的夹角的cos值
    CGFloat cosX;
    // 圆心与触控点的距离的平方（勾股定理）
    daX =  (x - centerCircle.x)*(x - centerCircle.x) + (y - centerCircle.y)*(y - centerCircle.y);
    aX = sqrt(daX); //开根号  //圆心与触控点的距离
    cosX =  fabs(x - centerCircle.x)/aX;  //绝对值
    cX = cosX * radius; //  x =R * cosX;  圆心到触控点在水平坐标的X的值
    cY = sqrt(radius * radius - cX * cX);
    
    if(x < centerCircle.x){ //如果X所在的点小于圆心 在圆心的左边
        cX = centerCircle.x - cX;
    }else{
        cX = centerCircle.x + cX;
    }
    
    if(y < centerCircle.y){
        cY = centerCircle.y - cY;
    }else{
        cY = centerCircle.y + cY;
    }
    cPoint.x = cX;
    cPoint.y = cY;
    return cPoint;
}

// 根据拖动时候的偏移确定摄像头的移动方向
- (ELPCircleConsoleMoveDirection)determineCameraDirection:(CGPoint)translation {
    if (translation.y == 0.0 || fabs(translation.x / translation.y) >= 1.0){
        if (translation.x > 0.0 ){
            _direction =ELPCircleConsoleMoveDirectionRight;
        }else{
            _direction =ELPCircleConsoleMoveDirectionLeft;
        }
    } else if (translation.x == 0.0 || fabs(translation.y / translation.x) >= 1.0){
        if (translation.y > 0.0 ){
            _direction =ELPCircleConsoleMoveDirectionDown;
        }else{
            _direction =ELPCircleConsoleMoveDirectionUp;
        }
    }
    return _direction;
}

-(void)dealloc{
    NSLog(@"ELPCircleConsole dealloc");
}

-(UIImage *)imageByInchesWithName:(NSString *)imageName{
    if (!imageName) {
        return [UIImage new];
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]];
}

#pragma mark - setter & getter
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.consoleBGImageView.frame = self.bounds;
    self.consoleBGImageView.size = self.size;
    
    self.rotateButton.size = self.rotateCenterButtonImage_normal.size;
    
    self.traceView.size = (CGSize){self.consoleBGImageView.width - self.rotateButton.width,self.consoleBGImageView.height - self.rotateButton.height};
}

-(void)setIsPortrait:(BOOL)isPortrait{
    _isPortrait = isPortrait;
    
    if (self.consoleBGImageView) {
        self.consoleBGImageView.image = self.rotateBackgroundImage_normal;
    }
    if (self.rotateButton) {
        [self.rotateButton setImage:self.rotateCenterButtonImage_normal forState:UIControlStateNormal];
        [self.rotateButton setImage:_rotateCenterButtonImage_active forState:UIControlStateHighlighted];
        self.rotateButton.size = self.rotateCenterButtonImage_normal.size;
    }
    if (self.traceView) {
        self.traceView.size = (CGSize){self.consoleBGImageView.width - self.rotateButton.width,self.consoleBGImageView.height - self.rotateButton.height};
    }
}

//中间操作台控制背景图片
-(UIImage *)rotateBackgroundImage_normal {
    if (!_rotateBackgroundImage_normal) {
        return [self imageByInchesWithName:self.isPortrait?@"protrait_ConsoleBackgroundImage_normal":@"landscape_ConsoleBackgroundImage_normal"];
    }
    return _rotateBackgroundImage_normal;
}
-(UIImage *)rotateBackgroundImage_active_up {
    if (!_rotateBackgroundImage_active_up) {
        return [self imageByInchesWithName:self.isPortrait?@"protrait_ConsoleBackgroundImage_active_up":@"landscape_ConsoleBackgroundImage_active_up"];
    }
    return _rotateBackgroundImage_active_up;
}
-(UIImage *)rotateBackgroundImage_active_down {
    if (!_rotateBackgroundImage_active_down) {
        return [self imageByInchesWithName:self.isPortrait?@"protrait_ConsoleBackgroundImage_active_down":@"landscape_ConsoleBackgroundImage_active_down"];
    }
    return _rotateBackgroundImage_active_down;
}
-(UIImage *)rotateBackgroundImage_active_left {
    if (!_rotateBackgroundImage_active_left) {
        return [self imageByInchesWithName:self.isPortrait?@"protrait_ConsoleBackgroundImage_active_left":@"landscape_ConsoleBackgroundImage_active_left"];
    }
    return _rotateBackgroundImage_active_left;
}
-(UIImage *)rotateBackgroundImage_active_right {
    if (!_rotateBackgroundImage_active_right) {
        return [self imageByInchesWithName:self.isPortrait?@"protrait_ConsoleBackgroundImage_active_right":@"landscape_ConsoleBackgroundImage_active_right"];
    }
    return _rotateBackgroundImage_active_right;
}
-(UIImage *)rotateCenterButtonImage_normal {
    if (!_rotateCenterButtonImage_normal) {
        return [self imageByInchesWithName:self.isPortrait?@"newly_protrait_rotateCenterButtonImage_normal":@"landscape_rotateCenterButtonImage_normal"];
    }
    return _rotateCenterButtonImage_normal;
}
-(UIImage *)rotateCenterButtonImage_active {
    if (!_rotateCenterButtonImage_active) {
        return [self imageByInchesWithName:self.isPortrait?@"newly_protrait_rotateCenterButtonImage_active":@"landscape_rotateCenterButtonImage_active"];
    }
    return _rotateCenterButtonImage_active;
}


@end

