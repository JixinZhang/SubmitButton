# SubmitButton
SubmitButton animation，design by [ColinGarven](https://dribbble.com/shots/1426764-Submit-Button) on dribbble。

##1.Demonstration
- Click "Submit” to start animation;


###(1) Loading completed, and the result is success

![submit_button_succeed](https://github.com/JixinZhang/SubmitButton/blob/master/submit_button_succeed.gif)

###(2) Loading completed, and the result is failure

![submit_button_failed](https://github.com/JixinZhang/SubmitButton/blob/master/submit_button_failed.gif)

##2.How to use
Drag the following four files to your project.

```
SubmitButtonView.h
SubmitButtonView.m
SubmitButtonLayer.h
SubmitButtonLayer.m

```


###(0) Import header file

```
#import "SubmitButtonView.h"

```

###(1) Initialization

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

###(2) Loading process, assign value to progress
case `SubmitButtonStatus == SubmitButtonStatusStart`  send a network request and then call `- (void)loadingProgressAnimationWithProgress:(CGFloat)progress` method to assign values to progress.

###(3) Loading completed, assign value to result
call `- (void)setFinalResultWith:(BOOL)result`

```
__weak typeof (self)wSelf = self;
self.submitBtnView.block = ^(SubmitButtonStatus submitBtnStatus){
    switch (submitBtnStatus) {
        case SubmitButtonStatusStart:
            //1.Send a network request
            [wSelf startLoad];
            //2.Assign value to progress
            [wSelf.submitBtnView loadingProgressAnimationWithProgress:wSelf.progress];
            //3.assign value to result(YES/NO)
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






