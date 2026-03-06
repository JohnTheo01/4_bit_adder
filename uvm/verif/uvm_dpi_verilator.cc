// Verilator-compatible UVM DPI implementation.
//
// Replaces uvm_dpi.cc for Verilator builds:
//   - Includes uvm_common.c and uvm_regex.cc within extern "C" so symbols
//     are exported with C linkage (no C++ name mangling).
//   - Stubs out uvm_hdl_* (HDL backdoor — requires a vendor simulator).
//   - Stubs out uvm_dpi_get_* (VPI tool-info — not needed for simulation).

#ifdef __cplusplus
extern "C" {
#endif

#include <stdlib.h>
#include <string.h>
#include "uvm_dpi.h"

// --- Common DPI utilities (m_uvm_report_dpi, int_str_max) ---
#include "uvm_common.c"

// --- Regex support (real POSIX implementation) ---
#include "uvm_regex.cc"

// --- Tool info stubs (replaces uvm_svcmd_dpi.c which requires VPI) ---
const char* uvm_dpi_get_next_arg_c(int init) {
    return NULL;
}

char* uvm_dpi_get_tool_name_c() {
    return (char*)"Verilator";
}

char* uvm_dpi_get_tool_version_c() {
    return (char*)"5.044";
}

// --- HDL backdoor stubs (replaces uvm_hdl.c / uvm_hdl_polling.c) ---
int uvm_hdl_check_path(char* path)                        { return 0; }
int uvm_hdl_read(char* path, p_vpi_vecval value)          { return 0; }
int uvm_hdl_deposit(char* path, p_vpi_vecval value)       { return 0; }
int uvm_hdl_force(char* path, p_vpi_vecval value)         { return 0; }
int uvm_hdl_release_and_read(char* path, p_vpi_vecval value) { return 0; }
int uvm_hdl_release(char* path)                           { return 0; }

#ifdef __cplusplus
}
#endif
