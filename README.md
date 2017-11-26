# XCTest
iOS自动化单元测试示例

## 一、前言： ##
UITest的单元测试能最大限度的解放测试妹妹的双手，当然也会给程序员带来巨大工作量，完整的测试代码估计是项目代码的两倍，另外大家可以自行百度 Xcode Coverage 查看测试代码覆盖率，这篇文章只讲如何在工程中用XCTest框架做单元测试。
其中主要介绍了，用六个按钮示意的UITests使用和性能测试、异步测试的。
## 二、创建工程： ##
先创建个名字为 XCTest 的示例工程：
![这里写图片描述](http://img.blog.csdn.net/20171125144804085?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
这里要说明一下如果当初创建工程时未勾选上`Include Unit Tests` 和 `Include UI Test` 这两个复选框，可在项目工程根目录下手动创建 Tests 、UITests文件夹，如下图示例：
![这里写图片描述](http://img.blog.csdn.net/20171125145138564?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
这里的"XC"是工程名字，XCTests，UITests这两个文件夹下的Info.plist 是一模一样的，里面包含的 key value 和app里的 Info.plist 是一样的，即：
![这里写图片描述](http://img.blog.csdn.net/20171125145607819?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
![这里写图片描述](http://img.blog.csdn.net/20171125145636399?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## 三、代码解释： ##
**1、接下来看看具体代码：**
我们可以在 XCTests.m  XCUITests.m 中发现一些共同的方法：

```
- (void)setUp {  …  }
```

```
- (void)tearDown {  …  }
```

**2、方法的意义：**
将要开始执行测试代码时调用：    `- (void)setUp {  …  }` ，
测试代码执行完后调用，测试失败不调用： `- (void)tearDown {  …  }`，
其他任何方法都会在 `- (void)setUp`  和  `- (void)tearDown` 调用。
所有的测试类类名都以Tests结尾，同样类中所有的测试方法也都以`- (void)test` 开头。

**3、获取app启动对象：**
```
[[[XCUIApplication alloc] init] launch];///为app对象分配内存并启动它
```

**4、其他：**
UI测试示例代码：

```
XCUIElement *button1 = [[XCUIApplication alloc] init].buttons[@"1111"];///获取名字为2222的按钮
    XCTAssertTrue(button1.exists, @"'1111'按钮存在");///#值为true才能通过，为false会停在这里
    [button1 tap];///触发按钮的点击事件
```

性能测试示例代码：
```
    NSLog(@"性能测试");
    [self measureBlock:^{  ///#用来分析代码执行的时间，log会打印在 console 里，同时本地也会有一份日志
        //实例化测试对象
        ///#测试那个类里的方法就要引入那个类
        ViewController *vc = [[ViewController alloc] init];
        //#调用测试方法获取测试结果
        [vc performanceExample];
    }];


```
异步测试示例代码：
注意其中的“执行顺序1、2、3、4”
```
 XCTestExpectation *expectation = [self expectationWithDescription:@"百度翻译 测试"];
    NSLog(@"执行顺序：1");
    ///请求参数
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:@"apple"  forKey:@"q"];
    [paramer setValue:@"en"     forKey:@"from"];
    [paramer setValue:@"zh"     forKey:@"to"];
    [paramer setValue:@"2015063000000001"   forKey:@"appid"];
    [paramer setValue:@"1435660288"         forKey:@"salt"];
    [paramer setValue:@"f89f9594663708c1605f3d736d01d2d4"     forKey:@"sign"];
    ///开始请求
    [ViewController networkRequestWithAPI:@"https://api.fanyi.baidu.com/api/trans/vip/translate" requestMethod:@"POST" cachePolicy:NSURLRequestUseProtocolCachePolicy requestParamer:paramer Completion:^(NSDictionary * _Nullable result, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [expectation fulfill];///调用fulfill后 waitForExpectationsWithTimeout 会结束等待
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        XCTAssertTrue(httpResponse.statusCode==200, @"接口请求成功");///200表明http请求成功，请求失败会停在这里
        XCTAssertNotNil(result, @"json 对象不为空");///result结果为nil，会停在这里
        XCTAssertNil(error, @"请求没有出错");//error 不为nil，会停在这里
        NSLog(@"执行顺序：3");
    }];
    NSLog(@"执行顺序：2");
    ///因为接口设置的是30秒超时，所以这里也设置30秒，意思就是这个线程最多等待30秒，
    [self waitForExpectationsWithTimeout:30.f handler:^(NSError * _Nullable error) {
        NSLog(@"执行顺序：4");
        if (error) {
            ///测试代码无异常
        } else {
            ///测试代码有异常
        }
    }];
```

![这里写图片描述](http://img.blog.csdn.net/20171125150219470?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![这里写图片描述](http://img.blog.csdn.net/20171125151009559?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![这里写图片描述](http://img.blog.csdn.net/20171125151115126?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## 四、图标解释： ##

**1、测试前的图标：**
![这里写图片描述](http://img.blog.csdn.net/20171125152016034?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)   这个图标出现在所有以 `- (void)test` 开头的方法前，这个是将要开始测试前的按钮状态图标，一旦点击就开始测试这个方法里的内容，或者我们也可以通过 *command+U* 的快捷键启动完整测试，完整测试会执行 Tests 和 UITests 下所有的测试类和类中所有的测试方法。

**2、测试成功图标：**
![这里写图片描述](http://img.blog.csdn.net/20171125152821571?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast) 
绿色代表测试成功，同时xcode 也会弹框提示，
![这里写图片描述](http://img.blog.csdn.net/20171125152910929?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

**3、测试失败：**
![这里写图片描述](http://img.blog.csdn.net/20171125152953328?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
表示某个测试方法测试失败，同时进程也会停在测试未通过的代码那。
![这里写图片描述](http://img.blog.csdn.net/20171125153105074?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvemhlbmdhbmcwMDc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## 五、断言注释： ##

```
XCTFail(format…) //生成一个失败的测试;
 XCTFail(@”Fail”);

 XCTAssertNil(a1, format…) //为空判断， a1 为空时通过，反之不通过;
 XCTAssertNil(@”not nil string”, @”string must be nil”);

 XCTAssertNotNil(a1, format…) //不为空判断，a1不为空时通过，反之不通过；
 XCTAssertNotNil(@”not nil string”, @”string can not be nil”);

 XCTAssert(expression, format…) //当expression求值为TRUE时通过；
 XCTAssert((2 > 2), @”expression must be true”);

 XCTAssertTrue(expression, format…) //当expression求值为TRUE时通过；
 XCTAssertTrue(1, @”Can not be zero”);

 XCTAssertFalse(expression, format…) //当expression求值为False时通过；
 XCTAssertFalse((2 < 2), @”expression must be false”);

 XCTAssertEqualObjects(a1, a2, format…) //判断相等， [a1 isEqual:a2] 值为TRUE时通过，其中一个不为空时，不通过；
 XCTAssertEqualObjects(@”1″, @”1″, @”[a1 isEqual:a2] should return YES”);
 XCTAssertEqualObjects(@”1″, @”2″, @”[a1 isEqual:a2] should return YES”);

 XCTAssertNotEqualObjects(a1, a2, format…) //判断不等， [a1 isEqual:a2] 值为False时通过，
 XCTAssertNotEqualObjects(@”1″, @”1″, @”[a1 isEqual:a2] should return NO”);
 XCTAssertNotEqualObjects(@”1″, @”2″, @”[a1 isEqual:a2] should return NO”);

 XCTAssertEqual(a1, a2, format…) //判断相等（当a1和a2是 C语言标量、结构体或联合体时使用,实际测试发现NSString也可以）；
 XCTAssertNotEqual(a1, a2, format…) //判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）;

 XCTAssertEqualWithAccuracy(a1, a2, accuracy, format…) 判断相等，（double或float类型）//提供一个误差范围，当在误差范围（+/- accuracy ）以内相等时通过测试;
 XCTAssertEqualWithAccuracy(1.0f, 1.5f, 0.25f, @”a1 = a2 in accuracy should return YES”);

 XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format…) 判断不等，（double或float类型）//提供一个误差范围，当在误差范围以内不等时通过测试;
 XCTAssertNotEqualWithAccuracy(1.0f, 1.5f, 0.25f, @”a1 = a2 in accuracy should return NO”);

 XCTAssertThrows(expression, format…) //异常测试，当expression发生异常时通过；反之不通过；
 XCTAssertThrowsSpecific(expression, specificException, format…) //异常测试，当expression发生 specificException 异常时通过；反之发生其他异常或不发生异常均不通过;
 XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format…) //异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过;
 XCTAssertNoThrow(expression, format…) //异常测试，当expression没有发生异常时通过测试；
 XCTAssertNoThrowSpecific(expression, specificException, format…)//异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过;
 XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format…) //异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过;


 //下面介绍一下测试元素的语法

 XCUIApplication：
 //继承XCUIElement，这个类掌管应用程序的生命周期，里面包含两个主要方法
 launch():
 //启动程序
 terminate()
 //终止程序

 XCUIElement
 //继承NSObject，实现协议XCUIElementAttributes, XCUIElementTypeQueryProvider
 //可以表示系统的各种UI元素
 .exist
 //可以让你判断当前的UI元素是否存在，如果对一个不存在的元素进行操作，会导致测试组件抛出异常并中断测试
 descendantsMatchingType(type:XCUIElementType)->XCUIElementQuery
 //取某种类型的元素以及它的子类集合
 childrenMatchingType(type:XCUIElementType)->XCUIElementQuery
 //取某种类型的元素集合，不包含它的子类

 //这两个方法的区别在于，你仅使用系统的UIButton时，用childrenMatchingType就可以了，如果你还希望查询自己定义的子Button，就要用descendantsMatchingType

 //另外UI元素还有一些交互方法
 tap()
 //点击
 doubleTap()
 //双击
 pressForDuration(duration: NSTimeInterval)
 //长按一段时间，在你需要进行延时操作时，这个就派上用场了
 swipeUp()
 //这个响应不了pan手势，暂时没发现能用在什么地方，也可能是beta版的bug，先不解释
 typeText(text: String)
 //用于textField和textView输入文本时使用，使用前要确保文本框获得输入焦点，可以使用tap()函数使其获得焦点

 XCUIElementAttributes协议
 //里面包含了UIAccessibility中的部分属性
```

## 五、结尾：##
如果大家觉得这篇文章和示例工程代码有用的话，点个赞，在github 上给个小星星，多谢。
博客地址：http://blog.csdn.net/zhengang007/
