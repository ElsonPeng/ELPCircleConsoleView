# ELPCircleConsoleView
iOS操纵控制方向圆盘
在各类游戏中，都可以看到操纵游戏人物运动的圆盘，该程序就是简单实现这个控制功能。

使用方法如下：<br/>
1.在项目中添加如下5个文件:<br/>
ELPCircleConsoleView.h 和 ELPCircleConsoleView.m<br/>
UIView+Sizes.h 和 UIView+Sizes.m<br/>
ELPCircleRotateImageAsset<br/>

2.引用："ELPCircleConsoleView.h"
添加：<ELPCircleConsoleMoveDelegate>
 
    ELPCircleConsoleView *gradleView = [[ELPCircleConsoleView alloc]init];
    gradleView.frame = CGRectMake(100, 200, 250, 250);
    gradleView.delegate = self;
    [self.view addSubview:gradleView];
    
3.实现ELPCircleConsoleMoveDelegate中的rotateCircleView方法，对方向的返回值做相应的业务处理


可以根据自己项目需要，修改ELPCircleRotateImageAsset中的文件，来做相应样式的变化

界面效果如下：
![Alt text](https://github.com/ElsonPeng/ELPCircleConsoleView/blob/master/ELPCircleConsoleViewTest/screenshot/screenshot3.png)
