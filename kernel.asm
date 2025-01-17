
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 73 10 80       	push   $0x80107340
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 71 43 00 00       	call   801043d0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 73 10 80       	push   $0x80107347
80100097:	50                   	push   %eax
80100098:	e8 23 42 00 00       	call   801042c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 f3 43 00 00       	call   801044e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 a9 44 00 00       	call   80104610 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 41 00 00       	call   80104300 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 4e 73 10 80       	push   $0x8010734e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 d9 41 00 00       	call   801043a0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 73 10 80       	push   $0x8010735f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 98 41 00 00       	call   801043a0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 41 00 00       	call   80104360 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 bc 42 00 00       	call   801044e0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 9b 43 00 00       	jmp    80104610 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 73 10 80       	push   $0x80107366
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 2a 42 00 00       	call   801044e0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 56 3c 00 00       	call   80103f40 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 71 36 00 00       	call   80103970 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 fd 42 00 00       	call   80104610 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 a6 42 00 00       	call   80104610 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 73 10 80       	push   $0x8010736d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 ff 7c 10 80 	movl   $0x80107cff,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 0f 40 00 00       	call   801043f0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 73 10 80       	push   $0x80107381
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 b1 59 00 00       	call   80105de0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 c6 58 00 00       	call   80105de0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 58 00 00       	call   80105de0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 58 00 00       	call   80105de0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 9a 41 00 00       	call   80104700 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 e5 40 00 00       	call   80104660 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 73 10 80       	push   $0x80107385
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 b0 73 10 80 	movzbl -0x7fef8c50(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 7c 3e 00 00       	call   801044e0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 74 3f 00 00       	call   80104610 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 98 73 10 80       	mov    $0x80107398,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 1e 3d 00 00       	call   801044e0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 e3 3d 00 00       	call   80104610 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 73 10 80       	push   $0x8010739f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 64 3c 00 00       	call   801044e0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 3c 3c 00 00       	call   80104610 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 ec 37 00 00       	jmp    801041f0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 db 36 00 00       	call   80104100 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 a8 73 10 80       	push   $0x801073a8
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 87 39 00 00       	call   801043d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 db 2e 00 00       	call   80103970 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 90 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 b8 22 00 00       	call   80102da0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 4f 64 00 00       	call   80106f60 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 f8 61 00 00       	call   80106d70 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 f2 60 00 00       	call   80106ca0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 f0 62 00 00       	call   80106ee0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c06:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c0c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  iunlockput(ip);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	53                   	push   %ebx
80100c16:	e8 e5 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c1b:	e8 80 21 00 00       	call   80102da0 <end_op>
  if((allocuvm(pgdir, sp - PGSIZE, sp)) == 0)
80100c20:	83 c4 0c             	add    $0xc,%esp
80100c23:	68 ff ff ff 7f       	push   $0x7fffffff
80100c28:	68 ff ef ff 7f       	push   $0x7fffefff
80100c2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c33:	e8 38 61 00 00       	call   80106d70 <allocuvm>
80100c38:	83 c4 10             	add    $0x10,%esp
80100c3b:	85 c0                	test   %eax,%eax
80100c3d:	0f 84 90 00 00 00    	je     80100cd3 <exec+0x253>
  curproc->stack_pages = 1;
80100c43:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  sp = KERNBASE-1;
80100c49:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100c4e:	31 ff                	xor    %edi,%edi
80100c50:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  curproc->stack_pages = 1;
80100c56:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  for(argc = 0; argv[argc]; argc++) {
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c60:	8b 00                	mov    (%eax),%eax
80100c62:	85 c0                	test   %eax,%eax
80100c64:	0f 84 8a 00 00 00    	je     80100cf4 <exec+0x274>
80100c6a:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c70:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c76:	eb 27                	jmp    80100c9f <exec+0x21f>
80100c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c7f:	90                   	nop
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 54                	je     80100cee <exec+0x26e>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 34                	je     80100cd3 <exec+0x253>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 b8 3b 00 00       	call   80104860 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 a5 3b 00 00       	call   80104860 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 54 65 00 00       	call   80107220 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
    freevm(pgdir);
80100cd3:	83 ec 0c             	sub    $0xc,%esp
80100cd6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cdc:	e8 ff 61 00 00       	call   80106ee0 <freevm>
80100ce1:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ce9:	e9 02 fe ff ff       	jmp    80100af0 <exec+0x70>
80100cee:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf4:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cfb:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cfd:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d04:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d08:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0a:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d0d:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d13:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d15:	50                   	push   %eax
80100d16:	52                   	push   %edx
80100d17:	53                   	push   %ebx
80100d18:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d1e:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d25:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d28:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d2e:	e8 ed 64 00 00       	call   80107220 <copyout>
80100d33:	83 c4 10             	add    $0x10,%esp
80100d36:	85 c0                	test   %eax,%eax
80100d38:	78 99                	js     80100cd3 <exec+0x253>
  for(last=s=path; *s; s++)
80100d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80100d3d:	8b 55 08             	mov    0x8(%ebp),%edx
80100d40:	0f b6 00             	movzbl (%eax),%eax
80100d43:	84 c0                	test   %al,%al
80100d45:	74 18                	je     80100d5f <exec+0x2df>
80100d47:	89 d1                	mov    %edx,%ecx
80100d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 aa 3a 00 00       	call   80104820 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 6e 5d 00 00       	call   80106b10 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 36 61 00 00       	call   80106ee0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 c1 73 10 80       	push   $0x801073c1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 f6                	xor    %esi,%esi
80100dd5:	e9 38 fe ff ff       	jmp    80100c12 <exec+0x192>
80100dda:	66 90                	xchg   %ax,%ax
80100ddc:	66 90                	xchg   %ax,%ax
80100dde:	66 90                	xchg   %ax,%ax

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 cd 73 10 80       	push   $0x801073cd
80100def:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df4:	e8 d7 35 00 00       	call   801043d0 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e15:	e8 c6 36 00 00       	call   801044e0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 ca 37 00 00       	call   80104610 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 b1 37 00 00       	call   80104610 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e83:	e8 58 36 00 00       	call   801044e0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea0:	e8 6b 37 00 00       	call   80104610 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 d4 73 10 80       	push   $0x801073d4
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed5:	e8 06 36 00 00       	call   801044e0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 fb 36 00 00       	call   80104610 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 cd 36 00 00       	jmp    80104610 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 92 25 00 00       	call   80103510 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 dc 73 10 80       	push   $0x801073dc
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 46 26 00 00       	jmp    801036b0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 e6 73 10 80       	push   $0x801073e6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 aa 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 11 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 4a 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 ef 73 10 80       	push   $0x801073ef
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 1a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 f5 73 10 80       	push   $0x801073f5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011b9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
80101202:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101207:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	89 fa                	mov    %edi,%edx
8010121b:	85 df                	test   %ebx,%edi
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 b4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 ff 73 10 80       	push   $0x801073ff
80101259:	e8 32 f1 ff ff       	call   80100390 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 9e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 76 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101285:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101288:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010128a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 c6 33 00 00       	call   80104660 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 6e 1c 00 00       	call   80102f10 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 46 ef ff ff       	call   801001f0 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012bf:	90                   	nop

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	89 c7                	mov    %eax,%edi
801012c6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c7:	31 f6                	xor    %esi,%esi
{
801012c9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 09 11 80       	push   $0x801109e0
801012da:	e8 01 32 00 00       	call   801044e0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801012e2:	83 c4 10             	add    $0x10,%esp
801012e5:	eb 1b                	jmp    80101302 <iget+0x42>
801012e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ee:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012f0:	39 3b                	cmp    %edi,(%ebx)
801012f2:	74 6c                	je     80101360 <iget+0xa0>
801012f4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101300:	73 26                	jae    80101328 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101302:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101305:	85 c9                	test   %ecx,%ecx
80101307:	7f e7                	jg     801012f0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e7                	jne    801012f4 <iget+0x34>
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101315:	85 c9                	test   %ecx,%ecx
80101317:	75 6e                	jne    80101387 <iget+0xc7>
80101319:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101321:	72 df                	jb     80101302 <iget+0x42>
80101323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101327:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101328:	85 f6                	test   %esi,%esi
8010132a:	74 73                	je     8010139f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010132c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010132f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101331:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101334:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010133b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101342:	68 e0 09 11 80       	push   $0x801109e0
80101347:	e8 c4 32 00 00       	call   80104610 <release>

  return ip;
8010134c:	83 c4 10             	add    $0x10,%esp
}
8010134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101352:	89 f0                	mov    %esi,%eax
80101354:	5b                   	pop    %ebx
80101355:	5e                   	pop    %esi
80101356:	5f                   	pop    %edi
80101357:	5d                   	pop    %ebp
80101358:	c3                   	ret    
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101360:	39 53 04             	cmp    %edx,0x4(%ebx)
80101363:	75 8f                	jne    801012f4 <iget+0x34>
      release(&icache.lock);
80101365:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101368:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010136b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010136d:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101372:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101375:	e8 96 32 00 00       	call   80104610 <release>
      return ip;
8010137a:	83 c4 10             	add    $0x10,%esp
}
8010137d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101380:	89 f0                	mov    %esi,%eax
80101382:	5b                   	pop    %ebx
80101383:	5e                   	pop    %esi
80101384:	5f                   	pop    %edi
80101385:	5d                   	pop    %ebp
80101386:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101387:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010138d:	73 10                	jae    8010139f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101392:	85 c9                	test   %ecx,%ecx
80101394:	0f 8f 56 ff ff ff    	jg     801012f0 <iget+0x30>
8010139a:	e9 6e ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 15 74 10 80       	push   $0x80107415
801013a7:	e8 e4 ef ff ff       	call   80100390 <panic>
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	89 c6                	mov    %eax,%esi
801013b7:	53                   	push   %ebx
801013b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013bb:	83 fa 0b             	cmp    $0xb,%edx
801013be:	0f 86 84 00 00 00    	jbe    80101448 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013c7:	83 fb 7f             	cmp    $0x7f,%ebx
801013ca:	0f 87 98 00 00 00    	ja     80101468 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013d6:	8b 16                	mov    (%esi),%edx
801013d8:	85 c0                	test   %eax,%eax
801013da:	74 54                	je     80101430 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013dc:	83 ec 08             	sub    $0x8,%esp
801013df:	50                   	push   %eax
801013e0:	52                   	push   %edx
801013e1:	e8 ea ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013e6:	83 c4 10             	add    $0x10,%esp
801013e9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013ed:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013ef:	8b 1a                	mov    (%edx),%ebx
801013f1:	85 db                	test   %ebx,%ebx
801013f3:	74 1b                	je     80101410 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	57                   	push   %edi
801013f9:	e8 f2 ed ff ff       	call   801001f0 <brelse>
    return addr;
801013fe:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101404:	89 d8                	mov    %ebx,%eax
80101406:	5b                   	pop    %ebx
80101407:	5e                   	pop    %esi
80101408:	5f                   	pop    %edi
80101409:	5d                   	pop    %ebp
8010140a:	c3                   	ret    
8010140b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010140f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101410:	8b 06                	mov    (%esi),%eax
80101412:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101415:	e8 96 fd ff ff       	call   801011b0 <balloc>
8010141a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010141d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101420:	89 c3                	mov    %eax,%ebx
80101422:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101424:	57                   	push   %edi
80101425:	e8 e6 1a 00 00       	call   80102f10 <log_write>
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	eb c6                	jmp    801013f5 <bmap+0x45>
8010142f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101430:	89 d0                	mov    %edx,%eax
80101432:	e8 79 fd ff ff       	call   801011b0 <balloc>
80101437:	8b 16                	mov    (%esi),%edx
80101439:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010143f:	eb 9b                	jmp    801013dc <bmap+0x2c>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101448:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010144b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010144e:	85 db                	test   %ebx,%ebx
80101450:	75 af                	jne    80101401 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101452:	8b 00                	mov    (%eax),%eax
80101454:	e8 57 fd ff ff       	call   801011b0 <balloc>
80101459:	89 47 5c             	mov    %eax,0x5c(%edi)
8010145c:	89 c3                	mov    %eax,%ebx
}
8010145e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101461:	89 d8                	mov    %ebx,%eax
80101463:	5b                   	pop    %ebx
80101464:	5e                   	pop    %esi
80101465:	5f                   	pop    %edi
80101466:	5d                   	pop    %ebp
80101467:	c3                   	ret    
  panic("bmap: out of range");
80101468:	83 ec 0c             	sub    $0xc,%esp
8010146b:	68 25 74 10 80       	push   $0x80107425
80101470:	e8 1b ef ff ff       	call   80100390 <panic>
80101475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101480 <readsb>:
{
80101480:	f3 0f 1e fb          	endbr32 
80101484:	55                   	push   %ebp
80101485:	89 e5                	mov    %esp,%ebp
80101487:	56                   	push   %esi
80101488:	53                   	push   %ebx
80101489:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010148c:	83 ec 08             	sub    $0x8,%esp
8010148f:	6a 01                	push   $0x1
80101491:	ff 75 08             	pushl  0x8(%ebp)
80101494:	e8 37 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101499:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010149c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010149e:	8d 40 5c             	lea    0x5c(%eax),%eax
801014a1:	6a 1c                	push   $0x1c
801014a3:	50                   	push   %eax
801014a4:	56                   	push   %esi
801014a5:	e8 56 32 00 00       	call   80104700 <memmove>
  brelse(bp);
801014aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014ad:	83 c4 10             	add    $0x10,%esp
}
801014b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014b3:	5b                   	pop    %ebx
801014b4:	5e                   	pop    %esi
801014b5:	5d                   	pop    %ebp
  brelse(bp);
801014b6:	e9 35 ed ff ff       	jmp    801001f0 <brelse>
801014bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014bf:	90                   	nop

801014c0 <bfree>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	89 c6                	mov    %eax,%esi
801014c6:	53                   	push   %ebx
801014c7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 c0 09 11 80       	push   $0x801109c0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801014e4:	50                   	push   %eax
801014e5:	56                   	push   %esi
801014e6:	e8 e5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014f0:	ba 01 00 00 00       	mov    $0x1,%edx
801014f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101503:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 25                	je     80101531 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010150c:	f7 d2                	not    %edx
  log_write(bp);
8010150e:	83 ec 0c             	sub    $0xc,%esp
80101511:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101513:	21 ca                	and    %ecx,%edx
80101515:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101519:	50                   	push   %eax
8010151a:	e8 f1 19 00 00       	call   80102f10 <log_write>
  brelse(bp);
8010151f:	89 34 24             	mov    %esi,(%esp)
80101522:	e8 c9 ec ff ff       	call   801001f0 <brelse>
}
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152d:	5b                   	pop    %ebx
8010152e:	5e                   	pop    %esi
8010152f:	5d                   	pop    %ebp
80101530:	c3                   	ret    
    panic("freeing free block");
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	68 38 74 10 80       	push   $0x80107438
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 4b 74 10 80       	push   $0x8010744b
80101555:	68 e0 09 11 80       	push   $0x801109e0
8010155a:	e8 71 2e 00 00       	call   801043d0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 52 74 10 80       	push   $0x80107452
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 44 2d 00 00       	call   801042c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 09 11 80       	push   $0x801109c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010159d:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015a3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015a9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015af:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015b5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015bb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015c1:	68 b8 74 10 80       	push   $0x801074b8
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 fd 2f 00 00       	call   80104660 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 30 fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 58 74 10 80       	push   $0x80107458
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 f6 2f 00 00       	call   80104700 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 fe 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 09 11 80       	push   $0x801109e0
80101743:	e8 98 2d 00 00       	call   801044e0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101753:	e8 b8 2e 00 00       	call   80104610 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 75 2b 00 00       	call   80104300 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 03 2f 00 00       	call   80104700 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 70 74 10 80       	push   $0x80107470
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 6a 74 10 80       	push   $0x8010746a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 44 2b 00 00       	call   801043a0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 e8 2a 00 00       	jmp    80104360 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 7f 74 10 80       	push   $0x8010747f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 57 2a 00 00       	call   80104300 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 9d 2a 00 00       	call   80104360 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018ca:	e8 11 2c 00 00       	call   801044e0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 27 2d 00 00       	jmp    80104610 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 09 11 80       	push   $0x801109e0
801018f8:	e8 e3 2b 00 00       	call   801044e0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101907:	e8 04 2d 00 00       	call   80104610 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 84 fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 fc fa ff ff       	call   801014c0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 d5 fa ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 e1 f8 ff ff       	call   801013b0 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 f4 2b 00 00       	call   80104700 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 e1 f7 ff ff       	call   801013b0 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 f8 2a 00 00       	call   80104700 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 c9 2a 00 00       	call   80104770 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 66 2a 00 00       	call   80104770 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 81 f5 ff ff       	call   801012c0 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 99 74 10 80       	push   $0x80107499
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 87 74 10 80       	push   $0x80107487
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 e1 1b 00 00       	call   80103970 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 09 11 80       	push   $0x801109e0
80101d9c:	e8 3f 27 00 00       	call   801044e0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dac:	e8 5f 28 00 00       	call   80104610 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 e4 28 00 00       	call   80104700 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 58 28 00 00       	call   80104700 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 9f f3 ff ff       	call   801012c0 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 e6 27 00 00       	call   801047c0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 a8 74 10 80       	push   $0x801074a8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 86 7a 10 80       	push   $0x80107a86
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 14 75 10 80       	push   $0x80107514
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 0b 75 10 80       	push   $0x8010750b
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 26 75 10 80       	push   $0x80107526
8010215f:	68 80 a5 10 80       	push   $0x8010a580
80102164:	e8 67 22 00 00       	call   801043d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 a5 10 80       	push   $0x8010a580
801021f2:	e8 e9 22 00 00       	call   801044e0 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 ae 1e 00 00       	call   80104100 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 a5 10 80       	push   $0x8010a580
8010226b:	e8 a0 23 00 00       	call   80104610 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 09 21 00 00       	call   801043a0 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 a5 10 80       	push   $0x8010a580
801022cc:	e8 0f 22 00 00       	call   801044e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 a5 10 80       	push   $0x8010a580
80102318:	53                   	push   %ebx
80102319:	e8 22 1c 00 00       	call   80103f40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 d5 22 00 00       	jmp    80104610 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 55 75 10 80       	push   $0x80107555
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 40 75 10 80       	push   $0x80107540
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 2a 75 10 80       	push   $0x8010752a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 74 75 10 80       	push   $0x80107574
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 b5 21 00 00       	call   80104660 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024c4:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 40 26 11 80       	push   $0x80112640
801024e0:	e8 fb 1f 00 00       	call   801044e0 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 10 21 00 00       	jmp    80104610 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 a6 75 10 80       	push   $0x801075a6
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 ac 75 10 80       	push   $0x801075ac
80102574:	68 40 26 11 80       	push   $0x80112640
80102579:	e8 52 1e 00 00       	call   801043d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 74 26 11 80       	mov    0x80112674,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 40 26 11 80       	push   $0x80112640
80102663:	e8 78 1e 00 00       	call   801044e0 <acquire>
  r = kmem.freelist;
80102668:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010266d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 40 26 11 80       	push   $0x80112640
80102691:	e8 7a 1f 00 00       	call   80104610 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	ba 64 00 00 00       	mov    $0x64,%edx
801026a9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026aa:	a8 01                	test   $0x1,%al
801026ac:	0f 84 be 00 00 00    	je     80102770 <kbdgetc+0xd0>
{
801026b2:	55                   	push   %ebp
801026b3:	ba 60 00 00 00       	mov    $0x60,%edx
801026b8:	89 e5                	mov    %esp,%ebp
801026ba:	53                   	push   %ebx
801026bb:	ec                   	in     (%dx),%al
  return data;
801026bc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026c2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026c5:	3c e0                	cmp    $0xe0,%al
801026c7:	74 57                	je     80102720 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c9:	89 d9                	mov    %ebx,%ecx
801026cb:	83 e1 40             	and    $0x40,%ecx
801026ce:	84 c0                	test   %al,%al
801026d0:	78 5e                	js     80102730 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026d2:	85 c9                	test   %ecx,%ecx
801026d4:	74 09                	je     801026df <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026d6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026d9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026dc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026df:	0f b6 8a e0 76 10 80 	movzbl -0x7fef8920(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 e0 75 10 80 	movzbl -0x7fef8a20(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 c0 75 10 80 	mov    -0x7fef8a40(,%eax,4),%eax
80102706:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010270a:	74 0b                	je     80102717 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010270c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010270f:	83 fa 19             	cmp    $0x19,%edx
80102712:	77 44                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102714:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102717:	5b                   	pop    %ebx
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102720:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102723:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102725:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 c9                	test   %ecx,%ecx
80102735:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102738:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010273a:	0f b6 8a e0 76 10 80 	movzbl -0x7fef8920(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010275e:	5b                   	pop    %ebx
8010275f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102760:	83 f9 1a             	cmp    $0x1a,%ecx
80102763:	0f 42 c2             	cmovb  %edx,%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
    return -1;
80102770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <kbdintr>:

void
kbdintr(void)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010278a:	68 a0 26 10 80       	push   $0x801026a0
8010278f:	e8 cc e0 ff ff       	call   80100860 <consoleintr>
}
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	c9                   	leave  
80102798:	c3                   	ret    
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027a4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 c7 00 00 00    	je     80102878 <lapicinit+0xd8>
  lapic[index] = value;
801027b1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027b8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027be:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027c5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027d2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027df:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027e2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ec:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027f9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ff:	8b 50 30             	mov    0x30(%eax),%edx
80102802:	c1 ea 10             	shr    $0x10,%edx
80102805:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010280b:	75 73                	jne    80102880 <lapicinit+0xe0>
  lapic[index] = value;
8010280d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010283b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102848:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102855:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102860:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102866:	80 e6 10             	and    $0x10,%dh
80102869:	75 f5                	jne    80102860 <lapicinit+0xc0>
  lapic[index] = value;
8010286b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102872:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102880:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102887:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010288d:	e9 7b ff ff ff       	jmp    8010280d <lapicinit+0x6d>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <lapicid>:

int
lapicid(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028a4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	74 0b                	je     801028b8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
801028b0:	c1 e8 18             	shr    $0x18,%eax
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
}
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028c4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0d                	je     801028da <lapiceoi+0x1a>
  lapic[index] = value;
801028cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028e0:	f3 0f 1e fb          	endbr32 
}
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028fa:	ba 70 00 00 00       	mov    $0x70,%edx
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	53                   	push   %ebx
80102902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102905:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102908:	ee                   	out    %al,(%dx)
80102909:	b8 0a 00 00 00       	mov    $0xa,%eax
8010290e:	ba 71 00 00 00       	mov    $0x71,%edx
80102913:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102914:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102916:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102919:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010291f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102921:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102924:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102926:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102929:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010292c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102932:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102937:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102940:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102947:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102954:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102963:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102972:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102975:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010297b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010297f:	5d                   	pop    %ebp
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	b8 0b 00 00 00       	mov    $0xb,%eax
8010299a:	ba 70 00 00 00       	mov    $0x70,%edx
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	83 ec 4c             	sub    $0x4c,%esp
801029a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ad:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ae:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c0:	31 c0                	xor    %eax,%eax
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d0:	89 da                	mov    %ebx,%edx
801029d2:	b8 02 00 00 00       	mov    $0x2,%eax
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	89 ca                	mov    %ecx,%edx
801029da:	ec                   	in     (%dx),%al
801029db:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029de:	89 da                	mov    %ebx,%edx
801029e0:	b8 04 00 00 00       	mov    $0x4,%eax
801029e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e6:	89 ca                	mov    %ecx,%edx
801029e8:	ec                   	in     (%dx),%al
801029e9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 07 00 00 00       	mov    $0x7,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
801029f7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	b8 08 00 00 00       	mov    $0x8,%eax
80102a01:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a07:	89 da                	mov    %ebx,%edx
80102a09:	b8 09 00 00 00       	mov    $0x9,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a1f:	84 c0                	test   %al,%al
80102a21:	78 9d                	js     801029c0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a23:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a27:	89 fa                	mov    %edi,%edx
80102a29:	0f b6 fa             	movzbl %dl,%edi
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a31:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a40:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a44:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a4a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a4e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a51:	31 c0                	xor    %eax,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a5f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al
80102a68:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6b:	89 da                	mov    %ebx,%edx
80102a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a81:	b8 07 00 00 00       	mov    $0x7,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	89 da                	mov    %ebx,%edx
80102a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a92:	b8 08 00 00 00       	mov    $0x8,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 da                	mov    %ebx,%edx
80102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aa3:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aaf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab8:	6a 18                	push   $0x18
80102aba:	50                   	push   %eax
80102abb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102abe:	50                   	push   %eax
80102abf:	e8 ec 1b 00 00       	call   801046b0 <memcmp>
80102ac4:	83 c4 10             	add    $0x10,%esp
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	0f 85 f1 fe ff ff    	jne    801029c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102acf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ad3:	75 78                	jne    80102b4d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b4d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b50:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b53:	89 06                	mov    %eax,(%esi)
80102b55:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b58:	89 46 04             	mov    %eax,0x4(%esi)
80102b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b5e:	89 46 08             	mov    %eax,0x8(%esi)
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 46 0c             	mov    %eax,0xc(%esi)
80102b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b6a:	89 46 10             	mov    %eax,0x10(%esi)
80102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b70:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b73:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7d:	5b                   	pop    %ebx
80102b7e:	5e                   	pop    %esi
80102b7f:	5f                   	pop    %edi
80102b80:	5d                   	pop    %ebp
80102b81:	c3                   	ret    
80102b82:	66 90                	xchg   %ax,%ax
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102bd4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 07 1b 00 00       	call   80104700 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c3d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	53                   	push   %ebx
80102c98:	83 ec 2c             	sub    $0x2c,%esp
80102c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9e:	68 e0 77 10 80       	push   $0x801077e0
80102ca3:	68 80 26 11 80       	push   $0x80112680
80102ca8:	e8 23 17 00 00       	call   801043d0 <initlock>
  readsb(dev, &sb);
80102cad:	58                   	pop    %eax
80102cae:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb1:	5a                   	pop    %edx
80102cb2:	50                   	push   %eax
80102cb3:	53                   	push   %ebx
80102cb4:	e8 c7 e7 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cbc:	59                   	pop    %ecx
  log.dev = dev;
80102cbd:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102ccb:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d1                	cmp    %edx,%ecx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d3a:	68 80 26 11 80       	push   $0x80112680
80102d3f:	e8 9c 17 00 00       	call   801044e0 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 80 26 11 80       	push   $0x80112680
80102d58:	68 80 26 11 80       	push   $0x80112680
80102d5d:	e8 de 11 00 00       	call   80103f40 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d73:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d7f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d82:	83 fa 1e             	cmp    $0x1e,%edx
80102d85:	7f c9                	jg     80102d50 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d8a:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d8f:	68 80 26 11 80       	push   $0x80112680
80102d94:	e8 77 18 00 00       	call   80104610 <release>
      break;
    }
  }
}
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	57                   	push   %edi
80102da8:	56                   	push   %esi
80102da9:	53                   	push   %ebx
80102daa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dad:	68 80 26 11 80       	push   $0x80112680
80102db2:	e8 29 17 00 00       	call   801044e0 <acquire>
  log.outstanding -= 1;
80102db7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102dbc:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 80 26 11 80       	push   $0x80112680
80102df0:	e8 1b 18 00 00       	call   80104610 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 80 26 11 80       	push   $0x80112680
80102e0a:	e8 d1 16 00 00       	call   801044e0 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e16:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 db 12 00 00       	call   80104100 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e2c:	e8 df 17 00 00       	call   80104610 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e64:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 77 18 00 00       	call   80104700 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 80 26 11 80       	push   $0x80112680
80102ed8:	e8 23 12 00 00       	call   80104100 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ee4:	e8 27 17 00 00       	call   80104610 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 e4 77 10 80       	push   $0x801077e4
80102efc:	e8 8f d4 ff ff       	call   80100390 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f1b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 80 26 11 80       	push   $0x80112680
80102f52:	e8 89 15 00 00       	call   801044e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f5d:	83 c4 10             	add    $0x10,%esp
80102f60:	85 d2                	test   %edx,%edx
80102f62:	7e 4e                	jle    80102fb2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f67:	31 c0                	xor    %eax,%eax
80102f69:	eb 0c                	jmp    80102f77 <log_write+0x67>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 76 16 00 00       	jmp    80104610 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 f3 77 10 80       	push   $0x801077f3
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 09 78 10 80       	push   $0x80107809
80102fd3:	e8 b8 d3 ff ff       	call   80100390 <panic>
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 64 09 00 00       	call   80103950 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 5d 09 00 00       	call   80103950 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 24 78 10 80       	push   $0x80107824
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 79 29 00 00       	call   80105980 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 d4 08 00 00       	call   801038e0 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 31 0c 00 00       	call   80103c50 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 c1 3a 00 00       	call   80106af0 <switchkvm>
  seginit();
8010302f:	e8 9c 39 00 00       	call   801069d0 <seginit>
  lapicinit();
80103034:	e8 67 f7 ff ff       	call   801027a0 <lapicinit>
  mpmain();
80103039:	e8 a2 ff ff ff       	call   80102fe0 <mpmain>
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103048:	83 e4 f0             	and    $0xfffffff0,%esp
8010304b:	ff 71 fc             	pushl  -0x4(%ecx)
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	53                   	push   %ebx
80103052:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103053:	83 ec 08             	sub    $0x8,%esp
80103056:	68 00 00 40 80       	push   $0x80400000
8010305b:	68 f4 58 11 80       	push   $0x801158f4
80103060:	e8 fb f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103065:	e8 76 3f 00 00       	call   80106fe0 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 91 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 57 39 00 00       	call   801069d0 <seginit>
  picinit();       // disable pic
80103079:	e8 62 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 93 2c 00 00       	call   80105d20 <uartinit>
  pinit();         // process table
8010308d:	e8 2e 08 00 00       	call   801038c0 <pinit>
  shminit();       // shared memory
80103092:	e8 19 42 00 00       	call   801072b0 <shminit>
  tvinit();        // trap vectors
80103097:	e8 64 28 00 00       	call   80105900 <tvinit>
  binit();         // buffer cache
8010309c:	e8 9f cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030a1:	e8 3a dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030a6:	e8 a5 f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030ab:	83 c4 0c             	add    $0xc,%esp
801030ae:	68 8a 00 00 00       	push   $0x8a
801030b3:	68 8c a4 10 80       	push   $0x8010a48c
801030b8:	68 00 70 00 80       	push   $0x80007000
801030bd:	e8 3e 16 00 00       	call   80104700 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030c2:	83 c4 10             	add    $0x10,%esp
801030c5:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030cc:	00 00 00 
801030cf:	05 80 27 11 80       	add    $0x80112780,%eax
801030d4:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801030d9:	76 7d                	jbe    80103158 <main+0x118>
801030db:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801030e0:	eb 1f                	jmp    80103101 <main+0xc1>
801030e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030e8:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030ef:	00 00 00 
801030f2:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030f8:	05 80 27 11 80       	add    $0x80112780,%eax
801030fd:	39 c3                	cmp    %eax,%ebx
801030ff:	73 57                	jae    80103158 <main+0x118>
    if(c == mycpu())  // We've started already.
80103101:	e8 da 07 00 00       	call   801038e0 <mycpu>
80103106:	39 c3                	cmp    %eax,%ebx
80103108:	74 de                	je     801030e8 <main+0xa8>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010310a:	e8 21 f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
8010310f:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
80103112:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
80103119:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010311c:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103123:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103126:	05 00 10 00 00       	add    $0x1000,%eax
8010312b:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103130:	0f b6 03             	movzbl (%ebx),%eax
80103133:	68 00 70 00 00       	push   $0x7000
80103138:	50                   	push   %eax
80103139:	e8 b2 f7 ff ff       	call   801028f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010313e:	83 c4 10             	add    $0x10,%esp
80103141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103148:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010314e:	85 c0                	test   %eax,%eax
80103150:	74 f6                	je     80103148 <main+0x108>
80103152:	eb 94                	jmp    801030e8 <main+0xa8>
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103158:	83 ec 08             	sub    $0x8,%esp
8010315b:	68 00 00 00 8e       	push   $0x8e000000
80103160:	68 00 00 40 80       	push   $0x80400000
80103165:	e8 66 f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
8010316a:	e8 31 08 00 00       	call   801039a0 <userinit>
  mpmain();        // finish this processor's setup
