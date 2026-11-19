#include "VFaseSim.h"
#include "verilated.h"
#include <deque>
#include <map>
#include <vector>
#include <cstdint>
#include <cstdio>
#include <stdexcept>
#include <string>
#include <algorithm>
#include <fstream>
#include <csignal>
#include <fcntl.h>
#include <unistd.h>
#include <cstdlib>
#include <termios.h>
static volatile std::sig_atomic_t stop_sim=0;
static void stop_handler(int){stop_sim=1;}

class Simulation {
public:
  VerilatedContext context;
  VFaseSim dut{&context};
  uint64_t cycles=0;
  static constexpr unsigned BIT=108;
  std::map<uint64_t,uint8_t> ram;
  struct Address {uint64_t addr;unsigned id,len,size,burst,pos=0;};
  struct Write {uint64_t data;unsigned mask;bool last;};
  struct Read {uint64_t data;unsigned id;bool last;uint64_t due;};
  std::deque<Address> aw;
  std::deque<Write> w;
  std::deque<unsigned> b;
  std::deque<Read> r;
  std::deque<uint8_t> tx,rx;
  int txbit=-1,txcount=0,rxbit=-1,rxcount=0;
  uint8_t txbyte=0,rxbyte=0;
  int oldtx=1;
  bool resetting=true;
  Simulation() {
    dut.rst_n = 0;
    dut.memory_ready = 0;
    run(32);
    dut.rst_n = 1;
    resetting = false;
    run(4096);
    check((dut.fase_debug & 0x8000) == 0, "hardware inited stays low before DDR ready");
    dut.memory_ready = 1;
  }
  static uint64_t beat_address(uint64_t start, unsigned len, unsigned size, unsigned burst, unsigned beat) {
    if (burst == 0) return start;
    const uint64_t next = start + (uint64_t(beat) << size);
    if (burst == 1) return next;
    const uint64_t mask = ((uint64_t(len) + 1) << size) - 1;
    return (start & ~mask) | (next & mask);
  }
  uint64_t read64(uint64_t address){uint64_t value=0;for(int i=0;i<8;i++)value|=uint64_t(ram[address+i])<<(8*i);return value;}
  void memory_drive(){
    dut.mem_axi4_0_aw_ready=aw.size()<8 && (cycles%7!=0);
    dut.mem_axi4_0_w_ready=w.size()<32 && (cycles%5!=0);
    dut.mem_axi4_0_ar_ready=r.size()<64 && (cycles%11!=0);
    dut.mem_axi4_0_b_valid=!b.empty();
    dut.mem_axi4_0_b_bits_id=b.empty()?0:b.front();
    dut.mem_axi4_0_b_bits_resp=0;
    dut.mem_axi4_0_r_valid=!r.empty()&&r.front().due<=cycles;
    dut.mem_axi4_0_r_bits_data=r.empty()?0:r.front().data;
    dut.mem_axi4_0_r_bits_id=r.empty()?0:r.front().id;
    dut.mem_axi4_0_r_bits_last=r.empty()?0:r.front().last;
    dut.mem_axi4_0_r_bits_resp=0;
  }
  void memory_capture(){
    if(resetting)return;
    if(dut.mem_axi4_0_b_valid&&dut.mem_axi4_0_b_ready)b.pop_front();
    if(dut.mem_axi4_0_r_valid&&dut.mem_axi4_0_r_ready)r.pop_front();
    if(dut.mem_axi4_0_aw_valid&&dut.mem_axi4_0_aw_ready)
      aw.push_back({dut.mem_axi4_0_aw_bits_addr,dut.mem_axi4_0_aw_bits_id,dut.mem_axi4_0_aw_bits_len,dut.mem_axi4_0_aw_bits_size,dut.mem_axi4_0_aw_bits_burst});
    if(dut.mem_axi4_0_w_valid&&dut.mem_axi4_0_w_ready)
      w.push_back({dut.mem_axi4_0_w_bits_data,dut.mem_axi4_0_w_bits_strb,bool(dut.mem_axi4_0_w_bits_last)});
    while(!aw.empty()&&!w.empty()){
      auto &a=aw.front();auto data=w.front();w.pop_front();
      const uint64_t address=beat_address(a.addr,a.len,a.size,a.burst,a.pos)&~7ULL;
      for(int lane=0;lane<8;lane++)if(data.mask&(1<<lane))ram[address+lane]=data.data>>(lane*8);
      if(data.last!=(a.pos==a.len))throw std::runtime_error("AXI WLAST mismatch");
      if(a.pos++==a.len){b.push_back(a.id);aw.pop_front();}
    }
    if(dut.mem_axi4_0_ar_valid&&dut.mem_axi4_0_ar_ready){
      const auto address=dut.mem_axi4_0_ar_bits_addr;
      const unsigned len=dut.mem_axi4_0_ar_bits_len,size=dut.mem_axi4_0_ar_bits_size,id=dut.mem_axi4_0_ar_bits_id;
      for(unsigned i=0;i<=len;i++)r.push_back({read64(beat_address(address,len,size,dut.mem_axi4_0_ar_bits_burst,i)&~7ULL),id,i==len,cycles+24+i});
    }
  }
  void serial_drive(){
    if(txcount>0){--txcount;return;}
    if(txbit<0){
      dut.fase_uart_rxd=1;
      if(tx.empty())return;
      txbyte=tx.front();tx.pop_front();txbit=0;
    }
    dut.fase_uart_rxd=txbit==0?0:txbit<=8?((txbyte>>(txbit-1))&1):1;
    txcount=BIT-1;
    if(++txbit==11)txbit=-1;
  }
  void serial_capture(){
    const int line=dut.fase_uart_txd;
    if(rxbit<0){if(oldtx==1&&!line){rxbit=0;rxcount=BIT+BIT/2-1;rxbyte=0;}}
    else if(rxcount>0)--rxcount;
    else if(rxbit<8){rxbyte|=line<<rxbit++;rxcount=BIT-1;}
    else {if(!line)throw std::runtime_error("UART framing");rx.push_back(rxbyte);rxbit=-1;}
    oldtx=line;
  }
  void tick(){
    serial_drive();dut.clk=0;memory_drive();dut.eval();
    memory_capture();dut.clk=1;dut.eval();serial_capture();
    ++cycles;context.timeInc(1);
    if(context.gotFinish())throw std::runtime_error("RTL finished/asserted");
  }
  void run(unsigned n){while(n--)tick();}
  std::vector<uint8_t> command(std::vector<uint8_t> data,unsigned count=1){
    if(!rx.empty())throw std::runtime_error("unexpected pending serial byte");
    for(auto byte:data)tx.push_back(byte);
    const uint64_t deadline=cycles+1500000;
    while(rx.size()<count&&cycles<deadline)tick();
    if(rx.size()<count){std::fprintf(stderr,"timeout op=%u cycle=%llu ctrl=%u core=0x%04x\n",data[0],(unsigned long long)cycles,dut.fase_uart_state,dut.fase_debug);throw std::runtime_error("serial timeout");}
    std::vector<uint8_t> result;while(count--){result.push_back(rx.front());rx.pop_front();}
    if(result[0]!=data[0])throw std::runtime_error("serial ACK mismatch");
    run(BIT*2);return result;
  }
  static void append(std::vector<uint8_t>&cmd,uint64_t value,unsigned n){while(n--){cmd.push_back(value);value>>=8;}}
  static uint64_t value(const std::vector<uint8_t>&data,unsigned offset=1,unsigned size=8){uint64_t value=0;for(unsigned i=0;i<size;i++)value|=uint64_t(data[offset+i])<<(i*8);return value;}
  void regwrite(unsigned index,uint64_t data){std::vector<uint8_t> cmd{9,0,uint8_t(index),0};append(cmd,data,8);command(cmd);}
  uint64_t regread(unsigned index){return value(command({8,0,uint8_t(index),0},9));}
  void memwrite(uint64_t address,uint64_t data){std::vector<uint8_t> cmd{11,0};append(cmd,address,6);append(cmd,data,8);command(cmd);}
  uint64_t memread(uint64_t address){std::vector<uint8_t> cmd{10,0};append(cmd,address,6);return value(command(cmd,9));}
  void inst(uint32_t instruction){std::vector<uint8_t>cmd{30,0};append(cmd,instruction,4);command(cmd);}
  void redirect(uint64_t pc){std::vector<uint8_t>cmd{4,0};append(cmd,pc,6);command(cmd);}
  void check(bool pass,const char *name){if(!pass)throw std::runtime_error(name);std::printf("PASS %s cycle=%llu\n",name,(unsigned long long)cycles);std::fflush(stdout);}
};

