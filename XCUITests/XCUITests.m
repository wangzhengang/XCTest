//
//  XCUITests.m
//  XCUITests
//
//  Created by iron on 2017/11/25.
//  Copyright © 2017年 wangzhengang. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCUITests : XCTestCase

@end

@implementation XCUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];///为app对象分配内存并启动它
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    ///UITest的测试代码能最大限度的解放测试妹妹的双手，当然也会给程序员带来巨大工作量，完整的测试代码估计是项目代码的两倍
    ///自行百度 Xcode Coverage 查看测试代码覆盖率
    
    
    ///这里的UItest代码最好自己写，录制完整测试代码在项目里不可行，毕竟项目的各种view层级是比较复杂的，会录出来一堆错误的代码，同时电脑也扛不住，Xcode会crash的。
    ///而完全靠自己写代码寻找XCUIElement也是很头疼的，view的层级复杂到山重水复疑无路，
    ///最好是，把录制测试代码的手段用在寻找XCUIElement上，而关于XCUIElement的其他tap()等事件代码最好自己写。
    ///如下示例，为了能寻找到textView我也是拼了，从window一路寻找下去，window儿子view的儿子view的儿子view的儿子view的儿子view的儿子view的view就是textView。
    // 示例 ：XCUIElement *textView = [[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextView].element;
    
    
    
    XCUIElement *button1 = [[XCUIApplication alloc] init].buttons[@"1111"];
    XCUIElement *button2 = [[XCUIApplication alloc] init].buttons[@"2222"];///获取名字为2222的按钮
    XCUIElement *button3 = [[XCUIApplication alloc] init].buttons[@"3333"];
    XCUIElement *button4 = [[XCUIApplication alloc] init].buttons[@"4444"];
    XCUIElement *button5 = [[XCUIApplication alloc] init].buttons[@"5555"];
    XCUIElement *button6 = [[XCUIApplication alloc] init].buttons[@"6666"];
    
    XCTAssertTrue(button1.exists, @"'1111'按钮存在");///#值为true才能通过，为false会停在这里
    XCTAssertTrue(button2.exists, @"'2222'按钮存在");///#值为true才能通过，为false会停在这里
    XCTAssertTrue(button3.exists, @"'3333'按钮存在");///#值为true才能通过，为false会停在这里
    XCTAssertTrue(button4.exists, @"'4444'按钮存在");///#值为true才能通过，为false会停在这里
    XCTAssertTrue(button5.exists, @"'5555'按钮存在");///#值为true才能通过，为false会停在这里
    XCTAssertTrue(button6.exists, @"'6666'按钮存在");///#值为true才能通过，为false会停在这里
    
    [button1 tap];///触发按钮的点击事件
    [button2 tap];
    [button3 tap];
    [button4 tap];
    [button5 tap];
    [button6 tap];
    [button5 tap];
    [button4 tap];
    [button3 tap];
    [button2 tap];
    [button1 tap];
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


@end
