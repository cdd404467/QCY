//
//  AES128.m
//  QCY
//
//  Created by i7colors on 2018/10/12.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AES128.h"
#import <CommonCrypto/CommonCryptor.h>
#import "TimeAbout.h"

#define Time_Key @"jK)Nig8N40YkntYG"
#define User_Key @"LnhtI(bt490B74Je"

@implementation AES128

+ (NSString *)urlEncodeStr:(NSString *)input {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}


+ (NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key isUrl:(BOOL)isUrl
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];

    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
//        return [GTMBase64 stringByEncodingData:resultData];
        
        NSString *base64Encode = [resultData base64EncodedStringWithOptions:0];
        if (isUrl == YES) {
            return [self urlEncodeStr:base64Encode];
        } else {
            return base64Encode;
        }
    }
    free(buffer);
    return nil;
}

//接口用到的固定的
+ (NSString *)AES128Encrypt {
    return [self AES128Encrypt:[TimeAbout getNowTimeTimestamp_HM] key:Time_Key isUrl:YES];
}

+ (NSString *)AES128Encrypt:(NSString *)plainText {
    return [self AES128Encrypt:plainText key:User_Key isUrl:NO];
}



@end