8010316f:	e8 6c fe ff ff       	call   80102fe0 <mpmain>
80103174:	66 90                	xchg   %ax,%ax
80103176:	66 90                	xchg   %ax,%ax
80103178:	66 90                	xchg   %ax,%ax
8010317a:	66 90                	xchg   %ax,%ax
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 38 78 10 80       	push   $0x80107838
801031b3:	56                   	push   %esi
801031b4:	e8 f7 14 00 00       	call   801046b0 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 3d 78 10 80       	push   $0x8010783d
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 38 14 00 00       	call   801046b0 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 42 78 10 80       	push   $0x80107842
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 5c 78 10 80       	push   $0x8010785c
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 dc d9 ff ff       	call   80100e00 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 cd d9 ff ff       	call   80100e00 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 ee f1 ff ff       	call   80102630 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 7b 78 10 80       	push   $0x8010787b
8010347c:	50                   	push   %eax
8010347d:	e8 4e 0f 00 00       	call   801043d0 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 e9 d9 ff ff       	call   80100ec0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 d7 d9 ff ff       	call   80100ec0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 b8 0f 00 00       	call   801044e0 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 b8 0b 00 00       	call   80104100 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 a3 10 00 00       	jmp    80104610 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 77 0b 00 00       	call   80104100 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 77 10 00 00       	call   80104610 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 c6 ee ff ff       	jmp    80102470 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 1a 0f 00 00       	call   801044e0 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 63 03 00 00       	call   80103970 <myproc>
8010360d:	8b 48 24             	mov    0x24(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 e3 0a 00 00       	call   80104100 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 1a 09 00 00       	call   80103f40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 bf 0f 00 00       	call   80104610 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 61 0a 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 69 0f 00 00       	call   80104610 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 11 0e 00 00       	call   801044e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 83 02 00 00       	call   80103970 <myproc>
801036ed:	8b 48 24             	mov    0x24(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 3e 08 00 00       	call   80103f40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 95 09 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 9d 0e 00 00       	call   80104610 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 82 0e 00 00       	call   80104610 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 2d 11 80       	push   $0x80112d20
801037b1:	e8 2a 0d 00 00       	call   801044e0 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 10                	jmp    801037cb <allocproc+0x2b>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	83 eb 80             	sub    $0xffffff80,%ebx
801037c3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801037c9:	74 75                	je     80103840 <allocproc+0xa0>
    if(p->state == UNUSED)
801037cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801037ce:	85 c0                	test   %eax,%eax
801037d0:	75 ee                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037da:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037e1:	89 43 10             	mov    %eax,0x10(%ebx)
801037e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037e7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037ec:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801037f2:	e8 19 0e 00 00       	call   80104610 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037f7:	e8 34 ee ff ff       	call   80102630 <kalloc>
801037fc:	83 c4 10             	add    $0x10,%esp
801037ff:	89 43 08             	mov    %eax,0x8(%ebx)
80103802:	85 c0                	test   %eax,%eax
80103804:	74 53                	je     80103859 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103806:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010380c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010380f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103814:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103817:	c7 40 14 e6 58 10 80 	movl   $0x801058e6,0x14(%eax)
  p->context = (struct context*)sp;
8010381e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103821:	6a 14                	push   $0x14
80103823:	6a 00                	push   $0x0
80103825:	50                   	push   %eax
80103826:	e8 35 0e 00 00       	call   80104660 <memset>
  p->context->eip = (uint)forkret;
8010382b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010382e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103831:	c7 40 10 70 38 10 80 	movl   $0x80103870,0x10(%eax)
}
80103838:	89 d8                	mov    %ebx,%eax
8010383a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010383d:	c9                   	leave  
8010383e:	c3                   	ret    
8010383f:	90                   	nop
  release(&ptable.lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103843:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103845:	68 20 2d 11 80       	push   $0x80112d20
8010384a:	e8 c1 0d 00 00       	call   80104610 <release>
}
8010384f:	89 d8                	mov    %ebx,%eax
  return 0;
80103851:	83 c4 10             	add    $0x10,%esp
}
80103854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103857:	c9                   	leave  
80103858:	c3                   	ret    
    p->state = UNUSED;
80103859:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103860:	31 db                	xor    %ebx,%ebx
}
80103862:	89 d8                	mov    %ebx,%eax
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103870 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103870:	f3 0f 1e fb          	endbr32 
80103874:	55                   	push   %ebp
80103875:	89 e5                	mov    %esp,%ebp
80103877:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010387a:	68 20 2d 11 80       	push   $0x80112d20
8010387f:	e8 8c 0d 00 00       	call   80104610 <release>

  if (first) {
80103884:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	85 c0                	test   %eax,%eax
8010388e:	75 08                	jne    80103898 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103890:	c9                   	leave  
80103891:	c3                   	ret    
80103892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103898:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010389f:	00 00 00 
    iinit(ROOTDEV);
801038a2:	83 ec 0c             	sub    $0xc,%esp
801038a5:	6a 01                	push   $0x1
801038a7:	e8 94 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038b3:	e8 d8 f3 ff ff       	call   80102c90 <initlog>
}
801038b8:	83 c4 10             	add    $0x10,%esp
801038bb:	c9                   	leave  
801038bc:	c3                   	ret    
801038bd:	8d 76 00             	lea    0x0(%esi),%esi

801038c0 <pinit>:
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038ca:	68 80 78 10 80       	push   $0x80107880
801038cf:	68 20 2d 11 80       	push   $0x80112d20
801038d4:	e8 f7 0a 00 00       	call   801043d0 <initlock>
}
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	c9                   	leave  
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax

801038e0 <mycpu>:
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	56                   	push   %esi
801038e8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038e9:	9c                   	pushf  
801038ea:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038eb:	f6 c4 02             	test   $0x2,%ah
801038ee:	75 4a                	jne    8010393a <mycpu+0x5a>
  apicid = lapicid();
801038f0:	e8 ab ef ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038f5:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
801038fb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801038fd:	85 f6                	test   %esi,%esi
801038ff:	7e 2c                	jle    8010392d <mycpu+0x4d>
80103901:	31 d2                	xor    %edx,%edx
80103903:	eb 0a                	jmp    8010390f <mycpu+0x2f>
80103905:	8d 76 00             	lea    0x0(%esi),%esi
80103908:	83 c2 01             	add    $0x1,%edx
8010390b:	39 f2                	cmp    %esi,%edx
8010390d:	74 1e                	je     8010392d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010390f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103915:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010391c:	39 d8                	cmp    %ebx,%eax
8010391e:	75 e8                	jne    80103908 <mycpu+0x28>
}
80103920:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103923:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103929:	5b                   	pop    %ebx
8010392a:	5e                   	pop    %esi
8010392b:	5d                   	pop    %ebp
8010392c:	c3                   	ret    
  panic("unknown apicid\n");
8010392d:	83 ec 0c             	sub    $0xc,%esp
80103930:	68 87 78 10 80       	push   $0x80107887
80103935:	e8 56 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010393a:	83 ec 0c             	sub    $0xc,%esp
8010393d:	68 64 79 10 80       	push   $0x80107964
80103942:	e8 49 ca ff ff       	call   80100390 <panic>
80103947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394e:	66 90                	xchg   %ax,%ax

80103950 <cpuid>:
cpuid() {
80103950:	f3 0f 1e fb          	endbr32 
80103954:	55                   	push   %ebp
80103955:	89 e5                	mov    %esp,%ebp
80103957:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010395a:	e8 81 ff ff ff       	call   801038e0 <mycpu>
}
8010395f:	c9                   	leave  
  return mycpu()-cpus;
80103960:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103965:	c1 f8 04             	sar    $0x4,%eax
80103968:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010396e:	c3                   	ret    
8010396f:	90                   	nop

80103970 <myproc>:
myproc(void) {
80103970:	f3 0f 1e fb          	endbr32 
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	53                   	push   %ebx
80103978:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010397b:	e8 10 0b 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103980:	e8 5b ff ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103985:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010398b:	e8 20 0c 00 00       	call   801045b0 <popcli>
}
80103990:	83 c4 04             	add    $0x4,%esp
80103993:	89 d8                	mov    %ebx,%eax
80103995:	5b                   	pop    %ebx
80103996:	5d                   	pop    %ebp
80103997:	c3                   	ret    
80103998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop

801039a0 <userinit>:
{
801039a0:	f3 0f 1e fb          	endbr32 
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	53                   	push   %ebx
801039a8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039ab:	e8 f0 fd ff ff       	call   801037a0 <allocproc>
801039b0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039b2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039b7:	e8 a4 35 00 00       	call   80106f60 <setupkvm>
801039bc:	89 43 04             	mov    %eax,0x4(%ebx)
801039bf:	85 c0                	test   %eax,%eax
801039c1:	0f 84 bd 00 00 00    	je     80103a84 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039c7:	83 ec 04             	sub    $0x4,%esp
801039ca:	68 2c 00 00 00       	push   $0x2c
801039cf:	68 60 a4 10 80       	push   $0x8010a460
801039d4:	50                   	push   %eax
801039d5:	e8 46 32 00 00       	call   80106c20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039da:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039dd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039e3:	6a 4c                	push   $0x4c
801039e5:	6a 00                	push   $0x0
801039e7:	ff 73 18             	pushl  0x18(%ebx)
801039ea:	e8 71 0c 00 00       	call   80104660 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ef:	8b 43 18             	mov    0x18(%ebx),%eax
801039f2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039f7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039fa:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ff:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a03:	8b 43 18             	mov    0x18(%ebx),%eax
80103a06:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a0a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a11:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a15:	8b 43 18             	mov    0x18(%ebx),%eax
80103a18:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a20:	8b 43 18             	mov    0x18(%ebx),%eax
80103a23:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a2a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a34:	8b 43 18             	mov    0x18(%ebx),%eax
80103a37:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a3e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a41:	6a 10                	push   $0x10
80103a43:	68 b0 78 10 80       	push   $0x801078b0
80103a48:	50                   	push   %eax
80103a49:	e8 d2 0d 00 00       	call   80104820 <safestrcpy>
  p->cwd = namei("/");
80103a4e:	c7 04 24 b9 78 10 80 	movl   $0x801078b9,(%esp)
80103a55:	e8 d6 e5 ff ff       	call   80102030 <namei>
80103a5a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a5d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a64:	e8 77 0a 00 00       	call   801044e0 <acquire>
  p->state = RUNNABLE;
80103a69:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a70:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a77:	e8 94 0b 00 00       	call   80104610 <release>
}
80103a7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a7f:	83 c4 10             	add    $0x10,%esp
80103a82:	c9                   	leave  
80103a83:	c3                   	ret    
    panic("userinit: out of memory?");
80103a84:	83 ec 0c             	sub    $0xc,%esp
80103a87:	68 97 78 10 80       	push   $0x80107897
80103a8c:	e8 ff c8 ff ff       	call   80100390 <panic>
80103a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop

80103aa0 <growproc>:
{
80103aa0:	f3 0f 1e fb          	endbr32 
80103aa4:	55                   	push   %ebp
80103aa5:	89 e5                	mov    %esp,%ebp
80103aa7:	56                   	push   %esi
80103aa8:	53                   	push   %ebx
80103aa9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aac:	e8 df 09 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103ab1:	e8 2a fe ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103ab6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103abc:	e8 ef 0a 00 00       	call   801045b0 <popcli>
  sz = curproc->sz;
80103ac1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ac3:	85 f6                	test   %esi,%esi
80103ac5:	7f 19                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac7:	75 37                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103acc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ace:	53                   	push   %ebx
80103acf:	e8 3c 30 00 00       	call   80106b10 <switchuvm>
  return 0;
80103ad4:	83 c4 10             	add    $0x10,%esp
80103ad7:	31 c0                	xor    %eax,%eax
}
80103ad9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103adc:	5b                   	pop    %ebx
80103add:	5e                   	pop    %esi
80103ade:	5d                   	pop    %ebp
80103adf:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	pushl  0x4(%ebx)
80103aea:	e8 81 32 00 00       	call   80106d70 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 d3                	jne    80103ac9 <growproc+0x29>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb dc                	jmp    80103ad9 <growproc+0x39>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	pushl  0x4(%ebx)
80103b0a:	e8 a1 33 00 00       	call   80106eb0 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 b3                	jne    80103ac9 <growproc+0x29>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <fork>:
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	57                   	push   %edi
80103b28:	56                   	push   %esi
80103b29:	53                   	push   %ebx
80103b2a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b2d:	e8 5e 09 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103b32:	e8 a9 fd ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103b37:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b3d:	e8 6e 0a 00 00       	call   801045b0 <popcli>
  if((np = allocproc()) == 0){
80103b42:	e8 59 fc ff ff       	call   801037a0 <allocproc>
80103b47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b4a:	85 c0                	test   %eax,%eax
80103b4c:	0f 84 c3 00 00 00    	je     80103c15 <fork+0xf5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b52:	83 ec 08             	sub    $0x8,%esp
80103b55:	ff 33                	pushl  (%ebx)
80103b57:	89 c7                	mov    %eax,%edi
80103b59:	ff 73 04             	pushl  0x4(%ebx)
80103b5c:	e8 cf 34 00 00       	call   80107030 <copyuvm>
80103b61:	83 c4 10             	add    $0x10,%esp
80103b64:	89 47 04             	mov    %eax,0x4(%edi)
80103b67:	85 c0                	test   %eax,%eax
80103b69:	0f 84 ad 00 00 00    	je     80103c1c <fork+0xfc>
  np->sz = curproc->sz;
80103b6f:	8b 03                	mov    (%ebx),%eax
80103b71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103b74:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103b79:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103b7b:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80103b7e:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103b81:	8b 73 18             	mov    0x18(%ebx),%esi
80103b84:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b86:	31 f6                	xor    %esi,%esi
  np->stack_pages = curproc->stack_pages;
80103b88:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b8b:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
80103b8e:	8b 42 18             	mov    0x18(%edx),%eax
80103b91:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 13                	je     80103bbb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	50                   	push   %eax
80103bac:	e8 bf d2 ff ff       	call   80100e70 <filedup>
80103bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bbb:	83 c6 01             	add    $0x1,%esi
80103bbe:	83 fe 10             	cmp    $0x10,%esi
80103bc1:	75 dd                	jne    80103ba0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103bc3:	83 ec 0c             	sub    $0xc,%esp
80103bc6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bcc:	e8 5f db ff ff       	call   80101730 <idup>
80103bd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bd7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	53                   	push   %ebx
80103be0:	50                   	push   %eax
80103be1:	e8 3a 0c 00 00       	call   80104820 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf0:	e8 eb 08 00 00       	call   801044e0 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c03:	e8 08 0a 00 00       	call   80104610 <release>
  return pid;
80103c08:	83 c4 10             	add    $0x10,%esp
}
80103c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0e:	89 d8                	mov    %ebx,%eax
80103c10:	5b                   	pop    %ebx
80103c11:	5e                   	pop    %esi
80103c12:	5f                   	pop    %edi
80103c13:	5d                   	pop    %ebp
80103c14:	c3                   	ret    
    return -1;
80103c15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c1a:	eb ef                	jmp    80103c0b <fork+0xeb>
    kfree(np->kstack);
80103c1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c1f:	83 ec 0c             	sub    $0xc,%esp
80103c22:	ff 73 08             	pushl  0x8(%ebx)
80103c25:	e8 46 e8 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103c2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c31:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c34:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c40:	eb c9                	jmp    80103c0b <fork+0xeb>
80103c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <scheduler>:
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	57                   	push   %edi
80103c58:	56                   	push   %esi
80103c59:	53                   	push   %ebx
80103c5a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c5d:	e8 7e fc ff ff       	call   801038e0 <mycpu>
  c->proc = 0;
80103c62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c69:	00 00 00 
  struct cpu *c = mycpu();
80103c6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6e:	8d 78 04             	lea    0x4(%eax),%edi
80103c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103c78:	fb                   	sti    
    acquire(&ptable.lock);
80103c79:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c7c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c81:	68 20 2d 11 80       	push   $0x80112d20
80103c86:	e8 55 08 00 00       	call   801044e0 <acquire>
80103c8b:	83 c4 10             	add    $0x10,%esp
80103c8e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c94:	75 33                	jne    80103cc9 <scheduler+0x79>
      switchuvm(p);
80103c96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 6b 2e 00 00       	call   80106b10 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	ff 73 1c             	pushl  0x1c(%ebx)
80103caa:	57                   	push   %edi
      p->state = RUNNING;
80103cab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cb2:	e8 cc 0b 00 00       	call   80104883 <swtch>
      switchkvm();
80103cb7:	e8 34 2e 00 00       	call   80106af0 <switchkvm>
      c->proc = 0;
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc9:	83 eb 80             	sub    $0xffffff80,%ebx
80103ccc:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cd2:	75 bc                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	68 20 2d 11 80       	push   $0x80112d20
80103cdc:	e8 2f 09 00 00       	call   80104610 <release>
    sti();
80103ce1:	83 c4 10             	add    $0x10,%esp
80103ce4:	eb 92                	jmp    80103c78 <scheduler+0x28>
80103ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ced:	8d 76 00             	lea    0x0(%esi),%esi

80103cf0 <sched>:
{
80103cf0:	f3 0f 1e fb          	endbr32 
80103cf4:	55                   	push   %ebp
80103cf5:	89 e5                	mov    %esp,%ebp
80103cf7:	56                   	push   %esi
80103cf8:	53                   	push   %ebx
  pushcli();
80103cf9:	e8 92 07 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103cfe:	e8 dd fb ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103d03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d09:	e8 a2 08 00 00       	call   801045b0 <popcli>
  if(!holding(&ptable.lock))
80103d0e:	83 ec 0c             	sub    $0xc,%esp
80103d11:	68 20 2d 11 80       	push   $0x80112d20
80103d16:	e8 35 07 00 00       	call   80104450 <holding>
80103d1b:	83 c4 10             	add    $0x10,%esp
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	74 4f                	je     80103d71 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d22:	e8 b9 fb ff ff       	call   801038e0 <mycpu>
80103d27:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d2e:	75 68                	jne    80103d98 <sched+0xa8>
  if(p->state == RUNNING)
80103d30:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d34:	74 55                	je     80103d8b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d36:	9c                   	pushf  
80103d37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d38:	f6 c4 02             	test   $0x2,%ah
80103d3b:	75 41                	jne    80103d7e <sched+0x8e>
  intena = mycpu()->intena;
80103d3d:	e8 9e fb ff ff       	call   801038e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d42:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d45:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d4b:	e8 90 fb ff ff       	call   801038e0 <mycpu>
80103d50:	83 ec 08             	sub    $0x8,%esp
80103d53:	ff 70 04             	pushl  0x4(%eax)
80103d56:	53                   	push   %ebx
80103d57:	e8 27 0b 00 00       	call   80104883 <swtch>
  mycpu()->intena = intena;
80103d5c:	e8 7f fb ff ff       	call   801038e0 <mycpu>
}
80103d61:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d64:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d6d:	5b                   	pop    %ebx
80103d6e:	5e                   	pop    %esi
80103d6f:	5d                   	pop    %ebp
80103d70:	c3                   	ret    
    panic("sched ptable.lock");
80103d71:	83 ec 0c             	sub    $0xc,%esp
80103d74:	68 bb 78 10 80       	push   $0x801078bb
80103d79:	e8 12 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d7e:	83 ec 0c             	sub    $0xc,%esp
80103d81:	68 e7 78 10 80       	push   $0x801078e7
80103d86:	e8 05 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d8b:	83 ec 0c             	sub    $0xc,%esp
80103d8e:	68 d9 78 10 80       	push   $0x801078d9
80103d93:	e8 f8 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d98:	83 ec 0c             	sub    $0xc,%esp
80103d9b:	68 cd 78 10 80       	push   $0x801078cd
80103da0:	e8 eb c5 ff ff       	call   80100390 <panic>
80103da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103db0 <exit>:
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	57                   	push   %edi
80103db8:	56                   	push   %esi
80103db9:	53                   	push   %ebx
80103dba:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103dbd:	e8 ce 06 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103dc2:	e8 19 fb ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103dc7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dcd:	e8 de 07 00 00       	call   801045b0 <popcli>
  if(curproc == initproc)
80103dd2:	8d 5e 28             	lea    0x28(%esi),%ebx
80103dd5:	8d 7e 68             	lea    0x68(%esi),%edi
80103dd8:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103dde:	0f 84 f3 00 00 00    	je     80103ed7 <exit+0x127>
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103de8:	8b 03                	mov    (%ebx),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 12                	je     80103e00 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	50                   	push   %eax
80103df2:	e8 c9 d0 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103df7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103dfd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e00:	83 c3 04             	add    $0x4,%ebx
80103e03:	39 df                	cmp    %ebx,%edi
80103e05:	75 e1                	jne    80103de8 <exit+0x38>
  begin_op();
80103e07:	e8 24 ef ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
80103e0c:	83 ec 0c             	sub    $0xc,%esp
80103e0f:	ff 76 68             	pushl  0x68(%esi)
80103e12:	e8 79 da ff ff       	call   80101890 <iput>
  end_op();
80103e17:	e8 84 ef ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
80103e1c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e2a:	e8 b1 06 00 00       	call   801044e0 <acquire>
  wakeup1(curproc->parent);
80103e2f:	8b 56 14             	mov    0x14(%esi),%edx
80103e32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e35:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e3a:	eb 0e                	jmp    80103e4a <exit+0x9a>
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e40:	83 e8 80             	sub    $0xffffff80,%eax
80103e43:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e48:	74 1c                	je     80103e66 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103e4a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e4e:	75 f0                	jne    80103e40 <exit+0x90>
80103e50:	3b 50 20             	cmp    0x20(%eax),%edx
80103e53:	75 eb                	jne    80103e40 <exit+0x90>
      p->state = RUNNABLE;
80103e55:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e5c:	83 e8 80             	sub    $0xffffff80,%eax
80103e5f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e64:	75 e4                	jne    80103e4a <exit+0x9a>
      p->parent = initproc;
80103e66:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e71:	eb 10                	jmp    80103e83 <exit+0xd3>
80103e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e77:	90                   	nop
80103e78:	83 ea 80             	sub    $0xffffff80,%edx
80103e7b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103e81:	74 3b                	je     80103ebe <exit+0x10e>
    if(p->parent == curproc){
80103e83:	39 72 14             	cmp    %esi,0x14(%edx)
80103e86:	75 f0                	jne    80103e78 <exit+0xc8>
      if(p->state == ZOMBIE)
80103e88:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e8c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e8f:	75 e7                	jne    80103e78 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e91:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e96:	eb 12                	jmp    80103eaa <exit+0xfa>
80103e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9f:	90                   	nop
80103ea0:	83 e8 80             	sub    $0xffffff80,%eax
80103ea3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ea8:	74 ce                	je     80103e78 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103eaa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eae:	75 f0                	jne    80103ea0 <exit+0xf0>
80103eb0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103eb3:	75 eb                	jne    80103ea0 <exit+0xf0>
      p->state = RUNNABLE;
80103eb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ebc:	eb e2                	jmp    80103ea0 <exit+0xf0>
  curproc->state = ZOMBIE;
80103ebe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103ec5:	e8 26 fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 08 79 10 80       	push   $0x80107908
80103ed2:	e8 b9 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103ed7:	83 ec 0c             	sub    $0xc,%esp
80103eda:	68 fb 78 10 80       	push   $0x801078fb
80103edf:	e8 ac c4 ff ff       	call   80100390 <panic>
80103ee4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eef:	90                   	nop

80103ef0 <yield>:
{
80103ef0:	f3 0f 1e fb          	endbr32 
80103ef4:	55                   	push   %ebp
80103ef5:	89 e5                	mov    %esp,%ebp
80103ef7:	53                   	push   %ebx
80103ef8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103efb:	68 20 2d 11 80       	push   $0x80112d20
80103f00:	e8 db 05 00 00       	call   801044e0 <acquire>
  pushcli();
80103f05:	e8 86 05 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103f0a:	e8 d1 f9 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103f0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f15:	e8 96 06 00 00       	call   801045b0 <popcli>
  myproc()->state = RUNNABLE;
80103f1a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f21:	e8 ca fd ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80103f26:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f2d:	e8 de 06 00 00       	call   80104610 <release>
}
80103f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f35:	83 c4 10             	add    $0x10,%esp
80103f38:	c9                   	leave  
80103f39:	c3                   	ret    
80103f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f40 <sleep>:
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	57                   	push   %edi
80103f48:	56                   	push   %esi
80103f49:	53                   	push   %ebx
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f50:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f53:	e8 38 05 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103f58:	e8 83 f9 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103f5d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f63:	e8 48 06 00 00       	call   801045b0 <popcli>
  if(p == 0)
80103f68:	85 db                	test   %ebx,%ebx
80103f6a:	0f 84 83 00 00 00    	je     80103ff3 <sleep+0xb3>
  if(lk == 0)
80103f70:	85 f6                	test   %esi,%esi
80103f72:	74 72                	je     80103fe6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f74:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f7a:	74 4c                	je     80103fc8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f7c:	83 ec 0c             	sub    $0xc,%esp
80103f7f:	68 20 2d 11 80       	push   $0x80112d20
80103f84:	e8 57 05 00 00       	call   801044e0 <acquire>
    release(lk);
80103f89:	89 34 24             	mov    %esi,(%esp)
80103f8c:	e8 7f 06 00 00       	call   80104610 <release>
  p->chan = chan;
80103f91:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f94:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f9b:	e8 50 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103fa0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103fa7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fae:	e8 5d 06 00 00       	call   80104610 <release>
    acquire(lk);
80103fb3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fb6:	83 c4 10             	add    $0x10,%esp
}
80103fb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fbc:	5b                   	pop    %ebx
80103fbd:	5e                   	pop    %esi
80103fbe:	5f                   	pop    %edi
80103fbf:	5d                   	pop    %ebp
    acquire(lk);
80103fc0:	e9 1b 05 00 00       	jmp    801044e0 <acquire>
80103fc5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103fc8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fcb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fd2:	e8 19 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103fd7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe1:	5b                   	pop    %ebx
80103fe2:	5e                   	pop    %esi
80103fe3:	5f                   	pop    %edi
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret    
    panic("sleep without lk");
80103fe6:	83 ec 0c             	sub    $0xc,%esp
80103fe9:	68 1a 79 10 80       	push   $0x8010791a
80103fee:	e8 9d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ff3:	83 ec 0c             	sub    $0xc,%esp
80103ff6:	68 14 79 10 80       	push   $0x80107914
80103ffb:	e8 90 c3 ff ff       	call   80100390 <panic>

80104000 <wait>:
{
80104000:	f3 0f 1e fb          	endbr32 
80104004:	55                   	push   %ebp
80104005:	89 e5                	mov    %esp,%ebp
80104007:	56                   	push   %esi
80104008:	53                   	push   %ebx
  pushcli();
80104009:	e8 82 04 00 00       	call   80104490 <pushcli>
  c = mycpu();
8010400e:	e8 cd f8 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80104013:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104019:	e8 92 05 00 00       	call   801045b0 <popcli>
  acquire(&ptable.lock);
8010401e:	83 ec 0c             	sub    $0xc,%esp
80104021:	68 20 2d 11 80       	push   $0x80112d20
80104026:	e8 b5 04 00 00       	call   801044e0 <acquire>
8010402b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010402e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104030:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104035:	eb 14                	jmp    8010404b <wait+0x4b>
80104037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403e:	66 90                	xchg   %ax,%ax
80104040:	83 eb 80             	sub    $0xffffff80,%ebx
80104043:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104049:	74 1b                	je     80104066 <wait+0x66>
      if(p->parent != curproc)
8010404b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010404e:	75 f0                	jne    80104040 <wait+0x40>
      if(p->state == ZOMBIE){
80104050:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104054:	74 32                	je     80104088 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104056:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104059:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405e:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104064:	75 e5                	jne    8010404b <wait+0x4b>
    if(!havekids || curproc->killed){
80104066:	85 c0                	test   %eax,%eax
80104068:	74 74                	je     801040de <wait+0xde>
8010406a:	8b 46 24             	mov    0x24(%esi),%eax
8010406d:	85 c0                	test   %eax,%eax
8010406f:	75 6d                	jne    801040de <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104071:	83 ec 08             	sub    $0x8,%esp
80104074:	68 20 2d 11 80       	push   $0x80112d20
80104079:	56                   	push   %esi
8010407a:	e8 c1 fe ff ff       	call   80103f40 <sleep>
    havekids = 0;
8010407f:	83 c4 10             	add    $0x10,%esp
80104082:	eb aa                	jmp    8010402e <wait+0x2e>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010408e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104091:	e8 da e3 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
80104096:	5a                   	pop    %edx
80104097:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010409a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040a1:	e8 3a 2e 00 00       	call   80106ee0 <freevm>
        release(&ptable.lock);
801040a6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
801040ad:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040b4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040bb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040bf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040c6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040cd:	e8 3e 05 00 00       	call   80104610 <release>
        return pid;
801040d2:	83 c4 10             	add    $0x10,%esp
}
801040d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040d8:	89 f0                	mov    %esi,%eax
801040da:	5b                   	pop    %ebx
801040db:	5e                   	pop    %esi
801040dc:	5d                   	pop    %ebp
801040dd:	c3                   	ret    
      release(&ptable.lock);
801040de:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040e1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040e6:	68 20 2d 11 80       	push   $0x80112d20
801040eb:	e8 20 05 00 00       	call   80104610 <release>
      return -1;
801040f0:	83 c4 10             	add    $0x10,%esp
801040f3:	eb e0                	jmp    801040d5 <wait+0xd5>
801040f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104100 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 10             	sub    $0x10,%esp
8010410b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010410e:	68 20 2d 11 80       	push   $0x80112d20
80104113:	e8 c8 03 00 00       	call   801044e0 <acquire>
80104118:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104120:	eb 10                	jmp    80104132 <wakeup+0x32>
80104122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104128:	83 e8 80             	sub    $0xffffff80,%eax
8010412b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104130:	74 1c                	je     8010414e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104132:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104136:	75 f0                	jne    80104128 <wakeup+0x28>
80104138:	3b 58 20             	cmp    0x20(%eax),%ebx
8010413b:	75 eb                	jne    80104128 <wakeup+0x28>
      p->state = RUNNABLE;
8010413d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104144:	83 e8 80             	sub    $0xffffff80,%eax
80104147:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
8010414c:	75 e4                	jne    80104132 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010414e:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104158:	c9                   	leave  
  release(&ptable.lock);
80104159:	e9 b2 04 00 00       	jmp    80104610 <release>
8010415e:	66 90                	xchg   %ax,%ax

80104160 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104160:	f3 0f 1e fb          	endbr32 
80104164:	55                   	push   %ebp
80104165:	89 e5                	mov    %esp,%ebp
80104167:	53                   	push   %ebx
80104168:	83 ec 10             	sub    $0x10,%esp
8010416b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010416e:	68 20 2d 11 80       	push   $0x80112d20
80104173:	e8 68 03 00 00       	call   801044e0 <acquire>
80104178:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010417b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104180:	eb 10                	jmp    80104192 <kill+0x32>
80104182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104188:	83 e8 80             	sub    $0xffffff80,%eax
8010418b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104190:	74 36                	je     801041c8 <kill+0x68>
    if(p->pid == pid){
80104192:	39 58 10             	cmp    %ebx,0x10(%eax)
80104195:	75 f1                	jne    80104188 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104197:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010419b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041a2:	75 07                	jne    801041ab <kill+0x4b>
        p->state = RUNNABLE;
801041a4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041ab:	83 ec 0c             	sub    $0xc,%esp
801041ae:	68 20 2d 11 80       	push   $0x80112d20
801041b3:	e8 58 04 00 00       	call   80104610 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	31 c0                	xor    %eax,%eax
}
801041c0:	c9                   	leave  
801041c1:	c3                   	ret    
801041c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	68 20 2d 11 80       	push   $0x80112d20
801041d0:	e8 3b 04 00 00       	call   80104610 <release>
}
801041d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041d8:	83 c4 10             	add    $0x10,%esp
801041db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041e0:	c9                   	leave  
801041e1:	c3                   	ret    
801041e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	57                   	push   %edi
801041f8:	56                   	push   %esi
801041f9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041fc:	53                   	push   %ebx
801041fd:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104202:	83 ec 3c             	sub    $0x3c,%esp
80104205:	eb 28                	jmp    8010422f <procdump+0x3f>
80104207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	68 ff 7c 10 80       	push   $0x80107cff
80104218:	e8 93 c4 ff ff       	call   801006b0 <cprintf>
8010421d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104220:	83 eb 80             	sub    $0xffffff80,%ebx
80104223:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80104229:	0f 84 81 00 00 00    	je     801042b0 <procdump+0xc0>
    if(p->state == UNUSED)
8010422f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104232:	85 c0                	test   %eax,%eax
80104234:	74 ea                	je     80104220 <procdump+0x30>
      state = "???";
80104236:	ba 2b 79 10 80       	mov    $0x8010792b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010423b:	83 f8 05             	cmp    $0x5,%eax
8010423e:	77 11                	ja     80104251 <procdump+0x61>
80104240:	8b 14 85 8c 79 10 80 	mov    -0x7fef8674(,%eax,4),%edx
      state = "???";
80104247:	b8 2b 79 10 80       	mov    $0x8010792b,%eax
8010424c:	85 d2                	test   %edx,%edx
8010424e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104251:	53                   	push   %ebx
80104252:	52                   	push   %edx
80104253:	ff 73 a4             	pushl  -0x5c(%ebx)
80104256:	68 2f 79 10 80       	push   $0x8010792f
8010425b:	e8 50 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104260:	83 c4 10             	add    $0x10,%esp
80104263:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104267:	75 a7                	jne    80104210 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104269:	83 ec 08             	sub    $0x8,%esp
8010426c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010426f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104272:	50                   	push   %eax
80104273:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104276:	8b 40 0c             	mov    0xc(%eax),%eax
80104279:	83 c0 08             	add    $0x8,%eax
8010427c:	50                   	push   %eax
8010427d:	e8 6e 01 00 00       	call   801043f0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104282:	83 c4 10             	add    $0x10,%esp
80104285:	8d 76 00             	lea    0x0(%esi),%esi
80104288:	8b 17                	mov    (%edi),%edx
8010428a:	85 d2                	test   %edx,%edx
8010428c:	74 82                	je     80104210 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010428e:	83 ec 08             	sub    $0x8,%esp
80104291:	83 c7 04             	add    $0x4,%edi
80104294:	52                   	push   %edx
80104295:	68 81 73 10 80       	push   $0x80107381
8010429a:	e8 11 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	39 fe                	cmp    %edi,%esi
801042a4:	75 e2                	jne    80104288 <procdump+0x98>
801042a6:	e9 65 ff ff ff       	jmp    80104210 <procdump+0x20>
801042ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042af:	90                   	nop
  }
}
801042b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b3:	5b                   	pop    %ebx
801042b4:	5e                   	pop    %esi
801042b5:	5f                   	pop    %edi
801042b6:	5d                   	pop    %ebp
801042b7:	c3                   	ret    
801042b8:	66 90                	xchg   %ax,%ax
801042ba:	66 90                	xchg   %ax,%ax
801042bc:	66 90                	xchg   %ax,%ax
801042be:	66 90                	xchg   %ax,%ax

