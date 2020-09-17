## Auto Fill:
#### 1、设置 TextField ContentType

类目 | UIKit | ContentType | Remark
------------ | ------------- | ------------- | -------------
用户名 | TextField | UserName | no
 密码  | TextField | Password | no
新密码 | TextField | New Password | no
验证码 | TextField | One Time Code | no

<img src="https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/AppDemoScreenshot/autofill/1542848152504.jpg" width="670" height="400">

#### 2、设置 apple-app-site-association
   > 需要一个支持HTTPS的网站在根目录下存放，`apple-app-site-association`文件。
   如果没有可以利用GitHub Pages挂载，步骤如下：
   
  * 2.1、Fork我的GitHub Pages
   > https://niyongsheng.github.io
  <img src="https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/AppDemoScreenshot/autofill/1542767161015.jpg" width="670" height="370">
  
  * 2.2、修改成自己的域名
  <img src="https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/AppDemoScreenshot/autofill/1542767303721.jpg" width="670" height="370">
  
  * 2.3、验证https://niyongsheng.github.io
  <img src="https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/AppDemoScreenshot/autofill/WX20181121-115649.png" width="670" height="370">
  
#### 3、修改apple-app-site-association文件
> [apple-app-site-association](AppDemo/apple-app-site-association)
```JSON
{
   "webcredentials":{
      // ${Prefix} Prefix, ${BundleID} Bundle ID ,如果有多个APP依次增加.
      "apps":["${Prefix}.${BundleID}"],
      "apps":["${Prefix1}.${BundleID2}"],
      "apps":["${Prefix2}.${BundleID3}"]
   }
}
```
<img src="https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/AppDemoScreenshot/autofill/1542767468091.jpg" width="670" height="370">
<img src="https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/AppDemoScreenshot/autofill/1542768385014.jpg" width="670" height="370">
  
#### 4、设置 Associated Domains
<img src="https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/AppDemoScreenshot/autofill/1542766863012.jpg" width="670" height="370">
  
#### 6、自动生成密码
```objc
self.nameField.textContentType = UITextContentTypeUsername;
if (@available(iOS 12.0, *)) {
    self.passwordField.textContentType = UITextContentTypeNewPassword;
    self.passwordField.passwordRules = [UITextInputPasswordRules passwordRulesWithDescriptor:@"required: lower; required: upper; allowe: digit; required: [-]; minlength: 6; maxlength: 16;"];

} else {
    self.passwordField.textContentType = UITextContentTypePassword;
}
```
* Password Rules Validation Tool: 
https://developer.apple.com/password-rules/

#### 7、官方文档
<img src="https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/AppDemoScreenshot/autofill/1542768418585.jpg" width="670" height="370">
https://developer.apple.com/videos/play/wwdc2017/206/
https://developer.apple.com/documentation/uikit/uitextcontenttype