int main(int argc,char **argv){
  Verilated::commandArgs(argc,argv);
  try{
    Simulation s;
    if(argc==3&&std::string(argv[1])=="--pty-file"){
      int fd=posix_openpt(O_RDWR|O_NOCTTY|O_NONBLOCK);
      if(fd<0||grantpt(fd)||unlockpt(fd))throw std::runtime_error("PTY allocation failed");
      int slave=open(ptsname(fd),O_RDWR|O_NOCTTY);
      termios settings{};
      if(slave<0||tcgetattr(slave,&settings))throw std::runtime_error("PTY termios failed");
      cfmakeraw(&settings);
      if(tcsetattr(slave,TCSANOW,&settings))throw std::runtime_error("PTY raw mode failed");
      std::ofstream(argv[2])<<ptsname(fd)<<"\n";
      std::signal(SIGTERM,stop_handler);std::signal(SIGINT,stop_handler);
      std::printf("CVA6 RTL PTY %s\n",ptsname(fd));std::fflush(stdout);
      while(!stop_sim){
        if(s.cycles%128==0){
          uint8_t data[512];ssize_t n=read(fd,data,sizeof(data));
          for(ssize_t i=0;i<n;i++)s.tx.push_back(data[i]);
        }
        s.tick();
        const auto phase=s.dut.fase_fault;
        if(s.cycles%1000000==0){
          std::printf("CVA6_PTY cycle=%llu phase=%u serial_pending=%zu ctrl=%u\n",(unsigned long long)s.cycles,unsigned(phase),s.tx.size(),s.dut.fase_uart_state);std::fflush(stdout);
        }
        if(phase)throw std::runtime_error("unexpected injected exception during Host run");
        while(!s.rx.empty()){
          uint8_t byte=s.rx.front();if(write(fd,&byte,1)!=1)break;s.rx.pop_front();
        }
      }
      std::printf("CVA6 RTL PTY stopped cycle=%llu\n",(unsigned long long)s.cycles);
      close(slave);close(fd);return 0;
    }
    s.run(12000);
    s.command({16},9);
    s.check(true,"original controller boot and CLK UART protocol");
    if(argc==2&&std::string(argv[1])=="--fault"){
      for(auto byte:std::vector<uint8_t>{30,0,0x73,0,0,0})s.tx.push_back(byte);
      s.run(100000);
      const auto phase=s.dut.fase_fault;
      std::printf("FAULT diagnostic phase=%u rx=%zu first=%u\n",unsigned(phase),s.rx.size(),s.rx.empty()?0:s.rx.front());
      s.check(phase&&s.rx.empty(),"injected exception enters fault and never acknowledges completion");
      return 0;
    }
    for(unsigned i=0;i<32;i++)s.regwrite(i,0xa500000000000000ULL|(0x102030405ULL*i));
    for(unsigned i=0;i<32;i++)s.check(s.regread(i)==(i?(0xa500000000000000ULL|(0x102030405ULL*i)):0),"direct GPR roundtrip/x0");
    s.regwrite(5,0x12345678);s.inst(0x00528293); // addi x5,x5,5
    s.check(s.regread(5)==0x1234567d,"injected arithmetic retires exactly once");
    const auto backup5=s.regread(5),backup6=s.regread(6);
    s.memwrite(0x80010000,0x0123456789abcdefULL);
    s.check(s.memread(0x80010000)==0x0123456789abcdefULL,"injected load/store with delayed AXI");
    s.check(s.regread(5)==backup5&&s.regread(6)==backup6,"controller temporary GPR restore");
    s.regwrite(32+7,0x7ff8000012345678ULL);
    s.check(s.regread(32+7)==0x7ff8000012345678ULL,"floating register FMV through normal FPU");
    s.command({7,0});s.command({5,0}); // fence.i / sfence.vma
    s.check(true,"fence.i and sfence.vma complete");
    // Uncompressed U program: increment x20 and ECALL. No ABI/runtime dependency.
    s.memwrite(0x80000000,0x00000073001a0a13ULL);
    s.command({7,0});
    s.regwrite(20,77);s.redirect(0x80000000);
    auto event=s.command({0},15);
    s.check(event[1]==0&&event[2]==8&&Simulation::value(event,3,6)==0x80000004,"MRET U-mode ECALL precise trap");
    s.check(s.regread(20)==78,"user architectural GPR preserved across trap");
    // Tight U loop with outstanding branch activity; stop by original HALT/ITR.
    s.memwrite(0x80000000,0xffdff06f001a0a13ULL);
    s.command({7,0});s.redirect(0x80000000);s.run(500);
    s.command({1,0});
    auto stopped=s.regread(20);s.run(4000);
    s.check(s.regread(20)==stopped,"external HALT drains and freezes architectural progress");
    s.redirect(0x80000000);s.run(1000);s.command({2,0});
    auto interrupt=s.command({0},15);
    std::printf("ITR raw cause=0x%x\n",interrupt[2]);
    s.check(interrupt[1]==0&&interrupt[2]==0x0b,"external ITR captured as machine external interrupt");
    s.command({1,0});
    std::ifstream stress("stress.bin",std::ios::binary);
    if(!stress)throw std::runtime_error("stress binary missing");
    std::vector<uint8_t> code{std::istreambuf_iterator<char>(stress),std::istreambuf_iterator<char>()};
    for(unsigned offset=0;offset<code.size();offset+=8){
      uint64_t data=0;for(unsigned i=0;i<8&&offset+i<code.size();i++)data|=uint64_t(code[offset+i])<<(8*i);
      s.memwrite(0x80001000+offset,data);
    }
    s.regwrite(32,0x3ff0000000000000ULL);s.regwrite(33,0x4008000000000000ULL);
    s.command({7,0});
    for(unsigned trial=0;trial<4;trial++){
      s.regwrite(20,0);
      s.redirect(0x80001000);s.run(17+trial*23);s.command({1,0});
      s.check(s.regread(20)>0,"stress loop retired memory and FDIV operations");
      s.inst(0x342029f3); // csrr x19,mcause
      s.check(s.regread(19)==0x800000000000000bULL,"stress stop cause is requested external interrupt");
      s.regwrite(21,0xfeed000000000000ULL+trial);s.regwrite(22,0xcafe000000000000ULL+trial);
      s.run(10000);
      s.check(s.regread(21)==0xfeed000000000000ULL+trial&&s.regread(22)==0xcafe000000000000ULL+trial,"HALT drains DIV/FDIV/LSU before direct writes");
    }
    auto pagecmd=[](uint8_t op,uint64_t address){std::vector<uint8_t> cmd{op,0};Simulation::append(cmd,address>>12,5);return cmd;};
    auto pgwt=pagecmd(14|(3<<5),0x80020000);
    for(unsigned i=0;i<512;i++)pgwt.push_back((i*29+11)&255);
    s.command(pgwt);
    auto pgrd=s.command(pagecmd(12|(3<<5),0x80020000),513);
    for(unsigned i=0;i<512;i++)if(pgrd[i+1]!=((i*29+11)&255))throw std::runtime_error("page segment mismatch");
    s.check(true,"PGWT/PGRD 512-byte segment with nonzero offset");
    auto pgcopy=pagecmd(15,0x80021000);Simulation::append(pgcopy,0x80020000>>12,5);s.command(pgcopy);
    s.check(s.memread(0x80021600)==s.memread(0x80020600),"PGCP full page");
    auto pgset=pagecmd(13,0x80022000);Simulation::append(pgset,0x55aa55aadeadbeefULL,8);s.command(pgset);
    s.check(s.memread(0x80022000)==0x55aa55aadeadbeefULL&&s.memread(0x80022ff8)==0x55aa55aadeadbeefULL,"PGST whole page endpoints");
    s.command(pagecmd(20,0x80022000));
    s.check(s.memread(0x80022000)==0&&s.memread(0x80022ff8)==0,"PGZERO whole page endpoints");
    s.check(true,"CVA6 FASE integrated serial smoke");
    return 0;
  }catch(const std::exception &error){std::fprintf(stderr,"FAIL %s\n",error.what());return 1;}
}