801042c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042c0:	f3 0f 1e fb          	endbr32 
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	53                   	push   %ebx
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ce:	68 a4 79 10 80       	push   $0x801079a4
801042d3:	8d 43 04             	lea    0x4(%ebx),%eax
801042d6:	50                   	push   %eax
801042d7:	e8 f4 00 00 00       	call   801043d0 <initlock>
  lk->name = name;
801042dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f5:	c9                   	leave  
801042f6:	c3                   	ret    
801042f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fe:	66 90                	xchg   %ax,%ax

80104300 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104300:	f3 0f 1e fb          	endbr32 
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	56                   	push   %esi
80104308:	53                   	push   %ebx
80104309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010430c:	8d 73 04             	lea    0x4(%ebx),%esi
8010430f:	83 ec 0c             	sub    $0xc,%esp
80104312:	56                   	push   %esi
80104313:	e8 c8 01 00 00       	call   801044e0 <acquire>
  while (lk->locked) {
80104318:	8b 13                	mov    (%ebx),%edx
8010431a:	83 c4 10             	add    $0x10,%esp
8010431d:	85 d2                	test   %edx,%edx
8010431f:	74 1a                	je     8010433b <acquiresleep+0x3b>
80104321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104328:	83 ec 08             	sub    $0x8,%esp
8010432b:	56                   	push   %esi
8010432c:	53                   	push   %ebx
8010432d:	e8 0e fc ff ff       	call   80103f40 <sleep>
  while (lk->locked) {
80104332:	8b 03                	mov    (%ebx),%eax
80104334:	83 c4 10             	add    $0x10,%esp
80104337:	85 c0                	test   %eax,%eax
80104339:	75 ed                	jne    80104328 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010433b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104341:	e8 2a f6 ff ff       	call   80103970 <myproc>
80104346:	8b 40 10             	mov    0x10(%eax),%eax
80104349:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010434c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010434f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104352:	5b                   	pop    %ebx
80104353:	5e                   	pop    %esi
80104354:	5d                   	pop    %ebp
  release(&lk->lk);
80104355:	e9 b6 02 00 00       	jmp    80104610 <release>
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104360 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104360:	f3 0f 1e fb          	endbr32 
80104364:	55                   	push   %ebp
80104365:	89 e5                	mov    %esp,%ebp
80104367:	56                   	push   %esi
80104368:	53                   	push   %ebx
80104369:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010436c:	8d 73 04             	lea    0x4(%ebx),%esi
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	56                   	push   %esi
80104373:	e8 68 01 00 00       	call   801044e0 <acquire>
  lk->locked = 0;
80104378:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010437e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104385:	89 1c 24             	mov    %ebx,(%esp)
80104388:	e8 73 fd ff ff       	call   80104100 <wakeup>
  release(&lk->lk);
8010438d:	89 75 08             	mov    %esi,0x8(%ebp)
80104390:	83 c4 10             	add    $0x10,%esp
}
80104393:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104396:	5b                   	pop    %ebx
80104397:	5e                   	pop    %esi
80104398:	5d                   	pop    %ebp
  release(&lk->lk);
80104399:	e9 72 02 00 00       	jmp    80104610 <release>
8010439e:	66 90                	xchg   %ax,%ax

801043a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	56                   	push   %esi
801043a8:	53                   	push   %ebx
801043a9:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801043ac:	8d 5e 04             	lea    0x4(%esi),%ebx
801043af:	83 ec 0c             	sub    $0xc,%esp
801043b2:	53                   	push   %ebx
801043b3:	e8 28 01 00 00       	call   801044e0 <acquire>
  r = lk->locked;
801043b8:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801043ba:	89 1c 24             	mov    %ebx,(%esp)
801043bd:	e8 4e 02 00 00       	call   80104610 <release>
  return r;
}
801043c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c5:	89 f0                	mov    %esi,%eax
801043c7:	5b                   	pop    %ebx
801043c8:	5e                   	pop    %esi
801043c9:	5d                   	pop    %ebp
801043ca:	c3                   	ret    
801043cb:	66 90                	xchg   %ax,%ax
801043cd:	66 90                	xchg   %ax,%ax
801043cf:	90                   	nop

801043d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043d0:	f3 0f 1e fb          	endbr32 
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
801043d7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043da:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043e3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043ed:	5d                   	pop    %ebp
801043ee:	c3                   	ret    
801043ef:	90                   	nop

801043f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043f0:	f3 0f 1e fb          	endbr32 
801043f4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043f5:	31 d2                	xor    %edx,%edx
{
801043f7:	89 e5                	mov    %esp,%ebp
801043f9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043fa:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104400:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104407:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104408:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010440e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104414:	77 1a                	ja     80104430 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104416:	8b 58 04             	mov    0x4(%eax),%ebx
80104419:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010441c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010441f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104421:	83 fa 0a             	cmp    $0xa,%edx
80104424:	75 e2                	jne    80104408 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104426:	5b                   	pop    %ebx
80104427:	5d                   	pop    %ebp
80104428:	c3                   	ret    
80104429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104430:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104433:	8d 51 28             	lea    0x28(%ecx),%edx
80104436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010443d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104446:	83 c0 04             	add    $0x4,%eax
80104449:	39 d0                	cmp    %edx,%eax
8010444b:	75 f3                	jne    80104440 <getcallerpcs+0x50>
}
8010444d:	5b                   	pop    %ebx
8010444e:	5d                   	pop    %ebp
8010444f:	c3                   	ret    

80104450 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104450:	f3 0f 1e fb          	endbr32 
80104454:	55                   	push   %ebp
80104455:	89 e5                	mov    %esp,%ebp
80104457:	53                   	push   %ebx
80104458:	83 ec 04             	sub    $0x4,%esp
8010445b:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010445e:	8b 02                	mov    (%edx),%eax
80104460:	85 c0                	test   %eax,%eax
80104462:	75 0c                	jne    80104470 <holding+0x20>
}
80104464:	83 c4 04             	add    $0x4,%esp
80104467:	31 c0                	xor    %eax,%eax
80104469:	5b                   	pop    %ebx
8010446a:	5d                   	pop    %ebp
8010446b:	c3                   	ret    
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104470:	8b 5a 08             	mov    0x8(%edx),%ebx
80104473:	e8 68 f4 ff ff       	call   801038e0 <mycpu>
80104478:	39 c3                	cmp    %eax,%ebx
8010447a:	0f 94 c0             	sete   %al
}
8010447d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104480:	0f b6 c0             	movzbl %al,%eax
}
80104483:	5b                   	pop    %ebx
80104484:	5d                   	pop    %ebp
80104485:	c3                   	ret    
80104486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448d:	8d 76 00             	lea    0x0(%esi),%esi

80104490 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104490:	f3 0f 1e fb          	endbr32 
80104494:	55                   	push   %ebp
80104495:	89 e5                	mov    %esp,%ebp
80104497:	53                   	push   %ebx
80104498:	83 ec 04             	sub    $0x4,%esp
8010449b:	9c                   	pushf  
8010449c:	5b                   	pop    %ebx
  asm volatile("cli");
8010449d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010449e:	e8 3d f4 ff ff       	call   801038e0 <mycpu>
801044a3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044a9:	85 c0                	test   %eax,%eax
801044ab:	74 13                	je     801044c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044ad:	e8 2e f4 ff ff       	call   801038e0 <mycpu>
801044b2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044b9:	83 c4 04             	add    $0x4,%esp
801044bc:	5b                   	pop    %ebx
801044bd:	5d                   	pop    %ebp
801044be:	c3                   	ret    
801044bf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044c0:	e8 1b f4 ff ff       	call   801038e0 <mycpu>
801044c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044d1:	eb da                	jmp    801044ad <pushcli+0x1d>
801044d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <acquire>:
{
801044e0:	f3 0f 1e fb          	endbr32 
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
801044e7:	56                   	push   %esi
801044e8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801044e9:	e8 a2 ff ff ff       	call   80104490 <pushcli>
  if(holding(lk))
801044ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801044f1:	8b 03                	mov    (%ebx),%eax
801044f3:	85 c0                	test   %eax,%eax
801044f5:	0f 85 8d 00 00 00    	jne    80104588 <acquire+0xa8>
  asm volatile("lock; xchgl %0, %1" :
801044fb:	ba 01 00 00 00       	mov    $0x1,%edx
80104500:	eb 09                	jmp    8010450b <acquire+0x2b>
80104502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104508:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010450b:	89 d0                	mov    %edx,%eax
8010450d:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104510:	85 c0                	test   %eax,%eax
80104512:	75 f4                	jne    80104508 <acquire+0x28>
  __sync_synchronize();
80104514:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010451c:	e8 bf f3 ff ff       	call   801038e0 <mycpu>
  ebp = (uint*)v - 2;
80104521:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104523:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104526:	31 c0                	xor    %eax,%eax
80104528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104530:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104536:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
8010453c:	77 22                	ja     80104560 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010453e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104541:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104545:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104548:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010454a:	83 f8 0a             	cmp    $0xa,%eax
8010454d:	75 e1                	jne    80104530 <acquire+0x50>
}
8010454f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104552:	5b                   	pop    %ebx
80104553:	5e                   	pop    %esi
80104554:	5d                   	pop    %ebp
80104555:	c3                   	ret    
80104556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104560:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104564:	83 c3 34             	add    $0x34,%ebx
80104567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104576:	83 c0 04             	add    $0x4,%eax
80104579:	39 d8                	cmp    %ebx,%eax
8010457b:	75 f3                	jne    80104570 <acquire+0x90>
}
8010457d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104580:	5b                   	pop    %ebx
80104581:	5e                   	pop    %esi
80104582:	5d                   	pop    %ebp
80104583:	c3                   	ret    
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104588:	8b 73 08             	mov    0x8(%ebx),%esi
8010458b:	e8 50 f3 ff ff       	call   801038e0 <mycpu>
80104590:	39 c6                	cmp    %eax,%esi
80104592:	0f 85 63 ff ff ff    	jne    801044fb <acquire+0x1b>
    panic("acquire");
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	68 af 79 10 80       	push   $0x801079af
801045a0:	e8 eb bd ff ff       	call   80100390 <panic>
801045a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <popcli>:

void
popcli(void)
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045ba:	9c                   	pushf  
801045bb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045bc:	f6 c4 02             	test   $0x2,%ah
801045bf:	75 31                	jne    801045f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045c1:	e8 1a f3 ff ff       	call   801038e0 <mycpu>
801045c6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045cd:	78 30                	js     801045ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045cf:	e8 0c f3 ff ff       	call   801038e0 <mycpu>
801045d4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045da:	85 d2                	test   %edx,%edx
801045dc:	74 02                	je     801045e0 <popcli+0x30>
    sti();
}
801045de:	c9                   	leave  
801045df:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045e0:	e8 fb f2 ff ff       	call   801038e0 <mycpu>
801045e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045eb:	85 c0                	test   %eax,%eax
801045ed:	74 ef                	je     801045de <popcli+0x2e>
  asm volatile("sti");
801045ef:	fb                   	sti    
}
801045f0:	c9                   	leave  
801045f1:	c3                   	ret    
    panic("popcli - interruptible");
801045f2:	83 ec 0c             	sub    $0xc,%esp
801045f5:	68 b7 79 10 80       	push   $0x801079b7
801045fa:	e8 91 bd ff ff       	call   80100390 <panic>
    panic("popcli");
801045ff:	83 ec 0c             	sub    $0xc,%esp
80104602:	68 ce 79 10 80       	push   $0x801079ce
80104607:	e8 84 bd ff ff       	call   80100390 <panic>
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104610 <release>:
{
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	56                   	push   %esi
80104618:	53                   	push   %ebx
80104619:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010461c:	8b 03                	mov    (%ebx),%eax
8010461e:	85 c0                	test   %eax,%eax
80104620:	75 0e                	jne    80104630 <release+0x20>
    panic("release");
80104622:	83 ec 0c             	sub    $0xc,%esp
80104625:	68 d5 79 10 80       	push   $0x801079d5
8010462a:	e8 61 bd ff ff       	call   80100390 <panic>
8010462f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104630:	8b 73 08             	mov    0x8(%ebx),%esi
80104633:	e8 a8 f2 ff ff       	call   801038e0 <mycpu>
80104638:	39 c6                	cmp    %eax,%esi
8010463a:	75 e6                	jne    80104622 <release+0x12>
  lk->pcs[0] = 0;
8010463c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104643:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010464a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010464f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104655:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104658:	5b                   	pop    %ebx
80104659:	5e                   	pop    %esi
8010465a:	5d                   	pop    %ebp
  popcli();
8010465b:	e9 50 ff ff ff       	jmp    801045b0 <popcli>

80104660 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104660:	f3 0f 1e fb          	endbr32 
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	57                   	push   %edi
80104668:	8b 55 08             	mov    0x8(%ebp),%edx
8010466b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010466e:	53                   	push   %ebx
8010466f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104672:	89 d7                	mov    %edx,%edi
80104674:	09 cf                	or     %ecx,%edi
80104676:	83 e7 03             	and    $0x3,%edi
80104679:	75 25                	jne    801046a0 <memset+0x40>
    c &= 0xFF;
8010467b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010467e:	c1 e0 18             	shl    $0x18,%eax
80104681:	89 fb                	mov    %edi,%ebx
80104683:	c1 e9 02             	shr    $0x2,%ecx
80104686:	c1 e3 10             	shl    $0x10,%ebx
80104689:	09 d8                	or     %ebx,%eax
8010468b:	09 f8                	or     %edi,%eax
8010468d:	c1 e7 08             	shl    $0x8,%edi
80104690:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104692:	89 d7                	mov    %edx,%edi
80104694:	fc                   	cld    
80104695:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104697:	5b                   	pop    %ebx
80104698:	89 d0                	mov    %edx,%eax
8010469a:	5f                   	pop    %edi
8010469b:	5d                   	pop    %ebp
8010469c:	c3                   	ret    
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801046a0:	89 d7                	mov    %edx,%edi
801046a2:	fc                   	cld    
801046a3:	f3 aa                	rep stos %al,%es:(%edi)
801046a5:	5b                   	pop    %ebx
801046a6:	89 d0                	mov    %edx,%eax
801046a8:	5f                   	pop    %edi
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    
801046ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046af:	90                   	nop

801046b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046b0:	f3 0f 1e fb          	endbr32 
801046b4:	55                   	push   %ebp
801046b5:	89 e5                	mov    %esp,%ebp
801046b7:	56                   	push   %esi
801046b8:	8b 75 10             	mov    0x10(%ebp),%esi
801046bb:	8b 55 08             	mov    0x8(%ebp),%edx
801046be:	53                   	push   %ebx
801046bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046c2:	85 f6                	test   %esi,%esi
801046c4:	74 2a                	je     801046f0 <memcmp+0x40>
801046c6:	01 c6                	add    %eax,%esi
801046c8:	eb 10                	jmp    801046da <memcmp+0x2a>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801046d0:	83 c0 01             	add    $0x1,%eax
801046d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801046d6:	39 f0                	cmp    %esi,%eax
801046d8:	74 16                	je     801046f0 <memcmp+0x40>
    if(*s1 != *s2)
801046da:	0f b6 0a             	movzbl (%edx),%ecx
801046dd:	0f b6 18             	movzbl (%eax),%ebx
801046e0:	38 d9                	cmp    %bl,%cl
801046e2:	74 ec                	je     801046d0 <memcmp+0x20>
      return *s1 - *s2;
801046e4:	0f b6 c1             	movzbl %cl,%eax
801046e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801046e9:	5b                   	pop    %ebx
801046ea:	5e                   	pop    %esi
801046eb:	5d                   	pop    %ebp
801046ec:	c3                   	ret    
801046ed:	8d 76 00             	lea    0x0(%esi),%esi
801046f0:	5b                   	pop    %ebx
  return 0;
801046f1:	31 c0                	xor    %eax,%eax
}
801046f3:	5e                   	pop    %esi
801046f4:	5d                   	pop    %ebp
801046f5:	c3                   	ret    
801046f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fd:	8d 76 00             	lea    0x0(%esi),%esi

80104700 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104700:	f3 0f 1e fb          	endbr32 
80104704:	55                   	push   %ebp
80104705:	89 e5                	mov    %esp,%ebp
80104707:	57                   	push   %edi
80104708:	8b 55 08             	mov    0x8(%ebp),%edx
8010470b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010470e:	56                   	push   %esi
8010470f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104712:	39 d6                	cmp    %edx,%esi
80104714:	73 2a                	jae    80104740 <memmove+0x40>
80104716:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104719:	39 fa                	cmp    %edi,%edx
8010471b:	73 23                	jae    80104740 <memmove+0x40>
8010471d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104720:	85 c9                	test   %ecx,%ecx
80104722:	74 13                	je     80104737 <memmove+0x37>
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104728:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010472c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010472f:	83 e8 01             	sub    $0x1,%eax
80104732:	83 f8 ff             	cmp    $0xffffffff,%eax
80104735:	75 f1                	jne    80104728 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104737:	5e                   	pop    %esi
80104738:	89 d0                	mov    %edx,%eax
8010473a:	5f                   	pop    %edi
8010473b:	5d                   	pop    %ebp
8010473c:	c3                   	ret    
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104740:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104743:	89 d7                	mov    %edx,%edi
80104745:	85 c9                	test   %ecx,%ecx
80104747:	74 ee                	je     80104737 <memmove+0x37>
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104750:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104751:	39 f0                	cmp    %esi,%eax
80104753:	75 fb                	jne    80104750 <memmove+0x50>
}
80104755:	5e                   	pop    %esi
80104756:	89 d0                	mov    %edx,%eax
80104758:	5f                   	pop    %edi
80104759:	5d                   	pop    %ebp
8010475a:	c3                   	ret    
8010475b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop

80104760 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104760:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104764:	eb 9a                	jmp    80104700 <memmove>
80104766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	56                   	push   %esi
80104778:	8b 75 10             	mov    0x10(%ebp),%esi
8010477b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010477e:	53                   	push   %ebx
8010477f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104782:	85 f6                	test   %esi,%esi
80104784:	74 32                	je     801047b8 <strncmp+0x48>
80104786:	01 c6                	add    %eax,%esi
80104788:	eb 14                	jmp    8010479e <strncmp+0x2e>
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104790:	38 da                	cmp    %bl,%dl
80104792:	75 14                	jne    801047a8 <strncmp+0x38>
    n--, p++, q++;
80104794:	83 c0 01             	add    $0x1,%eax
80104797:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010479a:	39 f0                	cmp    %esi,%eax
8010479c:	74 1a                	je     801047b8 <strncmp+0x48>
8010479e:	0f b6 11             	movzbl (%ecx),%edx
801047a1:	0f b6 18             	movzbl (%eax),%ebx
801047a4:	84 d2                	test   %dl,%dl
801047a6:	75 e8                	jne    80104790 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047a8:	0f b6 c2             	movzbl %dl,%eax
801047ab:	29 d8                	sub    %ebx,%eax
}
801047ad:	5b                   	pop    %ebx
801047ae:	5e                   	pop    %esi
801047af:	5d                   	pop    %ebp
801047b0:	c3                   	ret    
801047b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b8:	5b                   	pop    %ebx
    return 0;
801047b9:	31 c0                	xor    %eax,%eax
}
801047bb:	5e                   	pop    %esi
801047bc:	5d                   	pop    %ebp
801047bd:	c3                   	ret    
801047be:	66 90                	xchg   %ax,%ax

801047c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	57                   	push   %edi
801047c8:	56                   	push   %esi
801047c9:	8b 75 08             	mov    0x8(%ebp),%esi
801047cc:	53                   	push   %ebx
801047cd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047d0:	89 f2                	mov    %esi,%edx
801047d2:	eb 1b                	jmp    801047ef <strncpy+0x2f>
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801047dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801047df:	83 c2 01             	add    $0x1,%edx
801047e2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801047e6:	89 f9                	mov    %edi,%ecx
801047e8:	88 4a ff             	mov    %cl,-0x1(%edx)
801047eb:	84 c9                	test   %cl,%cl
801047ed:	74 09                	je     801047f8 <strncpy+0x38>
801047ef:	89 c3                	mov    %eax,%ebx
801047f1:	83 e8 01             	sub    $0x1,%eax
801047f4:	85 db                	test   %ebx,%ebx
801047f6:	7f e0                	jg     801047d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801047f8:	89 d1                	mov    %edx,%ecx
801047fa:	85 c0                	test   %eax,%eax
801047fc:	7e 15                	jle    80104813 <strncpy+0x53>
801047fe:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104800:	83 c1 01             	add    $0x1,%ecx
80104803:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104807:	89 c8                	mov    %ecx,%eax
80104809:	f7 d0                	not    %eax
8010480b:	01 d0                	add    %edx,%eax
8010480d:	01 d8                	add    %ebx,%eax
8010480f:	85 c0                	test   %eax,%eax
80104811:	7f ed                	jg     80104800 <strncpy+0x40>
  return os;
}
80104813:	5b                   	pop    %ebx
80104814:	89 f0                	mov    %esi,%eax
80104816:	5e                   	pop    %esi
80104817:	5f                   	pop    %edi
80104818:	5d                   	pop    %ebp
80104819:	c3                   	ret    
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104820 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	56                   	push   %esi
80104828:	8b 55 10             	mov    0x10(%ebp),%edx
8010482b:	8b 75 08             	mov    0x8(%ebp),%esi
8010482e:	53                   	push   %ebx
8010482f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104832:	85 d2                	test   %edx,%edx
80104834:	7e 21                	jle    80104857 <safestrcpy+0x37>
80104836:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010483a:	89 f2                	mov    %esi,%edx
8010483c:	eb 12                	jmp    80104850 <safestrcpy+0x30>
8010483e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104840:	0f b6 08             	movzbl (%eax),%ecx
80104843:	83 c0 01             	add    $0x1,%eax
80104846:	83 c2 01             	add    $0x1,%edx
80104849:	88 4a ff             	mov    %cl,-0x1(%edx)
8010484c:	84 c9                	test   %cl,%cl
8010484e:	74 04                	je     80104854 <safestrcpy+0x34>
80104850:	39 d8                	cmp    %ebx,%eax
80104852:	75 ec                	jne    80104840 <safestrcpy+0x20>
    ;
  *s = 0;
80104854:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104857:	89 f0                	mov    %esi,%eax
80104859:	5b                   	pop    %ebx
8010485a:	5e                   	pop    %esi
8010485b:	5d                   	pop    %ebp
8010485c:	c3                   	ret    
8010485d:	8d 76 00             	lea    0x0(%esi),%esi

80104860 <strlen>:

int
strlen(const char *s)
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104865:	31 c0                	xor    %eax,%eax
{
80104867:	89 e5                	mov    %esp,%ebp
80104869:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010486c:	80 3a 00             	cmpb   $0x0,(%edx)
8010486f:	74 10                	je     80104881 <strlen+0x21>
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104878:	83 c0 01             	add    $0x1,%eax
8010487b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010487f:	75 f7                	jne    80104878 <strlen+0x18>
    ;
  return n;
}
80104881:	5d                   	pop    %ebp
80104882:	c3                   	ret    

80104883 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104883:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104887:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010488b:	55                   	push   %ebp
  pushl %ebx
8010488c:	53                   	push   %ebx
  pushl %esi
8010488d:	56                   	push   %esi
  pushl %edi
8010488e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010488f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104891:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104893:	5f                   	pop    %edi
  popl %esi
80104894:	5e                   	pop    %esi
  popl %ebx
80104895:	5b                   	pop    %ebx
  popl %ebp
80104896:	5d                   	pop    %ebp
  ret
80104897:	c3                   	ret    
80104898:	66 90                	xchg   %ax,%ax
8010489a:	66 90                	xchg   %ax,%ax
8010489c:	66 90                	xchg   %ax,%ax
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	8b 45 08             	mov    0x8(%ebp),%eax
  // struct proc *curproc = myproc();

  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
801048aa:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801048af:	77 0f                	ja     801048c0 <fetchint+0x20>
    return -1;
  *ip = *(int*)(addr);
801048b1:	8b 10                	mov    (%eax),%edx
801048b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801048b6:	89 10                	mov    %edx,(%eax)
  return 0;
801048b8:	31 c0                	xor    %eax,%eax
}
801048ba:	5d                   	pop    %ebp
801048bb:	c3                   	ret    
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048c5:	5d                   	pop    %ebp
801048c6:	c3                   	ret    
801048c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp
801048d7:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;
  // struct proc *curproc = myproc();

  if(addr >= (KERNBASE-1))
801048da:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801048e0:	77 26                	ja     80104908 <fetchstr+0x38>
    return -1;
  *pp = (char*)addr;
801048e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801048e5:	89 10                	mov    %edx,(%eax)
  ep = (char*)(KERNBASE-1);
  for(s = *pp; s < ep; s++){
801048e7:	89 d0                	mov    %edx,%eax
801048e9:	eb 0f                	jmp    801048fa <fetchstr+0x2a>
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop
801048f0:	83 c0 01             	add    $0x1,%eax
801048f3:	3d ff ff ff 7f       	cmp    $0x7fffffff,%eax
801048f8:	74 0e                	je     80104908 <fetchstr+0x38>
    if(*s == 0)
801048fa:	80 38 00             	cmpb   $0x0,(%eax)
801048fd:	75 f1                	jne    801048f0 <fetchstr+0x20>
      return s - *pp;
801048ff:	29 d0                	sub    %edx,%eax
  }
  return -1;
}
80104901:	5d                   	pop    %ebp
80104902:	c3                   	ret    
80104903:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104907:	90                   	nop
    return -1;
80104908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010490d:	5d                   	pop    %ebp
8010490e:	c3                   	ret    
8010490f:	90                   	nop

80104910 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010491a:	e8 51 f0 ff ff       	call   80103970 <myproc>
8010491f:	8b 55 08             	mov    0x8(%ebp),%edx
80104922:	8b 40 18             	mov    0x18(%eax),%eax
80104925:	8b 40 44             	mov    0x44(%eax),%eax
80104928:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
8010492c:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
80104931:	77 0d                	ja     80104940 <argint+0x30>
  *ip = *(int*)(addr);
80104933:	8b 10                	mov    (%eax),%edx
80104935:	8b 45 0c             	mov    0xc(%ebp),%eax
80104938:	89 10                	mov    %edx,(%eax)
  return 0;
8010493a:	31 c0                	xor    %eax,%eax
}
8010493c:	c9                   	leave  
8010493d:	c3                   	ret    
8010493e:	66 90                	xchg   %ax,%ax
80104940:	c9                   	leave  
    return -1;
80104941:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104946:	c3                   	ret    
80104947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494e:	66 90                	xchg   %ax,%ax

80104950 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	53                   	push   %ebx
80104958:	83 ec 04             	sub    $0x4,%esp
8010495b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010495e:	e8 0d f0 ff ff       	call   80103970 <myproc>
80104963:	8b 55 08             	mov    0x8(%ebp),%edx
80104966:	8b 40 18             	mov    0x18(%eax),%eax
80104969:	8b 40 44             	mov    0x44(%eax),%eax
8010496c:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
80104970:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
80104975:	77 21                	ja     80104998 <argptr+0x48>
  *ip = *(int*)(addr);
80104977:	8b 00                	mov    (%eax),%eax
  int i;
  // struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= (KERNBASE-1) || (uint)i+size > (KERNBASE-1))
80104979:	85 db                	test   %ebx,%ebx
8010497b:	78 1b                	js     80104998 <argptr+0x48>
8010497d:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104982:	77 14                	ja     80104998 <argptr+0x48>
80104984:	01 c3                	add    %eax,%ebx
80104986:	78 10                	js     80104998 <argptr+0x48>
    return -1;
  *pp = (char*)i;
80104988:	8b 55 0c             	mov    0xc(%ebp),%edx
8010498b:	89 02                	mov    %eax,(%edx)
  return 0;
8010498d:	31 c0                	xor    %eax,%eax
}
8010498f:	83 c4 04             	add    $0x4,%esp
80104992:	5b                   	pop    %ebx
80104993:	5d                   	pop    %ebp
80104994:	c3                   	ret    
80104995:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010499d:	eb f0                	jmp    8010498f <argptr+0x3f>
8010499f:	90                   	nop

801049a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049aa:	e8 c1 ef ff ff       	call   80103970 <myproc>
801049af:	8b 55 08             	mov    0x8(%ebp),%edx
801049b2:	8b 40 18             	mov    0x18(%eax),%eax
801049b5:	8b 40 44             	mov    0x44(%eax),%eax
801049b8:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
801049bc:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801049c1:	77 35                	ja     801049f8 <argstr+0x58>
  *ip = *(int*)(addr);
801049c3:	8b 10                	mov    (%eax),%edx
  if(addr >= (KERNBASE-1))
801049c5:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801049cb:	77 2b                	ja     801049f8 <argstr+0x58>
  *pp = (char*)addr;
801049cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801049d0:	89 10                	mov    %edx,(%eax)
  for(s = *pp; s < ep; s++){
801049d2:	81 fa ff ff ff 7f    	cmp    $0x7fffffff,%edx
801049d8:	74 1e                	je     801049f8 <argstr+0x58>
801049da:	89 d0                	mov    %edx,%eax
801049dc:	eb 0c                	jmp    801049ea <argstr+0x4a>
801049de:	66 90                	xchg   %ax,%ax
801049e0:	83 c0 01             	add    $0x1,%eax
801049e3:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801049e8:	77 0e                	ja     801049f8 <argstr+0x58>
    if(*s == 0)
801049ea:	80 38 00             	cmpb   $0x0,(%eax)
801049ed:	75 f1                	jne    801049e0 <argstr+0x40>
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801049ef:	c9                   	leave  
      return s - *pp;
801049f0:	29 d0                	sub    %edx,%eax
}
801049f2:	c3                   	ret    
801049f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049f7:	90                   	nop
801049f8:	c9                   	leave  
    return -1;
801049f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049fe:	c3                   	ret    
801049ff:	90                   	nop

