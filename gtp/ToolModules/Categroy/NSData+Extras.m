//
//  NSData+MM.m
//  PregnancyHelper
//
//  Created by Chen Yaoqiang on 14-3-19.
//  Copyright (c) 2014年 ShengCheng. All rights reserved.
//

#import "NSData+Extras.h"

@implementation NSData (MM)
static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString *)newStringInBase64FromData
{
 NSMutableString *dest = [[NSMutableString alloc] initWithString:@""];
 unsigned char * working = (unsigned char *)[self bytes];
    NSUInteger srcLen = [self length];

 // tackle the source in 3's as conveniently 4 Base64 nibbles fit into 3 bytes
 for (int i=0; i<srcLen; i += 3)
 {
  // for each output nibble
  for (int nib=0; nib<4; nib++)
  {
   // nibble:nib from char:byt
   int byt = (nib == 0)?0:nib-1;
   int ix = (nib+1)*2;

   if (i+byt >= srcLen) break;

   // extract the top bits of the nibble, if valid
   unsigned char curr = ((working[i+byt] << (8-ix)) & 0x3F);

   // extract the bottom bits of the nibble, if valid
   if (i+nib < srcLen) curr |= ((working[i+nib] >> ix) & 0x3F);

   [dest appendFormat:@"%c", base64[curr]];
  }
 }

 return dest;
}
- (NSString *)toString
{
    Byte *dataPointer = (Byte *)[self bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSUInteger index;
    for (index = 0; index < [self length]; index++)
    {
        [result appendFormat:@"0x%02x,", dataPointer[index]];
    }
    return result;
}
- (id)jsonValue {
    if ([NSJSONSerialization class]) {
        NSError *error = nil;
        id jsonValue = [NSJSONSerialization JSONObjectWithData:self
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
        
        if (error) {
            NSLog(@"%s", [error localizedFailureReason].description.UTF8String);
            return nil;
        }
        return jsonValue;
    }
    
    return nil;
}


- (NSString *)utf8String {
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    if (string == nil) {
        string = [[NSString alloc] initWithData:[self UTF8Data] encoding:NSUTF8StringEncoding];
    }
    return string;
}

//              https://zh.wikipedia.org/wiki/UTF-8
//              https://www.w3.org/International/questions/qa-forms-utf-8
//
//            $field =~
//                    m/\A(
//            [\x09\x0A\x0D\x20-\x7E]            # ASCII
//            | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
//            |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
//            | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
//            |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
//            |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
//            | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
//            |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
//            )*\z/x;

- (NSData *)UTF8Data {
    //保存结果
    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:self.length];

    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];

    uint64_t index = 0;
    const uint8_t *bytes = self.bytes;

    long dataLength = (long) self.length;

    while (index < dataLength) {
        uint8_t len = 0;
        uint8_t firstChar = bytes[index];

            // 1个字节
        if ((firstChar & 0x80) == 0 && (firstChar == 0x09 || firstChar == 0x0A || firstChar == 0x0D || (0x20 <= firstChar && firstChar <= 0x7E))) {
            len = 1;
        }
            // 2字节
        else if ((firstChar & 0xE0) == 0xC0 && (0xC2 <= firstChar && firstChar <= 0xDF)) {
            if (index + 1 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                if (0x80 <= secondChar && secondChar <= 0xBF) {
                    len = 2;
                }
            }
        }
            // 3字节
        else if ((firstChar & 0xF0) == 0xE0) {
            if (index + 2 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                
                if (firstChar == 0xE0 && (0xA0 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (((0xE1 <= firstChar && firstChar <= 0xEC) || firstChar == 0xEE || firstChar == 0xEF) && (0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (firstChar == 0xED && (0x80 <= secondChar && secondChar <= 0x9F) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                }
            }
        }
            // 4字节
        else if ((firstChar & 0xF8) == 0xF0) {
            if (index + 3 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                uint8_t fourthChar = bytes[index + 3];
                
                if (firstChar == 0xF0) {
                    if ((0x90 <= secondChar & secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if ((0xF1 <= firstChar && firstChar <= 0xF3)) {
                    if ((0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if (firstChar == 0xF3) {
                    if ((0x80 <= secondChar && secondChar <= 0x8F) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                }
            }
        }
            // 5个字节
        else if ((firstChar & 0xFC) == 0xF8) {
            len = 0;
        }
            // 6个字节
        else if ((firstChar & 0xFE) == 0xFC) {
            len = 0;
        }

        if (len == 0) {
            index++;
            [resData appendData:replacement];
        } else {
            [resData appendBytes:bytes + index length:len];
            index += len;
        }
    }

    return resData;
}
@end
