//
//  UtilsMacros.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h

// 全局block
typedef void(^NYSBlock)(id obj);

// 获取系统对象
#define NApplication        [UIApplication sharedApplication]
#define NAppWindow          [UIApplication sharedApplication].delegate.window
#define NAppDelegate        [AppDelegate shareAppDelegate]
#define NRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define NUserDefaults       [NSUserDefaults standardUserDefaults]
#define NNotificationCenter [NSNotificationCenter defaultCenter]
// 发送通知
#define NPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

// 获取屏幕宽高
#define NScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define NScreenHeight [[UIScreen mainScreen] bounds].size.height
#define NScreen_Bounds [UIScreen mainScreen].bounds

#define Iphone6ScaleWidth NScreenWidth/375.0
#define Iphone6ScaleHeight NScreenHeight/667.0
// 根据ip6的屏幕来拉伸
#define RealValue(x) (x*(NScreenWidth/375.0))
// 判断iphoneX
#define isIphonex ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

// 状态栏高度
#define NStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define NGetNavBarHight \
({\
CGRect rectNav = self.navigationController.navigationBar.frame;\
(rectNav.size.height);\
})\

#define NNavBarHeight 44.0
#define NTabBarHeight (isIphonex ? 83 : 49)
#define NTopHeight (NStatusBarHeight + NNavBarHeight)
#define NBottomHeight (isIphonex ? 34 : 0)

// 强弱引用
#define NWeakSelf(type)  __weak typeof(type) weak##type = type;
#define NStrongSelf(type) __strong typeof(type) type = weak##type;

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf) __strong __typeof(&*self)strongSelf = self;

// View 圆角和加边框
#define ViewBorderRadius(View, NRadius, Width, Color)\
\
[View.layer setCornerRadius:(NRadius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, NRadius)\
\
[View.layer setCornerRadius:(NRadius)];\
[View.layer setMasksToBounds:YES]

// IOS 版本判断
#define IOSAVAILABLEVERSION(version) ([[UIDevice currentDevice] availableVersion:version] < 0)
// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion].floatValue
// 当前语言
#define CurrentLanguage ([NSLocale preferredLanguages] objectAtIndex:0])
// APP版本
#define CurrentAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 随机色生成
#define NRandomColor RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
// UIColor(hex)
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define UIColorfFollowHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]

#define RGBColor(r, g, b) RGBAColor(r, g, b, 1.0)
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 字体
#define BOLDSYSTEMFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)     [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 定义UIImage对象
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define IMAGE_NAMED(name) [UIImage imageNamed:name]

// 拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

// 数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

// 获取一段时间间隔
#define StartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define EndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)

// 单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

//-------------------打印日志-------------------------
// 打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)
// DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define NLog(format, ...) printf("^^类名:<地址:%p 控制器:%s:(行号:%d) > \n^^方法名:%s \n^^打印内容:%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else
#define NLog(format, ...)
#endif

// DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#define NDLog(fmt, ...) { UIAlertController* alert = [UIAlertController alertControllerWithTitle:\
                            [NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__]\
                            message:[NSString stringWithFormat:fmt, ##__VA_ARGS__] preferredStyle:UIAlertControllerStyleAlert];\
                            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];\
                            [NRootViewController presentViewController:alert animated:YES completion:nil];}
#else
#define NDLog(fmt, ...)
#endif

#endif /* UtilsMacros_h */
