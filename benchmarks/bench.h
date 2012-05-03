#import "../objc.string/NSString+ObjCString.h"


typedef NSString *(*StrFun)(NSString *);


void def_bench(NSString *name, StrFun stock_fptr,
               NSString *input_str, NSString *control_str, ...);

void def_mem_bench(NSString *input_str, NSString *control_str,
                   NSString *name, StrFun fptr, int chained);


#define STOCK_PAIR(name, fptr) name, fptr
#define NULL_STOCK             NULL, NULL

#define DEFBENCH(name, stock_fptr, input_str, control_str, ...) \
    int main()                                                              \
    {                                                                       \
        @autoreleasepool {                                                  \
            def_bench(name, stock_fptr,                                     \
                      input_str, control_str, __VA_ARGS__);                 \
        }                                                                   \
        return 0;                                                           \
    }
