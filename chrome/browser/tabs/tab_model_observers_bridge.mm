// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/tabs/tab_model_observers_bridge.h"

#include "base/logging.h"
#import "ios/chrome/browser/tabs/legacy_tab_helper.h"
#import "ios/chrome/browser/tabs/tab_model.h"
#import "ios/chrome/browser/tabs/tab_model_observers.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

@implementation TabModelObserversBridge {
  __weak TabModel* _tabModel;
  __weak TabModelObservers* _tabModelObservers;
}

- (instancetype)initWithTabModel:(TabModel*)tabModel
               tabModelObservers:(TabModelObservers*)tabModelObservers {
  DCHECK(tabModel);
  DCHECK(tabModelObservers);
  if ((self = [super init])) {
    _tabModel = tabModel;
    _tabModelObservers = tabModelObservers;
  }
  return self;
}

#pragma mark WebStateListObserving

- (void)webStateList:(WebStateList*)webStateList
    didInsertWebState:(web::WebState*)webState
              atIndex:(int)index {
  DCHECK_GE(index, 0);
  [_tabModelObservers tabModel:_tabModel
                  didInsertTab:LegacyTabHelper::GetTabForWebState(webState)
                       atIndex:static_cast<NSUInteger>(index)
                  inForeground:NO];
  [_tabModelObservers tabModelDidChangeTabCount:_tabModel];
}

- (void)webStateList:(WebStateList*)webStateList
     didMoveWebState:(web::WebState*)webState
           fromIndex:(int)fromIndex
             toIndex:(int)toIndex {
  DCHECK_GE(fromIndex, 0);
  DCHECK_GE(toIndex, 0);
  [_tabModelObservers tabModel:_tabModel
                    didMoveTab:LegacyTabHelper::GetTabForWebState(webState)
                     fromIndex:static_cast<NSUInteger>(fromIndex)
                       toIndex:static_cast<NSUInteger>(toIndex)];
}

- (void)webStateList:(WebStateList*)webStateList
    didReplaceWebState:(web::WebState*)oldWebState
          withWebState:(web::WebState*)newWebState
               atIndex:(int)index {
  DCHECK_GE(index, 0);
  [_tabModelObservers tabModel:_tabModel
                 didReplaceTab:LegacyTabHelper::GetTabForWebState(oldWebState)
                       withTab:LegacyTabHelper::GetTabForWebState(newWebState)
                       atIndex:static_cast<NSUInteger>(index)];
}

- (void)webStateList:(WebStateList*)webStateList
    didDetachWebState:(web::WebState*)webState
              atIndex:(int)index {
  DCHECK_GE(index, 0);
  [_tabModelObservers tabModel:_tabModel
                  didRemoveTab:LegacyTabHelper::GetTabForWebState(webState)
                       atIndex:static_cast<NSUInteger>(index)];
  [_tabModelObservers tabModelDidChangeTabCount:_tabModel];
}

@end