80104a00 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	53                   	push   %ebx
80104a08:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a0b:	e8 60 ef ff ff       	call   80103970 <myproc>
80104a10:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a12:	8b 40 18             	mov    0x18(%eax),%eax
80104a15:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a18:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a1b:	83 fa 16             	cmp    $0x16,%edx
80104a1e:	77 20                	ja     80104a40 <syscall+0x40>
80104a20:	8b 14 85 00 7a 10 80 	mov    -0x7fef8600(,%eax,4),%edx
80104a27:	85 d2                	test   %edx,%edx
80104a29:	74 15                	je     80104a40 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a2b:	ff d2                	call   *%edx
80104a2d:	89 c2                	mov    %eax,%edx
80104a2f:	8b 43 18             	mov    0x18(%ebx),%eax
80104a32:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a38:	c9                   	leave  
80104a39:	c3                   	ret    
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a40:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a41:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a44:	50                   	push   %eax
80104a45:	ff 73 10             	pushl  0x10(%ebx)
80104a48:	68 dd 79 10 80       	push   $0x801079dd
80104a4d:	e8 5e bc ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104a52:	8b 43 18             	mov    0x18(%ebx),%eax
80104a55:	83 c4 10             	add    $0x10,%esp
80104a58:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    
80104a64:	66 90                	xchg   %ax,%ax
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a75:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104a78:	53                   	push   %ebx
80104a79:	83 ec 44             	sub    $0x44,%esp
80104a7c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a82:	57                   	push   %edi
80104a83:	50                   	push   %eax
{
80104a84:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a87:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a8a:	e8 c1 d5 ff ff       	call   80102050 <nameiparent>
80104a8f:	83 c4 10             	add    $0x10,%esp
80104a92:	85 c0                	test   %eax,%eax
80104a94:	0f 84 46 01 00 00    	je     80104be0 <create+0x170>
    return 0;
  ilock(dp);
80104a9a:	83 ec 0c             	sub    $0xc,%esp
80104a9d:	89 c3                	mov    %eax,%ebx
80104a9f:	50                   	push   %eax
80104aa0:	e8 bb cc ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104aa5:	83 c4 0c             	add    $0xc,%esp
80104aa8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104aab:	50                   	push   %eax
80104aac:	57                   	push   %edi
80104aad:	53                   	push   %ebx
80104aae:	e8 fd d1 ff ff       	call   80101cb0 <dirlookup>
80104ab3:	83 c4 10             	add    $0x10,%esp
80104ab6:	89 c6                	mov    %eax,%esi
80104ab8:	85 c0                	test   %eax,%eax
80104aba:	74 54                	je     80104b10 <create+0xa0>
    iunlockput(dp);
80104abc:	83 ec 0c             	sub    $0xc,%esp
80104abf:	53                   	push   %ebx
80104ac0:	e8 3b cf ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104ac5:	89 34 24             	mov    %esi,(%esp)
80104ac8:	e8 93 cc ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104acd:	83 c4 10             	add    $0x10,%esp
80104ad0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ad5:	75 19                	jne    80104af0 <create+0x80>
80104ad7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104adc:	75 12                	jne    80104af0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ae1:	89 f0                	mov    %esi,%eax
80104ae3:	5b                   	pop    %ebx
80104ae4:	5e                   	pop    %esi
80104ae5:	5f                   	pop    %edi
80104ae6:	5d                   	pop    %ebp
80104ae7:	c3                   	ret    
80104ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aef:	90                   	nop
    iunlockput(ip);
80104af0:	83 ec 0c             	sub    $0xc,%esp
80104af3:	56                   	push   %esi
    return 0;
80104af4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104af6:	e8 05 cf ff ff       	call   80101a00 <iunlockput>
    return 0;
80104afb:	83 c4 10             	add    $0x10,%esp
}
80104afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b01:	89 f0                	mov    %esi,%eax
80104b03:	5b                   	pop    %ebx
80104b04:	5e                   	pop    %esi
80104b05:	5f                   	pop    %edi
80104b06:	5d                   	pop    %ebp
80104b07:	c3                   	ret    
80104b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104b10:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b14:	83 ec 08             	sub    $0x8,%esp
80104b17:	50                   	push   %eax
80104b18:	ff 33                	pushl  (%ebx)
80104b1a:	e8 c1 ca ff ff       	call   801015e0 <ialloc>
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	89 c6                	mov    %eax,%esi
80104b24:	85 c0                	test   %eax,%eax
80104b26:	0f 84 cd 00 00 00    	je     80104bf9 <create+0x189>
  ilock(ip);
80104b2c:	83 ec 0c             	sub    $0xc,%esp
80104b2f:	50                   	push   %eax
80104b30:	e8 2b cc ff ff       	call   80101760 <ilock>
  ip->major = major;
80104b35:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b39:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b3d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b41:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104b45:	b8 01 00 00 00       	mov    $0x1,%eax
80104b4a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104b4e:	89 34 24             	mov    %esi,(%esp)
80104b51:	e8 4a cb ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b56:	83 c4 10             	add    $0x10,%esp
80104b59:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104b5e:	74 30                	je     80104b90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b60:	83 ec 04             	sub    $0x4,%esp
80104b63:	ff 76 04             	pushl  0x4(%esi)
80104b66:	57                   	push   %edi
80104b67:	53                   	push   %ebx
80104b68:	e8 03 d4 ff ff       	call   80101f70 <dirlink>
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	85 c0                	test   %eax,%eax
80104b72:	78 78                	js     80104bec <create+0x17c>
  iunlockput(dp);
80104b74:	83 ec 0c             	sub    $0xc,%esp
80104b77:	53                   	push   %ebx
80104b78:	e8 83 ce ff ff       	call   80101a00 <iunlockput>
  return ip;
80104b7d:	83 c4 10             	add    $0x10,%esp
}
80104b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b83:	89 f0                	mov    %esi,%eax
80104b85:	5b                   	pop    %ebx
80104b86:	5e                   	pop    %esi
80104b87:	5f                   	pop    %edi
80104b88:	5d                   	pop    %ebp
80104b89:	c3                   	ret    
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b93:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b98:	53                   	push   %ebx
80104b99:	e8 02 cb ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b9e:	83 c4 0c             	add    $0xc,%esp
80104ba1:	ff 76 04             	pushl  0x4(%esi)
80104ba4:	68 7c 7a 10 80       	push   $0x80107a7c
80104ba9:	56                   	push   %esi
80104baa:	e8 c1 d3 ff ff       	call   80101f70 <dirlink>
80104baf:	83 c4 10             	add    $0x10,%esp
80104bb2:	85 c0                	test   %eax,%eax
80104bb4:	78 18                	js     80104bce <create+0x15e>
80104bb6:	83 ec 04             	sub    $0x4,%esp
80104bb9:	ff 73 04             	pushl  0x4(%ebx)
80104bbc:	68 7b 7a 10 80       	push   $0x80107a7b
80104bc1:	56                   	push   %esi
80104bc2:	e8 a9 d3 ff ff       	call   80101f70 <dirlink>
80104bc7:	83 c4 10             	add    $0x10,%esp
80104bca:	85 c0                	test   %eax,%eax
80104bcc:	79 92                	jns    80104b60 <create+0xf0>
      panic("create dots");
80104bce:	83 ec 0c             	sub    $0xc,%esp
80104bd1:	68 6f 7a 10 80       	push   $0x80107a6f
80104bd6:	e8 b5 b7 ff ff       	call   80100390 <panic>
80104bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bdf:	90                   	nop
}
80104be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104be3:	31 f6                	xor    %esi,%esi
}
80104be5:	5b                   	pop    %ebx
80104be6:	89 f0                	mov    %esi,%eax
80104be8:	5e                   	pop    %esi
80104be9:	5f                   	pop    %edi
80104bea:	5d                   	pop    %ebp
80104beb:	c3                   	ret    
    panic("create: dirlink");
80104bec:	83 ec 0c             	sub    $0xc,%esp
80104bef:	68 7e 7a 10 80       	push   $0x80107a7e
80104bf4:	e8 97 b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104bf9:	83 ec 0c             	sub    $0xc,%esp
80104bfc:	68 60 7a 10 80       	push   $0x80107a60
80104c01:	e8 8a b7 ff ff       	call   80100390 <panic>
80104c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi

80104c10 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	89 d6                	mov    %edx,%esi
80104c16:	53                   	push   %ebx
80104c17:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104c1c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c1f:	50                   	push   %eax
80104c20:	6a 00                	push   $0x0
80104c22:	e8 e9 fc ff ff       	call   80104910 <argint>
80104c27:	83 c4 10             	add    $0x10,%esp
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	78 2a                	js     80104c58 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c2e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c32:	77 24                	ja     80104c58 <argfd.constprop.0+0x48>
80104c34:	e8 37 ed ff ff       	call   80103970 <myproc>
80104c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c3c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c40:	85 c0                	test   %eax,%eax
80104c42:	74 14                	je     80104c58 <argfd.constprop.0+0x48>
  if(pfd)
80104c44:	85 db                	test   %ebx,%ebx
80104c46:	74 02                	je     80104c4a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c48:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104c4a:	89 06                	mov    %eax,(%esi)
  return 0;
80104c4c:	31 c0                	xor    %eax,%eax
}
80104c4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c51:	5b                   	pop    %ebx
80104c52:	5e                   	pop    %esi
80104c53:	5d                   	pop    %ebp
80104c54:	c3                   	ret    
80104c55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c5d:	eb ef                	jmp    80104c4e <argfd.constprop.0+0x3e>
80104c5f:	90                   	nop

80104c60 <sys_dup>:
{
80104c60:	f3 0f 1e fb          	endbr32 
80104c64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c65:	31 c0                	xor    %eax,%eax
{
80104c67:	89 e5                	mov    %esp,%ebp
80104c69:	56                   	push   %esi
80104c6a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c6b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c6e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c71:	e8 9a ff ff ff       	call   80104c10 <argfd.constprop.0>
80104c76:	85 c0                	test   %eax,%eax
80104c78:	78 1e                	js     80104c98 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104c7a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c7d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c7f:	e8 ec ec ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104c88:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c8c:	85 d2                	test   %edx,%edx
80104c8e:	74 20                	je     80104cb0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104c90:	83 c3 01             	add    $0x1,%ebx
80104c93:	83 fb 10             	cmp    $0x10,%ebx
80104c96:	75 f0                	jne    80104c88 <sys_dup+0x28>
}
80104c98:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ca0:	89 d8                	mov    %ebx,%eax
80104ca2:	5b                   	pop    %ebx
80104ca3:	5e                   	pop    %esi
80104ca4:	5d                   	pop    %ebp
80104ca5:	c3                   	ret    
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104cb0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104cb4:	83 ec 0c             	sub    $0xc,%esp
80104cb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cba:	e8 b1 c1 ff ff       	call   80100e70 <filedup>
  return fd;
80104cbf:	83 c4 10             	add    $0x10,%esp
}
80104cc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc5:	89 d8                	mov    %ebx,%eax
80104cc7:	5b                   	pop    %ebx
80104cc8:	5e                   	pop    %esi
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
80104ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ccf:	90                   	nop

80104cd0 <sys_read>:
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cd5:	31 c0                	xor    %eax,%eax
{
80104cd7:	89 e5                	mov    %esp,%ebp
80104cd9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cdc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cdf:	e8 2c ff ff ff       	call   80104c10 <argfd.constprop.0>
80104ce4:	85 c0                	test   %eax,%eax
80104ce6:	78 48                	js     80104d30 <sys_read+0x60>
80104ce8:	83 ec 08             	sub    $0x8,%esp
80104ceb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cee:	50                   	push   %eax
80104cef:	6a 02                	push   $0x2
80104cf1:	e8 1a fc ff ff       	call   80104910 <argint>
80104cf6:	83 c4 10             	add    $0x10,%esp
80104cf9:	85 c0                	test   %eax,%eax
80104cfb:	78 33                	js     80104d30 <sys_read+0x60>
80104cfd:	83 ec 04             	sub    $0x4,%esp
80104d00:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d03:	ff 75 f0             	pushl  -0x10(%ebp)
80104d06:	50                   	push   %eax
80104d07:	6a 01                	push   $0x1
80104d09:	e8 42 fc ff ff       	call   80104950 <argptr>
80104d0e:	83 c4 10             	add    $0x10,%esp
80104d11:	85 c0                	test   %eax,%eax
80104d13:	78 1b                	js     80104d30 <sys_read+0x60>
  return fileread(f, p, n);
80104d15:	83 ec 04             	sub    $0x4,%esp
80104d18:	ff 75 f0             	pushl  -0x10(%ebp)
80104d1b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d1e:	ff 75 ec             	pushl  -0x14(%ebp)
80104d21:	e8 ca c2 ff ff       	call   80100ff0 <fileread>
80104d26:	83 c4 10             	add    $0x10,%esp
}
80104d29:	c9                   	leave  
80104d2a:	c3                   	ret    
80104d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d2f:	90                   	nop
80104d30:	c9                   	leave  
    return -1;
80104d31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d36:	c3                   	ret    
80104d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <sys_write>:
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d45:	31 c0                	xor    %eax,%eax
{
80104d47:	89 e5                	mov    %esp,%ebp
80104d49:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d4c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d4f:	e8 bc fe ff ff       	call   80104c10 <argfd.constprop.0>
80104d54:	85 c0                	test   %eax,%eax
80104d56:	78 48                	js     80104da0 <sys_write+0x60>
80104d58:	83 ec 08             	sub    $0x8,%esp
80104d5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d5e:	50                   	push   %eax
80104d5f:	6a 02                	push   $0x2
80104d61:	e8 aa fb ff ff       	call   80104910 <argint>
80104d66:	83 c4 10             	add    $0x10,%esp
80104d69:	85 c0                	test   %eax,%eax
80104d6b:	78 33                	js     80104da0 <sys_write+0x60>
80104d6d:	83 ec 04             	sub    $0x4,%esp
80104d70:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d73:	ff 75 f0             	pushl  -0x10(%ebp)
80104d76:	50                   	push   %eax
80104d77:	6a 01                	push   $0x1
80104d79:	e8 d2 fb ff ff       	call   80104950 <argptr>
80104d7e:	83 c4 10             	add    $0x10,%esp
80104d81:	85 c0                	test   %eax,%eax
80104d83:	78 1b                	js     80104da0 <sys_write+0x60>
  return filewrite(f, p, n);
80104d85:	83 ec 04             	sub    $0x4,%esp
80104d88:	ff 75 f0             	pushl  -0x10(%ebp)
80104d8b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d8e:	ff 75 ec             	pushl  -0x14(%ebp)
80104d91:	e8 fa c2 ff ff       	call   80101090 <filewrite>
80104d96:	83 c4 10             	add    $0x10,%esp
}
80104d99:	c9                   	leave  
80104d9a:	c3                   	ret    
80104d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop
80104da0:	c9                   	leave  
    return -1;
80104da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104da6:	c3                   	ret    
80104da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dae:	66 90                	xchg   %ax,%ax

80104db0 <sys_close>:
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104dba:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104dbd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dc0:	e8 4b fe ff ff       	call   80104c10 <argfd.constprop.0>
80104dc5:	85 c0                	test   %eax,%eax
80104dc7:	78 27                	js     80104df0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104dc9:	e8 a2 eb ff ff       	call   80103970 <myproc>
80104dce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104dd1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104dd4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ddb:	00 
  fileclose(f);
80104ddc:	ff 75 f4             	pushl  -0xc(%ebp)
80104ddf:	e8 dc c0 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104de4:	83 c4 10             	add    $0x10,%esp
80104de7:	31 c0                	xor    %eax,%eax
}
80104de9:	c9                   	leave  
80104dea:	c3                   	ret    
80104deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop
80104df0:	c9                   	leave  
    return -1;
80104df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df6:	c3                   	ret    
80104df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfe:	66 90                	xchg   %ax,%ax

80104e00 <sys_fstat>:
{
80104e00:	f3 0f 1e fb          	endbr32 
80104e04:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e05:	31 c0                	xor    %eax,%eax
{
80104e07:	89 e5                	mov    %esp,%ebp
80104e09:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e0c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e0f:	e8 fc fd ff ff       	call   80104c10 <argfd.constprop.0>
80104e14:	85 c0                	test   %eax,%eax
80104e16:	78 30                	js     80104e48 <sys_fstat+0x48>
80104e18:	83 ec 04             	sub    $0x4,%esp
80104e1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e1e:	6a 14                	push   $0x14
80104e20:	50                   	push   %eax
80104e21:	6a 01                	push   $0x1
80104e23:	e8 28 fb ff ff       	call   80104950 <argptr>
80104e28:	83 c4 10             	add    $0x10,%esp
80104e2b:	85 c0                	test   %eax,%eax
80104e2d:	78 19                	js     80104e48 <sys_fstat+0x48>
  return filestat(f, st);
80104e2f:	83 ec 08             	sub    $0x8,%esp
80104e32:	ff 75 f4             	pushl  -0xc(%ebp)
80104e35:	ff 75 f0             	pushl  -0x10(%ebp)
80104e38:	e8 63 c1 ff ff       	call   80100fa0 <filestat>
80104e3d:	83 c4 10             	add    $0x10,%esp
}
80104e40:	c9                   	leave  
80104e41:	c3                   	ret    
80104e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e48:	c9                   	leave  
    return -1;
80104e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e4e:	c3                   	ret    
80104e4f:	90                   	nop

80104e50 <sys_link>:
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	57                   	push   %edi
80104e58:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e59:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e5c:	53                   	push   %ebx
80104e5d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e60:	50                   	push   %eax
80104e61:	6a 00                	push   $0x0
80104e63:	e8 38 fb ff ff       	call   801049a0 <argstr>
80104e68:	83 c4 10             	add    $0x10,%esp
80104e6b:	85 c0                	test   %eax,%eax
80104e6d:	0f 88 ff 00 00 00    	js     80104f72 <sys_link+0x122>
80104e73:	83 ec 08             	sub    $0x8,%esp
80104e76:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e79:	50                   	push   %eax
80104e7a:	6a 01                	push   $0x1
80104e7c:	e8 1f fb ff ff       	call   801049a0 <argstr>
80104e81:	83 c4 10             	add    $0x10,%esp
80104e84:	85 c0                	test   %eax,%eax
80104e86:	0f 88 e6 00 00 00    	js     80104f72 <sys_link+0x122>
  begin_op();
80104e8c:	e8 9f de ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
80104e91:	83 ec 0c             	sub    $0xc,%esp
80104e94:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e97:	e8 94 d1 ff ff       	call   80102030 <namei>
80104e9c:	83 c4 10             	add    $0x10,%esp
80104e9f:	89 c3                	mov    %eax,%ebx
80104ea1:	85 c0                	test   %eax,%eax
80104ea3:	0f 84 e8 00 00 00    	je     80104f91 <sys_link+0x141>
  ilock(ip);
80104ea9:	83 ec 0c             	sub    $0xc,%esp
80104eac:	50                   	push   %eax
80104ead:	e8 ae c8 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80104eb2:	83 c4 10             	add    $0x10,%esp
80104eb5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eba:	0f 84 b9 00 00 00    	je     80104f79 <sys_link+0x129>
  iupdate(ip);
80104ec0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104ec3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104ec8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ecb:	53                   	push   %ebx
80104ecc:	e8 cf c7 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80104ed1:	89 1c 24             	mov    %ebx,(%esp)
80104ed4:	e8 67 c9 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ed9:	58                   	pop    %eax
80104eda:	5a                   	pop    %edx
80104edb:	57                   	push   %edi
80104edc:	ff 75 d0             	pushl  -0x30(%ebp)
80104edf:	e8 6c d1 ff ff       	call   80102050 <nameiparent>
80104ee4:	83 c4 10             	add    $0x10,%esp
80104ee7:	89 c6                	mov    %eax,%esi
80104ee9:	85 c0                	test   %eax,%eax
80104eeb:	74 5f                	je     80104f4c <sys_link+0xfc>
  ilock(dp);
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	50                   	push   %eax
80104ef1:	e8 6a c8 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ef6:	8b 03                	mov    (%ebx),%eax
80104ef8:	83 c4 10             	add    $0x10,%esp
80104efb:	39 06                	cmp    %eax,(%esi)
80104efd:	75 41                	jne    80104f40 <sys_link+0xf0>
80104eff:	83 ec 04             	sub    $0x4,%esp
80104f02:	ff 73 04             	pushl  0x4(%ebx)
80104f05:	57                   	push   %edi
80104f06:	56                   	push   %esi
80104f07:	e8 64 d0 ff ff       	call   80101f70 <dirlink>
80104f0c:	83 c4 10             	add    $0x10,%esp
80104f0f:	85 c0                	test   %eax,%eax
80104f11:	78 2d                	js     80104f40 <sys_link+0xf0>
  iunlockput(dp);
80104f13:	83 ec 0c             	sub    $0xc,%esp
80104f16:	56                   	push   %esi
80104f17:	e8 e4 ca ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80104f1c:	89 1c 24             	mov    %ebx,(%esp)
80104f1f:	e8 6c c9 ff ff       	call   80101890 <iput>
  end_op();
80104f24:	e8 77 de ff ff       	call   80102da0 <end_op>
  return 0;
80104f29:	83 c4 10             	add    $0x10,%esp
80104f2c:	31 c0                	xor    %eax,%eax
}
80104f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f31:	5b                   	pop    %ebx
80104f32:	5e                   	pop    %esi
80104f33:	5f                   	pop    %edi
80104f34:	5d                   	pop    %ebp
80104f35:	c3                   	ret    
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f40:	83 ec 0c             	sub    $0xc,%esp
80104f43:	56                   	push   %esi
80104f44:	e8 b7 ca ff ff       	call   80101a00 <iunlockput>
    goto bad;
80104f49:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	53                   	push   %ebx
80104f50:	e8 0b c8 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80104f55:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f5a:	89 1c 24             	mov    %ebx,(%esp)
80104f5d:	e8 3e c7 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80104f62:	89 1c 24             	mov    %ebx,(%esp)
80104f65:	e8 96 ca ff ff       	call   80101a00 <iunlockput>
  end_op();
80104f6a:	e8 31 de ff ff       	call   80102da0 <end_op>
  return -1;
80104f6f:	83 c4 10             	add    $0x10,%esp
80104f72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f77:	eb b5                	jmp    80104f2e <sys_link+0xde>
    iunlockput(ip);
80104f79:	83 ec 0c             	sub    $0xc,%esp
80104f7c:	53                   	push   %ebx
80104f7d:	e8 7e ca ff ff       	call   80101a00 <iunlockput>
    end_op();
80104f82:	e8 19 de ff ff       	call   80102da0 <end_op>
    return -1;
80104f87:	83 c4 10             	add    $0x10,%esp
80104f8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8f:	eb 9d                	jmp    80104f2e <sys_link+0xde>
    end_op();
80104f91:	e8 0a de ff ff       	call   80102da0 <end_op>
    return -1;
80104f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9b:	eb 91                	jmp    80104f2e <sys_link+0xde>
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <sys_unlink>:
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	57                   	push   %edi
80104fa8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104fa9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104fac:	53                   	push   %ebx
80104fad:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104fb0:	50                   	push   %eax
80104fb1:	6a 00                	push   $0x0
80104fb3:	e8 e8 f9 ff ff       	call   801049a0 <argstr>
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	0f 88 7d 01 00 00    	js     80105140 <sys_unlink+0x1a0>
  begin_op();
80104fc3:	e8 68 dd ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fc8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104fcb:	83 ec 08             	sub    $0x8,%esp
80104fce:	53                   	push   %ebx
80104fcf:	ff 75 c0             	pushl  -0x40(%ebp)
80104fd2:	e8 79 d0 ff ff       	call   80102050 <nameiparent>
80104fd7:	83 c4 10             	add    $0x10,%esp
80104fda:	89 c6                	mov    %eax,%esi
80104fdc:	85 c0                	test   %eax,%eax
80104fde:	0f 84 66 01 00 00    	je     8010514a <sys_unlink+0x1aa>
  ilock(dp);
80104fe4:	83 ec 0c             	sub    $0xc,%esp
80104fe7:	50                   	push   %eax
80104fe8:	e8 73 c7 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fed:	58                   	pop    %eax
80104fee:	5a                   	pop    %edx
80104fef:	68 7c 7a 10 80       	push   $0x80107a7c
80104ff4:	53                   	push   %ebx
80104ff5:	e8 96 cc ff ff       	call   80101c90 <namecmp>
80104ffa:	83 c4 10             	add    $0x10,%esp
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	0f 84 03 01 00 00    	je     80105108 <sys_unlink+0x168>
80105005:	83 ec 08             	sub    $0x8,%esp
80105008:	68 7b 7a 10 80       	push   $0x80107a7b
8010500d:	53                   	push   %ebx
8010500e:	e8 7d cc ff ff       	call   80101c90 <namecmp>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	0f 84 ea 00 00 00    	je     80105108 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010501e:	83 ec 04             	sub    $0x4,%esp
80105021:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105024:	50                   	push   %eax
80105025:	53                   	push   %ebx
80105026:	56                   	push   %esi
80105027:	e8 84 cc ff ff       	call   80101cb0 <dirlookup>
8010502c:	83 c4 10             	add    $0x10,%esp
8010502f:	89 c3                	mov    %eax,%ebx
80105031:	85 c0                	test   %eax,%eax
80105033:	0f 84 cf 00 00 00    	je     80105108 <sys_unlink+0x168>
  ilock(ip);
80105039:	83 ec 0c             	sub    $0xc,%esp
8010503c:	50                   	push   %eax
8010503d:	e8 1e c7 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105042:	83 c4 10             	add    $0x10,%esp
80105045:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010504a:	0f 8e 23 01 00 00    	jle    80105173 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105050:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105055:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105058:	74 66                	je     801050c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010505a:	83 ec 04             	sub    $0x4,%esp
8010505d:	6a 10                	push   $0x10
8010505f:	6a 00                	push   $0x0
80105061:	57                   	push   %edi
80105062:	e8 f9 f5 ff ff       	call   80104660 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105067:	6a 10                	push   $0x10
80105069:	ff 75 c4             	pushl  -0x3c(%ebp)
8010506c:	57                   	push   %edi
8010506d:	56                   	push   %esi
8010506e:	e8 ed ca ff ff       	call   80101b60 <writei>
80105073:	83 c4 20             	add    $0x20,%esp
80105076:	83 f8 10             	cmp    $0x10,%eax
80105079:	0f 85 e7 00 00 00    	jne    80105166 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010507f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105084:	0f 84 96 00 00 00    	je     80105120 <sys_unlink+0x180>
  iunlockput(dp);
8010508a:	83 ec 0c             	sub    $0xc,%esp
8010508d:	56                   	push   %esi
8010508e:	e8 6d c9 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105093:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105098:	89 1c 24             	mov    %ebx,(%esp)
8010509b:	e8 00 c6 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801050a0:	89 1c 24             	mov    %ebx,(%esp)
801050a3:	e8 58 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
801050a8:	e8 f3 dc ff ff       	call   80102da0 <end_op>
  return 0;
801050ad:	83 c4 10             	add    $0x10,%esp
801050b0:	31 c0                	xor    %eax,%eax
}
801050b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050b5:	5b                   	pop    %ebx
801050b6:	5e                   	pop    %esi
801050b7:	5f                   	pop    %edi
801050b8:	5d                   	pop    %ebp
801050b9:	c3                   	ret    
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050c4:	76 94                	jbe    8010505a <sys_unlink+0xba>
801050c6:	ba 20 00 00 00       	mov    $0x20,%edx
801050cb:	eb 0b                	jmp    801050d8 <sys_unlink+0x138>
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
801050d0:	83 c2 10             	add    $0x10,%edx
801050d3:	39 53 58             	cmp    %edx,0x58(%ebx)
801050d6:	76 82                	jbe    8010505a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050d8:	6a 10                	push   $0x10
801050da:	52                   	push   %edx
801050db:	57                   	push   %edi
801050dc:	53                   	push   %ebx
801050dd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801050e0:	e8 7b c9 ff ff       	call   80101a60 <readi>
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801050eb:	83 f8 10             	cmp    $0x10,%eax
801050ee:	75 69                	jne    80105159 <sys_unlink+0x1b9>
    if(de.inum != 0)
801050f0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050f5:	74 d9                	je     801050d0 <sys_unlink+0x130>
    iunlockput(ip);
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	53                   	push   %ebx
801050fb:	e8 00 c9 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105107:	90                   	nop
  iunlockput(dp);
80105108:	83 ec 0c             	sub    $0xc,%esp
8010510b:	56                   	push   %esi
8010510c:	e8 ef c8 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105111:	e8 8a dc ff ff       	call   80102da0 <end_op>
  return -1;
80105116:	83 c4 10             	add    $0x10,%esp
80105119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511e:	eb 92                	jmp    801050b2 <sys_unlink+0x112>
    iupdate(dp);
80105120:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105123:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105128:	56                   	push   %esi
80105129:	e8 72 c5 ff ff       	call   801016a0 <iupdate>
8010512e:	83 c4 10             	add    $0x10,%esp
80105131:	e9 54 ff ff ff       	jmp    8010508a <sys_unlink+0xea>
80105136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105145:	e9 68 ff ff ff       	jmp    801050b2 <sys_unlink+0x112>
    end_op();
8010514a:	e8 51 dc ff ff       	call   80102da0 <end_op>
    return -1;
8010514f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105154:	e9 59 ff ff ff       	jmp    801050b2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105159:	83 ec 0c             	sub    $0xc,%esp
8010515c:	68 a0 7a 10 80       	push   $0x80107aa0
80105161:	e8 2a b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105166:	83 ec 0c             	sub    $0xc,%esp
80105169:	68 b2 7a 10 80       	push   $0x80107ab2
8010516e:	e8 1d b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105173:	83 ec 0c             	sub    $0xc,%esp
80105176:	68 8e 7a 10 80       	push   $0x80107a8e
8010517b:	e8 10 b2 ff ff       	call   80100390 <panic>

80105180 <sys_open>:

int
sys_open(void)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	57                   	push   %edi
80105188:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105189:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010518c:	53                   	push   %ebx
8010518d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105190:	50                   	push   %eax
80105191:	6a 00                	push   $0x0
80105193:	e8 08 f8 ff ff       	call   801049a0 <argstr>
80105198:	83 c4 10             	add    $0x10,%esp
8010519b:	85 c0                	test   %eax,%eax
8010519d:	0f 88 8a 00 00 00    	js     8010522d <sys_open+0xad>
801051a3:	83 ec 08             	sub    $0x8,%esp
801051a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801051a9:	50                   	push   %eax
801051aa:	6a 01                	push   $0x1
801051ac:	e8 5f f7 ff ff       	call   80104910 <argint>
801051b1:	83 c4 10             	add    $0x10,%esp
801051b4:	85 c0                	test   %eax,%eax
801051b6:	78 75                	js     8010522d <sys_open+0xad>
    return -1;

  begin_op();
801051b8:	e8 73 db ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
801051bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051c1:	75 75                	jne    80105238 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801051c3:	83 ec 0c             	sub    $0xc,%esp
801051c6:	ff 75 e0             	pushl  -0x20(%ebp)
801051c9:	e8 62 ce ff ff       	call   80102030 <namei>
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	89 c6                	mov    %eax,%esi
801051d3:	85 c0                	test   %eax,%eax
801051d5:	74 7e                	je     80105255 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801051d7:	83 ec 0c             	sub    $0xc,%esp
801051da:	50                   	push   %eax
801051db:	e8 80 c5 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051e0:	83 c4 10             	add    $0x10,%esp
801051e3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051e8:	0f 84 c2 00 00 00    	je     801052b0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051ee:	e8 0d bc ff ff       	call   80100e00 <filealloc>
801051f3:	89 c7                	mov    %eax,%edi
801051f5:	85 c0                	test   %eax,%eax
801051f7:	74 23                	je     8010521c <sys_open+0x9c>
  struct proc *curproc = myproc();
801051f9:	e8 72 e7 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051fe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105200:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105204:	85 d2                	test   %edx,%edx
80105206:	74 60                	je     80105268 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105208:	83 c3 01             	add    $0x1,%ebx
8010520b:	83 fb 10             	cmp    $0x10,%ebx
8010520e:	75 f0                	jne    80105200 <sys_open+0x80>
    if(f)
      fileclose(f);
