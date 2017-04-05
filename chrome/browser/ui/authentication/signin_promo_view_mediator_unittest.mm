// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/ui/authentication/signin_promo_view_mediator.h"

#import "ios/public/provider/chrome/browser/signin/fake_chrome_identity.h"
#import "ios/public/provider/chrome/browser/signin/fake_chrome_identity_service.h"
#import "ios/third_party/material_components_ios/src/components/Buttons/src/MaterialButtons.h"
#import "testing/platform_test.h"
#import "third_party/ocmock/OCMock/OCMock.h"
#include "third_party/ocmock/gtest_support.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

namespace {

class SigninPromoViewMediatorTest : public PlatformTest {
 protected:
  void SetUp() override {
    mediator_ = [[SigninPromoViewMediator alloc] init];

    signin_promo_view_ = OCMStrictClassMock([SigninPromoView class]);
    primary_button_ = OCMStrictClassMock([MDCFlatButton class]);
    OCMStub([signin_promo_view_ primaryButton]).andReturn(primary_button_);
    secondary_button_ = OCMStrictClassMock([MDCFlatButton class]);
    OCMStub([signin_promo_view_ secondaryButton]).andReturn(secondary_button_);
  }

  void TearDown() override {
    mediator_ = nil;
    EXPECT_OCMOCK_VERIFY((id)signin_promo_view_);
    EXPECT_OCMOCK_VERIFY((id)primary_button_);
    EXPECT_OCMOCK_VERIFY((id)secondary_button_);
  }

  void TestColdState() {
    EXPECT_EQ(nil, mediator_.defaultIdentity);
    ExpectColdStateConfiguration();
    [mediator_ configureSigninPromoView:signin_promo_view_];
    CheckColdStateConfiguration();
  }

  void TestWarmState() {
    expected_default_dentity_ =
        [FakeChromeIdentity identityWithEmail:@"johndoe@example.com"
                                       gaiaID:@"1"
                                         name:@"John Doe"];
    ios::FakeChromeIdentityService::GetInstanceFromChromeProvider()
        ->AddIdentity(expected_default_dentity_);
    ExpectWarmStateConfiguration();
    [mediator_ configureSigninPromoView:signin_promo_view_];
    CheckWarmStateConfiguration();
  }

  void ExpectColdStateConfiguration() {
    OCMExpect([signin_promo_view_ setMode:SigninPromoViewModeColdState]);
    image_view_profile_image_ = nil;
    primary_button_title_ = nil;
    secondary_button_title_ = nil;
  }

  void CheckColdStateConfiguration() {
    EXPECT_EQ(nil, image_view_profile_image_);
    EXPECT_EQ(nil, primary_button_title_);
    EXPECT_EQ(nil, secondary_button_title_);
  }

  void ExpectWarmStateConfiguration() {
    EXPECT_EQ(expected_default_dentity_, mediator_.defaultIdentity);
    OCMExpect([signin_promo_view_ setMode:SigninPromoViewModeWarmState]);
    OCMExpect([signin_promo_view_
        setProfileImage:[OCMArg checkWithBlock:^BOOL(id value) {
          image_view_profile_image_ = value;
          return YES;
        }]]);
    primary_button_title_ = nil;
    OCMExpect([primary_button_ setTitle:[OCMArg checkWithBlock:^BOOL(id value) {
                                 primary_button_title_ = value;
                                 return YES;
                               }]
                               forState:UIControlStateNormal]);
    secondary_button_title_ = nil;
    OCMExpect([secondary_button_
        setTitle:[OCMArg checkWithBlock:^BOOL(id value) {
          secondary_button_title_ = value;
          return YES;
        }]
        forState:UIControlStateNormal]);
  }

  void CheckWarmStateConfiguration() {
    EXPECT_NE(nil, image_view_profile_image_);
    NSString* userFullName = expected_default_dentity_.userFullName;
    NSRange profileNameRange =
        [primary_button_title_ rangeOfString:userFullName];
    EXPECT_NE(profileNameRange.length, 0u);
    NSString* userEmail = expected_default_dentity_.userEmail;
    NSRange profileEmailRange =
        [secondary_button_title_ rangeOfString:userEmail];
    EXPECT_NE(profileEmailRange.length, 0u);
  }

  // Mediator used for the tests.
  SigninPromoViewMediator* mediator_;

  // Identity used for the warm state.
  FakeChromeIdentity* expected_default_dentity_;

  // Mocks.
  SigninPromoView* signin_promo_view_;
  MDCFlatButton* primary_button_;
  MDCFlatButton* secondary_button_;

  // Value set by -[SigninPromoView setProfileImage:].
  UIImage* image_view_profile_image_;
  // Value set by -[primary_button_ setTitle: forState:UIControlStateNormal].
  NSString* primary_button_title_;
  // Value set by -[secondary_button_ setTitle: forState:UIControlStateNormal].
  NSString* secondary_button_title_;
};

TEST_F(SigninPromoViewMediatorTest, ColdStateConfigureSigninPromoView) {
  TestColdState();
}

TEST_F(SigninPromoViewMediatorTest,
       WarmStateConfigureSigninPromoViewWithoutImage) {
  TestWarmState();
}

// Cold state configuration and then warm state configuration.
TEST_F(SigninPromoViewMediatorTest, ConfigureSigninPromoViewWithColdAndWarm) {
  TestColdState();
  TestWarmState();
}

// Warm state configuration and then cold state configuration.
TEST_F(SigninPromoViewMediatorTest, ConfigureSigninPromoViewWithWarmAndCold) {
  TestWarmState();
  ios::FakeChromeIdentityService::GetInstanceFromChromeProvider()
      ->RemoveIdentity(expected_default_dentity_);
  expected_default_dentity_ = nil;
  TestColdState();
}

}  // namespace
