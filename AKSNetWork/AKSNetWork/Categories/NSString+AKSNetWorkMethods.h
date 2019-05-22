//
//  NSString+AKSNetWorkMethods.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/6.
//  Copyright © 2019年 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AKSNetWorkMethods)

/** Base64编码 */
- (NSString *)AKS_Base64Encode;

/** Base64反编码 */
- (NSString *)AKS_Base64Decode;

/** 32位MD5加密 */
- (NSString *)AKS_MD5Encrypt;

/** SHA1加密 */
- (NSString *)AKS_SHA1Encrypt;

/** AES加密 */
- (NSString *)AKS_AES128EncryptWithKey:(NSString *)key;

/** AES解密 */
- (NSString *)AKS_AES128DecryptWithKey:(NSString *)key;

/** DES加密 */
- (NSString *)AKS_DESEncryptWithKey:(NSString *)key;

/** DES解密 */
- (NSString *)AKS_DESDecryptWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
