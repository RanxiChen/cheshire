// SPDX-License-Identifier: Apache-2.0
#include <stdint.h>
#include "dif/clint.h"
#include "dif/uart.h"
#include "params.h"
#include "printf.h"
#include "regs/cheshire.h"
#include "util.h"

static uint64_t mix(uint64_t address, uint64_t salt) {
    return (address * UINT64_C(0x9e3779b97f4a7c15)) ^ salt;
}

int main(void) {
    const uintptr_t bases[] = {0x81000000, 0xc1000000, 0xffff0000};
    const uint64_t salts[] = {UINT64_C(0x5aa5a55aa55a5aa5), UINT64_C(0xa55a5aa55aa5a55a)};
    uint64_t hz = clint_get_core_freq(CHS_REGS->rtc_freq.f.ref_freq, 2500);
    uart_init(&__uart_base_addr__, hz, __BOOT_BAUDRATE);
    uint64_t misa, marchid, mimpid;
    asm volatile("csrr %0, misa" : "=r"(misa));
    asm volatile("csrr %0, marchid" : "=r"(marchid));
    asm volatile("csrr %0, mimpid" : "=r"(mimpid));
    printf("CVA6_ACCEPTANCE_START clock=%lu misa=%lx marchid=%lu mimpid=%lu\r\n",
           hz, misa, marchid, mimpid);
    uart_write_flush(&__uart_base_addr__);
    for (unsigned pass = 0; pass < 2; ++pass) {
        for (unsigned region = 0; region < 3; ++region) {
            volatile uint64_t *mem = (volatile uint64_t *)bases[region];
            for (unsigned i = 0; i < 8192; ++i)
                mem[i] = mix((uintptr_t)&mem[i], salts[pass]);
        }
        asm volatile("fence rw, rw" ::: "memory");
        for (unsigned region = 0; region < 3; ++region) {
            volatile uint64_t *mem = (volatile uint64_t *)bases[region];
            for (unsigned i = 0; i < 8192; ++i) {
                uint64_t actual = mem[i], expected = mix((uintptr_t)&mem[i], salts[pass]);
                if (actual != expected) {
                    printf("CVA6_DDR_FAIL address=%lx got=%lx expected=%lx\r\n",
                           (uintptr_t)&mem[i], actual, expected);
                    return 1;
                }
            }
        }
    }
    printf("CVA6_DDR_PATTERNS_PASS regions=3 bytes_per_region=65536 patterns=2\r\n");
    // Byte stores exercise every strobe lane across the 64-to-512-bit boundary.
    volatile uint8_t *bytes = (volatile uint8_t *)0x81000000;
    for (unsigned i = 0; i < 512; ++i) bytes[i] = (uint8_t)(i * 37 + 11);
    asm volatile("fence rw, rw" ::: "memory");
    for (unsigned i = 0; i < 512; ++i)
        if (bytes[i] != (uint8_t)(i * 37 + 11)) return 2;
    printf("CVA6_DDR_BYTE_LANES_PASS\r\n");
    volatile uint64_t *atom = (volatile uint64_t *)0x81001000;
    *atom = 41;
    uint64_t before, addend = 1;
    asm volatile("amoadd.d.aqrl %0, %2, (%1)" : "=r"(before) : "r"(atom), "r"(addend) : "memory");
    if (before != 41 || *atom != 42) return 3;
    printf("CVA6_DDR_AMO_PASS\r\n");
    volatile double x = 1.5, y = 2.25;
    if (x + y != 3.75) return 4;
    printf("CVA6_FP64_PASS\r\n");
    set_mie(0);
    clint_set_mtimecmpx(0, clint_get_mtime() + 100);
    uint64_t pending, deadline = get_mcycle() + hz / 100;
    do { asm volatile("csrr %0, mip" : "=r"(pending)); }
    while (!(pending & (1 << 7)) && get_mcycle() < deadline);
    clint_set_mtimecmpx(0, UINT64_MAX);
    if (!(pending & (1 << 7))) return 5;
    printf("CVA6_CLINT_PENDING_PASS\r\nCVA6_ACCEPTANCE_PASS\r\n");
    uart_write_flush(&__uart_base_addr__);
    return 0;
}
