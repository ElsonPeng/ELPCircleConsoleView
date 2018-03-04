# ELPCircleConsoleView
iOS操纵控制方向圆盘
在各类游戏中，都可以看到操纵游戏人物运动的圆盘，该程序就是简单实现这个控制功能。

使用方法如下：

引用："ELPCircleConsoleView.h"
添加：<ELPCircleConsoleMoveDelegate>

    ELPCircleConsoleView *gradleView = [[ELPCircleConsoleView alloc]init];
    gradleView.frame = CGRectMake(100, 200, 250, 250);
    [self.view addSubview:gradleView];

可以根据自己项目需要，修改ELPCircleRotateImageAsset中的文件，来做相应样式的变化

界面效果如下：
![Alt text](https://github.com/ElsonPeng/ELPCircleConsoleView/blob/master/ELPCircleConsoleViewTest/screenshot/screenshot1.png)