80105210:	83 ec 0c             	sub    $0xc,%esp
80105213:	57                   	push   %edi
80105214:	e8 a7 bc ff ff       	call   80100ec0 <fileclose>
80105219:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010521c:	83 ec 0c             	sub    $0xc,%esp
8010521f:	56                   	push   %esi
80105220:	e8 db c7 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105225:	e8 76 db ff ff       	call   80102da0 <end_op>
    return -1;
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105232:	eb 6d                	jmp    801052a1 <sys_open+0x121>
80105234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010523e:	31 c9                	xor    %ecx,%ecx
80105240:	ba 02 00 00 00       	mov    $0x2,%edx
80105245:	6a 00                	push   $0x0
80105247:	e8 24 f8 ff ff       	call   80104a70 <create>
    if(ip == 0){
8010524c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010524f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105251:	85 c0                	test   %eax,%eax
80105253:	75 99                	jne    801051ee <sys_open+0x6e>
      end_op();
80105255:	e8 46 db ff ff       	call   80102da0 <end_op>
      return -1;
8010525a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010525f:	eb 40                	jmp    801052a1 <sys_open+0x121>
80105261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105268:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010526b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010526f:	56                   	push   %esi
80105270:	e8 cb c5 ff ff       	call   80101840 <iunlock>
  end_op();
80105275:	e8 26 db ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
8010527a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105280:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105283:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105286:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105289:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010528b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105292:	f7 d0                	not    %eax
80105294:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105297:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010529a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010529d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801052a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a4:	89 d8                	mov    %ebx,%eax
801052a6:	5b                   	pop    %ebx
801052a7:	5e                   	pop    %esi
801052a8:	5f                   	pop    %edi
801052a9:	5d                   	pop    %ebp
801052aa:	c3                   	ret    
801052ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052af:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801052b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801052b3:	85 c9                	test   %ecx,%ecx
801052b5:	0f 84 33 ff ff ff    	je     801051ee <sys_open+0x6e>
801052bb:	e9 5c ff ff ff       	jmp    8010521c <sys_open+0x9c>

801052c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052ca:	e8 61 da ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052cf:	83 ec 08             	sub    $0x8,%esp
801052d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052d5:	50                   	push   %eax
801052d6:	6a 00                	push   $0x0
801052d8:	e8 c3 f6 ff ff       	call   801049a0 <argstr>
801052dd:	83 c4 10             	add    $0x10,%esp
801052e0:	85 c0                	test   %eax,%eax
801052e2:	78 34                	js     80105318 <sys_mkdir+0x58>
801052e4:	83 ec 0c             	sub    $0xc,%esp
801052e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ea:	31 c9                	xor    %ecx,%ecx
801052ec:	ba 01 00 00 00       	mov    $0x1,%edx
801052f1:	6a 00                	push   $0x0
801052f3:	e8 78 f7 ff ff       	call   80104a70 <create>
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	85 c0                	test   %eax,%eax
801052fd:	74 19                	je     80105318 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052ff:	83 ec 0c             	sub    $0xc,%esp
80105302:	50                   	push   %eax
80105303:	e8 f8 c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105308:	e8 93 da ff ff       	call   80102da0 <end_op>
  return 0;
8010530d:	83 c4 10             	add    $0x10,%esp
80105310:	31 c0                	xor    %eax,%eax
}
80105312:	c9                   	leave  
80105313:	c3                   	ret    
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105318:	e8 83 da ff ff       	call   80102da0 <end_op>
    return -1;
8010531d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105322:	c9                   	leave  
80105323:	c3                   	ret    
80105324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010532f:	90                   	nop

80105330 <sys_mknod>:

int
sys_mknod(void)
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010533a:	e8 f1 d9 ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010533f:	83 ec 08             	sub    $0x8,%esp
80105342:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105345:	50                   	push   %eax
80105346:	6a 00                	push   $0x0
80105348:	e8 53 f6 ff ff       	call   801049a0 <argstr>
8010534d:	83 c4 10             	add    $0x10,%esp
80105350:	85 c0                	test   %eax,%eax
80105352:	78 64                	js     801053b8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105354:	83 ec 08             	sub    $0x8,%esp
80105357:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010535a:	50                   	push   %eax
8010535b:	6a 01                	push   $0x1
8010535d:	e8 ae f5 ff ff       	call   80104910 <argint>
  if((argstr(0, &path)) < 0 ||
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	85 c0                	test   %eax,%eax
80105367:	78 4f                	js     801053b8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105369:	83 ec 08             	sub    $0x8,%esp
8010536c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536f:	50                   	push   %eax
80105370:	6a 02                	push   $0x2
80105372:	e8 99 f5 ff ff       	call   80104910 <argint>
     argint(1, &major) < 0 ||
80105377:	83 c4 10             	add    $0x10,%esp
8010537a:	85 c0                	test   %eax,%eax
8010537c:	78 3a                	js     801053b8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010537e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105382:	83 ec 0c             	sub    $0xc,%esp
80105385:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105389:	ba 03 00 00 00       	mov    $0x3,%edx
8010538e:	50                   	push   %eax
8010538f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105392:	e8 d9 f6 ff ff       	call   80104a70 <create>
     argint(2, &minor) < 0 ||
80105397:	83 c4 10             	add    $0x10,%esp
8010539a:	85 c0                	test   %eax,%eax
8010539c:	74 1a                	je     801053b8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010539e:	83 ec 0c             	sub    $0xc,%esp
801053a1:	50                   	push   %eax
801053a2:	e8 59 c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
801053a7:	e8 f4 d9 ff ff       	call   80102da0 <end_op>
  return 0;
801053ac:	83 c4 10             	add    $0x10,%esp
801053af:	31 c0                	xor    %eax,%eax
}
801053b1:	c9                   	leave  
801053b2:	c3                   	ret    
801053b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053b7:	90                   	nop
    end_op();
801053b8:	e8 e3 d9 ff ff       	call   80102da0 <end_op>
    return -1;
801053bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c2:	c9                   	leave  
801053c3:	c3                   	ret    
801053c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop

801053d0 <sys_chdir>:

int
sys_chdir(void)
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	56                   	push   %esi
801053d8:	53                   	push   %ebx
801053d9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801053dc:	e8 8f e5 ff ff       	call   80103970 <myproc>
801053e1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801053e3:	e8 48 d9 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053e8:	83 ec 08             	sub    $0x8,%esp
801053eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ee:	50                   	push   %eax
801053ef:	6a 00                	push   $0x0
801053f1:	e8 aa f5 ff ff       	call   801049a0 <argstr>
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	85 c0                	test   %eax,%eax
801053fb:	78 73                	js     80105470 <sys_chdir+0xa0>
801053fd:	83 ec 0c             	sub    $0xc,%esp
80105400:	ff 75 f4             	pushl  -0xc(%ebp)
80105403:	e8 28 cc ff ff       	call   80102030 <namei>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	89 c3                	mov    %eax,%ebx
8010540d:	85 c0                	test   %eax,%eax
8010540f:	74 5f                	je     80105470 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105411:	83 ec 0c             	sub    $0xc,%esp
80105414:	50                   	push   %eax
80105415:	e8 46 c3 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105422:	75 2c                	jne    80105450 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	53                   	push   %ebx
80105428:	e8 13 c4 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
8010542d:	58                   	pop    %eax
8010542e:	ff 76 68             	pushl  0x68(%esi)
80105431:	e8 5a c4 ff ff       	call   80101890 <iput>
  end_op();
80105436:	e8 65 d9 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
8010543b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	31 c0                	xor    %eax,%eax
}
80105443:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105446:	5b                   	pop    %ebx
80105447:	5e                   	pop    %esi
80105448:	5d                   	pop    %ebp
80105449:	c3                   	ret    
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	53                   	push   %ebx
80105454:	e8 a7 c5 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105459:	e8 42 d9 ff ff       	call   80102da0 <end_op>
    return -1;
8010545e:	83 c4 10             	add    $0x10,%esp
80105461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105466:	eb db                	jmp    80105443 <sys_chdir+0x73>
80105468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop
    end_op();
80105470:	e8 2b d9 ff ff       	call   80102da0 <end_op>
    return -1;
80105475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010547a:	eb c7                	jmp    80105443 <sys_chdir+0x73>
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_exec>:

int
sys_exec(void)
{
80105480:	f3 0f 1e fb          	endbr32 
80105484:	55                   	push   %ebp
80105485:	89 e5                	mov    %esp,%ebp
80105487:	57                   	push   %edi
80105488:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105489:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010548f:	53                   	push   %ebx
80105490:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105496:	50                   	push   %eax
80105497:	6a 00                	push   $0x0
80105499:	e8 02 f5 ff ff       	call   801049a0 <argstr>
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	0f 88 8b 00 00 00    	js     80105534 <sys_exec+0xb4>
801054a9:	83 ec 08             	sub    $0x8,%esp
801054ac:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801054b2:	50                   	push   %eax
801054b3:	6a 01                	push   $0x1
801054b5:	e8 56 f4 ff ff       	call   80104910 <argint>
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	85 c0                	test   %eax,%eax
801054bf:	78 73                	js     80105534 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801054c1:	83 ec 04             	sub    $0x4,%esp
801054c4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801054ca:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801054cc:	68 80 00 00 00       	push   $0x80
801054d1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054d7:	6a 00                	push   $0x0
801054d9:	50                   	push   %eax
801054da:	e8 81 f1 ff ff       	call   80104660 <memset>
801054df:	83 c4 10             	add    $0x10,%esp
801054e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054e8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054ee:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054f5:	83 ec 08             	sub    $0x8,%esp
801054f8:	57                   	push   %edi
801054f9:	01 f0                	add    %esi,%eax
801054fb:	50                   	push   %eax
801054fc:	e8 9f f3 ff ff       	call   801048a0 <fetchint>
80105501:	83 c4 10             	add    $0x10,%esp
80105504:	85 c0                	test   %eax,%eax
80105506:	78 2c                	js     80105534 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105508:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010550e:	85 c0                	test   %eax,%eax
80105510:	74 36                	je     80105548 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105512:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105518:	83 ec 08             	sub    $0x8,%esp
8010551b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010551e:	52                   	push   %edx
8010551f:	50                   	push   %eax
80105520:	e8 ab f3 ff ff       	call   801048d0 <fetchstr>
80105525:	83 c4 10             	add    $0x10,%esp
80105528:	85 c0                	test   %eax,%eax
8010552a:	78 08                	js     80105534 <sys_exec+0xb4>
  for(i=0;; i++){
8010552c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010552f:	83 fb 20             	cmp    $0x20,%ebx
80105532:	75 b4                	jne    801054e8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105534:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010553c:	5b                   	pop    %ebx
8010553d:	5e                   	pop    %esi
8010553e:	5f                   	pop    %edi
8010553f:	5d                   	pop    %ebp
80105540:	c3                   	ret    
80105541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105548:	83 ec 08             	sub    $0x8,%esp
8010554b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105551:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105558:	00 00 00 00 
  return exec(path, argv);
8010555c:	50                   	push   %eax
8010555d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105563:	e8 18 b5 ff ff       	call   80100a80 <exec>
80105568:	83 c4 10             	add    $0x10,%esp
}
8010556b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010556e:	5b                   	pop    %ebx
8010556f:	5e                   	pop    %esi
80105570:	5f                   	pop    %edi
80105571:	5d                   	pop    %ebp
80105572:	c3                   	ret    
80105573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105580 <sys_pipe>:

int
sys_pipe(void)
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
80105585:	89 e5                	mov    %esp,%ebp
80105587:	57                   	push   %edi
80105588:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105589:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010558c:	53                   	push   %ebx
8010558d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105590:	6a 08                	push   $0x8
80105592:	50                   	push   %eax
80105593:	6a 00                	push   $0x0
80105595:	e8 b6 f3 ff ff       	call   80104950 <argptr>
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	85 c0                	test   %eax,%eax
8010559f:	78 4e                	js     801055ef <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801055a1:	83 ec 08             	sub    $0x8,%esp
801055a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055a7:	50                   	push   %eax
801055a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055ab:	50                   	push   %eax
801055ac:	e8 4f de ff ff       	call   80103400 <pipealloc>
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	85 c0                	test   %eax,%eax
801055b6:	78 37                	js     801055ef <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801055bb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055bd:	e8 ae e3 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801055c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801055cc:	85 f6                	test   %esi,%esi
801055ce:	74 30                	je     80105600 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801055d0:	83 c3 01             	add    $0x1,%ebx
801055d3:	83 fb 10             	cmp    $0x10,%ebx
801055d6:	75 f0                	jne    801055c8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	ff 75 e0             	pushl  -0x20(%ebp)
801055de:	e8 dd b8 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801055e3:	58                   	pop    %eax
801055e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801055e7:	e8 d4 b8 ff ff       	call   80100ec0 <fileclose>
    return -1;
801055ec:	83 c4 10             	add    $0x10,%esp
801055ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f4:	eb 5b                	jmp    80105651 <sys_pipe+0xd1>
801055f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105600:	8d 73 08             	lea    0x8(%ebx),%esi
80105603:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105607:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010560a:	e8 61 e3 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010560f:	31 d2                	xor    %edx,%edx
80105611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105618:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010561c:	85 c9                	test   %ecx,%ecx
8010561e:	74 20                	je     80105640 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105620:	83 c2 01             	add    $0x1,%edx
80105623:	83 fa 10             	cmp    $0x10,%edx
80105626:	75 f0                	jne    80105618 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105628:	e8 43 e3 ff ff       	call   80103970 <myproc>
8010562d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105634:	00 
80105635:	eb a1                	jmp    801055d8 <sys_pipe+0x58>
80105637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105640:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105644:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105647:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105649:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010564c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010564f:	31 c0                	xor    %eax,%eax
}
80105651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105654:	5b                   	pop    %ebx
80105655:	5e                   	pop    %esi
80105656:	5f                   	pop    %edi
80105657:	5d                   	pop    %ebp
80105658:	c3                   	ret    
80105659:	66 90                	xchg   %ax,%ax
8010565b:	66 90                	xchg   %ax,%ax
8010565d:	66 90                	xchg   %ax,%ax
8010565f:	90                   	nop

80105660 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
80105665:	89 e5                	mov    %esp,%ebp
80105667:	83 ec 20             	sub    $0x20,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
8010566a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010566d:	50                   	push   %eax
8010566e:	6a 00                	push   $0x0
80105670:	e8 9b f2 ff ff       	call   80104910 <argint>
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	85 c0                	test   %eax,%eax
8010567a:	78 34                	js     801056b0 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010567c:	83 ec 04             	sub    $0x4,%esp
8010567f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105682:	6a 04                	push   $0x4
80105684:	50                   	push   %eax
80105685:	6a 01                	push   $0x1
80105687:	e8 c4 f2 ff ff       	call   80104950 <argptr>
8010568c:	83 c4 10             	add    $0x10,%esp
8010568f:	85 c0                	test   %eax,%eax
80105691:	78 1d                	js     801056b0 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
80105693:	83 ec 08             	sub    $0x8,%esp
80105696:	ff 75 f4             	pushl  -0xc(%ebp)
80105699:	ff 75 f0             	pushl  -0x10(%ebp)
8010569c:	e8 6f 1c 00 00       	call   80107310 <shm_open>
801056a1:	83 c4 10             	add    $0x10,%esp
}
801056a4:	c9                   	leave  
801056a5:	c3                   	ret    
801056a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
801056b0:	c9                   	leave  
    return -1;
801056b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b6:	c3                   	ret    
801056b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056be:	66 90                	xchg   %ax,%ax

801056c0 <sys_shm_close>:

int sys_shm_close(void) {
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	83 ec 20             	sub    $0x20,%esp
  int id;

  if(argint(0, &id) < 0)
801056ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056cd:	50                   	push   %eax
801056ce:	6a 00                	push   $0x0
801056d0:	e8 3b f2 ff ff       	call   80104910 <argint>
801056d5:	83 c4 10             	add    $0x10,%esp
801056d8:	85 c0                	test   %eax,%eax
801056da:	78 14                	js     801056f0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
801056dc:	83 ec 0c             	sub    $0xc,%esp
801056df:	ff 75 f4             	pushl  -0xc(%ebp)
801056e2:	e8 39 1c 00 00       	call   80107320 <shm_close>
801056e7:	83 c4 10             	add    $0x10,%esp
}
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056f0:	c9                   	leave  
    return -1;
801056f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f6:	c3                   	ret    
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax

80105700 <sys_fork>:

int
sys_fork(void)
{
80105700:	f3 0f 1e fb          	endbr32 
  return fork();
80105704:	e9 17 e4 ff ff       	jmp    80103b20 <fork>
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_exit>:
}

int
sys_exit(void)
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	83 ec 08             	sub    $0x8,%esp
  exit();
8010571a:	e8 91 e6 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
8010571f:	31 c0                	xor    %eax,%eax
80105721:	c9                   	leave  
80105722:	c3                   	ret    
80105723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105730 <sys_wait>:

int
sys_wait(void)
{
80105730:	f3 0f 1e fb          	endbr32 
  return wait();
80105734:	e9 c7 e8 ff ff       	jmp    80104000 <wait>
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_kill>:
}

int
sys_kill(void)
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010574a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010574d:	50                   	push   %eax
8010574e:	6a 00                	push   $0x0
80105750:	e8 bb f1 ff ff       	call   80104910 <argint>
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	85 c0                	test   %eax,%eax
8010575a:	78 14                	js     80105770 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	ff 75 f4             	pushl  -0xc(%ebp)
80105762:	e8 f9 e9 ff ff       	call   80104160 <kill>
80105767:	83 c4 10             	add    $0x10,%esp
}
8010576a:	c9                   	leave  
8010576b:	c3                   	ret    
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105770:	c9                   	leave  
    return -1;
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105776:	c3                   	ret    
80105777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_getpid>:

int
sys_getpid(void)
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010578a:	e8 e1 e1 ff ff       	call   80103970 <myproc>
8010578f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105792:	c9                   	leave  
80105793:	c3                   	ret    
80105794:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010579f:	90                   	nop

801057a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057a0:	f3 0f 1e fb          	endbr32 
801057a4:	55                   	push   %ebp
801057a5:	89 e5                	mov    %esp,%ebp
801057a7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057ab:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ae:	50                   	push   %eax
801057af:	6a 00                	push   $0x0
801057b1:	e8 5a f1 ff ff       	call   80104910 <argint>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 23                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057bd:	e8 ae e1 ff ff       	call   80103970 <myproc>
  if(growproc(n) < 0)
801057c2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057c5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057c7:	ff 75 f4             	pushl  -0xc(%ebp)
801057ca:	e8 d1 e2 ff ff       	call   80103aa0 <growproc>
801057cf:	83 c4 10             	add    $0x10,%esp
801057d2:	85 c0                	test   %eax,%eax
801057d4:	78 0a                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057d6:	89 d8                	mov    %ebx,%eax
801057d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057db:	c9                   	leave  
801057dc:	c3                   	ret    
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057e5:	eb ef                	jmp    801057d6 <sys_sbrk+0x36>
801057e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <sys_sleep>:

int
sys_sleep(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057fb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057fe:	50                   	push   %eax
801057ff:	6a 00                	push   $0x0
80105801:	e8 0a f1 ff ff       	call   80104910 <argint>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	0f 88 86 00 00 00    	js     80105897 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105811:	83 ec 0c             	sub    $0xc,%esp
80105814:	68 60 4d 11 80       	push   $0x80114d60
80105819:	e8 c2 ec ff ff       	call   801044e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010581e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105821:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	85 d2                	test   %edx,%edx
8010582c:	75 23                	jne    80105851 <sys_sleep+0x61>
8010582e:	eb 50                	jmp    80105880 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	68 60 4d 11 80       	push   $0x80114d60
80105838:	68 a0 55 11 80       	push   $0x801155a0
8010583d:	e8 fe e6 ff ff       	call   80103f40 <sleep>
  while(ticks - ticks0 < n){
80105842:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	29 d8                	sub    %ebx,%eax
8010584c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010584f:	73 2f                	jae    80105880 <sys_sleep+0x90>
    if(myproc()->killed){
80105851:	e8 1a e1 ff ff       	call   80103970 <myproc>
80105856:	8b 40 24             	mov    0x24(%eax),%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 d3                	je     80105830 <sys_sleep+0x40>
      release(&tickslock);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 60 4d 11 80       	push   $0x80114d60
80105865:	e8 a6 ed ff ff       	call   80104610 <release>
  }
  release(&tickslock);
  return 0;
}
8010586a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	68 60 4d 11 80       	push   $0x80114d60
80105888:	e8 83 ed ff ff       	call   80104610 <release>
  return 0;
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	31 c0                	xor    %eax,%eax
}
80105892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105895:	c9                   	leave  
80105896:	c3                   	ret    
    return -1;
80105897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589c:	eb f4                	jmp    80105892 <sys_sleep+0xa2>
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	53                   	push   %ebx
801058a8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058ab:	68 60 4d 11 80       	push   $0x80114d60
801058b0:	e8 2b ec ff ff       	call   801044e0 <acquire>
  xticks = ticks;
801058b5:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801058bb:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801058c2:	e8 49 ed ff ff       	call   80104610 <release>
  return xticks;
}
801058c7:	89 d8                	mov    %ebx,%eax
801058c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058cc:	c9                   	leave  
801058cd:	c3                   	ret    

801058ce <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ce:	1e                   	push   %ds
  pushl %es
801058cf:	06                   	push   %es
  pushl %fs
801058d0:	0f a0                	push   %fs
  pushl %gs
801058d2:	0f a8                	push   %gs
  pushal
801058d4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058d5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058d9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058db:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058dd:	54                   	push   %esp
  call trap
801058de:	e8 cd 00 00 00       	call   801059b0 <trap>
  addl $4, %esp
801058e3:	83 c4 04             	add    $0x4,%esp

801058e6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058e6:	61                   	popa   
  popl %gs
801058e7:	0f a9                	pop    %gs
  popl %fs
801058e9:	0f a1                	pop    %fs
  popl %es
801058eb:	07                   	pop    %es
  popl %ds
801058ec:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058ed:	83 c4 08             	add    $0x8,%esp
  iret
801058f0:	cf                   	iret   
801058f1:	66 90                	xchg   %ax,%ax
801058f3:	66 90                	xchg   %ax,%ax
801058f5:	66 90                	xchg   %ax,%ax
801058f7:	66 90                	xchg   %ax,%ax
801058f9:	66 90                	xchg   %ax,%ax
801058fb:	66 90                	xchg   %ax,%ax
801058fd:	66 90                	xchg   %ax,%ax
801058ff:	90                   	nop

80105900 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105905:	31 c0                	xor    %eax,%eax
{
80105907:	89 e5                	mov    %esp,%ebp
80105909:	83 ec 08             	sub    $0x8,%esp
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105910:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105917:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
8010591e:	08 00 00 8e 
80105922:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105929:	80 
8010592a:	c1 ea 10             	shr    $0x10,%edx
8010592d:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
80105934:	80 
  for(i = 0; i < 256; i++)
80105935:	83 c0 01             	add    $0x1,%eax
80105938:	3d 00 01 00 00       	cmp    $0x100,%eax
8010593d:	75 d1                	jne    80105910 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010593f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105942:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105947:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
8010594e:	00 00 ef 
  initlock(&tickslock, "time");
80105951:	68 c1 7a 10 80       	push   $0x80107ac1
80105956:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010595b:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105961:	c1 e8 10             	shr    $0x10,%eax
80105964:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
8010596a:	e8 61 ea ff ff       	call   801043d0 <initlock>
}
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	c9                   	leave  
80105973:	c3                   	ret    
80105974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010597f:	90                   	nop

80105980 <idtinit>:

void
idtinit(void)
{
80105980:	f3 0f 1e fb          	endbr32 
80105984:	55                   	push   %ebp
  pd[0] = size-1;
80105985:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010598a:	89 e5                	mov    %esp,%ebp
8010598c:	83 ec 10             	sub    $0x10,%esp
8010598f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105993:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105998:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010599c:	c1 e8 10             	shr    $0x10,%eax
8010599f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059a3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059a6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059a9:	c9                   	leave  
801059aa:	c3                   	ret    
801059ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059af:	90                   	nop

801059b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	57                   	push   %edi
801059b8:	56                   	push   %esi
801059b9:	53                   	push   %ebx
801059ba:	83 ec 1c             	sub    $0x1c,%esp
801059bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059c0:	8b 43 30             	mov    0x30(%ebx),%eax
801059c3:	83 f8 40             	cmp    $0x40,%eax
801059c6:	0f 84 2c 02 00 00    	je     80105bf8 <trap+0x248>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059cc:	83 e8 0e             	sub    $0xe,%eax
801059cf:	83 f8 31             	cmp    $0x31,%eax
801059d2:	0f 87 d6 00 00 00    	ja     80105aae <trap+0xfe>
801059d8:	3e ff 24 85 80 7b 10 	notrack jmp *-0x7fef8480(,%eax,4)
801059df:	80 

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059e0:	0f 20 d6             	mov    %cr2,%esi
    lapiceoi();
    break;

  case T_PGFLT: ;
      uint f = rcr2();
      if (f >KERNBASE-1){
801059e3:	85 f6                	test   %esi,%esi
801059e5:	0f 88 75 02 00 00    	js     80105c60 <trap+0x2b0>
          // cprintf("from trap access > KERNBASE");
          exit();
      }
      f = PGROUNDDOWN(f);
      if (allocuvm(myproc()->pgdir, f, f + PGSIZE) == 0) {
801059eb:	e8 80 df ff ff       	call   80103970 <myproc>
      f = PGROUNDDOWN(f);
801059f0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      if (allocuvm(myproc()->pgdir, f, f + PGSIZE) == 0) {
801059f6:	83 ec 04             	sub    $0x4,%esp
801059f9:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
801059ff:	52                   	push   %edx
80105a00:	56                   	push   %esi
80105a01:	ff 70 04             	pushl  0x4(%eax)
80105a04:	e8 67 13 00 00       	call   80106d70 <allocuvm>
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	0f 84 3c 02 00 00    	je     80105c50 <trap+0x2a0>
          // cprintf("case T_PGFLT from trap.c: allocuvm failed. Number of current allocated pages: %d\n", myproc()->stack_pages);
          exit();
      }
      myproc()->stack_pages++;
80105a14:	e8 57 df ff ff       	call   80103970 <myproc>
      cprintf("Increased stack size\n");
80105a19:	83 ec 0c             	sub    $0xc,%esp
      myproc()->stack_pages++;
80105a1c:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
      cprintf("Increased stack size\n");
80105a20:	68 c6 7a 10 80       	push   $0x80107ac6
80105a25:	e8 86 ac ff ff       	call   801006b0 <cprintf>
      //cprintf("case T_PGFLT from trap.c: allocuvm succeeded. Number of pages allocated: %d\n", myproc()->stack_pages);
      break;
80105a2a:	83 c4 10             	add    $0x10,%esp
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a2d:	e8 3e df ff ff       	call   80103970 <myproc>
80105a32:	85 c0                	test   %eax,%eax
80105a34:	74 1d                	je     80105a53 <trap+0xa3>
80105a36:	e8 35 df ff ff       	call   80103970 <myproc>
80105a3b:	8b 50 24             	mov    0x24(%eax),%edx
80105a3e:	85 d2                	test   %edx,%edx
80105a40:	74 11                	je     80105a53 <trap+0xa3>
80105a42:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a46:	83 e0 03             	and    $0x3,%eax
80105a49:	66 83 f8 03          	cmp    $0x3,%ax
80105a4d:	0f 84 dd 01 00 00    	je     80105c30 <trap+0x280>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a53:	e8 18 df ff ff       	call   80103970 <myproc>
80105a58:	85 c0                	test   %eax,%eax
80105a5a:	74 0f                	je     80105a6b <trap+0xbb>
80105a5c:	e8 0f df ff ff       	call   80103970 <myproc>
80105a61:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a65:	0f 84 75 01 00 00    	je     80105be0 <trap+0x230>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a6b:	e8 00 df ff ff       	call   80103970 <myproc>
80105a70:	85 c0                	test   %eax,%eax
80105a72:	74 1d                	je     80105a91 <trap+0xe1>
80105a74:	e8 f7 de ff ff       	call   80103970 <myproc>
80105a79:	8b 40 24             	mov    0x24(%eax),%eax
80105a7c:	85 c0                	test   %eax,%eax
80105a7e:	74 11                	je     80105a91 <trap+0xe1>
80105a80:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a84:	83 e0 03             	and    $0x3,%eax
80105a87:	66 83 f8 03          	cmp    $0x3,%ax
80105a8b:	0f 84 90 01 00 00    	je     80105c21 <trap+0x271>
    exit();
}
80105a91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a94:	5b                   	pop    %ebx
80105a95:	5e                   	pop    %esi
80105a96:	5f                   	pop    %edi
80105a97:	5d                   	pop    %ebp
80105a98:	c3                   	ret    
    ideintr();
80105a99:	e8 42 c7 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
80105a9e:	e8 1d ce ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aa3:	e8 c8 de ff ff       	call   80103970 <myproc>
80105aa8:	85 c0                	test   %eax,%eax
80105aaa:	75 8a                	jne    80105a36 <trap+0x86>
80105aac:	eb a5                	jmp    80105a53 <trap+0xa3>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105aae:	e8 bd de ff ff       	call   80103970 <myproc>
80105ab3:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	0f 84 ac 01 00 00    	je     80105c6a <trap+0x2ba>
80105abe:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ac2:	0f 84 a2 01 00 00    	je     80105c6a <trap+0x2ba>
80105ac8:	0f 20 d1             	mov    %cr2,%ecx
80105acb:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ace:	e8 7d de ff ff       	call   80103950 <cpuid>
80105ad3:	8b 73 30             	mov    0x30(%ebx),%esi
80105ad6:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ad9:	8b 43 34             	mov    0x34(%ebx),%eax
80105adc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105adf:	e8 8c de ff ff       	call   80103970 <myproc>
80105ae4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ae7:	e8 84 de ff ff       	call   80103970 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105aec:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105aef:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105af2:	51                   	push   %ecx
80105af3:	57                   	push   %edi
80105af4:	52                   	push   %edx
80105af5:	ff 75 e4             	pushl  -0x1c(%ebp)
80105af8:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105af9:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105afc:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105aff:	56                   	push   %esi
80105b00:	ff 70 10             	pushl  0x10(%eax)
80105b03:	68 3c 7b 10 80       	push   $0x80107b3c
80105b08:	e8 a3 ab ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105b0d:	83 c4 20             	add    $0x20,%esp
80105b10:	e8 5b de ff ff       	call   80103970 <myproc>
80105b15:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b1c:	e8 4f de ff ff       	call   80103970 <myproc>
80105b21:	85 c0                	test   %eax,%eax
80105b23:	0f 85 0d ff ff ff    	jne    80105a36 <trap+0x86>
80105b29:	e9 25 ff ff ff       	jmp    80105a53 <trap+0xa3>
    if(cpuid() == 0){
80105b2e:	e8 1d de ff ff       	call   80103950 <cpuid>
80105b33:	85 c0                	test   %eax,%eax
80105b35:	0f 85 63 ff ff ff    	jne    80105a9e <trap+0xee>
      acquire(&tickslock);
80105b3b:	83 ec 0c             	sub    $0xc,%esp
80105b3e:	68 60 4d 11 80       	push   $0x80114d60
80105b43:	e8 98 e9 ff ff       	call   801044e0 <acquire>
      wakeup(&ticks);
80105b48:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105b4f:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105b56:	e8 a5 e5 ff ff       	call   80104100 <wakeup>
      release(&tickslock);
80105b5b:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105b62:	e8 a9 ea ff ff       	call   80104610 <release>
80105b67:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105b6a:	e9 2f ff ff ff       	jmp    80105a9e <trap+0xee>
    kbdintr();
80105b6f:	e8 0c cc ff ff       	call   80102780 <kbdintr>
    lapiceoi();
80105b74:	e8 47 cd ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b79:	e8 f2 dd ff ff       	call   80103970 <myproc>
80105b7e:	85 c0                	test   %eax,%eax
80105b80:	0f 85 b0 fe ff ff    	jne    80105a36 <trap+0x86>
80105b86:	e9 c8 fe ff ff       	jmp    80105a53 <trap+0xa3>
    uartintr();
80105b8b:	e8 80 02 00 00       	call   80105e10 <uartintr>
    lapiceoi();
80105b90:	e8 2b cd ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b95:	e8 d6 dd ff ff       	call   80103970 <myproc>
80105b9a:	85 c0                	test   %eax,%eax
80105b9c:	0f 85 94 fe ff ff    	jne    80105a36 <trap+0x86>
80105ba2:	e9 ac fe ff ff       	jmp    80105a53 <trap+0xa3>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ba7:	8b 7b 38             	mov    0x38(%ebx),%edi
80105baa:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105bae:	e8 9d dd ff ff       	call   80103950 <cpuid>
80105bb3:	57                   	push   %edi
80105bb4:	56                   	push   %esi
80105bb5:	50                   	push   %eax
80105bb6:	68 e4 7a 10 80       	push   $0x80107ae4
80105bbb:	e8 f0 aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105bc0:	e8 fb cc ff ff       	call   801028c0 <lapiceoi>
    break;
80105bc5:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bc8:	e8 a3 dd ff ff       	call   80103970 <myproc>
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	0f 85 61 fe ff ff    	jne    80105a36 <trap+0x86>
80105bd5:	e9 79 fe ff ff       	jmp    80105a53 <trap+0xa3>
80105bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105be0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105be4:	0f 85 81 fe ff ff    	jne    80105a6b <trap+0xbb>
    yield();
80105bea:	e8 01 e3 ff ff       	call   80103ef0 <yield>
80105bef:	e9 77 fe ff ff       	jmp    80105a6b <trap+0xbb>
80105bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105bf8:	e8 73 dd ff ff       	call   80103970 <myproc>
80105bfd:	8b 70 24             	mov    0x24(%eax),%esi
80105c00:	85 f6                	test   %esi,%esi
80105c02:	75 3c                	jne    80105c40 <trap+0x290>
    myproc()->tf = tf;
80105c04:	e8 67 dd ff ff       	call   80103970 <myproc>
80105c09:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c0c:	e8 ef ed ff ff       	call   80104a00 <syscall>
    if(myproc()->killed)
80105c11:	e8 5a dd ff ff       	call   80103970 <myproc>
80105c16:	8b 48 24             	mov    0x24(%eax),%ecx
80105c19:	85 c9                	test   %ecx,%ecx
80105c1b:	0f 84 70 fe ff ff    	je     80105a91 <trap+0xe1>
}
80105c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c24:	5b                   	pop    %ebx
80105c25:	5e                   	pop    %esi
80105c26:	5f                   	pop    %edi
80105c27:	5d                   	pop    %ebp
      exit();
80105c28:	e9 83 e1 ff ff       	jmp    80103db0 <exit>
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105c30:	e8 7b e1 ff ff       	call   80103db0 <exit>
80105c35:	e9 19 fe ff ff       	jmp    80105a53 <trap+0xa3>
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105c40:	e8 6b e1 ff ff       	call   80103db0 <exit>
80105c45:	eb bd                	jmp    80105c04 <trap+0x254>
80105c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4e:	66 90                	xchg   %ax,%ax
          exit();
80105c50:	e8 5b e1 ff ff       	call   80103db0 <exit>
80105c55:	e9 ba fd ff ff       	jmp    80105a14 <trap+0x64>
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          exit();
80105c60:	e8 4b e1 ff ff       	call   80103db0 <exit>
80105c65:	e9 81 fd ff ff       	jmp    801059eb <trap+0x3b>
80105c6a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c6d:	e8 de dc ff ff       	call   80103950 <cpuid>
80105c72:	83 ec 0c             	sub    $0xc,%esp
80105c75:	56                   	push   %esi
80105c76:	57                   	push   %edi
80105c77:	50                   	push   %eax
80105c78:	ff 73 30             	pushl  0x30(%ebx)
80105c7b:	68 08 7b 10 80       	push   $0x80107b08
80105c80:	e8 2b aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105c85:	83 c4 14             	add    $0x14,%esp
80105c88:	68 dc 7a 10 80       	push   $0x80107adc
80105c8d:	e8 fe a6 ff ff       	call   80100390 <panic>
80105c92:	66 90                	xchg   %ax,%ax
80105c94:	66 90                	xchg   %ax,%ax
80105c96:	66 90                	xchg   %ax,%ax
80105c98:	66 90                	xchg   %ax,%ax
80105c9a:	66 90                	xchg   %ax,%ax
80105c9c:	66 90                	xchg   %ax,%ax
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105ca0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105ca4:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	74 1b                	je     80105cc8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cad:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cb2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105cb3:	a8 01                	test   $0x1,%al
80105cb5:	74 11                	je     80105cc8 <uartgetc+0x28>
80105cb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cbc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105cbd:	0f b6 c0             	movzbl %al,%eax
80105cc0:	c3                   	ret    
80105cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ccd:	c3                   	ret    
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <uartputc.part.0>:
uartputc(int c)
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	57                   	push   %edi
80105cd4:	89 c7                	mov    %eax,%edi
80105cd6:	56                   	push   %esi
80105cd7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cdc:	53                   	push   %ebx
80105cdd:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ce2:	83 ec 0c             	sub    $0xc,%esp
80105ce5:	eb 1b                	jmp    80105d02 <uartputc.part.0+0x32>
80105ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cee:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	6a 0a                	push   $0xa
80105cf5:	e8 e6 cb ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	83 eb 01             	sub    $0x1,%ebx
80105d00:	74 07                	je     80105d09 <uartputc.part.0+0x39>
80105d02:	89 f2                	mov    %esi,%edx
80105d04:	ec                   	in     (%dx),%al
80105d05:	a8 20                	test   $0x20,%al
80105d07:	74 e7                	je     80105cf0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d09:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d0e:	89 f8                	mov    %edi,%eax
80105d10:	ee                   	out    %al,(%dx)
}
80105d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d14:	5b                   	pop    %ebx
80105d15:	5e                   	pop    %esi
80105d16:	5f                   	pop    %edi
80105d17:	5d                   	pop    %ebp
80105d18:	c3                   	ret    
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d20 <uartinit>:
{
80105d20:	f3 0f 1e fb          	endbr32 
80105d24:	55                   	push   %ebp
80105d25:	31 c9                	xor    %ecx,%ecx
80105d27:	89 c8                	mov    %ecx,%eax
80105d29:	89 e5                	mov    %esp,%ebp
80105d2b:	57                   	push   %edi
80105d2c:	56                   	push   %esi
80105d2d:	53                   	push   %ebx
80105d2e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d33:	89 da                	mov    %ebx,%edx
80105d35:	83 ec 0c             	sub    $0xc,%esp
80105d38:	ee                   	out    %al,(%dx)
80105d39:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d3e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d43:	89 fa                	mov    %edi,%edx
80105d45:	ee                   	out    %al,(%dx)
80105d46:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d4b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d50:	ee                   	out    %al,(%dx)
80105d51:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d56:	89 c8                	mov    %ecx,%eax
80105d58:	89 f2                	mov    %esi,%edx
80105d5a:	ee                   	out    %al,(%dx)
80105d5b:	b8 03 00 00 00       	mov    $0x3,%eax
80105d60:	89 fa                	mov    %edi,%edx
80105d62:	ee                   	out    %al,(%dx)
80105d63:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d68:	89 c8                	mov    %ecx,%eax
80105d6a:	ee                   	out    %al,(%dx)
80105d6b:	b8 01 00 00 00       	mov    $0x1,%eax
80105d70:	89 f2                	mov    %esi,%edx
80105d72:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d73:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d78:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d79:	3c ff                	cmp    $0xff,%al
80105d7b:	74 52                	je     80105dcf <uartinit+0xaf>
  uart = 1;
80105d7d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d84:	00 00 00 
80105d87:	89 da                	mov    %ebx,%edx
80105d89:	ec                   	in     (%dx),%al
80105d8a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d8f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d90:	83 ec 08             	sub    $0x8,%esp
80105d93:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105d98:	bb 48 7c 10 80       	mov    $0x80107c48,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d9d:	6a 00                	push   $0x0
80105d9f:	6a 04                	push   $0x4
80105da1:	e8 8a c6 ff ff       	call   80102430 <ioapicenable>
80105da6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105da9:	b8 78 00 00 00       	mov    $0x78,%eax
80105dae:	eb 04                	jmp    80105db4 <uartinit+0x94>
80105db0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105db4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105dba:	85 d2                	test   %edx,%edx
80105dbc:	74 08                	je     80105dc6 <uartinit+0xa6>
    uartputc(*p);
80105dbe:	0f be c0             	movsbl %al,%eax
80105dc1:	e8 0a ff ff ff       	call   80105cd0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105dc6:	89 f0                	mov    %esi,%eax
80105dc8:	83 c3 01             	add    $0x1,%ebx
80105dcb:	84 c0                	test   %al,%al
80105dcd:	75 e1                	jne    80105db0 <uartinit+0x90>
}
80105dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dd2:	5b                   	pop    %ebx
80105dd3:	5e                   	pop    %esi
80105dd4:	5f                   	pop    %edi
80105dd5:	5d                   	pop    %ebp
80105dd6:	c3                   	ret    
80105dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <uartputc>:
{
80105de0:	f3 0f 1e fb          	endbr32 
80105de4:	55                   	push   %ebp
  if(!uart)
80105de5:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105deb:	89 e5                	mov    %esp,%ebp
80105ded:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105df0:	85 d2                	test   %edx,%edx
80105df2:	74 0c                	je     80105e00 <uartputc+0x20>
}
80105df4:	5d                   	pop    %ebp
80105df5:	e9 d6 fe ff ff       	jmp    80105cd0 <uartputc.part.0>
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e00:	5d                   	pop    %ebp
80105e01:	c3                   	ret    
80105e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e10 <uartintr>:

