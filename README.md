# 说明：
- 下载项目之后请先更新pod
- 将appDelegate中[[MMEmotionCentre defaultCentre] setAppId:@“your app id” secret:@“your secret”]设置成分配到的`id`和`secret`。
- 本Demo在亲leanCloud官方在2016.03.09提交的版本的基础上集成了BQMM2.1,在修改的地方我们都加上了“BQMM集成"的注释，可在项目中全局搜索查看。


# 表情云SDK接入文档

接入**SDK**，有以下必要步骤：

1. 下载与安装
2. 获取必要的接入信息  
3. 开始集成  

##第一步：下载与安装

目前有两种方式安装SDK：

* 通过`CocoaPods`管理依赖。
* 手动导入`SDK`并管理依赖。

###1. 使用 CocoaPods 导入SDK

在终端中运行以下命令：

```
pod search BQMM
```

如果运行以上命令，没有搜到SDK，或者搜不到最新的 SDK 版本，您可以运行以下命令，更新您本地的 CocoaPods 源列表。

```
pod repo update
```

在您工程的 Podfile中添加最新版本的SDK（在此以2.1版本为例）：

```
pod 'BQMM', '2.1'
```

然后在工程的根目录下运行以下命令：

```
pod install
```

说明：pod中不包含gif表情的UI模块，可在官网[下载](http://7xl6jm.com2.z0.glb.qiniucdn.com/release/android-sdk/BQMM_Lib_V2.0.zip)，手动导入`BQMM_GIF`


###2. 手动导入SDK

下载当前最新版本，解压缩后获得3个文件夹

* `BQMM`
* `BQMM_EXT`
* `BQMM_GIF`

`BQMM`中包含SDK所需的资源文件`BQMM.bundle`和库文件`BQMM.framework`;`BQMM_EXT`提供了SDK的默认消息显示控件和消息默认格式的开源代码，开发者们导入后可按需修改;`BQMM_GIF`中包含gif表情的UI模块，开发者导入后可按需修改。

###3. 添加系统库依赖

您除了在工程中导入 SDK 之外，还需要添加libz动态链接库。


##第二步：获取必要的接入信息

开发者将应用与SDK进行对接时,必要接入信息如下

* `appId` - 应用的App ID
* `appSecret` - 应用的App Secret


如您暂未获得以上接入信息，可以在此[申请](http://open.biaoqingmm.com/open/register/index.html)


##第三步：开始集成

###0. 注册AppId&AppSecret、设置SDK语言和区域

在 `AppDelegate` 的 `-application:didFinishLaunchingWithOptions:` 中添加：

```objectivec
// 初始化SDK
[[MMEmotionCentre defaultCentre] setAppId:@“your app id” secret:@“your secret”]

//设置SDK语言和区域
[MMEmotionCentre defaultCentre].sdkLanguage = MMLanguageEnglish;
[MMEmotionCentre defaultCentre].sdkRegion = MMRegionChina;

```

###1. 在App重新打开时清空session

在 `AppDelegate` 的 `- (void)applicationWillEnterForeground:` 中添加：

```objectivec
[[MMEmotionCentre defaultCentre] clearSession];
```

###2. 使用表情键盘和GIF搜索模块

####设置SDK代理 

`LCCKChatBar.m`
```objectivec
- (instancetype)initWithFrame:(CGRect)frame {
    ....
    //BQMM集成
    [MMEmotionCentre defaultCentre].delegate = self;
    ....
}
```

####配置GIF搜索模块

`LCCKConversationViewController.m`
```objectivec
- (void)viewDidLoad {
    ....
    //BQMM集成   设置gif搜索相关
    [[MMGifManager defaultManager] setSearchModeEnabled:true withInputView:_inputToolBar.inputTextView];
    [[MMGifManager defaultManager] setSearchUiVisible:true withAttatchedView:_inputToolBar];
        
    __weak typeof(self) weakSelf = self;
    [MMGifManager defaultManager].selectedHandler = ^(MMGif * _Nullable gif) {
        __strong MMChatViewController *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf didSendGifMessage:gif];
        }
    };
    ....
}

-(void)didSendGifMessage:(MMGif *)gif {
    NSString *sendStr = [@"[" stringByAppendingFormat:@"%@]", gif.text];
    NSDictionary *msgData = @{WEBSTICKER_URL: gif.mainImage, WEBSTICKER_IS_GIF: (gif.isAnimated ? @"1" : @"0"), WEBSTICKER_ID: gif.imageId,WEBSTICKER_WIDTH: @((float)gif.size.width), WEBSTICKER_HEIGHT: @((float)gif.size.height)};
    NSDictionary *mmExt = @{TEXT_MESG_TYPE:TEXT_MESG_WEB_TYPE,
                             TEXT_MESG_DATA:msgData
                             };
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:sendStr attributes:mmExt];
    [self makeSureSendValidMessage:message afterFetchedConversationShouldWithAssert:NO];
    [self sendCustomMessage:message];
}
```

####实现SDK代理方法

`LCCKConversationViewController` 实现了SDK的代理方法

```objectivec
//点击键盘中大表情的代理
- (void)didSelectEmoji:(MMEmoji *)emoji
{
    [self sendMMFace:emoji];
}

//点击小表情键盘上发送按钮的代理
- (void)didSendWithInput:(UIResponder<UITextInput> *)input
{
    UITextView *textView = (UITextView *)input;
    if(textView.text.length > 0){
        [self sendTextMessage:textView.text];
        textView.text = @"";
        self.chatBar.cachedText = @"";
        [textView layoutIfNeeded];
    }
}

//点击输入框切换表情按钮状态
- (void)tapOverlay
{
    [self.chatBar onTapOverlay];
}

//点击gifTab
- (void)didClickGifTab {
    //点击gif tab 后应该保证搜索模式是打开的 搜索UI是允许显示的
    [[MMGifManager defaultManager] setSearchModeEnabled:true withInputView:self.chatBar.textView];
    [[MMGifManager defaultManager] setSearchUiVisible:true withAttatchedView:self.chatBar];
    [[MMGifManager defaultManager] showTrending];
    [self.chatBar onClickGifButton];
}
```

####表情键盘和普通键盘的切换

`LCCKChatBar`

```objectivec
- (void)showFaceView:(BOOL)show {
    if (show) {
        [[MMEmotionCentre defaultCentre] attachEmotionKeyboardToInput:self.textView];
        [self beginInputing];
    } else {
        [[MMEmotionCentre defaultCentre] switchToDefaultKeyboard];
    }
}
```


###3. 使用表情消息编辑控件
SDK提供`UITextView+BQMM`作为表情编辑控件的扩展实现，可以以图文混排方式编辑，并提取编辑内容。
消息编辑框需要使用此控件，在适当位置引入头文件 

```objectivec
#import <BQMM/BQMM.h>
```

###4.消息的编码及发送

表情相关的消息需要编码成`extData`放入IM的普通文字消息的扩展字段，发送到接收方进行解析。
`extData`是SDK推荐的用于解析的表情消息发送格式，格式是一个二维数组，内容为拆分完成的`text`和`emojiCode`，并且说明这段内容是否是一个`emojiCode`。

#####大表情消息

`LCCKConversationViewController`
```objectivec
-(void)sendMMFace:(MMEmoji *)emoji {
    NSDictionary *mmExt = @{@"txt_msgType":@"facetype",
                            @"msg_data":@[@[emoji.emojiCode, [NSString stringWithFormat:@"%d", emoji.isEmoji ? 1 : 2]]]};
    NSString *sendStr = [NSString stringWithFormat:@"[%@]", emoji.emojiName];
    
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:sendStr attributes:mmExt];
    [self makeSureSendValidMessage:message afterFetchedConversationShouldWithAssert:NO];
    [self sendCustomMessage:message];
}
```

#####Gif表情消息

`LCCKConversationViewController`
```objectivec
-(void)didSendGifMessage:(MMGif *)gif {
    NSString *sendStr = [@"[" stringByAppendingFormat:@"%@]", gif.text];
    NSDictionary *msgData = @{WEBSTICKER_URL: gif.mainImage, WEBSTICKER_IS_GIF: (gif.isAnimated ? @"1" : @"0"), WEBSTICKER_ID: gif.imageId,WEBSTICKER_WIDTH: @((float)gif.size.width), WEBSTICKER_HEIGHT: @((float)gif.size.height)};
    NSDictionary *mmExt = @{TEXT_MESG_TYPE:TEXT_MESG_WEB_TYPE,
                             TEXT_MESG_DATA:msgData
                             };
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:sendStr attributes:mmExt];
    [self makeSureSendValidMessage:message afterFetchedConversationShouldWithAssert:NO];
    [self sendCustomMessage:message];
}
```

###5. 表情消息的解析

#### 单个大表情解析

从消息的扩展中解析出大表情（MMEmoji）的emojiCode

`LCCKBQMMMessageCell`
```objectivec
- (void)configureCellWithData:(LCCKMessage *)message {
	...
    if ([[message class] isSubclassOfClass:[AVIMTypedMessage class]]){
        AVIMTypedMessage *tempMessage = message;
        NSDictionary *ext = tempMessage.attributes;
        if([ext[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE]) {
            NSDictionary *ext = tempMessage.attributes;
            NSString *emojiCode = nil;
            if (ext[TEXT_MESG_DATA]) {
                emojiCode = ext[TEXT_MESG_DATA][0][0];
            }
            
            ...
        }
        ...
    }
}
```

#### Gif表情解析

从消息的扩展中解析出Gif表情（MMGif）的imageId和mainImage

`LCCKBQMMMessageCell`
```objectivec
- (void)configureCellWithData:(LCCKMessage *)message {
	...
    else if([ext[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            self.messageImageView.image = [UIImage imageNamed:@"mm_emoji_loading"];
            
            self.messageImageView.errorImage = [UIImage imageNamed:@"mm_emoji_error"];
            NSDictionary *msgData = ext[@"msg_data"];
            NSString *webStickerUrl = msgData[WEBSTICKER_URL];
            NSString *webStickerId = msgData[WEBSTICKER_ID];
            ...
        }
    }
    ...
}
```


###6. 表情消息显示

#### 大表情消息 && gif表情消息
SDK 提供 `MMImageView` 来显示单个大表情及gif表情

`LCCKBQMMMessageCell`

```objectivec
//BQMM集成
@property (nonatomic, strong, readonly) MMImageView *messageImageView;

- (MMImageView *)messageImageView {
    if (!_messageImageView) {
        _messageImageView = [[MMImageView alloc] init];
        //FIXME:这一行可以不需要
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _messageImageView;

}

- (void)configureCellWithData:(LCCKMessage *)message {
    [super configureCellWithData:message];
    if ([[message class] isSubclassOfClass:[AVIMTypedMessage class]]){
        AVIMTypedMessage *tempMessage = message;
        NSDictionary *ext = tempMessage.attributes;
        if([ext[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE]) {
            NSDictionary *ext = tempMessage.attributes;
            NSString *emojiCode = nil;
            if (ext[TEXT_MESG_DATA]) {
                emojiCode = ext[TEXT_MESG_DATA][0][0];
            }
            
            if (emojiCode != nil && emojiCode.length > 0) {
                self.messageImageView.errorImage = [UIImage imageNamed:@"mm_emoji_error"];
                self.messageImageView.image = [UIImage imageNamed:@"mm_emoji_loading"];
                [self.messageImageView setImageWithEmojiCode:emojiCode];
            }else {
                self.messageImageView.image = [UIImage imageNamed:@"mm_emoji_error"];
            }
        }
        ...
    }
}
```

gif表情
`LCCKBQMMMessageCell`
```objectivec
- (void)configureCellWithData:(LCCKMessage *)message {
    [super configureCellWithData:message];
    ...
    else if([ext[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            self.messageImageView.image = [UIImage imageNamed:@"mm_emoji_loading"];
            
            self.messageImageView.errorImage = [UIImage imageNamed:@"mm_emoji_error"];
            NSDictionary *msgData = ext[@"msg_data"];
            NSString *webStickerUrl = msgData[WEBSTICKER_URL];
            NSString *webStickerId = msgData[WEBSTICKER_ID];

            [self.messageImageView setImageWithUrl:webStickerUrl gifId:webStickerId];
        }
    }
}
```


###7. demo中的其他修改
0. 相应的类中引用头文件。

1. 消息tableView相关

`LCCKConversationViewModel`
```objectivec
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id message = self.dataArray[indexPath.row];
    //BQMM集成
    NSString *identifier = @"";
    LCCKChatMessageCell *messageCell = nil;
    
    identifier = [LCCKCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:[self.parentConversationViewController getConversationIfExists].lcck_type];
    
    messageCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    messageCell.tableView = self.parentConversationViewController.tableView;
    messageCell.indexPath = indexPath;
    [messageCell configureCellWithData:message];
    messageCell.delegate = self.parentConversationViewController;
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id message = self.dataArray[indexPath.row];
    NSString *identifier = [LCCKCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:[self.parentConversationViewController getConversationIfExists].lcck_type];
    NSString *cacheKey = [LCCKCellIdentifierFactory cacheKeyForMessage:message];
    //BQMM集成
    if ([[message class] isSubclassOfClass:[AVIMTypedMessage class]]){
        AVIMTypedMessage *tempMessage = message;
        if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE] || [tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            return [LCCKBQMMMessageCell heightForBQMMCellWithMessage:message];
        }
    }
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByKey:cacheKey configuration:^(LCCKChatMessageCell *cell) {
        [cell configureCellWithData:message];
    }];
}


//LCCKCellIdentifierFactory
+ (NSString *)cellIdentifierForDefaultMessageConfiguration:(LCCKMessage *)message groupKey:(NSString *)groupKey {
    ...
    //BQMM集成
    if ([[message class] isSubclassOfClass:[AVIMTypedMessage class]]){
        AVIMTypedMessage *tempMessage = message;
        if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE]) {
            typeKey = NSStringFromClass([LCCKBQMMMessageCell class]);
        }else if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            typeKey = NSStringFromClass([LCCKBQMMMessageCell class]);
        }
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

+ (NSString *)cellIdentifierForCustomMessageConfiguration:(AVIMTypedMessage *)message groupKey:(NSString *)groupKey {
    ...
    //BQMM集成
    if ([[message class] isSubclassOfClass:[AVIMTypedMessage class]]){
        AVIMTypedMessage *tempMessage = message;
        if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE]) {
            typeKey = NSStringFromClass([LCCKBQMMMessageCell class]);
        }else if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            typeKey = NSStringFromClass([LCCKBQMMMessageCell class]);
        }
    }
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

//LCCKCellRegisterController
+ (void)registerChatMessageCellClassForTableView:(UITableView *)tableView {
    ...
    //BQMM集成
    [self registerSystemMessageCellClassForTableView:tableView];
    [self registerBQMMMessageCellClass:[LCCKBQMMMessageCell class] ForTableView:tableView];
    
}

+ (void)registerBQMMMessageCellClass:(Class)messageCellClass ForTableView:(UITableView *)tableView  {
    NSString *messageCellClassString = NSStringFromClass(messageCellClass);
    [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerSelf, LCCKCellIdentifierGroup]];
    [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerSelf, LCCKCellIdentifierSingle]];
    [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerOther, LCCKCellIdentifierGroup]];
    [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerOther , LCCKCellIdentifierSingle]];
}
```

2. 关闭商店相关

`LCCKChatBar`
添加商店关闭观察者
```objectivec
- (void)setup {
    //BQMM集成
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backToUserInterface)
                                                 name:@"SMEmotionDismissShopNotification"
                                               object:nil];
    ...
}

- (void)backToUserInterface {
    [self.faceButton setSelected:YES];
}

```

3. 消息解析兼容安卓
`ChatViewController`
```objectivec
+ (NSMutableArray *)lcck_messagesWithAVIMMessages:(NSArray *)avimTypedMessages {
	...
    dispatch_group_async(group, queue, ^{
        void(^filteredMessageCallback)(NSArray *_avimTypedMessages) = ^(NSArray *_avimTypedMessages) {
            for (AVIMTypedMessage *typedMessage in _avimTypedMessages) {
                //BQMM集成
                if([typedMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
                    id msgData = typedMessage.attributes[TEXT_MESG_DATA];
                    if([msgData isKindOfClass:[NSString class]]) { //兼容安卓
                        NSData *jsonData = [msgData dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *err;
                        NSDictionary *msgDataDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                   options:NSJSONReadingMutableContainers
                                                                                     error:&err];
                        
                        typedMessage.attributes = @{TEXT_MESG_TYPE:TEXT_MESG_WEB_TYPE,
                                                    TEXT_MESG_DATA:msgDataDic
                                                    };
                        
                    }else{
                    }
                }
                ...
                
                
            }
        };
        ...
    }
}
```

###8. gif搜索模块UI定制

`BQMM_GIF`是一整套gif搜索UI模块的实现源码，可用于直接使用或用于参考实现gif搜索，及gif消息的发送解析。
####gif搜索源码说明
gif相关的功能由`MMGifManager`集中管理:

1.设置搜索模式的开启和关闭；指定输入控件
```objectivec
- (void)setSearchModeEnabled:(BOOL)enabled withInputView:(UIResponder<UITextInput> *_Nullable)input;
```

2.设置是否显示搜索出的表情内容；指定表情内容的显示位置
```objectivec
- (void)setSearchUiVisible:(BOOL)visible withAttatchedView:(UIView *_Nullable)attachedView;
```

3.通过`MMSearchModeStatus`管理搜索模式的开启和关闭及搜索内容的展示和收起（MMSearchModeStatus可自由调整）
```objectivec
typedef NS_OPTIONS (NSInteger, MMSearchModeStatus) {
    MMSearchModeStatusKeyboardHide = 1 << 0,         //收起键盘
    MMSearchModeStatusInputEndEditing = 1 << 1,         //收起键盘
    MMSearchModeStatusInputBecomeEmpty = 1 << 2,     //输入框清空
    MMSearchModeStatusInputTextChange = 1 << 3,      //输入框内容变化
    MMSearchModeStatusGifMessageSent = 1 << 4,       //发送了gif消息
    MMSearchModeStatusShowTrendingTriggered = 1 << 5,//触发流行表情
    MMSearchModeStatusGifsDataReceivedWithResult = 1 << 6,     //收到gif数据
    MMSearchModeStatusGifsDataReceivedWithEmptyResult = 1 << 7,     //搜索结果为空
};
- (void)updateSearchModeAndSearchUIWithStatus:(MMSearchModeStatus)status;
```

###9. UI定制

 SDK通过`MMTheme`提供一定程度的UI定制。具体参考类说明[MMTheme](../class_reference/README.md)。

创建一个`MMTheme`对象，设置相关属性， 然后[[MMEmotionCentre defaultCentre] setTheme:]即可修改商店和键盘样式。


###10. 清除缓存

调用`clearCache`方法清除缓存，此操作会删除所有临时的表情缓存，已下载的表情包不会被删除。建议在`- (void)applicationWillTerminate:(UIApplication *)application `方法中调用。

###11. 设置APP UserId

开发者可以用`setUserId`方法设置App UserId，以便在后台统计时跟踪追溯单个用户的表情使用情况。
