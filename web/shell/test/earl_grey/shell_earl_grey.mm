// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/web/shell/test/earl_grey/shell_earl_grey.h"

#import <EarlGrey/EarlGrey.h>

#import "ios/web/public/test/earl_grey/js_test_util.h"
#include "ios/web/shell/test/app/navigation_test_util.h"
#import "ios/web/shell/test/app/web_shell_test_util.h"

namespace {
const NSTimeInterval kWaitForPageLoadTimeout = 10.0;
}  // namespace

@implementation ShellEarlGrey

+ (void)loadURL:(const GURL&)URL {
  web::shell_test_util::LoadUrl(URL);

  // Make sure that the page started loading.
  GREYAssert(web::shell_test_util::IsLoading(), @"Page did not start loading.");

  GREYCondition* condition =
      [GREYCondition conditionWithName:@"Wait for page to complete loading."
                                 block:^BOOL {
                                   return !web::shell_test_util::IsLoading();
                                 }];
  GREYAssert([condition waitWithTimeout:kWaitForPageLoadTimeout],
             @"Page did not complete loading.");

  web::WebState* webState = web::shell_test_util::GetCurrentWebState();
  if (webState->ContentIsHTML())
    web::WaitUntilWindowIdInjected(webState);
}

@end