void
uartintr(void)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e1a:	68 a0 5c 10 80       	push   $0x80105ca0
80105e1f:	e8 3c aa ff ff       	call   80100860 <consoleintr>
}
80105e24:	83 c4 10             	add    $0x10,%esp
80105e27:	c9                   	leave  
80105e28:	c3                   	ret    

80105e29 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $0
80105e2b:	6a 00                	push   $0x0
  jmp alltraps
80105e2d:	e9 9c fa ff ff       	jmp    801058ce <alltraps>

80105e32 <vector1>:
.globl vector1
vector1:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $1
80105e34:	6a 01                	push   $0x1
  jmp alltraps
80105e36:	e9 93 fa ff ff       	jmp    801058ce <alltraps>

80105e3b <vector2>:
.globl vector2
vector2:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $2
80105e3d:	6a 02                	push   $0x2
  jmp alltraps
80105e3f:	e9 8a fa ff ff       	jmp    801058ce <alltraps>

80105e44 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $3
80105e46:	6a 03                	push   $0x3
  jmp alltraps
80105e48:	e9 81 fa ff ff       	jmp    801058ce <alltraps>

80105e4d <vector4>:
.globl vector4
vector4:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $4
80105e4f:	6a 04                	push   $0x4
  jmp alltraps
80105e51:	e9 78 fa ff ff       	jmp    801058ce <alltraps>

80105e56 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $5
80105e58:	6a 05                	push   $0x5
  jmp alltraps
80105e5a:	e9 6f fa ff ff       	jmp    801058ce <alltraps>

80105e5f <vector6>:
.globl vector6
vector6:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $6
80105e61:	6a 06                	push   $0x6
  jmp alltraps
80105e63:	e9 66 fa ff ff       	jmp    801058ce <alltraps>

80105e68 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $7
80105e6a:	6a 07                	push   $0x7
  jmp alltraps
80105e6c:	e9 5d fa ff ff       	jmp    801058ce <alltraps>

80105e71 <vector8>:
.globl vector8
vector8:
  pushl $8
80105e71:	6a 08                	push   $0x8
  jmp alltraps
80105e73:	e9 56 fa ff ff       	jmp    801058ce <alltraps>

80105e78 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $9
80105e7a:	6a 09                	push   $0x9
  jmp alltraps
80105e7c:	e9 4d fa ff ff       	jmp    801058ce <alltraps>

80105e81 <vector10>:
.globl vector10
vector10:
  pushl $10
80105e81:	6a 0a                	push   $0xa
  jmp alltraps
80105e83:	e9 46 fa ff ff       	jmp    801058ce <alltraps>

80105e88 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e88:	6a 0b                	push   $0xb
  jmp alltraps
80105e8a:	e9 3f fa ff ff       	jmp    801058ce <alltraps>

80105e8f <vector12>:
.globl vector12
vector12:
  pushl $12
80105e8f:	6a 0c                	push   $0xc
  jmp alltraps
80105e91:	e9 38 fa ff ff       	jmp    801058ce <alltraps>

80105e96 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e96:	6a 0d                	push   $0xd
  jmp alltraps
80105e98:	e9 31 fa ff ff       	jmp    801058ce <alltraps>

80105e9d <vector14>:
.globl vector14
vector14:
  pushl $14
80105e9d:	6a 0e                	push   $0xe
  jmp alltraps
80105e9f:	e9 2a fa ff ff       	jmp    801058ce <alltraps>

80105ea4 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $15
80105ea6:	6a 0f                	push   $0xf
  jmp alltraps
80105ea8:	e9 21 fa ff ff       	jmp    801058ce <alltraps>

80105ead <vector16>:
.globl vector16
vector16:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $16
80105eaf:	6a 10                	push   $0x10
  jmp alltraps
80105eb1:	e9 18 fa ff ff       	jmp    801058ce <alltraps>

80105eb6 <vector17>:
.globl vector17
vector17:
  pushl $17
80105eb6:	6a 11                	push   $0x11
  jmp alltraps
80105eb8:	e9 11 fa ff ff       	jmp    801058ce <alltraps>

80105ebd <vector18>:
.globl vector18
vector18:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $18
80105ebf:	6a 12                	push   $0x12
  jmp alltraps
80105ec1:	e9 08 fa ff ff       	jmp    801058ce <alltraps>

80105ec6 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $19
80105ec8:	6a 13                	push   $0x13
  jmp alltraps
80105eca:	e9 ff f9 ff ff       	jmp    801058ce <alltraps>

80105ecf <vector20>:
.globl vector20
vector20:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $20
80105ed1:	6a 14                	push   $0x14
  jmp alltraps
80105ed3:	e9 f6 f9 ff ff       	jmp    801058ce <alltraps>

80105ed8 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $21
80105eda:	6a 15                	push   $0x15
  jmp alltraps
80105edc:	e9 ed f9 ff ff       	jmp    801058ce <alltraps>

80105ee1 <vector22>:
.globl vector22
vector22:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $22
80105ee3:	6a 16                	push   $0x16
  jmp alltraps
80105ee5:	e9 e4 f9 ff ff       	jmp    801058ce <alltraps>

80105eea <vector23>:
.globl vector23
vector23:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $23
80105eec:	6a 17                	push   $0x17
  jmp alltraps
80105eee:	e9 db f9 ff ff       	jmp    801058ce <alltraps>

80105ef3 <vector24>:
.globl vector24
vector24:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $24
80105ef5:	6a 18                	push   $0x18
  jmp alltraps
80105ef7:	e9 d2 f9 ff ff       	jmp    801058ce <alltraps>

80105efc <vector25>:
.globl vector25
vector25:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $25
80105efe:	6a 19                	push   $0x19
  jmp alltraps
80105f00:	e9 c9 f9 ff ff       	jmp    801058ce <alltraps>

80105f05 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $26
80105f07:	6a 1a                	push   $0x1a
  jmp alltraps
80105f09:	e9 c0 f9 ff ff       	jmp    801058ce <alltraps>

80105f0e <vector27>:
.globl vector27
vector27:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $27
80105f10:	6a 1b                	push   $0x1b
  jmp alltraps
80105f12:	e9 b7 f9 ff ff       	jmp    801058ce <alltraps>

80105f17 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $28
80105f19:	6a 1c                	push   $0x1c
  jmp alltraps
80105f1b:	e9 ae f9 ff ff       	jmp    801058ce <alltraps>

80105f20 <vector29>:
.globl vector29
vector29:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $29
80105f22:	6a 1d                	push   $0x1d
  jmp alltraps
80105f24:	e9 a5 f9 ff ff       	jmp    801058ce <alltraps>

80105f29 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $30
80105f2b:	6a 1e                	push   $0x1e
  jmp alltraps
80105f2d:	e9 9c f9 ff ff       	jmp    801058ce <alltraps>

80105f32 <vector31>:
.globl vector31
vector31:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $31
80105f34:	6a 1f                	push   $0x1f
  jmp alltraps
80105f36:	e9 93 f9 ff ff       	jmp    801058ce <alltraps>

80105f3b <vector32>:
.globl vector32
vector32:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $32
80105f3d:	6a 20                	push   $0x20
  jmp alltraps
80105f3f:	e9 8a f9 ff ff       	jmp    801058ce <alltraps>

80105f44 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $33
80105f46:	6a 21                	push   $0x21
  jmp alltraps
80105f48:	e9 81 f9 ff ff       	jmp    801058ce <alltraps>

80105f4d <vector34>:
.globl vector34
vector34:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $34
80105f4f:	6a 22                	push   $0x22
  jmp alltraps
80105f51:	e9 78 f9 ff ff       	jmp    801058ce <alltraps>

80105f56 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $35
80105f58:	6a 23                	push   $0x23
  jmp alltraps
80105f5a:	e9 6f f9 ff ff       	jmp    801058ce <alltraps>

80105f5f <vector36>:
.globl vector36
vector36:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $36
80105f61:	6a 24                	push   $0x24
  jmp alltraps
80105f63:	e9 66 f9 ff ff       	jmp    801058ce <alltraps>

80105f68 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $37
80105f6a:	6a 25                	push   $0x25
  jmp alltraps
80105f6c:	e9 5d f9 ff ff       	jmp    801058ce <alltraps>

80105f71 <vector38>:
.globl vector38
vector38:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $38
80105f73:	6a 26                	push   $0x26
  jmp alltraps
80105f75:	e9 54 f9 ff ff       	jmp    801058ce <alltraps>

80105f7a <vector39>:
.globl vector39
vector39:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $39
80105f7c:	6a 27                	push   $0x27
  jmp alltraps
80105f7e:	e9 4b f9 ff ff       	jmp    801058ce <alltraps>

80105f83 <vector40>:
.globl vector40
vector40:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $40
80105f85:	6a 28                	push   $0x28
  jmp alltraps
80105f87:	e9 42 f9 ff ff       	jmp    801058ce <alltraps>

80105f8c <vector41>:
.globl vector41
vector41:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $41
80105f8e:	6a 29                	push   $0x29
  jmp alltraps
80105f90:	e9 39 f9 ff ff       	jmp    801058ce <alltraps>

80105f95 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $42
80105f97:	6a 2a                	push   $0x2a
  jmp alltraps
80105f99:	e9 30 f9 ff ff       	jmp    801058ce <alltraps>

80105f9e <vector43>:
.globl vector43
vector43:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $43
80105fa0:	6a 2b                	push   $0x2b
  jmp alltraps
80105fa2:	e9 27 f9 ff ff       	jmp    801058ce <alltraps>

80105fa7 <vector44>:
.globl vector44
vector44:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $44
80105fa9:	6a 2c                	push   $0x2c
  jmp alltraps
80105fab:	e9 1e f9 ff ff       	jmp    801058ce <alltraps>

80105fb0 <vector45>:
.globl vector45
vector45:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $45
80105fb2:	6a 2d                	push   $0x2d
  jmp alltraps
80105fb4:	e9 15 f9 ff ff       	jmp    801058ce <alltraps>

80105fb9 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $46
80105fbb:	6a 2e                	push   $0x2e
  jmp alltraps
80105fbd:	e9 0c f9 ff ff       	jmp    801058ce <alltraps>

80105fc2 <vector47>:
.globl vector47
vector47:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $47
80105fc4:	6a 2f                	push   $0x2f
  jmp alltraps
80105fc6:	e9 03 f9 ff ff       	jmp    801058ce <alltraps>

80105fcb <vector48>:
.globl vector48
vector48:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $48
80105fcd:	6a 30                	push   $0x30
  jmp alltraps
80105fcf:	e9 fa f8 ff ff       	jmp    801058ce <alltraps>

80105fd4 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $49
80105fd6:	6a 31                	push   $0x31
  jmp alltraps
80105fd8:	e9 f1 f8 ff ff       	jmp    801058ce <alltraps>

80105fdd <vector50>:
.globl vector50
vector50:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $50
80105fdf:	6a 32                	push   $0x32
  jmp alltraps
80105fe1:	e9 e8 f8 ff ff       	jmp    801058ce <alltraps>

80105fe6 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $51
80105fe8:	6a 33                	push   $0x33
  jmp alltraps
80105fea:	e9 df f8 ff ff       	jmp    801058ce <alltraps>

80105fef <vector52>:
.globl vector52
vector52:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $52
80105ff1:	6a 34                	push   $0x34
  jmp alltraps
80105ff3:	e9 d6 f8 ff ff       	jmp    801058ce <alltraps>

80105ff8 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $53
80105ffa:	6a 35                	push   $0x35
  jmp alltraps
80105ffc:	e9 cd f8 ff ff       	jmp    801058ce <alltraps>

80106001 <vector54>:
.globl vector54
vector54:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $54
80106003:	6a 36                	push   $0x36
  jmp alltraps
80106005:	e9 c4 f8 ff ff       	jmp    801058ce <alltraps>

8010600a <vector55>:
.globl vector55
vector55:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $55
8010600c:	6a 37                	push   $0x37
  jmp alltraps
8010600e:	e9 bb f8 ff ff       	jmp    801058ce <alltraps>

80106013 <vector56>:
.globl vector56
vector56:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $56
80106015:	6a 38                	push   $0x38
  jmp alltraps
80106017:	e9 b2 f8 ff ff       	jmp    801058ce <alltraps>

8010601c <vector57>:
.globl vector57
vector57:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $57
8010601e:	6a 39                	push   $0x39
  jmp alltraps
80106020:	e9 a9 f8 ff ff       	jmp    801058ce <alltraps>

80106025 <vector58>:
.globl vector58
vector58:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $58
80106027:	6a 3a                	push   $0x3a
  jmp alltraps
80106029:	e9 a0 f8 ff ff       	jmp    801058ce <alltraps>

8010602e <vector59>:
.globl vector59
vector59:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $59
80106030:	6a 3b                	push   $0x3b
  jmp alltraps
80106032:	e9 97 f8 ff ff       	jmp    801058ce <alltraps>

80106037 <vector60>:
.globl vector60
vector60:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $60
80106039:	6a 3c                	push   $0x3c
  jmp alltraps
8010603b:	e9 8e f8 ff ff       	jmp    801058ce <alltraps>

80106040 <vector61>:
.globl vector61
vector61:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $61
80106042:	6a 3d                	push   $0x3d
  jmp alltraps
80106044:	e9 85 f8 ff ff       	jmp    801058ce <alltraps>

80106049 <vector62>:
.globl vector62
vector62:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $62
8010604b:	6a 3e                	push   $0x3e
  jmp alltraps
8010604d:	e9 7c f8 ff ff       	jmp    801058ce <alltraps>

80106052 <vector63>:
.globl vector63
vector63:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $63
80106054:	6a 3f                	push   $0x3f
  jmp alltraps
80106056:	e9 73 f8 ff ff       	jmp    801058ce <alltraps>

8010605b <vector64>:
.globl vector64
vector64:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $64
8010605d:	6a 40                	push   $0x40
  jmp alltraps
8010605f:	e9 6a f8 ff ff       	jmp    801058ce <alltraps>

80106064 <vector65>:
.globl vector65
vector65:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $65
80106066:	6a 41                	push   $0x41
  jmp alltraps
80106068:	e9 61 f8 ff ff       	jmp    801058ce <alltraps>

8010606d <vector66>:
.globl vector66
vector66:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $66
8010606f:	6a 42                	push   $0x42
  jmp alltraps
80106071:	e9 58 f8 ff ff       	jmp    801058ce <alltraps>

80106076 <vector67>:
.globl vector67
vector67:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $67
80106078:	6a 43                	push   $0x43
  jmp alltraps
8010607a:	e9 4f f8 ff ff       	jmp    801058ce <alltraps>

8010607f <vector68>:
.globl vector68
vector68:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $68
80106081:	6a 44                	push   $0x44
  jmp alltraps
80106083:	e9 46 f8 ff ff       	jmp    801058ce <alltraps>

80106088 <vector69>:
.globl vector69
vector69:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $69
8010608a:	6a 45                	push   $0x45
  jmp alltraps
8010608c:	e9 3d f8 ff ff       	jmp    801058ce <alltraps>

80106091 <vector70>:
.globl vector70
vector70:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $70
80106093:	6a 46                	push   $0x46
  jmp alltraps
80106095:	e9 34 f8 ff ff       	jmp    801058ce <alltraps>

8010609a <vector71>:
.globl vector71
vector71:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $71
8010609c:	6a 47                	push   $0x47
  jmp alltraps
8010609e:	e9 2b f8 ff ff       	jmp    801058ce <alltraps>

801060a3 <vector72>:
.globl vector72
vector72:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $72
801060a5:	6a 48                	push   $0x48
  jmp alltraps
801060a7:	e9 22 f8 ff ff       	jmp    801058ce <alltraps>

801060ac <vector73>:
.globl vector73
vector73:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $73
801060ae:	6a 49                	push   $0x49
  jmp alltraps
801060b0:	e9 19 f8 ff ff       	jmp    801058ce <alltraps>

801060b5 <vector74>:
.globl vector74
vector74:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $74
801060b7:	6a 4a                	push   $0x4a
  jmp alltraps
801060b9:	e9 10 f8 ff ff       	jmp    801058ce <alltraps>

801060be <vector75>:
.globl vector75
vector75:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $75
801060c0:	6a 4b                	push   $0x4b
  jmp alltraps
801060c2:	e9 07 f8 ff ff       	jmp    801058ce <alltraps>

801060c7 <vector76>:
.globl vector76
vector76:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $76
801060c9:	6a 4c                	push   $0x4c
  jmp alltraps
801060cb:	e9 fe f7 ff ff       	jmp    801058ce <alltraps>

801060d0 <vector77>:
.globl vector77
vector77:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $77
801060d2:	6a 4d                	push   $0x4d
  jmp alltraps
801060d4:	e9 f5 f7 ff ff       	jmp    801058ce <alltraps>

801060d9 <vector78>:
.globl vector78
vector78:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $78
801060db:	6a 4e                	push   $0x4e
  jmp alltraps
801060dd:	e9 ec f7 ff ff       	jmp    801058ce <alltraps>

801060e2 <vector79>:
.globl vector79
vector79:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $79
801060e4:	6a 4f                	push   $0x4f
  jmp alltraps
801060e6:	e9 e3 f7 ff ff       	jmp    801058ce <alltraps>

801060eb <vector80>:
.globl vector80
vector80:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $80
801060ed:	6a 50                	push   $0x50
  jmp alltraps
801060ef:	e9 da f7 ff ff       	jmp    801058ce <alltraps>

801060f4 <vector81>:
.globl vector81
vector81:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $81
801060f6:	6a 51                	push   $0x51
  jmp alltraps
801060f8:	e9 d1 f7 ff ff       	jmp    801058ce <alltraps>

801060fd <vector82>:
.globl vector82
vector82:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $82
801060ff:	6a 52                	push   $0x52
  jmp alltraps
80106101:	e9 c8 f7 ff ff       	jmp    801058ce <alltraps>

80106106 <vector83>:
.globl vector83
vector83:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $83
80106108:	6a 53                	push   $0x53
  jmp alltraps
8010610a:	e9 bf f7 ff ff       	jmp    801058ce <alltraps>

8010610f <vector84>:
.globl vector84
vector84:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $84
80106111:	6a 54                	push   $0x54
  jmp alltraps
80106113:	e9 b6 f7 ff ff       	jmp    801058ce <alltraps>

80106118 <vector85>:
.globl vector85
vector85:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $85
8010611a:	6a 55                	push   $0x55
  jmp alltraps
8010611c:	e9 ad f7 ff ff       	jmp    801058ce <alltraps>

80106121 <vector86>:
.globl vector86
vector86:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $86
80106123:	6a 56                	push   $0x56
  jmp alltraps
80106125:	e9 a4 f7 ff ff       	jmp    801058ce <alltraps>

8010612a <vector87>:
.globl vector87
vector87:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $87
8010612c:	6a 57                	push   $0x57
  jmp alltraps
8010612e:	e9 9b f7 ff ff       	jmp    801058ce <alltraps>

80106133 <vector88>:
.globl vector88
vector88:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $88
80106135:	6a 58                	push   $0x58
  jmp alltraps
80106137:	e9 92 f7 ff ff       	jmp    801058ce <alltraps>

8010613c <vector89>:
.globl vector89
vector89:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $89
8010613e:	6a 59                	push   $0x59
  jmp alltraps
80106140:	e9 89 f7 ff ff       	jmp    801058ce <alltraps>

80106145 <vector90>:
.globl vector90
vector90:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $90
80106147:	6a 5a                	push   $0x5a
  jmp alltraps
80106149:	e9 80 f7 ff ff       	jmp    801058ce <alltraps>

8010614e <vector91>:
.globl vector91
vector91:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $91
80106150:	6a 5b                	push   $0x5b
  jmp alltraps
80106152:	e9 77 f7 ff ff       	jmp    801058ce <alltraps>

80106157 <vector92>:
.globl vector92
vector92:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $92
80106159:	6a 5c                	push   $0x5c
  jmp alltraps
8010615b:	e9 6e f7 ff ff       	jmp    801058ce <alltraps>

80106160 <vector93>:
.globl vector93
vector93:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $93
80106162:	6a 5d                	push   $0x5d
  jmp alltraps
80106164:	e9 65 f7 ff ff       	jmp    801058ce <alltraps>

80106169 <vector94>:
.globl vector94
vector94:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $94
8010616b:	6a 5e                	push   $0x5e
  jmp alltraps
8010616d:	e9 5c f7 ff ff       	jmp    801058ce <alltraps>

80106172 <vector95>:
.globl vector95
vector95:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $95
80106174:	6a 5f                	push   $0x5f
  jmp alltraps
80106176:	e9 53 f7 ff ff       	jmp    801058ce <alltraps>

8010617b <vector96>:
.globl vector96
vector96:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $96
8010617d:	6a 60                	push   $0x60
  jmp alltraps
8010617f:	e9 4a f7 ff ff       	jmp    801058ce <alltraps>

80106184 <vector97>:
.globl vector97
vector97:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $97
80106186:	6a 61                	push   $0x61
  jmp alltraps
80106188:	e9 41 f7 ff ff       	jmp    801058ce <alltraps>

8010618d <vector98>:
.globl vector98
vector98:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $98
8010618f:	6a 62                	push   $0x62
  jmp alltraps
80106191:	e9 38 f7 ff ff       	jmp    801058ce <alltraps>

80106196 <vector99>:
.globl vector99
vector99:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $99
80106198:	6a 63                	push   $0x63
  jmp alltraps
8010619a:	e9 2f f7 ff ff       	jmp    801058ce <alltraps>

8010619f <vector100>:
.globl vector100
vector100:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $100
801061a1:	6a 64                	push   $0x64
  jmp alltraps
801061a3:	e9 26 f7 ff ff       	jmp    801058ce <alltraps>

801061a8 <vector101>:
.globl vector101
vector101:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $101
801061aa:	6a 65                	push   $0x65
  jmp alltraps
801061ac:	e9 1d f7 ff ff       	jmp    801058ce <alltraps>

801061b1 <vector102>:
.globl vector102
vector102:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $102
801061b3:	6a 66                	push   $0x66
  jmp alltraps
801061b5:	e9 14 f7 ff ff       	jmp    801058ce <alltraps>

801061ba <vector103>:
.globl vector103
vector103:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $103
801061bc:	6a 67                	push   $0x67
  jmp alltraps
801061be:	e9 0b f7 ff ff       	jmp    801058ce <alltraps>

801061c3 <vector104>:
.globl vector104
vector104:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $104
801061c5:	6a 68                	push   $0x68
  jmp alltraps
801061c7:	e9 02 f7 ff ff       	jmp    801058ce <alltraps>

801061cc <vector105>:
.globl vector105
vector105:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $105
801061ce:	6a 69                	push   $0x69
  jmp alltraps
801061d0:	e9 f9 f6 ff ff       	jmp    801058ce <alltraps>

801061d5 <vector106>:
.globl vector106
vector106:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $106
801061d7:	6a 6a                	push   $0x6a
  jmp alltraps
801061d9:	e9 f0 f6 ff ff       	jmp    801058ce <alltraps>

801061de <vector107>:
.globl vector107
vector107:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $107
801061e0:	6a 6b                	push   $0x6b
  jmp alltraps
801061e2:	e9 e7 f6 ff ff       	jmp    801058ce <alltraps>

801061e7 <vector108>:
.globl vector108
vector108:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $108
801061e9:	6a 6c                	push   $0x6c
  jmp alltraps
801061eb:	e9 de f6 ff ff       	jmp    801058ce <alltraps>

801061f0 <vector109>:
.globl vector109
vector109:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $109
801061f2:	6a 6d                	push   $0x6d
  jmp alltraps
801061f4:	e9 d5 f6 ff ff       	jmp    801058ce <alltraps>

801061f9 <vector110>:
.globl vector110
vector110:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $110
801061fb:	6a 6e                	push   $0x6e
  jmp alltraps
801061fd:	e9 cc f6 ff ff       	jmp    801058ce <alltraps>

80106202 <vector111>:
.globl vector111
vector111:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $111
80106204:	6a 6f                	push   $0x6f
  jmp alltraps
80106206:	e9 c3 f6 ff ff       	jmp    801058ce <alltraps>

8010620b <vector112>:
.globl vector112
vector112:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $112
8010620d:	6a 70                	push   $0x70
  jmp alltraps
8010620f:	e9 ba f6 ff ff       	jmp    801058ce <alltraps>

80106214 <vector113>:
.globl vector113
vector113:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $113
80106216:	6a 71                	push   $0x71
  jmp alltraps
80106218:	e9 b1 f6 ff ff       	jmp    801058ce <alltraps>

