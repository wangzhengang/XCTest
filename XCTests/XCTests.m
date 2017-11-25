//
//  XCTests.m
//  XCTests
//
//  Created by iron on 2017/11/25.
//  Copyright © 2017年 wangzhengang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface XCTests : XCTestCase

@end

@implementation XCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"test start"); ///#开始测试
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    NSLog(@"test end");///#结束测试
}

///# 其他任何方法都会在 - (void)setUp  和  - (void)tearDown 调用

- (void)testFunc {
    NSLog(@"test func");
    
    //实例化测试对象
    ViewController *vc = [[ViewController alloc] init];
    //获取测试结果
    NSString *md5 = [vc md5HexDigest:@"123456"];
    //使用断言测试
    XCTAssert(md5.length < 64, "字符串必须小于32");///#断言失败，测试过程就会停在这里
}

- (void)testPerformanceExample {
    NSLog(@"性能测试");
    [self measureBlock:^{  ///#用来分析代码执行的时间，log会打印在 console 里，同时本地也会有一份日志
        //实例化测试对象
        ///#测试那个类里的方法就要引入那个类
        ViewController *vc = [[ViewController alloc] init];
        //#调用测试方法获取测试结果
        [vc performanceExample];
    }];
}


- (void)testFanyiNetworkRequest {
    //// “执行顺序：” 表示代码执行顺序
    
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
}





@end
