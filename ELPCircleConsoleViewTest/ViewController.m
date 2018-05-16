//
//  ViewController.m
//  ELPCircleConsoleViewTest
//
//  Created by ElsonPeng on 2018/3/2.
//  Copyright © 2018年 ElsonPeng. All rights reserved.
//

#import "ViewController.h"
#import "ELPCircleConsoleView.h"

@interface ViewController ()<ELPCircleConsoleMoveDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    ELPCircleConsoleView *gradleView = [[ELPCircleConsoleView alloc]init];
    gradleView.delegate = self;
    gradleView.frame = CGRectMake(100, 200, 250, 250);
    [self.view addSubview:gradleView];

}

-(void)rotateCircleView:(ELPCircleConsoleView *)rotetaCircleView didRotateWithValueX:(NSString *)Xstr valueY:(NSString *)Ystr stop:(BOOL)needStop moveDirection:(ELPCircleConsoleMoveDirection)orientation{
    
    //TODO for your own action method
    if(orientation == ELPCircleConsoleMoveDirectionUp){
        NSLog(@"rotate to up");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionDown){
        NSLog(@"rotate to down");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionLeft){
        NSLog(@"rotate to left");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionRight){
        NSLog(@"rotate to right");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionUpStop){
        NSLog(@"stop the priori direction method and turn to up");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionDownStop){
        NSLog(@"stop the priori direction method and turn to down");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionLeftStop){
        NSLog(@"stop the priori direction method and turn to left");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionRightStop){
        NSLog(@"stop the priori direction method and turn to right");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
