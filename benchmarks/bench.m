#import "bench.h"

#include <mach/mach_time.h>
#include <mach/mach.h>


static mach_timebase_info_data_t sTimebaseInfo;
static uint64_t timestamp;


#define NUM_ITERATIONS     100000
#define NUM_ITERATIONS_MEM 10000


static inline void get_timestamp()
{
    timestamp = mach_absolute_time();
}

static inline void print_report(NSString *name)
{
    uint64_t delta = (mach_absolute_time() - timestamp) * sTimebaseInfo.numer / sTimebaseInfo.denom;
    NSLog(@"*** %@ ***", name);
    NSLog(@"Average iteration time = %llu ns\n\n", (uint64_t)((long double)delta / NUM_ITERATIONS));
}

void test_runner(StrFun fptr, NSString *input_str, NSString *control_str, NSString *name)
{
    @autoreleasepool {
        NSString *result;

        get_timestamp();
        for (NSUInteger i = 0; i < NUM_ITERATIONS; ++i) {
            result = fptr(input_str);
        }
        print_report(name);

        if (![result isEqualToString:control_str]) {
            NSLog(@"%@ != %@", result, control_str);
            assert(0);
        }
    }
}

void def_bench(NSString *name, StrFun stock_fptr, NSString *input_str, NSString *control_str, ...)
{
    mach_timebase_info(&sTimebaseInfo);

    if (stock_fptr) {
        test_runner(stock_fptr, input_str, control_str, [NSString stringWithFormat:@"%@ [stock]", name]);
    }

    StrFun fptr;

    va_list args;
    va_start(args, control_str);
    while ((fptr = va_arg(args, StrFun))) {
        NSString *impl_name = va_arg(args, NSString *);
        test_runner(fptr, input_str, control_str, impl_name);
        test_runner(fptr, [input_str chain], control_str, [impl_name stringByAppendingString:@" [chained]"]);
    }
    va_end(args);
}

void def_mem_bench(NSString *input_str, NSString *control_str, NSString *name, StrFun fptr, int chained)
{
    NSString *str = (chained ? [input_str chain] : input_str);
    NSString *result;
    for (NSUInteger i = 0; i < NUM_ITERATIONS_MEM; ++i) {
        result = fptr(str);
    }

    if (![result isEqualToString:control_str]) {
        NSLog(@"%@ != %@", result, control_str);
        assert(0);
    }
}
