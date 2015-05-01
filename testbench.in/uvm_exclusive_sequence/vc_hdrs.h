
#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _VC_TYPES_
#define _VC_TYPES_
/* common definitions shared with DirectC.h */

typedef unsigned int U;
typedef unsigned char UB;
typedef unsigned char scalar;
typedef struct { U c; U d;} vec32;

#define scalar_0 0
#define scalar_1 1
#define scalar_z 2
#define scalar_x 3

extern long long int ConvUP2LLI(U* a);
extern void ConvLLI2UP(long long int a1, U* a2);
extern long long int GetLLIresult();
extern void StoreLLIresult(const unsigned int* data);
typedef struct VeriC_Descriptor *vc_handle;

#ifndef SV_3_COMPATIBILITY
#define SV_STRING const char*
#else
#define SV_STRING char*
#endif

#endif /* _VC_TYPES_ */


 extern int uvm_hdl_check_path(const char* path);

 extern int uvm_hdl_deposit(const char* path, const svLogicVecVal *value);

 extern int uvm_hdl_force(const char* path, const svLogicVecVal *value);

 extern int uvm_hdl_release_and_read(const char* path, /* INOUT */svLogicVecVal *value);

 extern int uvm_hdl_release(const char* path);

 extern int uvm_hdl_read(const char* path, /* OUTPUT */svLogicVecVal *value);

 extern SV_STRING dpi_get_next_arg_c();

 extern SV_STRING dpi_get_tool_name_c();

 extern SV_STRING dpi_get_tool_version_c();

 extern void* dpi_regcomp(const char* regex);

 extern int dpi_regexec(void* preg, const char* str);

 extern void dpi_regfree(void* preg);

 extern int uvm_re_match(const char* re, const char* str);

 extern void uvm_dump_re_cache();

 extern SV_STRING uvm_glob_to_re(const char* glob);
void Wterminate();

#ifdef __cplusplus
}
#endif