8010621d <vector114>:
.globl vector114
vector114:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $114
8010621f:	6a 72                	push   $0x72
  jmp alltraps
80106221:	e9 a8 f6 ff ff       	jmp    801058ce <alltraps>

80106226 <vector115>:
.globl vector115
vector115:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $115
80106228:	6a 73                	push   $0x73
  jmp alltraps
8010622a:	e9 9f f6 ff ff       	jmp    801058ce <alltraps>

8010622f <vector116>:
.globl vector116
vector116:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $116
80106231:	6a 74                	push   $0x74
  jmp alltraps
80106233:	e9 96 f6 ff ff       	jmp    801058ce <alltraps>

80106238 <vector117>:
.globl vector117
vector117:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $117
8010623a:	6a 75                	push   $0x75
  jmp alltraps
8010623c:	e9 8d f6 ff ff       	jmp    801058ce <alltraps>

80106241 <vector118>:
.globl vector118
vector118:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $118
80106243:	6a 76                	push   $0x76
  jmp alltraps
80106245:	e9 84 f6 ff ff       	jmp    801058ce <alltraps>

8010624a <vector119>:
.globl vector119
vector119:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $119
8010624c:	6a 77                	push   $0x77
  jmp alltraps
8010624e:	e9 7b f6 ff ff       	jmp    801058ce <alltraps>

80106253 <vector120>:
.globl vector120
vector120:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $120
80106255:	6a 78                	push   $0x78
  jmp alltraps
80106257:	e9 72 f6 ff ff       	jmp    801058ce <alltraps>

8010625c <vector121>:
.globl vector121
vector121:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $121
8010625e:	6a 79                	push   $0x79
  jmp alltraps
80106260:	e9 69 f6 ff ff       	jmp    801058ce <alltraps>

80106265 <vector122>:
.globl vector122
vector122:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $122
80106267:	6a 7a                	push   $0x7a
  jmp alltraps
80106269:	e9 60 f6 ff ff       	jmp    801058ce <alltraps>

8010626e <vector123>:
.globl vector123
vector123:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $123
80106270:	6a 7b                	push   $0x7b
  jmp alltraps
80106272:	e9 57 f6 ff ff       	jmp    801058ce <alltraps>

80106277 <vector124>:
.globl vector124
vector124:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $124
80106279:	6a 7c                	push   $0x7c
  jmp alltraps
8010627b:	e9 4e f6 ff ff       	jmp    801058ce <alltraps>

80106280 <vector125>:
.globl vector125
vector125:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $125
80106282:	6a 7d                	push   $0x7d
  jmp alltraps
80106284:	e9 45 f6 ff ff       	jmp    801058ce <alltraps>

80106289 <vector126>:
.globl vector126
vector126:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $126
8010628b:	6a 7e                	push   $0x7e
  jmp alltraps
8010628d:	e9 3c f6 ff ff       	jmp    801058ce <alltraps>

80106292 <vector127>:
.globl vector127
vector127:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $127
80106294:	6a 7f                	push   $0x7f
  jmp alltraps
80106296:	e9 33 f6 ff ff       	jmp    801058ce <alltraps>

8010629b <vector128>:
.globl vector128
vector128:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $128
8010629d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801062a2:	e9 27 f6 ff ff       	jmp    801058ce <alltraps>

801062a7 <vector129>:
.globl vector129
vector129:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $129
801062a9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801062ae:	e9 1b f6 ff ff       	jmp    801058ce <alltraps>

801062b3 <vector130>:
.globl vector130
vector130:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $130
801062b5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062ba:	e9 0f f6 ff ff       	jmp    801058ce <alltraps>

801062bf <vector131>:
.globl vector131
vector131:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $131
801062c1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062c6:	e9 03 f6 ff ff       	jmp    801058ce <alltraps>

801062cb <vector132>:
.globl vector132
vector132:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $132
801062cd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062d2:	e9 f7 f5 ff ff       	jmp    801058ce <alltraps>

801062d7 <vector133>:
.globl vector133
vector133:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $133
801062d9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062de:	e9 eb f5 ff ff       	jmp    801058ce <alltraps>

801062e3 <vector134>:
.globl vector134
vector134:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $134
801062e5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062ea:	e9 df f5 ff ff       	jmp    801058ce <alltraps>

801062ef <vector135>:
.globl vector135
vector135:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $135
801062f1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062f6:	e9 d3 f5 ff ff       	jmp    801058ce <alltraps>

801062fb <vector136>:
.globl vector136
vector136:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $136
801062fd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106302:	e9 c7 f5 ff ff       	jmp    801058ce <alltraps>

80106307 <vector137>:
.globl vector137
vector137:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $137
80106309:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010630e:	e9 bb f5 ff ff       	jmp    801058ce <alltraps>

80106313 <vector138>:
.globl vector138
vector138:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $138
80106315:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010631a:	e9 af f5 ff ff       	jmp    801058ce <alltraps>

8010631f <vector139>:
.globl vector139
vector139:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $139
80106321:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106326:	e9 a3 f5 ff ff       	jmp    801058ce <alltraps>

8010632b <vector140>:
.globl vector140
vector140:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $140
8010632d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106332:	e9 97 f5 ff ff       	jmp    801058ce <alltraps>

80106337 <vector141>:
.globl vector141
vector141:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $141
80106339:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010633e:	e9 8b f5 ff ff       	jmp    801058ce <alltraps>

80106343 <vector142>:
.globl vector142
vector142:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $142
80106345:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010634a:	e9 7f f5 ff ff       	jmp    801058ce <alltraps>

8010634f <vector143>:
.globl vector143
vector143:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $143
80106351:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106356:	e9 73 f5 ff ff       	jmp    801058ce <alltraps>

8010635b <vector144>:
.globl vector144
vector144:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $144
8010635d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106362:	e9 67 f5 ff ff       	jmp    801058ce <alltraps>

80106367 <vector145>:
.globl vector145
vector145:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $145
80106369:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010636e:	e9 5b f5 ff ff       	jmp    801058ce <alltraps>

80106373 <vector146>:
.globl vector146
vector146:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $146
80106375:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010637a:	e9 4f f5 ff ff       	jmp    801058ce <alltraps>

8010637f <vector147>:
.globl vector147
vector147:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $147
80106381:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106386:	e9 43 f5 ff ff       	jmp    801058ce <alltraps>

8010638b <vector148>:
.globl vector148
vector148:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $148
8010638d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106392:	e9 37 f5 ff ff       	jmp    801058ce <alltraps>

80106397 <vector149>:
.globl vector149
vector149:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $149
80106399:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010639e:	e9 2b f5 ff ff       	jmp    801058ce <alltraps>

801063a3 <vector150>:
.globl vector150
vector150:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $150
801063a5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801063aa:	e9 1f f5 ff ff       	jmp    801058ce <alltraps>

801063af <vector151>:
.globl vector151
vector151:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $151
801063b1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063b6:	e9 13 f5 ff ff       	jmp    801058ce <alltraps>

801063bb <vector152>:
.globl vector152
vector152:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $152
801063bd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063c2:	e9 07 f5 ff ff       	jmp    801058ce <alltraps>

801063c7 <vector153>:
.globl vector153
vector153:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $153
801063c9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063ce:	e9 fb f4 ff ff       	jmp    801058ce <alltraps>

801063d3 <vector154>:
.globl vector154
vector154:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $154
801063d5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063da:	e9 ef f4 ff ff       	jmp    801058ce <alltraps>

801063df <vector155>:
.globl vector155
vector155:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $155
801063e1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063e6:	e9 e3 f4 ff ff       	jmp    801058ce <alltraps>

801063eb <vector156>:
.globl vector156
vector156:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $156
801063ed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063f2:	e9 d7 f4 ff ff       	jmp    801058ce <alltraps>

801063f7 <vector157>:
.globl vector157
vector157:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $157
801063f9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063fe:	e9 cb f4 ff ff       	jmp    801058ce <alltraps>

80106403 <vector158>:
.globl vector158
vector158:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $158
80106405:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010640a:	e9 bf f4 ff ff       	jmp    801058ce <alltraps>

8010640f <vector159>:
.globl vector159
vector159:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $159
80106411:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106416:	e9 b3 f4 ff ff       	jmp    801058ce <alltraps>

8010641b <vector160>:
.globl vector160
vector160:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $160
8010641d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106422:	e9 a7 f4 ff ff       	jmp    801058ce <alltraps>

80106427 <vector161>:
.globl vector161
vector161:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $161
80106429:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010642e:	e9 9b f4 ff ff       	jmp    801058ce <alltraps>

80106433 <vector162>:
.globl vector162
vector162:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $162
80106435:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010643a:	e9 8f f4 ff ff       	jmp    801058ce <alltraps>

8010643f <vector163>:
.globl vector163
vector163:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $163
80106441:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106446:	e9 83 f4 ff ff       	jmp    801058ce <alltraps>

8010644b <vector164>:
.globl vector164
vector164:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $164
8010644d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106452:	e9 77 f4 ff ff       	jmp    801058ce <alltraps>

80106457 <vector165>:
.globl vector165
vector165:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $165
80106459:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010645e:	e9 6b f4 ff ff       	jmp    801058ce <alltraps>

80106463 <vector166>:
.globl vector166
vector166:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $166
80106465:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010646a:	e9 5f f4 ff ff       	jmp    801058ce <alltraps>

8010646f <vector167>:
.globl vector167
vector167:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $167
80106471:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106476:	e9 53 f4 ff ff       	jmp    801058ce <alltraps>

8010647b <vector168>:
.globl vector168
vector168:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $168
8010647d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106482:	e9 47 f4 ff ff       	jmp    801058ce <alltraps>

80106487 <vector169>:
.globl vector169
vector169:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $169
80106489:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010648e:	e9 3b f4 ff ff       	jmp    801058ce <alltraps>

80106493 <vector170>:
.globl vector170
vector170:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $170
80106495:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010649a:	e9 2f f4 ff ff       	jmp    801058ce <alltraps>

8010649f <vector171>:
.globl vector171
vector171:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $171
801064a1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801064a6:	e9 23 f4 ff ff       	jmp    801058ce <alltraps>

801064ab <vector172>:
.globl vector172
vector172:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $172
801064ad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064b2:	e9 17 f4 ff ff       	jmp    801058ce <alltraps>

801064b7 <vector173>:
.globl vector173
vector173:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $173
801064b9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064be:	e9 0b f4 ff ff       	jmp    801058ce <alltraps>

801064c3 <vector174>:
.globl vector174
vector174:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $174
801064c5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064ca:	e9 ff f3 ff ff       	jmp    801058ce <alltraps>

801064cf <vector175>:
.globl vector175
vector175:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $175
801064d1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064d6:	e9 f3 f3 ff ff       	jmp    801058ce <alltraps>

801064db <vector176>:
.globl vector176
vector176:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $176
801064dd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064e2:	e9 e7 f3 ff ff       	jmp    801058ce <alltraps>

801064e7 <vector177>:
.globl vector177
vector177:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $177
801064e9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064ee:	e9 db f3 ff ff       	jmp    801058ce <alltraps>

801064f3 <vector178>:
.globl vector178
vector178:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $178
801064f5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064fa:	e9 cf f3 ff ff       	jmp    801058ce <alltraps>

801064ff <vector179>:
.globl vector179
vector179:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $179
80106501:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106506:	e9 c3 f3 ff ff       	jmp    801058ce <alltraps>

8010650b <vector180>:
.globl vector180
vector180:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $180
8010650d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106512:	e9 b7 f3 ff ff       	jmp    801058ce <alltraps>

80106517 <vector181>:
.globl vector181
vector181:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $181
80106519:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010651e:	e9 ab f3 ff ff       	jmp    801058ce <alltraps>

80106523 <vector182>:
.globl vector182
vector182:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $182
80106525:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010652a:	e9 9f f3 ff ff       	jmp    801058ce <alltraps>

8010652f <vector183>:
.globl vector183
vector183:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $183
80106531:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106536:	e9 93 f3 ff ff       	jmp    801058ce <alltraps>

8010653b <vector184>:
.globl vector184
vector184:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $184
8010653d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106542:	e9 87 f3 ff ff       	jmp    801058ce <alltraps>

80106547 <vector185>:
.globl vector185
vector185:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $185
80106549:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010654e:	e9 7b f3 ff ff       	jmp    801058ce <alltraps>

80106553 <vector186>:
.globl vector186
vector186:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $186
80106555:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010655a:	e9 6f f3 ff ff       	jmp    801058ce <alltraps>

8010655f <vector187>:
.globl vector187
vector187:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $187
80106561:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106566:	e9 63 f3 ff ff       	jmp    801058ce <alltraps>

8010656b <vector188>:
.globl vector188
vector188:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $188
8010656d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106572:	e9 57 f3 ff ff       	jmp    801058ce <alltraps>

80106577 <vector189>:
.globl vector189
vector189:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $189
80106579:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010657e:	e9 4b f3 ff ff       	jmp    801058ce <alltraps>

80106583 <vector190>:
.globl vector190
vector190:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $190
80106585:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010658a:	e9 3f f3 ff ff       	jmp    801058ce <alltraps>

8010658f <vector191>:
.globl vector191
vector191:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $191
80106591:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106596:	e9 33 f3 ff ff       	jmp    801058ce <alltraps>

8010659b <vector192>:
.globl vector192
vector192:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $192
8010659d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801065a2:	e9 27 f3 ff ff       	jmp    801058ce <alltraps>

801065a7 <vector193>:
.globl vector193
vector193:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $193
801065a9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801065ae:	e9 1b f3 ff ff       	jmp    801058ce <alltraps>

801065b3 <vector194>:
.globl vector194
vector194:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $194
801065b5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065ba:	e9 0f f3 ff ff       	jmp    801058ce <alltraps>

801065bf <vector195>:
.globl vector195
vector195:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $195
801065c1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065c6:	e9 03 f3 ff ff       	jmp    801058ce <alltraps>

801065cb <vector196>:
.globl vector196
vector196:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $196
801065cd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065d2:	e9 f7 f2 ff ff       	jmp    801058ce <alltraps>

801065d7 <vector197>:
.globl vector197
vector197:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $197
801065d9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065de:	e9 eb f2 ff ff       	jmp    801058ce <alltraps>

801065e3 <vector198>:
.globl vector198
vector198:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $198
801065e5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065ea:	e9 df f2 ff ff       	jmp    801058ce <alltraps>

801065ef <vector199>:
.globl vector199
vector199:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $199
801065f1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065f6:	e9 d3 f2 ff ff       	jmp    801058ce <alltraps>

801065fb <vector200>:
.globl vector200
vector200:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $200
801065fd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106602:	e9 c7 f2 ff ff       	jmp    801058ce <alltraps>

80106607 <vector201>:
.globl vector201
vector201:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $201
80106609:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010660e:	e9 bb f2 ff ff       	jmp    801058ce <alltraps>

80106613 <vector202>:
.globl vector202
vector202:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $202
80106615:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010661a:	e9 af f2 ff ff       	jmp    801058ce <alltraps>

8010661f <vector203>:
.globl vector203
vector203:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $203
80106621:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106626:	e9 a3 f2 ff ff       	jmp    801058ce <alltraps>

8010662b <vector204>:
.globl vector204
vector204:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $204
8010662d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106632:	e9 97 f2 ff ff       	jmp    801058ce <alltraps>

80106637 <vector205>:
.globl vector205
vector205:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $205
80106639:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010663e:	e9 8b f2 ff ff       	jmp    801058ce <alltraps>

80106643 <vector206>:
.globl vector206
vector206:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $206
80106645:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010664a:	e9 7f f2 ff ff       	jmp    801058ce <alltraps>

8010664f <vector207>:
.globl vector207
vector207:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $207
80106651:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106656:	e9 73 f2 ff ff       	jmp    801058ce <alltraps>

8010665b <vector208>:
.globl vector208
vector208:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $208
8010665d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106662:	e9 67 f2 ff ff       	jmp    801058ce <alltraps>

80106667 <vector209>:
.globl vector209
vector209:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $209
80106669:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010666e:	e9 5b f2 ff ff       	jmp    801058ce <alltraps>

80106673 <vector210>:
.globl vector210
vector210:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $210
80106675:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010667a:	e9 4f f2 ff ff       	jmp    801058ce <alltraps>

8010667f <vector211>:
.globl vector211
vector211:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $211
80106681:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106686:	e9 43 f2 ff ff       	jmp    801058ce <alltraps>

8010668b <vector212>:
.globl vector212
vector212:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $212
8010668d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106692:	e9 37 f2 ff ff       	jmp    801058ce <alltraps>

80106697 <vector213>:
.globl vector213
vector213:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $213
80106699:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010669e:	e9 2b f2 ff ff       	jmp    801058ce <alltraps>

801066a3 <vector214>:
.globl vector214
vector214:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $214
801066a5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801066aa:	e9 1f f2 ff ff       	jmp    801058ce <alltraps>

801066af <vector215>:
.globl vector215
vector215:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $215
801066b1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066b6:	e9 13 f2 ff ff       	jmp    801058ce <alltraps>

801066bb <vector216>:
.globl vector216
vector216:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $216
801066bd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066c2:	e9 07 f2 ff ff       	jmp    801058ce <alltraps>

801066c7 <vector217>:
.globl vector217
vector217:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $217
801066c9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066ce:	e9 fb f1 ff ff       	jmp    801058ce <alltraps>

801066d3 <vector218>:
.globl vector218
vector218:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $218
801066d5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066da:	e9 ef f1 ff ff       	jmp    801058ce <alltraps>

801066df <vector219>:
.globl vector219
vector219:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $219
801066e1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066e6:	e9 e3 f1 ff ff       	jmp    801058ce <alltraps>

801066eb <vector220>:
.globl vector220
vector220:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $220
801066ed:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066f2:	e9 d7 f1 ff ff       	jmp    801058ce <alltraps>

801066f7 <vector221>:
.globl vector221
vector221:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $221
801066f9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066fe:	e9 cb f1 ff ff       	jmp    801058ce <alltraps>

80106703 <vector222>:
.globl vector222
vector222:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $222
80106705:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010670a:	e9 bf f1 ff ff       	jmp    801058ce <alltraps>

8010670f <vector223>:
.globl vector223
vector223:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $223
80106711:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106716:	e9 b3 f1 ff ff       	jmp    801058ce <alltraps>

8010671b <vector224>:
.globl vector224
vector224:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $224
8010671d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106722:	e9 a7 f1 ff ff       	jmp    801058ce <alltraps>

80106727 <vector225>:
.globl vector225
vector225:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $225
80106729:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010672e:	e9 9b f1 ff ff       	jmp    801058ce <alltraps>

80106733 <vector226>:
.globl vector226
vector226:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $226
80106735:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010673a:	e9 8f f1 ff ff       	jmp    801058ce <alltraps>

8010673f <vector227>:
.globl vector227
vector227:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $227
80106741:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106746:	e9 83 f1 ff ff       	jmp    801058ce <alltraps>

8010674b <vector228>:
.globl vector228
vector228:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $228
8010674d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106752:	e9 77 f1 ff ff       	jmp    801058ce <alltraps>

80106757 <vector229>:
.globl vector229
vector229:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $229
80106759:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010675e:	e9 6b f1 ff ff       	jmp    801058ce <alltraps>

80106763 <vector230>:
.globl vector230
vector230:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $230
80106765:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010676a:	e9 5f f1 ff ff       	jmp    801058ce <alltraps>

8010676f <vector231>:
.globl vector231
vector231:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $231
80106771:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106776:	e9 53 f1 ff ff       	jmp    801058ce <alltraps>

8010677b <vector232>:
.globl vector232
vector232:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $232
8010677d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106782:	e9 47 f1 ff ff       	jmp    801058ce <alltraps>

80106787 <vector233>:
.globl vector233
vector233:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $233
80106789:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010678e:	e9 3b f1 ff ff       	jmp    801058ce <alltraps>

80106793 <vector234>:
.globl vector234
vector234:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $234
80106795:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010679a:	e9 2f f1 ff ff       	jmp    801058ce <alltraps>

8010679f <vector235>:
.globl vector235
vector235:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $235
801067a1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801067a6:	e9 23 f1 ff ff       	jmp    801058ce <alltraps>

801067ab <vector236>:
.globl vector236
vector236:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $236
801067ad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067b2:	e9 17 f1 ff ff       	jmp    801058ce <alltraps>

801067b7 <vector237>:
.globl vector237
vector237:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $237
801067b9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067be:	e9 0b f1 ff ff       	jmp    801058ce <alltraps>

801067c3 <vector238>:
.globl vector238
vector238:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $238
801067c5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067ca:	e9 ff f0 ff ff       	jmp    801058ce <alltraps>

801067cf <vector239>:
.globl vector239
vector239:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $239
801067d1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067d6:	e9 f3 f0 ff ff       	jmp    801058ce <alltraps>

801067db <vector240>:
.globl vector240
vector240:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $240
801067dd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067e2:	e9 e7 f0 ff ff       	jmp    801058ce <alltraps>

801067e7 <vector241>:
.globl vector241
vector241:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $241
801067e9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067ee:	e9 db f0 ff ff       	jmp    801058ce <alltraps>

801067f3 <vector242>:
.globl vector242
vector242:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $242
801067f5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067fa:	e9 cf f0 ff ff       	jmp    801058ce <alltraps>

801067ff <vector243>:
.globl vector243
vector243:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $243
80106801:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106806:	e9 c3 f0 ff ff       	jmp    801058ce <alltraps>

8010680b <vector244>:
.globl vector244
vector244:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $244
8010680d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106812:	e9 b7 f0 ff ff       	jmp    801058ce <alltraps>

80106817 <vector245>:
.globl vector245
vector245:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $245
80106819:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010681e:	e9 ab f0 ff ff       	jmp    801058ce <alltraps>

80106823 <vector246>:
.globl vector246
vector246:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $246
80106825:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010682a:	e9 9f f0 ff ff       	jmp    801058ce <alltraps>

8010682f <vector247>:
.globl vector247
vector247:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $247
80106831:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106836:	e9 93 f0 ff ff       	jmp    801058ce <alltraps>

8010683b <vector248>:
.globl vector248
vector248:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $248
8010683d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106842:	e9 87 f0 ff ff       	jmp    801058ce <alltraps>

80106847 <vector249>:
.globl vector249
vector249:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $249
80106849:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010684e:	e9 7b f0 ff ff       	jmp    801058ce <alltraps>

80106853 <vector250>:
.globl vector250
vector250:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $250
80106855:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010685a:	e9 6f f0 ff ff       	jmp    801058ce <alltraps>

8010685f <vector251>:
.globl vector251
vector251:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $251
80106861:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106866:	e9 63 f0 ff ff       	jmp    801058ce <alltraps>

8010686b <vector252>:
.globl vector252
vector252:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $252
8010686d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106872:	e9 57 f0 ff ff       	jmp    801058ce <alltraps>

80106877 <vector253>:
.globl vector253
vector253:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $253
80106879:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010687e:	e9 4b f0 ff ff       	jmp    801058ce <alltraps>

80106883 <vector254>:
.globl vector254
vector254:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $254
80106885:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010688a:	e9 3f f0 ff ff       	jmp    801058ce <alltraps>

8010688f <vector255>:
.globl vector255
vector255:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $255
80106891:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106896:	e9 33 f0 ff ff       	jmp    801058ce <alltraps>
8010689b:	66 90                	xchg   %ax,%ax
8010689d:	66 90                	xchg   %ax,%ax
8010689f:	90                   	nop

801068a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	57                   	push   %edi
801068a4:	56                   	push   %esi
801068a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801068a7:	c1 ea 16             	shr    $0x16,%edx
{
801068aa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801068ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801068ae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801068b1:	8b 1f                	mov    (%edi),%ebx
801068b3:	f6 c3 01             	test   $0x1,%bl
801068b6:	74 28                	je     801068e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801068be:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801068c4:	89 f0                	mov    %esi,%eax
}
801068c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801068c9:	c1 e8 0a             	shr    $0xa,%eax
801068cc:	25 fc 0f 00 00       	and    $0xffc,%eax
801068d1:	01 d8                	add    %ebx,%eax
}
801068d3:	5b                   	pop    %ebx
801068d4:	5e                   	pop    %esi
801068d5:	5f                   	pop    %edi
801068d6:	5d                   	pop    %ebp
801068d7:	c3                   	ret    
801068d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068df:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801068e0:	85 c9                	test   %ecx,%ecx
801068e2:	74 2c                	je     80106910 <walkpgdir+0x70>
801068e4:	e8 47 bd ff ff       	call   80102630 <kalloc>
801068e9:	89 c3                	mov    %eax,%ebx
801068eb:	85 c0                	test   %eax,%eax
801068ed:	74 21                	je     80106910 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801068ef:	83 ec 04             	sub    $0x4,%esp
801068f2:	68 00 10 00 00       	push   $0x1000
801068f7:	6a 00                	push   $0x0
801068f9:	50                   	push   %eax
801068fa:	e8 61 dd ff ff       	call   80104660 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801068ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106905:	83 c4 10             	add    $0x10,%esp
80106908:	83 c8 07             	or     $0x7,%eax
8010690b:	89 07                	mov    %eax,(%edi)
8010690d:	eb b5                	jmp    801068c4 <walkpgdir+0x24>
8010690f:	90                   	nop
}
80106910:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106913:	31 c0                	xor    %eax,%eax
}
80106915:	5b                   	pop    %ebx
80106916:	5e                   	pop    %esi
80106917:	5f                   	pop    %edi
80106918:	5d                   	pop    %ebp
80106919:	c3                   	ret    
8010691a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106920 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	57                   	push   %edi
80106924:	56                   	push   %esi
80106925:	89 c6                	mov    %eax,%esi
80106927:	53                   	push   %ebx
80106928:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010692a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106930:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106936:	83 ec 1c             	sub    $0x1c,%esp
80106939:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010693c:	39 da                	cmp    %ebx,%edx
8010693e:	73 5b                	jae    8010699b <deallocuvm.part.0+0x7b>
80106940:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106943:	89 d7                	mov    %edx,%edi
80106945:	eb 14                	jmp    8010695b <deallocuvm.part.0+0x3b>
80106947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010694e:	66 90                	xchg   %ax,%ax
80106950:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106956:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106959:	76 40                	jbe    8010699b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010695b:	31 c9                	xor    %ecx,%ecx
8010695d:	89 fa                	mov    %edi,%edx
8010695f:	89 f0                	mov    %esi,%eax
80106961:	e8 3a ff ff ff       	call   801068a0 <walkpgdir>
80106966:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106968:	85 c0                	test   %eax,%eax
8010696a:	74 44                	je     801069b0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010696c:	8b 00                	mov    (%eax),%eax
8010696e:	a8 01                	test   $0x1,%al
80106970:	74 de                	je     80106950 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106972:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106977:	74 47                	je     801069c0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106979:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010697c:	05 00 00 00 80       	add    $0x80000000,%eax
80106981:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106987:	50                   	push   %eax
80106988:	e8 e3 ba ff ff       	call   80102470 <kfree>
      *pte = 0;
8010698d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106993:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106996:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106999:	77 c0                	ja     8010695b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010699b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010699e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069a1:	5b                   	pop    %ebx
801069a2:	5e                   	pop    %esi
801069a3:	5f                   	pop    %edi
801069a4:	5d                   	pop    %ebp
801069a5:	c3                   	ret    
801069a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ad:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069b0:	89 fa                	mov    %edi,%edx
801069b2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801069b8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801069be:	eb 96                	jmp    80106956 <deallocuvm.part.0+0x36>
        panic("kfree");
801069c0:	83 ec 0c             	sub    $0xc,%esp
801069c3:	68 a6 75 10 80       	push   $0x801075a6
801069c8:	e8 c3 99 ff ff       	call   80100390 <panic>
801069cd:	8d 76 00             	lea    0x0(%esi),%esi

801069d0 <seginit>:
{
801069d0:	f3 0f 1e fb          	endbr32 
801069d4:	55                   	push   %ebp
801069d5:	89 e5                	mov    %esp,%ebp
801069d7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069da:	e8 71 cf ff ff       	call   80103950 <cpuid>
  pd[0] = size-1;
801069df:	ba 2f 00 00 00       	mov    $0x2f,%edx
801069e4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069ea:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069ee:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
801069f5:	ff 00 00 
801069f8:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801069ff:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a02:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106a09:	ff 00 00 
80106a0c:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106a13:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a16:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106a1d:	ff 00 00 
80106a20:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106a27:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a2a:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106a31:	ff 00 00 
80106a34:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106a3b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a3e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106a43:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a47:	c1 e8 10             	shr    $0x10,%eax
80106a4a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a4e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a51:	0f 01 10             	lgdtl  (%eax)
}
80106a54:	c9                   	leave  
80106a55:	c3                   	ret    
80106a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a5d:	8d 76 00             	lea    0x0(%esi),%esi

80106a60 <mappages>:
{
80106a60:	f3 0f 1e fb          	endbr32 
80106a64:	55                   	push   %ebp
80106a65:	89 e5                	mov    %esp,%ebp
80106a67:	57                   	push   %edi
80106a68:	56                   	push   %esi
80106a69:	53                   	push   %ebx
80106a6a:	83 ec 1c             	sub    $0x1c,%esp
80106a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a70:	8b 4d 10             	mov    0x10(%ebp),%ecx
{
80106a73:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
80106a76:	89 c6                	mov    %eax,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a78:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
80106a7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106a81:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a87:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a8a:	8b 45 14             	mov    0x14(%ebp),%eax
80106a8d:	29 f0                	sub    %esi,%eax
80106a8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a92:	eb 1c                	jmp    80106ab0 <mappages+0x50>
80106a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*pte & PTE_P)
80106a98:	f6 00 01             	testb  $0x1,(%eax)
80106a9b:	75 45                	jne    80106ae2 <mappages+0x82>
    *pte = pa | perm | PTE_P;
80106a9d:	0b 5d 18             	or     0x18(%ebp),%ebx
80106aa0:	83 cb 01             	or     $0x1,%ebx
80106aa3:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106aa5:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106aa8:	74 2e                	je     80106ad8 <mappages+0x78>
    a += PGSIZE;
80106aaa:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ab3:	b9 01 00 00 00       	mov    $0x1,%ecx
80106ab8:	89 f2                	mov    %esi,%edx
80106aba:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106abd:	89 f8                	mov    %edi,%eax
80106abf:	e8 dc fd ff ff       	call   801068a0 <walkpgdir>
80106ac4:	85 c0                	test   %eax,%eax
80106ac6:	75 d0                	jne    80106a98 <mappages+0x38>
}
80106ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106acb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ad0:	5b                   	pop    %ebx
80106ad1:	5e                   	pop    %esi
80106ad2:	5f                   	pop    %edi
80106ad3:	5d                   	pop    %ebp
80106ad4:	c3                   	ret    
80106ad5:	8d 76 00             	lea    0x0(%esi),%esi
80106ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106adb:	31 c0                	xor    %eax,%eax
}
80106add:	5b                   	pop    %ebx
80106ade:	5e                   	pop    %esi
80106adf:	5f                   	pop    %edi
80106ae0:	5d                   	pop    %ebp
80106ae1:	c3                   	ret    
      panic("remap");
80106ae2:	83 ec 0c             	sub    $0xc,%esp
80106ae5:	68 50 7c 10 80       	push   $0x80107c50
80106aea:	e8 a1 98 ff ff       	call   80100390 <panic>
80106aef:	90                   	nop

