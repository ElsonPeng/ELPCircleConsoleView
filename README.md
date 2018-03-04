# ELPCircleConsoleView
iOS操纵控制方向圆盘
在各类游戏中，都可以看到操纵游戏人物运动的圆盘，该程序就是简单实现这个控制功能。

使用方法如下：

引用："ELPCircleConsoleView.h"
添加：<ELPCircleConsoleMoveDelegate>
 
- (void)viewDidLoad {
    [super viewDidLoad];
    ELPCircleConsoleView *gradleView = [[ELPCircleConsoleView alloc]init];
    gradleView.frame = CGRectMake(100, 200, 250, 250);
    gradleView.delegate = self;
    [self.view addSubview:gradleView];
 }

-(void)rotateCircleView:(ELPCircleConsoleView *)rotetaCircleView didRotateWithValueX:(NSString *)Xstr valueY:(NSString *)Ystr stop:(BOOL)needStop moveDirection:(ELPCircleConsoleMoveDirection)orientation{
    
    //TODO for your action
    if(orientation == ELPCircleConsoleMoveDirectionUp){
        NSLog(@"rotate in up");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionDown){
        NSLog(@"rotate in down");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionLeft){
        NSLog(@"rotate in left");
    }
    else if(orientation == ELPCircleConsoleMoveDirectionRight){
        NSLog(@"rotate in right");
    }    
}


可以根据自己项目需要，修改ELPCircleRotateImageAsset中的文件，来做相应样式的变化

界面效果如下：
![Alt text](https://github.com/ElsonPeng/ELPCircleConsoleView/blob/master/ELPCircleConsoleViewTest/screenshot/screenshot1.png)
