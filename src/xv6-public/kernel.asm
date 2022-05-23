
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 80 10 00       	mov    $0x108000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 a5 10 80       	mov    $0x8010a5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 15 2b 10 80       	mov    $0x80102b15,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 c0 a5 10 80       	push   $0x8010a5c0
80100046:	e8 70 3c 00 00       	call   80103cbb <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 10 ed 10 80    	mov    0x8010ed10,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb bc ec 10 80    	cmp    $0x8010ecbc,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 c0 a5 10 80       	push   $0x8010a5c0
8010007c:	e8 a3 3c 00 00       	call   80103d24 <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 fb 39 00 00       	call   80103a87 <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d 0c ed 10 80    	mov    0x8010ed0c,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb bc ec 10 80    	cmp    $0x8010ecbc,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 c0 a5 10 80       	push   $0x8010a5c0
801000ca:	e8 55 3c 00 00       	call   80103d24 <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 ad 39 00 00       	call   80103a87 <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 e0 65 10 80       	push   $0x801065e0
801000ef:	e8 68 02 00 00       	call   8010035c <panic>

801000f4 <binit>:
{
801000f4:	f3 0f 1e fb          	endbr32 
801000f8:	55                   	push   %ebp
801000f9:	89 e5                	mov    %esp,%ebp
801000fb:	53                   	push   %ebx
801000fc:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000ff:	68 f1 65 10 80       	push   $0x801065f1
80100104:	68 c0 a5 10 80       	push   $0x8010a5c0
80100109:	e8 5d 3a 00 00       	call   80103b6b <initlock>
  bcache.head.prev = &bcache.head;
8010010e:	c7 05 0c ed 10 80 bc 	movl   $0x8010ecbc,0x8010ed0c
80100115:	ec 10 80 
  bcache.head.next = &bcache.head;
80100118:	c7 05 10 ed 10 80 bc 	movl   $0x8010ecbc,0x8010ed10
8010011f:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100122:	83 c4 10             	add    $0x10,%esp
80100125:	bb f4 a5 10 80       	mov    $0x8010a5f4,%ebx
8010012a:	eb 37                	jmp    80100163 <binit+0x6f>
    b->next = bcache.head.next;
8010012c:	a1 10 ed 10 80       	mov    0x8010ed10,%eax
80100131:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100134:	c7 43 50 bc ec 10 80 	movl   $0x8010ecbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010013b:	83 ec 08             	sub    $0x8,%esp
8010013e:	68 f8 65 10 80       	push   $0x801065f8
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	50                   	push   %eax
80100147:	e8 04 39 00 00       	call   80103a50 <initsleeplock>
    bcache.head.next->prev = b;
8010014c:	a1 10 ed 10 80       	mov    0x8010ed10,%eax
80100151:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100154:	89 1d 10 ed 10 80    	mov    %ebx,0x8010ed10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010015a:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
80100160:	83 c4 10             	add    $0x10,%esp
80100163:	81 fb bc ec 10 80    	cmp    $0x8010ecbc,%ebx
80100169:	72 c1                	jb     8010012c <binit+0x38>
}
8010016b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016e:	c9                   	leave  
8010016f:	c3                   	ret    

80100170 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100170:	f3 0f 1e fb          	endbr32 
80100174:	55                   	push   %ebp
80100175:	89 e5                	mov    %esp,%ebp
80100177:	53                   	push   %ebx
80100178:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
8010017b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017e:	8b 45 08             	mov    0x8(%ebp),%eax
80100181:	e8 ae fe ff ff       	call   80100034 <bget>
80100186:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100188:	f6 00 02             	testb  $0x2,(%eax)
8010018b:	74 07                	je     80100194 <bread+0x24>
    iderw(b);
  }
  return b;
}
8010018d:	89 d8                	mov    %ebx,%eax
8010018f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100192:	c9                   	leave  
80100193:	c3                   	ret    
    iderw(b);
80100194:	83 ec 0c             	sub    $0xc,%esp
80100197:	50                   	push   %eax
80100198:	e8 ec 1c 00 00       	call   80101e89 <iderw>
8010019d:	83 c4 10             	add    $0x10,%esp
  return b;
801001a0:	eb eb                	jmp    8010018d <bread+0x1d>

801001a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a2:	f3 0f 1e fb          	endbr32 
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	53                   	push   %ebx
801001aa:	83 ec 10             	sub    $0x10,%esp
801001ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001b0:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b3:	50                   	push   %eax
801001b4:	e8 60 39 00 00       	call   80103b19 <holdingsleep>
801001b9:	83 c4 10             	add    $0x10,%esp
801001bc:	85 c0                	test   %eax,%eax
801001be:	74 14                	je     801001d4 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001c0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c3:	83 ec 0c             	sub    $0xc,%esp
801001c6:	53                   	push   %ebx
801001c7:	e8 bd 1c 00 00       	call   80101e89 <iderw>
}
801001cc:	83 c4 10             	add    $0x10,%esp
801001cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d2:	c9                   	leave  
801001d3:	c3                   	ret    
    panic("bwrite");
801001d4:	83 ec 0c             	sub    $0xc,%esp
801001d7:	68 ff 65 10 80       	push   $0x801065ff
801001dc:	e8 7b 01 00 00       	call   8010035c <panic>

801001e1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e1:	f3 0f 1e fb          	endbr32 
801001e5:	55                   	push   %ebp
801001e6:	89 e5                	mov    %esp,%ebp
801001e8:	56                   	push   %esi
801001e9:	53                   	push   %ebx
801001ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ed:	8d 73 0c             	lea    0xc(%ebx),%esi
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 20 39 00 00       	call   80103b19 <holdingsleep>
801001f9:	83 c4 10             	add    $0x10,%esp
801001fc:	85 c0                	test   %eax,%eax
801001fe:	74 6b                	je     8010026b <brelse+0x8a>
    panic("brelse");

  releasesleep(&b->lock);
80100200:	83 ec 0c             	sub    $0xc,%esp
80100203:	56                   	push   %esi
80100204:	e8 d1 38 00 00       	call   80103ada <releasesleep>

  acquire(&bcache.lock);
80100209:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
80100210:	e8 a6 3a 00 00       	call   80103cbb <acquire>
  b->refcnt--;
80100215:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100218:	83 e8 01             	sub    $0x1,%eax
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	83 c4 10             	add    $0x10,%esp
80100221:	85 c0                	test   %eax,%eax
80100223:	75 2f                	jne    80100254 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100225:	8b 43 54             	mov    0x54(%ebx),%eax
80100228:	8b 53 50             	mov    0x50(%ebx),%edx
8010022b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022e:	8b 43 50             	mov    0x50(%ebx),%eax
80100231:	8b 53 54             	mov    0x54(%ebx),%edx
80100234:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100237:	a1 10 ed 10 80       	mov    0x8010ed10,%eax
8010023c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010023f:	c7 43 50 bc ec 10 80 	movl   $0x8010ecbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100246:	a1 10 ed 10 80       	mov    0x8010ed10,%eax
8010024b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024e:	89 1d 10 ed 10 80    	mov    %ebx,0x8010ed10
  }
  
  release(&bcache.lock);
80100254:	83 ec 0c             	sub    $0xc,%esp
80100257:	68 c0 a5 10 80       	push   $0x8010a5c0
8010025c:	e8 c3 3a 00 00       	call   80103d24 <release>
}
80100261:	83 c4 10             	add    $0x10,%esp
80100264:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100267:	5b                   	pop    %ebx
80100268:	5e                   	pop    %esi
80100269:	5d                   	pop    %ebp
8010026a:	c3                   	ret    
    panic("brelse");
8010026b:	83 ec 0c             	sub    $0xc,%esp
8010026e:	68 06 66 10 80       	push   $0x80106606
80100273:	e8 e4 00 00 00       	call   8010035c <panic>

80100278 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100278:	f3 0f 1e fb          	endbr32 
8010027c:	55                   	push   %ebp
8010027d:	89 e5                	mov    %esp,%ebp
8010027f:	57                   	push   %edi
80100280:	56                   	push   %esi
80100281:	53                   	push   %ebx
80100282:	83 ec 28             	sub    $0x28,%esp
80100285:	8b 7d 08             	mov    0x8(%ebp),%edi
80100288:	8b 75 0c             	mov    0xc(%ebp),%esi
8010028b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010028e:	57                   	push   %edi
8010028f:	e8 fc 13 00 00       	call   80101690 <iunlock>
  target = n;
80100294:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100297:	c7 04 24 20 95 10 80 	movl   $0x80109520,(%esp)
8010029e:	e8 18 3a 00 00       	call   80103cbb <acquire>
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	85 db                	test   %ebx,%ebx
801002a8:	0f 8e 8f 00 00 00    	jle    8010033d <consoleread+0xc5>
    while(input.r == input.w){
801002ae:	a1 a0 ef 10 80       	mov    0x8010efa0,%eax
801002b3:	3b 05 a4 ef 10 80    	cmp    0x8010efa4,%eax
801002b9:	75 47                	jne    80100302 <consoleread+0x8a>
      if(myproc()->killed){
801002bb:	e8 05 30 00 00       	call   801032c5 <myproc>
801002c0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002c4:	75 17                	jne    801002dd <consoleread+0x65>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c6:	83 ec 08             	sub    $0x8,%esp
801002c9:	68 20 95 10 80       	push   $0x80109520
801002ce:	68 a0 ef 10 80       	push   $0x8010efa0
801002d3:	e8 b0 34 00 00       	call   80103788 <sleep>
801002d8:	83 c4 10             	add    $0x10,%esp
801002db:	eb d1                	jmp    801002ae <consoleread+0x36>
        release(&cons.lock);
801002dd:	83 ec 0c             	sub    $0xc,%esp
801002e0:	68 20 95 10 80       	push   $0x80109520
801002e5:	e8 3a 3a 00 00       	call   80103d24 <release>
        ilock(ip);
801002ea:	89 3c 24             	mov    %edi,(%esp)
801002ed:	e8 d8 12 00 00       	call   801015ca <ilock>
        return -1;
801002f2:	83 c4 10             	add    $0x10,%esp
801002f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fd:	5b                   	pop    %ebx
801002fe:	5e                   	pop    %esi
801002ff:	5f                   	pop    %edi
80100300:	5d                   	pop    %ebp
80100301:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
80100302:	8d 50 01             	lea    0x1(%eax),%edx
80100305:	89 15 a0 ef 10 80    	mov    %edx,0x8010efa0
8010030b:	89 c2                	mov    %eax,%edx
8010030d:	83 e2 7f             	and    $0x7f,%edx
80100310:	0f b6 92 20 ef 10 80 	movzbl -0x7fef10e0(%edx),%edx
80100317:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
8010031a:	80 fa 04             	cmp    $0x4,%dl
8010031d:	74 14                	je     80100333 <consoleread+0xbb>
    *dst++ = c;
8010031f:	8d 46 01             	lea    0x1(%esi),%eax
80100322:	88 16                	mov    %dl,(%esi)
    --n;
80100324:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100327:	83 f9 0a             	cmp    $0xa,%ecx
8010032a:	74 11                	je     8010033d <consoleread+0xc5>
    *dst++ = c;
8010032c:	89 c6                	mov    %eax,%esi
8010032e:	e9 73 ff ff ff       	jmp    801002a6 <consoleread+0x2e>
      if(n < target){
80100333:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100336:	73 05                	jae    8010033d <consoleread+0xc5>
        input.r--;
80100338:	a3 a0 ef 10 80       	mov    %eax,0x8010efa0
  release(&cons.lock);
8010033d:	83 ec 0c             	sub    $0xc,%esp
80100340:	68 20 95 10 80       	push   $0x80109520
80100345:	e8 da 39 00 00       	call   80103d24 <release>
  ilock(ip);
8010034a:	89 3c 24             	mov    %edi,(%esp)
8010034d:	e8 78 12 00 00       	call   801015ca <ilock>
  return target - n;
80100352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100355:	29 d8                	sub    %ebx,%eax
80100357:	83 c4 10             	add    $0x10,%esp
8010035a:	eb 9e                	jmp    801002fa <consoleread+0x82>

8010035c <panic>:
{
8010035c:	f3 0f 1e fb          	endbr32 
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	53                   	push   %ebx
80100364:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100367:	fa                   	cli    
  cons.locking = 0;
80100368:	c7 05 54 95 10 80 00 	movl   $0x0,0x80109554
8010036f:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100372:	e8 a2 20 00 00       	call   80102419 <lapicid>
80100377:	83 ec 08             	sub    $0x8,%esp
8010037a:	50                   	push   %eax
8010037b:	68 0d 66 10 80       	push   $0x8010660d
80100380:	e8 a4 02 00 00       	call   80100629 <cprintf>
  cprintf(s);
80100385:	83 c4 04             	add    $0x4,%esp
80100388:	ff 75 08             	pushl  0x8(%ebp)
8010038b:	e8 99 02 00 00       	call   80100629 <cprintf>
  cprintf("\n");
80100390:	c7 04 24 37 6f 10 80 	movl   $0x80106f37,(%esp)
80100397:	e8 8d 02 00 00       	call   80100629 <cprintf>
  getcallerpcs(&s, pcs);
8010039c:	83 c4 08             	add    $0x8,%esp
8010039f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801003a2:	50                   	push   %eax
801003a3:	8d 45 08             	lea    0x8(%ebp),%eax
801003a6:	50                   	push   %eax
801003a7:	e8 de 37 00 00       	call   80103b8a <getcallerpcs>
  for(i=0; i<10; i++)
801003ac:	83 c4 10             	add    $0x10,%esp
801003af:	bb 00 00 00 00       	mov    $0x0,%ebx
801003b4:	eb 17                	jmp    801003cd <panic+0x71>
    cprintf(" %p", pcs[i]);
801003b6:	83 ec 08             	sub    $0x8,%esp
801003b9:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003bd:	68 21 66 10 80       	push   $0x80106621
801003c2:	e8 62 02 00 00       	call   80100629 <cprintf>
  for(i=0; i<10; i++)
801003c7:	83 c3 01             	add    $0x1,%ebx
801003ca:	83 c4 10             	add    $0x10,%esp
801003cd:	83 fb 09             	cmp    $0x9,%ebx
801003d0:	7e e4                	jle    801003b6 <panic+0x5a>
  panicked = 1; // freeze other CPU
801003d2:	c7 05 58 95 10 80 01 	movl   $0x1,0x80109558
801003d9:	00 00 00 
  for(;;)
801003dc:	eb fe                	jmp    801003dc <panic+0x80>

801003de <cgaputc>:
{
801003de:	55                   	push   %ebp
801003df:	89 e5                	mov    %esp,%ebp
801003e1:	57                   	push   %edi
801003e2:	56                   	push   %esi
801003e3:	53                   	push   %ebx
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e9:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003ee:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f3:	89 ca                	mov    %ecx,%edx
801003f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003fb:	89 da                	mov    %ebx,%edx
801003fd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fe:	0f b6 f8             	movzbl %al,%edi
80100401:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100404:	b8 0f 00 00 00       	mov    $0xf,%eax
80100409:	89 ca                	mov    %ecx,%edx
8010040b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040c:	89 da                	mov    %ebx,%edx
8010040e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040f:	0f b6 c8             	movzbl %al,%ecx
80100412:	09 f9                	or     %edi,%ecx
  if(c == '\n')
80100414:	83 fe 0a             	cmp    $0xa,%esi
80100417:	74 66                	je     8010047f <cgaputc+0xa1>
  else if(c == BACKSPACE){
80100419:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041f:	74 7f                	je     801004a0 <cgaputc+0xc2>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100421:	89 f0                	mov    %esi,%eax
80100423:	0f b6 f0             	movzbl %al,%esi
80100426:	8d 59 01             	lea    0x1(%ecx),%ebx
80100429:	66 81 ce 00 07       	or     $0x700,%si
8010042e:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100435:	80 
  if(pos < 0 || pos > 25*80)
80100436:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010043c:	77 6f                	ja     801004ad <cgaputc+0xcf>
  if((pos/80) >= 24){  // Scroll up.
8010043e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100444:	7f 74                	jg     801004ba <cgaputc+0xdc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100446:	be d4 03 00 00       	mov    $0x3d4,%esi
8010044b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100450:	89 f2                	mov    %esi,%edx
80100452:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100453:	89 d8                	mov    %ebx,%eax
80100455:	c1 f8 08             	sar    $0x8,%eax
80100458:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010045d:	89 ca                	mov    %ecx,%edx
8010045f:	ee                   	out    %al,(%dx)
80100460:	b8 0f 00 00 00       	mov    $0xf,%eax
80100465:	89 f2                	mov    %esi,%edx
80100467:	ee                   	out    %al,(%dx)
80100468:	89 d8                	mov    %ebx,%eax
8010046a:	89 ca                	mov    %ecx,%edx
8010046c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010046d:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100474:	80 20 07 
}
80100477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010047a:	5b                   	pop    %ebx
8010047b:	5e                   	pop    %esi
8010047c:	5f                   	pop    %edi
8010047d:	5d                   	pop    %ebp
8010047e:	c3                   	ret    
    pos += 80 - pos%80;
8010047f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100484:	89 c8                	mov    %ecx,%eax
80100486:	f7 ea                	imul   %edx
80100488:	c1 fa 05             	sar    $0x5,%edx
8010048b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010048e:	c1 e0 04             	shl    $0x4,%eax
80100491:	89 ca                	mov    %ecx,%edx
80100493:	29 c2                	sub    %eax,%edx
80100495:	bb 50 00 00 00       	mov    $0x50,%ebx
8010049a:	29 d3                	sub    %edx,%ebx
8010049c:	01 cb                	add    %ecx,%ebx
8010049e:	eb 96                	jmp    80100436 <cgaputc+0x58>
    if(pos > 0) --pos;
801004a0:	85 c9                	test   %ecx,%ecx
801004a2:	7e 05                	jle    801004a9 <cgaputc+0xcb>
801004a4:	8d 59 ff             	lea    -0x1(%ecx),%ebx
801004a7:	eb 8d                	jmp    80100436 <cgaputc+0x58>
  pos |= inb(CRTPORT+1);
801004a9:	89 cb                	mov    %ecx,%ebx
801004ab:	eb 89                	jmp    80100436 <cgaputc+0x58>
    panic("pos under/overflow");
801004ad:	83 ec 0c             	sub    $0xc,%esp
801004b0:	68 25 66 10 80       	push   $0x80106625
801004b5:	e8 a2 fe ff ff       	call   8010035c <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004ba:	83 ec 04             	sub    $0x4,%esp
801004bd:	68 60 0e 00 00       	push   $0xe60
801004c2:	68 a0 80 0b 80       	push   $0x800b80a0
801004c7:	68 00 80 0b 80       	push   $0x800b8000
801004cc:	e8 1e 39 00 00       	call   80103def <memmove>
    pos -= 80;
801004d1:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004d4:	b8 80 07 00 00       	mov    $0x780,%eax
801004d9:	29 d8                	sub    %ebx,%eax
801004db:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004e2:	83 c4 0c             	add    $0xc,%esp
801004e5:	01 c0                	add    %eax,%eax
801004e7:	50                   	push   %eax
801004e8:	6a 00                	push   $0x0
801004ea:	52                   	push   %edx
801004eb:	e8 7f 38 00 00       	call   80103d6f <memset>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 4e ff ff ff       	jmp    80100446 <cgaputc+0x68>

801004f8 <consputc>:
  if(panicked){
801004f8:	83 3d 58 95 10 80 00 	cmpl   $0x0,0x80109558
801004ff:	74 03                	je     80100504 <consputc+0xc>
  asm volatile("cli");
80100501:	fa                   	cli    
    for(;;)
80100502:	eb fe                	jmp    80100502 <consputc+0xa>
{
80100504:	55                   	push   %ebp
80100505:	89 e5                	mov    %esp,%ebp
80100507:	53                   	push   %ebx
80100508:	83 ec 04             	sub    $0x4,%esp
8010050b:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
8010050d:	3d 00 01 00 00       	cmp    $0x100,%eax
80100512:	74 18                	je     8010052c <consputc+0x34>
    uartputc(c);
80100514:	83 ec 0c             	sub    $0xc,%esp
80100517:	50                   	push   %eax
80100518:	e8 69 4c 00 00       	call   80105186 <uartputc>
8010051d:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100520:	89 d8                	mov    %ebx,%eax
80100522:	e8 b7 fe ff ff       	call   801003de <cgaputc>
}
80100527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010052a:	c9                   	leave  
8010052b:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	6a 08                	push   $0x8
80100531:	e8 50 4c 00 00       	call   80105186 <uartputc>
80100536:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010053d:	e8 44 4c 00 00       	call   80105186 <uartputc>
80100542:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100549:	e8 38 4c 00 00       	call   80105186 <uartputc>
8010054e:	83 c4 10             	add    $0x10,%esp
80100551:	eb cd                	jmp    80100520 <consputc+0x28>

80100553 <printint>:
{
80100553:	55                   	push   %ebp
80100554:	89 e5                	mov    %esp,%ebp
80100556:	57                   	push   %edi
80100557:	56                   	push   %esi
80100558:	53                   	push   %ebx
80100559:	83 ec 2c             	sub    $0x2c,%esp
8010055c:	89 d6                	mov    %edx,%esi
8010055e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100561:	85 c9                	test   %ecx,%ecx
80100563:	74 0c                	je     80100571 <printint+0x1e>
80100565:	89 c7                	mov    %eax,%edi
80100567:	c1 ef 1f             	shr    $0x1f,%edi
8010056a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010056d:	85 c0                	test   %eax,%eax
8010056f:	78 38                	js     801005a9 <printint+0x56>
    x = xx;
80100571:	89 c1                	mov    %eax,%ecx
  i = 0;
80100573:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100578:	89 c8                	mov    %ecx,%eax
8010057a:	ba 00 00 00 00       	mov    $0x0,%edx
8010057f:	f7 f6                	div    %esi
80100581:	89 df                	mov    %ebx,%edi
80100583:	83 c3 01             	add    $0x1,%ebx
80100586:	0f b6 92 50 66 10 80 	movzbl -0x7fef99b0(%edx),%edx
8010058d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100591:	89 ca                	mov    %ecx,%edx
80100593:	89 c1                	mov    %eax,%ecx
80100595:	39 d6                	cmp    %edx,%esi
80100597:	76 df                	jbe    80100578 <printint+0x25>
  if(sign)
80100599:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010059d:	74 1a                	je     801005b9 <printint+0x66>
    buf[i++] = '-';
8010059f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
801005a4:	8d 5f 02             	lea    0x2(%edi),%ebx
801005a7:	eb 10                	jmp    801005b9 <printint+0x66>
    x = -xx;
801005a9:	f7 d8                	neg    %eax
801005ab:	89 c1                	mov    %eax,%ecx
801005ad:	eb c4                	jmp    80100573 <printint+0x20>
    consputc(buf[i]);
801005af:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
801005b4:	e8 3f ff ff ff       	call   801004f8 <consputc>
  while(--i >= 0)
801005b9:	83 eb 01             	sub    $0x1,%ebx
801005bc:	79 f1                	jns    801005af <printint+0x5c>
}
801005be:	83 c4 2c             	add    $0x2c,%esp
801005c1:	5b                   	pop    %ebx
801005c2:	5e                   	pop    %esi
801005c3:	5f                   	pop    %edi
801005c4:	5d                   	pop    %ebp
801005c5:	c3                   	ret    

801005c6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005c6:	f3 0f 1e fb          	endbr32 
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	57                   	push   %edi
801005ce:	56                   	push   %esi
801005cf:	53                   	push   %ebx
801005d0:	83 ec 18             	sub    $0x18,%esp
801005d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005d6:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005d9:	ff 75 08             	pushl  0x8(%ebp)
801005dc:	e8 af 10 00 00       	call   80101690 <iunlock>
  acquire(&cons.lock);
801005e1:	c7 04 24 20 95 10 80 	movl   $0x80109520,(%esp)
801005e8:	e8 ce 36 00 00       	call   80103cbb <acquire>
  for(i = 0; i < n; i++)
801005ed:	83 c4 10             	add    $0x10,%esp
801005f0:	bb 00 00 00 00       	mov    $0x0,%ebx
801005f5:	39 f3                	cmp    %esi,%ebx
801005f7:	7d 0e                	jge    80100607 <consolewrite+0x41>
    consputc(buf[i] & 0xff);
801005f9:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005fd:	e8 f6 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; i < n; i++)
80100602:	83 c3 01             	add    $0x1,%ebx
80100605:	eb ee                	jmp    801005f5 <consolewrite+0x2f>
  release(&cons.lock);
80100607:	83 ec 0c             	sub    $0xc,%esp
8010060a:	68 20 95 10 80       	push   $0x80109520
8010060f:	e8 10 37 00 00       	call   80103d24 <release>
  ilock(ip);
80100614:	83 c4 04             	add    $0x4,%esp
80100617:	ff 75 08             	pushl  0x8(%ebp)
8010061a:	e8 ab 0f 00 00       	call   801015ca <ilock>

  return n;
}
8010061f:	89 f0                	mov    %esi,%eax
80100621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100624:	5b                   	pop    %ebx
80100625:	5e                   	pop    %esi
80100626:	5f                   	pop    %edi
80100627:	5d                   	pop    %ebp
80100628:	c3                   	ret    

80100629 <cprintf>:
{
80100629:	f3 0f 1e fb          	endbr32 
8010062d:	55                   	push   %ebp
8010062e:	89 e5                	mov    %esp,%ebp
80100630:	57                   	push   %edi
80100631:	56                   	push   %esi
80100632:	53                   	push   %ebx
80100633:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100636:	a1 54 95 10 80       	mov    0x80109554,%eax
8010063b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
8010063e:	85 c0                	test   %eax,%eax
80100640:	75 10                	jne    80100652 <cprintf+0x29>
  if (fmt == 0)
80100642:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100646:	74 1c                	je     80100664 <cprintf+0x3b>
  argp = (uint*)(void*)(&fmt + 1);
80100648:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064b:	be 00 00 00 00       	mov    $0x0,%esi
80100650:	eb 27                	jmp    80100679 <cprintf+0x50>
    acquire(&cons.lock);
80100652:	83 ec 0c             	sub    $0xc,%esp
80100655:	68 20 95 10 80       	push   $0x80109520
8010065a:	e8 5c 36 00 00       	call   80103cbb <acquire>
8010065f:	83 c4 10             	add    $0x10,%esp
80100662:	eb de                	jmp    80100642 <cprintf+0x19>
    panic("null fmt");
80100664:	83 ec 0c             	sub    $0xc,%esp
80100667:	68 3f 66 10 80       	push   $0x8010663f
8010066c:	e8 eb fc ff ff       	call   8010035c <panic>
      consputc(c);
80100671:	e8 82 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	83 c6 01             	add    $0x1,%esi
80100679:	8b 55 08             	mov    0x8(%ebp),%edx
8010067c:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100680:	85 c0                	test   %eax,%eax
80100682:	0f 84 b1 00 00 00    	je     80100739 <cprintf+0x110>
    if(c != '%'){
80100688:	83 f8 25             	cmp    $0x25,%eax
8010068b:	75 e4                	jne    80100671 <cprintf+0x48>
    c = fmt[++i] & 0xff;
8010068d:	83 c6 01             	add    $0x1,%esi
80100690:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100694:	85 db                	test   %ebx,%ebx
80100696:	0f 84 9d 00 00 00    	je     80100739 <cprintf+0x110>
    switch(c){
8010069c:	83 fb 70             	cmp    $0x70,%ebx
8010069f:	74 2e                	je     801006cf <cprintf+0xa6>
801006a1:	7f 22                	jg     801006c5 <cprintf+0x9c>
801006a3:	83 fb 25             	cmp    $0x25,%ebx
801006a6:	74 6c                	je     80100714 <cprintf+0xeb>
801006a8:	83 fb 64             	cmp    $0x64,%ebx
801006ab:	75 76                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 10, 1);
801006ad:	8d 5f 04             	lea    0x4(%edi),%ebx
801006b0:	8b 07                	mov    (%edi),%eax
801006b2:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b7:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bc:	e8 92 fe ff ff       	call   80100553 <printint>
801006c1:	89 df                	mov    %ebx,%edi
      break;
801006c3:	eb b1                	jmp    80100676 <cprintf+0x4d>
    switch(c){
801006c5:	83 fb 73             	cmp    $0x73,%ebx
801006c8:	74 1d                	je     801006e7 <cprintf+0xbe>
801006ca:	83 fb 78             	cmp    $0x78,%ebx
801006cd:	75 54                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 16, 0);
801006cf:	8d 5f 04             	lea    0x4(%edi),%ebx
801006d2:	8b 07                	mov    (%edi),%eax
801006d4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006d9:	ba 10 00 00 00       	mov    $0x10,%edx
801006de:	e8 70 fe ff ff       	call   80100553 <printint>
801006e3:	89 df                	mov    %ebx,%edi
      break;
801006e5:	eb 8f                	jmp    80100676 <cprintf+0x4d>
      if((s = (char*)*argp++) == 0)
801006e7:	8d 47 04             	lea    0x4(%edi),%eax
801006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006ed:	8b 1f                	mov    (%edi),%ebx
801006ef:	85 db                	test   %ebx,%ebx
801006f1:	75 05                	jne    801006f8 <cprintf+0xcf>
        s = "(null)";
801006f3:	bb 38 66 10 80       	mov    $0x80106638,%ebx
      for(; *s; s++)
801006f8:	0f b6 03             	movzbl (%ebx),%eax
801006fb:	84 c0                	test   %al,%al
801006fd:	74 0d                	je     8010070c <cprintf+0xe3>
        consputc(*s);
801006ff:	0f be c0             	movsbl %al,%eax
80100702:	e8 f1 fd ff ff       	call   801004f8 <consputc>
      for(; *s; s++)
80100707:	83 c3 01             	add    $0x1,%ebx
8010070a:	eb ec                	jmp    801006f8 <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010070f:	e9 62 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100714:	b8 25 00 00 00       	mov    $0x25,%eax
80100719:	e8 da fd ff ff       	call   801004f8 <consputc>
      break;
8010071e:	e9 53 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100723:	b8 25 00 00 00       	mov    $0x25,%eax
80100728:	e8 cb fd ff ff       	call   801004f8 <consputc>
      consputc(c);
8010072d:	89 d8                	mov    %ebx,%eax
8010072f:	e8 c4 fd ff ff       	call   801004f8 <consputc>
      break;
80100734:	e9 3d ff ff ff       	jmp    80100676 <cprintf+0x4d>
  if(locking)
80100739:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010073d:	75 08                	jne    80100747 <cprintf+0x11e>
}
8010073f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100742:	5b                   	pop    %ebx
80100743:	5e                   	pop    %esi
80100744:	5f                   	pop    %edi
80100745:	5d                   	pop    %ebp
80100746:	c3                   	ret    
    release(&cons.lock);
80100747:	83 ec 0c             	sub    $0xc,%esp
8010074a:	68 20 95 10 80       	push   $0x80109520
8010074f:	e8 d0 35 00 00       	call   80103d24 <release>
80100754:	83 c4 10             	add    $0x10,%esp
}
80100757:	eb e6                	jmp    8010073f <cprintf+0x116>

80100759 <consoleintr>:
{
80100759:	f3 0f 1e fb          	endbr32 
8010075d:	55                   	push   %ebp
8010075e:	89 e5                	mov    %esp,%ebp
80100760:	57                   	push   %edi
80100761:	56                   	push   %esi
80100762:	53                   	push   %ebx
80100763:	83 ec 18             	sub    $0x18,%esp
80100766:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100769:	68 20 95 10 80       	push   $0x80109520
8010076e:	e8 48 35 00 00       	call   80103cbb <acquire>
  while((c = getc()) >= 0){
80100773:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100776:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
8010077b:	eb 13                	jmp    80100790 <consoleintr+0x37>
    switch(c){
8010077d:	83 ff 08             	cmp    $0x8,%edi
80100780:	0f 84 d9 00 00 00    	je     8010085f <consoleintr+0x106>
80100786:	83 ff 10             	cmp    $0x10,%edi
80100789:	75 25                	jne    801007b0 <consoleintr+0x57>
8010078b:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100790:	ff d3                	call   *%ebx
80100792:	89 c7                	mov    %eax,%edi
80100794:	85 c0                	test   %eax,%eax
80100796:	0f 88 f5 00 00 00    	js     80100891 <consoleintr+0x138>
    switch(c){
8010079c:	83 ff 15             	cmp    $0x15,%edi
8010079f:	0f 84 93 00 00 00    	je     80100838 <consoleintr+0xdf>
801007a5:	7e d6                	jle    8010077d <consoleintr+0x24>
801007a7:	83 ff 7f             	cmp    $0x7f,%edi
801007aa:	0f 84 af 00 00 00    	je     8010085f <consoleintr+0x106>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007b0:	85 ff                	test   %edi,%edi
801007b2:	74 dc                	je     80100790 <consoleintr+0x37>
801007b4:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
801007b9:	89 c2                	mov    %eax,%edx
801007bb:	2b 15 a0 ef 10 80    	sub    0x8010efa0,%edx
801007c1:	83 fa 7f             	cmp    $0x7f,%edx
801007c4:	77 ca                	ja     80100790 <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
801007c6:	83 ff 0d             	cmp    $0xd,%edi
801007c9:	0f 84 b8 00 00 00    	je     80100887 <consoleintr+0x12e>
        input.buf[input.e++ % INPUT_BUF] = c;
801007cf:	8d 50 01             	lea    0x1(%eax),%edx
801007d2:	89 15 a8 ef 10 80    	mov    %edx,0x8010efa8
801007d8:	83 e0 7f             	and    $0x7f,%eax
801007db:	89 f9                	mov    %edi,%ecx
801007dd:	88 88 20 ef 10 80    	mov    %cl,-0x7fef10e0(%eax)
        consputc(c);
801007e3:	89 f8                	mov    %edi,%eax
801007e5:	e8 0e fd ff ff       	call   801004f8 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007ea:	83 ff 0a             	cmp    $0xa,%edi
801007ed:	0f 94 c2             	sete   %dl
801007f0:	83 ff 04             	cmp    $0x4,%edi
801007f3:	0f 94 c0             	sete   %al
801007f6:	08 c2                	or     %al,%dl
801007f8:	75 10                	jne    8010080a <consoleintr+0xb1>
801007fa:	a1 a0 ef 10 80       	mov    0x8010efa0,%eax
801007ff:	83 e8 80             	sub    $0xffffff80,%eax
80100802:	39 05 a8 ef 10 80    	cmp    %eax,0x8010efa8
80100808:	75 86                	jne    80100790 <consoleintr+0x37>
          input.w = input.e;
8010080a:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
8010080f:	a3 a4 ef 10 80       	mov    %eax,0x8010efa4
          wakeup(&input.r);
80100814:	83 ec 0c             	sub    $0xc,%esp
80100817:	68 a0 ef 10 80       	push   $0x8010efa0
8010081c:	e8 d4 30 00 00       	call   801038f5 <wakeup>
80100821:	83 c4 10             	add    $0x10,%esp
80100824:	e9 67 ff ff ff       	jmp    80100790 <consoleintr+0x37>
        input.e--;
80100829:	a3 a8 ef 10 80       	mov    %eax,0x8010efa8
        consputc(BACKSPACE);
8010082e:	b8 00 01 00 00       	mov    $0x100,%eax
80100833:	e8 c0 fc ff ff       	call   801004f8 <consputc>
      while(input.e != input.w &&
80100838:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
8010083d:	3b 05 a4 ef 10 80    	cmp    0x8010efa4,%eax
80100843:	0f 84 47 ff ff ff    	je     80100790 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100849:	83 e8 01             	sub    $0x1,%eax
8010084c:	89 c2                	mov    %eax,%edx
8010084e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100851:	80 ba 20 ef 10 80 0a 	cmpb   $0xa,-0x7fef10e0(%edx)
80100858:	75 cf                	jne    80100829 <consoleintr+0xd0>
8010085a:	e9 31 ff ff ff       	jmp    80100790 <consoleintr+0x37>
      if(input.e != input.w){
8010085f:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
80100864:	3b 05 a4 ef 10 80    	cmp    0x8010efa4,%eax
8010086a:	0f 84 20 ff ff ff    	je     80100790 <consoleintr+0x37>
        input.e--;
80100870:	83 e8 01             	sub    $0x1,%eax
80100873:	a3 a8 ef 10 80       	mov    %eax,0x8010efa8
        consputc(BACKSPACE);
80100878:	b8 00 01 00 00       	mov    $0x100,%eax
8010087d:	e8 76 fc ff ff       	call   801004f8 <consputc>
80100882:	e9 09 ff ff ff       	jmp    80100790 <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
80100887:	bf 0a 00 00 00       	mov    $0xa,%edi
8010088c:	e9 3e ff ff ff       	jmp    801007cf <consoleintr+0x76>
  release(&cons.lock);
80100891:	83 ec 0c             	sub    $0xc,%esp
80100894:	68 20 95 10 80       	push   $0x80109520
80100899:	e8 86 34 00 00       	call   80103d24 <release>
  if(doprocdump) {
8010089e:	83 c4 10             	add    $0x10,%esp
801008a1:	85 f6                	test   %esi,%esi
801008a3:	75 08                	jne    801008ad <consoleintr+0x154>
}
801008a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008a8:	5b                   	pop    %ebx
801008a9:	5e                   	pop    %esi
801008aa:	5f                   	pop    %edi
801008ab:	5d                   	pop    %ebp
801008ac:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
801008ad:	e8 e8 30 00 00       	call   8010399a <procdump>
}
801008b2:	eb f1                	jmp    801008a5 <consoleintr+0x14c>

801008b4 <consoleinit>:

void
consoleinit(void)
{
801008b4:	f3 0f 1e fb          	endbr32 
801008b8:	55                   	push   %ebp
801008b9:	89 e5                	mov    %esp,%ebp
801008bb:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008be:	68 48 66 10 80       	push   $0x80106648
801008c3:	68 20 95 10 80       	push   $0x80109520
801008c8:	e8 9e 32 00 00       	call   80103b6b <initlock>

  devsw[CONSOLE].write = consolewrite;
801008cd:	c7 05 6c f9 10 80 c6 	movl   $0x801005c6,0x8010f96c
801008d4:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008d7:	c7 05 68 f9 10 80 78 	movl   $0x80100278,0x8010f968
801008de:	02 10 80 
  cons.locking = 1;
801008e1:	c7 05 54 95 10 80 01 	movl   $0x1,0x80109554
801008e8:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008eb:	83 c4 08             	add    $0x8,%esp
801008ee:	6a 00                	push   $0x0
801008f0:	6a 01                	push   $0x1
801008f2:	e8 04 17 00 00       	call   80101ffb <ioapicenable>
}
801008f7:	83 c4 10             	add    $0x10,%esp
801008fa:	c9                   	leave  
801008fb:	c3                   	ret    

801008fc <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008fc:	f3 0f 1e fb          	endbr32 
80100900:	55                   	push   %ebp
80100901:	89 e5                	mov    %esp,%ebp
80100903:	57                   	push   %edi
80100904:	56                   	push   %esi
80100905:	53                   	push   %ebx
80100906:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010090c:	e8 b4 29 00 00       	call   801032c5 <myproc>
80100911:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100917:	e8 33 1f 00 00       	call   8010284f <begin_op>

  if((ip = namei(path)) == 0){
8010091c:	83 ec 0c             	sub    $0xc,%esp
8010091f:	ff 75 08             	pushl  0x8(%ebp)
80100922:	e8 28 13 00 00       	call   80101c4f <namei>
80100927:	83 c4 10             	add    $0x10,%esp
8010092a:	85 c0                	test   %eax,%eax
8010092c:	74 56                	je     80100984 <exec+0x88>
8010092e:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100930:	83 ec 0c             	sub    $0xc,%esp
80100933:	50                   	push   %eax
80100934:	e8 91 0c 00 00       	call   801015ca <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100939:	6a 34                	push   $0x34
8010093b:	6a 00                	push   $0x0
8010093d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100943:	50                   	push   %eax
80100944:	53                   	push   %ebx
80100945:	e8 86 0e 00 00       	call   801017d0 <readi>
8010094a:	83 c4 20             	add    $0x20,%esp
8010094d:	83 f8 34             	cmp    $0x34,%eax
80100950:	75 0c                	jne    8010095e <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100952:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100959:	45 4c 46 
8010095c:	74 42                	je     801009a0 <exec+0xa4>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
8010095e:	85 db                	test   %ebx,%ebx
80100960:	0f 84 c9 02 00 00    	je     80100c2f <exec+0x333>
    iunlockput(ip);
80100966:	83 ec 0c             	sub    $0xc,%esp
80100969:	53                   	push   %ebx
8010096a:	e8 0e 0e 00 00       	call   8010177d <iunlockput>
    end_op();
8010096f:	e8 59 1f 00 00       	call   801028cd <end_op>
80100974:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010097c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010097f:	5b                   	pop    %ebx
80100980:	5e                   	pop    %esi
80100981:	5f                   	pop    %edi
80100982:	5d                   	pop    %ebp
80100983:	c3                   	ret    
    end_op();
80100984:	e8 44 1f 00 00       	call   801028cd <end_op>
    cprintf("exec: fail\n");
80100989:	83 ec 0c             	sub    $0xc,%esp
8010098c:	68 61 66 10 80       	push   $0x80106661
80100991:	e8 93 fc ff ff       	call   80100629 <cprintf>
    return -1;
80100996:	83 c4 10             	add    $0x10,%esp
80100999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010099e:	eb dc                	jmp    8010097c <exec+0x80>
  if((pgdir = setupkvm()) == 0)
801009a0:	e8 c3 59 00 00       	call   80106368 <setupkvm>
801009a5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009ab:	85 c0                	test   %eax,%eax
801009ad:	0f 84 09 01 00 00    	je     80100abc <exec+0x1c0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009b3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
801009b9:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009be:	be 00 00 00 00       	mov    $0x0,%esi
801009c3:	eb 0c                	jmp    801009d1 <exec+0xd5>
801009c5:	83 c6 01             	add    $0x1,%esi
801009c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801009ce:	83 c0 20             	add    $0x20,%eax
801009d1:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
801009d8:	39 f2                	cmp    %esi,%edx
801009da:	0f 8e 98 00 00 00    	jle    80100a78 <exec+0x17c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009e0:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009e6:	6a 20                	push   $0x20
801009e8:	50                   	push   %eax
801009e9:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009ef:	50                   	push   %eax
801009f0:	53                   	push   %ebx
801009f1:	e8 da 0d 00 00       	call   801017d0 <readi>
801009f6:	83 c4 10             	add    $0x10,%esp
801009f9:	83 f8 20             	cmp    $0x20,%eax
801009fc:	0f 85 ba 00 00 00    	jne    80100abc <exec+0x1c0>
    if(ph.type != ELF_PROG_LOAD)
80100a02:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a09:	75 ba                	jne    801009c5 <exec+0xc9>
    if(ph.memsz < ph.filesz)
80100a0b:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a11:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a17:	0f 82 9f 00 00 00    	jb     80100abc <exec+0x1c0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a1d:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a23:	0f 82 93 00 00 00    	jb     80100abc <exec+0x1c0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a29:	83 ec 04             	sub    $0x4,%esp
80100a2c:	50                   	push   %eax
80100a2d:	57                   	push   %edi
80100a2e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a34:	e8 ce 57 00 00       	call   80106207 <allocuvm>
80100a39:	89 c7                	mov    %eax,%edi
80100a3b:	83 c4 10             	add    $0x10,%esp
80100a3e:	85 c0                	test   %eax,%eax
80100a40:	74 7a                	je     80100abc <exec+0x1c0>
    if(ph.vaddr % PGSIZE != 0)
80100a42:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a48:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a4d:	75 6d                	jne    80100abc <exec+0x1c0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a4f:	83 ec 0c             	sub    $0xc,%esp
80100a52:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a58:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a5e:	53                   	push   %ebx
80100a5f:	50                   	push   %eax
80100a60:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a66:	e8 67 56 00 00       	call   801060d2 <loaduvm>
80100a6b:	83 c4 20             	add    $0x20,%esp
80100a6e:	85 c0                	test   %eax,%eax
80100a70:	0f 89 4f ff ff ff    	jns    801009c5 <exec+0xc9>
80100a76:	eb 44                	jmp    80100abc <exec+0x1c0>
  iunlockput(ip);
80100a78:	83 ec 0c             	sub    $0xc,%esp
80100a7b:	53                   	push   %ebx
80100a7c:	e8 fc 0c 00 00       	call   8010177d <iunlockput>
  end_op();
80100a81:	e8 47 1e 00 00       	call   801028cd <end_op>
  sz = PGROUNDUP(sz);
80100a86:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100a8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a91:	83 c4 0c             	add    $0xc,%esp
80100a94:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a9a:	52                   	push   %edx
80100a9b:	50                   	push   %eax
80100a9c:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100aa2:	57                   	push   %edi
80100aa3:	e8 5f 57 00 00       	call   80106207 <allocuvm>
80100aa8:	89 c6                	mov    %eax,%esi
80100aaa:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ab0:	83 c4 10             	add    $0x10,%esp
80100ab3:	85 c0                	test   %eax,%eax
80100ab5:	75 24                	jne    80100adb <exec+0x1df>
  ip = 0;
80100ab7:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100abc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac2:	85 c0                	test   %eax,%eax
80100ac4:	0f 84 94 fe ff ff    	je     8010095e <exec+0x62>
    freevm(pgdir);
80100aca:	83 ec 0c             	sub    $0xc,%esp
80100acd:	50                   	push   %eax
80100ace:	e8 21 58 00 00       	call   801062f4 <freevm>
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	e9 83 fe ff ff       	jmp    8010095e <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100adb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ae1:	83 ec 08             	sub    $0x8,%esp
80100ae4:	50                   	push   %eax
80100ae5:	57                   	push   %edi
80100ae6:	e8 0a 59 00 00       	call   801063f5 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100aeb:	83 c4 10             	add    $0x10,%esp
80100aee:	bf 00 00 00 00       	mov    $0x0,%edi
80100af3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af6:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100af9:	8b 03                	mov    (%ebx),%eax
80100afb:	85 c0                	test   %eax,%eax
80100afd:	74 4d                	je     80100b4c <exec+0x250>
    if(argc >= MAXARG)
80100aff:	83 ff 1f             	cmp    $0x1f,%edi
80100b02:	0f 87 13 01 00 00    	ja     80100c1b <exec+0x31f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b08:	83 ec 0c             	sub    $0xc,%esp
80100b0b:	50                   	push   %eax
80100b0c:	e8 1f 34 00 00       	call   80103f30 <strlen>
80100b11:	29 c6                	sub    %eax,%esi
80100b13:	83 ee 01             	sub    $0x1,%esi
80100b16:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b19:	83 c4 04             	add    $0x4,%esp
80100b1c:	ff 33                	pushl  (%ebx)
80100b1e:	e8 0d 34 00 00       	call   80103f30 <strlen>
80100b23:	83 c0 01             	add    $0x1,%eax
80100b26:	50                   	push   %eax
80100b27:	ff 33                	pushl  (%ebx)
80100b29:	56                   	push   %esi
80100b2a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b30:	e8 1a 5a 00 00       	call   8010654f <copyout>
80100b35:	83 c4 20             	add    $0x20,%esp
80100b38:	85 c0                	test   %eax,%eax
80100b3a:	0f 88 e5 00 00 00    	js     80100c25 <exec+0x329>
    ustack[3+argc] = sp;
80100b40:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b47:	83 c7 01             	add    $0x1,%edi
80100b4a:	eb a7                	jmp    80100af3 <exec+0x1f7>
80100b4c:	89 f1                	mov    %esi,%ecx
80100b4e:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100b50:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100b57:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b5b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b62:	ff ff ff 
  ustack[1] = argc;
80100b65:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b6b:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100b72:	89 f2                	mov    %esi,%edx
80100b74:	29 c2                	sub    %eax,%edx
80100b76:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b7c:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b83:	29 c1                	sub    %eax,%ecx
80100b85:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b87:	50                   	push   %eax
80100b88:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b8e:	50                   	push   %eax
80100b8f:	51                   	push   %ecx
80100b90:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b96:	e8 b4 59 00 00       	call   8010654f <copyout>
80100b9b:	83 c4 10             	add    $0x10,%esp
80100b9e:	85 c0                	test   %eax,%eax
80100ba0:	0f 88 16 ff ff ff    	js     80100abc <exec+0x1c0>
  for(last=s=path; *s; s++)
80100ba6:	8b 55 08             	mov    0x8(%ebp),%edx
80100ba9:	89 d0                	mov    %edx,%eax
80100bab:	eb 03                	jmp    80100bb0 <exec+0x2b4>
80100bad:	83 c0 01             	add    $0x1,%eax
80100bb0:	0f b6 08             	movzbl (%eax),%ecx
80100bb3:	84 c9                	test   %cl,%cl
80100bb5:	74 0a                	je     80100bc1 <exec+0x2c5>
    if(*s == '/')
80100bb7:	80 f9 2f             	cmp    $0x2f,%cl
80100bba:	75 f1                	jne    80100bad <exec+0x2b1>
      last = s+1;
80100bbc:	8d 50 01             	lea    0x1(%eax),%edx
80100bbf:	eb ec                	jmp    80100bad <exec+0x2b1>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bc1:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100bc7:	89 f8                	mov    %edi,%eax
80100bc9:	83 c0 6c             	add    $0x6c,%eax
80100bcc:	83 ec 04             	sub    $0x4,%esp
80100bcf:	6a 10                	push   $0x10
80100bd1:	52                   	push   %edx
80100bd2:	50                   	push   %eax
80100bd3:	e8 17 33 00 00       	call   80103eef <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bd8:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100bdb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100be1:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100be4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bea:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bec:	8b 47 18             	mov    0x18(%edi),%eax
80100bef:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bf5:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bf8:	8b 47 18             	mov    0x18(%edi),%eax
80100bfb:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bfe:	89 3c 24             	mov    %edi,(%esp)
80100c01:	e8 43 53 00 00       	call   80105f49 <switchuvm>
  freevm(oldpgdir);
80100c06:	89 1c 24             	mov    %ebx,(%esp)
80100c09:	e8 e6 56 00 00       	call   801062f4 <freevm>
  return 0;
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	b8 00 00 00 00       	mov    $0x0,%eax
80100c16:	e9 61 fd ff ff       	jmp    8010097c <exec+0x80>
  ip = 0;
80100c1b:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c20:	e9 97 fe ff ff       	jmp    80100abc <exec+0x1c0>
80100c25:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c2a:	e9 8d fe ff ff       	jmp    80100abc <exec+0x1c0>
  return -1;
80100c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c34:	e9 43 fd ff ff       	jmp    8010097c <exec+0x80>

80100c39 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c39:	f3 0f 1e fb          	endbr32 
80100c3d:	55                   	push   %ebp
80100c3e:	89 e5                	mov    %esp,%ebp
80100c40:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c43:	68 6d 66 10 80       	push   $0x8010666d
80100c48:	68 c0 ef 10 80       	push   $0x8010efc0
80100c4d:	e8 19 2f 00 00       	call   80103b6b <initlock>
}
80100c52:	83 c4 10             	add    $0x10,%esp
80100c55:	c9                   	leave  
80100c56:	c3                   	ret    

80100c57 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c57:	f3 0f 1e fb          	endbr32 
80100c5b:	55                   	push   %ebp
80100c5c:	89 e5                	mov    %esp,%ebp
80100c5e:	53                   	push   %ebx
80100c5f:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c62:	68 c0 ef 10 80       	push   $0x8010efc0
80100c67:	e8 4f 30 00 00       	call   80103cbb <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c6c:	83 c4 10             	add    $0x10,%esp
80100c6f:	bb f4 ef 10 80       	mov    $0x8010eff4,%ebx
80100c74:	eb 03                	jmp    80100c79 <filealloc+0x22>
80100c76:	83 c3 18             	add    $0x18,%ebx
80100c79:	81 fb 54 f9 10 80    	cmp    $0x8010f954,%ebx
80100c7f:	73 24                	jae    80100ca5 <filealloc+0x4e>
    if(f->ref == 0){
80100c81:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c85:	75 ef                	jne    80100c76 <filealloc+0x1f>
      f->ref = 1;
80100c87:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c8e:	83 ec 0c             	sub    $0xc,%esp
80100c91:	68 c0 ef 10 80       	push   $0x8010efc0
80100c96:	e8 89 30 00 00       	call   80103d24 <release>
      return f;
80100c9b:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c9e:	89 d8                	mov    %ebx,%eax
80100ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ca3:	c9                   	leave  
80100ca4:	c3                   	ret    
  release(&ftable.lock);
80100ca5:	83 ec 0c             	sub    $0xc,%esp
80100ca8:	68 c0 ef 10 80       	push   $0x8010efc0
80100cad:	e8 72 30 00 00       	call   80103d24 <release>
  return 0;
80100cb2:	83 c4 10             	add    $0x10,%esp
80100cb5:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cba:	eb e2                	jmp    80100c9e <filealloc+0x47>

80100cbc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cbc:	f3 0f 1e fb          	endbr32 
80100cc0:	55                   	push   %ebp
80100cc1:	89 e5                	mov    %esp,%ebp
80100cc3:	53                   	push   %ebx
80100cc4:	83 ec 10             	sub    $0x10,%esp
80100cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100cca:	68 c0 ef 10 80       	push   $0x8010efc0
80100ccf:	e8 e7 2f 00 00       	call   80103cbb <acquire>
  if(f->ref < 1)
80100cd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	85 c0                	test   %eax,%eax
80100cdc:	7e 1a                	jle    80100cf8 <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100cde:	83 c0 01             	add    $0x1,%eax
80100ce1:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ce4:	83 ec 0c             	sub    $0xc,%esp
80100ce7:	68 c0 ef 10 80       	push   $0x8010efc0
80100cec:	e8 33 30 00 00       	call   80103d24 <release>
  return f;
}
80100cf1:	89 d8                	mov    %ebx,%eax
80100cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf6:	c9                   	leave  
80100cf7:	c3                   	ret    
    panic("filedup");
80100cf8:	83 ec 0c             	sub    $0xc,%esp
80100cfb:	68 74 66 10 80       	push   $0x80106674
80100d00:	e8 57 f6 ff ff       	call   8010035c <panic>

80100d05 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d05:	f3 0f 1e fb          	endbr32 
80100d09:	55                   	push   %ebp
80100d0a:	89 e5                	mov    %esp,%ebp
80100d0c:	53                   	push   %ebx
80100d0d:	83 ec 30             	sub    $0x30,%esp
80100d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d13:	68 c0 ef 10 80       	push   $0x8010efc0
80100d18:	e8 9e 2f 00 00       	call   80103cbb <acquire>
  if(f->ref < 1)
80100d1d:	8b 43 04             	mov    0x4(%ebx),%eax
80100d20:	83 c4 10             	add    $0x10,%esp
80100d23:	85 c0                	test   %eax,%eax
80100d25:	7e 65                	jle    80100d8c <fileclose+0x87>
    panic("fileclose");
  if(--f->ref > 0){
80100d27:	83 e8 01             	sub    $0x1,%eax
80100d2a:	89 43 04             	mov    %eax,0x4(%ebx)
80100d2d:	85 c0                	test   %eax,%eax
80100d2f:	7f 68                	jg     80100d99 <fileclose+0x94>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100d31:	8b 03                	mov    (%ebx),%eax
80100d33:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d36:	8b 43 08             	mov    0x8(%ebx),%eax
80100d39:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d3c:	8b 43 0c             	mov    0xc(%ebx),%eax
80100d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d42:	8b 43 10             	mov    0x10(%ebx),%eax
80100d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f->ref = 0;
80100d48:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d55:	83 ec 0c             	sub    $0xc,%esp
80100d58:	68 c0 ef 10 80       	push   $0x8010efc0
80100d5d:	e8 c2 2f 00 00       	call   80103d24 <release>

  if(ff.type == FD_PIPE)
80100d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	83 f8 01             	cmp    $0x1,%eax
80100d6b:	74 41                	je     80100dae <fileclose+0xa9>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d6d:	83 f8 02             	cmp    $0x2,%eax
80100d70:	75 37                	jne    80100da9 <fileclose+0xa4>
    begin_op();
80100d72:	e8 d8 1a 00 00       	call   8010284f <begin_op>
    iput(ff.ip);
80100d77:	83 ec 0c             	sub    $0xc,%esp
80100d7a:	ff 75 f0             	pushl  -0x10(%ebp)
80100d7d:	e8 57 09 00 00       	call   801016d9 <iput>
    end_op();
80100d82:	e8 46 1b 00 00       	call   801028cd <end_op>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	eb 1d                	jmp    80100da9 <fileclose+0xa4>
    panic("fileclose");
80100d8c:	83 ec 0c             	sub    $0xc,%esp
80100d8f:	68 7c 66 10 80       	push   $0x8010667c
80100d94:	e8 c3 f5 ff ff       	call   8010035c <panic>
    release(&ftable.lock);
80100d99:	83 ec 0c             	sub    $0xc,%esp
80100d9c:	68 c0 ef 10 80       	push   $0x8010efc0
80100da1:	e8 7e 2f 00 00       	call   80103d24 <release>
    return;
80100da6:	83 c4 10             	add    $0x10,%esp
  }
}
80100da9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dac:	c9                   	leave  
80100dad:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100dae:	83 ec 08             	sub    $0x8,%esp
80100db1:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100db5:	50                   	push   %eax
80100db6:	ff 75 ec             	pushl  -0x14(%ebp)
80100db9:	e8 24 21 00 00       	call   80102ee2 <pipeclose>
80100dbe:	83 c4 10             	add    $0x10,%esp
80100dc1:	eb e6                	jmp    80100da9 <fileclose+0xa4>

80100dc3 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100dc3:	f3 0f 1e fb          	endbr32 
80100dc7:	55                   	push   %ebp
80100dc8:	89 e5                	mov    %esp,%ebp
80100dca:	53                   	push   %ebx
80100dcb:	83 ec 04             	sub    $0x4,%esp
80100dce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100dd1:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dd4:	75 31                	jne    80100e07 <filestat+0x44>
    ilock(f->ip);
80100dd6:	83 ec 0c             	sub    $0xc,%esp
80100dd9:	ff 73 10             	pushl  0x10(%ebx)
80100ddc:	e8 e9 07 00 00       	call   801015ca <ilock>
    stati(f->ip, st);
80100de1:	83 c4 08             	add    $0x8,%esp
80100de4:	ff 75 0c             	pushl  0xc(%ebp)
80100de7:	ff 73 10             	pushl  0x10(%ebx)
80100dea:	e8 b2 09 00 00       	call   801017a1 <stati>
    iunlock(f->ip);
80100def:	83 c4 04             	add    $0x4,%esp
80100df2:	ff 73 10             	pushl  0x10(%ebx)
80100df5:	e8 96 08 00 00       	call   80101690 <iunlock>
    return 0;
80100dfa:	83 c4 10             	add    $0x10,%esp
80100dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e05:	c9                   	leave  
80100e06:	c3                   	ret    
  return -1;
80100e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0c:	eb f4                	jmp    80100e02 <filestat+0x3f>

80100e0e <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e0e:	f3 0f 1e fb          	endbr32 
80100e12:	55                   	push   %ebp
80100e13:	89 e5                	mov    %esp,%ebp
80100e15:	56                   	push   %esi
80100e16:	53                   	push   %ebx
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e1a:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e1e:	74 70                	je     80100e90 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100e20:	8b 03                	mov    (%ebx),%eax
80100e22:	83 f8 01             	cmp    $0x1,%eax
80100e25:	74 44                	je     80100e6b <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e27:	83 f8 02             	cmp    $0x2,%eax
80100e2a:	75 57                	jne    80100e83 <fileread+0x75>
    ilock(f->ip);
80100e2c:	83 ec 0c             	sub    $0xc,%esp
80100e2f:	ff 73 10             	pushl  0x10(%ebx)
80100e32:	e8 93 07 00 00       	call   801015ca <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e37:	ff 75 10             	pushl  0x10(%ebp)
80100e3a:	ff 73 14             	pushl  0x14(%ebx)
80100e3d:	ff 75 0c             	pushl  0xc(%ebp)
80100e40:	ff 73 10             	pushl  0x10(%ebx)
80100e43:	e8 88 09 00 00       	call   801017d0 <readi>
80100e48:	89 c6                	mov    %eax,%esi
80100e4a:	83 c4 20             	add    $0x20,%esp
80100e4d:	85 c0                	test   %eax,%eax
80100e4f:	7e 03                	jle    80100e54 <fileread+0x46>
      f->off += r;
80100e51:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e54:	83 ec 0c             	sub    $0xc,%esp
80100e57:	ff 73 10             	pushl  0x10(%ebx)
80100e5a:	e8 31 08 00 00       	call   80101690 <iunlock>
    return r;
80100e5f:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e62:	89 f0                	mov    %esi,%eax
80100e64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5d                   	pop    %ebp
80100e6a:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e6b:	83 ec 04             	sub    $0x4,%esp
80100e6e:	ff 75 10             	pushl  0x10(%ebp)
80100e71:	ff 75 0c             	pushl  0xc(%ebp)
80100e74:	ff 73 0c             	pushl  0xc(%ebx)
80100e77:	e8 c0 21 00 00       	call   8010303c <piperead>
80100e7c:	89 c6                	mov    %eax,%esi
80100e7e:	83 c4 10             	add    $0x10,%esp
80100e81:	eb df                	jmp    80100e62 <fileread+0x54>
  panic("fileread");
80100e83:	83 ec 0c             	sub    $0xc,%esp
80100e86:	68 86 66 10 80       	push   $0x80106686
80100e8b:	e8 cc f4 ff ff       	call   8010035c <panic>
    return -1;
80100e90:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e95:	eb cb                	jmp    80100e62 <fileread+0x54>

80100e97 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e97:	f3 0f 1e fb          	endbr32 
80100e9b:	55                   	push   %ebp
80100e9c:	89 e5                	mov    %esp,%ebp
80100e9e:	57                   	push   %edi
80100e9f:	56                   	push   %esi
80100ea0:	53                   	push   %ebx
80100ea1:	83 ec 1c             	sub    $0x1c,%esp
80100ea4:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100ea7:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100eab:	0f 84 cc 00 00 00    	je     80100f7d <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100eb1:	8b 06                	mov    (%esi),%eax
80100eb3:	83 f8 01             	cmp    $0x1,%eax
80100eb6:	74 10                	je     80100ec8 <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eb8:	83 f8 02             	cmp    $0x2,%eax
80100ebb:	0f 85 af 00 00 00    	jne    80100f70 <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100ec1:	bf 00 00 00 00       	mov    $0x0,%edi
80100ec6:	eb 67                	jmp    80100f2f <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100ec8:	83 ec 04             	sub    $0x4,%esp
80100ecb:	ff 75 10             	pushl  0x10(%ebp)
80100ece:	ff 75 0c             	pushl  0xc(%ebp)
80100ed1:	ff 76 0c             	pushl  0xc(%esi)
80100ed4:	e8 99 20 00 00       	call   80102f72 <pipewrite>
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	e9 82 00 00 00       	jmp    80100f63 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100ee1:	e8 69 19 00 00       	call   8010284f <begin_op>
      ilock(f->ip);
80100ee6:	83 ec 0c             	sub    $0xc,%esp
80100ee9:	ff 76 10             	pushl  0x10(%esi)
80100eec:	e8 d9 06 00 00       	call   801015ca <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ef1:	ff 75 e4             	pushl  -0x1c(%ebp)
80100ef4:	ff 76 14             	pushl  0x14(%esi)
80100ef7:	89 f8                	mov    %edi,%eax
80100ef9:	03 45 0c             	add    0xc(%ebp),%eax
80100efc:	50                   	push   %eax
80100efd:	ff 76 10             	pushl  0x10(%esi)
80100f00:	e8 cc 09 00 00       	call   801018d1 <writei>
80100f05:	89 c3                	mov    %eax,%ebx
80100f07:	83 c4 20             	add    $0x20,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 03                	jle    80100f11 <filewrite+0x7a>
        f->off += r;
80100f0e:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100f11:	83 ec 0c             	sub    $0xc,%esp
80100f14:	ff 76 10             	pushl  0x10(%esi)
80100f17:	e8 74 07 00 00       	call   80101690 <iunlock>
      end_op();
80100f1c:	e8 ac 19 00 00       	call   801028cd <end_op>

      if(r < 0)
80100f21:	83 c4 10             	add    $0x10,%esp
80100f24:	85 db                	test   %ebx,%ebx
80100f26:	78 31                	js     80100f59 <filewrite+0xc2>
        break;
      if(r != n1)
80100f28:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100f2b:	75 1f                	jne    80100f4c <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100f2d:	01 df                	add    %ebx,%edi
    while(i < n){
80100f2f:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f32:	7d 25                	jge    80100f59 <filewrite+0xc2>
      int n1 = n - i;
80100f34:	8b 45 10             	mov    0x10(%ebp),%eax
80100f37:	29 f8                	sub    %edi,%eax
80100f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100f3c:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f41:	7e 9e                	jle    80100ee1 <filewrite+0x4a>
        n1 = max;
80100f43:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f4a:	eb 95                	jmp    80100ee1 <filewrite+0x4a>
        panic("short filewrite");
80100f4c:	83 ec 0c             	sub    $0xc,%esp
80100f4f:	68 8f 66 10 80       	push   $0x8010668f
80100f54:	e8 03 f4 ff ff       	call   8010035c <panic>
    }
    return i == n ? n : -1;
80100f59:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f5c:	74 0d                	je     80100f6b <filewrite+0xd4>
80100f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f66:	5b                   	pop    %ebx
80100f67:	5e                   	pop    %esi
80100f68:	5f                   	pop    %edi
80100f69:	5d                   	pop    %ebp
80100f6a:	c3                   	ret    
    return i == n ? n : -1;
80100f6b:	8b 45 10             	mov    0x10(%ebp),%eax
80100f6e:	eb f3                	jmp    80100f63 <filewrite+0xcc>
  panic("filewrite");
80100f70:	83 ec 0c             	sub    $0xc,%esp
80100f73:	68 95 66 10 80       	push   $0x80106695
80100f78:	e8 df f3 ff ff       	call   8010035c <panic>
    return -1;
80100f7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f82:	eb df                	jmp    80100f63 <filewrite+0xcc>

80100f84 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f84:	55                   	push   %ebp
80100f85:	89 e5                	mov    %esp,%ebp
80100f87:	57                   	push   %edi
80100f88:	56                   	push   %esi
80100f89:	53                   	push   %ebx
80100f8a:	83 ec 0c             	sub    $0xc,%esp
80100f8d:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f8f:	0f b6 10             	movzbl (%eax),%edx
80100f92:	80 fa 2f             	cmp    $0x2f,%dl
80100f95:	75 05                	jne    80100f9c <skipelem+0x18>
    path++;
80100f97:	83 c0 01             	add    $0x1,%eax
80100f9a:	eb f3                	jmp    80100f8f <skipelem+0xb>
  if(*path == 0)
80100f9c:	84 d2                	test   %dl,%dl
80100f9e:	74 59                	je     80100ff9 <skipelem+0x75>
80100fa0:	89 c3                	mov    %eax,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80100fa2:	0f b6 13             	movzbl (%ebx),%edx
80100fa5:	80 fa 2f             	cmp    $0x2f,%dl
80100fa8:	0f 95 c1             	setne  %cl
80100fab:	84 d2                	test   %dl,%dl
80100fad:	0f 95 c2             	setne  %dl
80100fb0:	84 d1                	test   %dl,%cl
80100fb2:	74 05                	je     80100fb9 <skipelem+0x35>
    path++;
80100fb4:	83 c3 01             	add    $0x1,%ebx
80100fb7:	eb e9                	jmp    80100fa2 <skipelem+0x1e>
  len = path - s;
80100fb9:	89 df                	mov    %ebx,%edi
80100fbb:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100fbd:	83 ff 0d             	cmp    $0xd,%edi
80100fc0:	7e 11                	jle    80100fd3 <skipelem+0x4f>
    memmove(name, s, DIRSIZ);
80100fc2:	83 ec 04             	sub    $0x4,%esp
80100fc5:	6a 0e                	push   $0xe
80100fc7:	50                   	push   %eax
80100fc8:	56                   	push   %esi
80100fc9:	e8 21 2e 00 00       	call   80103def <memmove>
80100fce:	83 c4 10             	add    $0x10,%esp
80100fd1:	eb 17                	jmp    80100fea <skipelem+0x66>
  else {
    memmove(name, s, len);
80100fd3:	83 ec 04             	sub    $0x4,%esp
80100fd6:	57                   	push   %edi
80100fd7:	50                   	push   %eax
80100fd8:	56                   	push   %esi
80100fd9:	e8 11 2e 00 00       	call   80103def <memmove>
    name[len] = 0;
80100fde:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100fe2:	83 c4 10             	add    $0x10,%esp
80100fe5:	eb 03                	jmp    80100fea <skipelem+0x66>
  }
  while(*path == '/')
    path++;
80100fe7:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80100fea:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fed:	74 f8                	je     80100fe7 <skipelem+0x63>
  return path;
}
80100fef:	89 d8                	mov    %ebx,%eax
80100ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff4:	5b                   	pop    %ebx
80100ff5:	5e                   	pop    %esi
80100ff6:	5f                   	pop    %edi
80100ff7:	5d                   	pop    %ebp
80100ff8:	c3                   	ret    
    return 0;
80100ff9:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ffe:	eb ef                	jmp    80100fef <skipelem+0x6b>

80101000 <bzero>:
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	53                   	push   %ebx
80101004:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80101007:	52                   	push   %edx
80101008:	50                   	push   %eax
80101009:	e8 62 f1 ff ff       	call   80100170 <bread>
8010100e:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101010:	8d 40 5c             	lea    0x5c(%eax),%eax
80101013:	83 c4 0c             	add    $0xc,%esp
80101016:	68 00 02 00 00       	push   $0x200
8010101b:	6a 00                	push   $0x0
8010101d:	50                   	push   %eax
8010101e:	e8 4c 2d 00 00       	call   80103d6f <memset>
  log_write(bp);
80101023:	89 1c 24             	mov    %ebx,(%esp)
80101026:	e8 55 19 00 00       	call   80102980 <log_write>
  brelse(bp);
8010102b:	89 1c 24             	mov    %ebx,(%esp)
8010102e:	e8 ae f1 ff ff       	call   801001e1 <brelse>
}
80101033:	83 c4 10             	add    $0x10,%esp
80101036:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101039:	c9                   	leave  
8010103a:	c3                   	ret    

8010103b <bfree>:
{
8010103b:	55                   	push   %ebp
8010103c:	89 e5                	mov    %esp,%ebp
8010103e:	57                   	push   %edi
8010103f:	56                   	push   %esi
80101040:	53                   	push   %ebx
80101041:	83 ec 14             	sub    $0x14,%esp
80101044:	89 c3                	mov    %eax,%ebx
80101046:	89 d6                	mov    %edx,%esi
  bp = bread(dev, BBLOCK(b, sb));
80101048:	89 d0                	mov    %edx,%eax
8010104a:	c1 e8 0c             	shr    $0xc,%eax
8010104d:	03 05 d8 f9 10 80    	add    0x8010f9d8,%eax
80101053:	50                   	push   %eax
80101054:	53                   	push   %ebx
80101055:	e8 16 f1 ff ff       	call   80100170 <bread>
8010105a:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
8010105c:	89 f7                	mov    %esi,%edi
8010105e:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
80101064:	89 f1                	mov    %esi,%ecx
80101066:	83 e1 07             	and    $0x7,%ecx
80101069:	b8 01 00 00 00       	mov    $0x1,%eax
8010106e:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101070:	83 c4 10             	add    $0x10,%esp
80101073:	c1 ff 03             	sar    $0x3,%edi
80101076:	0f b6 54 3b 5c       	movzbl 0x5c(%ebx,%edi,1),%edx
8010107b:	0f b6 ca             	movzbl %dl,%ecx
8010107e:	85 c1                	test   %eax,%ecx
80101080:	74 24                	je     801010a6 <bfree+0x6b>
  bp->data[bi/8] &= ~m;
80101082:	f7 d0                	not    %eax
80101084:	21 d0                	and    %edx,%eax
80101086:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	53                   	push   %ebx
8010108e:	e8 ed 18 00 00       	call   80102980 <log_write>
  brelse(bp);
80101093:	89 1c 24             	mov    %ebx,(%esp)
80101096:	e8 46 f1 ff ff       	call   801001e1 <brelse>
}
8010109b:	83 c4 10             	add    $0x10,%esp
8010109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a1:	5b                   	pop    %ebx
801010a2:	5e                   	pop    %esi
801010a3:	5f                   	pop    %edi
801010a4:	5d                   	pop    %ebp
801010a5:	c3                   	ret    
    panic("freeing free block");
801010a6:	83 ec 0c             	sub    $0xc,%esp
801010a9:	68 9f 66 10 80       	push   $0x8010669f
801010ae:	e8 a9 f2 ff ff       	call   8010035c <panic>

801010b3 <balloc>:
{
801010b3:	55                   	push   %ebp
801010b4:	89 e5                	mov    %esp,%ebp
801010b6:	57                   	push   %edi
801010b7:	56                   	push   %esi
801010b8:	53                   	push   %ebx
801010b9:	83 ec 1c             	sub    $0x1c,%esp
801010bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010bf:	be 00 00 00 00       	mov    $0x0,%esi
801010c4:	eb 14                	jmp    801010da <balloc+0x27>
    brelse(bp);
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	ff 75 e4             	pushl  -0x1c(%ebp)
801010cc:	e8 10 f1 ff ff       	call   801001e1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010d1:	81 c6 00 10 00 00    	add    $0x1000,%esi
801010d7:	83 c4 10             	add    $0x10,%esp
801010da:	39 35 c0 f9 10 80    	cmp    %esi,0x8010f9c0
801010e0:	76 75                	jbe    80101157 <balloc+0xa4>
    bp = bread(dev, BBLOCK(b, sb));
801010e2:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
801010e8:	85 f6                	test   %esi,%esi
801010ea:	0f 49 c6             	cmovns %esi,%eax
801010ed:	c1 f8 0c             	sar    $0xc,%eax
801010f0:	83 ec 08             	sub    $0x8,%esp
801010f3:	03 05 d8 f9 10 80    	add    0x8010f9d8,%eax
801010f9:	50                   	push   %eax
801010fa:	ff 75 d8             	pushl  -0x28(%ebp)
801010fd:	e8 6e f0 ff ff       	call   80100170 <bread>
80101102:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101105:	83 c4 10             	add    $0x10,%esp
80101108:	b8 00 00 00 00       	mov    $0x0,%eax
8010110d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80101112:	7f b2                	jg     801010c6 <balloc+0x13>
80101114:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80101117:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010111a:	3b 1d c0 f9 10 80    	cmp    0x8010f9c0,%ebx
80101120:	73 a4                	jae    801010c6 <balloc+0x13>
      m = 1 << (bi % 8);
80101122:	99                   	cltd   
80101123:	c1 ea 1d             	shr    $0x1d,%edx
80101126:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80101129:	83 e1 07             	and    $0x7,%ecx
8010112c:	29 d1                	sub    %edx,%ecx
8010112e:	ba 01 00 00 00       	mov    $0x1,%edx
80101133:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101135:	8d 48 07             	lea    0x7(%eax),%ecx
80101138:	85 c0                	test   %eax,%eax
8010113a:	0f 49 c8             	cmovns %eax,%ecx
8010113d:	c1 f9 03             	sar    $0x3,%ecx
80101140:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101143:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101146:	0f b6 4c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%ecx
8010114b:	0f b6 f9             	movzbl %cl,%edi
8010114e:	85 d7                	test   %edx,%edi
80101150:	74 12                	je     80101164 <balloc+0xb1>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101152:	83 c0 01             	add    $0x1,%eax
80101155:	eb b6                	jmp    8010110d <balloc+0x5a>
  panic("balloc: out of blocks");
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	68 b2 66 10 80       	push   $0x801066b2
8010115f:	e8 f8 f1 ff ff       	call   8010035c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
80101164:	09 ca                	or     %ecx,%edx
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	8b 75 dc             	mov    -0x24(%ebp),%esi
8010116c:	88 54 30 5c          	mov    %dl,0x5c(%eax,%esi,1)
        log_write(bp);
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	89 c6                	mov    %eax,%esi
80101175:	50                   	push   %eax
80101176:	e8 05 18 00 00       	call   80102980 <log_write>
        brelse(bp);
8010117b:	89 34 24             	mov    %esi,(%esp)
8010117e:	e8 5e f0 ff ff       	call   801001e1 <brelse>
        bzero(dev, b + bi);
80101183:	89 da                	mov    %ebx,%edx
80101185:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101188:	e8 73 fe ff ff       	call   80101000 <bzero>
}
8010118d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101193:	5b                   	pop    %ebx
80101194:	5e                   	pop    %esi
80101195:	5f                   	pop    %edi
80101196:	5d                   	pop    %ebp
80101197:	c3                   	ret    

80101198 <bmap>:
{
80101198:	55                   	push   %ebp
80101199:	89 e5                	mov    %esp,%ebp
8010119b:	57                   	push   %edi
8010119c:	56                   	push   %esi
8010119d:	53                   	push   %ebx
8010119e:	83 ec 1c             	sub    $0x1c,%esp
801011a1:	89 c3                	mov    %eax,%ebx
801011a3:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801011a5:	83 fa 0b             	cmp    $0xb,%edx
801011a8:	76 45                	jbe    801011ef <bmap+0x57>
  bn -= NDIRECT;
801011aa:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801011ad:	83 fe 7f             	cmp    $0x7f,%esi
801011b0:	77 7f                	ja     80101231 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
801011b2:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011b8:	85 c0                	test   %eax,%eax
801011ba:	74 4a                	je     80101206 <bmap+0x6e>
    bp = bread(ip->dev, addr);
801011bc:	83 ec 08             	sub    $0x8,%esp
801011bf:	50                   	push   %eax
801011c0:	ff 33                	pushl  (%ebx)
801011c2:	e8 a9 ef ff ff       	call   80100170 <bread>
801011c7:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801011c9:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
801011cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011d0:	8b 30                	mov    (%eax),%esi
801011d2:	83 c4 10             	add    $0x10,%esp
801011d5:	85 f6                	test   %esi,%esi
801011d7:	74 3c                	je     80101215 <bmap+0x7d>
    brelse(bp);
801011d9:	83 ec 0c             	sub    $0xc,%esp
801011dc:	57                   	push   %edi
801011dd:	e8 ff ef ff ff       	call   801001e1 <brelse>
    return addr;
801011e2:	83 c4 10             	add    $0x10,%esp
}
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ea:	5b                   	pop    %ebx
801011eb:	5e                   	pop    %esi
801011ec:	5f                   	pop    %edi
801011ed:	5d                   	pop    %ebp
801011ee:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801011ef:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801011f3:	85 f6                	test   %esi,%esi
801011f5:	75 ee                	jne    801011e5 <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801011f7:	8b 00                	mov    (%eax),%eax
801011f9:	e8 b5 fe ff ff       	call   801010b3 <balloc>
801011fe:	89 c6                	mov    %eax,%esi
80101200:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
80101204:	eb df                	jmp    801011e5 <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101206:	8b 03                	mov    (%ebx),%eax
80101208:	e8 a6 fe ff ff       	call   801010b3 <balloc>
8010120d:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101213:	eb a7                	jmp    801011bc <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
80101215:	8b 03                	mov    (%ebx),%eax
80101217:	e8 97 fe ff ff       	call   801010b3 <balloc>
8010121c:	89 c6                	mov    %eax,%esi
8010121e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101221:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101223:	83 ec 0c             	sub    $0xc,%esp
80101226:	57                   	push   %edi
80101227:	e8 54 17 00 00       	call   80102980 <log_write>
8010122c:	83 c4 10             	add    $0x10,%esp
8010122f:	eb a8                	jmp    801011d9 <bmap+0x41>
  panic("bmap: out of range");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 c8 66 10 80       	push   $0x801066c8
80101239:	e8 1e f1 ff ff       	call   8010035c <panic>

8010123e <iget>:
{
8010123e:	55                   	push   %ebp
8010123f:	89 e5                	mov    %esp,%ebp
80101241:	57                   	push   %edi
80101242:	56                   	push   %esi
80101243:	53                   	push   %ebx
80101244:	83 ec 28             	sub    $0x28,%esp
80101247:	89 c7                	mov    %eax,%edi
80101249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010124c:	68 e0 f9 10 80       	push   $0x8010f9e0
80101251:	e8 65 2a 00 00       	call   80103cbb <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101256:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101259:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125e:	bb 14 fa 10 80       	mov    $0x8010fa14,%ebx
80101263:	eb 0a                	jmp    8010126f <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101265:	85 f6                	test   %esi,%esi
80101267:	74 3b                	je     801012a4 <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101269:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010126f:	81 fb 34 16 11 80    	cmp    $0x80111634,%ebx
80101275:	73 35                	jae    801012ac <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101277:	8b 43 08             	mov    0x8(%ebx),%eax
8010127a:	85 c0                	test   %eax,%eax
8010127c:	7e e7                	jle    80101265 <iget+0x27>
8010127e:	39 3b                	cmp    %edi,(%ebx)
80101280:	75 e3                	jne    80101265 <iget+0x27>
80101282:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101285:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101288:	75 db                	jne    80101265 <iget+0x27>
      ip->ref++;
8010128a:	83 c0 01             	add    $0x1,%eax
8010128d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101290:	83 ec 0c             	sub    $0xc,%esp
80101293:	68 e0 f9 10 80       	push   $0x8010f9e0
80101298:	e8 87 2a 00 00       	call   80103d24 <release>
      return ip;
8010129d:	83 c4 10             	add    $0x10,%esp
801012a0:	89 de                	mov    %ebx,%esi
801012a2:	eb 32                	jmp    801012d6 <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012a4:	85 c0                	test   %eax,%eax
801012a6:	75 c1                	jne    80101269 <iget+0x2b>
      empty = ip;
801012a8:	89 de                	mov    %ebx,%esi
801012aa:	eb bd                	jmp    80101269 <iget+0x2b>
  if(empty == 0)
801012ac:	85 f6                	test   %esi,%esi
801012ae:	74 30                	je     801012e0 <iget+0xa2>
  ip->dev = dev;
801012b0:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012b5:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801012b8:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012bf:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	68 e0 f9 10 80       	push   $0x8010f9e0
801012ce:	e8 51 2a 00 00       	call   80103d24 <release>
  return ip;
801012d3:	83 c4 10             	add    $0x10,%esp
}
801012d6:	89 f0                	mov    %esi,%eax
801012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012db:	5b                   	pop    %ebx
801012dc:	5e                   	pop    %esi
801012dd:	5f                   	pop    %edi
801012de:	5d                   	pop    %ebp
801012df:	c3                   	ret    
    panic("iget: no inodes");
801012e0:	83 ec 0c             	sub    $0xc,%esp
801012e3:	68 db 66 10 80       	push   $0x801066db
801012e8:	e8 6f f0 ff ff       	call   8010035c <panic>

801012ed <readsb>:
{
801012ed:	f3 0f 1e fb          	endbr32 
801012f1:	55                   	push   %ebp
801012f2:	89 e5                	mov    %esp,%ebp
801012f4:	53                   	push   %ebx
801012f5:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012f8:	6a 01                	push   $0x1
801012fa:	ff 75 08             	pushl  0x8(%ebp)
801012fd:	e8 6e ee ff ff       	call   80100170 <bread>
80101302:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101304:	8d 40 5c             	lea    0x5c(%eax),%eax
80101307:	83 c4 0c             	add    $0xc,%esp
8010130a:	6a 1c                	push   $0x1c
8010130c:	50                   	push   %eax
8010130d:	ff 75 0c             	pushl  0xc(%ebp)
80101310:	e8 da 2a 00 00       	call   80103def <memmove>
  brelse(bp);
80101315:	89 1c 24             	mov    %ebx,(%esp)
80101318:	e8 c4 ee ff ff       	call   801001e1 <brelse>
}
8010131d:	83 c4 10             	add    $0x10,%esp
80101320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101323:	c9                   	leave  
80101324:	c3                   	ret    

80101325 <iinit>:
{
80101325:	f3 0f 1e fb          	endbr32 
80101329:	55                   	push   %ebp
8010132a:	89 e5                	mov    %esp,%ebp
8010132c:	53                   	push   %ebx
8010132d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101330:	68 eb 66 10 80       	push   $0x801066eb
80101335:	68 e0 f9 10 80       	push   $0x8010f9e0
8010133a:	e8 2c 28 00 00       	call   80103b6b <initlock>
  for(i = 0; i < NINODE; i++) {
8010133f:	83 c4 10             	add    $0x10,%esp
80101342:	bb 00 00 00 00       	mov    $0x0,%ebx
80101347:	83 fb 31             	cmp    $0x31,%ebx
8010134a:	7f 23                	jg     8010136f <iinit+0x4a>
    initsleeplock(&icache.inode[i].lock, "inode");
8010134c:	83 ec 08             	sub    $0x8,%esp
8010134f:	68 f2 66 10 80       	push   $0x801066f2
80101354:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101357:	89 d0                	mov    %edx,%eax
80101359:	c1 e0 04             	shl    $0x4,%eax
8010135c:	05 20 fa 10 80       	add    $0x8010fa20,%eax
80101361:	50                   	push   %eax
80101362:	e8 e9 26 00 00       	call   80103a50 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101367:	83 c3 01             	add    $0x1,%ebx
8010136a:	83 c4 10             	add    $0x10,%esp
8010136d:	eb d8                	jmp    80101347 <iinit+0x22>
  readsb(dev, &sb);
8010136f:	83 ec 08             	sub    $0x8,%esp
80101372:	68 c0 f9 10 80       	push   $0x8010f9c0
80101377:	ff 75 08             	pushl  0x8(%ebp)
8010137a:	e8 6e ff ff ff       	call   801012ed <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010137f:	ff 35 d8 f9 10 80    	pushl  0x8010f9d8
80101385:	ff 35 d4 f9 10 80    	pushl  0x8010f9d4
8010138b:	ff 35 d0 f9 10 80    	pushl  0x8010f9d0
80101391:	ff 35 cc f9 10 80    	pushl  0x8010f9cc
80101397:	ff 35 c8 f9 10 80    	pushl  0x8010f9c8
8010139d:	ff 35 c4 f9 10 80    	pushl  0x8010f9c4
801013a3:	ff 35 c0 f9 10 80    	pushl  0x8010f9c0
801013a9:	68 58 67 10 80       	push   $0x80106758
801013ae:	e8 76 f2 ff ff       	call   80100629 <cprintf>
}
801013b3:	83 c4 30             	add    $0x30,%esp
801013b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013b9:	c9                   	leave  
801013ba:	c3                   	ret    

801013bb <ialloc>:
{
801013bb:	f3 0f 1e fb          	endbr32 
801013bf:	55                   	push   %ebp
801013c0:	89 e5                	mov    %esp,%ebp
801013c2:	57                   	push   %edi
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	83 ec 1c             	sub    $0x1c,%esp
801013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801013cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013ce:	bb 01 00 00 00       	mov    $0x1,%ebx
801013d3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801013d6:	39 1d c8 f9 10 80    	cmp    %ebx,0x8010f9c8
801013dc:	76 76                	jbe    80101454 <ialloc+0x99>
    bp = bread(dev, IBLOCK(inum, sb));
801013de:	89 d8                	mov    %ebx,%eax
801013e0:	c1 e8 03             	shr    $0x3,%eax
801013e3:	83 ec 08             	sub    $0x8,%esp
801013e6:	03 05 d4 f9 10 80    	add    0x8010f9d4,%eax
801013ec:	50                   	push   %eax
801013ed:	ff 75 08             	pushl  0x8(%ebp)
801013f0:	e8 7b ed ff ff       	call   80100170 <bread>
801013f5:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013f7:	89 d8                	mov    %ebx,%eax
801013f9:	83 e0 07             	and    $0x7,%eax
801013fc:	c1 e0 06             	shl    $0x6,%eax
801013ff:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101403:	83 c4 10             	add    $0x10,%esp
80101406:	66 83 3f 00          	cmpw   $0x0,(%edi)
8010140a:	74 11                	je     8010141d <ialloc+0x62>
    brelse(bp);
8010140c:	83 ec 0c             	sub    $0xc,%esp
8010140f:	56                   	push   %esi
80101410:	e8 cc ed ff ff       	call   801001e1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101415:	83 c3 01             	add    $0x1,%ebx
80101418:	83 c4 10             	add    $0x10,%esp
8010141b:	eb b6                	jmp    801013d3 <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
8010141d:	83 ec 04             	sub    $0x4,%esp
80101420:	6a 40                	push   $0x40
80101422:	6a 00                	push   $0x0
80101424:	57                   	push   %edi
80101425:	e8 45 29 00 00       	call   80103d6f <memset>
      dip->type = type;
8010142a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010142e:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 47 15 00 00       	call   80102980 <log_write>
      brelse(bp);
80101439:	89 34 24             	mov    %esi,(%esp)
8010143c:	e8 a0 ed ff ff       	call   801001e1 <brelse>
      return iget(dev, inum);
80101441:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101444:	8b 45 08             	mov    0x8(%ebp),%eax
80101447:	e8 f2 fd ff ff       	call   8010123e <iget>
}
8010144c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5f                   	pop    %edi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret    
  panic("ialloc: no inodes");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 f8 66 10 80       	push   $0x801066f8
8010145c:	e8 fb ee ff ff       	call   8010035c <panic>

80101461 <iupdate>:
{
80101461:	f3 0f 1e fb          	endbr32 
80101465:	55                   	push   %ebp
80101466:	89 e5                	mov    %esp,%ebp
80101468:	56                   	push   %esi
80101469:	53                   	push   %ebx
8010146a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010146d:	8b 43 04             	mov    0x4(%ebx),%eax
80101470:	c1 e8 03             	shr    $0x3,%eax
80101473:	83 ec 08             	sub    $0x8,%esp
80101476:	03 05 d4 f9 10 80    	add    0x8010f9d4,%eax
8010147c:	50                   	push   %eax
8010147d:	ff 33                	pushl  (%ebx)
8010147f:	e8 ec ec ff ff       	call   80100170 <bread>
80101484:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101486:	8b 43 04             	mov    0x4(%ebx),%eax
80101489:	83 e0 07             	and    $0x7,%eax
8010148c:	c1 e0 06             	shl    $0x6,%eax
8010148f:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101493:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101497:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010149a:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
8010149e:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014a2:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
801014a6:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801014aa:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
801014ae:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014b2:	8b 53 58             	mov    0x58(%ebx),%edx
801014b5:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014b8:	83 c3 5c             	add    $0x5c,%ebx
801014bb:	83 c0 0c             	add    $0xc,%eax
801014be:	83 c4 0c             	add    $0xc,%esp
801014c1:	6a 34                	push   $0x34
801014c3:	53                   	push   %ebx
801014c4:	50                   	push   %eax
801014c5:	e8 25 29 00 00       	call   80103def <memmove>
  log_write(bp);
801014ca:	89 34 24             	mov    %esi,(%esp)
801014cd:	e8 ae 14 00 00       	call   80102980 <log_write>
  brelse(bp);
801014d2:	89 34 24             	mov    %esi,(%esp)
801014d5:	e8 07 ed ff ff       	call   801001e1 <brelse>
}
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014e0:	5b                   	pop    %ebx
801014e1:	5e                   	pop    %esi
801014e2:	5d                   	pop    %ebp
801014e3:	c3                   	ret    

801014e4 <itrunc>:
{
801014e4:	55                   	push   %ebp
801014e5:	89 e5                	mov    %esp,%ebp
801014e7:	57                   	push   %edi
801014e8:	56                   	push   %esi
801014e9:	53                   	push   %ebx
801014ea:	83 ec 1c             	sub    $0x1c,%esp
801014ed:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014ef:	bb 00 00 00 00       	mov    $0x0,%ebx
801014f4:	eb 03                	jmp    801014f9 <itrunc+0x15>
801014f6:	83 c3 01             	add    $0x1,%ebx
801014f9:	83 fb 0b             	cmp    $0xb,%ebx
801014fc:	7f 19                	jg     80101517 <itrunc+0x33>
    if(ip->addrs[i]){
801014fe:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
80101502:	85 d2                	test   %edx,%edx
80101504:	74 f0                	je     801014f6 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
80101506:	8b 06                	mov    (%esi),%eax
80101508:	e8 2e fb ff ff       	call   8010103b <bfree>
      ip->addrs[i] = 0;
8010150d:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101514:	00 
80101515:	eb df                	jmp    801014f6 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
80101517:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
8010151d:	85 c0                	test   %eax,%eax
8010151f:	75 1b                	jne    8010153c <itrunc+0x58>
  ip->size = 0;
80101521:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101528:	83 ec 0c             	sub    $0xc,%esp
8010152b:	56                   	push   %esi
8010152c:	e8 30 ff ff ff       	call   80101461 <iupdate>
}
80101531:	83 c4 10             	add    $0x10,%esp
80101534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101537:	5b                   	pop    %ebx
80101538:	5e                   	pop    %esi
80101539:	5f                   	pop    %edi
8010153a:	5d                   	pop    %ebp
8010153b:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010153c:	83 ec 08             	sub    $0x8,%esp
8010153f:	50                   	push   %eax
80101540:	ff 36                	pushl  (%esi)
80101542:	e8 29 ec ff ff       	call   80100170 <bread>
80101547:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010154a:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010154d:	83 c4 10             	add    $0x10,%esp
80101550:	bb 00 00 00 00       	mov    $0x0,%ebx
80101555:	eb 0a                	jmp    80101561 <itrunc+0x7d>
        bfree(ip->dev, a[j]);
80101557:	8b 06                	mov    (%esi),%eax
80101559:	e8 dd fa ff ff       	call   8010103b <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010155e:	83 c3 01             	add    $0x1,%ebx
80101561:	83 fb 7f             	cmp    $0x7f,%ebx
80101564:	77 09                	ja     8010156f <itrunc+0x8b>
      if(a[j])
80101566:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101569:	85 d2                	test   %edx,%edx
8010156b:	74 f1                	je     8010155e <itrunc+0x7a>
8010156d:	eb e8                	jmp    80101557 <itrunc+0x73>
    brelse(bp);
8010156f:	83 ec 0c             	sub    $0xc,%esp
80101572:	ff 75 e4             	pushl  -0x1c(%ebp)
80101575:	e8 67 ec ff ff       	call   801001e1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010157a:	8b 06                	mov    (%esi),%eax
8010157c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101582:	e8 b4 fa ff ff       	call   8010103b <bfree>
    ip->addrs[NDIRECT] = 0;
80101587:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010158e:	00 00 00 
80101591:	83 c4 10             	add    $0x10,%esp
80101594:	eb 8b                	jmp    80101521 <itrunc+0x3d>

80101596 <idup>:
{
80101596:	f3 0f 1e fb          	endbr32 
8010159a:	55                   	push   %ebp
8010159b:	89 e5                	mov    %esp,%ebp
8010159d:	53                   	push   %ebx
8010159e:	83 ec 10             	sub    $0x10,%esp
801015a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015a4:	68 e0 f9 10 80       	push   $0x8010f9e0
801015a9:	e8 0d 27 00 00       	call   80103cbb <acquire>
  ip->ref++;
801015ae:	8b 43 08             	mov    0x8(%ebx),%eax
801015b1:	83 c0 01             	add    $0x1,%eax
801015b4:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801015b7:	c7 04 24 e0 f9 10 80 	movl   $0x8010f9e0,(%esp)
801015be:	e8 61 27 00 00       	call   80103d24 <release>
}
801015c3:	89 d8                	mov    %ebx,%eax
801015c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015c8:	c9                   	leave  
801015c9:	c3                   	ret    

801015ca <ilock>:
{
801015ca:	f3 0f 1e fb          	endbr32 
801015ce:	55                   	push   %ebp
801015cf:	89 e5                	mov    %esp,%ebp
801015d1:	56                   	push   %esi
801015d2:	53                   	push   %ebx
801015d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015d6:	85 db                	test   %ebx,%ebx
801015d8:	74 22                	je     801015fc <ilock+0x32>
801015da:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015de:	7e 1c                	jle    801015fc <ilock+0x32>
  acquiresleep(&ip->lock);
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	8d 43 0c             	lea    0xc(%ebx),%eax
801015e6:	50                   	push   %eax
801015e7:	e8 9b 24 00 00       	call   80103a87 <acquiresleep>
  if(ip->valid == 0){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015f3:	74 14                	je     80101609 <ilock+0x3f>
}
801015f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015f8:	5b                   	pop    %ebx
801015f9:	5e                   	pop    %esi
801015fa:	5d                   	pop    %ebp
801015fb:	c3                   	ret    
    panic("ilock");
801015fc:	83 ec 0c             	sub    $0xc,%esp
801015ff:	68 0a 67 10 80       	push   $0x8010670a
80101604:	e8 53 ed ff ff       	call   8010035c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101609:	8b 43 04             	mov    0x4(%ebx),%eax
8010160c:	c1 e8 03             	shr    $0x3,%eax
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	03 05 d4 f9 10 80    	add    0x8010f9d4,%eax
80101618:	50                   	push   %eax
80101619:	ff 33                	pushl  (%ebx)
8010161b:	e8 50 eb ff ff       	call   80100170 <bread>
80101620:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101622:	8b 43 04             	mov    0x4(%ebx),%eax
80101625:	83 e0 07             	and    $0x7,%eax
80101628:	c1 e0 06             	shl    $0x6,%eax
8010162b:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
8010162f:	0f b7 10             	movzwl (%eax),%edx
80101632:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101636:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010163a:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010163e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101642:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101646:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010164a:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010164e:	8b 50 08             	mov    0x8(%eax),%edx
80101651:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101654:	83 c0 0c             	add    $0xc,%eax
80101657:	8d 53 5c             	lea    0x5c(%ebx),%edx
8010165a:	83 c4 0c             	add    $0xc,%esp
8010165d:	6a 34                	push   $0x34
8010165f:	50                   	push   %eax
80101660:	52                   	push   %edx
80101661:	e8 89 27 00 00       	call   80103def <memmove>
    brelse(bp);
80101666:	89 34 24             	mov    %esi,(%esp)
80101669:	e8 73 eb ff ff       	call   801001e1 <brelse>
    ip->valid = 1;
8010166e:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101675:	83 c4 10             	add    $0x10,%esp
80101678:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010167d:	0f 85 72 ff ff ff    	jne    801015f5 <ilock+0x2b>
      panic("ilock: no type");
80101683:	83 ec 0c             	sub    $0xc,%esp
80101686:	68 10 67 10 80       	push   $0x80106710
8010168b:	e8 cc ec ff ff       	call   8010035c <panic>

80101690 <iunlock>:
{
80101690:	f3 0f 1e fb          	endbr32 
80101694:	55                   	push   %ebp
80101695:	89 e5                	mov    %esp,%ebp
80101697:	56                   	push   %esi
80101698:	53                   	push   %ebx
80101699:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010169c:	85 db                	test   %ebx,%ebx
8010169e:	74 2c                	je     801016cc <iunlock+0x3c>
801016a0:	8d 73 0c             	lea    0xc(%ebx),%esi
801016a3:	83 ec 0c             	sub    $0xc,%esp
801016a6:	56                   	push   %esi
801016a7:	e8 6d 24 00 00       	call   80103b19 <holdingsleep>
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	85 c0                	test   %eax,%eax
801016b1:	74 19                	je     801016cc <iunlock+0x3c>
801016b3:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801016b7:	7e 13                	jle    801016cc <iunlock+0x3c>
  releasesleep(&ip->lock);
801016b9:	83 ec 0c             	sub    $0xc,%esp
801016bc:	56                   	push   %esi
801016bd:	e8 18 24 00 00       	call   80103ada <releasesleep>
}
801016c2:	83 c4 10             	add    $0x10,%esp
801016c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c8:	5b                   	pop    %ebx
801016c9:	5e                   	pop    %esi
801016ca:	5d                   	pop    %ebp
801016cb:	c3                   	ret    
    panic("iunlock");
801016cc:	83 ec 0c             	sub    $0xc,%esp
801016cf:	68 1f 67 10 80       	push   $0x8010671f
801016d4:	e8 83 ec ff ff       	call   8010035c <panic>

801016d9 <iput>:
{
801016d9:	f3 0f 1e fb          	endbr32 
801016dd:	55                   	push   %ebp
801016de:	89 e5                	mov    %esp,%ebp
801016e0:	57                   	push   %edi
801016e1:	56                   	push   %esi
801016e2:	53                   	push   %ebx
801016e3:	83 ec 18             	sub    $0x18,%esp
801016e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016e9:	8d 73 0c             	lea    0xc(%ebx),%esi
801016ec:	56                   	push   %esi
801016ed:	e8 95 23 00 00       	call   80103a87 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016f2:	83 c4 10             	add    $0x10,%esp
801016f5:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016f9:	74 07                	je     80101702 <iput+0x29>
801016fb:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101700:	74 35                	je     80101737 <iput+0x5e>
  releasesleep(&ip->lock);
80101702:	83 ec 0c             	sub    $0xc,%esp
80101705:	56                   	push   %esi
80101706:	e8 cf 23 00 00       	call   80103ada <releasesleep>
  acquire(&icache.lock);
8010170b:	c7 04 24 e0 f9 10 80 	movl   $0x8010f9e0,(%esp)
80101712:	e8 a4 25 00 00       	call   80103cbb <acquire>
  ip->ref--;
80101717:	8b 43 08             	mov    0x8(%ebx),%eax
8010171a:	83 e8 01             	sub    $0x1,%eax
8010171d:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101720:	c7 04 24 e0 f9 10 80 	movl   $0x8010f9e0,(%esp)
80101727:	e8 f8 25 00 00       	call   80103d24 <release>
}
8010172c:	83 c4 10             	add    $0x10,%esp
8010172f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101732:	5b                   	pop    %ebx
80101733:	5e                   	pop    %esi
80101734:	5f                   	pop    %edi
80101735:	5d                   	pop    %ebp
80101736:	c3                   	ret    
    acquire(&icache.lock);
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 e0 f9 10 80       	push   $0x8010f9e0
8010173f:	e8 77 25 00 00       	call   80103cbb <acquire>
    int r = ip->ref;
80101744:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101747:	c7 04 24 e0 f9 10 80 	movl   $0x8010f9e0,(%esp)
8010174e:	e8 d1 25 00 00       	call   80103d24 <release>
    if(r == 1){
80101753:	83 c4 10             	add    $0x10,%esp
80101756:	83 ff 01             	cmp    $0x1,%edi
80101759:	75 a7                	jne    80101702 <iput+0x29>
      itrunc(ip);
8010175b:	89 d8                	mov    %ebx,%eax
8010175d:	e8 82 fd ff ff       	call   801014e4 <itrunc>
      ip->type = 0;
80101762:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101768:	83 ec 0c             	sub    $0xc,%esp
8010176b:	53                   	push   %ebx
8010176c:	e8 f0 fc ff ff       	call   80101461 <iupdate>
      ip->valid = 0;
80101771:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	eb 85                	jmp    80101702 <iput+0x29>

8010177d <iunlockput>:
{
8010177d:	f3 0f 1e fb          	endbr32 
80101781:	55                   	push   %ebp
80101782:	89 e5                	mov    %esp,%ebp
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010178b:	53                   	push   %ebx
8010178c:	e8 ff fe ff ff       	call   80101690 <iunlock>
  iput(ip);
80101791:	89 1c 24             	mov    %ebx,(%esp)
80101794:	e8 40 ff ff ff       	call   801016d9 <iput>
}
80101799:	83 c4 10             	add    $0x10,%esp
8010179c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010179f:	c9                   	leave  
801017a0:	c3                   	ret    

801017a1 <stati>:
{
801017a1:	f3 0f 1e fb          	endbr32 
801017a5:	55                   	push   %ebp
801017a6:	89 e5                	mov    %esp,%ebp
801017a8:	8b 55 08             	mov    0x8(%ebp),%edx
801017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017ae:	8b 0a                	mov    (%edx),%ecx
801017b0:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017b3:	8b 4a 04             	mov    0x4(%edx),%ecx
801017b6:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017b9:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801017bd:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017c0:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801017c4:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801017c8:	8b 52 58             	mov    0x58(%edx),%edx
801017cb:	89 50 10             	mov    %edx,0x10(%eax)
}
801017ce:	5d                   	pop    %ebp
801017cf:	c3                   	ret    

801017d0 <readi>:
{
801017d0:	f3 0f 1e fb          	endbr32 
801017d4:	55                   	push   %ebp
801017d5:	89 e5                	mov    %esp,%ebp
801017d7:	57                   	push   %edi
801017d8:	56                   	push   %esi
801017d9:	53                   	push   %ebx
801017da:	83 ec 1c             	sub    $0x1c,%esp
801017dd:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
801017e0:	8b 45 08             	mov    0x8(%ebp),%eax
801017e3:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017e8:	74 2c                	je     80101816 <readi+0x46>
  if(off > ip->size || off + n < off)
801017ea:	8b 45 08             	mov    0x8(%ebp),%eax
801017ed:	8b 40 58             	mov    0x58(%eax),%eax
801017f0:	39 f0                	cmp    %esi,%eax
801017f2:	0f 82 cb 00 00 00    	jb     801018c3 <readi+0xf3>
801017f8:	89 f2                	mov    %esi,%edx
801017fa:	03 55 14             	add    0x14(%ebp),%edx
801017fd:	0f 82 c7 00 00 00    	jb     801018ca <readi+0xfa>
  if(off + n > ip->size)
80101803:	39 d0                	cmp    %edx,%eax
80101805:	73 05                	jae    8010180c <readi+0x3c>
    n = ip->size - off;
80101807:	29 f0                	sub    %esi,%eax
80101809:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010180c:	bf 00 00 00 00       	mov    $0x0,%edi
80101811:	e9 8f 00 00 00       	jmp    801018a5 <readi+0xd5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101816:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010181a:	66 83 f8 09          	cmp    $0x9,%ax
8010181e:	0f 87 91 00 00 00    	ja     801018b5 <readi+0xe5>
80101824:	98                   	cwtl   
80101825:	8b 04 c5 60 f9 10 80 	mov    -0x7fef06a0(,%eax,8),%eax
8010182c:	85 c0                	test   %eax,%eax
8010182e:	0f 84 88 00 00 00    	je     801018bc <readi+0xec>
    return devsw[ip->major].read(ip, dst, n);
80101834:	83 ec 04             	sub    $0x4,%esp
80101837:	ff 75 14             	pushl  0x14(%ebp)
8010183a:	ff 75 0c             	pushl  0xc(%ebp)
8010183d:	ff 75 08             	pushl  0x8(%ebp)
80101840:	ff d0                	call   *%eax
80101842:	83 c4 10             	add    $0x10,%esp
80101845:	eb 66                	jmp    801018ad <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101847:	89 f2                	mov    %esi,%edx
80101849:	c1 ea 09             	shr    $0x9,%edx
8010184c:	8b 45 08             	mov    0x8(%ebp),%eax
8010184f:	e8 44 f9 ff ff       	call   80101198 <bmap>
80101854:	83 ec 08             	sub    $0x8,%esp
80101857:	50                   	push   %eax
80101858:	8b 45 08             	mov    0x8(%ebp),%eax
8010185b:	ff 30                	pushl  (%eax)
8010185d:	e8 0e e9 ff ff       	call   80100170 <bread>
80101862:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
80101864:	89 f0                	mov    %esi,%eax
80101866:	25 ff 01 00 00       	and    $0x1ff,%eax
8010186b:	bb 00 02 00 00       	mov    $0x200,%ebx
80101870:	29 c3                	sub    %eax,%ebx
80101872:	8b 55 14             	mov    0x14(%ebp),%edx
80101875:	29 fa                	sub    %edi,%edx
80101877:	83 c4 0c             	add    $0xc,%esp
8010187a:	39 d3                	cmp    %edx,%ebx
8010187c:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010187f:	53                   	push   %ebx
80101880:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101883:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101887:	50                   	push   %eax
80101888:	ff 75 0c             	pushl  0xc(%ebp)
8010188b:	e8 5f 25 00 00       	call   80103def <memmove>
    brelse(bp);
80101890:	83 c4 04             	add    $0x4,%esp
80101893:	ff 75 e4             	pushl  -0x1c(%ebp)
80101896:	e8 46 e9 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010189b:	01 df                	add    %ebx,%edi
8010189d:	01 de                	add    %ebx,%esi
8010189f:	01 5d 0c             	add    %ebx,0xc(%ebp)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	39 7d 14             	cmp    %edi,0x14(%ebp)
801018a8:	77 9d                	ja     80101847 <readi+0x77>
  return n;
801018aa:	8b 45 14             	mov    0x14(%ebp),%eax
}
801018ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b0:	5b                   	pop    %ebx
801018b1:	5e                   	pop    %esi
801018b2:	5f                   	pop    %edi
801018b3:	5d                   	pop    %ebp
801018b4:	c3                   	ret    
      return -1;
801018b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018ba:	eb f1                	jmp    801018ad <readi+0xdd>
801018bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018c1:	eb ea                	jmp    801018ad <readi+0xdd>
    return -1;
801018c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018c8:	eb e3                	jmp    801018ad <readi+0xdd>
801018ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018cf:	eb dc                	jmp    801018ad <readi+0xdd>

801018d1 <writei>:
{
801018d1:	f3 0f 1e fb          	endbr32 
801018d5:	55                   	push   %ebp
801018d6:	89 e5                	mov    %esp,%ebp
801018d8:	57                   	push   %edi
801018d9:	56                   	push   %esi
801018da:	53                   	push   %ebx
801018db:	83 ec 1c             	sub    $0x1c,%esp
801018de:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
801018e1:	8b 45 08             	mov    0x8(%ebp),%eax
801018e4:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018e9:	0f 84 9b 00 00 00    	je     8010198a <writei+0xb9>
  if(off > ip->size || off + n < off)
801018ef:	8b 45 08             	mov    0x8(%ebp),%eax
801018f2:	39 70 58             	cmp    %esi,0x58(%eax)
801018f5:	0f 82 f0 00 00 00    	jb     801019eb <writei+0x11a>
801018fb:	89 f0                	mov    %esi,%eax
801018fd:	03 45 14             	add    0x14(%ebp),%eax
80101900:	0f 82 ec 00 00 00    	jb     801019f2 <writei+0x121>
  if(off + n > MAXFILE*BSIZE)
80101906:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010190b:	0f 87 e8 00 00 00    	ja     801019f9 <writei+0x128>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101911:	bf 00 00 00 00       	mov    $0x0,%edi
80101916:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101919:	0f 83 94 00 00 00    	jae    801019b3 <writei+0xe2>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010191f:	89 f2                	mov    %esi,%edx
80101921:	c1 ea 09             	shr    $0x9,%edx
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	e8 6c f8 ff ff       	call   80101198 <bmap>
8010192c:	83 ec 08             	sub    $0x8,%esp
8010192f:	50                   	push   %eax
80101930:	8b 45 08             	mov    0x8(%ebp),%eax
80101933:	ff 30                	pushl  (%eax)
80101935:	e8 36 e8 ff ff       	call   80100170 <bread>
8010193a:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
8010193c:	89 f0                	mov    %esi,%eax
8010193e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101943:	bb 00 02 00 00       	mov    $0x200,%ebx
80101948:	29 c3                	sub    %eax,%ebx
8010194a:	8b 55 14             	mov    0x14(%ebp),%edx
8010194d:	29 fa                	sub    %edi,%edx
8010194f:	83 c4 0c             	add    $0xc,%esp
80101952:	39 d3                	cmp    %edx,%ebx
80101954:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101957:	53                   	push   %ebx
80101958:	ff 75 0c             	pushl  0xc(%ebp)
8010195b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010195e:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101962:	50                   	push   %eax
80101963:	e8 87 24 00 00       	call   80103def <memmove>
    log_write(bp);
80101968:	83 c4 04             	add    $0x4,%esp
8010196b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010196e:	e8 0d 10 00 00       	call   80102980 <log_write>
    brelse(bp);
80101973:	83 c4 04             	add    $0x4,%esp
80101976:	ff 75 e4             	pushl  -0x1c(%ebp)
80101979:	e8 63 e8 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010197e:	01 df                	add    %ebx,%edi
80101980:	01 de                	add    %ebx,%esi
80101982:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101985:	83 c4 10             	add    $0x10,%esp
80101988:	eb 8c                	jmp    80101916 <writei+0x45>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010198a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010198e:	66 83 f8 09          	cmp    $0x9,%ax
80101992:	77 49                	ja     801019dd <writei+0x10c>
80101994:	98                   	cwtl   
80101995:	8b 04 c5 64 f9 10 80 	mov    -0x7fef069c(,%eax,8),%eax
8010199c:	85 c0                	test   %eax,%eax
8010199e:	74 44                	je     801019e4 <writei+0x113>
    return devsw[ip->major].write(ip, src, n);
801019a0:	83 ec 04             	sub    $0x4,%esp
801019a3:	ff 75 14             	pushl  0x14(%ebp)
801019a6:	ff 75 0c             	pushl  0xc(%ebp)
801019a9:	ff 75 08             	pushl  0x8(%ebp)
801019ac:	ff d0                	call   *%eax
801019ae:	83 c4 10             	add    $0x10,%esp
801019b1:	eb 11                	jmp    801019c4 <writei+0xf3>
  if(n > 0 && off > ip->size){
801019b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801019b7:	74 08                	je     801019c1 <writei+0xf0>
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	39 70 58             	cmp    %esi,0x58(%eax)
801019bf:	72 0b                	jb     801019cc <writei+0xfb>
  return n;
801019c1:	8b 45 14             	mov    0x14(%ebp),%eax
}
801019c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019c7:	5b                   	pop    %ebx
801019c8:	5e                   	pop    %esi
801019c9:	5f                   	pop    %edi
801019ca:	5d                   	pop    %ebp
801019cb:	c3                   	ret    
    ip->size = off;
801019cc:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	50                   	push   %eax
801019d3:	e8 89 fa ff ff       	call   80101461 <iupdate>
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	eb e4                	jmp    801019c1 <writei+0xf0>
      return -1;
801019dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019e2:	eb e0                	jmp    801019c4 <writei+0xf3>
801019e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019e9:	eb d9                	jmp    801019c4 <writei+0xf3>
    return -1;
801019eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019f0:	eb d2                	jmp    801019c4 <writei+0xf3>
801019f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019f7:	eb cb                	jmp    801019c4 <writei+0xf3>
    return -1;
801019f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019fe:	eb c4                	jmp    801019c4 <writei+0xf3>

80101a00 <namecmp>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a0a:	6a 0e                	push   $0xe
80101a0c:	ff 75 0c             	pushl  0xc(%ebp)
80101a0f:	ff 75 08             	pushl  0x8(%ebp)
80101a12:	e8 4a 24 00 00       	call   80103e61 <strncmp>
}
80101a17:	c9                   	leave  
80101a18:	c3                   	ret    

80101a19 <dirlookup>:
{
80101a19:	f3 0f 1e fb          	endbr32 
80101a1d:	55                   	push   %ebp
80101a1e:	89 e5                	mov    %esp,%ebp
80101a20:	57                   	push   %edi
80101a21:	56                   	push   %esi
80101a22:	53                   	push   %ebx
80101a23:	83 ec 1c             	sub    $0x1c,%esp
80101a26:	8b 75 08             	mov    0x8(%ebp),%esi
80101a29:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
80101a2c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a31:	75 07                	jne    80101a3a <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a33:	bb 00 00 00 00       	mov    $0x0,%ebx
80101a38:	eb 1d                	jmp    80101a57 <dirlookup+0x3e>
    panic("dirlookup not DIR");
80101a3a:	83 ec 0c             	sub    $0xc,%esp
80101a3d:	68 27 67 10 80       	push   $0x80106727
80101a42:	e8 15 e9 ff ff       	call   8010035c <panic>
      panic("dirlookup read");
80101a47:	83 ec 0c             	sub    $0xc,%esp
80101a4a:	68 39 67 10 80       	push   $0x80106739
80101a4f:	e8 08 e9 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a54:	83 c3 10             	add    $0x10,%ebx
80101a57:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a5a:	76 48                	jbe    80101aa4 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a5c:	6a 10                	push   $0x10
80101a5e:	53                   	push   %ebx
80101a5f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a62:	50                   	push   %eax
80101a63:	56                   	push   %esi
80101a64:	e8 67 fd ff ff       	call   801017d0 <readi>
80101a69:	83 c4 10             	add    $0x10,%esp
80101a6c:	83 f8 10             	cmp    $0x10,%eax
80101a6f:	75 d6                	jne    80101a47 <dirlookup+0x2e>
    if(de.inum == 0)
80101a71:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a76:	74 dc                	je     80101a54 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101a78:	83 ec 08             	sub    $0x8,%esp
80101a7b:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a7e:	50                   	push   %eax
80101a7f:	57                   	push   %edi
80101a80:	e8 7b ff ff ff       	call   80101a00 <namecmp>
80101a85:	83 c4 10             	add    $0x10,%esp
80101a88:	85 c0                	test   %eax,%eax
80101a8a:	75 c8                	jne    80101a54 <dirlookup+0x3b>
      if(poff)
80101a8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a90:	74 05                	je     80101a97 <dirlookup+0x7e>
        *poff = off;
80101a92:	8b 45 10             	mov    0x10(%ebp),%eax
80101a95:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a97:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a9b:	8b 06                	mov    (%esi),%eax
80101a9d:	e8 9c f7 ff ff       	call   8010123e <iget>
80101aa2:	eb 05                	jmp    80101aa9 <dirlookup+0x90>
  return 0;
80101aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101aa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aac:	5b                   	pop    %ebx
80101aad:	5e                   	pop    %esi
80101aae:	5f                   	pop    %edi
80101aaf:	5d                   	pop    %ebp
80101ab0:	c3                   	ret    

80101ab1 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ab1:	55                   	push   %ebp
80101ab2:	89 e5                	mov    %esp,%ebp
80101ab4:	57                   	push   %edi
80101ab5:	56                   	push   %esi
80101ab6:	53                   	push   %ebx
80101ab7:	83 ec 1c             	sub    $0x1c,%esp
80101aba:	89 c3                	mov    %eax,%ebx
80101abc:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101abf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ac2:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ac5:	74 17                	je     80101ade <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ac7:	e8 f9 17 00 00       	call   801032c5 <myproc>
80101acc:	83 ec 0c             	sub    $0xc,%esp
80101acf:	ff 70 68             	pushl  0x68(%eax)
80101ad2:	e8 bf fa ff ff       	call   80101596 <idup>
80101ad7:	89 c6                	mov    %eax,%esi
80101ad9:	83 c4 10             	add    $0x10,%esp
80101adc:	eb 53                	jmp    80101b31 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101ade:	ba 01 00 00 00       	mov    $0x1,%edx
80101ae3:	b8 01 00 00 00       	mov    $0x1,%eax
80101ae8:	e8 51 f7 ff ff       	call   8010123e <iget>
80101aed:	89 c6                	mov    %eax,%esi
80101aef:	eb 40                	jmp    80101b31 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101af1:	83 ec 0c             	sub    $0xc,%esp
80101af4:	56                   	push   %esi
80101af5:	e8 83 fc ff ff       	call   8010177d <iunlockput>
      return 0;
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101b02:	89 f0                	mov    %esi,%eax
80101b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b07:	5b                   	pop    %ebx
80101b08:	5e                   	pop    %esi
80101b09:	5f                   	pop    %edi
80101b0a:	5d                   	pop    %ebp
80101b0b:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101b0c:	83 ec 04             	sub    $0x4,%esp
80101b0f:	6a 00                	push   $0x0
80101b11:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b14:	56                   	push   %esi
80101b15:	e8 ff fe ff ff       	call   80101a19 <dirlookup>
80101b1a:	89 c7                	mov    %eax,%edi
80101b1c:	83 c4 10             	add    $0x10,%esp
80101b1f:	85 c0                	test   %eax,%eax
80101b21:	74 4a                	je     80101b6d <namex+0xbc>
    iunlockput(ip);
80101b23:	83 ec 0c             	sub    $0xc,%esp
80101b26:	56                   	push   %esi
80101b27:	e8 51 fc ff ff       	call   8010177d <iunlockput>
80101b2c:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b2f:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101b31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b34:	89 d8                	mov    %ebx,%eax
80101b36:	e8 49 f4 ff ff       	call   80100f84 <skipelem>
80101b3b:	89 c3                	mov    %eax,%ebx
80101b3d:	85 c0                	test   %eax,%eax
80101b3f:	74 3c                	je     80101b7d <namex+0xcc>
    ilock(ip);
80101b41:	83 ec 0c             	sub    $0xc,%esp
80101b44:	56                   	push   %esi
80101b45:	e8 80 fa ff ff       	call   801015ca <ilock>
    if(ip->type != T_DIR){
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b52:	75 9d                	jne    80101af1 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b58:	74 b2                	je     80101b0c <namex+0x5b>
80101b5a:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b5d:	75 ad                	jne    80101b0c <namex+0x5b>
      iunlock(ip);
80101b5f:	83 ec 0c             	sub    $0xc,%esp
80101b62:	56                   	push   %esi
80101b63:	e8 28 fb ff ff       	call   80101690 <iunlock>
      return ip;
80101b68:	83 c4 10             	add    $0x10,%esp
80101b6b:	eb 95                	jmp    80101b02 <namex+0x51>
      iunlockput(ip);
80101b6d:	83 ec 0c             	sub    $0xc,%esp
80101b70:	56                   	push   %esi
80101b71:	e8 07 fc ff ff       	call   8010177d <iunlockput>
      return 0;
80101b76:	83 c4 10             	add    $0x10,%esp
80101b79:	89 fe                	mov    %edi,%esi
80101b7b:	eb 85                	jmp    80101b02 <namex+0x51>
  if(nameiparent){
80101b7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b81:	0f 84 7b ff ff ff    	je     80101b02 <namex+0x51>
    iput(ip);
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	56                   	push   %esi
80101b8b:	e8 49 fb ff ff       	call   801016d9 <iput>
    return 0;
80101b90:	83 c4 10             	add    $0x10,%esp
80101b93:	89 de                	mov    %ebx,%esi
80101b95:	e9 68 ff ff ff       	jmp    80101b02 <namex+0x51>

80101b9a <dirlink>:
{
80101b9a:	f3 0f 1e fb          	endbr32 
80101b9e:	55                   	push   %ebp
80101b9f:	89 e5                	mov    %esp,%ebp
80101ba1:	57                   	push   %edi
80101ba2:	56                   	push   %esi
80101ba3:	53                   	push   %ebx
80101ba4:	83 ec 20             	sub    $0x20,%esp
80101ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101baa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101bad:	6a 00                	push   $0x0
80101baf:	57                   	push   %edi
80101bb0:	53                   	push   %ebx
80101bb1:	e8 63 fe ff ff       	call   80101a19 <dirlookup>
80101bb6:	83 c4 10             	add    $0x10,%esp
80101bb9:	85 c0                	test   %eax,%eax
80101bbb:	75 07                	jne    80101bc4 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bbd:	b8 00 00 00 00       	mov    $0x0,%eax
80101bc2:	eb 23                	jmp    80101be7 <dirlink+0x4d>
    iput(ip);
80101bc4:	83 ec 0c             	sub    $0xc,%esp
80101bc7:	50                   	push   %eax
80101bc8:	e8 0c fb ff ff       	call   801016d9 <iput>
    return -1;
80101bcd:	83 c4 10             	add    $0x10,%esp
80101bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd5:	eb 63                	jmp    80101c3a <dirlink+0xa0>
      panic("dirlink read");
80101bd7:	83 ec 0c             	sub    $0xc,%esp
80101bda:	68 48 67 10 80       	push   $0x80106748
80101bdf:	e8 78 e7 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101be4:	8d 46 10             	lea    0x10(%esi),%eax
80101be7:	89 c6                	mov    %eax,%esi
80101be9:	39 43 58             	cmp    %eax,0x58(%ebx)
80101bec:	76 1c                	jbe    80101c0a <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bee:	6a 10                	push   $0x10
80101bf0:	50                   	push   %eax
80101bf1:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101bf4:	50                   	push   %eax
80101bf5:	53                   	push   %ebx
80101bf6:	e8 d5 fb ff ff       	call   801017d0 <readi>
80101bfb:	83 c4 10             	add    $0x10,%esp
80101bfe:	83 f8 10             	cmp    $0x10,%eax
80101c01:	75 d4                	jne    80101bd7 <dirlink+0x3d>
    if(de.inum == 0)
80101c03:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c08:	75 da                	jne    80101be4 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101c0a:	83 ec 04             	sub    $0x4,%esp
80101c0d:	6a 0e                	push   $0xe
80101c0f:	57                   	push   %edi
80101c10:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c13:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c16:	50                   	push   %eax
80101c17:	e8 86 22 00 00       	call   80103ea2 <strncpy>
  de.inum = inum;
80101c1c:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1f:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c23:	6a 10                	push   $0x10
80101c25:	56                   	push   %esi
80101c26:	57                   	push   %edi
80101c27:	53                   	push   %ebx
80101c28:	e8 a4 fc ff ff       	call   801018d1 <writei>
80101c2d:	83 c4 20             	add    $0x20,%esp
80101c30:	83 f8 10             	cmp    $0x10,%eax
80101c33:	75 0d                	jne    80101c42 <dirlink+0xa8>
  return 0;
80101c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3d:	5b                   	pop    %ebx
80101c3e:	5e                   	pop    %esi
80101c3f:	5f                   	pop    %edi
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    
    panic("dirlink");
80101c42:	83 ec 0c             	sub    $0xc,%esp
80101c45:	68 30 6d 10 80       	push   $0x80106d30
80101c4a:	e8 0d e7 ff ff       	call   8010035c <panic>

80101c4f <namei>:

struct inode*
namei(char *path)
{
80101c4f:	f3 0f 1e fb          	endbr32 
80101c53:	55                   	push   %ebp
80101c54:	89 e5                	mov    %esp,%ebp
80101c56:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c59:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c5c:	ba 00 00 00 00       	mov    $0x0,%edx
80101c61:	8b 45 08             	mov    0x8(%ebp),%eax
80101c64:	e8 48 fe ff ff       	call   80101ab1 <namex>
}
80101c69:	c9                   	leave  
80101c6a:	c3                   	ret    

80101c6b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c6b:	f3 0f 1e fb          	endbr32 
80101c6f:	55                   	push   %ebp
80101c70:	89 e5                	mov    %esp,%ebp
80101c72:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c78:	ba 01 00 00 00       	mov    $0x1,%edx
80101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c80:	e8 2c fe ff ff       	call   80101ab1 <namex>
}
80101c85:	c9                   	leave  
80101c86:	c3                   	ret    

80101c87 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c87:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c89:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c8e:	ec                   	in     (%dx),%al
80101c8f:	89 c2                	mov    %eax,%edx
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c91:	83 e0 c0             	and    $0xffffffc0,%eax
80101c94:	3c 40                	cmp    $0x40,%al
80101c96:	75 f1                	jne    80101c89 <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c98:	85 c9                	test   %ecx,%ecx
80101c9a:	74 0a                	je     80101ca6 <idewait+0x1f>
80101c9c:	f6 c2 21             	test   $0x21,%dl
80101c9f:	75 08                	jne    80101ca9 <idewait+0x22>
    return -1;
  return 0;
80101ca1:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101ca6:	89 c8                	mov    %ecx,%eax
80101ca8:	c3                   	ret    
    return -1;
80101ca9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101cae:	eb f6                	jmp    80101ca6 <idewait+0x1f>

80101cb0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	56                   	push   %esi
80101cb4:	53                   	push   %ebx
  if(b == 0)
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	0f 84 91 00 00 00    	je     80101d4e <idestart+0x9e>
80101cbd:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101cbf:	8b 58 08             	mov    0x8(%eax),%ebx
80101cc2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101cc8:	0f 87 8d 00 00 00    	ja     80101d5b <idestart+0xab>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101cce:	b8 00 00 00 00       	mov    $0x0,%eax
80101cd3:	e8 af ff ff ff       	call   80101c87 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cd8:	b8 00 00 00 00       	mov    $0x0,%eax
80101cdd:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ce2:	ee                   	out    %al,(%dx)
80101ce3:	b8 01 00 00 00       	mov    $0x1,%eax
80101ce8:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101ced:	ee                   	out    %al,(%dx)
80101cee:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cf3:	89 d8                	mov    %ebx,%eax
80101cf5:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cf6:	89 d8                	mov    %ebx,%eax
80101cf8:	c1 f8 08             	sar    $0x8,%eax
80101cfb:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d00:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d01:	89 d8                	mov    %ebx,%eax
80101d03:	c1 f8 10             	sar    $0x10,%eax
80101d06:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d0b:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d0c:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d10:	c1 e0 04             	shl    $0x4,%eax
80101d13:	83 e0 10             	and    $0x10,%eax
80101d16:	c1 fb 18             	sar    $0x18,%ebx
80101d19:	83 e3 0f             	and    $0xf,%ebx
80101d1c:	09 d8                	or     %ebx,%eax
80101d1e:	83 c8 e0             	or     $0xffffffe0,%eax
80101d21:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d26:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d27:	f6 06 04             	testb  $0x4,(%esi)
80101d2a:	74 3c                	je     80101d68 <idestart+0xb8>
80101d2c:	b8 30 00 00 00       	mov    $0x30,%eax
80101d31:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d36:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d37:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d3a:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d3f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d44:	fc                   	cld    
80101d45:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d47:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d4a:	5b                   	pop    %ebx
80101d4b:	5e                   	pop    %esi
80101d4c:	5d                   	pop    %ebp
80101d4d:	c3                   	ret    
    panic("idestart");
80101d4e:	83 ec 0c             	sub    $0xc,%esp
80101d51:	68 ab 67 10 80       	push   $0x801067ab
80101d56:	e8 01 e6 ff ff       	call   8010035c <panic>
    panic("incorrect blockno");
80101d5b:	83 ec 0c             	sub    $0xc,%esp
80101d5e:	68 b4 67 10 80       	push   $0x801067b4
80101d63:	e8 f4 e5 ff ff       	call   8010035c <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d68:	b8 20 00 00 00       	mov    $0x20,%eax
80101d6d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d72:	ee                   	out    %al,(%dx)
}
80101d73:	eb d2                	jmp    80101d47 <idestart+0x97>

80101d75 <ideinit>:
{
80101d75:	f3 0f 1e fb          	endbr32 
80101d79:	55                   	push   %ebp
80101d7a:	89 e5                	mov    %esp,%ebp
80101d7c:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d7f:	68 c6 67 10 80       	push   $0x801067c6
80101d84:	68 80 95 10 80       	push   $0x80109580
80101d89:	e8 dd 1d 00 00       	call   80103b6b <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d8e:	83 c4 08             	add    $0x8,%esp
80101d91:	a1 00 1d 11 80       	mov    0x80111d00,%eax
80101d96:	83 e8 01             	sub    $0x1,%eax
80101d99:	50                   	push   %eax
80101d9a:	6a 0e                	push   $0xe
80101d9c:	e8 5a 02 00 00       	call   80101ffb <ioapicenable>
  idewait(0);
80101da1:	b8 00 00 00 00       	mov    $0x0,%eax
80101da6:	e8 dc fe ff ff       	call   80101c87 <idewait>
80101dab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101db0:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101db5:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101db6:	83 c4 10             	add    $0x10,%esp
80101db9:	b9 00 00 00 00       	mov    $0x0,%ecx
80101dbe:	eb 03                	jmp    80101dc3 <ideinit+0x4e>
80101dc0:	83 c1 01             	add    $0x1,%ecx
80101dc3:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101dc9:	7f 14                	jg     80101ddf <ideinit+0x6a>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101dcb:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dd0:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101dd1:	84 c0                	test   %al,%al
80101dd3:	74 eb                	je     80101dc0 <ideinit+0x4b>
      havedisk1 = 1;
80101dd5:	c7 05 60 95 10 80 01 	movl   $0x1,0x80109560
80101ddc:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ddf:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101de4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101de9:	ee                   	out    %al,(%dx)
}
80101dea:	c9                   	leave  
80101deb:	c3                   	ret    

80101dec <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101dec:	f3 0f 1e fb          	endbr32 
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101df5:	83 ec 0c             	sub    $0xc,%esp
80101df8:	68 80 95 10 80       	push   $0x80109580
80101dfd:	e8 b9 1e 00 00       	call   80103cbb <acquire>

  if((b = idequeue) == 0){
80101e02:	8b 1d 64 95 10 80    	mov    0x80109564,%ebx
80101e08:	83 c4 10             	add    $0x10,%esp
80101e0b:	85 db                	test   %ebx,%ebx
80101e0d:	74 48                	je     80101e57 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e0f:	8b 43 58             	mov    0x58(%ebx),%eax
80101e12:	a3 64 95 10 80       	mov    %eax,0x80109564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e17:	f6 03 04             	testb  $0x4,(%ebx)
80101e1a:	74 4d                	je     80101e69 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101e1c:	8b 03                	mov    (%ebx),%eax
80101e1e:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101e21:	83 e0 fb             	and    $0xfffffffb,%eax
80101e24:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	53                   	push   %ebx
80101e2a:	e8 c6 1a 00 00       	call   801038f5 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e2f:	a1 64 95 10 80       	mov    0x80109564,%eax
80101e34:	83 c4 10             	add    $0x10,%esp
80101e37:	85 c0                	test   %eax,%eax
80101e39:	74 05                	je     80101e40 <ideintr+0x54>
    idestart(idequeue);
80101e3b:	e8 70 fe ff ff       	call   80101cb0 <idestart>

  release(&idelock);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	68 80 95 10 80       	push   $0x80109580
80101e48:	e8 d7 1e 00 00       	call   80103d24 <release>
80101e4d:	83 c4 10             	add    $0x10,%esp
}
80101e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e53:	5b                   	pop    %ebx
80101e54:	5f                   	pop    %edi
80101e55:	5d                   	pop    %ebp
80101e56:	c3                   	ret    
    release(&idelock);
80101e57:	83 ec 0c             	sub    $0xc,%esp
80101e5a:	68 80 95 10 80       	push   $0x80109580
80101e5f:	e8 c0 1e 00 00       	call   80103d24 <release>
    return;
80101e64:	83 c4 10             	add    $0x10,%esp
80101e67:	eb e7                	jmp    80101e50 <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e69:	b8 01 00 00 00       	mov    $0x1,%eax
80101e6e:	e8 14 fe ff ff       	call   80101c87 <idewait>
80101e73:	85 c0                	test   %eax,%eax
80101e75:	78 a5                	js     80101e1c <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101e77:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e7a:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e7f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e84:	fc                   	cld    
80101e85:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101e87:	eb 93                	jmp    80101e1c <ideintr+0x30>

80101e89 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e89:	f3 0f 1e fb          	endbr32 
80101e8d:	55                   	push   %ebp
80101e8e:	89 e5                	mov    %esp,%ebp
80101e90:	53                   	push   %ebx
80101e91:	83 ec 10             	sub    $0x10,%esp
80101e94:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e97:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e9a:	50                   	push   %eax
80101e9b:	e8 79 1c 00 00       	call   80103b19 <holdingsleep>
80101ea0:	83 c4 10             	add    $0x10,%esp
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	74 37                	je     80101ede <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101ea7:	8b 03                	mov    (%ebx),%eax
80101ea9:	83 e0 06             	and    $0x6,%eax
80101eac:	83 f8 02             	cmp    $0x2,%eax
80101eaf:	74 3a                	je     80101eeb <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101eb1:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101eb5:	74 09                	je     80101ec0 <iderw+0x37>
80101eb7:	83 3d 60 95 10 80 00 	cmpl   $0x0,0x80109560
80101ebe:	74 38                	je     80101ef8 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	68 80 95 10 80       	push   $0x80109580
80101ec8:	e8 ee 1d 00 00       	call   80103cbb <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101ecd:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101ed4:	83 c4 10             	add    $0x10,%esp
80101ed7:	ba 64 95 10 80       	mov    $0x80109564,%edx
80101edc:	eb 2a                	jmp    80101f08 <iderw+0x7f>
    panic("iderw: buf not locked");
80101ede:	83 ec 0c             	sub    $0xc,%esp
80101ee1:	68 ca 67 10 80       	push   $0x801067ca
80101ee6:	e8 71 e4 ff ff       	call   8010035c <panic>
    panic("iderw: nothing to do");
80101eeb:	83 ec 0c             	sub    $0xc,%esp
80101eee:	68 e0 67 10 80       	push   $0x801067e0
80101ef3:	e8 64 e4 ff ff       	call   8010035c <panic>
    panic("iderw: ide disk 1 not present");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 f5 67 10 80       	push   $0x801067f5
80101f00:	e8 57 e4 ff ff       	call   8010035c <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f05:	8d 50 58             	lea    0x58(%eax),%edx
80101f08:	8b 02                	mov    (%edx),%eax
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	75 f7                	jne    80101f05 <iderw+0x7c>
    ;
  *pp = b;
80101f0e:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f10:	39 1d 64 95 10 80    	cmp    %ebx,0x80109564
80101f16:	75 1a                	jne    80101f32 <iderw+0xa9>
    idestart(b);
80101f18:	89 d8                	mov    %ebx,%eax
80101f1a:	e8 91 fd ff ff       	call   80101cb0 <idestart>
80101f1f:	eb 11                	jmp    80101f32 <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101f21:	83 ec 08             	sub    $0x8,%esp
80101f24:	68 80 95 10 80       	push   $0x80109580
80101f29:	53                   	push   %ebx
80101f2a:	e8 59 18 00 00       	call   80103788 <sleep>
80101f2f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f32:	8b 03                	mov    (%ebx),%eax
80101f34:	83 e0 06             	and    $0x6,%eax
80101f37:	83 f8 02             	cmp    $0x2,%eax
80101f3a:	75 e5                	jne    80101f21 <iderw+0x98>
  }


  release(&idelock);
80101f3c:	83 ec 0c             	sub    $0xc,%esp
80101f3f:	68 80 95 10 80       	push   $0x80109580
80101f44:	e8 db 1d 00 00       	call   80103d24 <release>
}
80101f49:	83 c4 10             	add    $0x10,%esp
80101f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f4f:	c9                   	leave  
80101f50:	c3                   	ret    

80101f51 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101f51:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80101f57:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f59:	a1 34 16 11 80       	mov    0x80111634,%eax
80101f5e:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f61:	c3                   	ret    

80101f62 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101f62:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101f68:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f6a:	a1 34 16 11 80       	mov    0x80111634,%eax
80101f6f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f72:	c3                   	ret    

80101f73 <ioapicinit>:

void
ioapicinit(void)
{
80101f73:	f3 0f 1e fb          	endbr32 
80101f77:	55                   	push   %ebp
80101f78:	89 e5                	mov    %esp,%ebp
80101f7a:	57                   	push   %edi
80101f7b:	56                   	push   %esi
80101f7c:	53                   	push   %ebx
80101f7d:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f80:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101f87:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f8a:	b8 01 00 00 00       	mov    $0x1,%eax
80101f8f:	e8 bd ff ff ff       	call   80101f51 <ioapicread>
80101f94:	c1 e8 10             	shr    $0x10,%eax
80101f97:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f9a:	b8 00 00 00 00       	mov    $0x0,%eax
80101f9f:	e8 ad ff ff ff       	call   80101f51 <ioapicread>
80101fa4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101fa7:	0f b6 15 60 17 11 80 	movzbl 0x80111760,%edx
80101fae:	39 c2                	cmp    %eax,%edx
80101fb0:	75 2f                	jne    80101fe1 <ioapicinit+0x6e>
{
80101fb2:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101fb7:	39 fb                	cmp    %edi,%ebx
80101fb9:	7f 38                	jg     80101ff3 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101fbb:	8d 53 20             	lea    0x20(%ebx),%edx
80101fbe:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101fc4:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101fc8:	89 f0                	mov    %esi,%eax
80101fca:	e8 93 ff ff ff       	call   80101f62 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101fcf:	8d 46 01             	lea    0x1(%esi),%eax
80101fd2:	ba 00 00 00 00       	mov    $0x0,%edx
80101fd7:	e8 86 ff ff ff       	call   80101f62 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101fdc:	83 c3 01             	add    $0x1,%ebx
80101fdf:	eb d6                	jmp    80101fb7 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101fe1:	83 ec 0c             	sub    $0xc,%esp
80101fe4:	68 14 68 10 80       	push   $0x80106814
80101fe9:	e8 3b e6 ff ff       	call   80100629 <cprintf>
80101fee:	83 c4 10             	add    $0x10,%esp
80101ff1:	eb bf                	jmp    80101fb2 <ioapicinit+0x3f>
  }
}
80101ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff6:	5b                   	pop    %ebx
80101ff7:	5e                   	pop    %esi
80101ff8:	5f                   	pop    %edi
80101ff9:	5d                   	pop    %ebp
80101ffa:	c3                   	ret    

80101ffb <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101ffb:	f3 0f 1e fb          	endbr32 
80101fff:	55                   	push   %ebp
80102000:	89 e5                	mov    %esp,%ebp
80102002:	53                   	push   %ebx
80102003:	83 ec 04             	sub    $0x4,%esp
80102006:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102009:	8d 50 20             	lea    0x20(%eax),%edx
8010200c:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80102010:	89 d8                	mov    %ebx,%eax
80102012:	e8 4b ff ff ff       	call   80101f62 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102017:	8b 55 0c             	mov    0xc(%ebp),%edx
8010201a:	c1 e2 18             	shl    $0x18,%edx
8010201d:	8d 43 01             	lea    0x1(%ebx),%eax
80102020:	e8 3d ff ff ff       	call   80101f62 <ioapicwrite>
}
80102025:	83 c4 04             	add    $0x4,%esp
80102028:	5b                   	pop    %ebx
80102029:	5d                   	pop    %ebp
8010202a:	c3                   	ret    

8010202b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
8010202b:	f3 0f 1e fb          	endbr32 
8010202f:	55                   	push   %ebp
80102030:	89 e5                	mov    %esp,%ebp
80102032:	53                   	push   %ebx
80102033:	83 ec 04             	sub    $0x4,%esp
80102036:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102039:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010203f:	75 4c                	jne    8010208d <kfree+0x62>
80102041:	81 fb a8 44 11 80    	cmp    $0x801144a8,%ebx
80102047:	72 44                	jb     8010208d <kfree+0x62>
80102049:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010204f:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102054:	77 37                	ja     8010208d <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102056:	83 ec 04             	sub    $0x4,%esp
80102059:	68 00 10 00 00       	push   $0x1000
8010205e:	6a 01                	push   $0x1
80102060:	53                   	push   %ebx
80102061:	e8 09 1d 00 00       	call   80103d6f <memset>

  if(kmem.use_lock)
80102066:	83 c4 10             	add    $0x10,%esp
80102069:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102070:	75 28                	jne    8010209a <kfree+0x6f>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102072:	a1 78 16 11 80       	mov    0x80111678,%eax
80102077:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102079:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
8010207f:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102086:	75 24                	jne    801020ac <kfree+0x81>
    release(&kmem.lock);
}
80102088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010208b:	c9                   	leave  
8010208c:	c3                   	ret    
    panic("kfree");
8010208d:	83 ec 0c             	sub    $0xc,%esp
80102090:	68 46 68 10 80       	push   $0x80106846
80102095:	e8 c2 e2 ff ff       	call   8010035c <panic>
    acquire(&kmem.lock);
8010209a:	83 ec 0c             	sub    $0xc,%esp
8010209d:	68 40 16 11 80       	push   $0x80111640
801020a2:	e8 14 1c 00 00       	call   80103cbb <acquire>
801020a7:	83 c4 10             	add    $0x10,%esp
801020aa:	eb c6                	jmp    80102072 <kfree+0x47>
    release(&kmem.lock);
801020ac:	83 ec 0c             	sub    $0xc,%esp
801020af:	68 40 16 11 80       	push   $0x80111640
801020b4:	e8 6b 1c 00 00       	call   80103d24 <release>
801020b9:	83 c4 10             	add    $0x10,%esp
}
801020bc:	eb ca                	jmp    80102088 <kfree+0x5d>

801020be <freerange>:
{
801020be:	f3 0f 1e fb          	endbr32 
801020c2:	55                   	push   %ebp
801020c3:	89 e5                	mov    %esp,%ebp
801020c5:	56                   	push   %esi
801020c6:	53                   	push   %ebx
801020c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
801020ca:	8b 45 08             	mov    0x8(%ebp),%eax
801020cd:	05 ff 0f 00 00       	add    $0xfff,%eax
801020d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020d7:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
801020dd:	39 de                	cmp    %ebx,%esi
801020df:	77 10                	ja     801020f1 <freerange+0x33>
    kfree(p);
801020e1:	83 ec 0c             	sub    $0xc,%esp
801020e4:	50                   	push   %eax
801020e5:	e8 41 ff ff ff       	call   8010202b <kfree>
801020ea:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020ed:	89 f0                	mov    %esi,%eax
801020ef:	eb e6                	jmp    801020d7 <freerange+0x19>
}
801020f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020f4:	5b                   	pop    %ebx
801020f5:	5e                   	pop    %esi
801020f6:	5d                   	pop    %ebp
801020f7:	c3                   	ret    

801020f8 <kinit1>:
{
801020f8:	f3 0f 1e fb          	endbr32 
801020fc:	55                   	push   %ebp
801020fd:	89 e5                	mov    %esp,%ebp
801020ff:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102102:	68 4c 68 10 80       	push   $0x8010684c
80102107:	68 40 16 11 80       	push   $0x80111640
8010210c:	e8 5a 1a 00 00       	call   80103b6b <initlock>
  kmem.use_lock = 0;
80102111:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102118:	00 00 00 
  freerange(vstart, vend);
8010211b:	83 c4 08             	add    $0x8,%esp
8010211e:	ff 75 0c             	pushl  0xc(%ebp)
80102121:	ff 75 08             	pushl  0x8(%ebp)
80102124:	e8 95 ff ff ff       	call   801020be <freerange>
}
80102129:	83 c4 10             	add    $0x10,%esp
8010212c:	c9                   	leave  
8010212d:	c3                   	ret    

8010212e <kinit2>:
{
8010212e:	f3 0f 1e fb          	endbr32 
80102132:	55                   	push   %ebp
80102133:	89 e5                	mov    %esp,%ebp
80102135:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102138:	ff 75 0c             	pushl  0xc(%ebp)
8010213b:	ff 75 08             	pushl  0x8(%ebp)
8010213e:	e8 7b ff ff ff       	call   801020be <freerange>
  kmem.use_lock = 1;
80102143:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010214a:	00 00 00 
}
8010214d:	83 c4 10             	add    $0x10,%esp
80102150:	c9                   	leave  
80102151:	c3                   	ret    

80102152 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102152:	f3 0f 1e fb          	endbr32 
80102156:	55                   	push   %ebp
80102157:	89 e5                	mov    %esp,%ebp
80102159:	53                   	push   %ebx
8010215a:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
8010215d:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102164:	75 21                	jne    80102187 <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102166:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
8010216c:	85 db                	test   %ebx,%ebx
8010216e:	74 07                	je     80102177 <kalloc+0x25>
    kmem.freelist = r->next;
80102170:	8b 03                	mov    (%ebx),%eax
80102172:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
80102177:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
8010217e:	75 19                	jne    80102199 <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
80102180:	89 d8                	mov    %ebx,%eax
80102182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102185:	c9                   	leave  
80102186:	c3                   	ret    
    acquire(&kmem.lock);
80102187:	83 ec 0c             	sub    $0xc,%esp
8010218a:	68 40 16 11 80       	push   $0x80111640
8010218f:	e8 27 1b 00 00       	call   80103cbb <acquire>
80102194:	83 c4 10             	add    $0x10,%esp
80102197:	eb cd                	jmp    80102166 <kalloc+0x14>
    release(&kmem.lock);
80102199:	83 ec 0c             	sub    $0xc,%esp
8010219c:	68 40 16 11 80       	push   $0x80111640
801021a1:	e8 7e 1b 00 00       	call   80103d24 <release>
801021a6:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021a9:	eb d5                	jmp    80102180 <kalloc+0x2e>

801021ab <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801021ab:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021af:	ba 64 00 00 00       	mov    $0x64,%edx
801021b4:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021b5:	a8 01                	test   $0x1,%al
801021b7:	0f 84 ad 00 00 00    	je     8010226a <kbdgetc+0xbf>
801021bd:	ba 60 00 00 00       	mov    $0x60,%edx
801021c2:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801021c3:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801021c6:	3c e0                	cmp    $0xe0,%al
801021c8:	74 5b                	je     80102225 <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801021ca:	84 c0                	test   %al,%al
801021cc:	78 64                	js     80102232 <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801021ce:	8b 0d b4 95 10 80    	mov    0x801095b4,%ecx
801021d4:	f6 c1 40             	test   $0x40,%cl
801021d7:	74 0f                	je     801021e8 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801021d9:	83 c8 80             	or     $0xffffff80,%eax
801021dc:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
801021df:	83 e1 bf             	and    $0xffffffbf,%ecx
801021e2:	89 0d b4 95 10 80    	mov    %ecx,0x801095b4
  }

  shift |= shiftcode[data];
801021e8:	0f b6 8a 80 69 10 80 	movzbl -0x7fef9680(%edx),%ecx
801021ef:	0b 0d b4 95 10 80    	or     0x801095b4,%ecx
  shift ^= togglecode[data];
801021f5:	0f b6 82 80 68 10 80 	movzbl -0x7fef9780(%edx),%eax
801021fc:	31 c1                	xor    %eax,%ecx
801021fe:	89 0d b4 95 10 80    	mov    %ecx,0x801095b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102204:	89 c8                	mov    %ecx,%eax
80102206:	83 e0 03             	and    $0x3,%eax
80102209:	8b 04 85 60 68 10 80 	mov    -0x7fef97a0(,%eax,4),%eax
80102210:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102214:	f6 c1 08             	test   $0x8,%cl
80102217:	74 56                	je     8010226f <kbdgetc+0xc4>
    if('a' <= c && c <= 'z')
80102219:	8d 50 9f             	lea    -0x61(%eax),%edx
8010221c:	83 fa 19             	cmp    $0x19,%edx
8010221f:	77 3d                	ja     8010225e <kbdgetc+0xb3>
      c += 'A' - 'a';
80102221:	83 e8 20             	sub    $0x20,%eax
80102224:	c3                   	ret    
    shift |= E0ESC;
80102225:	83 0d b4 95 10 80 40 	orl    $0x40,0x801095b4
    return 0;
8010222c:	b8 00 00 00 00       	mov    $0x0,%eax
80102231:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102232:	8b 0d b4 95 10 80    	mov    0x801095b4,%ecx
80102238:	f6 c1 40             	test   $0x40,%cl
8010223b:	75 05                	jne    80102242 <kbdgetc+0x97>
8010223d:	89 c2                	mov    %eax,%edx
8010223f:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102242:	0f b6 82 80 69 10 80 	movzbl -0x7fef9680(%edx),%eax
80102249:	83 c8 40             	or     $0x40,%eax
8010224c:	0f b6 c0             	movzbl %al,%eax
8010224f:	f7 d0                	not    %eax
80102251:	21 c8                	and    %ecx,%eax
80102253:	a3 b4 95 10 80       	mov    %eax,0x801095b4
    return 0;
80102258:	b8 00 00 00 00       	mov    $0x0,%eax
8010225d:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
8010225e:	8d 50 bf             	lea    -0x41(%eax),%edx
80102261:	83 fa 19             	cmp    $0x19,%edx
80102264:	77 09                	ja     8010226f <kbdgetc+0xc4>
      c += 'a' - 'A';
80102266:	83 c0 20             	add    $0x20,%eax
  }
  return c;
80102269:	c3                   	ret    
    return -1;
8010226a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010226f:	c3                   	ret    

80102270 <kbdintr>:

void
kbdintr(void)
{
80102270:	f3 0f 1e fb          	endbr32 
80102274:	55                   	push   %ebp
80102275:	89 e5                	mov    %esp,%ebp
80102277:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010227a:	68 ab 21 10 80       	push   $0x801021ab
8010227f:	e8 d5 e4 ff ff       	call   80100759 <consoleintr>
}
80102284:	83 c4 10             	add    $0x10,%esp
80102287:	c9                   	leave  
80102288:	c3                   	ret    

80102289 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102289:	8b 0d 7c 16 11 80    	mov    0x8011167c,%ecx
8010228f:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102292:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102294:	a1 7c 16 11 80       	mov    0x8011167c,%eax
80102299:	8b 40 20             	mov    0x20(%eax),%eax
}
8010229c:	c3                   	ret    

8010229d <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010229d:	ba 70 00 00 00       	mov    $0x70,%edx
801022a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022a3:	ba 71 00 00 00       	mov    $0x71,%edx
801022a8:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801022a9:	0f b6 c0             	movzbl %al,%eax
}
801022ac:	c3                   	ret    

801022ad <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801022ad:	55                   	push   %ebp
801022ae:	89 e5                	mov    %esp,%ebp
801022b0:	53                   	push   %ebx
801022b1:	83 ec 04             	sub    $0x4,%esp
801022b4:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
801022b6:	b8 00 00 00 00       	mov    $0x0,%eax
801022bb:	e8 dd ff ff ff       	call   8010229d <cmos_read>
801022c0:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
801022c2:	b8 02 00 00 00       	mov    $0x2,%eax
801022c7:	e8 d1 ff ff ff       	call   8010229d <cmos_read>
801022cc:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
801022cf:	b8 04 00 00 00       	mov    $0x4,%eax
801022d4:	e8 c4 ff ff ff       	call   8010229d <cmos_read>
801022d9:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
801022dc:	b8 07 00 00 00       	mov    $0x7,%eax
801022e1:	e8 b7 ff ff ff       	call   8010229d <cmos_read>
801022e6:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
801022e9:	b8 08 00 00 00       	mov    $0x8,%eax
801022ee:	e8 aa ff ff ff       	call   8010229d <cmos_read>
801022f3:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
801022f6:	b8 09 00 00 00       	mov    $0x9,%eax
801022fb:	e8 9d ff ff ff       	call   8010229d <cmos_read>
80102300:	89 43 14             	mov    %eax,0x14(%ebx)
}
80102303:	83 c4 04             	add    $0x4,%esp
80102306:	5b                   	pop    %ebx
80102307:	5d                   	pop    %ebp
80102308:	c3                   	ret    

80102309 <lapicinit>:
{
80102309:	f3 0f 1e fb          	endbr32 
  if(!lapic)
8010230d:	83 3d 7c 16 11 80 00 	cmpl   $0x0,0x8011167c
80102314:	0f 84 fe 00 00 00    	je     80102418 <lapicinit+0x10f>
{
8010231a:	55                   	push   %ebp
8010231b:	89 e5                	mov    %esp,%ebp
8010231d:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102320:	ba 3f 01 00 00       	mov    $0x13f,%edx
80102325:	b8 3c 00 00 00       	mov    $0x3c,%eax
8010232a:	e8 5a ff ff ff       	call   80102289 <lapicw>
  lapicw(TDCR, X1);
8010232f:	ba 0b 00 00 00       	mov    $0xb,%edx
80102334:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102339:	e8 4b ff ff ff       	call   80102289 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010233e:	ba 20 00 02 00       	mov    $0x20020,%edx
80102343:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102348:	e8 3c ff ff ff       	call   80102289 <lapicw>
  lapicw(TICR, 10000000);
8010234d:	ba 80 96 98 00       	mov    $0x989680,%edx
80102352:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102357:	e8 2d ff ff ff       	call   80102289 <lapicw>
  lapicw(LINT0, MASKED);
8010235c:	ba 00 00 01 00       	mov    $0x10000,%edx
80102361:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102366:	e8 1e ff ff ff       	call   80102289 <lapicw>
  lapicw(LINT1, MASKED);
8010236b:	ba 00 00 01 00       	mov    $0x10000,%edx
80102370:	b8 d8 00 00 00       	mov    $0xd8,%eax
80102375:	e8 0f ff ff ff       	call   80102289 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010237a:	a1 7c 16 11 80       	mov    0x8011167c,%eax
8010237f:	8b 40 30             	mov    0x30(%eax),%eax
80102382:	c1 e8 10             	shr    $0x10,%eax
80102385:	a8 fc                	test   $0xfc,%al
80102387:	75 7b                	jne    80102404 <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102389:	ba 33 00 00 00       	mov    $0x33,%edx
8010238e:	b8 dc 00 00 00       	mov    $0xdc,%eax
80102393:	e8 f1 fe ff ff       	call   80102289 <lapicw>
  lapicw(ESR, 0);
80102398:	ba 00 00 00 00       	mov    $0x0,%edx
8010239d:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023a2:	e8 e2 fe ff ff       	call   80102289 <lapicw>
  lapicw(ESR, 0);
801023a7:	ba 00 00 00 00       	mov    $0x0,%edx
801023ac:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023b1:	e8 d3 fe ff ff       	call   80102289 <lapicw>
  lapicw(EOI, 0);
801023b6:	ba 00 00 00 00       	mov    $0x0,%edx
801023bb:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023c0:	e8 c4 fe ff ff       	call   80102289 <lapicw>
  lapicw(ICRHI, 0);
801023c5:	ba 00 00 00 00       	mov    $0x0,%edx
801023ca:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023cf:	e8 b5 fe ff ff       	call   80102289 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801023d4:	ba 00 85 08 00       	mov    $0x88500,%edx
801023d9:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023de:	e8 a6 fe ff ff       	call   80102289 <lapicw>
  while(lapic[ICRLO] & DELIVS)
801023e3:	a1 7c 16 11 80       	mov    0x8011167c,%eax
801023e8:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
801023ee:	f6 c4 10             	test   $0x10,%ah
801023f1:	75 f0                	jne    801023e3 <lapicinit+0xda>
  lapicw(TPR, 0);
801023f3:	ba 00 00 00 00       	mov    $0x0,%edx
801023f8:	b8 20 00 00 00       	mov    $0x20,%eax
801023fd:	e8 87 fe ff ff       	call   80102289 <lapicw>
}
80102402:	c9                   	leave  
80102403:	c3                   	ret    
    lapicw(PCINT, MASKED);
80102404:	ba 00 00 01 00       	mov    $0x10000,%edx
80102409:	b8 d0 00 00 00       	mov    $0xd0,%eax
8010240e:	e8 76 fe ff ff       	call   80102289 <lapicw>
80102413:	e9 71 ff ff ff       	jmp    80102389 <lapicinit+0x80>
80102418:	c3                   	ret    

80102419 <lapicid>:
{
80102419:	f3 0f 1e fb          	endbr32 
  if (!lapic)
8010241d:	a1 7c 16 11 80       	mov    0x8011167c,%eax
80102422:	85 c0                	test   %eax,%eax
80102424:	74 07                	je     8010242d <lapicid+0x14>
  return lapic[ID] >> 24;
80102426:	8b 40 20             	mov    0x20(%eax),%eax
80102429:	c1 e8 18             	shr    $0x18,%eax
8010242c:	c3                   	ret    
    return 0;
8010242d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102432:	c3                   	ret    

80102433 <lapiceoi>:
{
80102433:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102437:	83 3d 7c 16 11 80 00 	cmpl   $0x0,0x8011167c
8010243e:	74 17                	je     80102457 <lapiceoi+0x24>
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102446:	ba 00 00 00 00       	mov    $0x0,%edx
8010244b:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102450:	e8 34 fe ff ff       	call   80102289 <lapicw>
}
80102455:	c9                   	leave  
80102456:	c3                   	ret    
80102457:	c3                   	ret    

80102458 <microdelay>:
{
80102458:	f3 0f 1e fb          	endbr32 
}
8010245c:	c3                   	ret    

8010245d <lapicstartap>:
{
8010245d:	f3 0f 1e fb          	endbr32 
80102461:	55                   	push   %ebp
80102462:	89 e5                	mov    %esp,%ebp
80102464:	57                   	push   %edi
80102465:	56                   	push   %esi
80102466:	53                   	push   %ebx
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	8b 75 08             	mov    0x8(%ebp),%esi
8010246d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102470:	b8 0f 00 00 00       	mov    $0xf,%eax
80102475:	ba 70 00 00 00       	mov    $0x70,%edx
8010247a:	ee                   	out    %al,(%dx)
8010247b:	b8 0a 00 00 00       	mov    $0xa,%eax
80102480:	ba 71 00 00 00       	mov    $0x71,%edx
80102485:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102486:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
8010248d:	00 00 
  wrv[1] = addr >> 4;
8010248f:	89 f8                	mov    %edi,%eax
80102491:	c1 e8 04             	shr    $0x4,%eax
80102494:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010249a:	c1 e6 18             	shl    $0x18,%esi
8010249d:	89 f2                	mov    %esi,%edx
8010249f:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024a4:	e8 e0 fd ff ff       	call   80102289 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024a9:	ba 00 c5 00 00       	mov    $0xc500,%edx
801024ae:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024b3:	e8 d1 fd ff ff       	call   80102289 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801024b8:	ba 00 85 00 00       	mov    $0x8500,%edx
801024bd:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024c2:	e8 c2 fd ff ff       	call   80102289 <lapicw>
  for(i = 0; i < 2; i++){
801024c7:	bb 00 00 00 00       	mov    $0x0,%ebx
801024cc:	eb 21                	jmp    801024ef <lapicstartap+0x92>
    lapicw(ICRHI, apicid<<24);
801024ce:	89 f2                	mov    %esi,%edx
801024d0:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024d5:	e8 af fd ff ff       	call   80102289 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024da:	89 fa                	mov    %edi,%edx
801024dc:	c1 ea 0c             	shr    $0xc,%edx
801024df:	80 ce 06             	or     $0x6,%dh
801024e2:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024e7:	e8 9d fd ff ff       	call   80102289 <lapicw>
  for(i = 0; i < 2; i++){
801024ec:	83 c3 01             	add    $0x1,%ebx
801024ef:	83 fb 01             	cmp    $0x1,%ebx
801024f2:	7e da                	jle    801024ce <lapicstartap+0x71>
}
801024f4:	83 c4 0c             	add    $0xc,%esp
801024f7:	5b                   	pop    %ebx
801024f8:	5e                   	pop    %esi
801024f9:	5f                   	pop    %edi
801024fa:	5d                   	pop    %ebp
801024fb:	c3                   	ret    

801024fc <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801024fc:	f3 0f 1e fb          	endbr32 
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	57                   	push   %edi
80102504:	56                   	push   %esi
80102505:	53                   	push   %ebx
80102506:	83 ec 3c             	sub    $0x3c,%esp
80102509:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010250c:	b8 0b 00 00 00       	mov    $0xb,%eax
80102511:	e8 87 fd ff ff       	call   8010229d <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
80102516:	83 e0 04             	and    $0x4,%eax
80102519:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010251b:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010251e:	e8 8a fd ff ff       	call   801022ad <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102523:	b8 0a 00 00 00       	mov    $0xa,%eax
80102528:	e8 70 fd ff ff       	call   8010229d <cmos_read>
8010252d:	a8 80                	test   $0x80,%al
8010252f:	75 ea                	jne    8010251b <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
80102531:	8d 5d b8             	lea    -0x48(%ebp),%ebx
80102534:	89 d8                	mov    %ebx,%eax
80102536:	e8 72 fd ff ff       	call   801022ad <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010253b:	83 ec 04             	sub    $0x4,%esp
8010253e:	6a 18                	push   $0x18
80102540:	53                   	push   %ebx
80102541:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102544:	50                   	push   %eax
80102545:	e8 6c 18 00 00       	call   80103db6 <memcmp>
8010254a:	83 c4 10             	add    $0x10,%esp
8010254d:	85 c0                	test   %eax,%eax
8010254f:	75 ca                	jne    8010251b <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
80102551:	85 ff                	test   %edi,%edi
80102553:	75 78                	jne    801025cd <cmostime+0xd1>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102555:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102558:	89 c2                	mov    %eax,%edx
8010255a:	c1 ea 04             	shr    $0x4,%edx
8010255d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102560:	83 e0 0f             	and    $0xf,%eax
80102563:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102566:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102569:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010256c:	89 c2                	mov    %eax,%edx
8010256e:	c1 ea 04             	shr    $0x4,%edx
80102571:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102574:	83 e0 0f             	and    $0xf,%eax
80102577:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010257a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
8010257d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102580:	89 c2                	mov    %eax,%edx
80102582:	c1 ea 04             	shr    $0x4,%edx
80102585:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102588:	83 e0 0f             	and    $0xf,%eax
8010258b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010258e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102591:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102594:	89 c2                	mov    %eax,%edx
80102596:	c1 ea 04             	shr    $0x4,%edx
80102599:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010259c:	83 e0 0f             	and    $0xf,%eax
8010259f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025a8:	89 c2                	mov    %eax,%edx
801025aa:	c1 ea 04             	shr    $0x4,%edx
801025ad:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025b0:	83 e0 0f             	and    $0xf,%eax
801025b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025bc:	89 c2                	mov    %eax,%edx
801025be:	c1 ea 04             	shr    $0x4,%edx
801025c1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c4:	83 e0 0f             	and    $0xf,%eax
801025c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801025cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025d0:	89 06                	mov    %eax,(%esi)
801025d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801025d5:	89 46 04             	mov    %eax,0x4(%esi)
801025d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025db:	89 46 08             	mov    %eax,0x8(%esi)
801025de:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025e1:	89 46 0c             	mov    %eax,0xc(%esi)
801025e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025e7:	89 46 10             	mov    %eax,0x10(%esi)
801025ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025ed:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801025f0:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801025f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025fa:	5b                   	pop    %ebx
801025fb:	5e                   	pop    %esi
801025fc:	5f                   	pop    %edi
801025fd:	5d                   	pop    %ebp
801025fe:	c3                   	ret    

801025ff <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801025ff:	55                   	push   %ebp
80102600:	89 e5                	mov    %esp,%ebp
80102602:	53                   	push   %ebx
80102603:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102606:	ff 35 b4 16 11 80    	pushl  0x801116b4
8010260c:	ff 35 c4 16 11 80    	pushl  0x801116c4
80102612:	e8 59 db ff ff       	call   80100170 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102617:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010261a:	89 1d c8 16 11 80    	mov    %ebx,0x801116c8
  for (i = 0; i < log.lh.n; i++) {
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	ba 00 00 00 00       	mov    $0x0,%edx
80102628:	39 d3                	cmp    %edx,%ebx
8010262a:	7e 10                	jle    8010263c <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
8010262c:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102630:	89 0c 95 cc 16 11 80 	mov    %ecx,-0x7feee934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102637:	83 c2 01             	add    $0x1,%edx
8010263a:	eb ec                	jmp    80102628 <read_head+0x29>
  }
  brelse(buf);
8010263c:	83 ec 0c             	sub    $0xc,%esp
8010263f:	50                   	push   %eax
80102640:	e8 9c db ff ff       	call   801001e1 <brelse>
}
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010264b:	c9                   	leave  
8010264c:	c3                   	ret    

8010264d <install_trans>:
{
8010264d:	55                   	push   %ebp
8010264e:	89 e5                	mov    %esp,%ebp
80102650:	57                   	push   %edi
80102651:	56                   	push   %esi
80102652:	53                   	push   %ebx
80102653:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102656:	be 00 00 00 00       	mov    $0x0,%esi
8010265b:	39 35 c8 16 11 80    	cmp    %esi,0x801116c8
80102661:	7e 68                	jle    801026cb <install_trans+0x7e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102663:	89 f0                	mov    %esi,%eax
80102665:	03 05 b4 16 11 80    	add    0x801116b4,%eax
8010266b:	83 c0 01             	add    $0x1,%eax
8010266e:	83 ec 08             	sub    $0x8,%esp
80102671:	50                   	push   %eax
80102672:	ff 35 c4 16 11 80    	pushl  0x801116c4
80102678:	e8 f3 da ff ff       	call   80100170 <bread>
8010267d:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010267f:	83 c4 08             	add    $0x8,%esp
80102682:	ff 34 b5 cc 16 11 80 	pushl  -0x7feee934(,%esi,4)
80102689:	ff 35 c4 16 11 80    	pushl  0x801116c4
8010268f:	e8 dc da ff ff       	call   80100170 <bread>
80102694:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102696:	8d 57 5c             	lea    0x5c(%edi),%edx
80102699:	8d 40 5c             	lea    0x5c(%eax),%eax
8010269c:	83 c4 0c             	add    $0xc,%esp
8010269f:	68 00 02 00 00       	push   $0x200
801026a4:	52                   	push   %edx
801026a5:	50                   	push   %eax
801026a6:	e8 44 17 00 00       	call   80103def <memmove>
    bwrite(dbuf);  // write dst to disk
801026ab:	89 1c 24             	mov    %ebx,(%esp)
801026ae:	e8 ef da ff ff       	call   801001a2 <bwrite>
    brelse(lbuf);
801026b3:	89 3c 24             	mov    %edi,(%esp)
801026b6:	e8 26 db ff ff       	call   801001e1 <brelse>
    brelse(dbuf);
801026bb:	89 1c 24             	mov    %ebx,(%esp)
801026be:	e8 1e db ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026c3:	83 c6 01             	add    $0x1,%esi
801026c6:	83 c4 10             	add    $0x10,%esp
801026c9:	eb 90                	jmp    8010265b <install_trans+0xe>
}
801026cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026ce:	5b                   	pop    %ebx
801026cf:	5e                   	pop    %esi
801026d0:	5f                   	pop    %edi
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret    

801026d3 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801026d3:	55                   	push   %ebp
801026d4:	89 e5                	mov    %esp,%ebp
801026d6:	53                   	push   %ebx
801026d7:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801026da:	ff 35 b4 16 11 80    	pushl  0x801116b4
801026e0:	ff 35 c4 16 11 80    	pushl  0x801116c4
801026e6:	e8 85 da ff ff       	call   80100170 <bread>
801026eb:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801026ed:	8b 0d c8 16 11 80    	mov    0x801116c8,%ecx
801026f3:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801026f6:	83 c4 10             	add    $0x10,%esp
801026f9:	b8 00 00 00 00       	mov    $0x0,%eax
801026fe:	39 c1                	cmp    %eax,%ecx
80102700:	7e 10                	jle    80102712 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
80102702:	8b 14 85 cc 16 11 80 	mov    -0x7feee934(,%eax,4),%edx
80102709:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
8010270d:	83 c0 01             	add    $0x1,%eax
80102710:	eb ec                	jmp    801026fe <write_head+0x2b>
  }
  bwrite(buf);
80102712:	83 ec 0c             	sub    $0xc,%esp
80102715:	53                   	push   %ebx
80102716:	e8 87 da ff ff       	call   801001a2 <bwrite>
  brelse(buf);
8010271b:	89 1c 24             	mov    %ebx,(%esp)
8010271e:	e8 be da ff ff       	call   801001e1 <brelse>
}
80102723:	83 c4 10             	add    $0x10,%esp
80102726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102729:	c9                   	leave  
8010272a:	c3                   	ret    

8010272b <recover_from_log>:

static void
recover_from_log(void)
{
8010272b:	55                   	push   %ebp
8010272c:	89 e5                	mov    %esp,%ebp
8010272e:	83 ec 08             	sub    $0x8,%esp
  read_head();
80102731:	e8 c9 fe ff ff       	call   801025ff <read_head>
  install_trans(); // if committed, copy from log to disk
80102736:	e8 12 ff ff ff       	call   8010264d <install_trans>
  log.lh.n = 0;
8010273b:	c7 05 c8 16 11 80 00 	movl   $0x0,0x801116c8
80102742:	00 00 00 
  write_head(); // clear the log
80102745:	e8 89 ff ff ff       	call   801026d3 <write_head>
}
8010274a:	c9                   	leave  
8010274b:	c3                   	ret    

8010274c <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010274c:	55                   	push   %ebp
8010274d:	89 e5                	mov    %esp,%ebp
8010274f:	57                   	push   %edi
80102750:	56                   	push   %esi
80102751:	53                   	push   %ebx
80102752:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102755:	be 00 00 00 00       	mov    $0x0,%esi
8010275a:	39 35 c8 16 11 80    	cmp    %esi,0x801116c8
80102760:	7e 68                	jle    801027ca <write_log+0x7e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102762:	89 f0                	mov    %esi,%eax
80102764:	03 05 b4 16 11 80    	add    0x801116b4,%eax
8010276a:	83 c0 01             	add    $0x1,%eax
8010276d:	83 ec 08             	sub    $0x8,%esp
80102770:	50                   	push   %eax
80102771:	ff 35 c4 16 11 80    	pushl  0x801116c4
80102777:	e8 f4 d9 ff ff       	call   80100170 <bread>
8010277c:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010277e:	83 c4 08             	add    $0x8,%esp
80102781:	ff 34 b5 cc 16 11 80 	pushl  -0x7feee934(,%esi,4)
80102788:	ff 35 c4 16 11 80    	pushl  0x801116c4
8010278e:	e8 dd d9 ff ff       	call   80100170 <bread>
80102793:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102795:	8d 50 5c             	lea    0x5c(%eax),%edx
80102798:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010279b:	83 c4 0c             	add    $0xc,%esp
8010279e:	68 00 02 00 00       	push   $0x200
801027a3:	52                   	push   %edx
801027a4:	50                   	push   %eax
801027a5:	e8 45 16 00 00       	call   80103def <memmove>
    bwrite(to);  // write the log
801027aa:	89 1c 24             	mov    %ebx,(%esp)
801027ad:	e8 f0 d9 ff ff       	call   801001a2 <bwrite>
    brelse(from);
801027b2:	89 3c 24             	mov    %edi,(%esp)
801027b5:	e8 27 da ff ff       	call   801001e1 <brelse>
    brelse(to);
801027ba:	89 1c 24             	mov    %ebx,(%esp)
801027bd:	e8 1f da ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801027c2:	83 c6 01             	add    $0x1,%esi
801027c5:	83 c4 10             	add    $0x10,%esp
801027c8:	eb 90                	jmp    8010275a <write_log+0xe>
  }
}
801027ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027cd:	5b                   	pop    %ebx
801027ce:	5e                   	pop    %esi
801027cf:	5f                   	pop    %edi
801027d0:	5d                   	pop    %ebp
801027d1:	c3                   	ret    

801027d2 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
801027d2:	83 3d c8 16 11 80 00 	cmpl   $0x0,0x801116c8
801027d9:	7f 01                	jg     801027dc <commit+0xa>
801027db:	c3                   	ret    
{
801027dc:	55                   	push   %ebp
801027dd:	89 e5                	mov    %esp,%ebp
801027df:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
801027e2:	e8 65 ff ff ff       	call   8010274c <write_log>
    write_head();    // Write header to disk -- the real commit
801027e7:	e8 e7 fe ff ff       	call   801026d3 <write_head>
    install_trans(); // Now install writes to home locations
801027ec:	e8 5c fe ff ff       	call   8010264d <install_trans>
    log.lh.n = 0;
801027f1:	c7 05 c8 16 11 80 00 	movl   $0x0,0x801116c8
801027f8:	00 00 00 
    write_head();    // Erase the transaction from the log
801027fb:	e8 d3 fe ff ff       	call   801026d3 <write_head>
  }
}
80102800:	c9                   	leave  
80102801:	c3                   	ret    

80102802 <initlog>:
{
80102802:	f3 0f 1e fb          	endbr32 
80102806:	55                   	push   %ebp
80102807:	89 e5                	mov    %esp,%ebp
80102809:	53                   	push   %ebx
8010280a:	83 ec 2c             	sub    $0x2c,%esp
8010280d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102810:	68 80 6a 10 80       	push   $0x80106a80
80102815:	68 80 16 11 80       	push   $0x80111680
8010281a:	e8 4c 13 00 00       	call   80103b6b <initlock>
  readsb(dev, &sb);
8010281f:	83 c4 08             	add    $0x8,%esp
80102822:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102825:	50                   	push   %eax
80102826:	53                   	push   %ebx
80102827:	e8 c1 ea ff ff       	call   801012ed <readsb>
  log.start = sb.logstart;
8010282c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010282f:	a3 b4 16 11 80       	mov    %eax,0x801116b4
  log.size = sb.nlog;
80102834:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102837:	a3 b8 16 11 80       	mov    %eax,0x801116b8
  log.dev = dev;
8010283c:	89 1d c4 16 11 80    	mov    %ebx,0x801116c4
  recover_from_log();
80102842:	e8 e4 fe ff ff       	call   8010272b <recover_from_log>
}
80102847:	83 c4 10             	add    $0x10,%esp
8010284a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284d:	c9                   	leave  
8010284e:	c3                   	ret    

8010284f <begin_op>:
{
8010284f:	f3 0f 1e fb          	endbr32 
80102853:	55                   	push   %ebp
80102854:	89 e5                	mov    %esp,%ebp
80102856:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102859:	68 80 16 11 80       	push   $0x80111680
8010285e:	e8 58 14 00 00       	call   80103cbb <acquire>
80102863:	83 c4 10             	add    $0x10,%esp
80102866:	eb 15                	jmp    8010287d <begin_op+0x2e>
      sleep(&log, &log.lock);
80102868:	83 ec 08             	sub    $0x8,%esp
8010286b:	68 80 16 11 80       	push   $0x80111680
80102870:	68 80 16 11 80       	push   $0x80111680
80102875:	e8 0e 0f 00 00       	call   80103788 <sleep>
8010287a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010287d:	83 3d c0 16 11 80 00 	cmpl   $0x0,0x801116c0
80102884:	75 e2                	jne    80102868 <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102886:	a1 bc 16 11 80       	mov    0x801116bc,%eax
8010288b:	83 c0 01             	add    $0x1,%eax
8010288e:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102891:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
80102894:	03 15 c8 16 11 80    	add    0x801116c8,%edx
8010289a:	83 fa 1e             	cmp    $0x1e,%edx
8010289d:	7e 17                	jle    801028b6 <begin_op+0x67>
      sleep(&log, &log.lock);
8010289f:	83 ec 08             	sub    $0x8,%esp
801028a2:	68 80 16 11 80       	push   $0x80111680
801028a7:	68 80 16 11 80       	push   $0x80111680
801028ac:	e8 d7 0e 00 00       	call   80103788 <sleep>
801028b1:	83 c4 10             	add    $0x10,%esp
801028b4:	eb c7                	jmp    8010287d <begin_op+0x2e>
      log.outstanding += 1;
801028b6:	a3 bc 16 11 80       	mov    %eax,0x801116bc
      release(&log.lock);
801028bb:	83 ec 0c             	sub    $0xc,%esp
801028be:	68 80 16 11 80       	push   $0x80111680
801028c3:	e8 5c 14 00 00       	call   80103d24 <release>
}
801028c8:	83 c4 10             	add    $0x10,%esp
801028cb:	c9                   	leave  
801028cc:	c3                   	ret    

801028cd <end_op>:
{
801028cd:	f3 0f 1e fb          	endbr32 
801028d1:	55                   	push   %ebp
801028d2:	89 e5                	mov    %esp,%ebp
801028d4:	53                   	push   %ebx
801028d5:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
801028d8:	68 80 16 11 80       	push   $0x80111680
801028dd:	e8 d9 13 00 00       	call   80103cbb <acquire>
  log.outstanding -= 1;
801028e2:	a1 bc 16 11 80       	mov    0x801116bc,%eax
801028e7:	83 e8 01             	sub    $0x1,%eax
801028ea:	a3 bc 16 11 80       	mov    %eax,0x801116bc
  if(log.committing)
801028ef:	8b 1d c0 16 11 80    	mov    0x801116c0,%ebx
801028f5:	83 c4 10             	add    $0x10,%esp
801028f8:	85 db                	test   %ebx,%ebx
801028fa:	75 2c                	jne    80102928 <end_op+0x5b>
  if(log.outstanding == 0){
801028fc:	85 c0                	test   %eax,%eax
801028fe:	75 35                	jne    80102935 <end_op+0x68>
    log.committing = 1;
80102900:	c7 05 c0 16 11 80 01 	movl   $0x1,0x801116c0
80102907:	00 00 00 
    do_commit = 1;
8010290a:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
8010290f:	83 ec 0c             	sub    $0xc,%esp
80102912:	68 80 16 11 80       	push   $0x80111680
80102917:	e8 08 14 00 00       	call   80103d24 <release>
  if(do_commit){
8010291c:	83 c4 10             	add    $0x10,%esp
8010291f:	85 db                	test   %ebx,%ebx
80102921:	75 24                	jne    80102947 <end_op+0x7a>
}
80102923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102926:	c9                   	leave  
80102927:	c3                   	ret    
    panic("log.committing");
80102928:	83 ec 0c             	sub    $0xc,%esp
8010292b:	68 84 6a 10 80       	push   $0x80106a84
80102930:	e8 27 da ff ff       	call   8010035c <panic>
    wakeup(&log);
80102935:	83 ec 0c             	sub    $0xc,%esp
80102938:	68 80 16 11 80       	push   $0x80111680
8010293d:	e8 b3 0f 00 00       	call   801038f5 <wakeup>
80102942:	83 c4 10             	add    $0x10,%esp
80102945:	eb c8                	jmp    8010290f <end_op+0x42>
    commit();
80102947:	e8 86 fe ff ff       	call   801027d2 <commit>
    acquire(&log.lock);
8010294c:	83 ec 0c             	sub    $0xc,%esp
8010294f:	68 80 16 11 80       	push   $0x80111680
80102954:	e8 62 13 00 00       	call   80103cbb <acquire>
    log.committing = 0;
80102959:	c7 05 c0 16 11 80 00 	movl   $0x0,0x801116c0
80102960:	00 00 00 
    wakeup(&log);
80102963:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
8010296a:	e8 86 0f 00 00       	call   801038f5 <wakeup>
    release(&log.lock);
8010296f:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
80102976:	e8 a9 13 00 00       	call   80103d24 <release>
8010297b:	83 c4 10             	add    $0x10,%esp
}
8010297e:	eb a3                	jmp    80102923 <end_op+0x56>

80102980 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102980:	f3 0f 1e fb          	endbr32 
80102984:	55                   	push   %ebp
80102985:	89 e5                	mov    %esp,%ebp
80102987:	53                   	push   %ebx
80102988:	83 ec 04             	sub    $0x4,%esp
8010298b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010298e:	8b 15 c8 16 11 80    	mov    0x801116c8,%edx
80102994:	83 fa 1d             	cmp    $0x1d,%edx
80102997:	7f 45                	jg     801029de <log_write+0x5e>
80102999:	a1 b8 16 11 80       	mov    0x801116b8,%eax
8010299e:	83 e8 01             	sub    $0x1,%eax
801029a1:	39 c2                	cmp    %eax,%edx
801029a3:	7d 39                	jge    801029de <log_write+0x5e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801029a5:	83 3d bc 16 11 80 00 	cmpl   $0x0,0x801116bc
801029ac:	7e 3d                	jle    801029eb <log_write+0x6b>
    panic("log_write outside of trans");

  acquire(&log.lock);
801029ae:	83 ec 0c             	sub    $0xc,%esp
801029b1:	68 80 16 11 80       	push   $0x80111680
801029b6:	e8 00 13 00 00       	call   80103cbb <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029bb:	83 c4 10             	add    $0x10,%esp
801029be:	b8 00 00 00 00       	mov    $0x0,%eax
801029c3:	8b 15 c8 16 11 80    	mov    0x801116c8,%edx
801029c9:	39 c2                	cmp    %eax,%edx
801029cb:	7e 2b                	jle    801029f8 <log_write+0x78>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801029cd:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029d0:	39 0c 85 cc 16 11 80 	cmp    %ecx,-0x7feee934(,%eax,4)
801029d7:	74 1f                	je     801029f8 <log_write+0x78>
  for (i = 0; i < log.lh.n; i++) {
801029d9:	83 c0 01             	add    $0x1,%eax
801029dc:	eb e5                	jmp    801029c3 <log_write+0x43>
    panic("too big a transaction");
801029de:	83 ec 0c             	sub    $0xc,%esp
801029e1:	68 93 6a 10 80       	push   $0x80106a93
801029e6:	e8 71 d9 ff ff       	call   8010035c <panic>
    panic("log_write outside of trans");
801029eb:	83 ec 0c             	sub    $0xc,%esp
801029ee:	68 a9 6a 10 80       	push   $0x80106aa9
801029f3:	e8 64 d9 ff ff       	call   8010035c <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
801029f8:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029fb:	89 0c 85 cc 16 11 80 	mov    %ecx,-0x7feee934(,%eax,4)
  if (i == log.lh.n)
80102a02:	39 c2                	cmp    %eax,%edx
80102a04:	74 18                	je     80102a1e <log_write+0x9e>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a06:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a09:	83 ec 0c             	sub    $0xc,%esp
80102a0c:	68 80 16 11 80       	push   $0x80111680
80102a11:	e8 0e 13 00 00       	call   80103d24 <release>
}
80102a16:	83 c4 10             	add    $0x10,%esp
80102a19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1c:	c9                   	leave  
80102a1d:	c3                   	ret    
    log.lh.n++;
80102a1e:	83 c2 01             	add    $0x1,%edx
80102a21:	89 15 c8 16 11 80    	mov    %edx,0x801116c8
80102a27:	eb dd                	jmp    80102a06 <log_write+0x86>

80102a29 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80102a29:	55                   	push   %ebp
80102a2a:	89 e5                	mov    %esp,%ebp
80102a2c:	53                   	push   %ebx
80102a2d:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102a30:	68 8a 00 00 00       	push   $0x8a
80102a35:	68 8c 94 10 80       	push   $0x8010948c
80102a3a:	68 00 70 00 80       	push   $0x80007000
80102a3f:	e8 ab 13 00 00       	call   80103def <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102a44:	83 c4 10             	add    $0x10,%esp
80102a47:	bb 80 17 11 80       	mov    $0x80111780,%ebx
80102a4c:	eb 47                	jmp    80102a95 <startothers+0x6c>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102a4e:	e8 ff f6 ff ff       	call   80102152 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102a53:	05 00 10 00 00       	add    $0x1000,%eax
80102a58:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102a5d:	c7 05 f8 6f 00 80 f7 	movl   $0x80102af7,0x80006ff8
80102a64:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102a67:	c7 05 f4 6f 00 80 00 	movl   $0x108000,0x80006ff4
80102a6e:	80 10 00 

    lapicstartap(c->apicid, V2P(code));
80102a71:	83 ec 08             	sub    $0x8,%esp
80102a74:	68 00 70 00 00       	push   $0x7000
80102a79:	0f b6 03             	movzbl (%ebx),%eax
80102a7c:	50                   	push   %eax
80102a7d:	e8 db f9 ff ff       	call   8010245d <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102a82:	83 c4 10             	add    $0x10,%esp
80102a85:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102a8b:	85 c0                	test   %eax,%eax
80102a8d:	74 f6                	je     80102a85 <startothers+0x5c>
  for(c = cpus; c < cpus+ncpu; c++){
80102a8f:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102a95:	69 05 00 1d 11 80 b0 	imul   $0xb0,0x80111d00,%eax
80102a9c:	00 00 00 
80102a9f:	05 80 17 11 80       	add    $0x80111780,%eax
80102aa4:	39 d8                	cmp    %ebx,%eax
80102aa6:	76 0b                	jbe    80102ab3 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
80102aa8:	e8 99 07 00 00       	call   80103246 <mycpu>
80102aad:	39 c3                	cmp    %eax,%ebx
80102aaf:	74 de                	je     80102a8f <startothers+0x66>
80102ab1:	eb 9b                	jmp    80102a4e <startothers+0x25>
      ;
  }
}
80102ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ab6:	c9                   	leave  
80102ab7:	c3                   	ret    

80102ab8 <mpmain>:
{
80102ab8:	55                   	push   %ebp
80102ab9:	89 e5                	mov    %esp,%ebp
80102abb:	53                   	push   %ebx
80102abc:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102abf:	e8 e2 07 00 00       	call   801032a6 <cpuid>
80102ac4:	89 c3                	mov    %eax,%ebx
80102ac6:	e8 db 07 00 00       	call   801032a6 <cpuid>
80102acb:	83 ec 04             	sub    $0x4,%esp
80102ace:	53                   	push   %ebx
80102acf:	50                   	push   %eax
80102ad0:	68 c4 6a 10 80       	push   $0x80106ac4
80102ad5:	e8 4f db ff ff       	call   80100629 <cprintf>
  idtinit();       // load idt register
80102ada:	e8 38 24 00 00       	call   80104f17 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102adf:	e8 62 07 00 00       	call   80103246 <mycpu>
80102ae4:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ae6:	b8 01 00 00 00       	mov    $0x1,%eax
80102aeb:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102af2:	e8 5c 0a 00 00       	call   80103553 <scheduler>

80102af7 <mpenter>:
{
80102af7:	f3 0f 1e fb          	endbr32 
80102afb:	55                   	push   %ebp
80102afc:	89 e5                	mov    %esp,%ebp
80102afe:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102b01:	e8 31 34 00 00       	call   80105f37 <switchkvm>
  seginit();
80102b06:	e8 dc 32 00 00       	call   80105de7 <seginit>
  lapicinit();
80102b0b:	e8 f9 f7 ff ff       	call   80102309 <lapicinit>
  mpmain();
80102b10:	e8 a3 ff ff ff       	call   80102ab8 <mpmain>

80102b15 <main>:
{
80102b15:	f3 0f 1e fb          	endbr32 
80102b19:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102b1d:	83 e4 f0             	and    $0xfffffff0,%esp
80102b20:	ff 71 fc             	pushl  -0x4(%ecx)
80102b23:	55                   	push   %ebp
80102b24:	89 e5                	mov    %esp,%ebp
80102b26:	51                   	push   %ecx
80102b27:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b2a:	68 00 00 40 80       	push   $0x80400000
80102b2f:	68 a8 44 11 80       	push   $0x801144a8
80102b34:	e8 bf f5 ff ff       	call   801020f8 <kinit1>
  kvmalloc();      // kernel page table
80102b39:	e8 9c 38 00 00       	call   801063da <kvmalloc>
  mpinit();        // detect other processors
80102b3e:	e8 c1 01 00 00       	call   80102d04 <mpinit>
  lapicinit();     // interrupt controller
80102b43:	e8 c1 f7 ff ff       	call   80102309 <lapicinit>
  seginit();       // segment descriptors
80102b48:	e8 9a 32 00 00       	call   80105de7 <seginit>
  picinit();       // disable pic
80102b4d:	e8 8c 02 00 00       	call   80102dde <picinit>
  ioapicinit();    // another interrupt controller
80102b52:	e8 1c f4 ff ff       	call   80101f73 <ioapicinit>
  consoleinit();   // console hardware
80102b57:	e8 58 dd ff ff       	call   801008b4 <consoleinit>
  uartinit();      // serial port
80102b5c:	e8 6e 26 00 00       	call   801051cf <uartinit>
  pinit();         // process table
80102b61:	e8 c2 06 00 00       	call   80103228 <pinit>
  tvinit();        // trap vectors
80102b66:	e8 f7 22 00 00       	call   80104e62 <tvinit>
  binit();         // buffer cache
80102b6b:	e8 84 d5 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102b70:	e8 c4 e0 ff ff       	call   80100c39 <fileinit>
  ideinit();       // disk 
80102b75:	e8 fb f1 ff ff       	call   80101d75 <ideinit>
  startothers();   // start other processors
80102b7a:	e8 aa fe ff ff       	call   80102a29 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b7f:	83 c4 08             	add    $0x8,%esp
80102b82:	68 00 00 00 8e       	push   $0x8e000000
80102b87:	68 00 00 40 80       	push   $0x80400000
80102b8c:	e8 9d f5 ff ff       	call   8010212e <kinit2>
  userinit();      // first user process
80102b91:	e8 57 07 00 00       	call   801032ed <userinit>
  mpmain();        // finish this processor's setup
80102b96:	e8 1d ff ff ff       	call   80102ab8 <mpmain>

80102b9b <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102b9b:	55                   	push   %ebp
80102b9c:	89 e5                	mov    %esp,%ebp
80102b9e:	56                   	push   %esi
80102b9f:	53                   	push   %ebx
80102ba0:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102ba7:	b9 00 00 00 00       	mov    $0x0,%ecx
80102bac:	39 d1                	cmp    %edx,%ecx
80102bae:	7d 0b                	jge    80102bbb <sum+0x20>
    sum += addr[i];
80102bb0:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102bb4:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102bb6:	83 c1 01             	add    $0x1,%ecx
80102bb9:	eb f1                	jmp    80102bac <sum+0x11>
  return sum;
}
80102bbb:	5b                   	pop    %ebx
80102bbc:	5e                   	pop    %esi
80102bbd:	5d                   	pop    %ebp
80102bbe:	c3                   	ret    

80102bbf <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102bbf:	55                   	push   %ebp
80102bc0:	89 e5                	mov    %esp,%ebp
80102bc2:	56                   	push   %esi
80102bc3:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102bc4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102bca:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102bcc:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102bce:	eb 03                	jmp    80102bd3 <mpsearch1+0x14>
80102bd0:	83 c3 10             	add    $0x10,%ebx
80102bd3:	39 f3                	cmp    %esi,%ebx
80102bd5:	73 29                	jae    80102c00 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102bd7:	83 ec 04             	sub    $0x4,%esp
80102bda:	6a 04                	push   $0x4
80102bdc:	68 d8 6a 10 80       	push   $0x80106ad8
80102be1:	53                   	push   %ebx
80102be2:	e8 cf 11 00 00       	call   80103db6 <memcmp>
80102be7:	83 c4 10             	add    $0x10,%esp
80102bea:	85 c0                	test   %eax,%eax
80102bec:	75 e2                	jne    80102bd0 <mpsearch1+0x11>
80102bee:	ba 10 00 00 00       	mov    $0x10,%edx
80102bf3:	89 d8                	mov    %ebx,%eax
80102bf5:	e8 a1 ff ff ff       	call   80102b9b <sum>
80102bfa:	84 c0                	test   %al,%al
80102bfc:	75 d2                	jne    80102bd0 <mpsearch1+0x11>
80102bfe:	eb 05                	jmp    80102c05 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102c00:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102c05:	89 d8                	mov    %ebx,%eax
80102c07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c0a:	5b                   	pop    %ebx
80102c0b:	5e                   	pop    %esi
80102c0c:	5d                   	pop    %ebp
80102c0d:	c3                   	ret    

80102c0e <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102c0e:	55                   	push   %ebp
80102c0f:	89 e5                	mov    %esp,%ebp
80102c11:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c14:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c1b:	c1 e0 08             	shl    $0x8,%eax
80102c1e:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c25:	09 d0                	or     %edx,%eax
80102c27:	c1 e0 04             	shl    $0x4,%eax
80102c2a:	74 1f                	je     80102c4b <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102c2c:	ba 00 04 00 00       	mov    $0x400,%edx
80102c31:	e8 89 ff ff ff       	call   80102bbf <mpsearch1>
80102c36:	85 c0                	test   %eax,%eax
80102c38:	75 0f                	jne    80102c49 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102c3a:	ba 00 00 01 00       	mov    $0x10000,%edx
80102c3f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102c44:	e8 76 ff ff ff       	call   80102bbf <mpsearch1>
}
80102c49:	c9                   	leave  
80102c4a:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102c4b:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102c52:	c1 e0 08             	shl    $0x8,%eax
80102c55:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102c5c:	09 d0                	or     %edx,%eax
80102c5e:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102c61:	2d 00 04 00 00       	sub    $0x400,%eax
80102c66:	ba 00 04 00 00       	mov    $0x400,%edx
80102c6b:	e8 4f ff ff ff       	call   80102bbf <mpsearch1>
80102c70:	85 c0                	test   %eax,%eax
80102c72:	75 d5                	jne    80102c49 <mpsearch+0x3b>
80102c74:	eb c4                	jmp    80102c3a <mpsearch+0x2c>

80102c76 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102c76:	55                   	push   %ebp
80102c77:	89 e5                	mov    %esp,%ebp
80102c79:	57                   	push   %edi
80102c7a:	56                   	push   %esi
80102c7b:	53                   	push   %ebx
80102c7c:	83 ec 1c             	sub    $0x1c,%esp
80102c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c82:	e8 87 ff ff ff       	call   80102c0e <mpsearch>
80102c87:	89 c3                	mov    %eax,%ebx
80102c89:	85 c0                	test   %eax,%eax
80102c8b:	74 5a                	je     80102ce7 <mpconfig+0x71>
80102c8d:	8b 70 04             	mov    0x4(%eax),%esi
80102c90:	85 f6                	test   %esi,%esi
80102c92:	74 57                	je     80102ceb <mpconfig+0x75>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c94:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c9a:	83 ec 04             	sub    $0x4,%esp
80102c9d:	6a 04                	push   $0x4
80102c9f:	68 dd 6a 10 80       	push   $0x80106add
80102ca4:	57                   	push   %edi
80102ca5:	e8 0c 11 00 00       	call   80103db6 <memcmp>
80102caa:	83 c4 10             	add    $0x10,%esp
80102cad:	85 c0                	test   %eax,%eax
80102caf:	75 3e                	jne    80102cef <mpconfig+0x79>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102cb1:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102cb8:	3c 01                	cmp    $0x1,%al
80102cba:	0f 95 c2             	setne  %dl
80102cbd:	3c 04                	cmp    $0x4,%al
80102cbf:	0f 95 c0             	setne  %al
80102cc2:	84 c2                	test   %al,%dl
80102cc4:	75 30                	jne    80102cf6 <mpconfig+0x80>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102cc6:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102ccd:	89 f8                	mov    %edi,%eax
80102ccf:	e8 c7 fe ff ff       	call   80102b9b <sum>
80102cd4:	84 c0                	test   %al,%al
80102cd6:	75 25                	jne    80102cfd <mpconfig+0x87>
    return 0;
  *pmp = mp;
80102cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102cdb:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102cdd:	89 f8                	mov    %edi,%eax
80102cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce2:	5b                   	pop    %ebx
80102ce3:	5e                   	pop    %esi
80102ce4:	5f                   	pop    %edi
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    
    return 0;
80102ce7:	89 c7                	mov    %eax,%edi
80102ce9:	eb f2                	jmp    80102cdd <mpconfig+0x67>
80102ceb:	89 f7                	mov    %esi,%edi
80102ced:	eb ee                	jmp    80102cdd <mpconfig+0x67>
    return 0;
80102cef:	bf 00 00 00 00       	mov    $0x0,%edi
80102cf4:	eb e7                	jmp    80102cdd <mpconfig+0x67>
    return 0;
80102cf6:	bf 00 00 00 00       	mov    $0x0,%edi
80102cfb:	eb e0                	jmp    80102cdd <mpconfig+0x67>
    return 0;
80102cfd:	bf 00 00 00 00       	mov    $0x0,%edi
80102d02:	eb d9                	jmp    80102cdd <mpconfig+0x67>

80102d04 <mpinit>:

void
mpinit(void)
{
80102d04:	f3 0f 1e fb          	endbr32 
80102d08:	55                   	push   %ebp
80102d09:	89 e5                	mov    %esp,%ebp
80102d0b:	57                   	push   %edi
80102d0c:	56                   	push   %esi
80102d0d:	53                   	push   %ebx
80102d0e:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102d11:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102d14:	e8 5d ff ff ff       	call   80102c76 <mpconfig>
80102d19:	85 c0                	test   %eax,%eax
80102d1b:	74 19                	je     80102d36 <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102d1d:	8b 50 24             	mov    0x24(%eax),%edx
80102d20:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d26:	8d 50 2c             	lea    0x2c(%eax),%edx
80102d29:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102d2d:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102d2f:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d34:	eb 20                	jmp    80102d56 <mpinit+0x52>
    panic("Expect to run on an SMP");
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	68 e2 6a 10 80       	push   $0x80106ae2
80102d3e:	e8 19 d6 ff ff       	call   8010035c <panic>
    switch(*p){
80102d43:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d48:	eb 0c                	jmp    80102d56 <mpinit+0x52>
80102d4a:	83 e8 03             	sub    $0x3,%eax
80102d4d:	3c 01                	cmp    $0x1,%al
80102d4f:	76 1a                	jbe    80102d6b <mpinit+0x67>
80102d51:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d56:	39 ca                	cmp    %ecx,%edx
80102d58:	73 4d                	jae    80102da7 <mpinit+0xa3>
    switch(*p){
80102d5a:	0f b6 02             	movzbl (%edx),%eax
80102d5d:	3c 02                	cmp    $0x2,%al
80102d5f:	74 38                	je     80102d99 <mpinit+0x95>
80102d61:	77 e7                	ja     80102d4a <mpinit+0x46>
80102d63:	84 c0                	test   %al,%al
80102d65:	74 09                	je     80102d70 <mpinit+0x6c>
80102d67:	3c 01                	cmp    $0x1,%al
80102d69:	75 d8                	jne    80102d43 <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102d6b:	83 c2 08             	add    $0x8,%edx
      continue;
80102d6e:	eb e6                	jmp    80102d56 <mpinit+0x52>
      if(ncpu < NCPU) {
80102d70:	8b 35 00 1d 11 80    	mov    0x80111d00,%esi
80102d76:	83 fe 07             	cmp    $0x7,%esi
80102d79:	7f 19                	jg     80102d94 <mpinit+0x90>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d7b:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102d7f:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102d85:	88 87 80 17 11 80    	mov    %al,-0x7feee880(%edi)
        ncpu++;
80102d8b:	83 c6 01             	add    $0x1,%esi
80102d8e:	89 35 00 1d 11 80    	mov    %esi,0x80111d00
      p += sizeof(struct mpproc);
80102d94:	83 c2 14             	add    $0x14,%edx
      continue;
80102d97:	eb bd                	jmp    80102d56 <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102d99:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102d9d:	a2 60 17 11 80       	mov    %al,0x80111760
      p += sizeof(struct mpioapic);
80102da2:	83 c2 08             	add    $0x8,%edx
      continue;
80102da5:	eb af                	jmp    80102d56 <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102da7:	85 db                	test   %ebx,%ebx
80102da9:	74 26                	je     80102dd1 <mpinit+0xcd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102dae:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102db2:	74 15                	je     80102dc9 <mpinit+0xc5>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db4:	b8 70 00 00 00       	mov    $0x70,%eax
80102db9:	ba 22 00 00 00       	mov    $0x22,%edx
80102dbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbf:	ba 23 00 00 00       	mov    $0x23,%edx
80102dc4:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102dc5:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc8:	ee                   	out    %al,(%dx)
  }
}
80102dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dcc:	5b                   	pop    %ebx
80102dcd:	5e                   	pop    %esi
80102dce:	5f                   	pop    %edi
80102dcf:	5d                   	pop    %ebp
80102dd0:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102dd1:	83 ec 0c             	sub    $0xc,%esp
80102dd4:	68 fc 6a 10 80       	push   $0x80106afc
80102dd9:	e8 7e d5 ff ff       	call   8010035c <panic>

80102dde <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102dde:	f3 0f 1e fb          	endbr32 
80102de2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102de7:	ba 21 00 00 00       	mov    $0x21,%edx
80102dec:	ee                   	out    %al,(%dx)
80102ded:	ba a1 00 00 00       	mov    $0xa1,%edx
80102df2:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102df3:	c3                   	ret    

80102df4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102df4:	f3 0f 1e fb          	endbr32 
80102df8:	55                   	push   %ebp
80102df9:	89 e5                	mov    %esp,%ebp
80102dfb:	57                   	push   %edi
80102dfc:	56                   	push   %esi
80102dfd:	53                   	push   %ebx
80102dfe:	83 ec 0c             	sub    $0xc,%esp
80102e01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e04:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e07:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e0d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e13:	e8 3f de ff ff       	call   80100c57 <filealloc>
80102e18:	89 03                	mov    %eax,(%ebx)
80102e1a:	85 c0                	test   %eax,%eax
80102e1c:	0f 84 88 00 00 00    	je     80102eaa <pipealloc+0xb6>
80102e22:	e8 30 de ff ff       	call   80100c57 <filealloc>
80102e27:	89 06                	mov    %eax,(%esi)
80102e29:	85 c0                	test   %eax,%eax
80102e2b:	74 7d                	je     80102eaa <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e2d:	e8 20 f3 ff ff       	call   80102152 <kalloc>
80102e32:	89 c7                	mov    %eax,%edi
80102e34:	85 c0                	test   %eax,%eax
80102e36:	74 72                	je     80102eaa <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102e38:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e3f:	00 00 00 
  p->writeopen = 1;
80102e42:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e49:	00 00 00 
  p->nwrite = 0;
80102e4c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e53:	00 00 00 
  p->nread = 0;
80102e56:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102e5d:	00 00 00 
  initlock(&p->lock, "pipe");
80102e60:	83 ec 08             	sub    $0x8,%esp
80102e63:	68 1b 6b 10 80       	push   $0x80106b1b
80102e68:	50                   	push   %eax
80102e69:	e8 fd 0c 00 00       	call   80103b6b <initlock>
  (*f0)->type = FD_PIPE;
80102e6e:	8b 03                	mov    (%ebx),%eax
80102e70:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e76:	8b 03                	mov    (%ebx),%eax
80102e78:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e7c:	8b 03                	mov    (%ebx),%eax
80102e7e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e82:	8b 03                	mov    (%ebx),%eax
80102e84:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e87:	8b 06                	mov    (%esi),%eax
80102e89:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e8f:	8b 06                	mov    (%esi),%eax
80102e91:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e95:	8b 06                	mov    (%esi),%eax
80102e97:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e9b:	8b 06                	mov    (%esi),%eax
80102e9d:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102ea0:	83 c4 10             	add    $0x10,%esp
80102ea3:	b8 00 00 00 00       	mov    $0x0,%eax
80102ea8:	eb 29                	jmp    80102ed3 <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102eaa:	8b 03                	mov    (%ebx),%eax
80102eac:	85 c0                	test   %eax,%eax
80102eae:	74 0c                	je     80102ebc <pipealloc+0xc8>
    fileclose(*f0);
80102eb0:	83 ec 0c             	sub    $0xc,%esp
80102eb3:	50                   	push   %eax
80102eb4:	e8 4c de ff ff       	call   80100d05 <fileclose>
80102eb9:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102ebc:	8b 06                	mov    (%esi),%eax
80102ebe:	85 c0                	test   %eax,%eax
80102ec0:	74 19                	je     80102edb <pipealloc+0xe7>
    fileclose(*f1);
80102ec2:	83 ec 0c             	sub    $0xc,%esp
80102ec5:	50                   	push   %eax
80102ec6:	e8 3a de ff ff       	call   80100d05 <fileclose>
80102ecb:	83 c4 10             	add    $0x10,%esp
  return -1;
80102ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed6:	5b                   	pop    %ebx
80102ed7:	5e                   	pop    %esi
80102ed8:	5f                   	pop    %edi
80102ed9:	5d                   	pop    %ebp
80102eda:	c3                   	ret    
  return -1;
80102edb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ee0:	eb f1                	jmp    80102ed3 <pipealloc+0xdf>

80102ee2 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102ee2:	f3 0f 1e fb          	endbr32 
80102ee6:	55                   	push   %ebp
80102ee7:	89 e5                	mov    %esp,%ebp
80102ee9:	53                   	push   %ebx
80102eea:	83 ec 10             	sub    $0x10,%esp
80102eed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102ef0:	53                   	push   %ebx
80102ef1:	e8 c5 0d 00 00       	call   80103cbb <acquire>
  if(writable){
80102ef6:	83 c4 10             	add    $0x10,%esp
80102ef9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102efd:	74 3f                	je     80102f3e <pipeclose+0x5c>
    p->writeopen = 0;
80102eff:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102f06:	00 00 00 
    wakeup(&p->nread);
80102f09:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f0f:	83 ec 0c             	sub    $0xc,%esp
80102f12:	50                   	push   %eax
80102f13:	e8 dd 09 00 00       	call   801038f5 <wakeup>
80102f18:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f1b:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f22:	75 09                	jne    80102f2d <pipeclose+0x4b>
80102f24:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102f2b:	74 2f                	je     80102f5c <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f2d:	83 ec 0c             	sub    $0xc,%esp
80102f30:	53                   	push   %ebx
80102f31:	e8 ee 0d 00 00       	call   80103d24 <release>
80102f36:	83 c4 10             	add    $0x10,%esp
}
80102f39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f3c:	c9                   	leave  
80102f3d:	c3                   	ret    
    p->readopen = 0;
80102f3e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102f45:	00 00 00 
    wakeup(&p->nwrite);
80102f48:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f4e:	83 ec 0c             	sub    $0xc,%esp
80102f51:	50                   	push   %eax
80102f52:	e8 9e 09 00 00       	call   801038f5 <wakeup>
80102f57:	83 c4 10             	add    $0x10,%esp
80102f5a:	eb bf                	jmp    80102f1b <pipeclose+0x39>
    release(&p->lock);
80102f5c:	83 ec 0c             	sub    $0xc,%esp
80102f5f:	53                   	push   %ebx
80102f60:	e8 bf 0d 00 00       	call   80103d24 <release>
    kfree((char*)p);
80102f65:	89 1c 24             	mov    %ebx,(%esp)
80102f68:	e8 be f0 ff ff       	call   8010202b <kfree>
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	eb c7                	jmp    80102f39 <pipeclose+0x57>

80102f72 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102f72:	f3 0f 1e fb          	endbr32 
80102f76:	55                   	push   %ebp
80102f77:	89 e5                	mov    %esp,%ebp
80102f79:	57                   	push   %edi
80102f7a:	56                   	push   %esi
80102f7b:	53                   	push   %ebx
80102f7c:	83 ec 18             	sub    $0x18,%esp
80102f7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102f82:	89 de                	mov    %ebx,%esi
80102f84:	53                   	push   %ebx
80102f85:	e8 31 0d 00 00       	call   80103cbb <acquire>
  for(i = 0; i < n; i++){
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	bf 00 00 00 00       	mov    $0x0,%edi
80102f92:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102f95:	7c 41                	jl     80102fd8 <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f97:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f9d:	83 ec 0c             	sub    $0xc,%esp
80102fa0:	50                   	push   %eax
80102fa1:	e8 4f 09 00 00       	call   801038f5 <wakeup>
  release(&p->lock);
80102fa6:	89 1c 24             	mov    %ebx,(%esp)
80102fa9:	e8 76 0d 00 00       	call   80103d24 <release>
  return n;
80102fae:	83 c4 10             	add    $0x10,%esp
80102fb1:	8b 45 10             	mov    0x10(%ebp),%eax
80102fb4:	eb 5c                	jmp    80103012 <pipewrite+0xa0>
      wakeup(&p->nread);
80102fb6:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fbc:	83 ec 0c             	sub    $0xc,%esp
80102fbf:	50                   	push   %eax
80102fc0:	e8 30 09 00 00       	call   801038f5 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102fc5:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102fcb:	83 c4 08             	add    $0x8,%esp
80102fce:	56                   	push   %esi
80102fcf:	50                   	push   %eax
80102fd0:	e8 b3 07 00 00       	call   80103788 <sleep>
80102fd5:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102fd8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fde:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fe4:	05 00 02 00 00       	add    $0x200,%eax
80102fe9:	39 c2                	cmp    %eax,%edx
80102feb:	75 2d                	jne    8010301a <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80102fed:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ff4:	74 0b                	je     80103001 <pipewrite+0x8f>
80102ff6:	e8 ca 02 00 00       	call   801032c5 <myproc>
80102ffb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102fff:	74 b5                	je     80102fb6 <pipewrite+0x44>
        release(&p->lock);
80103001:	83 ec 0c             	sub    $0xc,%esp
80103004:	53                   	push   %ebx
80103005:	e8 1a 0d 00 00       	call   80103d24 <release>
        return -1;
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103012:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103015:	5b                   	pop    %ebx
80103016:	5e                   	pop    %esi
80103017:	5f                   	pop    %edi
80103018:	5d                   	pop    %ebp
80103019:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010301a:	8d 42 01             	lea    0x1(%edx),%eax
8010301d:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103023:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010302c:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
80103030:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103034:	83 c7 01             	add    $0x1,%edi
80103037:	e9 56 ff ff ff       	jmp    80102f92 <pipewrite+0x20>

8010303c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010303c:	f3 0f 1e fb          	endbr32 
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 18             	sub    $0x18,%esp
80103049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010304c:	89 df                	mov    %ebx,%edi
8010304e:	53                   	push   %ebx
8010304f:	e8 67 0c 00 00       	call   80103cbb <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103054:	83 c4 10             	add    $0x10,%esp
80103057:	eb 13                	jmp    8010306c <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103059:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010305f:	83 ec 08             	sub    $0x8,%esp
80103062:	57                   	push   %edi
80103063:	50                   	push   %eax
80103064:	e8 1f 07 00 00       	call   80103788 <sleep>
80103069:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010306c:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103072:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103078:	75 28                	jne    801030a2 <piperead+0x66>
8010307a:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80103080:	85 f6                	test   %esi,%esi
80103082:	74 23                	je     801030a7 <piperead+0x6b>
    if(myproc()->killed){
80103084:	e8 3c 02 00 00       	call   801032c5 <myproc>
80103089:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010308d:	74 ca                	je     80103059 <piperead+0x1d>
      release(&p->lock);
8010308f:	83 ec 0c             	sub    $0xc,%esp
80103092:	53                   	push   %ebx
80103093:	e8 8c 0c 00 00       	call   80103d24 <release>
      return -1;
80103098:	83 c4 10             	add    $0x10,%esp
8010309b:	be ff ff ff ff       	mov    $0xffffffff,%esi
801030a0:	eb 50                	jmp    801030f2 <piperead+0xb6>
801030a2:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030a7:	3b 75 10             	cmp    0x10(%ebp),%esi
801030aa:	7d 2c                	jge    801030d8 <piperead+0x9c>
    if(p->nread == p->nwrite)
801030ac:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801030b2:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801030b8:	74 1e                	je     801030d8 <piperead+0x9c>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801030ba:	8d 50 01             	lea    0x1(%eax),%edx
801030bd:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
801030c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801030c8:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801030cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801030d0:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030d3:	83 c6 01             	add    $0x1,%esi
801030d6:	eb cf                	jmp    801030a7 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801030d8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801030de:	83 ec 0c             	sub    $0xc,%esp
801030e1:	50                   	push   %eax
801030e2:	e8 0e 08 00 00       	call   801038f5 <wakeup>
  release(&p->lock);
801030e7:	89 1c 24             	mov    %ebx,(%esp)
801030ea:	e8 35 0c 00 00       	call   80103d24 <release>
  return i;
801030ef:	83 c4 10             	add    $0x10,%esp
}
801030f2:	89 f0                	mov    %esi,%eax
801030f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030f7:	5b                   	pop    %ebx
801030f8:	5e                   	pop    %esi
801030f9:	5f                   	pop    %edi
801030fa:	5d                   	pop    %ebp
801030fb:	c3                   	ret    

801030fc <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030fc:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103101:	eb 0a                	jmp    8010310d <wakeup1+0x11>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
80103103:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010310a:	83 c2 7c             	add    $0x7c,%edx
8010310d:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103113:	73 0d                	jae    80103122 <wakeup1+0x26>
    if(p->state == SLEEPING && p->chan == chan)
80103115:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103119:	75 ef                	jne    8010310a <wakeup1+0xe>
8010311b:	39 42 20             	cmp    %eax,0x20(%edx)
8010311e:	75 ea                	jne    8010310a <wakeup1+0xe>
80103120:	eb e1                	jmp    80103103 <wakeup1+0x7>
}
80103122:	c3                   	ret    

80103123 <allocproc>:
{
80103123:	55                   	push   %ebp
80103124:	89 e5                	mov    %esp,%ebp
80103126:	53                   	push   %ebx
80103127:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010312a:	68 20 1d 11 80       	push   $0x80111d20
8010312f:	e8 87 0b 00 00       	call   80103cbb <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103134:	83 c4 10             	add    $0x10,%esp
80103137:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010313c:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103142:	73 7b                	jae    801031bf <allocproc+0x9c>
    if(p->state == UNUSED)
80103144:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80103148:	74 05                	je     8010314f <allocproc+0x2c>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010314a:	83 c3 7c             	add    $0x7c,%ebx
8010314d:	eb ed                	jmp    8010313c <allocproc+0x19>
  p->state = EMBRYO;
8010314f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103156:	a1 04 90 10 80       	mov    0x80109004,%eax
8010315b:	8d 50 01             	lea    0x1(%eax),%edx
8010315e:	89 15 04 90 10 80    	mov    %edx,0x80109004
80103164:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103167:	83 ec 0c             	sub    $0xc,%esp
8010316a:	68 20 1d 11 80       	push   $0x80111d20
8010316f:	e8 b0 0b 00 00       	call   80103d24 <release>
  if((p->kstack = kalloc()) == 0){
80103174:	e8 d9 ef ff ff       	call   80102152 <kalloc>
80103179:	89 43 08             	mov    %eax,0x8(%ebx)
8010317c:	83 c4 10             	add    $0x10,%esp
8010317f:	85 c0                	test   %eax,%eax
80103181:	74 53                	je     801031d6 <allocproc+0xb3>
  sp -= sizeof *p->tf;
80103183:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
80103189:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010318c:	c7 80 b0 0f 00 00 57 	movl   $0x80104e57,0xfb0(%eax)
80103193:	4e 10 80 
  sp -= sizeof *p->context;
80103196:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010319b:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010319e:	83 ec 04             	sub    $0x4,%esp
801031a1:	6a 14                	push   $0x14
801031a3:	6a 00                	push   $0x0
801031a5:	50                   	push   %eax
801031a6:	e8 c4 0b 00 00       	call   80103d6f <memset>
  p->context->eip = (uint)forkret;
801031ab:	8b 43 1c             	mov    0x1c(%ebx),%eax
801031ae:	c7 40 10 e1 31 10 80 	movl   $0x801031e1,0x10(%eax)
  return p;
801031b5:	83 c4 10             	add    $0x10,%esp
}
801031b8:	89 d8                	mov    %ebx,%eax
801031ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031bd:	c9                   	leave  
801031be:	c3                   	ret    
  release(&ptable.lock);
801031bf:	83 ec 0c             	sub    $0xc,%esp
801031c2:	68 20 1d 11 80       	push   $0x80111d20
801031c7:	e8 58 0b 00 00       	call   80103d24 <release>
  return 0;
801031cc:	83 c4 10             	add    $0x10,%esp
801031cf:	bb 00 00 00 00       	mov    $0x0,%ebx
801031d4:	eb e2                	jmp    801031b8 <allocproc+0x95>
    p->state = UNUSED;
801031d6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801031dd:	89 c3                	mov    %eax,%ebx
801031df:	eb d7                	jmp    801031b8 <allocproc+0x95>

801031e1 <forkret>:
{
801031e1:	f3 0f 1e fb          	endbr32 
801031e5:	55                   	push   %ebp
801031e6:	89 e5                	mov    %esp,%ebp
801031e8:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801031eb:	68 20 1d 11 80       	push   $0x80111d20
801031f0:	e8 2f 0b 00 00       	call   80103d24 <release>
  if (first) {
801031f5:	83 c4 10             	add    $0x10,%esp
801031f8:	83 3d 00 90 10 80 00 	cmpl   $0x0,0x80109000
801031ff:	75 02                	jne    80103203 <forkret+0x22>
}
80103201:	c9                   	leave  
80103202:	c3                   	ret    
    first = 0;
80103203:	c7 05 00 90 10 80 00 	movl   $0x0,0x80109000
8010320a:	00 00 00 
    iinit(ROOTDEV);
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	6a 01                	push   $0x1
80103212:	e8 0e e1 ff ff       	call   80101325 <iinit>
    initlog(ROOTDEV);
80103217:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010321e:	e8 df f5 ff ff       	call   80102802 <initlog>
80103223:	83 c4 10             	add    $0x10,%esp
}
80103226:	eb d9                	jmp    80103201 <forkret+0x20>

80103228 <pinit>:
{
80103228:	f3 0f 1e fb          	endbr32 
8010322c:	55                   	push   %ebp
8010322d:	89 e5                	mov    %esp,%ebp
8010322f:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103232:	68 20 6b 10 80       	push   $0x80106b20
80103237:	68 20 1d 11 80       	push   $0x80111d20
8010323c:	e8 2a 09 00 00       	call   80103b6b <initlock>
}
80103241:	83 c4 10             	add    $0x10,%esp
80103244:	c9                   	leave  
80103245:	c3                   	ret    

80103246 <mycpu>:
{
80103246:	f3 0f 1e fb          	endbr32 
8010324a:	55                   	push   %ebp
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103250:	9c                   	pushf  
80103251:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103252:	f6 c4 02             	test   $0x2,%ah
80103255:	75 28                	jne    8010327f <mycpu+0x39>
  apicid = lapicid();
80103257:	e8 bd f1 ff ff       	call   80102419 <lapicid>
  for (i = 0; i < ncpu; ++i) {
8010325c:	ba 00 00 00 00       	mov    $0x0,%edx
80103261:	39 15 00 1d 11 80    	cmp    %edx,0x80111d00
80103267:	7e 30                	jle    80103299 <mycpu+0x53>
    if (cpus[i].apicid == apicid)
80103269:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010326f:	0f b6 89 80 17 11 80 	movzbl -0x7feee880(%ecx),%ecx
80103276:	39 c1                	cmp    %eax,%ecx
80103278:	74 12                	je     8010328c <mycpu+0x46>
  for (i = 0; i < ncpu; ++i) {
8010327a:	83 c2 01             	add    $0x1,%edx
8010327d:	eb e2                	jmp    80103261 <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
8010327f:	83 ec 0c             	sub    $0xc,%esp
80103282:	68 04 6c 10 80       	push   $0x80106c04
80103287:	e8 d0 d0 ff ff       	call   8010035c <panic>
      return &cpus[i];
8010328c:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103292:	05 80 17 11 80       	add    $0x80111780,%eax
}
80103297:	c9                   	leave  
80103298:	c3                   	ret    
  panic("unknown apicid\n");
80103299:	83 ec 0c             	sub    $0xc,%esp
8010329c:	68 27 6b 10 80       	push   $0x80106b27
801032a1:	e8 b6 d0 ff ff       	call   8010035c <panic>

801032a6 <cpuid>:
cpuid() {
801032a6:	f3 0f 1e fb          	endbr32 
801032aa:	55                   	push   %ebp
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801032b0:	e8 91 ff ff ff       	call   80103246 <mycpu>
801032b5:	2d 80 17 11 80       	sub    $0x80111780,%eax
801032ba:	c1 f8 04             	sar    $0x4,%eax
801032bd:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801032c3:	c9                   	leave  
801032c4:	c3                   	ret    

801032c5 <myproc>:
myproc(void) {
801032c5:	f3 0f 1e fb          	endbr32 
801032c9:	55                   	push   %ebp
801032ca:	89 e5                	mov    %esp,%ebp
801032cc:	53                   	push   %ebx
801032cd:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801032d0:	e8 fd 08 00 00       	call   80103bd2 <pushcli>
  c = mycpu();
801032d5:	e8 6c ff ff ff       	call   80103246 <mycpu>
  p = c->proc;
801032da:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801032e0:	e8 2e 09 00 00       	call   80103c13 <popcli>
}
801032e5:	89 d8                	mov    %ebx,%eax
801032e7:	83 c4 04             	add    $0x4,%esp
801032ea:	5b                   	pop    %ebx
801032eb:	5d                   	pop    %ebp
801032ec:	c3                   	ret    

801032ed <userinit>:
{
801032ed:	f3 0f 1e fb          	endbr32 
801032f1:	55                   	push   %ebp
801032f2:	89 e5                	mov    %esp,%ebp
801032f4:	53                   	push   %ebx
801032f5:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801032f8:	e8 26 fe ff ff       	call   80103123 <allocproc>
801032fd:	89 c3                	mov    %eax,%ebx
  initproc = p;
801032ff:	a3 b8 95 10 80       	mov    %eax,0x801095b8
  if((p->pgdir = setupkvm()) == 0)
80103304:	e8 5f 30 00 00       	call   80106368 <setupkvm>
80103309:	89 43 04             	mov    %eax,0x4(%ebx)
8010330c:	85 c0                	test   %eax,%eax
8010330e:	0f 84 b8 00 00 00    	je     801033cc <userinit+0xdf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103314:	83 ec 04             	sub    $0x4,%esp
80103317:	68 2c 00 00 00       	push   $0x2c
8010331c:	68 60 94 10 80       	push   $0x80109460
80103321:	50                   	push   %eax
80103322:	e8 3e 2d 00 00       	call   80106065 <inituvm>
  p->sz = PGSIZE;
80103327:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010332d:	8b 43 18             	mov    0x18(%ebx),%eax
80103330:	83 c4 0c             	add    $0xc,%esp
80103333:	6a 4c                	push   $0x4c
80103335:	6a 00                	push   $0x0
80103337:	50                   	push   %eax
80103338:	e8 32 0a 00 00       	call   80103d6f <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010333d:	8b 43 18             	mov    0x18(%ebx),%eax
80103340:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103346:	8b 43 18             	mov    0x18(%ebx),%eax
80103349:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010334f:	8b 43 18             	mov    0x18(%ebx),%eax
80103352:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103356:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010335a:	8b 43 18             	mov    0x18(%ebx),%eax
8010335d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103361:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103365:	8b 43 18             	mov    0x18(%ebx),%eax
80103368:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010336f:	8b 43 18             	mov    0x18(%ebx),%eax
80103372:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103379:	8b 43 18             	mov    0x18(%ebx),%eax
8010337c:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103383:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103386:	83 c4 0c             	add    $0xc,%esp
80103389:	6a 10                	push   $0x10
8010338b:	68 50 6b 10 80       	push   $0x80106b50
80103390:	50                   	push   %eax
80103391:	e8 59 0b 00 00       	call   80103eef <safestrcpy>
  p->cwd = namei("/");
80103396:	c7 04 24 59 6b 10 80 	movl   $0x80106b59,(%esp)
8010339d:	e8 ad e8 ff ff       	call   80101c4f <namei>
801033a2:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801033a5:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801033ac:	e8 0a 09 00 00       	call   80103cbb <acquire>
  p->state = RUNNABLE;
801033b1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801033b8:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801033bf:	e8 60 09 00 00       	call   80103d24 <release>
}
801033c4:	83 c4 10             	add    $0x10,%esp
801033c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033ca:	c9                   	leave  
801033cb:	c3                   	ret    
    panic("userinit: out of memory?");
801033cc:	83 ec 0c             	sub    $0xc,%esp
801033cf:	68 37 6b 10 80       	push   $0x80106b37
801033d4:	e8 83 cf ff ff       	call   8010035c <panic>

801033d9 <growproc>:
{
801033d9:	f3 0f 1e fb          	endbr32 
801033dd:	55                   	push   %ebp
801033de:	89 e5                	mov    %esp,%ebp
801033e0:	56                   	push   %esi
801033e1:	53                   	push   %ebx
801033e2:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801033e5:	e8 db fe ff ff       	call   801032c5 <myproc>
801033ea:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801033ec:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801033ee:	85 f6                	test   %esi,%esi
801033f0:	7f 1c                	jg     8010340e <growproc+0x35>
  } else if(n < 0){
801033f2:	78 37                	js     8010342b <growproc+0x52>
  curproc->sz = sz;
801033f4:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801033f6:	83 ec 0c             	sub    $0xc,%esp
801033f9:	53                   	push   %ebx
801033fa:	e8 4a 2b 00 00       	call   80105f49 <switchuvm>
  return 0;
801033ff:	83 c4 10             	add    $0x10,%esp
80103402:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103407:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010340a:	5b                   	pop    %ebx
8010340b:	5e                   	pop    %esi
8010340c:	5d                   	pop    %ebp
8010340d:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010340e:	83 ec 04             	sub    $0x4,%esp
80103411:	01 c6                	add    %eax,%esi
80103413:	56                   	push   %esi
80103414:	50                   	push   %eax
80103415:	ff 73 04             	pushl  0x4(%ebx)
80103418:	e8 ea 2d 00 00       	call   80106207 <allocuvm>
8010341d:	83 c4 10             	add    $0x10,%esp
80103420:	85 c0                	test   %eax,%eax
80103422:	75 d0                	jne    801033f4 <growproc+0x1b>
      return -1;
80103424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103429:	eb dc                	jmp    80103407 <growproc+0x2e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010342b:	83 ec 04             	sub    $0x4,%esp
8010342e:	01 c6                	add    %eax,%esi
80103430:	56                   	push   %esi
80103431:	50                   	push   %eax
80103432:	ff 73 04             	pushl  0x4(%ebx)
80103435:	e8 37 2d 00 00       	call   80106171 <deallocuvm>
8010343a:	83 c4 10             	add    $0x10,%esp
8010343d:	85 c0                	test   %eax,%eax
8010343f:	75 b3                	jne    801033f4 <growproc+0x1b>
      return -1;
80103441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103446:	eb bf                	jmp    80103407 <growproc+0x2e>

80103448 <fork>:
{
80103448:	f3 0f 1e fb          	endbr32 
8010344c:	55                   	push   %ebp
8010344d:	89 e5                	mov    %esp,%ebp
8010344f:	57                   	push   %edi
80103450:	56                   	push   %esi
80103451:	53                   	push   %ebx
80103452:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103455:	e8 6b fe ff ff       	call   801032c5 <myproc>
8010345a:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
8010345c:	e8 c2 fc ff ff       	call   80103123 <allocproc>
80103461:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103464:	85 c0                	test   %eax,%eax
80103466:	0f 84 e0 00 00 00    	je     8010354c <fork+0x104>
8010346c:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010346e:	83 ec 08             	sub    $0x8,%esp
80103471:	ff 33                	pushl  (%ebx)
80103473:	ff 73 04             	pushl  0x4(%ebx)
80103476:	e8 aa 2f 00 00       	call   80106425 <copyuvm>
8010347b:	89 47 04             	mov    %eax,0x4(%edi)
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	85 c0                	test   %eax,%eax
80103483:	74 2a                	je     801034af <fork+0x67>
  np->sz = curproc->sz;
80103485:	8b 03                	mov    (%ebx),%eax
80103487:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010348a:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010348c:	89 c8                	mov    %ecx,%eax
8010348e:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103491:	8b 73 18             	mov    0x18(%ebx),%esi
80103494:	8b 79 18             	mov    0x18(%ecx),%edi
80103497:	b9 13 00 00 00       	mov    $0x13,%ecx
8010349c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
8010349e:	8b 40 18             	mov    0x18(%eax),%eax
801034a1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801034a8:	be 00 00 00 00       	mov    $0x0,%esi
801034ad:	eb 3c                	jmp    801034eb <fork+0xa3>
    kfree(np->kstack);
801034af:	83 ec 0c             	sub    $0xc,%esp
801034b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034b5:	ff 73 08             	pushl  0x8(%ebx)
801034b8:	e8 6e eb ff ff       	call   8010202b <kfree>
    np->kstack = 0;
801034bd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801034c4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801034cb:	83 c4 10             	add    $0x10,%esp
801034ce:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801034d3:	eb 6d                	jmp    80103542 <fork+0xfa>
      np->ofile[i] = filedup(curproc->ofile[i]);
801034d5:	83 ec 0c             	sub    $0xc,%esp
801034d8:	50                   	push   %eax
801034d9:	e8 de d7 ff ff       	call   80100cbc <filedup>
801034de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034e1:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801034e5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
801034e8:	83 c6 01             	add    $0x1,%esi
801034eb:	83 fe 0f             	cmp    $0xf,%esi
801034ee:	7f 0a                	jg     801034fa <fork+0xb2>
    if(curproc->ofile[i])
801034f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801034f4:	85 c0                	test   %eax,%eax
801034f6:	75 dd                	jne    801034d5 <fork+0x8d>
801034f8:	eb ee                	jmp    801034e8 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
801034fa:	83 ec 0c             	sub    $0xc,%esp
801034fd:	ff 73 68             	pushl  0x68(%ebx)
80103500:	e8 91 e0 ff ff       	call   80101596 <idup>
80103505:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103508:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010350b:	83 c3 6c             	add    $0x6c,%ebx
8010350e:	8d 47 6c             	lea    0x6c(%edi),%eax
80103511:	83 c4 0c             	add    $0xc,%esp
80103514:	6a 10                	push   $0x10
80103516:	53                   	push   %ebx
80103517:	50                   	push   %eax
80103518:	e8 d2 09 00 00       	call   80103eef <safestrcpy>
  pid = np->pid;
8010351d:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103520:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103527:	e8 8f 07 00 00       	call   80103cbb <acquire>
  np->state = RUNNABLE;
8010352c:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103533:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010353a:	e8 e5 07 00 00       	call   80103d24 <release>
  return pid;
8010353f:	83 c4 10             	add    $0x10,%esp
}
80103542:	89 d8                	mov    %ebx,%eax
80103544:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103547:	5b                   	pop    %ebx
80103548:	5e                   	pop    %esi
80103549:	5f                   	pop    %edi
8010354a:	5d                   	pop    %ebp
8010354b:	c3                   	ret    
    return -1;
8010354c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103551:	eb ef                	jmp    80103542 <fork+0xfa>

80103553 <scheduler>:
{
80103553:	f3 0f 1e fb          	endbr32 
80103557:	55                   	push   %ebp
80103558:	89 e5                	mov    %esp,%ebp
8010355a:	56                   	push   %esi
8010355b:	53                   	push   %ebx
  struct cpu *c = mycpu();
8010355c:	e8 e5 fc ff ff       	call   80103246 <mycpu>
80103561:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103563:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010356a:	00 00 00 
8010356d:	eb 5a                	jmp    801035c9 <scheduler+0x76>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010356f:	83 c3 7c             	add    $0x7c,%ebx
80103572:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103578:	73 3f                	jae    801035b9 <scheduler+0x66>
      if(p->state != RUNNABLE)
8010357a:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010357e:	75 ef                	jne    8010356f <scheduler+0x1c>
      c->proc = p;
80103580:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103586:	83 ec 0c             	sub    $0xc,%esp
80103589:	53                   	push   %ebx
8010358a:	e8 ba 29 00 00       	call   80105f49 <switchuvm>
      p->state = RUNNING;
8010358f:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103596:	83 c4 08             	add    $0x8,%esp
80103599:	ff 73 1c             	pushl  0x1c(%ebx)
8010359c:	8d 46 04             	lea    0x4(%esi),%eax
8010359f:	50                   	push   %eax
801035a0:	e8 a7 09 00 00       	call   80103f4c <swtch>
      switchkvm();
801035a5:	e8 8d 29 00 00       	call   80105f37 <switchkvm>
      c->proc = 0;
801035aa:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801035b1:	00 00 00 
801035b4:	83 c4 10             	add    $0x10,%esp
801035b7:	eb b6                	jmp    8010356f <scheduler+0x1c>
    release(&ptable.lock);
801035b9:	83 ec 0c             	sub    $0xc,%esp
801035bc:	68 20 1d 11 80       	push   $0x80111d20
801035c1:	e8 5e 07 00 00       	call   80103d24 <release>
    sti();
801035c6:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801035c9:	fb                   	sti    
    acquire(&ptable.lock);
801035ca:	83 ec 0c             	sub    $0xc,%esp
801035cd:	68 20 1d 11 80       	push   $0x80111d20
801035d2:	e8 e4 06 00 00       	call   80103cbb <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801035d7:	83 c4 10             	add    $0x10,%esp
801035da:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801035df:	eb 91                	jmp    80103572 <scheduler+0x1f>

801035e1 <sched>:
{
801035e1:	f3 0f 1e fb          	endbr32 
801035e5:	55                   	push   %ebp
801035e6:	89 e5                	mov    %esp,%ebp
801035e8:	56                   	push   %esi
801035e9:	53                   	push   %ebx
  struct proc *p = myproc();
801035ea:	e8 d6 fc ff ff       	call   801032c5 <myproc>
801035ef:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 20 1d 11 80       	push   $0x80111d20
801035f9:	e8 79 06 00 00       	call   80103c77 <holding>
801035fe:	83 c4 10             	add    $0x10,%esp
80103601:	85 c0                	test   %eax,%eax
80103603:	74 4f                	je     80103654 <sched+0x73>
  if(mycpu()->ncli != 1)
80103605:	e8 3c fc ff ff       	call   80103246 <mycpu>
8010360a:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103611:	75 4e                	jne    80103661 <sched+0x80>
  if(p->state == RUNNING)
80103613:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103617:	74 55                	je     8010366e <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103619:	9c                   	pushf  
8010361a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010361b:	f6 c4 02             	test   $0x2,%ah
8010361e:	75 5b                	jne    8010367b <sched+0x9a>
  intena = mycpu()->intena;
80103620:	e8 21 fc ff ff       	call   80103246 <mycpu>
80103625:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010362b:	e8 16 fc ff ff       	call   80103246 <mycpu>
80103630:	83 ec 08             	sub    $0x8,%esp
80103633:	ff 70 04             	pushl  0x4(%eax)
80103636:	83 c3 1c             	add    $0x1c,%ebx
80103639:	53                   	push   %ebx
8010363a:	e8 0d 09 00 00       	call   80103f4c <swtch>
  mycpu()->intena = intena;
8010363f:	e8 02 fc ff ff       	call   80103246 <mycpu>
80103644:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010364a:	83 c4 10             	add    $0x10,%esp
8010364d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103650:	5b                   	pop    %ebx
80103651:	5e                   	pop    %esi
80103652:	5d                   	pop    %ebp
80103653:	c3                   	ret    
    panic("sched ptable.lock");
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	68 5b 6b 10 80       	push   $0x80106b5b
8010365c:	e8 fb cc ff ff       	call   8010035c <panic>
    panic("sched locks");
80103661:	83 ec 0c             	sub    $0xc,%esp
80103664:	68 6d 6b 10 80       	push   $0x80106b6d
80103669:	e8 ee cc ff ff       	call   8010035c <panic>
    panic("sched running");
8010366e:	83 ec 0c             	sub    $0xc,%esp
80103671:	68 79 6b 10 80       	push   $0x80106b79
80103676:	e8 e1 cc ff ff       	call   8010035c <panic>
    panic("sched interruptible");
8010367b:	83 ec 0c             	sub    $0xc,%esp
8010367e:	68 87 6b 10 80       	push   $0x80106b87
80103683:	e8 d4 cc ff ff       	call   8010035c <panic>

80103688 <exit>:
{
80103688:	f3 0f 1e fb          	endbr32 
8010368c:	55                   	push   %ebp
8010368d:	89 e5                	mov    %esp,%ebp
8010368f:	56                   	push   %esi
80103690:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103691:	e8 2f fc ff ff       	call   801032c5 <myproc>
  if(curproc == initproc)
80103696:	39 05 b8 95 10 80    	cmp    %eax,0x801095b8
8010369c:	74 09                	je     801036a7 <exit+0x1f>
8010369e:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
801036a0:	bb 00 00 00 00       	mov    $0x0,%ebx
801036a5:	eb 24                	jmp    801036cb <exit+0x43>
    panic("init exiting");
801036a7:	83 ec 0c             	sub    $0xc,%esp
801036aa:	68 9b 6b 10 80       	push   $0x80106b9b
801036af:	e8 a8 cc ff ff       	call   8010035c <panic>
      fileclose(curproc->ofile[fd]);
801036b4:	83 ec 0c             	sub    $0xc,%esp
801036b7:	50                   	push   %eax
801036b8:	e8 48 d6 ff ff       	call   80100d05 <fileclose>
      curproc->ofile[fd] = 0;
801036bd:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801036c4:	00 
801036c5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801036c8:	83 c3 01             	add    $0x1,%ebx
801036cb:	83 fb 0f             	cmp    $0xf,%ebx
801036ce:	7f 0a                	jg     801036da <exit+0x52>
    if(curproc->ofile[fd]){
801036d0:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
801036d4:	85 c0                	test   %eax,%eax
801036d6:	75 dc                	jne    801036b4 <exit+0x2c>
801036d8:	eb ee                	jmp    801036c8 <exit+0x40>
  begin_op();
801036da:	e8 70 f1 ff ff       	call   8010284f <begin_op>
  iput(curproc->cwd);
801036df:	83 ec 0c             	sub    $0xc,%esp
801036e2:	ff 76 68             	pushl  0x68(%esi)
801036e5:	e8 ef df ff ff       	call   801016d9 <iput>
  end_op();
801036ea:	e8 de f1 ff ff       	call   801028cd <end_op>
  curproc->cwd = 0;
801036ef:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801036f6:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801036fd:	e8 b9 05 00 00       	call   80103cbb <acquire>
  wakeup1(curproc->parent);
80103702:	8b 46 14             	mov    0x14(%esi),%eax
80103705:	e8 f2 f9 ff ff       	call   801030fc <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010370a:	83 c4 10             	add    $0x10,%esp
8010370d:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103712:	eb 03                	jmp    80103717 <exit+0x8f>
80103714:	83 c3 7c             	add    $0x7c,%ebx
80103717:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010371d:	73 1a                	jae    80103739 <exit+0xb1>
    if(p->parent == curproc){
8010371f:	39 73 14             	cmp    %esi,0x14(%ebx)
80103722:	75 f0                	jne    80103714 <exit+0x8c>
      p->parent = initproc;
80103724:	a1 b8 95 10 80       	mov    0x801095b8,%eax
80103729:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010372c:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103730:	75 e2                	jne    80103714 <exit+0x8c>
        wakeup1(initproc);
80103732:	e8 c5 f9 ff ff       	call   801030fc <wakeup1>
80103737:	eb db                	jmp    80103714 <exit+0x8c>
  curproc->state = ZOMBIE;
80103739:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103740:	e8 9c fe ff ff       	call   801035e1 <sched>
  panic("zombie exit");
80103745:	83 ec 0c             	sub    $0xc,%esp
80103748:	68 a8 6b 10 80       	push   $0x80106ba8
8010374d:	e8 0a cc ff ff       	call   8010035c <panic>

80103752 <yield>:
{
80103752:	f3 0f 1e fb          	endbr32 
80103756:	55                   	push   %ebp
80103757:	89 e5                	mov    %esp,%ebp
80103759:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010375c:	68 20 1d 11 80       	push   $0x80111d20
80103761:	e8 55 05 00 00       	call   80103cbb <acquire>
  myproc()->state = RUNNABLE;
80103766:	e8 5a fb ff ff       	call   801032c5 <myproc>
8010376b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103772:	e8 6a fe ff ff       	call   801035e1 <sched>
  release(&ptable.lock);
80103777:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010377e:	e8 a1 05 00 00       	call   80103d24 <release>
}
80103783:	83 c4 10             	add    $0x10,%esp
80103786:	c9                   	leave  
80103787:	c3                   	ret    

80103788 <sleep>:
{
80103788:	f3 0f 1e fb          	endbr32 
8010378c:	55                   	push   %ebp
8010378d:	89 e5                	mov    %esp,%ebp
8010378f:	56                   	push   %esi
80103790:	53                   	push   %ebx
80103791:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103794:	e8 2c fb ff ff       	call   801032c5 <myproc>
  if(p == 0)
80103799:	85 c0                	test   %eax,%eax
8010379b:	74 66                	je     80103803 <sleep+0x7b>
8010379d:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
8010379f:	85 f6                	test   %esi,%esi
801037a1:	74 6d                	je     80103810 <sleep+0x88>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801037a3:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801037a9:	74 18                	je     801037c3 <sleep+0x3b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801037ab:	83 ec 0c             	sub    $0xc,%esp
801037ae:	68 20 1d 11 80       	push   $0x80111d20
801037b3:	e8 03 05 00 00       	call   80103cbb <acquire>
    release(lk);
801037b8:	89 34 24             	mov    %esi,(%esp)
801037bb:	e8 64 05 00 00       	call   80103d24 <release>
801037c0:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
801037c3:	8b 45 08             	mov    0x8(%ebp),%eax
801037c6:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801037c9:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801037d0:	e8 0c fe ff ff       	call   801035e1 <sched>
  p->chan = 0;
801037d5:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
801037dc:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801037e2:	74 18                	je     801037fc <sleep+0x74>
    release(&ptable.lock);
801037e4:	83 ec 0c             	sub    $0xc,%esp
801037e7:	68 20 1d 11 80       	push   $0x80111d20
801037ec:	e8 33 05 00 00       	call   80103d24 <release>
    acquire(lk);
801037f1:	89 34 24             	mov    %esi,(%esp)
801037f4:	e8 c2 04 00 00       	call   80103cbb <acquire>
801037f9:	83 c4 10             	add    $0x10,%esp
}
801037fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037ff:	5b                   	pop    %ebx
80103800:	5e                   	pop    %esi
80103801:	5d                   	pop    %ebp
80103802:	c3                   	ret    
    panic("sleep");
80103803:	83 ec 0c             	sub    $0xc,%esp
80103806:	68 b4 6b 10 80       	push   $0x80106bb4
8010380b:	e8 4c cb ff ff       	call   8010035c <panic>
    panic("sleep without lk");
80103810:	83 ec 0c             	sub    $0xc,%esp
80103813:	68 ba 6b 10 80       	push   $0x80106bba
80103818:	e8 3f cb ff ff       	call   8010035c <panic>

8010381d <wait>:
{
8010381d:	f3 0f 1e fb          	endbr32 
80103821:	55                   	push   %ebp
80103822:	89 e5                	mov    %esp,%ebp
80103824:	56                   	push   %esi
80103825:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103826:	e8 9a fa ff ff       	call   801032c5 <myproc>
8010382b:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 20 1d 11 80       	push   $0x80111d20
80103835:	e8 81 04 00 00       	call   80103cbb <acquire>
8010383a:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010383d:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103842:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103847:	eb 5b                	jmp    801038a4 <wait+0x87>
        pid = p->pid;
80103849:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	ff 73 08             	pushl  0x8(%ebx)
80103852:	e8 d4 e7 ff ff       	call   8010202b <kfree>
        p->kstack = 0;
80103857:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010385e:	83 c4 04             	add    $0x4,%esp
80103861:	ff 73 04             	pushl  0x4(%ebx)
80103864:	e8 8b 2a 00 00       	call   801062f4 <freevm>
        p->pid = 0;
80103869:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103870:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103877:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010387b:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103882:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103889:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103890:	e8 8f 04 00 00       	call   80103d24 <release>
        return pid;
80103895:	83 c4 10             	add    $0x10,%esp
}
80103898:	89 f0                	mov    %esi,%eax
8010389a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010389d:	5b                   	pop    %ebx
8010389e:	5e                   	pop    %esi
8010389f:	5d                   	pop    %ebp
801038a0:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038a1:	83 c3 7c             	add    $0x7c,%ebx
801038a4:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801038aa:	73 12                	jae    801038be <wait+0xa1>
      if(p->parent != curproc)
801038ac:	39 73 14             	cmp    %esi,0x14(%ebx)
801038af:	75 f0                	jne    801038a1 <wait+0x84>
      if(p->state == ZOMBIE){
801038b1:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801038b5:	74 92                	je     80103849 <wait+0x2c>
      havekids = 1;
801038b7:	b8 01 00 00 00       	mov    $0x1,%eax
801038bc:	eb e3                	jmp    801038a1 <wait+0x84>
    if(!havekids || curproc->killed){
801038be:	85 c0                	test   %eax,%eax
801038c0:	74 06                	je     801038c8 <wait+0xab>
801038c2:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801038c6:	74 17                	je     801038df <wait+0xc2>
      release(&ptable.lock);
801038c8:	83 ec 0c             	sub    $0xc,%esp
801038cb:	68 20 1d 11 80       	push   $0x80111d20
801038d0:	e8 4f 04 00 00       	call   80103d24 <release>
      return -1;
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801038dd:	eb b9                	jmp    80103898 <wait+0x7b>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801038df:	83 ec 08             	sub    $0x8,%esp
801038e2:	68 20 1d 11 80       	push   $0x80111d20
801038e7:	56                   	push   %esi
801038e8:	e8 9b fe ff ff       	call   80103788 <sleep>
    havekids = 0;
801038ed:	83 c4 10             	add    $0x10,%esp
801038f0:	e9 48 ff ff ff       	jmp    8010383d <wait+0x20>

801038f5 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801038f5:	f3 0f 1e fb          	endbr32 
801038f9:	55                   	push   %ebp
801038fa:	89 e5                	mov    %esp,%ebp
801038fc:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801038ff:	68 20 1d 11 80       	push   $0x80111d20
80103904:	e8 b2 03 00 00       	call   80103cbb <acquire>
  wakeup1(chan);
80103909:	8b 45 08             	mov    0x8(%ebp),%eax
8010390c:	e8 eb f7 ff ff       	call   801030fc <wakeup1>
  release(&ptable.lock);
80103911:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103918:	e8 07 04 00 00       	call   80103d24 <release>
}
8010391d:	83 c4 10             	add    $0x10,%esp
80103920:	c9                   	leave  
80103921:	c3                   	ret    

80103922 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103922:	f3 0f 1e fb          	endbr32 
80103926:	55                   	push   %ebp
80103927:	89 e5                	mov    %esp,%ebp
80103929:	53                   	push   %ebx
8010392a:	83 ec 10             	sub    $0x10,%esp
8010392d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103930:	68 20 1d 11 80       	push   $0x80111d20
80103935:	e8 81 03 00 00       	call   80103cbb <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010393a:	83 c4 10             	add    $0x10,%esp
8010393d:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103942:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103947:	73 3a                	jae    80103983 <kill+0x61>
    if(p->pid == pid){
80103949:	39 58 10             	cmp    %ebx,0x10(%eax)
8010394c:	74 05                	je     80103953 <kill+0x31>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010394e:	83 c0 7c             	add    $0x7c,%eax
80103951:	eb ef                	jmp    80103942 <kill+0x20>
      p->killed = 1;
80103953:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010395a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010395e:	74 1a                	je     8010397a <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 20 1d 11 80       	push   $0x80111d20
80103968:	e8 b7 03 00 00       	call   80103d24 <release>
      return 0;
8010396d:	83 c4 10             	add    $0x10,%esp
80103970:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103978:	c9                   	leave  
80103979:	c3                   	ret    
        p->state = RUNNABLE;
8010397a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103981:	eb dd                	jmp    80103960 <kill+0x3e>
  release(&ptable.lock);
80103983:	83 ec 0c             	sub    $0xc,%esp
80103986:	68 20 1d 11 80       	push   $0x80111d20
8010398b:	e8 94 03 00 00       	call   80103d24 <release>
  return -1;
80103990:	83 c4 10             	add    $0x10,%esp
80103993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103998:	eb db                	jmp    80103975 <kill+0x53>

8010399a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010399a:	f3 0f 1e fb          	endbr32 
8010399e:	55                   	push   %ebp
8010399f:	89 e5                	mov    %esp,%ebp
801039a1:	56                   	push   %esi
801039a2:	53                   	push   %ebx
801039a3:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a6:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801039ab:	eb 33                	jmp    801039e0 <procdump+0x46>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
801039ad:	b8 cb 6b 10 80       	mov    $0x80106bcb,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801039b2:	8d 53 6c             	lea    0x6c(%ebx),%edx
801039b5:	52                   	push   %edx
801039b6:	50                   	push   %eax
801039b7:	ff 73 10             	pushl  0x10(%ebx)
801039ba:	68 cf 6b 10 80       	push   $0x80106bcf
801039bf:	e8 65 cc ff ff       	call   80100629 <cprintf>
    if(p->state == SLEEPING){
801039c4:	83 c4 10             	add    $0x10,%esp
801039c7:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801039cb:	74 39                	je     80103a06 <procdump+0x6c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801039cd:	83 ec 0c             	sub    $0xc,%esp
801039d0:	68 37 6f 10 80       	push   $0x80106f37
801039d5:	e8 4f cc ff ff       	call   80100629 <cprintf>
801039da:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039dd:	83 c3 7c             	add    $0x7c,%ebx
801039e0:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801039e6:	73 61                	jae    80103a49 <procdump+0xaf>
    if(p->state == UNUSED)
801039e8:	8b 43 0c             	mov    0xc(%ebx),%eax
801039eb:	85 c0                	test   %eax,%eax
801039ed:	74 ee                	je     801039dd <procdump+0x43>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801039ef:	83 f8 05             	cmp    $0x5,%eax
801039f2:	77 b9                	ja     801039ad <procdump+0x13>
801039f4:	8b 04 85 2c 6c 10 80 	mov    -0x7fef93d4(,%eax,4),%eax
801039fb:	85 c0                	test   %eax,%eax
801039fd:	75 b3                	jne    801039b2 <procdump+0x18>
      state = "???";
801039ff:	b8 cb 6b 10 80       	mov    $0x80106bcb,%eax
80103a04:	eb ac                	jmp    801039b2 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103a06:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a09:	8b 40 0c             	mov    0xc(%eax),%eax
80103a0c:	83 c0 08             	add    $0x8,%eax
80103a0f:	83 ec 08             	sub    $0x8,%esp
80103a12:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103a15:	52                   	push   %edx
80103a16:	50                   	push   %eax
80103a17:	e8 6e 01 00 00       	call   80103b8a <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a1c:	83 c4 10             	add    $0x10,%esp
80103a1f:	be 00 00 00 00       	mov    $0x0,%esi
80103a24:	eb 14                	jmp    80103a3a <procdump+0xa0>
        cprintf(" %p", pc[i]);
80103a26:	83 ec 08             	sub    $0x8,%esp
80103a29:	50                   	push   %eax
80103a2a:	68 21 66 10 80       	push   $0x80106621
80103a2f:	e8 f5 cb ff ff       	call   80100629 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a34:	83 c6 01             	add    $0x1,%esi
80103a37:	83 c4 10             	add    $0x10,%esp
80103a3a:	83 fe 09             	cmp    $0x9,%esi
80103a3d:	7f 8e                	jg     801039cd <procdump+0x33>
80103a3f:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103a43:	85 c0                	test   %eax,%eax
80103a45:	75 df                	jne    80103a26 <procdump+0x8c>
80103a47:	eb 84                	jmp    801039cd <procdump+0x33>
  }
}
80103a49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a4c:	5b                   	pop    %ebx
80103a4d:	5e                   	pop    %esi
80103a4e:	5d                   	pop    %ebp
80103a4f:	c3                   	ret    

80103a50 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103a50:	f3 0f 1e fb          	endbr32 
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	53                   	push   %ebx
80103a58:	83 ec 0c             	sub    $0xc,%esp
80103a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103a5e:	68 44 6c 10 80       	push   $0x80106c44
80103a63:	8d 43 04             	lea    0x4(%ebx),%eax
80103a66:	50                   	push   %eax
80103a67:	e8 ff 00 00 00       	call   80103b6b <initlock>
  lk->name = name;
80103a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a6f:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103a72:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a78:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103a7f:	83 c4 10             	add    $0x10,%esp
80103a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a85:	c9                   	leave  
80103a86:	c3                   	ret    

80103a87 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103a87:	f3 0f 1e fb          	endbr32 
80103a8b:	55                   	push   %ebp
80103a8c:	89 e5                	mov    %esp,%ebp
80103a8e:	56                   	push   %esi
80103a8f:	53                   	push   %ebx
80103a90:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103a93:	8d 73 04             	lea    0x4(%ebx),%esi
80103a96:	83 ec 0c             	sub    $0xc,%esp
80103a99:	56                   	push   %esi
80103a9a:	e8 1c 02 00 00       	call   80103cbb <acquire>
  while (lk->locked) {
80103a9f:	83 c4 10             	add    $0x10,%esp
80103aa2:	83 3b 00             	cmpl   $0x0,(%ebx)
80103aa5:	74 0f                	je     80103ab6 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80103aa7:	83 ec 08             	sub    $0x8,%esp
80103aaa:	56                   	push   %esi
80103aab:	53                   	push   %ebx
80103aac:	e8 d7 fc ff ff       	call   80103788 <sleep>
80103ab1:	83 c4 10             	add    $0x10,%esp
80103ab4:	eb ec                	jmp    80103aa2 <acquiresleep+0x1b>
  }
  lk->locked = 1;
80103ab6:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103abc:	e8 04 f8 ff ff       	call   801032c5 <myproc>
80103ac1:	8b 40 10             	mov    0x10(%eax),%eax
80103ac4:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103ac7:	83 ec 0c             	sub    $0xc,%esp
80103aca:	56                   	push   %esi
80103acb:	e8 54 02 00 00       	call   80103d24 <release>
}
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad6:	5b                   	pop    %ebx
80103ad7:	5e                   	pop    %esi
80103ad8:	5d                   	pop    %ebp
80103ad9:	c3                   	ret    

80103ada <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103ada:	f3 0f 1e fb          	endbr32 
80103ade:	55                   	push   %ebp
80103adf:	89 e5                	mov    %esp,%ebp
80103ae1:	56                   	push   %esi
80103ae2:	53                   	push   %ebx
80103ae3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103ae6:	8d 73 04             	lea    0x4(%ebx),%esi
80103ae9:	83 ec 0c             	sub    $0xc,%esp
80103aec:	56                   	push   %esi
80103aed:	e8 c9 01 00 00       	call   80103cbb <acquire>
  lk->locked = 0;
80103af2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103af8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103aff:	89 1c 24             	mov    %ebx,(%esp)
80103b02:	e8 ee fd ff ff       	call   801038f5 <wakeup>
  release(&lk->lk);
80103b07:	89 34 24             	mov    %esi,(%esp)
80103b0a:	e8 15 02 00 00       	call   80103d24 <release>
}
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b15:	5b                   	pop    %ebx
80103b16:	5e                   	pop    %esi
80103b17:	5d                   	pop    %ebp
80103b18:	c3                   	ret    

80103b19 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b19:	f3 0f 1e fb          	endbr32 
80103b1d:	55                   	push   %ebp
80103b1e:	89 e5                	mov    %esp,%ebp
80103b20:	56                   	push   %esi
80103b21:	53                   	push   %ebx
80103b22:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103b25:	8d 73 04             	lea    0x4(%ebx),%esi
80103b28:	83 ec 0c             	sub    $0xc,%esp
80103b2b:	56                   	push   %esi
80103b2c:	e8 8a 01 00 00       	call   80103cbb <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103b31:	83 c4 10             	add    $0x10,%esp
80103b34:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b37:	75 17                	jne    80103b50 <holdingsleep+0x37>
80103b39:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103b3e:	83 ec 0c             	sub    $0xc,%esp
80103b41:	56                   	push   %esi
80103b42:	e8 dd 01 00 00       	call   80103d24 <release>
  return r;
}
80103b47:	89 d8                	mov    %ebx,%eax
80103b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b4c:	5b                   	pop    %ebx
80103b4d:	5e                   	pop    %esi
80103b4e:	5d                   	pop    %ebp
80103b4f:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103b50:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103b53:	e8 6d f7 ff ff       	call   801032c5 <myproc>
80103b58:	3b 58 10             	cmp    0x10(%eax),%ebx
80103b5b:	74 07                	je     80103b64 <holdingsleep+0x4b>
80103b5d:	bb 00 00 00 00       	mov    $0x0,%ebx
80103b62:	eb da                	jmp    80103b3e <holdingsleep+0x25>
80103b64:	bb 01 00 00 00       	mov    $0x1,%ebx
80103b69:	eb d3                	jmp    80103b3e <holdingsleep+0x25>

80103b6b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103b6b:	f3 0f 1e fb          	endbr32 
80103b6f:	55                   	push   %ebp
80103b70:	89 e5                	mov    %esp,%ebp
80103b72:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103b75:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b78:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103b81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103b88:	5d                   	pop    %ebp
80103b89:	c3                   	ret    

80103b8a <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103b8a:	f3 0f 1e fb          	endbr32 
80103b8e:	55                   	push   %ebp
80103b8f:	89 e5                	mov    %esp,%ebp
80103b91:	53                   	push   %ebx
80103b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103b95:	8b 45 08             	mov    0x8(%ebp),%eax
80103b98:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103b9b:	b8 00 00 00 00       	mov    $0x0,%eax
80103ba0:	83 f8 09             	cmp    $0x9,%eax
80103ba3:	7f 25                	jg     80103bca <getcallerpcs+0x40>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103ba5:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103bab:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103bb1:	77 17                	ja     80103bca <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103bb3:	8b 5a 04             	mov    0x4(%edx),%ebx
80103bb6:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103bb9:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103bbb:	83 c0 01             	add    $0x1,%eax
80103bbe:	eb e0                	jmp    80103ba0 <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103bc0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103bc7:	83 c0 01             	add    $0x1,%eax
80103bca:	83 f8 09             	cmp    $0x9,%eax
80103bcd:	7e f1                	jle    80103bc0 <getcallerpcs+0x36>
}
80103bcf:	5b                   	pop    %ebx
80103bd0:	5d                   	pop    %ebp
80103bd1:	c3                   	ret    

80103bd2 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103bd2:	f3 0f 1e fb          	endbr32 
80103bd6:	55                   	push   %ebp
80103bd7:	89 e5                	mov    %esp,%ebp
80103bd9:	53                   	push   %ebx
80103bda:	83 ec 04             	sub    $0x4,%esp
80103bdd:	9c                   	pushf  
80103bde:	5b                   	pop    %ebx
  asm volatile("cli");
80103bdf:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103be0:	e8 61 f6 ff ff       	call   80103246 <mycpu>
80103be5:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103bec:	74 12                	je     80103c00 <pushcli+0x2e>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103bee:	e8 53 f6 ff ff       	call   80103246 <mycpu>
80103bf3:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103bfa:	83 c4 04             	add    $0x4,%esp
80103bfd:	5b                   	pop    %ebx
80103bfe:	5d                   	pop    %ebp
80103bff:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c00:	e8 41 f6 ff ff       	call   80103246 <mycpu>
80103c05:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c0b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103c11:	eb db                	jmp    80103bee <pushcli+0x1c>

80103c13 <popcli>:

void
popcli(void)
{
80103c13:	f3 0f 1e fb          	endbr32 
80103c17:	55                   	push   %ebp
80103c18:	89 e5                	mov    %esp,%ebp
80103c1a:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c1d:	9c                   	pushf  
80103c1e:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c1f:	f6 c4 02             	test   $0x2,%ah
80103c22:	75 28                	jne    80103c4c <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103c24:	e8 1d f6 ff ff       	call   80103246 <mycpu>
80103c29:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103c2f:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103c32:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103c38:	85 d2                	test   %edx,%edx
80103c3a:	78 1d                	js     80103c59 <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c3c:	e8 05 f6 ff ff       	call   80103246 <mycpu>
80103c41:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c48:	74 1c                	je     80103c66 <popcli+0x53>
    sti();
}
80103c4a:	c9                   	leave  
80103c4b:	c3                   	ret    
    panic("popcli - interruptible");
80103c4c:	83 ec 0c             	sub    $0xc,%esp
80103c4f:	68 4f 6c 10 80       	push   $0x80106c4f
80103c54:	e8 03 c7 ff ff       	call   8010035c <panic>
    panic("popcli");
80103c59:	83 ec 0c             	sub    $0xc,%esp
80103c5c:	68 66 6c 10 80       	push   $0x80106c66
80103c61:	e8 f6 c6 ff ff       	call   8010035c <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c66:	e8 db f5 ff ff       	call   80103246 <mycpu>
80103c6b:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103c72:	74 d6                	je     80103c4a <popcli+0x37>
  asm volatile("sti");
80103c74:	fb                   	sti    
}
80103c75:	eb d3                	jmp    80103c4a <popcli+0x37>

80103c77 <holding>:
{
80103c77:	f3 0f 1e fb          	endbr32 
80103c7b:	55                   	push   %ebp
80103c7c:	89 e5                	mov    %esp,%ebp
80103c7e:	53                   	push   %ebx
80103c7f:	83 ec 04             	sub    $0x4,%esp
80103c82:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103c85:	e8 48 ff ff ff       	call   80103bd2 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103c8a:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c8d:	75 12                	jne    80103ca1 <holding+0x2a>
80103c8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103c94:	e8 7a ff ff ff       	call   80103c13 <popcli>
}
80103c99:	89 d8                	mov    %ebx,%eax
80103c9b:	83 c4 04             	add    $0x4,%esp
80103c9e:	5b                   	pop    %ebx
80103c9f:	5d                   	pop    %ebp
80103ca0:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103ca1:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103ca4:	e8 9d f5 ff ff       	call   80103246 <mycpu>
80103ca9:	39 c3                	cmp    %eax,%ebx
80103cab:	74 07                	je     80103cb4 <holding+0x3d>
80103cad:	bb 00 00 00 00       	mov    $0x0,%ebx
80103cb2:	eb e0                	jmp    80103c94 <holding+0x1d>
80103cb4:	bb 01 00 00 00       	mov    $0x1,%ebx
80103cb9:	eb d9                	jmp    80103c94 <holding+0x1d>

80103cbb <acquire>:
{
80103cbb:	f3 0f 1e fb          	endbr32 
80103cbf:	55                   	push   %ebp
80103cc0:	89 e5                	mov    %esp,%ebp
80103cc2:	53                   	push   %ebx
80103cc3:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103cc6:	e8 07 ff ff ff       	call   80103bd2 <pushcli>
  if(holding(lk))
80103ccb:	83 ec 0c             	sub    $0xc,%esp
80103cce:	ff 75 08             	pushl  0x8(%ebp)
80103cd1:	e8 a1 ff ff ff       	call   80103c77 <holding>
80103cd6:	83 c4 10             	add    $0x10,%esp
80103cd9:	85 c0                	test   %eax,%eax
80103cdb:	75 3a                	jne    80103d17 <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
80103cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103ce0:	b8 01 00 00 00       	mov    $0x1,%eax
80103ce5:	f0 87 02             	lock xchg %eax,(%edx)
80103ce8:	85 c0                	test   %eax,%eax
80103cea:	75 f1                	jne    80103cdd <acquire+0x22>
  __sync_synchronize();
80103cec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103cf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cf4:	e8 4d f5 ff ff       	call   80103246 <mycpu>
80103cf9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103cff:	83 c0 0c             	add    $0xc,%eax
80103d02:	83 ec 08             	sub    $0x8,%esp
80103d05:	50                   	push   %eax
80103d06:	8d 45 08             	lea    0x8(%ebp),%eax
80103d09:	50                   	push   %eax
80103d0a:	e8 7b fe ff ff       	call   80103b8a <getcallerpcs>
}
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d15:	c9                   	leave  
80103d16:	c3                   	ret    
    panic("acquire");
80103d17:	83 ec 0c             	sub    $0xc,%esp
80103d1a:	68 6d 6c 10 80       	push   $0x80106c6d
80103d1f:	e8 38 c6 ff ff       	call   8010035c <panic>

80103d24 <release>:
{
80103d24:	f3 0f 1e fb          	endbr32 
80103d28:	55                   	push   %ebp
80103d29:	89 e5                	mov    %esp,%ebp
80103d2b:	53                   	push   %ebx
80103d2c:	83 ec 10             	sub    $0x10,%esp
80103d2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d32:	53                   	push   %ebx
80103d33:	e8 3f ff ff ff       	call   80103c77 <holding>
80103d38:	83 c4 10             	add    $0x10,%esp
80103d3b:	85 c0                	test   %eax,%eax
80103d3d:	74 23                	je     80103d62 <release+0x3e>
  lk->pcs[0] = 0;
80103d3f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103d46:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103d4d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103d52:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103d58:	e8 b6 fe ff ff       	call   80103c13 <popcli>
}
80103d5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d60:	c9                   	leave  
80103d61:	c3                   	ret    
    panic("release");
80103d62:	83 ec 0c             	sub    $0xc,%esp
80103d65:	68 75 6c 10 80       	push   $0x80106c75
80103d6a:	e8 ed c5 ff ff       	call   8010035c <panic>

80103d6f <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d6f:	f3 0f 1e fb          	endbr32 
80103d73:	55                   	push   %ebp
80103d74:	89 e5                	mov    %esp,%ebp
80103d76:	57                   	push   %edi
80103d77:	53                   	push   %ebx
80103d78:	8b 55 08             	mov    0x8(%ebp),%edx
80103d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103d81:	f6 c2 03             	test   $0x3,%dl
80103d84:	75 25                	jne    80103dab <memset+0x3c>
80103d86:	f6 c1 03             	test   $0x3,%cl
80103d89:	75 20                	jne    80103dab <memset+0x3c>
    c &= 0xFF;
80103d8b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103d8e:	c1 e9 02             	shr    $0x2,%ecx
80103d91:	c1 e0 18             	shl    $0x18,%eax
80103d94:	89 fb                	mov    %edi,%ebx
80103d96:	c1 e3 10             	shl    $0x10,%ebx
80103d99:	09 d8                	or     %ebx,%eax
80103d9b:	89 fb                	mov    %edi,%ebx
80103d9d:	c1 e3 08             	shl    $0x8,%ebx
80103da0:	09 d8                	or     %ebx,%eax
80103da2:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103da4:	89 d7                	mov    %edx,%edi
80103da6:	fc                   	cld    
80103da7:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103da9:	eb 05                	jmp    80103db0 <memset+0x41>
  asm volatile("cld; rep stosb" :
80103dab:	89 d7                	mov    %edx,%edi
80103dad:	fc                   	cld    
80103dae:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103db0:	89 d0                	mov    %edx,%eax
80103db2:	5b                   	pop    %ebx
80103db3:	5f                   	pop    %edi
80103db4:	5d                   	pop    %ebp
80103db5:	c3                   	ret    

80103db6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103db6:	f3 0f 1e fb          	endbr32 
80103dba:	55                   	push   %ebp
80103dbb:	89 e5                	mov    %esp,%ebp
80103dbd:	56                   	push   %esi
80103dbe:	53                   	push   %ebx
80103dbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103dc8:	8d 70 ff             	lea    -0x1(%eax),%esi
80103dcb:	85 c0                	test   %eax,%eax
80103dcd:	74 1c                	je     80103deb <memcmp+0x35>
    if(*s1 != *s2)
80103dcf:	0f b6 01             	movzbl (%ecx),%eax
80103dd2:	0f b6 1a             	movzbl (%edx),%ebx
80103dd5:	38 d8                	cmp    %bl,%al
80103dd7:	75 0a                	jne    80103de3 <memcmp+0x2d>
      return *s1 - *s2;
    s1++, s2++;
80103dd9:	83 c1 01             	add    $0x1,%ecx
80103ddc:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80103ddf:	89 f0                	mov    %esi,%eax
80103de1:	eb e5                	jmp    80103dc8 <memcmp+0x12>
      return *s1 - *s2;
80103de3:	0f b6 c0             	movzbl %al,%eax
80103de6:	0f b6 db             	movzbl %bl,%ebx
80103de9:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103deb:	5b                   	pop    %ebx
80103dec:	5e                   	pop    %esi
80103ded:	5d                   	pop    %ebp
80103dee:	c3                   	ret    

80103def <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103def:	f3 0f 1e fb          	endbr32 
80103df3:	55                   	push   %ebp
80103df4:	89 e5                	mov    %esp,%ebp
80103df6:	56                   	push   %esi
80103df7:	53                   	push   %ebx
80103df8:	8b 75 08             	mov    0x8(%ebp),%esi
80103dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103e01:	39 f2                	cmp    %esi,%edx
80103e03:	73 3a                	jae    80103e3f <memmove+0x50>
80103e05:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103e08:	39 f1                	cmp    %esi,%ecx
80103e0a:	76 37                	jbe    80103e43 <memmove+0x54>
    s += n;
    d += n;
80103e0c:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103e0f:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e12:	85 c0                	test   %eax,%eax
80103e14:	74 23                	je     80103e39 <memmove+0x4a>
      *--d = *--s;
80103e16:	83 e9 01             	sub    $0x1,%ecx
80103e19:	83 ea 01             	sub    $0x1,%edx
80103e1c:	0f b6 01             	movzbl (%ecx),%eax
80103e1f:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103e21:	89 d8                	mov    %ebx,%eax
80103e23:	eb ea                	jmp    80103e0f <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103e25:	0f b6 02             	movzbl (%edx),%eax
80103e28:	88 01                	mov    %al,(%ecx)
80103e2a:	8d 49 01             	lea    0x1(%ecx),%ecx
80103e2d:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103e30:	89 d8                	mov    %ebx,%eax
80103e32:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e35:	85 c0                	test   %eax,%eax
80103e37:	75 ec                	jne    80103e25 <memmove+0x36>

  return dst;
}
80103e39:	89 f0                	mov    %esi,%eax
80103e3b:	5b                   	pop    %ebx
80103e3c:	5e                   	pop    %esi
80103e3d:	5d                   	pop    %ebp
80103e3e:	c3                   	ret    
80103e3f:	89 f1                	mov    %esi,%ecx
80103e41:	eb ef                	jmp    80103e32 <memmove+0x43>
80103e43:	89 f1                	mov    %esi,%ecx
80103e45:	eb eb                	jmp    80103e32 <memmove+0x43>

80103e47 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103e47:	f3 0f 1e fb          	endbr32 
80103e4b:	55                   	push   %ebp
80103e4c:	89 e5                	mov    %esp,%ebp
80103e4e:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103e51:	ff 75 10             	pushl  0x10(%ebp)
80103e54:	ff 75 0c             	pushl  0xc(%ebp)
80103e57:	ff 75 08             	pushl  0x8(%ebp)
80103e5a:	e8 90 ff ff ff       	call   80103def <memmove>
}
80103e5f:	c9                   	leave  
80103e60:	c3                   	ret    

80103e61 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103e61:	f3 0f 1e fb          	endbr32 
80103e65:	55                   	push   %ebp
80103e66:	89 e5                	mov    %esp,%ebp
80103e68:	53                   	push   %ebx
80103e69:	8b 55 08             	mov    0x8(%ebp),%edx
80103e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103e72:	eb 09                	jmp    80103e7d <strncmp+0x1c>
    n--, p++, q++;
80103e74:	83 e8 01             	sub    $0x1,%eax
80103e77:	83 c2 01             	add    $0x1,%edx
80103e7a:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80103e7d:	85 c0                	test   %eax,%eax
80103e7f:	74 0b                	je     80103e8c <strncmp+0x2b>
80103e81:	0f b6 1a             	movzbl (%edx),%ebx
80103e84:	84 db                	test   %bl,%bl
80103e86:	74 04                	je     80103e8c <strncmp+0x2b>
80103e88:	3a 19                	cmp    (%ecx),%bl
80103e8a:	74 e8                	je     80103e74 <strncmp+0x13>
  if(n == 0)
80103e8c:	85 c0                	test   %eax,%eax
80103e8e:	74 0b                	je     80103e9b <strncmp+0x3a>
    return 0;
  return (uchar)*p - (uchar)*q;
80103e90:	0f b6 02             	movzbl (%edx),%eax
80103e93:	0f b6 11             	movzbl (%ecx),%edx
80103e96:	29 d0                	sub    %edx,%eax
}
80103e98:	5b                   	pop    %ebx
80103e99:	5d                   	pop    %ebp
80103e9a:	c3                   	ret    
    return 0;
80103e9b:	b8 00 00 00 00       	mov    $0x0,%eax
80103ea0:	eb f6                	jmp    80103e98 <strncmp+0x37>

80103ea2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103ea2:	f3 0f 1e fb          	endbr32 
80103ea6:	55                   	push   %ebp
80103ea7:	89 e5                	mov    %esp,%ebp
80103ea9:	57                   	push   %edi
80103eaa:	56                   	push   %esi
80103eab:	53                   	push   %ebx
80103eac:	8b 7d 08             	mov    0x8(%ebp),%edi
80103eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103eb5:	89 fa                	mov    %edi,%edx
80103eb7:	eb 04                	jmp    80103ebd <strncpy+0x1b>
80103eb9:	89 f1                	mov    %esi,%ecx
80103ebb:	89 da                	mov    %ebx,%edx
80103ebd:	89 c3                	mov    %eax,%ebx
80103ebf:	83 e8 01             	sub    $0x1,%eax
80103ec2:	85 db                	test   %ebx,%ebx
80103ec4:	7e 1b                	jle    80103ee1 <strncpy+0x3f>
80103ec6:	8d 71 01             	lea    0x1(%ecx),%esi
80103ec9:	8d 5a 01             	lea    0x1(%edx),%ebx
80103ecc:	0f b6 09             	movzbl (%ecx),%ecx
80103ecf:	88 0a                	mov    %cl,(%edx)
80103ed1:	84 c9                	test   %cl,%cl
80103ed3:	75 e4                	jne    80103eb9 <strncpy+0x17>
80103ed5:	89 da                	mov    %ebx,%edx
80103ed7:	eb 08                	jmp    80103ee1 <strncpy+0x3f>
    ;
  while(n-- > 0)
    *s++ = 0;
80103ed9:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
80103edc:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
80103ede:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
80103ee1:	8d 48 ff             	lea    -0x1(%eax),%ecx
80103ee4:	85 c0                	test   %eax,%eax
80103ee6:	7f f1                	jg     80103ed9 <strncpy+0x37>
  return os;
}
80103ee8:	89 f8                	mov    %edi,%eax
80103eea:	5b                   	pop    %ebx
80103eeb:	5e                   	pop    %esi
80103eec:	5f                   	pop    %edi
80103eed:	5d                   	pop    %ebp
80103eee:	c3                   	ret    

80103eef <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103eef:	f3 0f 1e fb          	endbr32 
80103ef3:	55                   	push   %ebp
80103ef4:	89 e5                	mov    %esp,%ebp
80103ef6:	57                   	push   %edi
80103ef7:	56                   	push   %esi
80103ef8:	53                   	push   %ebx
80103ef9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103eff:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80103f02:	85 c0                	test   %eax,%eax
80103f04:	7e 23                	jle    80103f29 <safestrcpy+0x3a>
80103f06:	89 fa                	mov    %edi,%edx
80103f08:	eb 04                	jmp    80103f0e <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103f0a:	89 f1                	mov    %esi,%ecx
80103f0c:	89 da                	mov    %ebx,%edx
80103f0e:	83 e8 01             	sub    $0x1,%eax
80103f11:	85 c0                	test   %eax,%eax
80103f13:	7e 11                	jle    80103f26 <safestrcpy+0x37>
80103f15:	8d 71 01             	lea    0x1(%ecx),%esi
80103f18:	8d 5a 01             	lea    0x1(%edx),%ebx
80103f1b:	0f b6 09             	movzbl (%ecx),%ecx
80103f1e:	88 0a                	mov    %cl,(%edx)
80103f20:	84 c9                	test   %cl,%cl
80103f22:	75 e6                	jne    80103f0a <safestrcpy+0x1b>
80103f24:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
80103f26:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80103f29:	89 f8                	mov    %edi,%eax
80103f2b:	5b                   	pop    %ebx
80103f2c:	5e                   	pop    %esi
80103f2d:	5f                   	pop    %edi
80103f2e:	5d                   	pop    %ebp
80103f2f:	c3                   	ret    

80103f30 <strlen>:

int
strlen(const char *s)
{
80103f30:	f3 0f 1e fb          	endbr32 
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103f3a:	b8 00 00 00 00       	mov    $0x0,%eax
80103f3f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f43:	74 05                	je     80103f4a <strlen+0x1a>
80103f45:	83 c0 01             	add    $0x1,%eax
80103f48:	eb f5                	jmp    80103f3f <strlen+0xf>
    ;
  return n;
}
80103f4a:	5d                   	pop    %ebp
80103f4b:	c3                   	ret    

80103f4c <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103f4c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103f50:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103f54:	55                   	push   %ebp
  pushl %ebx
80103f55:	53                   	push   %ebx
  pushl %esi
80103f56:	56                   	push   %esi
  pushl %edi
80103f57:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103f58:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103f5a:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103f5c:	5f                   	pop    %edi
  popl %esi
80103f5d:	5e                   	pop    %esi
  popl %ebx
80103f5e:	5b                   	pop    %ebx
  popl %ebp
80103f5f:	5d                   	pop    %ebp
  ret
80103f60:	c3                   	ret    

80103f61 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103f61:	f3 0f 1e fb          	endbr32 
80103f65:	55                   	push   %ebp
80103f66:	89 e5                	mov    %esp,%ebp
80103f68:	53                   	push   %ebx
80103f69:	83 ec 04             	sub    $0x4,%esp
80103f6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103f6f:	e8 51 f3 ff ff       	call   801032c5 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103f74:	8b 00                	mov    (%eax),%eax
80103f76:	39 d8                	cmp    %ebx,%eax
80103f78:	76 19                	jbe    80103f93 <fetchint+0x32>
80103f7a:	8d 53 04             	lea    0x4(%ebx),%edx
80103f7d:	39 d0                	cmp    %edx,%eax
80103f7f:	72 19                	jb     80103f9a <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
80103f81:	8b 13                	mov    (%ebx),%edx
80103f83:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f86:	89 10                	mov    %edx,(%eax)
  return 0;
80103f88:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f8d:	83 c4 04             	add    $0x4,%esp
80103f90:	5b                   	pop    %ebx
80103f91:	5d                   	pop    %ebp
80103f92:	c3                   	ret    
    return -1;
80103f93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f98:	eb f3                	jmp    80103f8d <fetchint+0x2c>
80103f9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f9f:	eb ec                	jmp    80103f8d <fetchint+0x2c>

80103fa1 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103fa1:	f3 0f 1e fb          	endbr32 
80103fa5:	55                   	push   %ebp
80103fa6:	89 e5                	mov    %esp,%ebp
80103fa8:	53                   	push   %ebx
80103fa9:	83 ec 04             	sub    $0x4,%esp
80103fac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103faf:	e8 11 f3 ff ff       	call   801032c5 <myproc>

  if(addr >= curproc->sz)
80103fb4:	39 18                	cmp    %ebx,(%eax)
80103fb6:	76 26                	jbe    80103fde <fetchstr+0x3d>
    return -1;
  *pp = (char*)addr;
80103fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fbb:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103fbd:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103fbf:	89 d8                	mov    %ebx,%eax
80103fc1:	39 d0                	cmp    %edx,%eax
80103fc3:	73 0e                	jae    80103fd3 <fetchstr+0x32>
    if(*s == 0)
80103fc5:	80 38 00             	cmpb   $0x0,(%eax)
80103fc8:	74 05                	je     80103fcf <fetchstr+0x2e>
  for(s = *pp; s < ep; s++){
80103fca:	83 c0 01             	add    $0x1,%eax
80103fcd:	eb f2                	jmp    80103fc1 <fetchstr+0x20>
      return s - *pp;
80103fcf:	29 d8                	sub    %ebx,%eax
80103fd1:	eb 05                	jmp    80103fd8 <fetchstr+0x37>
  }
  return -1;
80103fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fd8:	83 c4 04             	add    $0x4,%esp
80103fdb:	5b                   	pop    %ebx
80103fdc:	5d                   	pop    %ebp
80103fdd:	c3                   	ret    
    return -1;
80103fde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fe3:	eb f3                	jmp    80103fd8 <fetchstr+0x37>

80103fe5 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103fe5:	f3 0f 1e fb          	endbr32 
80103fe9:	55                   	push   %ebp
80103fea:	89 e5                	mov    %esp,%ebp
80103fec:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103fef:	e8 d1 f2 ff ff       	call   801032c5 <myproc>
80103ff4:	8b 50 18             	mov    0x18(%eax),%edx
80103ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffa:	c1 e0 02             	shl    $0x2,%eax
80103ffd:	03 42 44             	add    0x44(%edx),%eax
80104000:	83 ec 08             	sub    $0x8,%esp
80104003:	ff 75 0c             	pushl  0xc(%ebp)
80104006:	83 c0 04             	add    $0x4,%eax
80104009:	50                   	push   %eax
8010400a:	e8 52 ff ff ff       	call   80103f61 <fetchint>
}
8010400f:	c9                   	leave  
80104010:	c3                   	ret    

80104011 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104011:	f3 0f 1e fb          	endbr32 
80104015:	55                   	push   %ebp
80104016:	89 e5                	mov    %esp,%ebp
80104018:	56                   	push   %esi
80104019:	53                   	push   %ebx
8010401a:	83 ec 10             	sub    $0x10,%esp
8010401d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104020:	e8 a0 f2 ff ff       	call   801032c5 <myproc>
80104025:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104027:	83 ec 08             	sub    $0x8,%esp
8010402a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010402d:	50                   	push   %eax
8010402e:	ff 75 08             	pushl  0x8(%ebp)
80104031:	e8 af ff ff ff       	call   80103fe5 <argint>
80104036:	83 c4 10             	add    $0x10,%esp
80104039:	85 c0                	test   %eax,%eax
8010403b:	78 24                	js     80104061 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010403d:	85 db                	test   %ebx,%ebx
8010403f:	78 27                	js     80104068 <argptr+0x57>
80104041:	8b 16                	mov    (%esi),%edx
80104043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104046:	39 c2                	cmp    %eax,%edx
80104048:	76 25                	jbe    8010406f <argptr+0x5e>
8010404a:	01 c3                	add    %eax,%ebx
8010404c:	39 da                	cmp    %ebx,%edx
8010404e:	72 26                	jb     80104076 <argptr+0x65>
    return -1;
  *pp = (char*)i;
80104050:	8b 55 0c             	mov    0xc(%ebp),%edx
80104053:	89 02                	mov    %eax,(%edx)
  return 0;
80104055:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010405a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010405d:	5b                   	pop    %ebx
8010405e:	5e                   	pop    %esi
8010405f:	5d                   	pop    %ebp
80104060:	c3                   	ret    
    return -1;
80104061:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104066:	eb f2                	jmp    8010405a <argptr+0x49>
    return -1;
80104068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010406d:	eb eb                	jmp    8010405a <argptr+0x49>
8010406f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104074:	eb e4                	jmp    8010405a <argptr+0x49>
80104076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010407b:	eb dd                	jmp    8010405a <argptr+0x49>

8010407d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010407d:	f3 0f 1e fb          	endbr32 
80104081:	55                   	push   %ebp
80104082:	89 e5                	mov    %esp,%ebp
80104084:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104087:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010408a:	50                   	push   %eax
8010408b:	ff 75 08             	pushl  0x8(%ebp)
8010408e:	e8 52 ff ff ff       	call   80103fe5 <argint>
80104093:	83 c4 10             	add    $0x10,%esp
80104096:	85 c0                	test   %eax,%eax
80104098:	78 13                	js     801040ad <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010409a:	83 ec 08             	sub    $0x8,%esp
8010409d:	ff 75 0c             	pushl  0xc(%ebp)
801040a0:	ff 75 f4             	pushl  -0xc(%ebp)
801040a3:	e8 f9 fe ff ff       	call   80103fa1 <fetchstr>
801040a8:	83 c4 10             	add    $0x10,%esp
}
801040ab:	c9                   	leave  
801040ac:	c3                   	ret    
    return -1;
801040ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040b2:	eb f7                	jmp    801040ab <argstr+0x2e>

801040b4 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801040b4:	f3 0f 1e fb          	endbr32 
801040b8:	55                   	push   %ebp
801040b9:	89 e5                	mov    %esp,%ebp
801040bb:	53                   	push   %ebx
801040bc:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801040bf:	e8 01 f2 ff ff       	call   801032c5 <myproc>
801040c4:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801040c6:	8b 40 18             	mov    0x18(%eax),%eax
801040c9:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801040cc:	8d 50 ff             	lea    -0x1(%eax),%edx
801040cf:	83 fa 14             	cmp    $0x14,%edx
801040d2:	77 17                	ja     801040eb <syscall+0x37>
801040d4:	8b 14 85 a0 6c 10 80 	mov    -0x7fef9360(,%eax,4),%edx
801040db:	85 d2                	test   %edx,%edx
801040dd:	74 0c                	je     801040eb <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
801040df:	ff d2                	call   *%edx
801040e1:	89 c2                	mov    %eax,%edx
801040e3:	8b 43 18             	mov    0x18(%ebx),%eax
801040e6:	89 50 1c             	mov    %edx,0x1c(%eax)
801040e9:	eb 1f                	jmp    8010410a <syscall+0x56>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801040eb:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
801040ee:	50                   	push   %eax
801040ef:	52                   	push   %edx
801040f0:	ff 73 10             	pushl  0x10(%ebx)
801040f3:	68 7d 6c 10 80       	push   $0x80106c7d
801040f8:	e8 2c c5 ff ff       	call   80100629 <cprintf>
    curproc->tf->eax = -1;
801040fd:	8b 43 18             	mov    0x18(%ebx),%eax
80104100:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104107:	83 c4 10             	add    $0x10,%esp
  }
}
8010410a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010410d:	c9                   	leave  
8010410e:	c3                   	ret    

8010410f <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010410f:	55                   	push   %ebp
80104110:	89 e5                	mov    %esp,%ebp
80104112:	56                   	push   %esi
80104113:	53                   	push   %ebx
80104114:	83 ec 18             	sub    $0x18,%esp
80104117:	89 d6                	mov    %edx,%esi
80104119:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010411b:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010411e:	52                   	push   %edx
8010411f:	50                   	push   %eax
80104120:	e8 c0 fe ff ff       	call   80103fe5 <argint>
80104125:	83 c4 10             	add    $0x10,%esp
80104128:	85 c0                	test   %eax,%eax
8010412a:	78 35                	js     80104161 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010412c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104130:	77 28                	ja     8010415a <argfd+0x4b>
80104132:	e8 8e f1 ff ff       	call   801032c5 <myproc>
80104137:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010413a:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
8010413e:	85 c0                	test   %eax,%eax
80104140:	74 18                	je     8010415a <argfd+0x4b>
    return -1;
  if(pfd)
80104142:	85 f6                	test   %esi,%esi
80104144:	74 02                	je     80104148 <argfd+0x39>
    *pfd = fd;
80104146:	89 16                	mov    %edx,(%esi)
  if(pf)
80104148:	85 db                	test   %ebx,%ebx
8010414a:	74 1c                	je     80104168 <argfd+0x59>
    *pf = f;
8010414c:	89 03                	mov    %eax,(%ebx)
  return 0;
8010414e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104153:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104156:	5b                   	pop    %ebx
80104157:	5e                   	pop    %esi
80104158:	5d                   	pop    %ebp
80104159:	c3                   	ret    
    return -1;
8010415a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010415f:	eb f2                	jmp    80104153 <argfd+0x44>
    return -1;
80104161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104166:	eb eb                	jmp    80104153 <argfd+0x44>
  return 0;
80104168:	b8 00 00 00 00       	mov    $0x0,%eax
8010416d:	eb e4                	jmp    80104153 <argfd+0x44>

8010416f <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010416f:	55                   	push   %ebp
80104170:	89 e5                	mov    %esp,%ebp
80104172:	53                   	push   %ebx
80104173:	83 ec 04             	sub    $0x4,%esp
80104176:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104178:	e8 48 f1 ff ff       	call   801032c5 <myproc>
8010417d:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
8010417f:	b8 00 00 00 00       	mov    $0x0,%eax
80104184:	83 f8 0f             	cmp    $0xf,%eax
80104187:	7f 12                	jg     8010419b <fdalloc+0x2c>
    if(curproc->ofile[fd] == 0){
80104189:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
8010418e:	74 05                	je     80104195 <fdalloc+0x26>
  for(fd = 0; fd < NOFILE; fd++){
80104190:	83 c0 01             	add    $0x1,%eax
80104193:	eb ef                	jmp    80104184 <fdalloc+0x15>
      curproc->ofile[fd] = f;
80104195:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104199:	eb 05                	jmp    801041a0 <fdalloc+0x31>
    }
  }
  return -1;
8010419b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041a0:	83 c4 04             	add    $0x4,%esp
801041a3:	5b                   	pop    %ebx
801041a4:	5d                   	pop    %ebp
801041a5:	c3                   	ret    

801041a6 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801041a6:	55                   	push   %ebp
801041a7:	89 e5                	mov    %esp,%ebp
801041a9:	56                   	push   %esi
801041aa:	53                   	push   %ebx
801041ab:	83 ec 10             	sub    $0x10,%esp
801041ae:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801041b0:	b8 20 00 00 00       	mov    $0x20,%eax
801041b5:	89 c6                	mov    %eax,%esi
801041b7:	39 43 58             	cmp    %eax,0x58(%ebx)
801041ba:	76 2e                	jbe    801041ea <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801041bc:	6a 10                	push   $0x10
801041be:	50                   	push   %eax
801041bf:	8d 45 e8             	lea    -0x18(%ebp),%eax
801041c2:	50                   	push   %eax
801041c3:	53                   	push   %ebx
801041c4:	e8 07 d6 ff ff       	call   801017d0 <readi>
801041c9:	83 c4 10             	add    $0x10,%esp
801041cc:	83 f8 10             	cmp    $0x10,%eax
801041cf:	75 0c                	jne    801041dd <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
801041d1:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
801041d6:	75 1e                	jne    801041f6 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801041d8:	8d 46 10             	lea    0x10(%esi),%eax
801041db:	eb d8                	jmp    801041b5 <isdirempty+0xf>
      panic("isdirempty: readi");
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 f8 6c 10 80       	push   $0x80106cf8
801041e5:	e8 72 c1 ff ff       	call   8010035c <panic>
      return 0;
  }
  return 1;
801041ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
801041ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041f2:	5b                   	pop    %ebx
801041f3:	5e                   	pop    %esi
801041f4:	5d                   	pop    %ebp
801041f5:	c3                   	ret    
      return 0;
801041f6:	b8 00 00 00 00       	mov    $0x0,%eax
801041fb:	eb f2                	jmp    801041ef <isdirempty+0x49>

801041fd <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801041fd:	55                   	push   %ebp
801041fe:	89 e5                	mov    %esp,%ebp
80104200:	57                   	push   %edi
80104201:	56                   	push   %esi
80104202:	53                   	push   %ebx
80104203:	83 ec 34             	sub    $0x34,%esp
80104206:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104209:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010420c:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010420f:	8d 55 da             	lea    -0x26(%ebp),%edx
80104212:	52                   	push   %edx
80104213:	50                   	push   %eax
80104214:	e8 52 da ff ff       	call   80101c6b <nameiparent>
80104219:	89 c6                	mov    %eax,%esi
8010421b:	83 c4 10             	add    $0x10,%esp
8010421e:	85 c0                	test   %eax,%eax
80104220:	0f 84 33 01 00 00    	je     80104359 <create+0x15c>
    return 0;
  ilock(dp);
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	50                   	push   %eax
8010422a:	e8 9b d3 ff ff       	call   801015ca <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010422f:	83 c4 0c             	add    $0xc,%esp
80104232:	6a 00                	push   $0x0
80104234:	8d 45 da             	lea    -0x26(%ebp),%eax
80104237:	50                   	push   %eax
80104238:	56                   	push   %esi
80104239:	e8 db d7 ff ff       	call   80101a19 <dirlookup>
8010423e:	89 c3                	mov    %eax,%ebx
80104240:	83 c4 10             	add    $0x10,%esp
80104243:	85 c0                	test   %eax,%eax
80104245:	74 3d                	je     80104284 <create+0x87>
    iunlockput(dp);
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	56                   	push   %esi
8010424b:	e8 2d d5 ff ff       	call   8010177d <iunlockput>
    ilock(ip);
80104250:	89 1c 24             	mov    %ebx,(%esp)
80104253:	e8 72 d3 ff ff       	call   801015ca <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104258:	83 c4 10             	add    $0x10,%esp
8010425b:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104260:	75 07                	jne    80104269 <create+0x6c>
80104262:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104267:	74 11                	je     8010427a <create+0x7d>
      return ip;
    iunlockput(ip);
80104269:	83 ec 0c             	sub    $0xc,%esp
8010426c:	53                   	push   %ebx
8010426d:	e8 0b d5 ff ff       	call   8010177d <iunlockput>
    return 0;
80104272:	83 c4 10             	add    $0x10,%esp
80104275:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010427a:	89 d8                	mov    %ebx,%eax
8010427c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010427f:	5b                   	pop    %ebx
80104280:	5e                   	pop    %esi
80104281:	5f                   	pop    %edi
80104282:	5d                   	pop    %ebp
80104283:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104284:	83 ec 08             	sub    $0x8,%esp
80104287:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
8010428b:	50                   	push   %eax
8010428c:	ff 36                	pushl  (%esi)
8010428e:	e8 28 d1 ff ff       	call   801013bb <ialloc>
80104293:	89 c3                	mov    %eax,%ebx
80104295:	83 c4 10             	add    $0x10,%esp
80104298:	85 c0                	test   %eax,%eax
8010429a:	74 52                	je     801042ee <create+0xf1>
  ilock(ip);
8010429c:	83 ec 0c             	sub    $0xc,%esp
8010429f:	50                   	push   %eax
801042a0:	e8 25 d3 ff ff       	call   801015ca <ilock>
  ip->major = major;
801042a5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801042a9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801042ad:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
801042b1:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
801042b7:	89 1c 24             	mov    %ebx,(%esp)
801042ba:	e8 a2 d1 ff ff       	call   80101461 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801042bf:	83 c4 10             	add    $0x10,%esp
801042c2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801042c7:	74 32                	je     801042fb <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
801042c9:	83 ec 04             	sub    $0x4,%esp
801042cc:	ff 73 04             	pushl  0x4(%ebx)
801042cf:	8d 45 da             	lea    -0x26(%ebp),%eax
801042d2:	50                   	push   %eax
801042d3:	56                   	push   %esi
801042d4:	e8 c1 d8 ff ff       	call   80101b9a <dirlink>
801042d9:	83 c4 10             	add    $0x10,%esp
801042dc:	85 c0                	test   %eax,%eax
801042de:	78 6c                	js     8010434c <create+0x14f>
  iunlockput(dp);
801042e0:	83 ec 0c             	sub    $0xc,%esp
801042e3:	56                   	push   %esi
801042e4:	e8 94 d4 ff ff       	call   8010177d <iunlockput>
  return ip;
801042e9:	83 c4 10             	add    $0x10,%esp
801042ec:	eb 8c                	jmp    8010427a <create+0x7d>
    panic("create: ialloc");
801042ee:	83 ec 0c             	sub    $0xc,%esp
801042f1:	68 0a 6d 10 80       	push   $0x80106d0a
801042f6:	e8 61 c0 ff ff       	call   8010035c <panic>
    dp->nlink++;  // for ".."
801042fb:	0f b7 46 56          	movzwl 0x56(%esi),%eax
801042ff:	83 c0 01             	add    $0x1,%eax
80104302:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	56                   	push   %esi
8010430a:	e8 52 d1 ff ff       	call   80101461 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010430f:	83 c4 0c             	add    $0xc,%esp
80104312:	ff 73 04             	pushl  0x4(%ebx)
80104315:	68 1a 6d 10 80       	push   $0x80106d1a
8010431a:	53                   	push   %ebx
8010431b:	e8 7a d8 ff ff       	call   80101b9a <dirlink>
80104320:	83 c4 10             	add    $0x10,%esp
80104323:	85 c0                	test   %eax,%eax
80104325:	78 18                	js     8010433f <create+0x142>
80104327:	83 ec 04             	sub    $0x4,%esp
8010432a:	ff 76 04             	pushl  0x4(%esi)
8010432d:	68 19 6d 10 80       	push   $0x80106d19
80104332:	53                   	push   %ebx
80104333:	e8 62 d8 ff ff       	call   80101b9a <dirlink>
80104338:	83 c4 10             	add    $0x10,%esp
8010433b:	85 c0                	test   %eax,%eax
8010433d:	79 8a                	jns    801042c9 <create+0xcc>
      panic("create dots");
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	68 1c 6d 10 80       	push   $0x80106d1c
80104347:	e8 10 c0 ff ff       	call   8010035c <panic>
    panic("create: dirlink");
8010434c:	83 ec 0c             	sub    $0xc,%esp
8010434f:	68 28 6d 10 80       	push   $0x80106d28
80104354:	e8 03 c0 ff ff       	call   8010035c <panic>
    return 0;
80104359:	89 c3                	mov    %eax,%ebx
8010435b:	e9 1a ff ff ff       	jmp    8010427a <create+0x7d>

80104360 <sys_dup>:
{
80104360:	f3 0f 1e fb          	endbr32 
80104364:	55                   	push   %ebp
80104365:	89 e5                	mov    %esp,%ebp
80104367:	53                   	push   %ebx
80104368:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010436b:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010436e:	ba 00 00 00 00       	mov    $0x0,%edx
80104373:	b8 00 00 00 00       	mov    $0x0,%eax
80104378:	e8 92 fd ff ff       	call   8010410f <argfd>
8010437d:	85 c0                	test   %eax,%eax
8010437f:	78 23                	js     801043a4 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
80104381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104384:	e8 e6 fd ff ff       	call   8010416f <fdalloc>
80104389:	89 c3                	mov    %eax,%ebx
8010438b:	85 c0                	test   %eax,%eax
8010438d:	78 1c                	js     801043ab <sys_dup+0x4b>
  filedup(f);
8010438f:	83 ec 0c             	sub    $0xc,%esp
80104392:	ff 75 f4             	pushl  -0xc(%ebp)
80104395:	e8 22 c9 ff ff       	call   80100cbc <filedup>
  return fd;
8010439a:	83 c4 10             	add    $0x10,%esp
}
8010439d:	89 d8                	mov    %ebx,%eax
8010439f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a2:	c9                   	leave  
801043a3:	c3                   	ret    
    return -1;
801043a4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043a9:	eb f2                	jmp    8010439d <sys_dup+0x3d>
    return -1;
801043ab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043b0:	eb eb                	jmp    8010439d <sys_dup+0x3d>

801043b2 <sys_read>:
{
801043b2:	f3 0f 1e fb          	endbr32 
801043b6:	55                   	push   %ebp
801043b7:	89 e5                	mov    %esp,%ebp
801043b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801043bc:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043bf:	ba 00 00 00 00       	mov    $0x0,%edx
801043c4:	b8 00 00 00 00       	mov    $0x0,%eax
801043c9:	e8 41 fd ff ff       	call   8010410f <argfd>
801043ce:	85 c0                	test   %eax,%eax
801043d0:	78 43                	js     80104415 <sys_read+0x63>
801043d2:	83 ec 08             	sub    $0x8,%esp
801043d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043d8:	50                   	push   %eax
801043d9:	6a 02                	push   $0x2
801043db:	e8 05 fc ff ff       	call   80103fe5 <argint>
801043e0:	83 c4 10             	add    $0x10,%esp
801043e3:	85 c0                	test   %eax,%eax
801043e5:	78 2e                	js     80104415 <sys_read+0x63>
801043e7:	83 ec 04             	sub    $0x4,%esp
801043ea:	ff 75 f0             	pushl  -0x10(%ebp)
801043ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
801043f0:	50                   	push   %eax
801043f1:	6a 01                	push   $0x1
801043f3:	e8 19 fc ff ff       	call   80104011 <argptr>
801043f8:	83 c4 10             	add    $0x10,%esp
801043fb:	85 c0                	test   %eax,%eax
801043fd:	78 16                	js     80104415 <sys_read+0x63>
  return fileread(f, p, n);
801043ff:	83 ec 04             	sub    $0x4,%esp
80104402:	ff 75 f0             	pushl  -0x10(%ebp)
80104405:	ff 75 ec             	pushl  -0x14(%ebp)
80104408:	ff 75 f4             	pushl  -0xc(%ebp)
8010440b:	e8 fe c9 ff ff       	call   80100e0e <fileread>
80104410:	83 c4 10             	add    $0x10,%esp
}
80104413:	c9                   	leave  
80104414:	c3                   	ret    
    return -1;
80104415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441a:	eb f7                	jmp    80104413 <sys_read+0x61>

8010441c <sys_write>:
{
8010441c:	f3 0f 1e fb          	endbr32 
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104426:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104429:	ba 00 00 00 00       	mov    $0x0,%edx
8010442e:	b8 00 00 00 00       	mov    $0x0,%eax
80104433:	e8 d7 fc ff ff       	call   8010410f <argfd>
80104438:	85 c0                	test   %eax,%eax
8010443a:	78 43                	js     8010447f <sys_write+0x63>
8010443c:	83 ec 08             	sub    $0x8,%esp
8010443f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104442:	50                   	push   %eax
80104443:	6a 02                	push   $0x2
80104445:	e8 9b fb ff ff       	call   80103fe5 <argint>
8010444a:	83 c4 10             	add    $0x10,%esp
8010444d:	85 c0                	test   %eax,%eax
8010444f:	78 2e                	js     8010447f <sys_write+0x63>
80104451:	83 ec 04             	sub    $0x4,%esp
80104454:	ff 75 f0             	pushl  -0x10(%ebp)
80104457:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010445a:	50                   	push   %eax
8010445b:	6a 01                	push   $0x1
8010445d:	e8 af fb ff ff       	call   80104011 <argptr>
80104462:	83 c4 10             	add    $0x10,%esp
80104465:	85 c0                	test   %eax,%eax
80104467:	78 16                	js     8010447f <sys_write+0x63>
  return filewrite(f, p, n);
80104469:	83 ec 04             	sub    $0x4,%esp
8010446c:	ff 75 f0             	pushl  -0x10(%ebp)
8010446f:	ff 75 ec             	pushl  -0x14(%ebp)
80104472:	ff 75 f4             	pushl  -0xc(%ebp)
80104475:	e8 1d ca ff ff       	call   80100e97 <filewrite>
8010447a:	83 c4 10             	add    $0x10,%esp
}
8010447d:	c9                   	leave  
8010447e:	c3                   	ret    
    return -1;
8010447f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104484:	eb f7                	jmp    8010447d <sys_write+0x61>

80104486 <sys_close>:
{
80104486:	f3 0f 1e fb          	endbr32 
8010448a:	55                   	push   %ebp
8010448b:	89 e5                	mov    %esp,%ebp
8010448d:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104490:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104493:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104496:	b8 00 00 00 00       	mov    $0x0,%eax
8010449b:	e8 6f fc ff ff       	call   8010410f <argfd>
801044a0:	85 c0                	test   %eax,%eax
801044a2:	78 25                	js     801044c9 <sys_close+0x43>
  myproc()->ofile[fd] = 0;
801044a4:	e8 1c ee ff ff       	call   801032c5 <myproc>
801044a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044ac:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801044b3:	00 
  fileclose(f);
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	ff 75 f0             	pushl  -0x10(%ebp)
801044ba:	e8 46 c8 ff ff       	call   80100d05 <fileclose>
  return 0;
801044bf:	83 c4 10             	add    $0x10,%esp
801044c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044c7:	c9                   	leave  
801044c8:	c3                   	ret    
    return -1;
801044c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044ce:	eb f7                	jmp    801044c7 <sys_close+0x41>

801044d0 <sys_fstat>:
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801044da:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044dd:	ba 00 00 00 00       	mov    $0x0,%edx
801044e2:	b8 00 00 00 00       	mov    $0x0,%eax
801044e7:	e8 23 fc ff ff       	call   8010410f <argfd>
801044ec:	85 c0                	test   %eax,%eax
801044ee:	78 2a                	js     8010451a <sys_fstat+0x4a>
801044f0:	83 ec 04             	sub    $0x4,%esp
801044f3:	6a 14                	push   $0x14
801044f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044f8:	50                   	push   %eax
801044f9:	6a 01                	push   $0x1
801044fb:	e8 11 fb ff ff       	call   80104011 <argptr>
80104500:	83 c4 10             	add    $0x10,%esp
80104503:	85 c0                	test   %eax,%eax
80104505:	78 13                	js     8010451a <sys_fstat+0x4a>
  return filestat(f, st);
80104507:	83 ec 08             	sub    $0x8,%esp
8010450a:	ff 75 f0             	pushl  -0x10(%ebp)
8010450d:	ff 75 f4             	pushl  -0xc(%ebp)
80104510:	e8 ae c8 ff ff       	call   80100dc3 <filestat>
80104515:	83 c4 10             	add    $0x10,%esp
}
80104518:	c9                   	leave  
80104519:	c3                   	ret    
    return -1;
8010451a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010451f:	eb f7                	jmp    80104518 <sys_fstat+0x48>

80104521 <sys_link>:
{
80104521:	f3 0f 1e fb          	endbr32 
80104525:	55                   	push   %ebp
80104526:	89 e5                	mov    %esp,%ebp
80104528:	56                   	push   %esi
80104529:	53                   	push   %ebx
8010452a:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010452d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104530:	50                   	push   %eax
80104531:	6a 00                	push   $0x0
80104533:	e8 45 fb ff ff       	call   8010407d <argstr>
80104538:	83 c4 10             	add    $0x10,%esp
8010453b:	85 c0                	test   %eax,%eax
8010453d:	0f 88 d3 00 00 00    	js     80104616 <sys_link+0xf5>
80104543:	83 ec 08             	sub    $0x8,%esp
80104546:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104549:	50                   	push   %eax
8010454a:	6a 01                	push   $0x1
8010454c:	e8 2c fb ff ff       	call   8010407d <argstr>
80104551:	83 c4 10             	add    $0x10,%esp
80104554:	85 c0                	test   %eax,%eax
80104556:	0f 88 ba 00 00 00    	js     80104616 <sys_link+0xf5>
  begin_op();
8010455c:	e8 ee e2 ff ff       	call   8010284f <begin_op>
  if((ip = namei(old)) == 0){
80104561:	83 ec 0c             	sub    $0xc,%esp
80104564:	ff 75 e0             	pushl  -0x20(%ebp)
80104567:	e8 e3 d6 ff ff       	call   80101c4f <namei>
8010456c:	89 c3                	mov    %eax,%ebx
8010456e:	83 c4 10             	add    $0x10,%esp
80104571:	85 c0                	test   %eax,%eax
80104573:	0f 84 a4 00 00 00    	je     8010461d <sys_link+0xfc>
  ilock(ip);
80104579:	83 ec 0c             	sub    $0xc,%esp
8010457c:	50                   	push   %eax
8010457d:	e8 48 d0 ff ff       	call   801015ca <ilock>
  if(ip->type == T_DIR){
80104582:	83 c4 10             	add    $0x10,%esp
80104585:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010458a:	0f 84 99 00 00 00    	je     80104629 <sys_link+0x108>
  ip->nlink++;
80104590:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104594:	83 c0 01             	add    $0x1,%eax
80104597:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010459b:	83 ec 0c             	sub    $0xc,%esp
8010459e:	53                   	push   %ebx
8010459f:	e8 bd ce ff ff       	call   80101461 <iupdate>
  iunlock(ip);
801045a4:	89 1c 24             	mov    %ebx,(%esp)
801045a7:	e8 e4 d0 ff ff       	call   80101690 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801045ac:	83 c4 08             	add    $0x8,%esp
801045af:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045b2:	50                   	push   %eax
801045b3:	ff 75 e4             	pushl  -0x1c(%ebp)
801045b6:	e8 b0 d6 ff ff       	call   80101c6b <nameiparent>
801045bb:	89 c6                	mov    %eax,%esi
801045bd:	83 c4 10             	add    $0x10,%esp
801045c0:	85 c0                	test   %eax,%eax
801045c2:	0f 84 85 00 00 00    	je     8010464d <sys_link+0x12c>
  ilock(dp);
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	50                   	push   %eax
801045cc:	e8 f9 cf ff ff       	call   801015ca <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801045d1:	83 c4 10             	add    $0x10,%esp
801045d4:	8b 03                	mov    (%ebx),%eax
801045d6:	39 06                	cmp    %eax,(%esi)
801045d8:	75 67                	jne    80104641 <sys_link+0x120>
801045da:	83 ec 04             	sub    $0x4,%esp
801045dd:	ff 73 04             	pushl  0x4(%ebx)
801045e0:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045e3:	50                   	push   %eax
801045e4:	56                   	push   %esi
801045e5:	e8 b0 d5 ff ff       	call   80101b9a <dirlink>
801045ea:	83 c4 10             	add    $0x10,%esp
801045ed:	85 c0                	test   %eax,%eax
801045ef:	78 50                	js     80104641 <sys_link+0x120>
  iunlockput(dp);
801045f1:	83 ec 0c             	sub    $0xc,%esp
801045f4:	56                   	push   %esi
801045f5:	e8 83 d1 ff ff       	call   8010177d <iunlockput>
  iput(ip);
801045fa:	89 1c 24             	mov    %ebx,(%esp)
801045fd:	e8 d7 d0 ff ff       	call   801016d9 <iput>
  end_op();
80104602:	e8 c6 e2 ff ff       	call   801028cd <end_op>
  return 0;
80104607:	83 c4 10             	add    $0x10,%esp
8010460a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010460f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104612:	5b                   	pop    %ebx
80104613:	5e                   	pop    %esi
80104614:	5d                   	pop    %ebp
80104615:	c3                   	ret    
    return -1;
80104616:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010461b:	eb f2                	jmp    8010460f <sys_link+0xee>
    end_op();
8010461d:	e8 ab e2 ff ff       	call   801028cd <end_op>
    return -1;
80104622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104627:	eb e6                	jmp    8010460f <sys_link+0xee>
    iunlockput(ip);
80104629:	83 ec 0c             	sub    $0xc,%esp
8010462c:	53                   	push   %ebx
8010462d:	e8 4b d1 ff ff       	call   8010177d <iunlockput>
    end_op();
80104632:	e8 96 e2 ff ff       	call   801028cd <end_op>
    return -1;
80104637:	83 c4 10             	add    $0x10,%esp
8010463a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010463f:	eb ce                	jmp    8010460f <sys_link+0xee>
    iunlockput(dp);
80104641:	83 ec 0c             	sub    $0xc,%esp
80104644:	56                   	push   %esi
80104645:	e8 33 d1 ff ff       	call   8010177d <iunlockput>
    goto bad;
8010464a:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010464d:	83 ec 0c             	sub    $0xc,%esp
80104650:	53                   	push   %ebx
80104651:	e8 74 cf ff ff       	call   801015ca <ilock>
  ip->nlink--;
80104656:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
8010465a:	83 e8 01             	sub    $0x1,%eax
8010465d:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104661:	89 1c 24             	mov    %ebx,(%esp)
80104664:	e8 f8 cd ff ff       	call   80101461 <iupdate>
  iunlockput(ip);
80104669:	89 1c 24             	mov    %ebx,(%esp)
8010466c:	e8 0c d1 ff ff       	call   8010177d <iunlockput>
  end_op();
80104671:	e8 57 e2 ff ff       	call   801028cd <end_op>
  return -1;
80104676:	83 c4 10             	add    $0x10,%esp
80104679:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010467e:	eb 8f                	jmp    8010460f <sys_link+0xee>

80104680 <sys_unlink>:
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	57                   	push   %edi
80104688:	56                   	push   %esi
80104689:	53                   	push   %ebx
8010468a:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010468d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104690:	50                   	push   %eax
80104691:	6a 00                	push   $0x0
80104693:	e8 e5 f9 ff ff       	call   8010407d <argstr>
80104698:	83 c4 10             	add    $0x10,%esp
8010469b:	85 c0                	test   %eax,%eax
8010469d:	0f 88 83 01 00 00    	js     80104826 <sys_unlink+0x1a6>
  begin_op();
801046a3:	e8 a7 e1 ff ff       	call   8010284f <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801046a8:	83 ec 08             	sub    $0x8,%esp
801046ab:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046ae:	50                   	push   %eax
801046af:	ff 75 c4             	pushl  -0x3c(%ebp)
801046b2:	e8 b4 d5 ff ff       	call   80101c6b <nameiparent>
801046b7:	89 c6                	mov    %eax,%esi
801046b9:	83 c4 10             	add    $0x10,%esp
801046bc:	85 c0                	test   %eax,%eax
801046be:	0f 84 ed 00 00 00    	je     801047b1 <sys_unlink+0x131>
  ilock(dp);
801046c4:	83 ec 0c             	sub    $0xc,%esp
801046c7:	50                   	push   %eax
801046c8:	e8 fd ce ff ff       	call   801015ca <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801046cd:	83 c4 08             	add    $0x8,%esp
801046d0:	68 1a 6d 10 80       	push   $0x80106d1a
801046d5:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046d8:	50                   	push   %eax
801046d9:	e8 22 d3 ff ff       	call   80101a00 <namecmp>
801046de:	83 c4 10             	add    $0x10,%esp
801046e1:	85 c0                	test   %eax,%eax
801046e3:	0f 84 fc 00 00 00    	je     801047e5 <sys_unlink+0x165>
801046e9:	83 ec 08             	sub    $0x8,%esp
801046ec:	68 19 6d 10 80       	push   $0x80106d19
801046f1:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046f4:	50                   	push   %eax
801046f5:	e8 06 d3 ff ff       	call   80101a00 <namecmp>
801046fa:	83 c4 10             	add    $0x10,%esp
801046fd:	85 c0                	test   %eax,%eax
801046ff:	0f 84 e0 00 00 00    	je     801047e5 <sys_unlink+0x165>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104705:	83 ec 04             	sub    $0x4,%esp
80104708:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010470b:	50                   	push   %eax
8010470c:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010470f:	50                   	push   %eax
80104710:	56                   	push   %esi
80104711:	e8 03 d3 ff ff       	call   80101a19 <dirlookup>
80104716:	89 c3                	mov    %eax,%ebx
80104718:	83 c4 10             	add    $0x10,%esp
8010471b:	85 c0                	test   %eax,%eax
8010471d:	0f 84 c2 00 00 00    	je     801047e5 <sys_unlink+0x165>
  ilock(ip);
80104723:	83 ec 0c             	sub    $0xc,%esp
80104726:	50                   	push   %eax
80104727:	e8 9e ce ff ff       	call   801015ca <ilock>
  if(ip->nlink < 1)
8010472c:	83 c4 10             	add    $0x10,%esp
8010472f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104734:	0f 8e 83 00 00 00    	jle    801047bd <sys_unlink+0x13d>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010473a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010473f:	0f 84 85 00 00 00    	je     801047ca <sys_unlink+0x14a>
  memset(&de, 0, sizeof(de));
80104745:	83 ec 04             	sub    $0x4,%esp
80104748:	6a 10                	push   $0x10
8010474a:	6a 00                	push   $0x0
8010474c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010474f:	57                   	push   %edi
80104750:	e8 1a f6 ff ff       	call   80103d6f <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104755:	6a 10                	push   $0x10
80104757:	ff 75 c0             	pushl  -0x40(%ebp)
8010475a:	57                   	push   %edi
8010475b:	56                   	push   %esi
8010475c:	e8 70 d1 ff ff       	call   801018d1 <writei>
80104761:	83 c4 20             	add    $0x20,%esp
80104764:	83 f8 10             	cmp    $0x10,%eax
80104767:	0f 85 90 00 00 00    	jne    801047fd <sys_unlink+0x17d>
  if(ip->type == T_DIR){
8010476d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104772:	0f 84 92 00 00 00    	je     8010480a <sys_unlink+0x18a>
  iunlockput(dp);
80104778:	83 ec 0c             	sub    $0xc,%esp
8010477b:	56                   	push   %esi
8010477c:	e8 fc cf ff ff       	call   8010177d <iunlockput>
  ip->nlink--;
80104781:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104785:	83 e8 01             	sub    $0x1,%eax
80104788:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010478c:	89 1c 24             	mov    %ebx,(%esp)
8010478f:	e8 cd cc ff ff       	call   80101461 <iupdate>
  iunlockput(ip);
80104794:	89 1c 24             	mov    %ebx,(%esp)
80104797:	e8 e1 cf ff ff       	call   8010177d <iunlockput>
  end_op();
8010479c:	e8 2c e1 ff ff       	call   801028cd <end_op>
  return 0;
801047a1:	83 c4 10             	add    $0x10,%esp
801047a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ac:	5b                   	pop    %ebx
801047ad:	5e                   	pop    %esi
801047ae:	5f                   	pop    %edi
801047af:	5d                   	pop    %ebp
801047b0:	c3                   	ret    
    end_op();
801047b1:	e8 17 e1 ff ff       	call   801028cd <end_op>
    return -1;
801047b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047bb:	eb ec                	jmp    801047a9 <sys_unlink+0x129>
    panic("unlink: nlink < 1");
801047bd:	83 ec 0c             	sub    $0xc,%esp
801047c0:	68 38 6d 10 80       	push   $0x80106d38
801047c5:	e8 92 bb ff ff       	call   8010035c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047ca:	89 d8                	mov    %ebx,%eax
801047cc:	e8 d5 f9 ff ff       	call   801041a6 <isdirempty>
801047d1:	85 c0                	test   %eax,%eax
801047d3:	0f 85 6c ff ff ff    	jne    80104745 <sys_unlink+0xc5>
    iunlockput(ip);
801047d9:	83 ec 0c             	sub    $0xc,%esp
801047dc:	53                   	push   %ebx
801047dd:	e8 9b cf ff ff       	call   8010177d <iunlockput>
    goto bad;
801047e2:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801047e5:	83 ec 0c             	sub    $0xc,%esp
801047e8:	56                   	push   %esi
801047e9:	e8 8f cf ff ff       	call   8010177d <iunlockput>
  end_op();
801047ee:	e8 da e0 ff ff       	call   801028cd <end_op>
  return -1;
801047f3:	83 c4 10             	add    $0x10,%esp
801047f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047fb:	eb ac                	jmp    801047a9 <sys_unlink+0x129>
    panic("unlink: writei");
801047fd:	83 ec 0c             	sub    $0xc,%esp
80104800:	68 4a 6d 10 80       	push   $0x80106d4a
80104805:	e8 52 bb ff ff       	call   8010035c <panic>
    dp->nlink--;
8010480a:	0f b7 46 56          	movzwl 0x56(%esi),%eax
8010480e:	83 e8 01             	sub    $0x1,%eax
80104811:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104815:	83 ec 0c             	sub    $0xc,%esp
80104818:	56                   	push   %esi
80104819:	e8 43 cc ff ff       	call   80101461 <iupdate>
8010481e:	83 c4 10             	add    $0x10,%esp
80104821:	e9 52 ff ff ff       	jmp    80104778 <sys_unlink+0xf8>
    return -1;
80104826:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010482b:	e9 79 ff ff ff       	jmp    801047a9 <sys_unlink+0x129>

80104830 <sys_open>:

int
sys_open(void)
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	56                   	push   %esi
80104839:	53                   	push   %ebx
8010483a:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010483d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104840:	50                   	push   %eax
80104841:	6a 00                	push   $0x0
80104843:	e8 35 f8 ff ff       	call   8010407d <argstr>
80104848:	83 c4 10             	add    $0x10,%esp
8010484b:	85 c0                	test   %eax,%eax
8010484d:	0f 88 a0 00 00 00    	js     801048f3 <sys_open+0xc3>
80104853:	83 ec 08             	sub    $0x8,%esp
80104856:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104859:	50                   	push   %eax
8010485a:	6a 01                	push   $0x1
8010485c:	e8 84 f7 ff ff       	call   80103fe5 <argint>
80104861:	83 c4 10             	add    $0x10,%esp
80104864:	85 c0                	test   %eax,%eax
80104866:	0f 88 87 00 00 00    	js     801048f3 <sys_open+0xc3>
    return -1;

  begin_op();
8010486c:	e8 de df ff ff       	call   8010284f <begin_op>

  if(omode & O_CREATE){
80104871:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104875:	0f 84 8b 00 00 00    	je     80104906 <sys_open+0xd6>
    ip = create(path, T_FILE, 0, 0);
8010487b:	83 ec 0c             	sub    $0xc,%esp
8010487e:	6a 00                	push   $0x0
80104880:	b9 00 00 00 00       	mov    $0x0,%ecx
80104885:	ba 02 00 00 00       	mov    $0x2,%edx
8010488a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010488d:	e8 6b f9 ff ff       	call   801041fd <create>
80104892:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104894:	83 c4 10             	add    $0x10,%esp
80104897:	85 c0                	test   %eax,%eax
80104899:	74 5f                	je     801048fa <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010489b:	e8 b7 c3 ff ff       	call   80100c57 <filealloc>
801048a0:	89 c3                	mov    %eax,%ebx
801048a2:	85 c0                	test   %eax,%eax
801048a4:	0f 84 b5 00 00 00    	je     8010495f <sys_open+0x12f>
801048aa:	e8 c0 f8 ff ff       	call   8010416f <fdalloc>
801048af:	89 c7                	mov    %eax,%edi
801048b1:	85 c0                	test   %eax,%eax
801048b3:	0f 88 a6 00 00 00    	js     8010495f <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801048b9:	83 ec 0c             	sub    $0xc,%esp
801048bc:	56                   	push   %esi
801048bd:	e8 ce cd ff ff       	call   80101690 <iunlock>
  end_op();
801048c2:	e8 06 e0 ff ff       	call   801028cd <end_op>

  f->type = FD_INODE;
801048c7:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
801048cd:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
801048d0:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801048d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048da:	83 c4 10             	add    $0x10,%esp
801048dd:	a8 01                	test   $0x1,%al
801048df:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801048e3:	a8 03                	test   $0x3,%al
801048e5:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
801048e9:	89 f8                	mov    %edi,%eax
801048eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048ee:	5b                   	pop    %ebx
801048ef:	5e                   	pop    %esi
801048f0:	5f                   	pop    %edi
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    
    return -1;
801048f3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801048f8:	eb ef                	jmp    801048e9 <sys_open+0xb9>
      end_op();
801048fa:	e8 ce df ff ff       	call   801028cd <end_op>
      return -1;
801048ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104904:	eb e3                	jmp    801048e9 <sys_open+0xb9>
    if((ip = namei(path)) == 0){
80104906:	83 ec 0c             	sub    $0xc,%esp
80104909:	ff 75 e4             	pushl  -0x1c(%ebp)
8010490c:	e8 3e d3 ff ff       	call   80101c4f <namei>
80104911:	89 c6                	mov    %eax,%esi
80104913:	83 c4 10             	add    $0x10,%esp
80104916:	85 c0                	test   %eax,%eax
80104918:	74 39                	je     80104953 <sys_open+0x123>
    ilock(ip);
8010491a:	83 ec 0c             	sub    $0xc,%esp
8010491d:	50                   	push   %eax
8010491e:	e8 a7 cc ff ff       	call   801015ca <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104923:	83 c4 10             	add    $0x10,%esp
80104926:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
8010492b:	0f 85 6a ff ff ff    	jne    8010489b <sys_open+0x6b>
80104931:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104935:	0f 84 60 ff ff ff    	je     8010489b <sys_open+0x6b>
      iunlockput(ip);
8010493b:	83 ec 0c             	sub    $0xc,%esp
8010493e:	56                   	push   %esi
8010493f:	e8 39 ce ff ff       	call   8010177d <iunlockput>
      end_op();
80104944:	e8 84 df ff ff       	call   801028cd <end_op>
      return -1;
80104949:	83 c4 10             	add    $0x10,%esp
8010494c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104951:	eb 96                	jmp    801048e9 <sys_open+0xb9>
      end_op();
80104953:	e8 75 df ff ff       	call   801028cd <end_op>
      return -1;
80104958:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010495d:	eb 8a                	jmp    801048e9 <sys_open+0xb9>
    if(f)
8010495f:	85 db                	test   %ebx,%ebx
80104961:	74 0c                	je     8010496f <sys_open+0x13f>
      fileclose(f);
80104963:	83 ec 0c             	sub    $0xc,%esp
80104966:	53                   	push   %ebx
80104967:	e8 99 c3 ff ff       	call   80100d05 <fileclose>
8010496c:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010496f:	83 ec 0c             	sub    $0xc,%esp
80104972:	56                   	push   %esi
80104973:	e8 05 ce ff ff       	call   8010177d <iunlockput>
    end_op();
80104978:	e8 50 df ff ff       	call   801028cd <end_op>
    return -1;
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104985:	e9 5f ff ff ff       	jmp    801048e9 <sys_open+0xb9>

8010498a <sys_mkdir>:

int
sys_mkdir(void)
{
8010498a:	f3 0f 1e fb          	endbr32 
8010498e:	55                   	push   %ebp
8010498f:	89 e5                	mov    %esp,%ebp
80104991:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104994:	e8 b6 de ff ff       	call   8010284f <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104999:	83 ec 08             	sub    $0x8,%esp
8010499c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010499f:	50                   	push   %eax
801049a0:	6a 00                	push   $0x0
801049a2:	e8 d6 f6 ff ff       	call   8010407d <argstr>
801049a7:	83 c4 10             	add    $0x10,%esp
801049aa:	85 c0                	test   %eax,%eax
801049ac:	78 36                	js     801049e4 <sys_mkdir+0x5a>
801049ae:	83 ec 0c             	sub    $0xc,%esp
801049b1:	6a 00                	push   $0x0
801049b3:	b9 00 00 00 00       	mov    $0x0,%ecx
801049b8:	ba 01 00 00 00       	mov    $0x1,%edx
801049bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c0:	e8 38 f8 ff ff       	call   801041fd <create>
801049c5:	83 c4 10             	add    $0x10,%esp
801049c8:	85 c0                	test   %eax,%eax
801049ca:	74 18                	je     801049e4 <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
801049cc:	83 ec 0c             	sub    $0xc,%esp
801049cf:	50                   	push   %eax
801049d0:	e8 a8 cd ff ff       	call   8010177d <iunlockput>
  end_op();
801049d5:	e8 f3 de ff ff       	call   801028cd <end_op>
  return 0;
801049da:	83 c4 10             	add    $0x10,%esp
801049dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049e2:	c9                   	leave  
801049e3:	c3                   	ret    
    end_op();
801049e4:	e8 e4 de ff ff       	call   801028cd <end_op>
    return -1;
801049e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ee:	eb f2                	jmp    801049e2 <sys_mkdir+0x58>

801049f0 <sys_mknod>:

int
sys_mknod(void)
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801049fa:	e8 50 de ff ff       	call   8010284f <begin_op>
  if((argstr(0, &path)) < 0 ||
801049ff:	83 ec 08             	sub    $0x8,%esp
80104a02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a05:	50                   	push   %eax
80104a06:	6a 00                	push   $0x0
80104a08:	e8 70 f6 ff ff       	call   8010407d <argstr>
80104a0d:	83 c4 10             	add    $0x10,%esp
80104a10:	85 c0                	test   %eax,%eax
80104a12:	78 62                	js     80104a76 <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80104a14:	83 ec 08             	sub    $0x8,%esp
80104a17:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a1a:	50                   	push   %eax
80104a1b:	6a 01                	push   $0x1
80104a1d:	e8 c3 f5 ff ff       	call   80103fe5 <argint>
  if((argstr(0, &path)) < 0 ||
80104a22:	83 c4 10             	add    $0x10,%esp
80104a25:	85 c0                	test   %eax,%eax
80104a27:	78 4d                	js     80104a76 <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80104a29:	83 ec 08             	sub    $0x8,%esp
80104a2c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a2f:	50                   	push   %eax
80104a30:	6a 02                	push   $0x2
80104a32:	e8 ae f5 ff ff       	call   80103fe5 <argint>
     argint(1, &major) < 0 ||
80104a37:	83 c4 10             	add    $0x10,%esp
80104a3a:	85 c0                	test   %eax,%eax
80104a3c:	78 38                	js     80104a76 <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104a3e:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104a42:	83 ec 0c             	sub    $0xc,%esp
80104a45:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104a49:	50                   	push   %eax
80104a4a:	ba 03 00 00 00       	mov    $0x3,%edx
80104a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a52:	e8 a6 f7 ff ff       	call   801041fd <create>
     argint(2, &minor) < 0 ||
80104a57:	83 c4 10             	add    $0x10,%esp
80104a5a:	85 c0                	test   %eax,%eax
80104a5c:	74 18                	je     80104a76 <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a5e:	83 ec 0c             	sub    $0xc,%esp
80104a61:	50                   	push   %eax
80104a62:	e8 16 cd ff ff       	call   8010177d <iunlockput>
  end_op();
80104a67:	e8 61 de ff ff       	call   801028cd <end_op>
  return 0;
80104a6c:	83 c4 10             	add    $0x10,%esp
80104a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a74:	c9                   	leave  
80104a75:	c3                   	ret    
    end_op();
80104a76:	e8 52 de ff ff       	call   801028cd <end_op>
    return -1;
80104a7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a80:	eb f2                	jmp    80104a74 <sys_mknod+0x84>

80104a82 <sys_chdir>:

int
sys_chdir(void)
{
80104a82:	f3 0f 1e fb          	endbr32 
80104a86:	55                   	push   %ebp
80104a87:	89 e5                	mov    %esp,%ebp
80104a89:	56                   	push   %esi
80104a8a:	53                   	push   %ebx
80104a8b:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104a8e:	e8 32 e8 ff ff       	call   801032c5 <myproc>
80104a93:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104a95:	e8 b5 dd ff ff       	call   8010284f <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104a9a:	83 ec 08             	sub    $0x8,%esp
80104a9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aa0:	50                   	push   %eax
80104aa1:	6a 00                	push   $0x0
80104aa3:	e8 d5 f5 ff ff       	call   8010407d <argstr>
80104aa8:	83 c4 10             	add    $0x10,%esp
80104aab:	85 c0                	test   %eax,%eax
80104aad:	78 52                	js     80104b01 <sys_chdir+0x7f>
80104aaf:	83 ec 0c             	sub    $0xc,%esp
80104ab2:	ff 75 f4             	pushl  -0xc(%ebp)
80104ab5:	e8 95 d1 ff ff       	call   80101c4f <namei>
80104aba:	89 c3                	mov    %eax,%ebx
80104abc:	83 c4 10             	add    $0x10,%esp
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	74 3e                	je     80104b01 <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80104ac3:	83 ec 0c             	sub    $0xc,%esp
80104ac6:	50                   	push   %eax
80104ac7:	e8 fe ca ff ff       	call   801015ca <ilock>
  if(ip->type != T_DIR){
80104acc:	83 c4 10             	add    $0x10,%esp
80104acf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ad4:	75 37                	jne    80104b0d <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104ad6:	83 ec 0c             	sub    $0xc,%esp
80104ad9:	53                   	push   %ebx
80104ada:	e8 b1 cb ff ff       	call   80101690 <iunlock>
  iput(curproc->cwd);
80104adf:	83 c4 04             	add    $0x4,%esp
80104ae2:	ff 76 68             	pushl  0x68(%esi)
80104ae5:	e8 ef cb ff ff       	call   801016d9 <iput>
  end_op();
80104aea:	e8 de dd ff ff       	call   801028cd <end_op>
  curproc->cwd = ip;
80104aef:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104af2:	83 c4 10             	add    $0x10,%esp
80104af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104afd:	5b                   	pop    %ebx
80104afe:	5e                   	pop    %esi
80104aff:	5d                   	pop    %ebp
80104b00:	c3                   	ret    
    end_op();
80104b01:	e8 c7 dd ff ff       	call   801028cd <end_op>
    return -1;
80104b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b0b:	eb ed                	jmp    80104afa <sys_chdir+0x78>
    iunlockput(ip);
80104b0d:	83 ec 0c             	sub    $0xc,%esp
80104b10:	53                   	push   %ebx
80104b11:	e8 67 cc ff ff       	call   8010177d <iunlockput>
    end_op();
80104b16:	e8 b2 dd ff ff       	call   801028cd <end_op>
    return -1;
80104b1b:	83 c4 10             	add    $0x10,%esp
80104b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b23:	eb d5                	jmp    80104afa <sys_chdir+0x78>

80104b25 <sys_exec>:

int
sys_exec(void)
{
80104b25:	f3 0f 1e fb          	endbr32 
80104b29:	55                   	push   %ebp
80104b2a:	89 e5                	mov    %esp,%ebp
80104b2c:	53                   	push   %ebx
80104b2d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104b33:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b36:	50                   	push   %eax
80104b37:	6a 00                	push   $0x0
80104b39:	e8 3f f5 ff ff       	call   8010407d <argstr>
80104b3e:	83 c4 10             	add    $0x10,%esp
80104b41:	85 c0                	test   %eax,%eax
80104b43:	78 38                	js     80104b7d <sys_exec+0x58>
80104b45:	83 ec 08             	sub    $0x8,%esp
80104b48:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104b4e:	50                   	push   %eax
80104b4f:	6a 01                	push   $0x1
80104b51:	e8 8f f4 ff ff       	call   80103fe5 <argint>
80104b56:	83 c4 10             	add    $0x10,%esp
80104b59:	85 c0                	test   %eax,%eax
80104b5b:	78 20                	js     80104b7d <sys_exec+0x58>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104b5d:	83 ec 04             	sub    $0x4,%esp
80104b60:	68 80 00 00 00       	push   $0x80
80104b65:	6a 00                	push   $0x0
80104b67:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b6d:	50                   	push   %eax
80104b6e:	e8 fc f1 ff ff       	call   80103d6f <memset>
80104b73:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104b76:	bb 00 00 00 00       	mov    $0x0,%ebx
80104b7b:	eb 2c                	jmp    80104ba9 <sys_exec+0x84>
    return -1;
80104b7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b82:	eb 78                	jmp    80104bfc <sys_exec+0xd7>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104b84:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104b8b:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104b8f:	83 ec 08             	sub    $0x8,%esp
80104b92:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b98:	50                   	push   %eax
80104b99:	ff 75 f4             	pushl  -0xc(%ebp)
80104b9c:	e8 5b bd ff ff       	call   801008fc <exec>
80104ba1:	83 c4 10             	add    $0x10,%esp
80104ba4:	eb 56                	jmp    80104bfc <sys_exec+0xd7>
  for(i=0;; i++){
80104ba6:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80104ba9:	83 fb 1f             	cmp    $0x1f,%ebx
80104bac:	77 49                	ja     80104bf7 <sys_exec+0xd2>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104bae:	83 ec 08             	sub    $0x8,%esp
80104bb1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104bb7:	50                   	push   %eax
80104bb8:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104bbe:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104bc1:	50                   	push   %eax
80104bc2:	e8 9a f3 ff ff       	call   80103f61 <fetchint>
80104bc7:	83 c4 10             	add    $0x10,%esp
80104bca:	85 c0                	test   %eax,%eax
80104bcc:	78 33                	js     80104c01 <sys_exec+0xdc>
    if(uarg == 0){
80104bce:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104bd4:	85 c0                	test   %eax,%eax
80104bd6:	74 ac                	je     80104b84 <sys_exec+0x5f>
    if(fetchstr(uarg, &argv[i]) < 0)
80104bd8:	83 ec 08             	sub    $0x8,%esp
80104bdb:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104be2:	52                   	push   %edx
80104be3:	50                   	push   %eax
80104be4:	e8 b8 f3 ff ff       	call   80103fa1 <fetchstr>
80104be9:	83 c4 10             	add    $0x10,%esp
80104bec:	85 c0                	test   %eax,%eax
80104bee:	79 b6                	jns    80104ba6 <sys_exec+0x81>
      return -1;
80104bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf5:	eb 05                	jmp    80104bfc <sys_exec+0xd7>
      return -1;
80104bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bff:	c9                   	leave  
80104c00:	c3                   	ret    
      return -1;
80104c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c06:	eb f4                	jmp    80104bfc <sys_exec+0xd7>

80104c08 <sys_pipe>:

int
sys_pipe(void)
{
80104c08:	f3 0f 1e fb          	endbr32 
80104c0c:	55                   	push   %ebp
80104c0d:	89 e5                	mov    %esp,%ebp
80104c0f:	53                   	push   %ebx
80104c10:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104c13:	6a 08                	push   $0x8
80104c15:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c18:	50                   	push   %eax
80104c19:	6a 00                	push   $0x0
80104c1b:	e8 f1 f3 ff ff       	call   80104011 <argptr>
80104c20:	83 c4 10             	add    $0x10,%esp
80104c23:	85 c0                	test   %eax,%eax
80104c25:	78 79                	js     80104ca0 <sys_pipe+0x98>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104c27:	83 ec 08             	sub    $0x8,%esp
80104c2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c2d:	50                   	push   %eax
80104c2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c31:	50                   	push   %eax
80104c32:	e8 bd e1 ff ff       	call   80102df4 <pipealloc>
80104c37:	83 c4 10             	add    $0x10,%esp
80104c3a:	85 c0                	test   %eax,%eax
80104c3c:	78 69                	js     80104ca7 <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c41:	e8 29 f5 ff ff       	call   8010416f <fdalloc>
80104c46:	89 c3                	mov    %eax,%ebx
80104c48:	85 c0                	test   %eax,%eax
80104c4a:	78 21                	js     80104c6d <sys_pipe+0x65>
80104c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c4f:	e8 1b f5 ff ff       	call   8010416f <fdalloc>
80104c54:	85 c0                	test   %eax,%eax
80104c56:	78 15                	js     80104c6d <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c5b:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c60:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c6b:	c9                   	leave  
80104c6c:	c3                   	ret    
    if(fd0 >= 0)
80104c6d:	85 db                	test   %ebx,%ebx
80104c6f:	79 20                	jns    80104c91 <sys_pipe+0x89>
    fileclose(rf);
80104c71:	83 ec 0c             	sub    $0xc,%esp
80104c74:	ff 75 f0             	pushl  -0x10(%ebp)
80104c77:	e8 89 c0 ff ff       	call   80100d05 <fileclose>
    fileclose(wf);
80104c7c:	83 c4 04             	add    $0x4,%esp
80104c7f:	ff 75 ec             	pushl  -0x14(%ebp)
80104c82:	e8 7e c0 ff ff       	call   80100d05 <fileclose>
    return -1;
80104c87:	83 c4 10             	add    $0x10,%esp
80104c8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c8f:	eb d7                	jmp    80104c68 <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80104c91:	e8 2f e6 ff ff       	call   801032c5 <myproc>
80104c96:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104c9d:	00 
80104c9e:	eb d1                	jmp    80104c71 <sys_pipe+0x69>
    return -1;
80104ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca5:	eb c1                	jmp    80104c68 <sys_pipe+0x60>
    return -1;
80104ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cac:	eb ba                	jmp    80104c68 <sys_pipe+0x60>

80104cae <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104cae:	f3 0f 1e fb          	endbr32 
80104cb2:	55                   	push   %ebp
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104cb8:	e8 8b e7 ff ff       	call   80103448 <fork>
}
80104cbd:	c9                   	leave  
80104cbe:	c3                   	ret    

80104cbf <sys_exit>:

int
sys_exit(void)
{
80104cbf:	f3 0f 1e fb          	endbr32 
80104cc3:	55                   	push   %ebp
80104cc4:	89 e5                	mov    %esp,%ebp
80104cc6:	83 ec 08             	sub    $0x8,%esp
  exit();
80104cc9:	e8 ba e9 ff ff       	call   80103688 <exit>
  return 0;  // not reached
}
80104cce:	b8 00 00 00 00       	mov    $0x0,%eax
80104cd3:	c9                   	leave  
80104cd4:	c3                   	ret    

80104cd5 <sys_wait>:

int
sys_wait(void)
{
80104cd5:	f3 0f 1e fb          	endbr32 
80104cd9:	55                   	push   %ebp
80104cda:	89 e5                	mov    %esp,%ebp
80104cdc:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104cdf:	e8 39 eb ff ff       	call   8010381d <wait>
}
80104ce4:	c9                   	leave  
80104ce5:	c3                   	ret    

80104ce6 <sys_kill>:

int
sys_kill(void)
{
80104ce6:	f3 0f 1e fb          	endbr32 
80104cea:	55                   	push   %ebp
80104ceb:	89 e5                	mov    %esp,%ebp
80104ced:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104cf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cf3:	50                   	push   %eax
80104cf4:	6a 00                	push   $0x0
80104cf6:	e8 ea f2 ff ff       	call   80103fe5 <argint>
80104cfb:	83 c4 10             	add    $0x10,%esp
80104cfe:	85 c0                	test   %eax,%eax
80104d00:	78 10                	js     80104d12 <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104d02:	83 ec 0c             	sub    $0xc,%esp
80104d05:	ff 75 f4             	pushl  -0xc(%ebp)
80104d08:	e8 15 ec ff ff       	call   80103922 <kill>
80104d0d:	83 c4 10             	add    $0x10,%esp
}
80104d10:	c9                   	leave  
80104d11:	c3                   	ret    
    return -1;
80104d12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d17:	eb f7                	jmp    80104d10 <sys_kill+0x2a>

80104d19 <sys_getpid>:

int
sys_getpid(void)
{
80104d19:	f3 0f 1e fb          	endbr32 
80104d1d:	55                   	push   %ebp
80104d1e:	89 e5                	mov    %esp,%ebp
80104d20:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104d23:	e8 9d e5 ff ff       	call   801032c5 <myproc>
80104d28:	8b 40 10             	mov    0x10(%eax),%eax
}
80104d2b:	c9                   	leave  
80104d2c:	c3                   	ret    

80104d2d <sys_sbrk>:

int
sys_sbrk(void)
{
80104d2d:	f3 0f 1e fb          	endbr32 
80104d31:	55                   	push   %ebp
80104d32:	89 e5                	mov    %esp,%ebp
80104d34:	53                   	push   %ebx
80104d35:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d3b:	50                   	push   %eax
80104d3c:	6a 00                	push   $0x0
80104d3e:	e8 a2 f2 ff ff       	call   80103fe5 <argint>
80104d43:	83 c4 10             	add    $0x10,%esp
80104d46:	85 c0                	test   %eax,%eax
80104d48:	78 20                	js     80104d6a <sys_sbrk+0x3d>
    return -1;
  addr = myproc()->sz;
80104d4a:	e8 76 e5 ff ff       	call   801032c5 <myproc>
80104d4f:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104d51:	83 ec 0c             	sub    $0xc,%esp
80104d54:	ff 75 f4             	pushl  -0xc(%ebp)
80104d57:	e8 7d e6 ff ff       	call   801033d9 <growproc>
80104d5c:	83 c4 10             	add    $0x10,%esp
80104d5f:	85 c0                	test   %eax,%eax
80104d61:	78 0e                	js     80104d71 <sys_sbrk+0x44>
    return -1;
  return addr;
}
80104d63:	89 d8                	mov    %ebx,%eax
80104d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d68:	c9                   	leave  
80104d69:	c3                   	ret    
    return -1;
80104d6a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d6f:	eb f2                	jmp    80104d63 <sys_sbrk+0x36>
    return -1;
80104d71:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d76:	eb eb                	jmp    80104d63 <sys_sbrk+0x36>

80104d78 <sys_sleep>:

int
sys_sleep(void)
{
80104d78:	f3 0f 1e fb          	endbr32 
80104d7c:	55                   	push   %ebp
80104d7d:	89 e5                	mov    %esp,%ebp
80104d7f:	53                   	push   %ebx
80104d80:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104d83:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d86:	50                   	push   %eax
80104d87:	6a 00                	push   $0x0
80104d89:	e8 57 f2 ff ff       	call   80103fe5 <argint>
80104d8e:	83 c4 10             	add    $0x10,%esp
80104d91:	85 c0                	test   %eax,%eax
80104d93:	78 75                	js     80104e0a <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104d95:	83 ec 0c             	sub    $0xc,%esp
80104d98:	68 60 3c 11 80       	push   $0x80113c60
80104d9d:	e8 19 ef ff ff       	call   80103cbb <acquire>
  ticks0 = ticks;
80104da2:	8b 1d a0 44 11 80    	mov    0x801144a0,%ebx
  while(ticks - ticks0 < n){
80104da8:	83 c4 10             	add    $0x10,%esp
80104dab:	a1 a0 44 11 80       	mov    0x801144a0,%eax
80104db0:	29 d8                	sub    %ebx,%eax
80104db2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104db5:	73 39                	jae    80104df0 <sys_sleep+0x78>
    if(myproc()->killed){
80104db7:	e8 09 e5 ff ff       	call   801032c5 <myproc>
80104dbc:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104dc0:	75 17                	jne    80104dd9 <sys_sleep+0x61>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104dc2:	83 ec 08             	sub    $0x8,%esp
80104dc5:	68 60 3c 11 80       	push   $0x80113c60
80104dca:	68 a0 44 11 80       	push   $0x801144a0
80104dcf:	e8 b4 e9 ff ff       	call   80103788 <sleep>
80104dd4:	83 c4 10             	add    $0x10,%esp
80104dd7:	eb d2                	jmp    80104dab <sys_sleep+0x33>
      release(&tickslock);
80104dd9:	83 ec 0c             	sub    $0xc,%esp
80104ddc:	68 60 3c 11 80       	push   $0x80113c60
80104de1:	e8 3e ef ff ff       	call   80103d24 <release>
      return -1;
80104de6:	83 c4 10             	add    $0x10,%esp
80104de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dee:	eb 15                	jmp    80104e05 <sys_sleep+0x8d>
  }
  release(&tickslock);
80104df0:	83 ec 0c             	sub    $0xc,%esp
80104df3:	68 60 3c 11 80       	push   $0x80113c60
80104df8:	e8 27 ef ff ff       	call   80103d24 <release>
  return 0;
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e08:	c9                   	leave  
80104e09:	c3                   	ret    
    return -1;
80104e0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e0f:	eb f4                	jmp    80104e05 <sys_sleep+0x8d>

80104e11 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104e11:	f3 0f 1e fb          	endbr32 
80104e15:	55                   	push   %ebp
80104e16:	89 e5                	mov    %esp,%ebp
80104e18:	53                   	push   %ebx
80104e19:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104e1c:	68 60 3c 11 80       	push   $0x80113c60
80104e21:	e8 95 ee ff ff       	call   80103cbb <acquire>
  xticks = ticks;
80104e26:	8b 1d a0 44 11 80    	mov    0x801144a0,%ebx
  release(&tickslock);
80104e2c:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104e33:	e8 ec ee ff ff       	call   80103d24 <release>
  return xticks;
}
80104e38:	89 d8                	mov    %ebx,%eax
80104e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e3d:	c9                   	leave  
80104e3e:	c3                   	ret    

80104e3f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104e3f:	1e                   	push   %ds
  pushl %es
80104e40:	06                   	push   %es
  pushl %fs
80104e41:	0f a0                	push   %fs
  pushl %gs
80104e43:	0f a8                	push   %gs
  pushal
80104e45:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104e46:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104e4a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104e4c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104e4e:	54                   	push   %esp
  call trap
80104e4f:	e8 eb 00 00 00       	call   80104f3f <trap>
  addl $4, %esp
80104e54:	83 c4 04             	add    $0x4,%esp

80104e57 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104e57:	61                   	popa   
  popl %gs
80104e58:	0f a9                	pop    %gs
  popl %fs
80104e5a:	0f a1                	pop    %fs
  popl %es
80104e5c:	07                   	pop    %es
  popl %ds
80104e5d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104e5e:	83 c4 08             	add    $0x8,%esp
  iret
80104e61:	cf                   	iret   

80104e62 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104e62:	f3 0f 1e fb          	endbr32 
80104e66:	55                   	push   %ebp
80104e67:	89 e5                	mov    %esp,%ebp
80104e69:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80104e6c:	b8 00 00 00 00       	mov    $0x0,%eax
80104e71:	3d ff 00 00 00       	cmp    $0xff,%eax
80104e76:	7f 4c                	jg     80104ec4 <tvinit+0x62>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104e78:	8b 0c 85 08 90 10 80 	mov    -0x7fef6ff8(,%eax,4),%ecx
80104e7f:	66 89 0c c5 a0 3c 11 	mov    %cx,-0x7feec360(,%eax,8)
80104e86:	80 
80104e87:	66 c7 04 c5 a2 3c 11 	movw   $0x8,-0x7feec35e(,%eax,8)
80104e8e:	80 08 00 
80104e91:	c6 04 c5 a4 3c 11 80 	movb   $0x0,-0x7feec35c(,%eax,8)
80104e98:	00 
80104e99:	0f b6 14 c5 a5 3c 11 	movzbl -0x7feec35b(,%eax,8),%edx
80104ea0:	80 
80104ea1:	83 e2 f0             	and    $0xfffffff0,%edx
80104ea4:	83 ca 0e             	or     $0xe,%edx
80104ea7:	83 e2 8f             	and    $0xffffff8f,%edx
80104eaa:	83 ca 80             	or     $0xffffff80,%edx
80104ead:	88 14 c5 a5 3c 11 80 	mov    %dl,-0x7feec35b(,%eax,8)
80104eb4:	c1 e9 10             	shr    $0x10,%ecx
80104eb7:	66 89 0c c5 a6 3c 11 	mov    %cx,-0x7feec35a(,%eax,8)
80104ebe:	80 
  for(i = 0; i < 256; i++)
80104ebf:	83 c0 01             	add    $0x1,%eax
80104ec2:	eb ad                	jmp    80104e71 <tvinit+0xf>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104ec4:	8b 15 08 91 10 80    	mov    0x80109108,%edx
80104eca:	66 89 15 a0 3e 11 80 	mov    %dx,0x80113ea0
80104ed1:	66 c7 05 a2 3e 11 80 	movw   $0x8,0x80113ea2
80104ed8:	08 00 
80104eda:	c6 05 a4 3e 11 80 00 	movb   $0x0,0x80113ea4
80104ee1:	0f b6 05 a5 3e 11 80 	movzbl 0x80113ea5,%eax
80104ee8:	83 c8 0f             	or     $0xf,%eax
80104eeb:	83 e0 ef             	and    $0xffffffef,%eax
80104eee:	83 c8 e0             	or     $0xffffffe0,%eax
80104ef1:	a2 a5 3e 11 80       	mov    %al,0x80113ea5
80104ef6:	c1 ea 10             	shr    $0x10,%edx
80104ef9:	66 89 15 a6 3e 11 80 	mov    %dx,0x80113ea6

  initlock(&tickslock, "time");
80104f00:	83 ec 08             	sub    $0x8,%esp
80104f03:	68 59 6d 10 80       	push   $0x80106d59
80104f08:	68 60 3c 11 80       	push   $0x80113c60
80104f0d:	e8 59 ec ff ff       	call   80103b6b <initlock>
}
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    

80104f17 <idtinit>:

void
idtinit(void)
{
80104f17:	f3 0f 1e fb          	endbr32 
80104f1b:	55                   	push   %ebp
80104f1c:	89 e5                	mov    %esp,%ebp
80104f1e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104f21:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104f27:	b8 a0 3c 11 80       	mov    $0x80113ca0,%eax
80104f2c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104f30:	c1 e8 10             	shr    $0x10,%eax
80104f33:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104f37:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104f3a:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104f3d:	c9                   	leave  
80104f3e:	c3                   	ret    

80104f3f <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104f3f:	f3 0f 1e fb          	endbr32 
80104f43:	55                   	push   %ebp
80104f44:	89 e5                	mov    %esp,%ebp
80104f46:	57                   	push   %edi
80104f47:	56                   	push   %esi
80104f48:	53                   	push   %ebx
80104f49:	83 ec 1c             	sub    $0x1c,%esp
80104f4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104f4f:	8b 43 30             	mov    0x30(%ebx),%eax
80104f52:	83 f8 40             	cmp    $0x40,%eax
80104f55:	74 14                	je     80104f6b <trap+0x2c>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104f57:	83 e8 20             	sub    $0x20,%eax
80104f5a:	83 f8 1f             	cmp    $0x1f,%eax
80104f5d:	0f 87 3b 01 00 00    	ja     8010509e <trap+0x15f>
80104f63:	3e ff 24 85 00 6e 10 	notrack jmp *-0x7fef9200(,%eax,4)
80104f6a:	80 
    if(myproc()->killed)
80104f6b:	e8 55 e3 ff ff       	call   801032c5 <myproc>
80104f70:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f74:	75 1f                	jne    80104f95 <trap+0x56>
    myproc()->tf = tf;
80104f76:	e8 4a e3 ff ff       	call   801032c5 <myproc>
80104f7b:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80104f7e:	e8 31 f1 ff ff       	call   801040b4 <syscall>
    if(myproc()->killed)
80104f83:	e8 3d e3 ff ff       	call   801032c5 <myproc>
80104f88:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f8c:	74 7e                	je     8010500c <trap+0xcd>
      exit();
80104f8e:	e8 f5 e6 ff ff       	call   80103688 <exit>
    return;
80104f93:	eb 77                	jmp    8010500c <trap+0xcd>
      exit();
80104f95:	e8 ee e6 ff ff       	call   80103688 <exit>
80104f9a:	eb da                	jmp    80104f76 <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104f9c:	e8 05 e3 ff ff       	call   801032a6 <cpuid>
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	74 6f                	je     80105014 <trap+0xd5>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80104fa5:	e8 89 d4 ff ff       	call   80102433 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104faa:	e8 16 e3 ff ff       	call   801032c5 <myproc>
80104faf:	85 c0                	test   %eax,%eax
80104fb1:	74 1c                	je     80104fcf <trap+0x90>
80104fb3:	e8 0d e3 ff ff       	call   801032c5 <myproc>
80104fb8:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fbc:	74 11                	je     80104fcf <trap+0x90>
80104fbe:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80104fc2:	83 e0 03             	and    $0x3,%eax
80104fc5:	66 83 f8 03          	cmp    $0x3,%ax
80104fc9:	0f 84 62 01 00 00    	je     80105131 <trap+0x1f2>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104fcf:	e8 f1 e2 ff ff       	call   801032c5 <myproc>
80104fd4:	85 c0                	test   %eax,%eax
80104fd6:	74 0f                	je     80104fe7 <trap+0xa8>
80104fd8:	e8 e8 e2 ff ff       	call   801032c5 <myproc>
80104fdd:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104fe1:	0f 84 54 01 00 00    	je     8010513b <trap+0x1fc>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104fe7:	e8 d9 e2 ff ff       	call   801032c5 <myproc>
80104fec:	85 c0                	test   %eax,%eax
80104fee:	74 1c                	je     8010500c <trap+0xcd>
80104ff0:	e8 d0 e2 ff ff       	call   801032c5 <myproc>
80104ff5:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104ff9:	74 11                	je     8010500c <trap+0xcd>
80104ffb:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80104fff:	83 e0 03             	and    $0x3,%eax
80105002:	66 83 f8 03          	cmp    $0x3,%ax
80105006:	0f 84 43 01 00 00    	je     8010514f <trap+0x210>
    exit();
}
8010500c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5f                   	pop    %edi
80105012:	5d                   	pop    %ebp
80105013:	c3                   	ret    
      acquire(&tickslock);
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	68 60 3c 11 80       	push   $0x80113c60
8010501c:	e8 9a ec ff ff       	call   80103cbb <acquire>
      ticks++;
80105021:	83 05 a0 44 11 80 01 	addl   $0x1,0x801144a0
      wakeup(&ticks);
80105028:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
8010502f:	e8 c1 e8 ff ff       	call   801038f5 <wakeup>
      release(&tickslock);
80105034:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
8010503b:	e8 e4 ec ff ff       	call   80103d24 <release>
80105040:	83 c4 10             	add    $0x10,%esp
80105043:	e9 5d ff ff ff       	jmp    80104fa5 <trap+0x66>
    ideintr();
80105048:	e8 9f cd ff ff       	call   80101dec <ideintr>
    lapiceoi();
8010504d:	e8 e1 d3 ff ff       	call   80102433 <lapiceoi>
    break;
80105052:	e9 53 ff ff ff       	jmp    80104faa <trap+0x6b>
    kbdintr();
80105057:	e8 14 d2 ff ff       	call   80102270 <kbdintr>
    lapiceoi();
8010505c:	e8 d2 d3 ff ff       	call   80102433 <lapiceoi>
    break;
80105061:	e9 44 ff ff ff       	jmp    80104faa <trap+0x6b>
    uartintr();
80105066:	e8 0a 02 00 00       	call   80105275 <uartintr>
    lapiceoi();
8010506b:	e8 c3 d3 ff ff       	call   80102433 <lapiceoi>
    break;
80105070:	e9 35 ff ff ff       	jmp    80104faa <trap+0x6b>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105075:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105078:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010507c:	e8 25 e2 ff ff       	call   801032a6 <cpuid>
80105081:	57                   	push   %edi
80105082:	0f b7 f6             	movzwl %si,%esi
80105085:	56                   	push   %esi
80105086:	50                   	push   %eax
80105087:	68 64 6d 10 80       	push   $0x80106d64
8010508c:	e8 98 b5 ff ff       	call   80100629 <cprintf>
    lapiceoi();
80105091:	e8 9d d3 ff ff       	call   80102433 <lapiceoi>
    break;
80105096:	83 c4 10             	add    $0x10,%esp
80105099:	e9 0c ff ff ff       	jmp    80104faa <trap+0x6b>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010509e:	e8 22 e2 ff ff       	call   801032c5 <myproc>
801050a3:	85 c0                	test   %eax,%eax
801050a5:	74 5f                	je     80105106 <trap+0x1c7>
801050a7:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801050ab:	74 59                	je     80105106 <trap+0x1c7>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801050ad:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801050b0:	8b 43 38             	mov    0x38(%ebx),%eax
801050b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801050b6:	e8 eb e1 ff ff       	call   801032a6 <cpuid>
801050bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801050be:	8b 53 34             	mov    0x34(%ebx),%edx
801050c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
801050c4:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801050c7:	e8 f9 e1 ff ff       	call   801032c5 <myproc>
801050cc:	8d 48 6c             	lea    0x6c(%eax),%ecx
801050cf:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801050d2:	e8 ee e1 ff ff       	call   801032c5 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801050d7:	57                   	push   %edi
801050d8:	ff 75 e4             	pushl  -0x1c(%ebp)
801050db:	ff 75 e0             	pushl  -0x20(%ebp)
801050de:	ff 75 dc             	pushl  -0x24(%ebp)
801050e1:	56                   	push   %esi
801050e2:	ff 75 d8             	pushl  -0x28(%ebp)
801050e5:	ff 70 10             	pushl  0x10(%eax)
801050e8:	68 bc 6d 10 80       	push   $0x80106dbc
801050ed:	e8 37 b5 ff ff       	call   80100629 <cprintf>
    myproc()->killed = 1;
801050f2:	83 c4 20             	add    $0x20,%esp
801050f5:	e8 cb e1 ff ff       	call   801032c5 <myproc>
801050fa:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105101:	e9 a4 fe ff ff       	jmp    80104faa <trap+0x6b>
80105106:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105109:	8b 73 38             	mov    0x38(%ebx),%esi
8010510c:	e8 95 e1 ff ff       	call   801032a6 <cpuid>
80105111:	83 ec 0c             	sub    $0xc,%esp
80105114:	57                   	push   %edi
80105115:	56                   	push   %esi
80105116:	50                   	push   %eax
80105117:	ff 73 30             	pushl  0x30(%ebx)
8010511a:	68 88 6d 10 80       	push   $0x80106d88
8010511f:	e8 05 b5 ff ff       	call   80100629 <cprintf>
      panic("trap");
80105124:	83 c4 14             	add    $0x14,%esp
80105127:	68 5e 6d 10 80       	push   $0x80106d5e
8010512c:	e8 2b b2 ff ff       	call   8010035c <panic>
    exit();
80105131:	e8 52 e5 ff ff       	call   80103688 <exit>
80105136:	e9 94 fe ff ff       	jmp    80104fcf <trap+0x90>
  if(myproc() && myproc()->state == RUNNING &&
8010513b:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010513f:	0f 85 a2 fe ff ff    	jne    80104fe7 <trap+0xa8>
    yield();
80105145:	e8 08 e6 ff ff       	call   80103752 <yield>
8010514a:	e9 98 fe ff ff       	jmp    80104fe7 <trap+0xa8>
    exit();
8010514f:	e8 34 e5 ff ff       	call   80103688 <exit>
80105154:	e9 b3 fe ff ff       	jmp    8010500c <trap+0xcd>

80105159 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105159:	f3 0f 1e fb          	endbr32 
  if(!uart)
8010515d:	83 3d bc 95 10 80 00 	cmpl   $0x0,0x801095bc
80105164:	74 14                	je     8010517a <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105166:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010516b:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010516c:	a8 01                	test   $0x1,%al
8010516e:	74 10                	je     80105180 <uartgetc+0x27>
80105170:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105175:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105176:	0f b6 c0             	movzbl %al,%eax
80105179:	c3                   	ret    
    return -1;
8010517a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517f:	c3                   	ret    
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105185:	c3                   	ret    

80105186 <uartputc>:
{
80105186:	f3 0f 1e fb          	endbr32 
  if(!uart)
8010518a:	83 3d bc 95 10 80 00 	cmpl   $0x0,0x801095bc
80105191:	74 3b                	je     801051ce <uartputc+0x48>
{
80105193:	55                   	push   %ebp
80105194:	89 e5                	mov    %esp,%ebp
80105196:	53                   	push   %ebx
80105197:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010519a:	bb 00 00 00 00       	mov    $0x0,%ebx
8010519f:	83 fb 7f             	cmp    $0x7f,%ebx
801051a2:	7f 1c                	jg     801051c0 <uartputc+0x3a>
801051a4:	ba fd 03 00 00       	mov    $0x3fd,%edx
801051a9:	ec                   	in     (%dx),%al
801051aa:	a8 20                	test   $0x20,%al
801051ac:	75 12                	jne    801051c0 <uartputc+0x3a>
    microdelay(10);
801051ae:	83 ec 0c             	sub    $0xc,%esp
801051b1:	6a 0a                	push   $0xa
801051b3:	e8 a0 d2 ff ff       	call   80102458 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801051b8:	83 c3 01             	add    $0x1,%ebx
801051bb:	83 c4 10             	add    $0x10,%esp
801051be:	eb df                	jmp    8010519f <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801051c0:	8b 45 08             	mov    0x8(%ebp),%eax
801051c3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801051c8:	ee                   	out    %al,(%dx)
}
801051c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051cc:	c9                   	leave  
801051cd:	c3                   	ret    
801051ce:	c3                   	ret    

801051cf <uartinit>:
{
801051cf:	f3 0f 1e fb          	endbr32 
801051d3:	55                   	push   %ebp
801051d4:	89 e5                	mov    %esp,%ebp
801051d6:	56                   	push   %esi
801051d7:	53                   	push   %ebx
801051d8:	b9 00 00 00 00       	mov    $0x0,%ecx
801051dd:	ba fa 03 00 00       	mov    $0x3fa,%edx
801051e2:	89 c8                	mov    %ecx,%eax
801051e4:	ee                   	out    %al,(%dx)
801051e5:	be fb 03 00 00       	mov    $0x3fb,%esi
801051ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801051ef:	89 f2                	mov    %esi,%edx
801051f1:	ee                   	out    %al,(%dx)
801051f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801051f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801051fc:	ee                   	out    %al,(%dx)
801051fd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105202:	89 c8                	mov    %ecx,%eax
80105204:	89 da                	mov    %ebx,%edx
80105206:	ee                   	out    %al,(%dx)
80105207:	b8 03 00 00 00       	mov    $0x3,%eax
8010520c:	89 f2                	mov    %esi,%edx
8010520e:	ee                   	out    %al,(%dx)
8010520f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105214:	89 c8                	mov    %ecx,%eax
80105216:	ee                   	out    %al,(%dx)
80105217:	b8 01 00 00 00       	mov    $0x1,%eax
8010521c:	89 da                	mov    %ebx,%edx
8010521e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010521f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105224:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105225:	3c ff                	cmp    $0xff,%al
80105227:	74 45                	je     8010526e <uartinit+0x9f>
  uart = 1;
80105229:	c7 05 bc 95 10 80 01 	movl   $0x1,0x801095bc
80105230:	00 00 00 
80105233:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105238:	ec                   	in     (%dx),%al
80105239:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010523e:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010523f:	83 ec 08             	sub    $0x8,%esp
80105242:	6a 00                	push   $0x0
80105244:	6a 04                	push   $0x4
80105246:	e8 b0 cd ff ff       	call   80101ffb <ioapicenable>
  for(p="xv6...\n"; *p; p++)
8010524b:	83 c4 10             	add    $0x10,%esp
8010524e:	bb 80 6e 10 80       	mov    $0x80106e80,%ebx
80105253:	eb 12                	jmp    80105267 <uartinit+0x98>
    uartputc(*p);
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	0f be c0             	movsbl %al,%eax
8010525b:	50                   	push   %eax
8010525c:	e8 25 ff ff ff       	call   80105186 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105261:	83 c3 01             	add    $0x1,%ebx
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	0f b6 03             	movzbl (%ebx),%eax
8010526a:	84 c0                	test   %al,%al
8010526c:	75 e7                	jne    80105255 <uartinit+0x86>
}
8010526e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105271:	5b                   	pop    %ebx
80105272:	5e                   	pop    %esi
80105273:	5d                   	pop    %ebp
80105274:	c3                   	ret    

80105275 <uartintr>:

void
uartintr(void)
{
80105275:	f3 0f 1e fb          	endbr32 
80105279:	55                   	push   %ebp
8010527a:	89 e5                	mov    %esp,%ebp
8010527c:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010527f:	68 59 51 10 80       	push   $0x80105159
80105284:	e8 d0 b4 ff ff       	call   80100759 <consoleintr>
}
80105289:	83 c4 10             	add    $0x10,%esp
8010528c:	c9                   	leave  
8010528d:	c3                   	ret    

8010528e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010528e:	6a 00                	push   $0x0
  pushl $0
80105290:	6a 00                	push   $0x0
  jmp alltraps
80105292:	e9 a8 fb ff ff       	jmp    80104e3f <alltraps>

80105297 <vector1>:
.globl vector1
vector1:
  pushl $0
80105297:	6a 00                	push   $0x0
  pushl $1
80105299:	6a 01                	push   $0x1
  jmp alltraps
8010529b:	e9 9f fb ff ff       	jmp    80104e3f <alltraps>

801052a0 <vector2>:
.globl vector2
vector2:
  pushl $0
801052a0:	6a 00                	push   $0x0
  pushl $2
801052a2:	6a 02                	push   $0x2
  jmp alltraps
801052a4:	e9 96 fb ff ff       	jmp    80104e3f <alltraps>

801052a9 <vector3>:
.globl vector3
vector3:
  pushl $0
801052a9:	6a 00                	push   $0x0
  pushl $3
801052ab:	6a 03                	push   $0x3
  jmp alltraps
801052ad:	e9 8d fb ff ff       	jmp    80104e3f <alltraps>

801052b2 <vector4>:
.globl vector4
vector4:
  pushl $0
801052b2:	6a 00                	push   $0x0
  pushl $4
801052b4:	6a 04                	push   $0x4
  jmp alltraps
801052b6:	e9 84 fb ff ff       	jmp    80104e3f <alltraps>

801052bb <vector5>:
.globl vector5
vector5:
  pushl $0
801052bb:	6a 00                	push   $0x0
  pushl $5
801052bd:	6a 05                	push   $0x5
  jmp alltraps
801052bf:	e9 7b fb ff ff       	jmp    80104e3f <alltraps>

801052c4 <vector6>:
.globl vector6
vector6:
  pushl $0
801052c4:	6a 00                	push   $0x0
  pushl $6
801052c6:	6a 06                	push   $0x6
  jmp alltraps
801052c8:	e9 72 fb ff ff       	jmp    80104e3f <alltraps>

801052cd <vector7>:
.globl vector7
vector7:
  pushl $0
801052cd:	6a 00                	push   $0x0
  pushl $7
801052cf:	6a 07                	push   $0x7
  jmp alltraps
801052d1:	e9 69 fb ff ff       	jmp    80104e3f <alltraps>

801052d6 <vector8>:
.globl vector8
vector8:
  pushl $8
801052d6:	6a 08                	push   $0x8
  jmp alltraps
801052d8:	e9 62 fb ff ff       	jmp    80104e3f <alltraps>

801052dd <vector9>:
.globl vector9
vector9:
  pushl $0
801052dd:	6a 00                	push   $0x0
  pushl $9
801052df:	6a 09                	push   $0x9
  jmp alltraps
801052e1:	e9 59 fb ff ff       	jmp    80104e3f <alltraps>

801052e6 <vector10>:
.globl vector10
vector10:
  pushl $10
801052e6:	6a 0a                	push   $0xa
  jmp alltraps
801052e8:	e9 52 fb ff ff       	jmp    80104e3f <alltraps>

801052ed <vector11>:
.globl vector11
vector11:
  pushl $11
801052ed:	6a 0b                	push   $0xb
  jmp alltraps
801052ef:	e9 4b fb ff ff       	jmp    80104e3f <alltraps>

801052f4 <vector12>:
.globl vector12
vector12:
  pushl $12
801052f4:	6a 0c                	push   $0xc
  jmp alltraps
801052f6:	e9 44 fb ff ff       	jmp    80104e3f <alltraps>

801052fb <vector13>:
.globl vector13
vector13:
  pushl $13
801052fb:	6a 0d                	push   $0xd
  jmp alltraps
801052fd:	e9 3d fb ff ff       	jmp    80104e3f <alltraps>

80105302 <vector14>:
.globl vector14
vector14:
  pushl $14
80105302:	6a 0e                	push   $0xe
  jmp alltraps
80105304:	e9 36 fb ff ff       	jmp    80104e3f <alltraps>

80105309 <vector15>:
.globl vector15
vector15:
  pushl $0
80105309:	6a 00                	push   $0x0
  pushl $15
8010530b:	6a 0f                	push   $0xf
  jmp alltraps
8010530d:	e9 2d fb ff ff       	jmp    80104e3f <alltraps>

80105312 <vector16>:
.globl vector16
vector16:
  pushl $0
80105312:	6a 00                	push   $0x0
  pushl $16
80105314:	6a 10                	push   $0x10
  jmp alltraps
80105316:	e9 24 fb ff ff       	jmp    80104e3f <alltraps>

8010531b <vector17>:
.globl vector17
vector17:
  pushl $17
8010531b:	6a 11                	push   $0x11
  jmp alltraps
8010531d:	e9 1d fb ff ff       	jmp    80104e3f <alltraps>

80105322 <vector18>:
.globl vector18
vector18:
  pushl $0
80105322:	6a 00                	push   $0x0
  pushl $18
80105324:	6a 12                	push   $0x12
  jmp alltraps
80105326:	e9 14 fb ff ff       	jmp    80104e3f <alltraps>

8010532b <vector19>:
.globl vector19
vector19:
  pushl $0
8010532b:	6a 00                	push   $0x0
  pushl $19
8010532d:	6a 13                	push   $0x13
  jmp alltraps
8010532f:	e9 0b fb ff ff       	jmp    80104e3f <alltraps>

80105334 <vector20>:
.globl vector20
vector20:
  pushl $0
80105334:	6a 00                	push   $0x0
  pushl $20
80105336:	6a 14                	push   $0x14
  jmp alltraps
80105338:	e9 02 fb ff ff       	jmp    80104e3f <alltraps>

8010533d <vector21>:
.globl vector21
vector21:
  pushl $0
8010533d:	6a 00                	push   $0x0
  pushl $21
8010533f:	6a 15                	push   $0x15
  jmp alltraps
80105341:	e9 f9 fa ff ff       	jmp    80104e3f <alltraps>

80105346 <vector22>:
.globl vector22
vector22:
  pushl $0
80105346:	6a 00                	push   $0x0
  pushl $22
80105348:	6a 16                	push   $0x16
  jmp alltraps
8010534a:	e9 f0 fa ff ff       	jmp    80104e3f <alltraps>

8010534f <vector23>:
.globl vector23
vector23:
  pushl $0
8010534f:	6a 00                	push   $0x0
  pushl $23
80105351:	6a 17                	push   $0x17
  jmp alltraps
80105353:	e9 e7 fa ff ff       	jmp    80104e3f <alltraps>

80105358 <vector24>:
.globl vector24
vector24:
  pushl $0
80105358:	6a 00                	push   $0x0
  pushl $24
8010535a:	6a 18                	push   $0x18
  jmp alltraps
8010535c:	e9 de fa ff ff       	jmp    80104e3f <alltraps>

80105361 <vector25>:
.globl vector25
vector25:
  pushl $0
80105361:	6a 00                	push   $0x0
  pushl $25
80105363:	6a 19                	push   $0x19
  jmp alltraps
80105365:	e9 d5 fa ff ff       	jmp    80104e3f <alltraps>

8010536a <vector26>:
.globl vector26
vector26:
  pushl $0
8010536a:	6a 00                	push   $0x0
  pushl $26
8010536c:	6a 1a                	push   $0x1a
  jmp alltraps
8010536e:	e9 cc fa ff ff       	jmp    80104e3f <alltraps>

80105373 <vector27>:
.globl vector27
vector27:
  pushl $0
80105373:	6a 00                	push   $0x0
  pushl $27
80105375:	6a 1b                	push   $0x1b
  jmp alltraps
80105377:	e9 c3 fa ff ff       	jmp    80104e3f <alltraps>

8010537c <vector28>:
.globl vector28
vector28:
  pushl $0
8010537c:	6a 00                	push   $0x0
  pushl $28
8010537e:	6a 1c                	push   $0x1c
  jmp alltraps
80105380:	e9 ba fa ff ff       	jmp    80104e3f <alltraps>

80105385 <vector29>:
.globl vector29
vector29:
  pushl $0
80105385:	6a 00                	push   $0x0
  pushl $29
80105387:	6a 1d                	push   $0x1d
  jmp alltraps
80105389:	e9 b1 fa ff ff       	jmp    80104e3f <alltraps>

8010538e <vector30>:
.globl vector30
vector30:
  pushl $0
8010538e:	6a 00                	push   $0x0
  pushl $30
80105390:	6a 1e                	push   $0x1e
  jmp alltraps
80105392:	e9 a8 fa ff ff       	jmp    80104e3f <alltraps>

80105397 <vector31>:
.globl vector31
vector31:
  pushl $0
80105397:	6a 00                	push   $0x0
  pushl $31
80105399:	6a 1f                	push   $0x1f
  jmp alltraps
8010539b:	e9 9f fa ff ff       	jmp    80104e3f <alltraps>

801053a0 <vector32>:
.globl vector32
vector32:
  pushl $0
801053a0:	6a 00                	push   $0x0
  pushl $32
801053a2:	6a 20                	push   $0x20
  jmp alltraps
801053a4:	e9 96 fa ff ff       	jmp    80104e3f <alltraps>

801053a9 <vector33>:
.globl vector33
vector33:
  pushl $0
801053a9:	6a 00                	push   $0x0
  pushl $33
801053ab:	6a 21                	push   $0x21
  jmp alltraps
801053ad:	e9 8d fa ff ff       	jmp    80104e3f <alltraps>

801053b2 <vector34>:
.globl vector34
vector34:
  pushl $0
801053b2:	6a 00                	push   $0x0
  pushl $34
801053b4:	6a 22                	push   $0x22
  jmp alltraps
801053b6:	e9 84 fa ff ff       	jmp    80104e3f <alltraps>

801053bb <vector35>:
.globl vector35
vector35:
  pushl $0
801053bb:	6a 00                	push   $0x0
  pushl $35
801053bd:	6a 23                	push   $0x23
  jmp alltraps
801053bf:	e9 7b fa ff ff       	jmp    80104e3f <alltraps>

801053c4 <vector36>:
.globl vector36
vector36:
  pushl $0
801053c4:	6a 00                	push   $0x0
  pushl $36
801053c6:	6a 24                	push   $0x24
  jmp alltraps
801053c8:	e9 72 fa ff ff       	jmp    80104e3f <alltraps>

801053cd <vector37>:
.globl vector37
vector37:
  pushl $0
801053cd:	6a 00                	push   $0x0
  pushl $37
801053cf:	6a 25                	push   $0x25
  jmp alltraps
801053d1:	e9 69 fa ff ff       	jmp    80104e3f <alltraps>

801053d6 <vector38>:
.globl vector38
vector38:
  pushl $0
801053d6:	6a 00                	push   $0x0
  pushl $38
801053d8:	6a 26                	push   $0x26
  jmp alltraps
801053da:	e9 60 fa ff ff       	jmp    80104e3f <alltraps>

801053df <vector39>:
.globl vector39
vector39:
  pushl $0
801053df:	6a 00                	push   $0x0
  pushl $39
801053e1:	6a 27                	push   $0x27
  jmp alltraps
801053e3:	e9 57 fa ff ff       	jmp    80104e3f <alltraps>

801053e8 <vector40>:
.globl vector40
vector40:
  pushl $0
801053e8:	6a 00                	push   $0x0
  pushl $40
801053ea:	6a 28                	push   $0x28
  jmp alltraps
801053ec:	e9 4e fa ff ff       	jmp    80104e3f <alltraps>

801053f1 <vector41>:
.globl vector41
vector41:
  pushl $0
801053f1:	6a 00                	push   $0x0
  pushl $41
801053f3:	6a 29                	push   $0x29
  jmp alltraps
801053f5:	e9 45 fa ff ff       	jmp    80104e3f <alltraps>

801053fa <vector42>:
.globl vector42
vector42:
  pushl $0
801053fa:	6a 00                	push   $0x0
  pushl $42
801053fc:	6a 2a                	push   $0x2a
  jmp alltraps
801053fe:	e9 3c fa ff ff       	jmp    80104e3f <alltraps>

80105403 <vector43>:
.globl vector43
vector43:
  pushl $0
80105403:	6a 00                	push   $0x0
  pushl $43
80105405:	6a 2b                	push   $0x2b
  jmp alltraps
80105407:	e9 33 fa ff ff       	jmp    80104e3f <alltraps>

8010540c <vector44>:
.globl vector44
vector44:
  pushl $0
8010540c:	6a 00                	push   $0x0
  pushl $44
8010540e:	6a 2c                	push   $0x2c
  jmp alltraps
80105410:	e9 2a fa ff ff       	jmp    80104e3f <alltraps>

80105415 <vector45>:
.globl vector45
vector45:
  pushl $0
80105415:	6a 00                	push   $0x0
  pushl $45
80105417:	6a 2d                	push   $0x2d
  jmp alltraps
80105419:	e9 21 fa ff ff       	jmp    80104e3f <alltraps>

8010541e <vector46>:
.globl vector46
vector46:
  pushl $0
8010541e:	6a 00                	push   $0x0
  pushl $46
80105420:	6a 2e                	push   $0x2e
  jmp alltraps
80105422:	e9 18 fa ff ff       	jmp    80104e3f <alltraps>

80105427 <vector47>:
.globl vector47
vector47:
  pushl $0
80105427:	6a 00                	push   $0x0
  pushl $47
80105429:	6a 2f                	push   $0x2f
  jmp alltraps
8010542b:	e9 0f fa ff ff       	jmp    80104e3f <alltraps>

80105430 <vector48>:
.globl vector48
vector48:
  pushl $0
80105430:	6a 00                	push   $0x0
  pushl $48
80105432:	6a 30                	push   $0x30
  jmp alltraps
80105434:	e9 06 fa ff ff       	jmp    80104e3f <alltraps>

80105439 <vector49>:
.globl vector49
vector49:
  pushl $0
80105439:	6a 00                	push   $0x0
  pushl $49
8010543b:	6a 31                	push   $0x31
  jmp alltraps
8010543d:	e9 fd f9 ff ff       	jmp    80104e3f <alltraps>

80105442 <vector50>:
.globl vector50
vector50:
  pushl $0
80105442:	6a 00                	push   $0x0
  pushl $50
80105444:	6a 32                	push   $0x32
  jmp alltraps
80105446:	e9 f4 f9 ff ff       	jmp    80104e3f <alltraps>

8010544b <vector51>:
.globl vector51
vector51:
  pushl $0
8010544b:	6a 00                	push   $0x0
  pushl $51
8010544d:	6a 33                	push   $0x33
  jmp alltraps
8010544f:	e9 eb f9 ff ff       	jmp    80104e3f <alltraps>

80105454 <vector52>:
.globl vector52
vector52:
  pushl $0
80105454:	6a 00                	push   $0x0
  pushl $52
80105456:	6a 34                	push   $0x34
  jmp alltraps
80105458:	e9 e2 f9 ff ff       	jmp    80104e3f <alltraps>

8010545d <vector53>:
.globl vector53
vector53:
  pushl $0
8010545d:	6a 00                	push   $0x0
  pushl $53
8010545f:	6a 35                	push   $0x35
  jmp alltraps
80105461:	e9 d9 f9 ff ff       	jmp    80104e3f <alltraps>

80105466 <vector54>:
.globl vector54
vector54:
  pushl $0
80105466:	6a 00                	push   $0x0
  pushl $54
80105468:	6a 36                	push   $0x36
  jmp alltraps
8010546a:	e9 d0 f9 ff ff       	jmp    80104e3f <alltraps>

8010546f <vector55>:
.globl vector55
vector55:
  pushl $0
8010546f:	6a 00                	push   $0x0
  pushl $55
80105471:	6a 37                	push   $0x37
  jmp alltraps
80105473:	e9 c7 f9 ff ff       	jmp    80104e3f <alltraps>

80105478 <vector56>:
.globl vector56
vector56:
  pushl $0
80105478:	6a 00                	push   $0x0
  pushl $56
8010547a:	6a 38                	push   $0x38
  jmp alltraps
8010547c:	e9 be f9 ff ff       	jmp    80104e3f <alltraps>

80105481 <vector57>:
.globl vector57
vector57:
  pushl $0
80105481:	6a 00                	push   $0x0
  pushl $57
80105483:	6a 39                	push   $0x39
  jmp alltraps
80105485:	e9 b5 f9 ff ff       	jmp    80104e3f <alltraps>

8010548a <vector58>:
.globl vector58
vector58:
  pushl $0
8010548a:	6a 00                	push   $0x0
  pushl $58
8010548c:	6a 3a                	push   $0x3a
  jmp alltraps
8010548e:	e9 ac f9 ff ff       	jmp    80104e3f <alltraps>

80105493 <vector59>:
.globl vector59
vector59:
  pushl $0
80105493:	6a 00                	push   $0x0
  pushl $59
80105495:	6a 3b                	push   $0x3b
  jmp alltraps
80105497:	e9 a3 f9 ff ff       	jmp    80104e3f <alltraps>

8010549c <vector60>:
.globl vector60
vector60:
  pushl $0
8010549c:	6a 00                	push   $0x0
  pushl $60
8010549e:	6a 3c                	push   $0x3c
  jmp alltraps
801054a0:	e9 9a f9 ff ff       	jmp    80104e3f <alltraps>

801054a5 <vector61>:
.globl vector61
vector61:
  pushl $0
801054a5:	6a 00                	push   $0x0
  pushl $61
801054a7:	6a 3d                	push   $0x3d
  jmp alltraps
801054a9:	e9 91 f9 ff ff       	jmp    80104e3f <alltraps>

801054ae <vector62>:
.globl vector62
vector62:
  pushl $0
801054ae:	6a 00                	push   $0x0
  pushl $62
801054b0:	6a 3e                	push   $0x3e
  jmp alltraps
801054b2:	e9 88 f9 ff ff       	jmp    80104e3f <alltraps>

801054b7 <vector63>:
.globl vector63
vector63:
  pushl $0
801054b7:	6a 00                	push   $0x0
  pushl $63
801054b9:	6a 3f                	push   $0x3f
  jmp alltraps
801054bb:	e9 7f f9 ff ff       	jmp    80104e3f <alltraps>

801054c0 <vector64>:
.globl vector64
vector64:
  pushl $0
801054c0:	6a 00                	push   $0x0
  pushl $64
801054c2:	6a 40                	push   $0x40
  jmp alltraps
801054c4:	e9 76 f9 ff ff       	jmp    80104e3f <alltraps>

801054c9 <vector65>:
.globl vector65
vector65:
  pushl $0
801054c9:	6a 00                	push   $0x0
  pushl $65
801054cb:	6a 41                	push   $0x41
  jmp alltraps
801054cd:	e9 6d f9 ff ff       	jmp    80104e3f <alltraps>

801054d2 <vector66>:
.globl vector66
vector66:
  pushl $0
801054d2:	6a 00                	push   $0x0
  pushl $66
801054d4:	6a 42                	push   $0x42
  jmp alltraps
801054d6:	e9 64 f9 ff ff       	jmp    80104e3f <alltraps>

801054db <vector67>:
.globl vector67
vector67:
  pushl $0
801054db:	6a 00                	push   $0x0
  pushl $67
801054dd:	6a 43                	push   $0x43
  jmp alltraps
801054df:	e9 5b f9 ff ff       	jmp    80104e3f <alltraps>

801054e4 <vector68>:
.globl vector68
vector68:
  pushl $0
801054e4:	6a 00                	push   $0x0
  pushl $68
801054e6:	6a 44                	push   $0x44
  jmp alltraps
801054e8:	e9 52 f9 ff ff       	jmp    80104e3f <alltraps>

801054ed <vector69>:
.globl vector69
vector69:
  pushl $0
801054ed:	6a 00                	push   $0x0
  pushl $69
801054ef:	6a 45                	push   $0x45
  jmp alltraps
801054f1:	e9 49 f9 ff ff       	jmp    80104e3f <alltraps>

801054f6 <vector70>:
.globl vector70
vector70:
  pushl $0
801054f6:	6a 00                	push   $0x0
  pushl $70
801054f8:	6a 46                	push   $0x46
  jmp alltraps
801054fa:	e9 40 f9 ff ff       	jmp    80104e3f <alltraps>

801054ff <vector71>:
.globl vector71
vector71:
  pushl $0
801054ff:	6a 00                	push   $0x0
  pushl $71
80105501:	6a 47                	push   $0x47
  jmp alltraps
80105503:	e9 37 f9 ff ff       	jmp    80104e3f <alltraps>

80105508 <vector72>:
.globl vector72
vector72:
  pushl $0
80105508:	6a 00                	push   $0x0
  pushl $72
8010550a:	6a 48                	push   $0x48
  jmp alltraps
8010550c:	e9 2e f9 ff ff       	jmp    80104e3f <alltraps>

80105511 <vector73>:
.globl vector73
vector73:
  pushl $0
80105511:	6a 00                	push   $0x0
  pushl $73
80105513:	6a 49                	push   $0x49
  jmp alltraps
80105515:	e9 25 f9 ff ff       	jmp    80104e3f <alltraps>

8010551a <vector74>:
.globl vector74
vector74:
  pushl $0
8010551a:	6a 00                	push   $0x0
  pushl $74
8010551c:	6a 4a                	push   $0x4a
  jmp alltraps
8010551e:	e9 1c f9 ff ff       	jmp    80104e3f <alltraps>

80105523 <vector75>:
.globl vector75
vector75:
  pushl $0
80105523:	6a 00                	push   $0x0
  pushl $75
80105525:	6a 4b                	push   $0x4b
  jmp alltraps
80105527:	e9 13 f9 ff ff       	jmp    80104e3f <alltraps>

8010552c <vector76>:
.globl vector76
vector76:
  pushl $0
8010552c:	6a 00                	push   $0x0
  pushl $76
8010552e:	6a 4c                	push   $0x4c
  jmp alltraps
80105530:	e9 0a f9 ff ff       	jmp    80104e3f <alltraps>

80105535 <vector77>:
.globl vector77
vector77:
  pushl $0
80105535:	6a 00                	push   $0x0
  pushl $77
80105537:	6a 4d                	push   $0x4d
  jmp alltraps
80105539:	e9 01 f9 ff ff       	jmp    80104e3f <alltraps>

8010553e <vector78>:
.globl vector78
vector78:
  pushl $0
8010553e:	6a 00                	push   $0x0
  pushl $78
80105540:	6a 4e                	push   $0x4e
  jmp alltraps
80105542:	e9 f8 f8 ff ff       	jmp    80104e3f <alltraps>

80105547 <vector79>:
.globl vector79
vector79:
  pushl $0
80105547:	6a 00                	push   $0x0
  pushl $79
80105549:	6a 4f                	push   $0x4f
  jmp alltraps
8010554b:	e9 ef f8 ff ff       	jmp    80104e3f <alltraps>

80105550 <vector80>:
.globl vector80
vector80:
  pushl $0
80105550:	6a 00                	push   $0x0
  pushl $80
80105552:	6a 50                	push   $0x50
  jmp alltraps
80105554:	e9 e6 f8 ff ff       	jmp    80104e3f <alltraps>

80105559 <vector81>:
.globl vector81
vector81:
  pushl $0
80105559:	6a 00                	push   $0x0
  pushl $81
8010555b:	6a 51                	push   $0x51
  jmp alltraps
8010555d:	e9 dd f8 ff ff       	jmp    80104e3f <alltraps>

80105562 <vector82>:
.globl vector82
vector82:
  pushl $0
80105562:	6a 00                	push   $0x0
  pushl $82
80105564:	6a 52                	push   $0x52
  jmp alltraps
80105566:	e9 d4 f8 ff ff       	jmp    80104e3f <alltraps>

8010556b <vector83>:
.globl vector83
vector83:
  pushl $0
8010556b:	6a 00                	push   $0x0
  pushl $83
8010556d:	6a 53                	push   $0x53
  jmp alltraps
8010556f:	e9 cb f8 ff ff       	jmp    80104e3f <alltraps>

80105574 <vector84>:
.globl vector84
vector84:
  pushl $0
80105574:	6a 00                	push   $0x0
  pushl $84
80105576:	6a 54                	push   $0x54
  jmp alltraps
80105578:	e9 c2 f8 ff ff       	jmp    80104e3f <alltraps>

8010557d <vector85>:
.globl vector85
vector85:
  pushl $0
8010557d:	6a 00                	push   $0x0
  pushl $85
8010557f:	6a 55                	push   $0x55
  jmp alltraps
80105581:	e9 b9 f8 ff ff       	jmp    80104e3f <alltraps>

80105586 <vector86>:
.globl vector86
vector86:
  pushl $0
80105586:	6a 00                	push   $0x0
  pushl $86
80105588:	6a 56                	push   $0x56
  jmp alltraps
8010558a:	e9 b0 f8 ff ff       	jmp    80104e3f <alltraps>

8010558f <vector87>:
.globl vector87
vector87:
  pushl $0
8010558f:	6a 00                	push   $0x0
  pushl $87
80105591:	6a 57                	push   $0x57
  jmp alltraps
80105593:	e9 a7 f8 ff ff       	jmp    80104e3f <alltraps>

80105598 <vector88>:
.globl vector88
vector88:
  pushl $0
80105598:	6a 00                	push   $0x0
  pushl $88
8010559a:	6a 58                	push   $0x58
  jmp alltraps
8010559c:	e9 9e f8 ff ff       	jmp    80104e3f <alltraps>

801055a1 <vector89>:
.globl vector89
vector89:
  pushl $0
801055a1:	6a 00                	push   $0x0
  pushl $89
801055a3:	6a 59                	push   $0x59
  jmp alltraps
801055a5:	e9 95 f8 ff ff       	jmp    80104e3f <alltraps>

801055aa <vector90>:
.globl vector90
vector90:
  pushl $0
801055aa:	6a 00                	push   $0x0
  pushl $90
801055ac:	6a 5a                	push   $0x5a
  jmp alltraps
801055ae:	e9 8c f8 ff ff       	jmp    80104e3f <alltraps>

801055b3 <vector91>:
.globl vector91
vector91:
  pushl $0
801055b3:	6a 00                	push   $0x0
  pushl $91
801055b5:	6a 5b                	push   $0x5b
  jmp alltraps
801055b7:	e9 83 f8 ff ff       	jmp    80104e3f <alltraps>

801055bc <vector92>:
.globl vector92
vector92:
  pushl $0
801055bc:	6a 00                	push   $0x0
  pushl $92
801055be:	6a 5c                	push   $0x5c
  jmp alltraps
801055c0:	e9 7a f8 ff ff       	jmp    80104e3f <alltraps>

801055c5 <vector93>:
.globl vector93
vector93:
  pushl $0
801055c5:	6a 00                	push   $0x0
  pushl $93
801055c7:	6a 5d                	push   $0x5d
  jmp alltraps
801055c9:	e9 71 f8 ff ff       	jmp    80104e3f <alltraps>

801055ce <vector94>:
.globl vector94
vector94:
  pushl $0
801055ce:	6a 00                	push   $0x0
  pushl $94
801055d0:	6a 5e                	push   $0x5e
  jmp alltraps
801055d2:	e9 68 f8 ff ff       	jmp    80104e3f <alltraps>

801055d7 <vector95>:
.globl vector95
vector95:
  pushl $0
801055d7:	6a 00                	push   $0x0
  pushl $95
801055d9:	6a 5f                	push   $0x5f
  jmp alltraps
801055db:	e9 5f f8 ff ff       	jmp    80104e3f <alltraps>

801055e0 <vector96>:
.globl vector96
vector96:
  pushl $0
801055e0:	6a 00                	push   $0x0
  pushl $96
801055e2:	6a 60                	push   $0x60
  jmp alltraps
801055e4:	e9 56 f8 ff ff       	jmp    80104e3f <alltraps>

801055e9 <vector97>:
.globl vector97
vector97:
  pushl $0
801055e9:	6a 00                	push   $0x0
  pushl $97
801055eb:	6a 61                	push   $0x61
  jmp alltraps
801055ed:	e9 4d f8 ff ff       	jmp    80104e3f <alltraps>

801055f2 <vector98>:
.globl vector98
vector98:
  pushl $0
801055f2:	6a 00                	push   $0x0
  pushl $98
801055f4:	6a 62                	push   $0x62
  jmp alltraps
801055f6:	e9 44 f8 ff ff       	jmp    80104e3f <alltraps>

801055fb <vector99>:
.globl vector99
vector99:
  pushl $0
801055fb:	6a 00                	push   $0x0
  pushl $99
801055fd:	6a 63                	push   $0x63
  jmp alltraps
801055ff:	e9 3b f8 ff ff       	jmp    80104e3f <alltraps>

80105604 <vector100>:
.globl vector100
vector100:
  pushl $0
80105604:	6a 00                	push   $0x0
  pushl $100
80105606:	6a 64                	push   $0x64
  jmp alltraps
80105608:	e9 32 f8 ff ff       	jmp    80104e3f <alltraps>

8010560d <vector101>:
.globl vector101
vector101:
  pushl $0
8010560d:	6a 00                	push   $0x0
  pushl $101
8010560f:	6a 65                	push   $0x65
  jmp alltraps
80105611:	e9 29 f8 ff ff       	jmp    80104e3f <alltraps>

80105616 <vector102>:
.globl vector102
vector102:
  pushl $0
80105616:	6a 00                	push   $0x0
  pushl $102
80105618:	6a 66                	push   $0x66
  jmp alltraps
8010561a:	e9 20 f8 ff ff       	jmp    80104e3f <alltraps>

8010561f <vector103>:
.globl vector103
vector103:
  pushl $0
8010561f:	6a 00                	push   $0x0
  pushl $103
80105621:	6a 67                	push   $0x67
  jmp alltraps
80105623:	e9 17 f8 ff ff       	jmp    80104e3f <alltraps>

80105628 <vector104>:
.globl vector104
vector104:
  pushl $0
80105628:	6a 00                	push   $0x0
  pushl $104
8010562a:	6a 68                	push   $0x68
  jmp alltraps
8010562c:	e9 0e f8 ff ff       	jmp    80104e3f <alltraps>

80105631 <vector105>:
.globl vector105
vector105:
  pushl $0
80105631:	6a 00                	push   $0x0
  pushl $105
80105633:	6a 69                	push   $0x69
  jmp alltraps
80105635:	e9 05 f8 ff ff       	jmp    80104e3f <alltraps>

8010563a <vector106>:
.globl vector106
vector106:
  pushl $0
8010563a:	6a 00                	push   $0x0
  pushl $106
8010563c:	6a 6a                	push   $0x6a
  jmp alltraps
8010563e:	e9 fc f7 ff ff       	jmp    80104e3f <alltraps>

80105643 <vector107>:
.globl vector107
vector107:
  pushl $0
80105643:	6a 00                	push   $0x0
  pushl $107
80105645:	6a 6b                	push   $0x6b
  jmp alltraps
80105647:	e9 f3 f7 ff ff       	jmp    80104e3f <alltraps>

8010564c <vector108>:
.globl vector108
vector108:
  pushl $0
8010564c:	6a 00                	push   $0x0
  pushl $108
8010564e:	6a 6c                	push   $0x6c
  jmp alltraps
80105650:	e9 ea f7 ff ff       	jmp    80104e3f <alltraps>

80105655 <vector109>:
.globl vector109
vector109:
  pushl $0
80105655:	6a 00                	push   $0x0
  pushl $109
80105657:	6a 6d                	push   $0x6d
  jmp alltraps
80105659:	e9 e1 f7 ff ff       	jmp    80104e3f <alltraps>

8010565e <vector110>:
.globl vector110
vector110:
  pushl $0
8010565e:	6a 00                	push   $0x0
  pushl $110
80105660:	6a 6e                	push   $0x6e
  jmp alltraps
80105662:	e9 d8 f7 ff ff       	jmp    80104e3f <alltraps>

80105667 <vector111>:
.globl vector111
vector111:
  pushl $0
80105667:	6a 00                	push   $0x0
  pushl $111
80105669:	6a 6f                	push   $0x6f
  jmp alltraps
8010566b:	e9 cf f7 ff ff       	jmp    80104e3f <alltraps>

80105670 <vector112>:
.globl vector112
vector112:
  pushl $0
80105670:	6a 00                	push   $0x0
  pushl $112
80105672:	6a 70                	push   $0x70
  jmp alltraps
80105674:	e9 c6 f7 ff ff       	jmp    80104e3f <alltraps>

80105679 <vector113>:
.globl vector113
vector113:
  pushl $0
80105679:	6a 00                	push   $0x0
  pushl $113
8010567b:	6a 71                	push   $0x71
  jmp alltraps
8010567d:	e9 bd f7 ff ff       	jmp    80104e3f <alltraps>

80105682 <vector114>:
.globl vector114
vector114:
  pushl $0
80105682:	6a 00                	push   $0x0
  pushl $114
80105684:	6a 72                	push   $0x72
  jmp alltraps
80105686:	e9 b4 f7 ff ff       	jmp    80104e3f <alltraps>

8010568b <vector115>:
.globl vector115
vector115:
  pushl $0
8010568b:	6a 00                	push   $0x0
  pushl $115
8010568d:	6a 73                	push   $0x73
  jmp alltraps
8010568f:	e9 ab f7 ff ff       	jmp    80104e3f <alltraps>

80105694 <vector116>:
.globl vector116
vector116:
  pushl $0
80105694:	6a 00                	push   $0x0
  pushl $116
80105696:	6a 74                	push   $0x74
  jmp alltraps
80105698:	e9 a2 f7 ff ff       	jmp    80104e3f <alltraps>

8010569d <vector117>:
.globl vector117
vector117:
  pushl $0
8010569d:	6a 00                	push   $0x0
  pushl $117
8010569f:	6a 75                	push   $0x75
  jmp alltraps
801056a1:	e9 99 f7 ff ff       	jmp    80104e3f <alltraps>

801056a6 <vector118>:
.globl vector118
vector118:
  pushl $0
801056a6:	6a 00                	push   $0x0
  pushl $118
801056a8:	6a 76                	push   $0x76
  jmp alltraps
801056aa:	e9 90 f7 ff ff       	jmp    80104e3f <alltraps>

801056af <vector119>:
.globl vector119
vector119:
  pushl $0
801056af:	6a 00                	push   $0x0
  pushl $119
801056b1:	6a 77                	push   $0x77
  jmp alltraps
801056b3:	e9 87 f7 ff ff       	jmp    80104e3f <alltraps>

801056b8 <vector120>:
.globl vector120
vector120:
  pushl $0
801056b8:	6a 00                	push   $0x0
  pushl $120
801056ba:	6a 78                	push   $0x78
  jmp alltraps
801056bc:	e9 7e f7 ff ff       	jmp    80104e3f <alltraps>

801056c1 <vector121>:
.globl vector121
vector121:
  pushl $0
801056c1:	6a 00                	push   $0x0
  pushl $121
801056c3:	6a 79                	push   $0x79
  jmp alltraps
801056c5:	e9 75 f7 ff ff       	jmp    80104e3f <alltraps>

801056ca <vector122>:
.globl vector122
vector122:
  pushl $0
801056ca:	6a 00                	push   $0x0
  pushl $122
801056cc:	6a 7a                	push   $0x7a
  jmp alltraps
801056ce:	e9 6c f7 ff ff       	jmp    80104e3f <alltraps>

801056d3 <vector123>:
.globl vector123
vector123:
  pushl $0
801056d3:	6a 00                	push   $0x0
  pushl $123
801056d5:	6a 7b                	push   $0x7b
  jmp alltraps
801056d7:	e9 63 f7 ff ff       	jmp    80104e3f <alltraps>

801056dc <vector124>:
.globl vector124
vector124:
  pushl $0
801056dc:	6a 00                	push   $0x0
  pushl $124
801056de:	6a 7c                	push   $0x7c
  jmp alltraps
801056e0:	e9 5a f7 ff ff       	jmp    80104e3f <alltraps>

801056e5 <vector125>:
.globl vector125
vector125:
  pushl $0
801056e5:	6a 00                	push   $0x0
  pushl $125
801056e7:	6a 7d                	push   $0x7d
  jmp alltraps
801056e9:	e9 51 f7 ff ff       	jmp    80104e3f <alltraps>

801056ee <vector126>:
.globl vector126
vector126:
  pushl $0
801056ee:	6a 00                	push   $0x0
  pushl $126
801056f0:	6a 7e                	push   $0x7e
  jmp alltraps
801056f2:	e9 48 f7 ff ff       	jmp    80104e3f <alltraps>

801056f7 <vector127>:
.globl vector127
vector127:
  pushl $0
801056f7:	6a 00                	push   $0x0
  pushl $127
801056f9:	6a 7f                	push   $0x7f
  jmp alltraps
801056fb:	e9 3f f7 ff ff       	jmp    80104e3f <alltraps>

80105700 <vector128>:
.globl vector128
vector128:
  pushl $0
80105700:	6a 00                	push   $0x0
  pushl $128
80105702:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105707:	e9 33 f7 ff ff       	jmp    80104e3f <alltraps>

8010570c <vector129>:
.globl vector129
vector129:
  pushl $0
8010570c:	6a 00                	push   $0x0
  pushl $129
8010570e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105713:	e9 27 f7 ff ff       	jmp    80104e3f <alltraps>

80105718 <vector130>:
.globl vector130
vector130:
  pushl $0
80105718:	6a 00                	push   $0x0
  pushl $130
8010571a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010571f:	e9 1b f7 ff ff       	jmp    80104e3f <alltraps>

80105724 <vector131>:
.globl vector131
vector131:
  pushl $0
80105724:	6a 00                	push   $0x0
  pushl $131
80105726:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010572b:	e9 0f f7 ff ff       	jmp    80104e3f <alltraps>

80105730 <vector132>:
.globl vector132
vector132:
  pushl $0
80105730:	6a 00                	push   $0x0
  pushl $132
80105732:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105737:	e9 03 f7 ff ff       	jmp    80104e3f <alltraps>

8010573c <vector133>:
.globl vector133
vector133:
  pushl $0
8010573c:	6a 00                	push   $0x0
  pushl $133
8010573e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105743:	e9 f7 f6 ff ff       	jmp    80104e3f <alltraps>

80105748 <vector134>:
.globl vector134
vector134:
  pushl $0
80105748:	6a 00                	push   $0x0
  pushl $134
8010574a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010574f:	e9 eb f6 ff ff       	jmp    80104e3f <alltraps>

80105754 <vector135>:
.globl vector135
vector135:
  pushl $0
80105754:	6a 00                	push   $0x0
  pushl $135
80105756:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010575b:	e9 df f6 ff ff       	jmp    80104e3f <alltraps>

80105760 <vector136>:
.globl vector136
vector136:
  pushl $0
80105760:	6a 00                	push   $0x0
  pushl $136
80105762:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105767:	e9 d3 f6 ff ff       	jmp    80104e3f <alltraps>

8010576c <vector137>:
.globl vector137
vector137:
  pushl $0
8010576c:	6a 00                	push   $0x0
  pushl $137
8010576e:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105773:	e9 c7 f6 ff ff       	jmp    80104e3f <alltraps>

80105778 <vector138>:
.globl vector138
vector138:
  pushl $0
80105778:	6a 00                	push   $0x0
  pushl $138
8010577a:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010577f:	e9 bb f6 ff ff       	jmp    80104e3f <alltraps>

80105784 <vector139>:
.globl vector139
vector139:
  pushl $0
80105784:	6a 00                	push   $0x0
  pushl $139
80105786:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010578b:	e9 af f6 ff ff       	jmp    80104e3f <alltraps>

80105790 <vector140>:
.globl vector140
vector140:
  pushl $0
80105790:	6a 00                	push   $0x0
  pushl $140
80105792:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105797:	e9 a3 f6 ff ff       	jmp    80104e3f <alltraps>

8010579c <vector141>:
.globl vector141
vector141:
  pushl $0
8010579c:	6a 00                	push   $0x0
  pushl $141
8010579e:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801057a3:	e9 97 f6 ff ff       	jmp    80104e3f <alltraps>

801057a8 <vector142>:
.globl vector142
vector142:
  pushl $0
801057a8:	6a 00                	push   $0x0
  pushl $142
801057aa:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801057af:	e9 8b f6 ff ff       	jmp    80104e3f <alltraps>

801057b4 <vector143>:
.globl vector143
vector143:
  pushl $0
801057b4:	6a 00                	push   $0x0
  pushl $143
801057b6:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801057bb:	e9 7f f6 ff ff       	jmp    80104e3f <alltraps>

801057c0 <vector144>:
.globl vector144
vector144:
  pushl $0
801057c0:	6a 00                	push   $0x0
  pushl $144
801057c2:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801057c7:	e9 73 f6 ff ff       	jmp    80104e3f <alltraps>

801057cc <vector145>:
.globl vector145
vector145:
  pushl $0
801057cc:	6a 00                	push   $0x0
  pushl $145
801057ce:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801057d3:	e9 67 f6 ff ff       	jmp    80104e3f <alltraps>

801057d8 <vector146>:
.globl vector146
vector146:
  pushl $0
801057d8:	6a 00                	push   $0x0
  pushl $146
801057da:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801057df:	e9 5b f6 ff ff       	jmp    80104e3f <alltraps>

801057e4 <vector147>:
.globl vector147
vector147:
  pushl $0
801057e4:	6a 00                	push   $0x0
  pushl $147
801057e6:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801057eb:	e9 4f f6 ff ff       	jmp    80104e3f <alltraps>

801057f0 <vector148>:
.globl vector148
vector148:
  pushl $0
801057f0:	6a 00                	push   $0x0
  pushl $148
801057f2:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801057f7:	e9 43 f6 ff ff       	jmp    80104e3f <alltraps>

801057fc <vector149>:
.globl vector149
vector149:
  pushl $0
801057fc:	6a 00                	push   $0x0
  pushl $149
801057fe:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105803:	e9 37 f6 ff ff       	jmp    80104e3f <alltraps>

80105808 <vector150>:
.globl vector150
vector150:
  pushl $0
80105808:	6a 00                	push   $0x0
  pushl $150
8010580a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010580f:	e9 2b f6 ff ff       	jmp    80104e3f <alltraps>

80105814 <vector151>:
.globl vector151
vector151:
  pushl $0
80105814:	6a 00                	push   $0x0
  pushl $151
80105816:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010581b:	e9 1f f6 ff ff       	jmp    80104e3f <alltraps>

80105820 <vector152>:
.globl vector152
vector152:
  pushl $0
80105820:	6a 00                	push   $0x0
  pushl $152
80105822:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105827:	e9 13 f6 ff ff       	jmp    80104e3f <alltraps>

8010582c <vector153>:
.globl vector153
vector153:
  pushl $0
8010582c:	6a 00                	push   $0x0
  pushl $153
8010582e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105833:	e9 07 f6 ff ff       	jmp    80104e3f <alltraps>

80105838 <vector154>:
.globl vector154
vector154:
  pushl $0
80105838:	6a 00                	push   $0x0
  pushl $154
8010583a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010583f:	e9 fb f5 ff ff       	jmp    80104e3f <alltraps>

80105844 <vector155>:
.globl vector155
vector155:
  pushl $0
80105844:	6a 00                	push   $0x0
  pushl $155
80105846:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010584b:	e9 ef f5 ff ff       	jmp    80104e3f <alltraps>

80105850 <vector156>:
.globl vector156
vector156:
  pushl $0
80105850:	6a 00                	push   $0x0
  pushl $156
80105852:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105857:	e9 e3 f5 ff ff       	jmp    80104e3f <alltraps>

8010585c <vector157>:
.globl vector157
vector157:
  pushl $0
8010585c:	6a 00                	push   $0x0
  pushl $157
8010585e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105863:	e9 d7 f5 ff ff       	jmp    80104e3f <alltraps>

80105868 <vector158>:
.globl vector158
vector158:
  pushl $0
80105868:	6a 00                	push   $0x0
  pushl $158
8010586a:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010586f:	e9 cb f5 ff ff       	jmp    80104e3f <alltraps>

80105874 <vector159>:
.globl vector159
vector159:
  pushl $0
80105874:	6a 00                	push   $0x0
  pushl $159
80105876:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010587b:	e9 bf f5 ff ff       	jmp    80104e3f <alltraps>

80105880 <vector160>:
.globl vector160
vector160:
  pushl $0
80105880:	6a 00                	push   $0x0
  pushl $160
80105882:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105887:	e9 b3 f5 ff ff       	jmp    80104e3f <alltraps>

8010588c <vector161>:
.globl vector161
vector161:
  pushl $0
8010588c:	6a 00                	push   $0x0
  pushl $161
8010588e:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105893:	e9 a7 f5 ff ff       	jmp    80104e3f <alltraps>

80105898 <vector162>:
.globl vector162
vector162:
  pushl $0
80105898:	6a 00                	push   $0x0
  pushl $162
8010589a:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010589f:	e9 9b f5 ff ff       	jmp    80104e3f <alltraps>

801058a4 <vector163>:
.globl vector163
vector163:
  pushl $0
801058a4:	6a 00                	push   $0x0
  pushl $163
801058a6:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801058ab:	e9 8f f5 ff ff       	jmp    80104e3f <alltraps>

801058b0 <vector164>:
.globl vector164
vector164:
  pushl $0
801058b0:	6a 00                	push   $0x0
  pushl $164
801058b2:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801058b7:	e9 83 f5 ff ff       	jmp    80104e3f <alltraps>

801058bc <vector165>:
.globl vector165
vector165:
  pushl $0
801058bc:	6a 00                	push   $0x0
  pushl $165
801058be:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801058c3:	e9 77 f5 ff ff       	jmp    80104e3f <alltraps>

801058c8 <vector166>:
.globl vector166
vector166:
  pushl $0
801058c8:	6a 00                	push   $0x0
  pushl $166
801058ca:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801058cf:	e9 6b f5 ff ff       	jmp    80104e3f <alltraps>

801058d4 <vector167>:
.globl vector167
vector167:
  pushl $0
801058d4:	6a 00                	push   $0x0
  pushl $167
801058d6:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801058db:	e9 5f f5 ff ff       	jmp    80104e3f <alltraps>

801058e0 <vector168>:
.globl vector168
vector168:
  pushl $0
801058e0:	6a 00                	push   $0x0
  pushl $168
801058e2:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801058e7:	e9 53 f5 ff ff       	jmp    80104e3f <alltraps>

801058ec <vector169>:
.globl vector169
vector169:
  pushl $0
801058ec:	6a 00                	push   $0x0
  pushl $169
801058ee:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801058f3:	e9 47 f5 ff ff       	jmp    80104e3f <alltraps>

801058f8 <vector170>:
.globl vector170
vector170:
  pushl $0
801058f8:	6a 00                	push   $0x0
  pushl $170
801058fa:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801058ff:	e9 3b f5 ff ff       	jmp    80104e3f <alltraps>

80105904 <vector171>:
.globl vector171
vector171:
  pushl $0
80105904:	6a 00                	push   $0x0
  pushl $171
80105906:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010590b:	e9 2f f5 ff ff       	jmp    80104e3f <alltraps>

80105910 <vector172>:
.globl vector172
vector172:
  pushl $0
80105910:	6a 00                	push   $0x0
  pushl $172
80105912:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105917:	e9 23 f5 ff ff       	jmp    80104e3f <alltraps>

8010591c <vector173>:
.globl vector173
vector173:
  pushl $0
8010591c:	6a 00                	push   $0x0
  pushl $173
8010591e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105923:	e9 17 f5 ff ff       	jmp    80104e3f <alltraps>

80105928 <vector174>:
.globl vector174
vector174:
  pushl $0
80105928:	6a 00                	push   $0x0
  pushl $174
8010592a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010592f:	e9 0b f5 ff ff       	jmp    80104e3f <alltraps>

80105934 <vector175>:
.globl vector175
vector175:
  pushl $0
80105934:	6a 00                	push   $0x0
  pushl $175
80105936:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010593b:	e9 ff f4 ff ff       	jmp    80104e3f <alltraps>

80105940 <vector176>:
.globl vector176
vector176:
  pushl $0
80105940:	6a 00                	push   $0x0
  pushl $176
80105942:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105947:	e9 f3 f4 ff ff       	jmp    80104e3f <alltraps>

8010594c <vector177>:
.globl vector177
vector177:
  pushl $0
8010594c:	6a 00                	push   $0x0
  pushl $177
8010594e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105953:	e9 e7 f4 ff ff       	jmp    80104e3f <alltraps>

80105958 <vector178>:
.globl vector178
vector178:
  pushl $0
80105958:	6a 00                	push   $0x0
  pushl $178
8010595a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010595f:	e9 db f4 ff ff       	jmp    80104e3f <alltraps>

80105964 <vector179>:
.globl vector179
vector179:
  pushl $0
80105964:	6a 00                	push   $0x0
  pushl $179
80105966:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010596b:	e9 cf f4 ff ff       	jmp    80104e3f <alltraps>

80105970 <vector180>:
.globl vector180
vector180:
  pushl $0
80105970:	6a 00                	push   $0x0
  pushl $180
80105972:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105977:	e9 c3 f4 ff ff       	jmp    80104e3f <alltraps>

8010597c <vector181>:
.globl vector181
vector181:
  pushl $0
8010597c:	6a 00                	push   $0x0
  pushl $181
8010597e:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105983:	e9 b7 f4 ff ff       	jmp    80104e3f <alltraps>

80105988 <vector182>:
.globl vector182
vector182:
  pushl $0
80105988:	6a 00                	push   $0x0
  pushl $182
8010598a:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010598f:	e9 ab f4 ff ff       	jmp    80104e3f <alltraps>

80105994 <vector183>:
.globl vector183
vector183:
  pushl $0
80105994:	6a 00                	push   $0x0
  pushl $183
80105996:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010599b:	e9 9f f4 ff ff       	jmp    80104e3f <alltraps>

801059a0 <vector184>:
.globl vector184
vector184:
  pushl $0
801059a0:	6a 00                	push   $0x0
  pushl $184
801059a2:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801059a7:	e9 93 f4 ff ff       	jmp    80104e3f <alltraps>

801059ac <vector185>:
.globl vector185
vector185:
  pushl $0
801059ac:	6a 00                	push   $0x0
  pushl $185
801059ae:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801059b3:	e9 87 f4 ff ff       	jmp    80104e3f <alltraps>

801059b8 <vector186>:
.globl vector186
vector186:
  pushl $0
801059b8:	6a 00                	push   $0x0
  pushl $186
801059ba:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801059bf:	e9 7b f4 ff ff       	jmp    80104e3f <alltraps>

801059c4 <vector187>:
.globl vector187
vector187:
  pushl $0
801059c4:	6a 00                	push   $0x0
  pushl $187
801059c6:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801059cb:	e9 6f f4 ff ff       	jmp    80104e3f <alltraps>

801059d0 <vector188>:
.globl vector188
vector188:
  pushl $0
801059d0:	6a 00                	push   $0x0
  pushl $188
801059d2:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801059d7:	e9 63 f4 ff ff       	jmp    80104e3f <alltraps>

801059dc <vector189>:
.globl vector189
vector189:
  pushl $0
801059dc:	6a 00                	push   $0x0
  pushl $189
801059de:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801059e3:	e9 57 f4 ff ff       	jmp    80104e3f <alltraps>

801059e8 <vector190>:
.globl vector190
vector190:
  pushl $0
801059e8:	6a 00                	push   $0x0
  pushl $190
801059ea:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801059ef:	e9 4b f4 ff ff       	jmp    80104e3f <alltraps>

801059f4 <vector191>:
.globl vector191
vector191:
  pushl $0
801059f4:	6a 00                	push   $0x0
  pushl $191
801059f6:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801059fb:	e9 3f f4 ff ff       	jmp    80104e3f <alltraps>

80105a00 <vector192>:
.globl vector192
vector192:
  pushl $0
80105a00:	6a 00                	push   $0x0
  pushl $192
80105a02:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105a07:	e9 33 f4 ff ff       	jmp    80104e3f <alltraps>

80105a0c <vector193>:
.globl vector193
vector193:
  pushl $0
80105a0c:	6a 00                	push   $0x0
  pushl $193
80105a0e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105a13:	e9 27 f4 ff ff       	jmp    80104e3f <alltraps>

80105a18 <vector194>:
.globl vector194
vector194:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $194
80105a1a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105a1f:	e9 1b f4 ff ff       	jmp    80104e3f <alltraps>

80105a24 <vector195>:
.globl vector195
vector195:
  pushl $0
80105a24:	6a 00                	push   $0x0
  pushl $195
80105a26:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105a2b:	e9 0f f4 ff ff       	jmp    80104e3f <alltraps>

80105a30 <vector196>:
.globl vector196
vector196:
  pushl $0
80105a30:	6a 00                	push   $0x0
  pushl $196
80105a32:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105a37:	e9 03 f4 ff ff       	jmp    80104e3f <alltraps>

80105a3c <vector197>:
.globl vector197
vector197:
  pushl $0
80105a3c:	6a 00                	push   $0x0
  pushl $197
80105a3e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105a43:	e9 f7 f3 ff ff       	jmp    80104e3f <alltraps>

80105a48 <vector198>:
.globl vector198
vector198:
  pushl $0
80105a48:	6a 00                	push   $0x0
  pushl $198
80105a4a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105a4f:	e9 eb f3 ff ff       	jmp    80104e3f <alltraps>

80105a54 <vector199>:
.globl vector199
vector199:
  pushl $0
80105a54:	6a 00                	push   $0x0
  pushl $199
80105a56:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105a5b:	e9 df f3 ff ff       	jmp    80104e3f <alltraps>

80105a60 <vector200>:
.globl vector200
vector200:
  pushl $0
80105a60:	6a 00                	push   $0x0
  pushl $200
80105a62:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105a67:	e9 d3 f3 ff ff       	jmp    80104e3f <alltraps>

80105a6c <vector201>:
.globl vector201
vector201:
  pushl $0
80105a6c:	6a 00                	push   $0x0
  pushl $201
80105a6e:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105a73:	e9 c7 f3 ff ff       	jmp    80104e3f <alltraps>

80105a78 <vector202>:
.globl vector202
vector202:
  pushl $0
80105a78:	6a 00                	push   $0x0
  pushl $202
80105a7a:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105a7f:	e9 bb f3 ff ff       	jmp    80104e3f <alltraps>

80105a84 <vector203>:
.globl vector203
vector203:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $203
80105a86:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105a8b:	e9 af f3 ff ff       	jmp    80104e3f <alltraps>

80105a90 <vector204>:
.globl vector204
vector204:
  pushl $0
80105a90:	6a 00                	push   $0x0
  pushl $204
80105a92:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105a97:	e9 a3 f3 ff ff       	jmp    80104e3f <alltraps>

80105a9c <vector205>:
.globl vector205
vector205:
  pushl $0
80105a9c:	6a 00                	push   $0x0
  pushl $205
80105a9e:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105aa3:	e9 97 f3 ff ff       	jmp    80104e3f <alltraps>

80105aa8 <vector206>:
.globl vector206
vector206:
  pushl $0
80105aa8:	6a 00                	push   $0x0
  pushl $206
80105aaa:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105aaf:	e9 8b f3 ff ff       	jmp    80104e3f <alltraps>

80105ab4 <vector207>:
.globl vector207
vector207:
  pushl $0
80105ab4:	6a 00                	push   $0x0
  pushl $207
80105ab6:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105abb:	e9 7f f3 ff ff       	jmp    80104e3f <alltraps>

80105ac0 <vector208>:
.globl vector208
vector208:
  pushl $0
80105ac0:	6a 00                	push   $0x0
  pushl $208
80105ac2:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105ac7:	e9 73 f3 ff ff       	jmp    80104e3f <alltraps>

80105acc <vector209>:
.globl vector209
vector209:
  pushl $0
80105acc:	6a 00                	push   $0x0
  pushl $209
80105ace:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105ad3:	e9 67 f3 ff ff       	jmp    80104e3f <alltraps>

80105ad8 <vector210>:
.globl vector210
vector210:
  pushl $0
80105ad8:	6a 00                	push   $0x0
  pushl $210
80105ada:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105adf:	e9 5b f3 ff ff       	jmp    80104e3f <alltraps>

80105ae4 <vector211>:
.globl vector211
vector211:
  pushl $0
80105ae4:	6a 00                	push   $0x0
  pushl $211
80105ae6:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105aeb:	e9 4f f3 ff ff       	jmp    80104e3f <alltraps>

80105af0 <vector212>:
.globl vector212
vector212:
  pushl $0
80105af0:	6a 00                	push   $0x0
  pushl $212
80105af2:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105af7:	e9 43 f3 ff ff       	jmp    80104e3f <alltraps>

80105afc <vector213>:
.globl vector213
vector213:
  pushl $0
80105afc:	6a 00                	push   $0x0
  pushl $213
80105afe:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105b03:	e9 37 f3 ff ff       	jmp    80104e3f <alltraps>

80105b08 <vector214>:
.globl vector214
vector214:
  pushl $0
80105b08:	6a 00                	push   $0x0
  pushl $214
80105b0a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105b0f:	e9 2b f3 ff ff       	jmp    80104e3f <alltraps>

80105b14 <vector215>:
.globl vector215
vector215:
  pushl $0
80105b14:	6a 00                	push   $0x0
  pushl $215
80105b16:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105b1b:	e9 1f f3 ff ff       	jmp    80104e3f <alltraps>

80105b20 <vector216>:
.globl vector216
vector216:
  pushl $0
80105b20:	6a 00                	push   $0x0
  pushl $216
80105b22:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105b27:	e9 13 f3 ff ff       	jmp    80104e3f <alltraps>

80105b2c <vector217>:
.globl vector217
vector217:
  pushl $0
80105b2c:	6a 00                	push   $0x0
  pushl $217
80105b2e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105b33:	e9 07 f3 ff ff       	jmp    80104e3f <alltraps>

80105b38 <vector218>:
.globl vector218
vector218:
  pushl $0
80105b38:	6a 00                	push   $0x0
  pushl $218
80105b3a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105b3f:	e9 fb f2 ff ff       	jmp    80104e3f <alltraps>

80105b44 <vector219>:
.globl vector219
vector219:
  pushl $0
80105b44:	6a 00                	push   $0x0
  pushl $219
80105b46:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105b4b:	e9 ef f2 ff ff       	jmp    80104e3f <alltraps>

80105b50 <vector220>:
.globl vector220
vector220:
  pushl $0
80105b50:	6a 00                	push   $0x0
  pushl $220
80105b52:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105b57:	e9 e3 f2 ff ff       	jmp    80104e3f <alltraps>

80105b5c <vector221>:
.globl vector221
vector221:
  pushl $0
80105b5c:	6a 00                	push   $0x0
  pushl $221
80105b5e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105b63:	e9 d7 f2 ff ff       	jmp    80104e3f <alltraps>

80105b68 <vector222>:
.globl vector222
vector222:
  pushl $0
80105b68:	6a 00                	push   $0x0
  pushl $222
80105b6a:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105b6f:	e9 cb f2 ff ff       	jmp    80104e3f <alltraps>

80105b74 <vector223>:
.globl vector223
vector223:
  pushl $0
80105b74:	6a 00                	push   $0x0
  pushl $223
80105b76:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105b7b:	e9 bf f2 ff ff       	jmp    80104e3f <alltraps>

80105b80 <vector224>:
.globl vector224
vector224:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $224
80105b82:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105b87:	e9 b3 f2 ff ff       	jmp    80104e3f <alltraps>

80105b8c <vector225>:
.globl vector225
vector225:
  pushl $0
80105b8c:	6a 00                	push   $0x0
  pushl $225
80105b8e:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105b93:	e9 a7 f2 ff ff       	jmp    80104e3f <alltraps>

80105b98 <vector226>:
.globl vector226
vector226:
  pushl $0
80105b98:	6a 00                	push   $0x0
  pushl $226
80105b9a:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105b9f:	e9 9b f2 ff ff       	jmp    80104e3f <alltraps>

80105ba4 <vector227>:
.globl vector227
vector227:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $227
80105ba6:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105bab:	e9 8f f2 ff ff       	jmp    80104e3f <alltraps>

80105bb0 <vector228>:
.globl vector228
vector228:
  pushl $0
80105bb0:	6a 00                	push   $0x0
  pushl $228
80105bb2:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105bb7:	e9 83 f2 ff ff       	jmp    80104e3f <alltraps>

80105bbc <vector229>:
.globl vector229
vector229:
  pushl $0
80105bbc:	6a 00                	push   $0x0
  pushl $229
80105bbe:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105bc3:	e9 77 f2 ff ff       	jmp    80104e3f <alltraps>

80105bc8 <vector230>:
.globl vector230
vector230:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $230
80105bca:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105bcf:	e9 6b f2 ff ff       	jmp    80104e3f <alltraps>

80105bd4 <vector231>:
.globl vector231
vector231:
  pushl $0
80105bd4:	6a 00                	push   $0x0
  pushl $231
80105bd6:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105bdb:	e9 5f f2 ff ff       	jmp    80104e3f <alltraps>

80105be0 <vector232>:
.globl vector232
vector232:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $232
80105be2:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105be7:	e9 53 f2 ff ff       	jmp    80104e3f <alltraps>

80105bec <vector233>:
.globl vector233
vector233:
  pushl $0
80105bec:	6a 00                	push   $0x0
  pushl $233
80105bee:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105bf3:	e9 47 f2 ff ff       	jmp    80104e3f <alltraps>

80105bf8 <vector234>:
.globl vector234
vector234:
  pushl $0
80105bf8:	6a 00                	push   $0x0
  pushl $234
80105bfa:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105bff:	e9 3b f2 ff ff       	jmp    80104e3f <alltraps>

80105c04 <vector235>:
.globl vector235
vector235:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $235
80105c06:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105c0b:	e9 2f f2 ff ff       	jmp    80104e3f <alltraps>

80105c10 <vector236>:
.globl vector236
vector236:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $236
80105c12:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105c17:	e9 23 f2 ff ff       	jmp    80104e3f <alltraps>

80105c1c <vector237>:
.globl vector237
vector237:
  pushl $0
80105c1c:	6a 00                	push   $0x0
  pushl $237
80105c1e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105c23:	e9 17 f2 ff ff       	jmp    80104e3f <alltraps>

80105c28 <vector238>:
.globl vector238
vector238:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $238
80105c2a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105c2f:	e9 0b f2 ff ff       	jmp    80104e3f <alltraps>

80105c34 <vector239>:
.globl vector239
vector239:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $239
80105c36:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105c3b:	e9 ff f1 ff ff       	jmp    80104e3f <alltraps>

80105c40 <vector240>:
.globl vector240
vector240:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $240
80105c42:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105c47:	e9 f3 f1 ff ff       	jmp    80104e3f <alltraps>

80105c4c <vector241>:
.globl vector241
vector241:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $241
80105c4e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105c53:	e9 e7 f1 ff ff       	jmp    80104e3f <alltraps>

80105c58 <vector242>:
.globl vector242
vector242:
  pushl $0
80105c58:	6a 00                	push   $0x0
  pushl $242
80105c5a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105c5f:	e9 db f1 ff ff       	jmp    80104e3f <alltraps>

80105c64 <vector243>:
.globl vector243
vector243:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $243
80105c66:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105c6b:	e9 cf f1 ff ff       	jmp    80104e3f <alltraps>

80105c70 <vector244>:
.globl vector244
vector244:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $244
80105c72:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105c77:	e9 c3 f1 ff ff       	jmp    80104e3f <alltraps>

80105c7c <vector245>:
.globl vector245
vector245:
  pushl $0
80105c7c:	6a 00                	push   $0x0
  pushl $245
80105c7e:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105c83:	e9 b7 f1 ff ff       	jmp    80104e3f <alltraps>

80105c88 <vector246>:
.globl vector246
vector246:
  pushl $0
80105c88:	6a 00                	push   $0x0
  pushl $246
80105c8a:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105c8f:	e9 ab f1 ff ff       	jmp    80104e3f <alltraps>

80105c94 <vector247>:
.globl vector247
vector247:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $247
80105c96:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105c9b:	e9 9f f1 ff ff       	jmp    80104e3f <alltraps>

80105ca0 <vector248>:
.globl vector248
vector248:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $248
80105ca2:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105ca7:	e9 93 f1 ff ff       	jmp    80104e3f <alltraps>

80105cac <vector249>:
.globl vector249
vector249:
  pushl $0
80105cac:	6a 00                	push   $0x0
  pushl $249
80105cae:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105cb3:	e9 87 f1 ff ff       	jmp    80104e3f <alltraps>

80105cb8 <vector250>:
.globl vector250
vector250:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $250
80105cba:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105cbf:	e9 7b f1 ff ff       	jmp    80104e3f <alltraps>

80105cc4 <vector251>:
.globl vector251
vector251:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $251
80105cc6:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105ccb:	e9 6f f1 ff ff       	jmp    80104e3f <alltraps>

80105cd0 <vector252>:
.globl vector252
vector252:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $252
80105cd2:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105cd7:	e9 63 f1 ff ff       	jmp    80104e3f <alltraps>

80105cdc <vector253>:
.globl vector253
vector253:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $253
80105cde:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105ce3:	e9 57 f1 ff ff       	jmp    80104e3f <alltraps>

80105ce8 <vector254>:
.globl vector254
vector254:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $254
80105cea:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105cef:	e9 4b f1 ff ff       	jmp    80104e3f <alltraps>

80105cf4 <vector255>:
.globl vector255
vector255:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $255
80105cf6:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105cfb:	e9 3f f1 ff ff       	jmp    80104e3f <alltraps>

80105d00 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	57                   	push   %edi
80105d04:	56                   	push   %esi
80105d05:	53                   	push   %ebx
80105d06:	83 ec 0c             	sub    $0xc,%esp
80105d09:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105d0b:	c1 ea 16             	shr    $0x16,%edx
80105d0e:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105d11:	8b 37                	mov    (%edi),%esi
80105d13:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105d19:	74 20                	je     80105d3b <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105d1b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105d21:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d27:	c1 eb 0c             	shr    $0xc,%ebx
80105d2a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105d30:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d36:	5b                   	pop    %ebx
80105d37:	5e                   	pop    %esi
80105d38:	5f                   	pop    %edi
80105d39:	5d                   	pop    %ebp
80105d3a:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105d3b:	85 c9                	test   %ecx,%ecx
80105d3d:	74 2b                	je     80105d6a <walkpgdir+0x6a>
80105d3f:	e8 0e c4 ff ff       	call   80102152 <kalloc>
80105d44:	89 c6                	mov    %eax,%esi
80105d46:	85 c0                	test   %eax,%eax
80105d48:	74 20                	je     80105d6a <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105d4a:	83 ec 04             	sub    $0x4,%esp
80105d4d:	68 00 10 00 00       	push   $0x1000
80105d52:	6a 00                	push   $0x0
80105d54:	50                   	push   %eax
80105d55:	e8 15 e0 ff ff       	call   80103d6f <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105d5a:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105d60:	83 c8 07             	or     $0x7,%eax
80105d63:	89 07                	mov    %eax,(%edi)
80105d65:	83 c4 10             	add    $0x10,%esp
80105d68:	eb bd                	jmp    80105d27 <walkpgdir+0x27>
      return 0;
80105d6a:	b8 00 00 00 00       	mov    $0x0,%eax
80105d6f:	eb c2                	jmp    80105d33 <walkpgdir+0x33>

80105d71 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105d71:	55                   	push   %ebp
80105d72:	89 e5                	mov    %esp,%ebp
80105d74:	57                   	push   %edi
80105d75:	56                   	push   %esi
80105d76:	53                   	push   %ebx
80105d77:	83 ec 1c             	sub    $0x1c,%esp
80105d7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105d7d:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105d80:	89 d3                	mov    %edx,%ebx
80105d82:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105d88:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80105d8c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105d92:	b9 01 00 00 00       	mov    $0x1,%ecx
80105d97:	89 da                	mov    %ebx,%edx
80105d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d9c:	e8 5f ff ff ff       	call   80105d00 <walkpgdir>
80105da1:	85 c0                	test   %eax,%eax
80105da3:	74 2e                	je     80105dd3 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80105da5:	f6 00 01             	testb  $0x1,(%eax)
80105da8:	75 1c                	jne    80105dc6 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105daa:	89 f2                	mov    %esi,%edx
80105dac:	0b 55 0c             	or     0xc(%ebp),%edx
80105daf:	83 ca 01             	or     $0x1,%edx
80105db2:	89 10                	mov    %edx,(%eax)
    if(a == last)
80105db4:	39 fb                	cmp    %edi,%ebx
80105db6:	74 28                	je     80105de0 <mappages+0x6f>
      break;
    a += PGSIZE;
80105db8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80105dbe:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105dc4:	eb cc                	jmp    80105d92 <mappages+0x21>
      panic("remap");
80105dc6:	83 ec 0c             	sub    $0xc,%esp
80105dc9:	68 88 6e 10 80       	push   $0x80106e88
80105dce:	e8 89 a5 ff ff       	call   8010035c <panic>
      return -1;
80105dd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80105dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ddb:	5b                   	pop    %ebx
80105ddc:	5e                   	pop    %esi
80105ddd:	5f                   	pop    %edi
80105dde:	5d                   	pop    %ebp
80105ddf:	c3                   	ret    
  return 0;
80105de0:	b8 00 00 00 00       	mov    $0x0,%eax
80105de5:	eb f1                	jmp    80105dd8 <mappages+0x67>

80105de7 <seginit>:
{
80105de7:	f3 0f 1e fb          	endbr32 
80105deb:	55                   	push   %ebp
80105dec:	89 e5                	mov    %esp,%ebp
80105dee:	53                   	push   %ebx
80105def:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpuid()];
80105df2:	e8 af d4 ff ff       	call   801032a6 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105df7:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105dfd:	66 c7 80 f8 17 11 80 	movw   $0xffff,-0x7feee808(%eax)
80105e04:	ff ff 
80105e06:	66 c7 80 fa 17 11 80 	movw   $0x0,-0x7feee806(%eax)
80105e0d:	00 00 
80105e0f:	c6 80 fc 17 11 80 00 	movb   $0x0,-0x7feee804(%eax)
80105e16:	0f b6 88 fd 17 11 80 	movzbl -0x7feee803(%eax),%ecx
80105e1d:	83 e1 f0             	and    $0xfffffff0,%ecx
80105e20:	83 c9 1a             	or     $0x1a,%ecx
80105e23:	83 e1 9f             	and    $0xffffff9f,%ecx
80105e26:	83 c9 80             	or     $0xffffff80,%ecx
80105e29:	88 88 fd 17 11 80    	mov    %cl,-0x7feee803(%eax)
80105e2f:	0f b6 88 fe 17 11 80 	movzbl -0x7feee802(%eax),%ecx
80105e36:	83 c9 0f             	or     $0xf,%ecx
80105e39:	83 e1 cf             	and    $0xffffffcf,%ecx
80105e3c:	83 c9 c0             	or     $0xffffffc0,%ecx
80105e3f:	88 88 fe 17 11 80    	mov    %cl,-0x7feee802(%eax)
80105e45:	c6 80 ff 17 11 80 00 	movb   $0x0,-0x7feee801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105e4c:	66 c7 80 00 18 11 80 	movw   $0xffff,-0x7feee800(%eax)
80105e53:	ff ff 
80105e55:	66 c7 80 02 18 11 80 	movw   $0x0,-0x7feee7fe(%eax)
80105e5c:	00 00 
80105e5e:	c6 80 04 18 11 80 00 	movb   $0x0,-0x7feee7fc(%eax)
80105e65:	0f b6 88 05 18 11 80 	movzbl -0x7feee7fb(%eax),%ecx
80105e6c:	83 e1 f0             	and    $0xfffffff0,%ecx
80105e6f:	83 c9 12             	or     $0x12,%ecx
80105e72:	83 e1 9f             	and    $0xffffff9f,%ecx
80105e75:	83 c9 80             	or     $0xffffff80,%ecx
80105e78:	88 88 05 18 11 80    	mov    %cl,-0x7feee7fb(%eax)
80105e7e:	0f b6 88 06 18 11 80 	movzbl -0x7feee7fa(%eax),%ecx
80105e85:	83 c9 0f             	or     $0xf,%ecx
80105e88:	83 e1 cf             	and    $0xffffffcf,%ecx
80105e8b:	83 c9 c0             	or     $0xffffffc0,%ecx
80105e8e:	88 88 06 18 11 80    	mov    %cl,-0x7feee7fa(%eax)
80105e94:	c6 80 07 18 11 80 00 	movb   $0x0,-0x7feee7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105e9b:	66 c7 80 08 18 11 80 	movw   $0xffff,-0x7feee7f8(%eax)
80105ea2:	ff ff 
80105ea4:	66 c7 80 0a 18 11 80 	movw   $0x0,-0x7feee7f6(%eax)
80105eab:	00 00 
80105ead:	c6 80 0c 18 11 80 00 	movb   $0x0,-0x7feee7f4(%eax)
80105eb4:	c6 80 0d 18 11 80 fa 	movb   $0xfa,-0x7feee7f3(%eax)
80105ebb:	0f b6 88 0e 18 11 80 	movzbl -0x7feee7f2(%eax),%ecx
80105ec2:	83 c9 0f             	or     $0xf,%ecx
80105ec5:	83 e1 cf             	and    $0xffffffcf,%ecx
80105ec8:	83 c9 c0             	or     $0xffffffc0,%ecx
80105ecb:	88 88 0e 18 11 80    	mov    %cl,-0x7feee7f2(%eax)
80105ed1:	c6 80 0f 18 11 80 00 	movb   $0x0,-0x7feee7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105ed8:	66 c7 80 10 18 11 80 	movw   $0xffff,-0x7feee7f0(%eax)
80105edf:	ff ff 
80105ee1:	66 c7 80 12 18 11 80 	movw   $0x0,-0x7feee7ee(%eax)
80105ee8:	00 00 
80105eea:	c6 80 14 18 11 80 00 	movb   $0x0,-0x7feee7ec(%eax)
80105ef1:	c6 80 15 18 11 80 f2 	movb   $0xf2,-0x7feee7eb(%eax)
80105ef8:	0f b6 88 16 18 11 80 	movzbl -0x7feee7ea(%eax),%ecx
80105eff:	83 c9 0f             	or     $0xf,%ecx
80105f02:	83 e1 cf             	and    $0xffffffcf,%ecx
80105f05:	83 c9 c0             	or     $0xffffffc0,%ecx
80105f08:	88 88 16 18 11 80    	mov    %cl,-0x7feee7ea(%eax)
80105f0e:	c6 80 17 18 11 80 00 	movb   $0x0,-0x7feee7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105f15:	05 f0 17 11 80       	add    $0x801117f0,%eax
  pd[0] = size-1;
80105f1a:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105f20:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105f24:	c1 e8 10             	shr    $0x10,%eax
80105f27:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105f2b:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105f2e:	0f 01 10             	lgdtl  (%eax)
}
80105f31:	83 c4 14             	add    $0x14,%esp
80105f34:	5b                   	pop    %ebx
80105f35:	5d                   	pop    %ebp
80105f36:	c3                   	ret    

80105f37 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105f37:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105f3b:	a1 a4 44 11 80       	mov    0x801144a4,%eax
80105f40:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105f45:	0f 22 d8             	mov    %eax,%cr3
}
80105f48:	c3                   	ret    

80105f49 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105f49:	f3 0f 1e fb          	endbr32 
80105f4d:	55                   	push   %ebp
80105f4e:	89 e5                	mov    %esp,%ebp
80105f50:	57                   	push   %edi
80105f51:	56                   	push   %esi
80105f52:	53                   	push   %ebx
80105f53:	83 ec 1c             	sub    $0x1c,%esp
80105f56:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105f59:	85 f6                	test   %esi,%esi
80105f5b:	0f 84 dd 00 00 00    	je     8010603e <switchuvm+0xf5>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105f61:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80105f65:	0f 84 e0 00 00 00    	je     8010604b <switchuvm+0x102>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105f6b:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80105f6f:	0f 84 e3 00 00 00    	je     80106058 <switchuvm+0x10f>
    panic("switchuvm: no pgdir");

  pushcli();
80105f75:	e8 58 dc ff ff       	call   80103bd2 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105f7a:	e8 c7 d2 ff ff       	call   80103246 <mycpu>
80105f7f:	89 c3                	mov    %eax,%ebx
80105f81:	e8 c0 d2 ff ff       	call   80103246 <mycpu>
80105f86:	8d 78 08             	lea    0x8(%eax),%edi
80105f89:	e8 b8 d2 ff ff       	call   80103246 <mycpu>
80105f8e:	83 c0 08             	add    $0x8,%eax
80105f91:	c1 e8 10             	shr    $0x10,%eax
80105f94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f97:	e8 aa d2 ff ff       	call   80103246 <mycpu>
80105f9c:	83 c0 08             	add    $0x8,%eax
80105f9f:	c1 e8 18             	shr    $0x18,%eax
80105fa2:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80105fa9:	67 00 
80105fab:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80105fb2:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
80105fb6:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80105fbc:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80105fc3:	83 e2 f0             	and    $0xfffffff0,%edx
80105fc6:	83 ca 19             	or     $0x19,%edx
80105fc9:	83 e2 9f             	and    $0xffffff9f,%edx
80105fcc:	83 ca 80             	or     $0xffffff80,%edx
80105fcf:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80105fd5:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80105fdc:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80105fe2:	e8 5f d2 ff ff       	call   80103246 <mycpu>
80105fe7:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80105fee:	83 e2 ef             	and    $0xffffffef,%edx
80105ff1:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80105ff7:	e8 4a d2 ff ff       	call   80103246 <mycpu>
80105ffc:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106002:	8b 5e 08             	mov    0x8(%esi),%ebx
80106005:	e8 3c d2 ff ff       	call   80103246 <mycpu>
8010600a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106010:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106013:	e8 2e d2 ff ff       	call   80103246 <mycpu>
80106018:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010601e:	b8 28 00 00 00       	mov    $0x28,%eax
80106023:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106026:	8b 46 04             	mov    0x4(%esi),%eax
80106029:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010602e:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106031:	e8 dd db ff ff       	call   80103c13 <popcli>
}
80106036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106039:	5b                   	pop    %ebx
8010603a:	5e                   	pop    %esi
8010603b:	5f                   	pop    %edi
8010603c:	5d                   	pop    %ebp
8010603d:	c3                   	ret    
    panic("switchuvm: no process");
8010603e:	83 ec 0c             	sub    $0xc,%esp
80106041:	68 8e 6e 10 80       	push   $0x80106e8e
80106046:	e8 11 a3 ff ff       	call   8010035c <panic>
    panic("switchuvm: no kstack");
8010604b:	83 ec 0c             	sub    $0xc,%esp
8010604e:	68 a4 6e 10 80       	push   $0x80106ea4
80106053:	e8 04 a3 ff ff       	call   8010035c <panic>
    panic("switchuvm: no pgdir");
80106058:	83 ec 0c             	sub    $0xc,%esp
8010605b:	68 b9 6e 10 80       	push   $0x80106eb9
80106060:	e8 f7 a2 ff ff       	call   8010035c <panic>

80106065 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106065:	f3 0f 1e fb          	endbr32 
80106069:	55                   	push   %ebp
8010606a:	89 e5                	mov    %esp,%ebp
8010606c:	56                   	push   %esi
8010606d:	53                   	push   %ebx
8010606e:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106071:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106077:	77 4c                	ja     801060c5 <inituvm+0x60>
    panic("inituvm: more than a page");
  mem = kalloc();
80106079:	e8 d4 c0 ff ff       	call   80102152 <kalloc>
8010607e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106080:	83 ec 04             	sub    $0x4,%esp
80106083:	68 00 10 00 00       	push   $0x1000
80106088:	6a 00                	push   $0x0
8010608a:	50                   	push   %eax
8010608b:	e8 df dc ff ff       	call   80103d6f <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106090:	83 c4 08             	add    $0x8,%esp
80106093:	6a 06                	push   $0x6
80106095:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010609b:	50                   	push   %eax
8010609c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801060a1:	ba 00 00 00 00       	mov    $0x0,%edx
801060a6:	8b 45 08             	mov    0x8(%ebp),%eax
801060a9:	e8 c3 fc ff ff       	call   80105d71 <mappages>
  memmove(mem, init, sz);
801060ae:	83 c4 0c             	add    $0xc,%esp
801060b1:	56                   	push   %esi
801060b2:	ff 75 0c             	pushl  0xc(%ebp)
801060b5:	53                   	push   %ebx
801060b6:	e8 34 dd ff ff       	call   80103def <memmove>
}
801060bb:	83 c4 10             	add    $0x10,%esp
801060be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060c1:	5b                   	pop    %ebx
801060c2:	5e                   	pop    %esi
801060c3:	5d                   	pop    %ebp
801060c4:	c3                   	ret    
    panic("inituvm: more than a page");
801060c5:	83 ec 0c             	sub    $0xc,%esp
801060c8:	68 cd 6e 10 80       	push   $0x80106ecd
801060cd:	e8 8a a2 ff ff       	call   8010035c <panic>

801060d2 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801060d2:	f3 0f 1e fb          	endbr32 
801060d6:	55                   	push   %ebp
801060d7:	89 e5                	mov    %esp,%ebp
801060d9:	57                   	push   %edi
801060da:	56                   	push   %esi
801060db:	53                   	push   %ebx
801060dc:	83 ec 0c             	sub    $0xc,%esp
801060df:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801060e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801060e5:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801060eb:	74 3c                	je     80106129 <loaduvm+0x57>
    panic("loaduvm: addr must be page aligned");
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	68 88 6f 10 80       	push   $0x80106f88
801060f5:	e8 62 a2 ff ff       	call   8010035c <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801060fa:	83 ec 0c             	sub    $0xc,%esp
801060fd:	68 e7 6e 10 80       	push   $0x80106ee7
80106102:	e8 55 a2 ff ff       	call   8010035c <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106107:	05 00 00 00 80       	add    $0x80000000,%eax
8010610c:	56                   	push   %esi
8010610d:	89 da                	mov    %ebx,%edx
8010610f:	03 55 14             	add    0x14(%ebp),%edx
80106112:	52                   	push   %edx
80106113:	50                   	push   %eax
80106114:	ff 75 10             	pushl  0x10(%ebp)
80106117:	e8 b4 b6 ff ff       	call   801017d0 <readi>
8010611c:	83 c4 10             	add    $0x10,%esp
8010611f:	39 f0                	cmp    %esi,%eax
80106121:	75 47                	jne    8010616a <loaduvm+0x98>
  for(i = 0; i < sz; i += PGSIZE){
80106123:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106129:	39 fb                	cmp    %edi,%ebx
8010612b:	73 30                	jae    8010615d <loaduvm+0x8b>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010612d:	89 da                	mov    %ebx,%edx
8010612f:	03 55 0c             	add    0xc(%ebp),%edx
80106132:	b9 00 00 00 00       	mov    $0x0,%ecx
80106137:	8b 45 08             	mov    0x8(%ebp),%eax
8010613a:	e8 c1 fb ff ff       	call   80105d00 <walkpgdir>
8010613f:	85 c0                	test   %eax,%eax
80106141:	74 b7                	je     801060fa <loaduvm+0x28>
    pa = PTE_ADDR(*pte);
80106143:	8b 00                	mov    (%eax),%eax
80106145:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010614a:	89 fe                	mov    %edi,%esi
8010614c:	29 de                	sub    %ebx,%esi
8010614e:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106154:	76 b1                	jbe    80106107 <loaduvm+0x35>
      n = PGSIZE;
80106156:	be 00 10 00 00       	mov    $0x1000,%esi
8010615b:	eb aa                	jmp    80106107 <loaduvm+0x35>
      return -1;
  }
  return 0;
8010615d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106162:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106165:	5b                   	pop    %ebx
80106166:	5e                   	pop    %esi
80106167:	5f                   	pop    %edi
80106168:	5d                   	pop    %ebp
80106169:	c3                   	ret    
      return -1;
8010616a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616f:	eb f1                	jmp    80106162 <loaduvm+0x90>

80106171 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106171:	f3 0f 1e fb          	endbr32 
80106175:	55                   	push   %ebp
80106176:	89 e5                	mov    %esp,%ebp
80106178:	57                   	push   %edi
80106179:	56                   	push   %esi
8010617a:	53                   	push   %ebx
8010617b:	83 ec 0c             	sub    $0xc,%esp
8010617e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106181:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106184:	73 11                	jae    80106197 <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
80106186:	8b 45 10             	mov    0x10(%ebp),%eax
80106189:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010618f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106195:	eb 19                	jmp    801061b0 <deallocuvm+0x3f>
    return oldsz;
80106197:	89 f8                	mov    %edi,%eax
80106199:	eb 64                	jmp    801061ff <deallocuvm+0x8e>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010619b:	c1 eb 16             	shr    $0x16,%ebx
8010619e:	83 c3 01             	add    $0x1,%ebx
801061a1:	c1 e3 16             	shl    $0x16,%ebx
801061a4:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801061aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801061b0:	39 fb                	cmp    %edi,%ebx
801061b2:	73 48                	jae    801061fc <deallocuvm+0x8b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801061b4:	b9 00 00 00 00       	mov    $0x0,%ecx
801061b9:	89 da                	mov    %ebx,%edx
801061bb:	8b 45 08             	mov    0x8(%ebp),%eax
801061be:	e8 3d fb ff ff       	call   80105d00 <walkpgdir>
801061c3:	89 c6                	mov    %eax,%esi
    if(!pte)
801061c5:	85 c0                	test   %eax,%eax
801061c7:	74 d2                	je     8010619b <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
801061c9:	8b 00                	mov    (%eax),%eax
801061cb:	a8 01                	test   $0x1,%al
801061cd:	74 db                	je     801061aa <deallocuvm+0x39>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801061cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801061d4:	74 19                	je     801061ef <deallocuvm+0x7e>
        panic("kfree");
      char *v = P2V(pa);
801061d6:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801061db:	83 ec 0c             	sub    $0xc,%esp
801061de:	50                   	push   %eax
801061df:	e8 47 be ff ff       	call   8010202b <kfree>
      *pte = 0;
801061e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	eb bb                	jmp    801061aa <deallocuvm+0x39>
        panic("kfree");
801061ef:	83 ec 0c             	sub    $0xc,%esp
801061f2:	68 46 68 10 80       	push   $0x80106846
801061f7:	e8 60 a1 ff ff       	call   8010035c <panic>
    }
  }
  return newsz;
801061fc:	8b 45 10             	mov    0x10(%ebp),%eax
}
801061ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106202:	5b                   	pop    %ebx
80106203:	5e                   	pop    %esi
80106204:	5f                   	pop    %edi
80106205:	5d                   	pop    %ebp
80106206:	c3                   	ret    

80106207 <allocuvm>:
{
80106207:	f3 0f 1e fb          	endbr32 
8010620b:	55                   	push   %ebp
8010620c:	89 e5                	mov    %esp,%ebp
8010620e:	57                   	push   %edi
8010620f:	56                   	push   %esi
80106210:	53                   	push   %ebx
80106211:	83 ec 1c             	sub    $0x1c,%esp
80106214:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106217:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010621a:	85 ff                	test   %edi,%edi
8010621c:	0f 88 c0 00 00 00    	js     801062e2 <allocuvm+0xdb>
  if(newsz < oldsz)
80106222:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106225:	72 11                	jb     80106238 <allocuvm+0x31>
  a = PGROUNDUP(oldsz);
80106227:	8b 45 0c             	mov    0xc(%ebp),%eax
8010622a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106230:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106236:	eb 39                	jmp    80106271 <allocuvm+0x6a>
    return oldsz;
80106238:	8b 45 0c             	mov    0xc(%ebp),%eax
8010623b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010623e:	e9 a6 00 00 00       	jmp    801062e9 <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
80106243:	83 ec 0c             	sub    $0xc,%esp
80106246:	68 05 6f 10 80       	push   $0x80106f05
8010624b:	e8 d9 a3 ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106250:	83 c4 0c             	add    $0xc,%esp
80106253:	ff 75 0c             	pushl  0xc(%ebp)
80106256:	57                   	push   %edi
80106257:	ff 75 08             	pushl  0x8(%ebp)
8010625a:	e8 12 ff ff ff       	call   80106171 <deallocuvm>
      return 0;
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106269:	eb 7e                	jmp    801062e9 <allocuvm+0xe2>
  for(; a < newsz; a += PGSIZE){
8010626b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106271:	39 fe                	cmp    %edi,%esi
80106273:	73 74                	jae    801062e9 <allocuvm+0xe2>
    mem = kalloc();
80106275:	e8 d8 be ff ff       	call   80102152 <kalloc>
8010627a:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010627c:	85 c0                	test   %eax,%eax
8010627e:	74 c3                	je     80106243 <allocuvm+0x3c>
    memset(mem, 0, PGSIZE);
80106280:	83 ec 04             	sub    $0x4,%esp
80106283:	68 00 10 00 00       	push   $0x1000
80106288:	6a 00                	push   $0x0
8010628a:	50                   	push   %eax
8010628b:	e8 df da ff ff       	call   80103d6f <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106290:	83 c4 08             	add    $0x8,%esp
80106293:	6a 06                	push   $0x6
80106295:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010629b:	50                   	push   %eax
8010629c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801062a1:	89 f2                	mov    %esi,%edx
801062a3:	8b 45 08             	mov    0x8(%ebp),%eax
801062a6:	e8 c6 fa ff ff       	call   80105d71 <mappages>
801062ab:	83 c4 10             	add    $0x10,%esp
801062ae:	85 c0                	test   %eax,%eax
801062b0:	79 b9                	jns    8010626b <allocuvm+0x64>
      cprintf("allocuvm out of memory (2)\n");
801062b2:	83 ec 0c             	sub    $0xc,%esp
801062b5:	68 1d 6f 10 80       	push   $0x80106f1d
801062ba:	e8 6a a3 ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801062bf:	83 c4 0c             	add    $0xc,%esp
801062c2:	ff 75 0c             	pushl  0xc(%ebp)
801062c5:	57                   	push   %edi
801062c6:	ff 75 08             	pushl  0x8(%ebp)
801062c9:	e8 a3 fe ff ff       	call   80106171 <deallocuvm>
      kfree(mem);
801062ce:	89 1c 24             	mov    %ebx,(%esp)
801062d1:	e8 55 bd ff ff       	call   8010202b <kfree>
      return 0;
801062d6:	83 c4 10             	add    $0x10,%esp
801062d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801062e0:	eb 07                	jmp    801062e9 <allocuvm+0xe2>
    return 0;
801062e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801062e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062ef:	5b                   	pop    %ebx
801062f0:	5e                   	pop    %esi
801062f1:	5f                   	pop    %edi
801062f2:	5d                   	pop    %ebp
801062f3:	c3                   	ret    

801062f4 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801062f4:	f3 0f 1e fb          	endbr32 
801062f8:	55                   	push   %ebp
801062f9:	89 e5                	mov    %esp,%ebp
801062fb:	56                   	push   %esi
801062fc:	53                   	push   %ebx
801062fd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106300:	85 f6                	test   %esi,%esi
80106302:	74 1a                	je     8010631e <freevm+0x2a>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80106304:	83 ec 04             	sub    $0x4,%esp
80106307:	6a 00                	push   $0x0
80106309:	68 00 00 00 80       	push   $0x80000000
8010630e:	56                   	push   %esi
8010630f:	e8 5d fe ff ff       	call   80106171 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80106314:	83 c4 10             	add    $0x10,%esp
80106317:	bb 00 00 00 00       	mov    $0x0,%ebx
8010631c:	eb 26                	jmp    80106344 <freevm+0x50>
    panic("freevm: no pgdir");
8010631e:	83 ec 0c             	sub    $0xc,%esp
80106321:	68 39 6f 10 80       	push   $0x80106f39
80106326:	e8 31 a0 ff ff       	call   8010035c <panic>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010632b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106330:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106335:	83 ec 0c             	sub    $0xc,%esp
80106338:	50                   	push   %eax
80106339:	e8 ed bc ff ff       	call   8010202b <kfree>
8010633e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106341:	83 c3 01             	add    $0x1,%ebx
80106344:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
8010634a:	77 09                	ja     80106355 <freevm+0x61>
    if(pgdir[i] & PTE_P){
8010634c:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
8010634f:	a8 01                	test   $0x1,%al
80106351:	74 ee                	je     80106341 <freevm+0x4d>
80106353:	eb d6                	jmp    8010632b <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106355:	83 ec 0c             	sub    $0xc,%esp
80106358:	56                   	push   %esi
80106359:	e8 cd bc ff ff       	call   8010202b <kfree>
}
8010635e:	83 c4 10             	add    $0x10,%esp
80106361:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106364:	5b                   	pop    %ebx
80106365:	5e                   	pop    %esi
80106366:	5d                   	pop    %ebp
80106367:	c3                   	ret    

80106368 <setupkvm>:
{
80106368:	f3 0f 1e fb          	endbr32 
8010636c:	55                   	push   %ebp
8010636d:	89 e5                	mov    %esp,%ebp
8010636f:	56                   	push   %esi
80106370:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106371:	e8 dc bd ff ff       	call   80102152 <kalloc>
80106376:	89 c6                	mov    %eax,%esi
80106378:	85 c0                	test   %eax,%eax
8010637a:	74 55                	je     801063d1 <setupkvm+0x69>
  memset(pgdir, 0, PGSIZE);
8010637c:	83 ec 04             	sub    $0x4,%esp
8010637f:	68 00 10 00 00       	push   $0x1000
80106384:	6a 00                	push   $0x0
80106386:	50                   	push   %eax
80106387:	e8 e3 d9 ff ff       	call   80103d6f <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010638c:	83 c4 10             	add    $0x10,%esp
8010638f:	bb 20 94 10 80       	mov    $0x80109420,%ebx
80106394:	81 fb 60 94 10 80    	cmp    $0x80109460,%ebx
8010639a:	73 35                	jae    801063d1 <setupkvm+0x69>
                (uint)k->phys_start, k->perm) < 0) {
8010639c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010639f:	8b 4b 08             	mov    0x8(%ebx),%ecx
801063a2:	29 c1                	sub    %eax,%ecx
801063a4:	83 ec 08             	sub    $0x8,%esp
801063a7:	ff 73 0c             	pushl  0xc(%ebx)
801063aa:	50                   	push   %eax
801063ab:	8b 13                	mov    (%ebx),%edx
801063ad:	89 f0                	mov    %esi,%eax
801063af:	e8 bd f9 ff ff       	call   80105d71 <mappages>
801063b4:	83 c4 10             	add    $0x10,%esp
801063b7:	85 c0                	test   %eax,%eax
801063b9:	78 05                	js     801063c0 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801063bb:	83 c3 10             	add    $0x10,%ebx
801063be:	eb d4                	jmp    80106394 <setupkvm+0x2c>
      freevm(pgdir);
801063c0:	83 ec 0c             	sub    $0xc,%esp
801063c3:	56                   	push   %esi
801063c4:	e8 2b ff ff ff       	call   801062f4 <freevm>
      return 0;
801063c9:	83 c4 10             	add    $0x10,%esp
801063cc:	be 00 00 00 00       	mov    $0x0,%esi
}
801063d1:	89 f0                	mov    %esi,%eax
801063d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063d6:	5b                   	pop    %ebx
801063d7:	5e                   	pop    %esi
801063d8:	5d                   	pop    %ebp
801063d9:	c3                   	ret    

801063da <kvmalloc>:
{
801063da:	f3 0f 1e fb          	endbr32 
801063de:	55                   	push   %ebp
801063df:	89 e5                	mov    %esp,%ebp
801063e1:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801063e4:	e8 7f ff ff ff       	call   80106368 <setupkvm>
801063e9:	a3 a4 44 11 80       	mov    %eax,0x801144a4
  switchkvm();
801063ee:	e8 44 fb ff ff       	call   80105f37 <switchkvm>
}
801063f3:	c9                   	leave  
801063f4:	c3                   	ret    

801063f5 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801063f5:	f3 0f 1e fb          	endbr32 
801063f9:	55                   	push   %ebp
801063fa:	89 e5                	mov    %esp,%ebp
801063fc:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801063ff:	b9 00 00 00 00       	mov    $0x0,%ecx
80106404:	8b 55 0c             	mov    0xc(%ebp),%edx
80106407:	8b 45 08             	mov    0x8(%ebp),%eax
8010640a:	e8 f1 f8 ff ff       	call   80105d00 <walkpgdir>
  if(pte == 0)
8010640f:	85 c0                	test   %eax,%eax
80106411:	74 05                	je     80106418 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106413:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106416:	c9                   	leave  
80106417:	c3                   	ret    
    panic("clearpteu");
80106418:	83 ec 0c             	sub    $0xc,%esp
8010641b:	68 4a 6f 10 80       	push   $0x80106f4a
80106420:	e8 37 9f ff ff       	call   8010035c <panic>

80106425 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106425:	f3 0f 1e fb          	endbr32 
80106429:	55                   	push   %ebp
8010642a:	89 e5                	mov    %esp,%ebp
8010642c:	57                   	push   %edi
8010642d:	56                   	push   %esi
8010642e:	53                   	push   %ebx
8010642f:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106432:	e8 31 ff ff ff       	call   80106368 <setupkvm>
80106437:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010643a:	85 c0                	test   %eax,%eax
8010643c:	0f 84 c4 00 00 00    	je     80106506 <copyuvm+0xe1>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106442:	bf 00 00 00 00       	mov    $0x0,%edi
80106447:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010644a:	0f 83 b6 00 00 00    	jae    80106506 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106450:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106453:	b9 00 00 00 00       	mov    $0x0,%ecx
80106458:	89 fa                	mov    %edi,%edx
8010645a:	8b 45 08             	mov    0x8(%ebp),%eax
8010645d:	e8 9e f8 ff ff       	call   80105d00 <walkpgdir>
80106462:	85 c0                	test   %eax,%eax
80106464:	74 65                	je     801064cb <copyuvm+0xa6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106466:	8b 00                	mov    (%eax),%eax
80106468:	a8 01                	test   $0x1,%al
8010646a:	74 6c                	je     801064d8 <copyuvm+0xb3>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010646c:	89 c6                	mov    %eax,%esi
8010646e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
80106474:	25 ff 0f 00 00       	and    $0xfff,%eax
80106479:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
8010647c:	e8 d1 bc ff ff       	call   80102152 <kalloc>
80106481:	89 c3                	mov    %eax,%ebx
80106483:	85 c0                	test   %eax,%eax
80106485:	74 6a                	je     801064f1 <copyuvm+0xcc>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106487:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010648d:	83 ec 04             	sub    $0x4,%esp
80106490:	68 00 10 00 00       	push   $0x1000
80106495:	56                   	push   %esi
80106496:	50                   	push   %eax
80106497:	e8 53 d9 ff ff       	call   80103def <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010649c:	83 c4 08             	add    $0x8,%esp
8010649f:	ff 75 e0             	pushl  -0x20(%ebp)
801064a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064a8:	50                   	push   %eax
801064a9:	b9 00 10 00 00       	mov    $0x1000,%ecx
801064ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801064b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064b4:	e8 b8 f8 ff ff       	call   80105d71 <mappages>
801064b9:	83 c4 10             	add    $0x10,%esp
801064bc:	85 c0                	test   %eax,%eax
801064be:	78 25                	js     801064e5 <copyuvm+0xc0>
  for(i = 0; i < sz; i += PGSIZE){
801064c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801064c6:	e9 7c ff ff ff       	jmp    80106447 <copyuvm+0x22>
      panic("copyuvm: pte should exist");
801064cb:	83 ec 0c             	sub    $0xc,%esp
801064ce:	68 54 6f 10 80       	push   $0x80106f54
801064d3:	e8 84 9e ff ff       	call   8010035c <panic>
      panic("copyuvm: page not present");
801064d8:	83 ec 0c             	sub    $0xc,%esp
801064db:	68 6e 6f 10 80       	push   $0x80106f6e
801064e0:	e8 77 9e ff ff       	call   8010035c <panic>
      kfree(mem);
801064e5:	83 ec 0c             	sub    $0xc,%esp
801064e8:	53                   	push   %ebx
801064e9:	e8 3d bb ff ff       	call   8010202b <kfree>
      goto bad;
801064ee:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
801064f1:	83 ec 0c             	sub    $0xc,%esp
801064f4:	ff 75 dc             	pushl  -0x24(%ebp)
801064f7:	e8 f8 fd ff ff       	call   801062f4 <freevm>
  return 0;
801064fc:	83 c4 10             	add    $0x10,%esp
801064ff:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106506:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106509:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010650c:	5b                   	pop    %ebx
8010650d:	5e                   	pop    %esi
8010650e:	5f                   	pop    %edi
8010650f:	5d                   	pop    %ebp
80106510:	c3                   	ret    

80106511 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106511:	f3 0f 1e fb          	endbr32 
80106515:	55                   	push   %ebp
80106516:	89 e5                	mov    %esp,%ebp
80106518:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010651b:	b9 00 00 00 00       	mov    $0x0,%ecx
80106520:	8b 55 0c             	mov    0xc(%ebp),%edx
80106523:	8b 45 08             	mov    0x8(%ebp),%eax
80106526:	e8 d5 f7 ff ff       	call   80105d00 <walkpgdir>
  if((*pte & PTE_P) == 0)
8010652b:	8b 00                	mov    (%eax),%eax
8010652d:	a8 01                	test   $0x1,%al
8010652f:	74 10                	je     80106541 <uva2ka+0x30>
    return 0;
  if((*pte & PTE_U) == 0)
80106531:	a8 04                	test   $0x4,%al
80106533:	74 13                	je     80106548 <uva2ka+0x37>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106535:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010653a:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010653f:	c9                   	leave  
80106540:	c3                   	ret    
    return 0;
80106541:	b8 00 00 00 00       	mov    $0x0,%eax
80106546:	eb f7                	jmp    8010653f <uva2ka+0x2e>
    return 0;
80106548:	b8 00 00 00 00       	mov    $0x0,%eax
8010654d:	eb f0                	jmp    8010653f <uva2ka+0x2e>

8010654f <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010654f:	f3 0f 1e fb          	endbr32 
80106553:	55                   	push   %ebp
80106554:	89 e5                	mov    %esp,%ebp
80106556:	57                   	push   %edi
80106557:	56                   	push   %esi
80106558:	53                   	push   %ebx
80106559:	83 ec 0c             	sub    $0xc,%esp
8010655c:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010655f:	eb 25                	jmp    80106586 <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106561:	8b 55 0c             	mov    0xc(%ebp),%edx
80106564:	29 f2                	sub    %esi,%edx
80106566:	01 d0                	add    %edx,%eax
80106568:	83 ec 04             	sub    $0x4,%esp
8010656b:	53                   	push   %ebx
8010656c:	ff 75 10             	pushl  0x10(%ebp)
8010656f:	50                   	push   %eax
80106570:	e8 7a d8 ff ff       	call   80103def <memmove>
    len -= n;
80106575:	29 df                	sub    %ebx,%edi
    buf += n;
80106577:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
8010657a:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106580:	89 45 0c             	mov    %eax,0xc(%ebp)
80106583:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106586:	85 ff                	test   %edi,%edi
80106588:	74 2f                	je     801065b9 <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
8010658a:	8b 75 0c             	mov    0xc(%ebp),%esi
8010658d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106593:	83 ec 08             	sub    $0x8,%esp
80106596:	56                   	push   %esi
80106597:	ff 75 08             	pushl  0x8(%ebp)
8010659a:	e8 72 ff ff ff       	call   80106511 <uva2ka>
    if(pa0 == 0)
8010659f:	83 c4 10             	add    $0x10,%esp
801065a2:	85 c0                	test   %eax,%eax
801065a4:	74 20                	je     801065c6 <copyout+0x77>
    n = PGSIZE - (va - va0);
801065a6:	89 f3                	mov    %esi,%ebx
801065a8:	2b 5d 0c             	sub    0xc(%ebp),%ebx
801065ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801065b1:	39 df                	cmp    %ebx,%edi
801065b3:	73 ac                	jae    80106561 <copyout+0x12>
      n = len;
801065b5:	89 fb                	mov    %edi,%ebx
801065b7:	eb a8                	jmp    80106561 <copyout+0x12>
  }
  return 0;
801065b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065c1:	5b                   	pop    %ebx
801065c2:	5e                   	pop    %esi
801065c3:	5f                   	pop    %edi
801065c4:	5d                   	pop    %ebp
801065c5:	c3                   	ret    
      return -1;
801065c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065cb:	eb f1                	jmp    801065be <copyout+0x6f>