80106af0 <switchkvm>:
{
80106af0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106af4:	a1 a4 55 11 80       	mov    0x801155a4,%eax
80106af9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106afe:	0f 22 d8             	mov    %eax,%cr3
}
80106b01:	c3                   	ret    
80106b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b10 <switchuvm>:
{
80106b10:	f3 0f 1e fb          	endbr32 
80106b14:	55                   	push   %ebp
80106b15:	89 e5                	mov    %esp,%ebp
80106b17:	57                   	push   %edi
80106b18:	56                   	push   %esi
80106b19:	53                   	push   %ebx
80106b1a:	83 ec 1c             	sub    $0x1c,%esp
80106b1d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b20:	85 f6                	test   %esi,%esi
80106b22:	0f 84 cb 00 00 00    	je     80106bf3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106b28:	8b 46 08             	mov    0x8(%esi),%eax
80106b2b:	85 c0                	test   %eax,%eax
80106b2d:	0f 84 da 00 00 00    	je     80106c0d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106b33:	8b 46 04             	mov    0x4(%esi),%eax
80106b36:	85 c0                	test   %eax,%eax
80106b38:	0f 84 c2 00 00 00    	je     80106c00 <switchuvm+0xf0>
  pushcli();
80106b3e:	e8 4d d9 ff ff       	call   80104490 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b43:	e8 98 cd ff ff       	call   801038e0 <mycpu>
80106b48:	89 c3                	mov    %eax,%ebx
80106b4a:	e8 91 cd ff ff       	call   801038e0 <mycpu>
80106b4f:	89 c7                	mov    %eax,%edi
80106b51:	e8 8a cd ff ff       	call   801038e0 <mycpu>
80106b56:	83 c7 08             	add    $0x8,%edi
80106b59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b5c:	e8 7f cd ff ff       	call   801038e0 <mycpu>
80106b61:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b64:	ba 67 00 00 00       	mov    $0x67,%edx
80106b69:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b70:	83 c0 08             	add    $0x8,%eax
80106b73:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b7a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b7f:	83 c1 08             	add    $0x8,%ecx
80106b82:	c1 e8 18             	shr    $0x18,%eax
80106b85:	c1 e9 10             	shr    $0x10,%ecx
80106b88:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106b8e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b94:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b99:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ba0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ba5:	e8 36 cd ff ff       	call   801038e0 <mycpu>
80106baa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bb1:	e8 2a cd ff ff       	call   801038e0 <mycpu>
80106bb6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106bba:	8b 5e 08             	mov    0x8(%esi),%ebx
80106bbd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bc3:	e8 18 cd ff ff       	call   801038e0 <mycpu>
80106bc8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bcb:	e8 10 cd ff ff       	call   801038e0 <mycpu>
80106bd0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106bd4:	b8 28 00 00 00       	mov    $0x28,%eax
80106bd9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106bdc:	8b 46 04             	mov    0x4(%esi),%eax
80106bdf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106be4:	0f 22 d8             	mov    %eax,%cr3
}
80106be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bea:	5b                   	pop    %ebx
80106beb:	5e                   	pop    %esi
80106bec:	5f                   	pop    %edi
80106bed:	5d                   	pop    %ebp
  popcli();
80106bee:	e9 bd d9 ff ff       	jmp    801045b0 <popcli>
    panic("switchuvm: no process");
80106bf3:	83 ec 0c             	sub    $0xc,%esp
80106bf6:	68 56 7c 10 80       	push   $0x80107c56
80106bfb:	e8 90 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106c00:	83 ec 0c             	sub    $0xc,%esp
80106c03:	68 81 7c 10 80       	push   $0x80107c81
80106c08:	e8 83 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106c0d:	83 ec 0c             	sub    $0xc,%esp
80106c10:	68 6c 7c 10 80       	push   $0x80107c6c
80106c15:	e8 76 97 ff ff       	call   80100390 <panic>
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c20 <inituvm>:
{
80106c20:	f3 0f 1e fb          	endbr32 
80106c24:	55                   	push   %ebp
80106c25:	89 e5                	mov    %esp,%ebp
80106c27:	57                   	push   %edi
80106c28:	56                   	push   %esi
80106c29:	53                   	push   %ebx
80106c2a:	83 ec 1c             	sub    $0x1c,%esp
80106c2d:	8b 75 10             	mov    0x10(%ebp),%esi
80106c30:	8b 55 08             	mov    0x8(%ebp),%edx
80106c33:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106c36:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c3c:	77 50                	ja     80106c8e <inituvm+0x6e>
80106c3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80106c41:	e8 ea b9 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80106c46:	83 ec 04             	sub    $0x4,%esp
80106c49:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106c4e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c50:	6a 00                	push   $0x0
80106c52:	50                   	push   %eax
80106c53:	e8 08 da ff ff       	call   80104660 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c5b:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c61:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106c68:	50                   	push   %eax
80106c69:	68 00 10 00 00       	push   $0x1000
80106c6e:	6a 00                	push   $0x0
80106c70:	52                   	push   %edx
80106c71:	e8 ea fd ff ff       	call   80106a60 <mappages>
  memmove(mem, init, sz);
80106c76:	89 75 10             	mov    %esi,0x10(%ebp)
80106c79:	83 c4 20             	add    $0x20,%esp
80106c7c:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c89:	e9 72 da ff ff       	jmp    80104700 <memmove>
    panic("inituvm: more than a page");
80106c8e:	83 ec 0c             	sub    $0xc,%esp
80106c91:	68 95 7c 10 80       	push   $0x80107c95
80106c96:	e8 f5 96 ff ff       	call   80100390 <panic>
80106c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c9f:	90                   	nop

80106ca0 <loaduvm>:
{
80106ca0:	f3 0f 1e fb          	endbr32 
80106ca4:	55                   	push   %ebp
80106ca5:	89 e5                	mov    %esp,%ebp
80106ca7:	57                   	push   %edi
80106ca8:	56                   	push   %esi
80106ca9:	53                   	push   %ebx
80106caa:	83 ec 1c             	sub    $0x1c,%esp
80106cad:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cb0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106cb3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106cb8:	0f 85 99 00 00 00    	jne    80106d57 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106cbe:	01 f0                	add    %esi,%eax
80106cc0:	89 f3                	mov    %esi,%ebx
80106cc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cc5:	8b 45 14             	mov    0x14(%ebp),%eax
80106cc8:	01 f0                	add    %esi,%eax
80106cca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ccd:	85 f6                	test   %esi,%esi
80106ccf:	75 15                	jne    80106ce6 <loaduvm+0x46>
80106cd1:	eb 6d                	jmp    80106d40 <loaduvm+0xa0>
80106cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cd7:	90                   	nop
80106cd8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106cde:	89 f0                	mov    %esi,%eax
80106ce0:	29 d8                	sub    %ebx,%eax
80106ce2:	39 c6                	cmp    %eax,%esi
80106ce4:	76 5a                	jbe    80106d40 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ce6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80106cec:	31 c9                	xor    %ecx,%ecx
80106cee:	29 da                	sub    %ebx,%edx
80106cf0:	e8 ab fb ff ff       	call   801068a0 <walkpgdir>
80106cf5:	85 c0                	test   %eax,%eax
80106cf7:	74 51                	je     80106d4a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106cf9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cfb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106cfe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106d03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d08:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106d0e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d11:	29 d9                	sub    %ebx,%ecx
80106d13:	05 00 00 00 80       	add    $0x80000000,%eax
80106d18:	57                   	push   %edi
80106d19:	51                   	push   %ecx
80106d1a:	50                   	push   %eax
80106d1b:	ff 75 10             	pushl  0x10(%ebp)
80106d1e:	e8 3d ad ff ff       	call   80101a60 <readi>
80106d23:	83 c4 10             	add    $0x10,%esp
80106d26:	39 f8                	cmp    %edi,%eax
80106d28:	74 ae                	je     80106cd8 <loaduvm+0x38>
}
80106d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d32:	5b                   	pop    %ebx
80106d33:	5e                   	pop    %esi
80106d34:	5f                   	pop    %edi
80106d35:	5d                   	pop    %ebp
80106d36:	c3                   	ret    
80106d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3e:	66 90                	xchg   %ax,%ax
80106d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d43:	31 c0                	xor    %eax,%eax
}
80106d45:	5b                   	pop    %ebx
80106d46:	5e                   	pop    %esi
80106d47:	5f                   	pop    %edi
80106d48:	5d                   	pop    %ebp
80106d49:	c3                   	ret    
      panic("loaduvm: address should exist");
80106d4a:	83 ec 0c             	sub    $0xc,%esp
80106d4d:	68 af 7c 10 80       	push   $0x80107caf
80106d52:	e8 39 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106d57:	83 ec 0c             	sub    $0xc,%esp
80106d5a:	68 50 7d 10 80       	push   $0x80107d50
80106d5f:	e8 2c 96 ff ff       	call   80100390 <panic>
80106d64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d6f:	90                   	nop

80106d70 <allocuvm>:
{
80106d70:	f3 0f 1e fb          	endbr32 
80106d74:	55                   	push   %ebp
80106d75:	89 e5                	mov    %esp,%ebp
80106d77:	57                   	push   %edi
80106d78:	56                   	push   %esi
80106d79:	53                   	push   %ebx
80106d7a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d7d:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d80:	85 ff                	test   %edi,%edi
80106d82:	0f 88 c0 00 00 00    	js     80106e48 <allocuvm+0xd8>
  if(newsz < oldsz)
80106d88:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d8b:	0f 82 a7 00 00 00    	jb     80106e38 <allocuvm+0xc8>
  a = PGROUNDUP(oldsz);
80106d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d94:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d9a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106da0:	39 75 10             	cmp    %esi,0x10(%ebp)
80106da3:	0f 86 92 00 00 00    	jbe    80106e3b <allocuvm+0xcb>
80106da9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106dac:	8b 7d 08             	mov    0x8(%ebp),%edi
80106daf:	eb 47                	jmp    80106df8 <allocuvm+0x88>
80106db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106db8:	83 ec 04             	sub    $0x4,%esp
80106dbb:	68 00 10 00 00       	push   $0x1000
80106dc0:	6a 00                	push   $0x0
80106dc2:	50                   	push   %eax
80106dc3:	e8 98 d8 ff ff       	call   80104660 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106dc8:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dce:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106dd5:	50                   	push   %eax
80106dd6:	68 00 10 00 00       	push   $0x1000
80106ddb:	56                   	push   %esi
80106ddc:	57                   	push   %edi
80106ddd:	e8 7e fc ff ff       	call   80106a60 <mappages>
80106de2:	83 c4 20             	add    $0x20,%esp
80106de5:	85 c0                	test   %eax,%eax
80106de7:	78 6f                	js     80106e58 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106de9:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106def:	39 75 10             	cmp    %esi,0x10(%ebp)
80106df2:	0f 86 a0 00 00 00    	jbe    80106e98 <allocuvm+0x128>
    mem = kalloc();
80106df8:	e8 33 b8 ff ff       	call   80102630 <kalloc>
80106dfd:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106dff:	85 c0                	test   %eax,%eax
80106e01:	75 b5                	jne    80106db8 <allocuvm+0x48>
      cprintf("allocuvm out of memory\n");
80106e03:	83 ec 0c             	sub    $0xc,%esp
80106e06:	68 cd 7c 10 80       	push   $0x80107ccd
80106e0b:	e8 a0 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e10:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e13:	83 c4 10             	add    $0x10,%esp
80106e16:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e19:	74 2d                	je     80106e48 <allocuvm+0xd8>
80106e1b:	8b 55 10             	mov    0x10(%ebp),%edx
80106e1e:	89 c1                	mov    %eax,%ecx
80106e20:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106e23:	31 ff                	xor    %edi,%edi
80106e25:	e8 f6 fa ff ff       	call   80106920 <deallocuvm.part.0>
}
80106e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e2d:	89 f8                	mov    %edi,%eax
80106e2f:	5b                   	pop    %ebx
80106e30:	5e                   	pop    %esi
80106e31:	5f                   	pop    %edi
80106e32:	5d                   	pop    %ebp
80106e33:	c3                   	ret    
80106e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106e38:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106e3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e3e:	89 f8                	mov    %edi,%eax
80106e40:	5b                   	pop    %ebx
80106e41:	5e                   	pop    %esi
80106e42:	5f                   	pop    %edi
80106e43:	5d                   	pop    %ebp
80106e44:	c3                   	ret    
80106e45:	8d 76 00             	lea    0x0(%esi),%esi
80106e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106e4b:	31 ff                	xor    %edi,%edi
}
80106e4d:	5b                   	pop    %ebx
80106e4e:	89 f8                	mov    %edi,%eax
80106e50:	5e                   	pop    %esi
80106e51:	5f                   	pop    %edi
80106e52:	5d                   	pop    %ebp
80106e53:	c3                   	ret    
80106e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e58:	83 ec 0c             	sub    $0xc,%esp
80106e5b:	68 e5 7c 10 80       	push   $0x80107ce5
80106e60:	e8 4b 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e65:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e68:	83 c4 10             	add    $0x10,%esp
80106e6b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e6e:	74 0d                	je     80106e7d <allocuvm+0x10d>
80106e70:	89 c1                	mov    %eax,%ecx
80106e72:	8b 55 10             	mov    0x10(%ebp),%edx
80106e75:	8b 45 08             	mov    0x8(%ebp),%eax
80106e78:	e8 a3 fa ff ff       	call   80106920 <deallocuvm.part.0>
      kfree(mem);
80106e7d:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106e80:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106e82:	53                   	push   %ebx
80106e83:	e8 e8 b5 ff ff       	call   80102470 <kfree>
      return 0;
80106e88:	83 c4 10             	add    $0x10,%esp
}
80106e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e8e:	89 f8                	mov    %edi,%eax
80106e90:	5b                   	pop    %ebx
80106e91:	5e                   	pop    %esi
80106e92:	5f                   	pop    %edi
80106e93:	5d                   	pop    %ebp
80106e94:	c3                   	ret    
80106e95:	8d 76 00             	lea    0x0(%esi),%esi
80106e98:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9e:	5b                   	pop    %ebx
80106e9f:	5e                   	pop    %esi
80106ea0:	89 f8                	mov    %edi,%eax
80106ea2:	5f                   	pop    %edi
80106ea3:	5d                   	pop    %ebp
80106ea4:	c3                   	ret    
80106ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106eb0 <deallocuvm>:
{
80106eb0:	f3 0f 1e fb          	endbr32 
80106eb4:	55                   	push   %ebp
80106eb5:	89 e5                	mov    %esp,%ebp
80106eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eba:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106ec0:	39 d1                	cmp    %edx,%ecx
80106ec2:	73 0c                	jae    80106ed0 <deallocuvm+0x20>
}
80106ec4:	5d                   	pop    %ebp
80106ec5:	e9 56 fa ff ff       	jmp    80106920 <deallocuvm.part.0>
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ed0:	89 d0                	mov    %edx,%eax
80106ed2:	5d                   	pop    %ebp
80106ed3:	c3                   	ret    
80106ed4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106edf:	90                   	nop

80106ee0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ee0:	f3 0f 1e fb          	endbr32 
80106ee4:	55                   	push   %ebp
80106ee5:	89 e5                	mov    %esp,%ebp
80106ee7:	57                   	push   %edi
80106ee8:	56                   	push   %esi
80106ee9:	53                   	push   %ebx
80106eea:	83 ec 0c             	sub    $0xc,%esp
80106eed:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ef0:	85 f6                	test   %esi,%esi
80106ef2:	74 55                	je     80106f49 <freevm+0x69>
  if(newsz >= oldsz)
80106ef4:	31 c9                	xor    %ecx,%ecx
80106ef6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106efb:	89 f0                	mov    %esi,%eax
80106efd:	89 f3                	mov    %esi,%ebx
80106eff:	e8 1c fa ff ff       	call   80106920 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f04:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f0a:	eb 0b                	jmp    80106f17 <freevm+0x37>
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f10:	83 c3 04             	add    $0x4,%ebx
80106f13:	39 df                	cmp    %ebx,%edi
80106f15:	74 23                	je     80106f3a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f17:	8b 03                	mov    (%ebx),%eax
80106f19:	a8 01                	test   $0x1,%al
80106f1b:	74 f3                	je     80106f10 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f22:	83 ec 0c             	sub    $0xc,%esp
80106f25:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f28:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f2d:	50                   	push   %eax
80106f2e:	e8 3d b5 ff ff       	call   80102470 <kfree>
80106f33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f36:	39 df                	cmp    %ebx,%edi
80106f38:	75 dd                	jne    80106f17 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f40:	5b                   	pop    %ebx
80106f41:	5e                   	pop    %esi
80106f42:	5f                   	pop    %edi
80106f43:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f44:	e9 27 b5 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80106f49:	83 ec 0c             	sub    $0xc,%esp
80106f4c:	68 01 7d 10 80       	push   $0x80107d01
80106f51:	e8 3a 94 ff ff       	call   80100390 <panic>
80106f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f5d:	8d 76 00             	lea    0x0(%esi),%esi

80106f60 <setupkvm>:
{
80106f60:	f3 0f 1e fb          	endbr32 
80106f64:	55                   	push   %ebp
80106f65:	89 e5                	mov    %esp,%ebp
80106f67:	56                   	push   %esi
80106f68:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f69:	e8 c2 b6 ff ff       	call   80102630 <kalloc>
80106f6e:	89 c6                	mov    %eax,%esi
80106f70:	85 c0                	test   %eax,%eax
80106f72:	74 42                	je     80106fb6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106f74:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f77:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f7c:	68 00 10 00 00       	push   $0x1000
80106f81:	6a 00                	push   $0x0
80106f83:	50                   	push   %eax
80106f84:	e8 d7 d6 ff ff       	call   80104660 <memset>
80106f89:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f8c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f8f:	8b 53 08             	mov    0x8(%ebx),%edx
80106f92:	83 ec 0c             	sub    $0xc,%esp
80106f95:	ff 73 0c             	pushl  0xc(%ebx)
80106f98:	29 c2                	sub    %eax,%edx
80106f9a:	50                   	push   %eax
80106f9b:	52                   	push   %edx
80106f9c:	ff 33                	pushl  (%ebx)
80106f9e:	56                   	push   %esi
80106f9f:	e8 bc fa ff ff       	call   80106a60 <mappages>
80106fa4:	83 c4 20             	add    $0x20,%esp
80106fa7:	85 c0                	test   %eax,%eax
80106fa9:	78 15                	js     80106fc0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fab:	83 c3 10             	add    $0x10,%ebx
80106fae:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106fb4:	75 d6                	jne    80106f8c <setupkvm+0x2c>
}
80106fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fb9:	89 f0                	mov    %esi,%eax
80106fbb:	5b                   	pop    %ebx
80106fbc:	5e                   	pop    %esi
80106fbd:	5d                   	pop    %ebp
80106fbe:	c3                   	ret    
80106fbf:	90                   	nop
      freevm(pgdir);
80106fc0:	83 ec 0c             	sub    $0xc,%esp
80106fc3:	56                   	push   %esi
      return 0;
80106fc4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106fc6:	e8 15 ff ff ff       	call   80106ee0 <freevm>
      return 0;
80106fcb:	83 c4 10             	add    $0x10,%esp
}
80106fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fd1:	89 f0                	mov    %esi,%eax
80106fd3:	5b                   	pop    %ebx
80106fd4:	5e                   	pop    %esi
80106fd5:	5d                   	pop    %ebp
80106fd6:	c3                   	ret    
80106fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fde:	66 90                	xchg   %ax,%ax

80106fe0 <kvmalloc>:
{
80106fe0:	f3 0f 1e fb          	endbr32 
80106fe4:	55                   	push   %ebp
80106fe5:	89 e5                	mov    %esp,%ebp
80106fe7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fea:	e8 71 ff ff ff       	call   80106f60 <setupkvm>
80106fef:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ff4:	05 00 00 00 80       	add    $0x80000000,%eax
80106ff9:	0f 22 d8             	mov    %eax,%cr3
}
80106ffc:	c9                   	leave  
80106ffd:	c3                   	ret    
80106ffe:	66 90                	xchg   %ax,%ax

80107000 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107000:	f3 0f 1e fb          	endbr32 
80107004:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107005:	31 c9                	xor    %ecx,%ecx
{
80107007:	89 e5                	mov    %esp,%ebp
80107009:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010700c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010700f:	8b 45 08             	mov    0x8(%ebp),%eax
80107012:	e8 89 f8 ff ff       	call   801068a0 <walkpgdir>
  if(pte == 0)
80107017:	85 c0                	test   %eax,%eax
80107019:	74 05                	je     80107020 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010701b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010701e:	c9                   	leave  
8010701f:	c3                   	ret    
    panic("clearpteu");
80107020:	83 ec 0c             	sub    $0xc,%esp
80107023:	68 12 7d 10 80       	push   $0x80107d12
80107028:	e8 63 93 ff ff       	call   80100390 <panic>
8010702d:	8d 76 00             	lea    0x0(%esi),%esi

80107030 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107030:	f3 0f 1e fb          	endbr32 
80107034:	55                   	push   %ebp
80107035:	89 e5                	mov    %esp,%ebp
80107037:	57                   	push   %edi
80107038:	56                   	push   %esi
80107039:	53                   	push   %ebx
8010703a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  struct proc *curproc = myproc();
8010703d:	e8 2e c9 ff ff       	call   80103970 <myproc>
80107042:	89 45 dc             	mov    %eax,-0x24(%ebp)

  if((d = setupkvm()) == 0)
80107045:	e8 16 ff ff ff       	call   80106f60 <setupkvm>
8010704a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010704d:	85 c0                	test   %eax,%eax
8010704f:	0f 84 a3 00 00 00    	je     801070f8 <copyuvm+0xc8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107055:	8b 45 0c             	mov    0xc(%ebp),%eax
80107058:	85 c0                	test   %eax,%eax
8010705a:	0f 84 a8 00 00 00    	je     80107108 <copyuvm+0xd8>
80107060:	31 f6                	xor    %esi,%esi
80107062:	eb 49                	jmp    801070ad <copyuvm+0x7d>
80107064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107068:	83 ec 04             	sub    $0x4,%esp
8010706b:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107074:	68 00 10 00 00       	push   $0x1000
80107079:	57                   	push   %edi
8010707a:	50                   	push   %eax
8010707b:	e8 80 d6 ff ff       	call   80104700 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107080:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107083:	89 1c 24             	mov    %ebx,(%esp)
80107086:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010708c:	52                   	push   %edx
8010708d:	68 00 10 00 00       	push   $0x1000
80107092:	56                   	push   %esi
80107093:	ff 75 e0             	pushl  -0x20(%ebp)
80107096:	e8 c5 f9 ff ff       	call   80106a60 <mappages>
8010709b:	83 c4 20             	add    $0x20,%esp
8010709e:	85 c0                	test   %eax,%eax
801070a0:	78 41                	js     801070e3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
801070a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070a8:	39 75 0c             	cmp    %esi,0xc(%ebp)
801070ab:	76 5b                	jbe    80107108 <copyuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070ad:	8b 45 08             	mov    0x8(%ebp),%eax
801070b0:	31 c9                	xor    %ecx,%ecx
801070b2:	89 f2                	mov    %esi,%edx
801070b4:	e8 e7 f7 ff ff       	call   801068a0 <walkpgdir>
801070b9:	85 c0                	test   %eax,%eax
801070bb:	0f 84 12 01 00 00    	je     801071d3 <copyuvm+0x1a3>
    if(!(*pte & PTE_P))
801070c1:	8b 18                	mov    (%eax),%ebx
801070c3:	f6 c3 01             	test   $0x1,%bl
801070c6:	0f 84 fa 00 00 00    	je     801071c6 <copyuvm+0x196>
    pa = PTE_ADDR(*pte);
801070cc:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801070ce:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801070d4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801070da:	e8 51 b5 ff ff       	call   80102630 <kalloc>
801070df:	85 c0                	test   %eax,%eax
801070e1:	75 85                	jne    80107068 <copyuvm+0x38>


  return d;

bad:
  freevm(d);
801070e3:	83 ec 0c             	sub    $0xc,%esp
801070e6:	ff 75 e0             	pushl  -0x20(%ebp)
801070e9:	e8 f2 fd ff ff       	call   80106ee0 <freevm>
  return 0;
801070ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070f5:	83 c4 10             	add    $0x10,%esp
}
801070f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070fe:	5b                   	pop    %ebx
801070ff:	5e                   	pop    %esi
80107100:	5f                   	pop    %edi
80107101:	5d                   	pop    %ebp
80107102:	c3                   	ret    
80107103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107107:	90                   	nop
  for(i = f; i > f - (curproc->stack_pages) * PGSIZE; i -= PGSIZE){
80107108:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010710b:	8b 40 7c             	mov    0x7c(%eax),%eax
8010710e:	89 c2                	mov    %eax,%edx
80107110:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107113:	b8 00 f0 ff 7f       	mov    $0x7ffff000,%eax
80107118:	c1 e2 0c             	shl    $0xc,%edx
8010711b:	29 d0                	sub    %edx,%eax
8010711d:	3d ff ef ff 7f       	cmp    $0x7fffefff,%eax
80107122:	77 d4                	ja     801070f8 <copyuvm+0xc8>
80107124:	be 00 f0 ff 7f       	mov    $0x7ffff000,%esi
80107129:	eb 64                	jmp    8010718f <copyuvm+0x15f>
8010712b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010712f:	90                   	nop
      memmove(mem, (char*)P2V(pa), PGSIZE);
80107130:	83 ec 04             	sub    $0x4,%esp
80107133:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010713c:	68 00 10 00 00       	push   $0x1000
80107141:	57                   	push   %edi
80107142:	50                   	push   %eax
80107143:	e8 b8 d5 ff ff       	call   80104700 <memmove>
      if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107148:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010714b:	89 1c 24             	mov    %ebx,(%esp)
8010714e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107154:	52                   	push   %edx
80107155:	68 00 10 00 00       	push   $0x1000
8010715a:	56                   	push   %esi
8010715b:	ff 75 e0             	pushl  -0x20(%ebp)
8010715e:	e8 fd f8 ff ff       	call   80106a60 <mappages>
80107163:	83 c4 20             	add    $0x20,%esp
80107166:	85 c0                	test   %eax,%eax
80107168:	0f 88 75 ff ff ff    	js     801070e3 <copyuvm+0xb3>
  for(i = f; i > f - (curproc->stack_pages) * PGSIZE; i -= PGSIZE){
8010716e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107171:	b9 00 f0 ff 7f       	mov    $0x7ffff000,%ecx
80107176:	81 ee 00 10 00 00    	sub    $0x1000,%esi
8010717c:	8b 40 7c             	mov    0x7c(%eax),%eax
8010717f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107182:	c1 e0 0c             	shl    $0xc,%eax
80107185:	29 c1                	sub    %eax,%ecx
80107187:	39 f1                	cmp    %esi,%ecx
80107189:	0f 83 69 ff ff ff    	jae    801070f8 <copyuvm+0xc8>
      if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010718f:	8b 45 08             	mov    0x8(%ebp),%eax
80107192:	31 c9                	xor    %ecx,%ecx
80107194:	89 f2                	mov    %esi,%edx
80107196:	e8 05 f7 ff ff       	call   801068a0 <walkpgdir>
8010719b:	85 c0                	test   %eax,%eax
8010719d:	74 34                	je     801071d3 <copyuvm+0x1a3>
      if(!(*pte & PTE_P))
8010719f:	8b 18                	mov    (%eax),%ebx
801071a1:	f6 c3 01             	test   $0x1,%bl
801071a4:	74 20                	je     801071c6 <copyuvm+0x196>
      pa = PTE_ADDR(*pte);
801071a6:	89 df                	mov    %ebx,%edi
      flags = PTE_FLAGS(*pte);
801071a8:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
      pa = PTE_ADDR(*pte);
801071ae:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      if((mem = kalloc()) == 0)
801071b4:	e8 77 b4 ff ff       	call   80102630 <kalloc>
801071b9:	85 c0                	test   %eax,%eax
801071bb:	0f 85 6f ff ff ff    	jne    80107130 <copyuvm+0x100>
801071c1:	e9 1d ff ff ff       	jmp    801070e3 <copyuvm+0xb3>
      panic("copyuvm: page not present");
801071c6:	83 ec 0c             	sub    $0xc,%esp
801071c9:	68 36 7d 10 80       	push   $0x80107d36
801071ce:	e8 bd 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801071d3:	83 ec 0c             	sub    $0xc,%esp
801071d6:	68 1c 7d 10 80       	push   $0x80107d1c
801071db:	e8 b0 91 ff ff       	call   80100390 <panic>

801071e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071e0:	f3 0f 1e fb          	endbr32 
801071e4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071e5:	31 c9                	xor    %ecx,%ecx
{
801071e7:	89 e5                	mov    %esp,%ebp
801071e9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801071ef:	8b 45 08             	mov    0x8(%ebp),%eax
801071f2:	e8 a9 f6 ff ff       	call   801068a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071f7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071f9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801071fa:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107201:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107204:	05 00 00 00 80       	add    $0x80000000,%eax
80107209:	83 fa 05             	cmp    $0x5,%edx
8010720c:	ba 00 00 00 00       	mov    $0x0,%edx
80107211:	0f 45 c2             	cmovne %edx,%eax
}
80107214:	c3                   	ret    
80107215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107220 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107220:	f3 0f 1e fb          	endbr32 
80107224:	55                   	push   %ebp
80107225:	89 e5                	mov    %esp,%ebp
80107227:	57                   	push   %edi
80107228:	56                   	push   %esi
80107229:	53                   	push   %ebx
8010722a:	83 ec 0c             	sub    $0xc,%esp
8010722d:	8b 75 14             	mov    0x14(%ebp),%esi
80107230:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107233:	85 f6                	test   %esi,%esi
80107235:	75 3c                	jne    80107273 <copyout+0x53>
80107237:	eb 67                	jmp    801072a0 <copyout+0x80>
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107240:	8b 55 0c             	mov    0xc(%ebp),%edx
80107243:	89 fb                	mov    %edi,%ebx
80107245:	29 d3                	sub    %edx,%ebx
80107247:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010724d:	39 f3                	cmp    %esi,%ebx
8010724f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107252:	29 fa                	sub    %edi,%edx
80107254:	83 ec 04             	sub    $0x4,%esp
80107257:	01 c2                	add    %eax,%edx
80107259:	53                   	push   %ebx
8010725a:	ff 75 10             	pushl  0x10(%ebp)
8010725d:	52                   	push   %edx
8010725e:	e8 9d d4 ff ff       	call   80104700 <memmove>
    len -= n;
    buf += n;
80107263:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107266:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010726c:	83 c4 10             	add    $0x10,%esp
8010726f:	29 de                	sub    %ebx,%esi
80107271:	74 2d                	je     801072a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107273:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107275:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107278:	89 55 0c             	mov    %edx,0xc(%ebp)
8010727b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107281:	57                   	push   %edi
80107282:	ff 75 08             	pushl  0x8(%ebp)
80107285:	e8 56 ff ff ff       	call   801071e0 <uva2ka>
    if(pa0 == 0)
8010728a:	83 c4 10             	add    $0x10,%esp
8010728d:	85 c0                	test   %eax,%eax
8010728f:	75 af                	jne    80107240 <copyout+0x20>
  }
  return 0;
}
80107291:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107299:	5b                   	pop    %ebx
8010729a:	5e                   	pop    %esi
8010729b:	5f                   	pop    %edi
8010729c:	5d                   	pop    %ebp
8010729d:	c3                   	ret    
8010729e:	66 90                	xchg   %ax,%ax
801072a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072a3:	31 c0                	xor    %eax,%eax
}
801072a5:	5b                   	pop    %ebx
801072a6:	5e                   	pop    %esi
801072a7:	5f                   	pop    %edi
801072a8:	5d                   	pop    %ebp
801072a9:	c3                   	ret    
801072aa:	66 90                	xchg   %ax,%ax
801072ac:	66 90                	xchg   %ax,%ax
801072ae:	66 90                	xchg   %ax,%ax

801072b0 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
801072b0:	f3 0f 1e fb          	endbr32 
801072b4:	55                   	push   %ebp
801072b5:	89 e5                	mov    %esp,%ebp
801072b7:	83 ec 10             	sub    $0x10,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
801072ba:	68 73 7d 10 80       	push   $0x80107d73
801072bf:	68 c0 55 11 80       	push   $0x801155c0
801072c4:	e8 07 d1 ff ff       	call   801043d0 <initlock>
  acquire(&(shm_table.lock));
801072c9:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
801072d0:	e8 0b d2 ff ff       	call   801044e0 <acquire>
  for (i = 0; i< 64; i++) {
801072d5:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
801072da:	83 c4 10             	add    $0x10,%esp
801072dd:	8d 76 00             	lea    0x0(%esi),%esi
    shm_table.shm_pages[i].id =0;
801072e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].frame =0;
801072e6:	83 c0 0c             	add    $0xc,%eax
801072e9:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
801072f0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
801072f7:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
801072fc:	75 e2                	jne    801072e0 <shminit+0x30>
  }
  release(&(shm_table.lock));
801072fe:	83 ec 0c             	sub    $0xc,%esp
80107301:	68 c0 55 11 80       	push   $0x801155c0
80107306:	e8 05 d3 ff ff       	call   80104610 <release>
}
8010730b:	83 c4 10             	add    $0x10,%esp
8010730e:	c9                   	leave  
8010730f:	c3                   	ret    

80107310 <shm_open>:

int shm_open(int id, char **pointer) {
80107310:	f3 0f 1e fb          	endbr32 




return 0; //added to remove compiler warning -- you should decide what to return
}
80107314:	31 c0                	xor    %eax,%eax
80107316:	c3                   	ret    
80107317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731e:	66 90                	xchg   %ax,%ax

80107320 <shm_close>:


int shm_close(int id) {
80107320:	f3 0f 1e fb          	endbr32 




return 0; //added to remove compiler warning -- you should decide what to return
}
80107324:	31 c0                	xor    %eax,%eax
80107326:	c3                   	ret    
