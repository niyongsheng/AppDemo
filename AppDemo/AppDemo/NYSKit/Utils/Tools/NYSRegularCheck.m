//
//  NYSRegularCheck.m
//  NYS
//
//  Created by niyongsheng on 2021/8/18.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSRegularCheck.h"

@implementation NYSRegularCheck

#pragma 正则校验邮箱号
+ (BOOL)checkMailInput:(NSString *)mail {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

+ (BOOL)checkAouthCode:(NSString *)auth {
    
    auth = [auth stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *QQNum = @"[0-9]{6}";
    NSPredicate *QQTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",QQNum];
    
    return [QQTest evaluateWithObject:auth];
}

#pragma 正则校验手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber {
    
    telNumber = [telNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNumber length] != 11) {
        return NO;
    }
    
    /**
     * 规则 -- 更新日期 2017-03-30
     * 手机号码: 13[0-9], 14[5,7,9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     *
     * [数据卡]: 14号段以前为上网卡专属号段，如中国联通的是145，中国移动的是147,中国电信的是149等等。
     * [虚拟运营商]: 170[1700/1701/1702(电信)、1703/1705/1706(移动)、1704/1707/1708/1709(联通)]、171（联通）
     * [卫星通信]: 1349
     */
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147(数据卡),150,151,152,157,158,159,170[5],178,182,183,184,187,188
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[8])|(18[2-4,7-8]))\\d{8}|(170[5])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145(数据卡),155,156,170[4,7-9],171,175,176,185,186
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[156])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149(数据卡),153,170[0-2],173,177,180,181,189
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNumber];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNumber];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNumber];
    
    if (isMatch_CM || isMatch_CT || isMatch_CU) {
        return YES;
    }
    
    return NO;
}

#pragma 正则校验用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password {
    
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma 正则校验用户身份证号15或18位
+ (BOOL)checkUserIcyard: (NSString *) icyard {
    
    BOOL flag;
    if (icyard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [pred evaluateWithObject:icyard];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number {
    
    NSString *pattern = @"^[0-9]{12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}

#pragma 正则校验URL
+ (BOOL)checkURL : (NSString *) url {
    
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

#pragma 正则校验昵称
+ (BOOL)checkNickname:(NSString *) nickname {
    
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isMatch = [pred evaluateWithObject:nickname];
    return isMatch;
}

#pragma 正则校验以C开头的18位字符
+ (BOOL)checkCtooNumberTo18:(NSString *) nickNumber {
    
    NSString *nickNum=@"^C{1}[0-9]{18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNum];
    BOOL isMatch = [pred evaluateWithObject:nickNumber];
    return isMatch;
}
#pragma 正则校验以C开头字符
+ (BOOL)checkCtooNumber:(NSString *) nickNumber {
    
    NSString *nickNum=@"^C{1}[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNum];
    BOOL isMatch = [pred evaluateWithObject:nickNumber];
    return isMatch;
}
#pragma 正则校验银行卡号是否正确
+ (BOOL)checkBankNumber:(NSString *) bankNumber {
    
    NSString *bankNum=@"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:bankNumber];
    return isMatch;
}

#pragma 正则只能输入数字和字母
+ (BOOL)checkTeshuZifuNumber:(NSString *) CheJiaNumber {
    
    NSString *bankNum=@"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CheJiaNumber];
    return isMatch;
}

#pragma 车牌号验证
+ (BOOL)checkCarNumber:(NSString *) CarNumber {
    
    NSString *bankNum = @"^([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼A-Z]{1}[a-zA-Z](([DF]((?![IO])[a-zA-Z0-9](?![IO]))[0-9]{4})|([0-9]{5}[DF]))|[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂]{1})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CarNumber];
    return isMatch;
}

#pragma 正则只能输入汉字
+ (BOOL)checkChineseCharacters:(NSString *) name {
    
    if ([name length] <= 1) {
        return NO;
    }
    NSString *bankNum = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:name];
    return isMatch;
}

#pragma 正则验证金额数字
+ (BOOL)checkFloatMoney:(NSString *) money {
    
    NSString *moneyRegular = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,10}(([.]\\d{0,2})?)))?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moneyRegular];
    BOOL isMatch = [pred evaluateWithObject:money];
    return isMatch;
}

#pragma 正则验证精确到小数点后三位
+ (BOOL)checkThreeDecimalPlaces:(NSString *) value {
    
    NSString *valueRegular = @"(\\+|\\-)?(([0]|(0[.]\\d{0,3}))|([1-9]\\d{0,10}(([.]\\d{0,3})?)))?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",valueRegular];
    BOOL isMatch = [pred evaluateWithObject:value];
    return isMatch;
}

@end
