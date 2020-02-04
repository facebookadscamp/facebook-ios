// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "FBSDKShareMessengerContentUtility.h"

#ifdef FBSDKCOCOAPODS
#import <FBSDKCoreKit/FBSDKCoreKit+Internal.h>
#else
#import "FBSDKCoreKit+Internal.h"
#endif
#import "FBSDKShareConstants.h"
#import "FBSDKShareUtility.h"

NSString *const kFBSDKShareMessengerTemplateTypeKey = @"template_type";
NSString *const kFBSDKShareMessengerTemplateKey = @"template";
NSString *const kFBSDKShareMessengerPayloadKey = @"payload";
NSString *const kFBSDKShareMessengerTypeKey = @"type";
NSString *const kFBSDKShareMessengerAttachmentKey = @"attachment";
NSString *const kFBSDKShareMessengerElementsKey = @"elements";
NSString *const kFBSDKShareMessengerButtonsKey = @"buttons";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation FBSDKShareMessengerContentUtility
#pragma clang diagnostic pop

static NSString *_WebviewHeightRatioString(FBSDKShareMessengerURLActionButtonWebviewHeightRatio heightRatio) {
  switch (heightRatio) {
    case FBSDKShareMessengerURLActionButtonWebviewHeightRatioFull:
      return @"full";
    case FBSDKShareMessengerURLActionButtonWebviewHeightRatioTall:
      return @"tall";
    case FBSDKShareMessengerURLActionButtonWebviewHeightRatioCompact:
      return @"compact";
  }
}

static NSString *_WebviewShareButtonString(BOOL shouldHideWebviewShareButton) {
  return shouldHideWebviewShareButton ? @"hide" : nil;
}

+ (void)addToParameters:(NSMutableDictionary<NSString *, id> *)parameters
        contentForShare:(NSMutableDictionary<NSString *, id> *)contentForShare
      contentForPreview:(NSMutableDictionary<NSString *, id> *)contentForPreview
{
  NSError *error = nil;
  NSData *contentForShareData = [NSJSONSerialization dataWithJSONObject:contentForShare options:kNilOptions error:&error];
  if (!error && contentForShareData) {
    NSString *contentForShareDataString = [[NSString alloc] initWithData:contentForShareData encoding:NSUTF8StringEncoding];

    NSMutableDictionary<NSString *, id> *messengerShareContent = [NSMutableDictionary dictionary];
    [FBSDKBasicUtility dictionary:messengerShareContent setObject:contentForShareDataString forKey:@"content_for_share"];
    [FBSDKBasicUtility dictionary:messengerShareContent setObject:contentForPreview forKey:@"content_for_preview"];
    [FBSDKBasicUtility dictionary:parameters setObject:messengerShareContent forKey:@"messenger_share_content"];
  }
}

@end
