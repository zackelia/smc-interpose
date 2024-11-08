#include <cstdio>
#include <cstdlib>

#include "dyld-interposing.h"

// A simple shim to call Swift code after interposing. I don't know how to do
// this in pure Swift.
extern "C" int run_smc(void);

int my_puts(const char *, FILE *)
{
    exit(run_smc());
}

DYLD_INTERPOSE(my_puts, puts)
