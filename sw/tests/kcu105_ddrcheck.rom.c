// SPDX-License-Identifier: Apache-2.0

#include <stddef.h>
#include <stdint.h>

#include "dif/clint.h"
#include "dif/uart.h"
#include "params.h"
#include "printf.h"
#include "regs/cheshire.h"
#include "util.h"

enum { Words = 16384 };

static uint32_t pattern(uintptr_t address, uint32_t salt) {
    return (uint32_t)address ^ salt;
}

int main(void) {
    const uintptr_t bases[] = {0x81000000, 0xc1000000};
    const uint32_t salts[] = {0x5aa5a55a, 0xa55a5aa5};
    uint32_t rtc_hz = CHS_REGS->rtc_freq.f.ref_freq;
    uint64_t clock_hz = clint_get_core_freq(rtc_hz, 2500);
    uart_init(&__uart_base_addr__, clock_hz, __BOOT_BAUDRATE);
    printf("KCU105 CVA6 SPM PASS; clock %lu Hz\r\n", (unsigned long)clock_hz);
    uart_write_flush(&__uart_base_addr__);

    const uint64_t machine_timer_pending = 1u << 7;
    uint64_t pending;
    set_mie(0);
    clint_set_mtimecmpx(0, clint_get_mtime() + 100);
    uint64_t deadline = get_mcycle() + clock_hz / 100;
    do {
        asm volatile("csrr %0, mip" : "=r"(pending));
    } while (!(pending & machine_timer_pending) && get_mcycle() < deadline);
    clint_set_mtimecmpx(0, UINT64_MAX);
    if (!(pending & machine_timer_pending)) {
        printf("KCU105 CLINT FAIL\r\n");
        uart_write_flush(&__uart_base_addr__);
        return 1;
    }
    printf("KCU105 CLINT PASS\r\n");
    uart_write_flush(&__uart_base_addr__);

    for (size_t pass = 0; pass < sizeof(salts) / sizeof(salts[0]); ++pass) {
        for (size_t region = 0; region < sizeof(bases) / sizeof(bases[0]); ++region) {
            volatile uint32_t *words = (volatile uint32_t *)bases[region];
            for (size_t index = 0; index < Words; ++index) {
                words[index] = pattern((uintptr_t)&words[index], salts[pass]);
            }
        }
        asm volatile("fence rw, rw" ::: "memory");
        for (size_t region = 0; region < sizeof(bases) / sizeof(bases[0]); ++region) {
            volatile uint32_t *words = (volatile uint32_t *)bases[region];
            for (size_t index = 0; index < Words; ++index) {
                uint32_t expected = pattern((uintptr_t)&words[index], salts[pass]);
                uint32_t actual = words[index];
                if (actual != expected) {
                    printf("KCU105 DDR FAIL at 0x%lx: got %08x expected %08x\r\n",
                           (unsigned long)&words[index], actual, expected);
                    uart_write_flush(&__uart_base_addr__);
                    return 2;
                }
            }
        }
    }
    printf("KCU105 DDR PASS: two 64 KiB regions, two patterns\r\n");
    uart_write_flush(&__uart_base_addr__);
    return 0;
}
