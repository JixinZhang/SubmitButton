# SubmitButton
一个SubmitButton动画，设计稿[传送门](https://dribbble.com/shots/1426764-Submit-Button)。

##演示
- 点击“Submit”开始动画；
- Loading过程的progress由外部传入；
- 加载完成的结果（成功/失败）也由外部传入。


###1.	加载完成，结果为成功

![submit_button_succeed](https://github.com/JixinZhang/SubmitButton/blob/master/submit_button_succeed.gif)

###2. 加载完成，结果为失败

![submit_button_failed](https://github.com/JixinZhang/SubmitButton/blob/master/submit_button_failed.gif)

##使用
将SubmitButtonView.h，SubmitButtonView.m和SubmitButtonLayer.h，SubmitButtonLayer.m拖曳到工程里。

###0. 导入头文件

```
#import "SubmitButtonView.h"

```

###1. 初始化

```
self.submitBtnView = [[SubmitButtonView alloc] initWithFrame:CGRectMake(100, 200, 200, 60)];
__weak typeof (self)wSelf = self;
self.submitBtnView.block = ^(SubmitButtonStatus submitBtnStatus){
    switch (submitBtnStatus) {
        case SubmitButtonStatusStart:
            
            break;
            
        case SubmitButtonStatusEnd:
            
            break;
            
        default:
            break;
    }
};
[self.view addSubview:self.submitBtnView];
```

###2. Loading过程的progress赋值
在SubmitButtonStatus == SubmitButtonStatusStart时发送网络请求，并且调用`- (void)loadingProgressAnimationWithProgress:(CGFloat)progress`方法给loading过程的progress赋值
###3. 加载完成后结果赋值
加载完成后调用`- (void)setFinalResultWith:(BOOL)result`方法赋值

```
__weak typeof (self)wSelf = self;
self.submitBtnView.block = ^(SubmitButtonStatus submitBtnStatus){
    switch (submitBtnStatus) {
        case SubmitButtonStatusStart:
            //发送网络请求
            [wSelf startLoad];
            //给loading赋值
            [wSelf.submitBtnView loadingProgressAnimationWithProgress:wSelf.progress];
            //加载完成后，赋值YES/NO
            if (wSelf.progress == 1) {
    	        [wSelf.submitBtnView setFinalResultWith:NO];
            }
            break;
            
        case SubmitButtonStatusEnd:
            
            break;
            
        default:
            break;
    }
};

```






