//
//  ELPCircleConsoleView.h
//  ELPCircleConsoleViewTest
//
//  Created by 彭成龙 on 2018/3/2.
//  Copyright © 2018年 ElsonPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ELPCircleConsoleMoveDirection) {
    ELPCircleConsoleMoveDirectionUp,
    ELPCircleConsoleMoveDirectionDown,
    ELPCircleConsoleMoveDirectionLeft,
    ELPCircleConsoleMoveDirectionRight,
    ELPCircleConsoleMoveDirectionNone,
    ELPCircleConsoleMoveDirectionStop,
    ELPCircleConsoleMoveDirectionLeftStop,
    ELPCircleConsoleMoveDirectionRightStop,
    ELPCircleConsoleMoveDirectionUpStop,
    ELPCircleConsoleMoveDirectionDownStop
};

@class ELPCircleConsoleView;

@protocol ELPCircleConsoleMoveDelegate <NSObject>

@optional
- (void)rotateCircleView:(ELPCircleConsoleView *)rotetaCircleView didRotateWithValueX:(NSString *)Xstr valueY:(NSString *)Ystr stop:(BOOL)needStop moveDirection:(ELPCircleConsoleMoveDirection)orientation;
@end

@interface ELPCircleConsoleView : UIView

@property (nonatomic, weak) id <ELPCircleConsoleMoveDelegate>delegate;

@property (nonatomic, assign) BOOL isPortrait;

-(instancetype)initWithOritention:(BOOL)isProtrait;

@end
