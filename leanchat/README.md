![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/LeanChatLib.svg?style=flat)](http://cocoapods.org/?q=LeanChatLib)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/LeanChatLib.svg?style=flat)](http://cocoapods.org/?q=LeanChatLib)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)

![leanchat](https://cloud.githubusercontent.com/assets/5022872/8431636/4eff0aca-1f6d-11e5-8728-f8f450dac380.gif)
 
## App Store  
LeanChat 已经在 App Store 上架，可前往 https://itunes.apple.com/gb/app/leanchat/id943324553 或在 App Store 上搜 LeanChat。
 
## 介绍
这个示例项目全面展示了 LeanCloud 实时通讯功能的应用，但含杂着许多 UI 代码和其它功能，并不适合快速上手学习，如果你第一次接触 LeanMessage，更推荐 [LeanMessage-Demo](https://github.com/leancloud/LeanMessage-Demo) 项目。等熟悉了之后，可前往 [LeanCloud-Demos](https://github.com/leancloud/leancloud-demos) 挑选你喜欢的 IM 皮肤进行集成。集成的过程中，若遇到疑难问题，不妨再来参考 LeanChat 项目。

## LeanChat 项目构成

* [leanchat-android](https://github.com/leancloud/leanchat-android)，Android 客户端
* [leanchat-ios](https://github.com/leancloud/leanchat-ios)，iOS 客户端
* [leanchat-webapp](https://github.com/leancloud/leanchat-webapp)，Web 客户端
* [leanchat-cloud-code](https://github.com/leancloud/leanchat-cloudcode)，服务端

## 宝贵意见

如果有任何问题，欢迎提 [issue](https://github.com/leancloud/leanchat-ios/issues)，写上你不明白的地方，看到后会尽快给予帮助。

## 下载
请直接点击 Github 上的`Download Zip`，如图所示，这样只下载最新版。如果是 `git clone`，则可能非常慢，因为含杂很大的提交历史。某次测试两者是1.5M:40M。

![qq20150618-2 2x](https://cloud.githubusercontent.com/assets/5022872/8223520/4c25415a-15ab-11e5-912d-b5dab916ce86.png)

## 运行
```bash
  // LeanChat (复杂例子)
  cd LeanChat
  pod install --verbose  // 如果本地有 AVOSCloud 依赖库，可加选项 --no-repo-update 加快速度
  open LeanChat.workspace
  
  // LeanChatExample (简单例子)
  cd LeanChatExample
  pod install --verbose --no-repo-update
  open LeanChatExample.xcworkspace

  // LeanChatSwift (Swift 例子)
  cd LeanChatSwift
  pod install --verbose --no-repo-update
  open LeanChatSwift.xcworkspace
  
  // LeanChatLib (封装了 LeanCloud 通信组件 和 UI 的库)
  cd LeanChatLib
  pod install --verbose --no-repo-update
  open LeanChatLib.xcworkspace
```

若遇到`definition of 'AVUser' must be imported from module 'LeanChatLib.CDChatListVC' before it is required` 类似的问题，可在菜单 Product 按住 Option ，点击 [Clean Build Folder](http://stackoverflow.com/questions/8087065/xcode-4-clean-vs-clean-build-folder)，清空掉所有 Build 文件，重新编译即可。此问题似乎是 Cocoapods 在进行复杂编译的时候出现的Bug。具体可以看这个 [Gif](https://cloud.githubusercontent.com/assets/5022872/9230256/cf822fe4-4153-11e5-876d-ed819babad89.gif)。

请注意因为默认使用了生产证书，开发的时候，离线消息是没有推送的。而线上版本是有推送的，可到 [App Store](https://itunes.apple.com/gb/app/leanchat/id943324553 ) 上下载。具体也可参考这个 [issue](https://github.com/leancloud/leanchat-ios/issues/40)。

这里可以看到三个项目，介绍如下。

## 子项目介绍
* LeanChatLib ，核心的聊天逻辑和聊天界面库。有了它，可以快速集成聊天功能，支持文字、音频、图片、表情消息，消息通知。同时也有相应的 [Android 版本](https://github.com/leancloud/leanchat-android)。
* LeanChatExample，leanchatlib 最简单的使用例子。展示了如何用少量代码调用 LeanChatLib 来加入聊天，无论是用 LeanCloud 的用户系统还是自己的用户系统。
* LeanChat-ios，为 LeanChat 整个应用。它包含好友管理、群组管理、地理消息、附近的人、个人页面、登录注册的功能，完全基于 LeanCloud 的存储和通信功能。它也是对 LeanChatLib 更复杂的应用。

## LeanChatLib 介绍

封装了最近对话页面和聊天页面，LeanChat 和 LeanChatExample 项目都依赖于它。可通过以下方式安装，
```
    pod 'LeanChatLib'
```

大多数时候，你会采用拖动源代码的方式集成 LeanChatLib，这时，先需要安装 `AVOSCloud.framework` 和 `AVOSCloudIM.framework`，如果不是用 `pod install 'AVOSCloud'`、`pod install 'AVOSCloudIM'` 来安装的话，则可根据LeanCloud [Quick Start Guide](https://leancloud.cn/docs/start.html) 配置一下 SDK 所需的Framework。同时安装另外两个依赖库`JSBadgeView` 与 `DateTools`。在` pod install ` 运行本 Demo 的时候，会有 Pods 目录生成，可以从中找到这两个Pods。或者网上搜索一下。另外可以通过 [.podspec 文件](https://github.com/leancloud/leanchat-ios/blob/master/LeanChatLib.podspec#L9)来配置，podspec 描述了需要集成哪些源文件、引入哪些系统 framework 等等。或请参考这个[工单](https://ticket.leancloud.cn/tickets/7666)。

## 如何三步加入IM
1. LeanCloud 中创建应用       
2. 加入 LeanChatLib 的 pod 依赖，或拖动 LeanChatLib 的代码文件进项目，改 UI 和调整功能方便些。
3. 依次在合适的地方加入以下代码，

应用启动后，初始化，以及配置 IM User

```objc
    [AVOSCloud setApplicationId:@"YourAppId" clientKey:@"YourAppKey"];
    [CDChatManager manager].userDelegate = [[CDUserFactory alloc] init];
```

配置一个 UserFactory，遵守 CDUserDelegate协议即可。

```objc
#import "CDUserFactory.h"

#import <LeanChatLib/LeanChatLib.h>

@interface CDUserFactory ()<CDUserDelegate>

@end

@implementation CDUserFactory

#pragma mark - CDUserDelegate
- (void)cacheUserByIds:(NSSet *)userIds block:(AVIMArrayResultBlock)block{
    block(nil,nil); // don't forget it
}

- (id<CDUserModelDelegate>)getUserById:(NSString *)userId {
    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    user.username = userId;
    user.avatarUrl = @"http://image17-c.poco.cn/mypoco/myphoto/20151211/16/17338872420151211164742047.png";
    return user;
}

@end

```

这里的 CDUser 是应用内的User对象，你可以在你的 User 对象实现 CDUserModelDelegate 协议即可。


 CDUserModelDelegate 协议内容如下：

```objc
@protocol CDUserModelDelegate <NSObject>

@required

- (NSString*)userId;

- (NSString*)avatarUrl;

- (NSString*)username;

@end
```

登录时调用：


```objc
        [[CDChatManager manager] openWithClientId:selfId callback: ^(BOOL succeeded, NSError *error) {
            if (error) {
                DLog(@"%@", error);
            }
            else {
               //go Main Controller
            }
        }];
```

和某人聊天：

```objc
        [[CDChatManager manager] fetchConversationWithOtherId : otherId callback : ^(AVIMConversation *conversation, NSError *error) {
            if (error) {
                DLog(@"%@", error);
            }
            else {
                LCEChatRoomVC *chatRoomVC = [[LCEChatRoomVC alloc] initWithConversaion:conversation];
                [weakSelf.navigationController pushViewController:chatRoomVC animated:YES];
            }
        }];
```

和多人群聊：

```objc
        NSMutableArray *memberIds = [NSMutableArray array];
        [memberIds addObject:groupId1];
        [memberIds addObject:groupId2];
        [memberIds addObject:[CDChatManager manager].selfId];
        [[CDChatManager manager] fetchConversaionWithMembers:memberIds callback: ^(AVIMConversation *conversation, NSError *error) {
            if (error) {
                DLog(@"%@", error);
            }
            else {
                LCEChatRoomVC *chatRoomVC = [[LCEChatRoomVC alloc] initWithConversation:conversation];
                [weakSelf.navigationController pushViewController:chatRoomVC animated:YES];
            }
        }];
```

注销时：

```objc
    [[CDChatManager manager] closeWithCallback: ^(BOOL succeeded, NSError *error) {
        
    }];
```

然后，就可以像上面截图那样聊天了。注意，目前我们并不推荐直接用 pod 方式来引入 LeanChatLib ，因为有些界面和功能需要由你来定制，所以推荐将 LeanChatLib 的代码拷贝进项目，这样改起来方便一些。

## LeanChatLib ChangeLog	

0.2.6

升级 SDK 至 3.1.4，适配 iOS 9

0.2.5

使用 AVIMConversationQuery 里的 cachePolicy，节省流量更好支持离线
修复当对话不存在调用 fecthConversationWithConversationId  可能崩溃的 Bug

0.2.4	

增加兔斯基表情

0.2.3

增加 fetchConversationWithMembers: 接口的参数检查、修复对话列表当是单聊对话但只有一个成员时可能出现的崩溃、

0.2.2

AVOSCloud 库升级至 3.1.2.8

0.2.1

ChatListDelegate 增加 configureCell: 与 prepareConversaion: 接口，以便实现更复杂的对话定制。

对于图像消息，使用 AVFile 来缓存图像，使得自己发送的照片不用重新下载。

0.2.0

补充注释、支持重发消息、显示失败的消息、增加音效和振动

0.1.3

修复了快速下拉加载历史消息时崩溃的Bug

0.1.2

用了 SDK 的聊天缓存，去掉了 FMDB 依赖。可以看到服务器上的历史消息，重装后也可以看到历史聊天记录。去掉了 CDNotify 类。

0.1.1

重构

0.1.0

发布


## 部署 LeanChat 需知

如果要部署完整的LeanChat的话，因为该应用有添加好友的功能，请在设置->应用选项中，勾选互相关注选项，以便一方同意的时候，能互相加好友。

![qq20150407-5](https://cloud.githubusercontent.com/assets/5022872/7016645/53f91bb8-dd1b-11e4-8ce0-72312c655094.png)

## 开发指南

[实时通信服务开发指南](https://leancloud.cn/docs/realtime_v2.html)

[更多介绍](https://github.com/leancloud/leanchat-android)

## 致谢

感谢曾宪华大神的 [MessageDisplayKit](https://github.com/xhzengAIB/MessageDisplayKit) 开源库。
