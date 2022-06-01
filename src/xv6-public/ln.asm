
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  16:	83 39 03             	cmpl   $0x3,(%ecx)
  19:	74 14                	je     2f <main+0x2f>
    printf(2, "Usage: ln old new\n");
  1b:	83 ec 08             	sub    $0x8,%esp
  1e:	68 2c 06 00 00       	push   $0x62c
  23:	6a 02                	push   $0x2
  25:	e8 44 03 00 00       	call   36e <printf>
    exit();
  2a:	e8 ee 01 00 00       	call   21d <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	ff 73 08             	pushl  0x8(%ebx)
  35:	ff 73 04             	pushl  0x4(%ebx)
  38:	e8 40 02 00 00       	call   27d <link>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	85 c0                	test   %eax,%eax
  42:	78 05                	js     49 <main+0x49>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  44:	e8 d4 01 00 00       	call   21d <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  49:	ff 73 08             	pushl  0x8(%ebx)
  4c:	ff 73 04             	pushl  0x4(%ebx)
  4f:	68 3f 06 00 00       	push   $0x63f
  54:	6a 02                	push   $0x2
  56:	e8 13 03 00 00       	call   36e <printf>
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	eb e4                	jmp    44 <main+0x44>

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	f3 0f 1e fb          	endbr32 
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	56                   	push   %esi
  68:	53                   	push   %ebx
  69:	8b 75 08             	mov    0x8(%ebp),%esi
  6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6f:	89 f0                	mov    %esi,%eax
  71:	89 d1                	mov    %edx,%ecx
  73:	83 c2 01             	add    $0x1,%edx
  76:	89 c3                	mov    %eax,%ebx
  78:	83 c0 01             	add    $0x1,%eax
  7b:	0f b6 09             	movzbl (%ecx),%ecx
  7e:	88 0b                	mov    %cl,(%ebx)
  80:	84 c9                	test   %cl,%cl
  82:	75 ed                	jne    71 <strcpy+0x11>
    ;
  return os;
}
  84:	89 f0                	mov    %esi,%eax
  86:	5b                   	pop    %ebx
  87:	5e                   	pop    %esi
  88:	5d                   	pop    %ebp
  89:	c3                   	ret    

0000008a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8a:	f3 0f 1e fb          	endbr32 
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  94:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  97:	0f b6 01             	movzbl (%ecx),%eax
  9a:	84 c0                	test   %al,%al
  9c:	74 0c                	je     aa <strcmp+0x20>
  9e:	3a 02                	cmp    (%edx),%al
  a0:	75 08                	jne    aa <strcmp+0x20>
    p++, q++;
  a2:	83 c1 01             	add    $0x1,%ecx
  a5:	83 c2 01             	add    $0x1,%edx
  a8:	eb ed                	jmp    97 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  aa:	0f b6 c0             	movzbl %al,%eax
  ad:	0f b6 12             	movzbl (%edx),%edx
  b0:	29 d0                	sub    %edx,%eax
}
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	f3 0f 1e fb          	endbr32 
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  be:	b8 00 00 00 00       	mov    $0x0,%eax
  c3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  c7:	74 05                	je     ce <strlen+0x1a>
  c9:	83 c0 01             	add    $0x1,%eax
  cc:	eb f5                	jmp    c3 <strlen+0xf>
    ;
  return n;
}
  ce:	5d                   	pop    %ebp
  cf:	c3                   	ret    

000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	f3 0f 1e fb          	endbr32 
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	57                   	push   %edi
  d8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  db:	89 d7                	mov    %edx,%edi
  dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  e3:	fc                   	cld    
  e4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e6:	89 d0                	mov    %edx,%eax
  e8:	5f                   	pop    %edi
  e9:	5d                   	pop    %ebp
  ea:	c3                   	ret    

000000eb <strchr>:

char*
strchr(const char *s, char c)
{
  eb:	f3 0f 1e fb          	endbr32 
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f9:	0f b6 10             	movzbl (%eax),%edx
  fc:	84 d2                	test   %dl,%dl
  fe:	74 09                	je     109 <strchr+0x1e>
    if(*s == c)
 100:	38 ca                	cmp    %cl,%dl
 102:	74 0a                	je     10e <strchr+0x23>
  for(; *s; s++)
 104:	83 c0 01             	add    $0x1,%eax
 107:	eb f0                	jmp    f9 <strchr+0xe>
      return (char*)s;
  return 0;
 109:	b8 00 00 00 00       	mov    $0x0,%eax
}
 10e:	5d                   	pop    %ebp
 10f:	c3                   	ret    

00000110 <gets>:

char*
gets(char *buf, int max)
{
 110:	f3 0f 1e fb          	endbr32 
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	56                   	push   %esi
 119:	53                   	push   %ebx
 11a:	83 ec 1c             	sub    $0x1c,%esp
 11d:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 120:	bb 00 00 00 00       	mov    $0x0,%ebx
 125:	89 de                	mov    %ebx,%esi
 127:	83 c3 01             	add    $0x1,%ebx
 12a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12d:	7d 2e                	jge    15d <gets+0x4d>
    cc = read(0, &c, 1);
 12f:	83 ec 04             	sub    $0x4,%esp
 132:	6a 01                	push   $0x1
 134:	8d 45 e7             	lea    -0x19(%ebp),%eax
 137:	50                   	push   %eax
 138:	6a 00                	push   $0x0
 13a:	e8 f6 00 00 00       	call   235 <read>
    if(cc < 1)
 13f:	83 c4 10             	add    $0x10,%esp
 142:	85 c0                	test   %eax,%eax
 144:	7e 17                	jle    15d <gets+0x4d>
      break;
    buf[i++] = c;
 146:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 14a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 14d:	3c 0a                	cmp    $0xa,%al
 14f:	0f 94 c2             	sete   %dl
 152:	3c 0d                	cmp    $0xd,%al
 154:	0f 94 c0             	sete   %al
 157:	08 c2                	or     %al,%dl
 159:	74 ca                	je     125 <gets+0x15>
    buf[i++] = c;
 15b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 15d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 161:	89 f8                	mov    %edi,%eax
 163:	8d 65 f4             	lea    -0xc(%ebp),%esp
 166:	5b                   	pop    %ebx
 167:	5e                   	pop    %esi
 168:	5f                   	pop    %edi
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <stat>:

int
stat(const char *n, struct stat *st)
{
 16b:	f3 0f 1e fb          	endbr32 
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	56                   	push   %esi
 173:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 174:	83 ec 08             	sub    $0x8,%esp
 177:	6a 00                	push   $0x0
 179:	ff 75 08             	pushl  0x8(%ebp)
 17c:	e8 dc 00 00 00       	call   25d <open>
  if(fd < 0)
 181:	83 c4 10             	add    $0x10,%esp
 184:	85 c0                	test   %eax,%eax
 186:	78 24                	js     1ac <stat+0x41>
 188:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 18a:	83 ec 08             	sub    $0x8,%esp
 18d:	ff 75 0c             	pushl  0xc(%ebp)
 190:	50                   	push   %eax
 191:	e8 df 00 00 00       	call   275 <fstat>
 196:	89 c6                	mov    %eax,%esi
  close(fd);
 198:	89 1c 24             	mov    %ebx,(%esp)
 19b:	e8 a5 00 00 00       	call   245 <close>
  return r;
 1a0:	83 c4 10             	add    $0x10,%esp
}
 1a3:	89 f0                	mov    %esi,%eax
 1a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a8:	5b                   	pop    %ebx
 1a9:	5e                   	pop    %esi
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    
    return -1;
 1ac:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b1:	eb f0                	jmp    1a3 <stat+0x38>

000001b3 <atoi>:

int
atoi(const char *s)
{
 1b3:	f3 0f 1e fb          	endbr32 
 1b7:	55                   	push   %ebp
 1b8:	89 e5                	mov    %esp,%ebp
 1ba:	53                   	push   %ebx
 1bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1be:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c3:	0f b6 01             	movzbl (%ecx),%eax
 1c6:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1c9:	80 fb 09             	cmp    $0x9,%bl
 1cc:	77 12                	ja     1e0 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1ce:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1d1:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1d4:	83 c1 01             	add    $0x1,%ecx
 1d7:	0f be c0             	movsbl %al,%eax
 1da:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1de:	eb e3                	jmp    1c3 <atoi+0x10>
  return n;
}
 1e0:	89 d0                	mov    %edx,%eax
 1e2:	5b                   	pop    %ebx
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    

000001e5 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e5:	f3 0f 1e fb          	endbr32 
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	56                   	push   %esi
 1ed:	53                   	push   %ebx
 1ee:	8b 75 08             	mov    0x8(%ebp),%esi
 1f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1f4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1f7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1fc:	85 c0                	test   %eax,%eax
 1fe:	7e 0f                	jle    20f <memmove+0x2a>
    *dst++ = *src++;
 200:	0f b6 01             	movzbl (%ecx),%eax
 203:	88 02                	mov    %al,(%edx)
 205:	8d 49 01             	lea    0x1(%ecx),%ecx
 208:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 20b:	89 d8                	mov    %ebx,%eax
 20d:	eb ea                	jmp    1f9 <memmove+0x14>
  return vdst;
}
 20f:	89 f0                	mov    %esi,%eax
 211:	5b                   	pop    %ebx
 212:	5e                   	pop    %esi
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    

00000215 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 215:	b8 01 00 00 00       	mov    $0x1,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <exit>:
SYSCALL(exit)
 21d:	b8 02 00 00 00       	mov    $0x2,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <wait>:
SYSCALL(wait)
 225:	b8 03 00 00 00       	mov    $0x3,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <pipe>:
SYSCALL(pipe)
 22d:	b8 04 00 00 00       	mov    $0x4,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <read>:
SYSCALL(read)
 235:	b8 05 00 00 00       	mov    $0x5,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <write>:
SYSCALL(write)
 23d:	b8 10 00 00 00       	mov    $0x10,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <close>:
SYSCALL(close)
 245:	b8 15 00 00 00       	mov    $0x15,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <kill>:
SYSCALL(kill)
 24d:	b8 06 00 00 00       	mov    $0x6,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <exec>:
SYSCALL(exec)
 255:	b8 07 00 00 00       	mov    $0x7,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <open>:
SYSCALL(open)
 25d:	b8 0f 00 00 00       	mov    $0xf,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <mknod>:
SYSCALL(mknod)
 265:	b8 11 00 00 00       	mov    $0x11,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <unlink>:
SYSCALL(unlink)
 26d:	b8 12 00 00 00       	mov    $0x12,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <fstat>:
SYSCALL(fstat)
 275:	b8 08 00 00 00       	mov    $0x8,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <link>:
SYSCALL(link)
 27d:	b8 13 00 00 00       	mov    $0x13,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <mkdir>:
SYSCALL(mkdir)
 285:	b8 14 00 00 00       	mov    $0x14,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <chdir>:
SYSCALL(chdir)
 28d:	b8 09 00 00 00       	mov    $0x9,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <dup>:
SYSCALL(dup)
 295:	b8 0a 00 00 00       	mov    $0xa,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <getpid>:
SYSCALL(getpid)
 29d:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <sbrk>:
SYSCALL(sbrk)
 2a5:	b8 0c 00 00 00       	mov    $0xc,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <sleep>:
SYSCALL(sleep)
 2ad:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <uptime>:
SYSCALL(uptime)
 2b5:	b8 0e 00 00 00       	mov    $0xe,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <get_siblings_info>:
SYSCALL(get_siblings_info)
 2bd:	b8 16 00 00 00       	mov    $0x16,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <get_ancestors>:
SYSCALL(get_ancestors)
 2c5:	b8 17 00 00 00       	mov    $0x17,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	83 ec 1c             	sub    $0x1c,%esp
 2d3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2d6:	6a 01                	push   $0x1
 2d8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2db:	52                   	push   %edx
 2dc:	50                   	push   %eax
 2dd:	e8 5b ff ff ff       	call   23d <write>
}
 2e2:	83 c4 10             	add    $0x10,%esp
 2e5:	c9                   	leave  
 2e6:	c3                   	ret    

000002e7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
 2ea:	57                   	push   %edi
 2eb:	56                   	push   %esi
 2ec:	53                   	push   %ebx
 2ed:	83 ec 2c             	sub    $0x2c,%esp
 2f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2f3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f9:	0f 95 c2             	setne  %dl
 2fc:	89 f0                	mov    %esi,%eax
 2fe:	c1 e8 1f             	shr    $0x1f,%eax
 301:	84 c2                	test   %al,%dl
 303:	74 42                	je     347 <printint+0x60>
    neg = 1;
    x = -xx;
 305:	f7 de                	neg    %esi
    neg = 1;
 307:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 30e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 313:	89 f0                	mov    %esi,%eax
 315:	ba 00 00 00 00       	mov    $0x0,%edx
 31a:	f7 f1                	div    %ecx
 31c:	89 df                	mov    %ebx,%edi
 31e:	83 c3 01             	add    $0x1,%ebx
 321:	0f b6 92 5c 06 00 00 	movzbl 0x65c(%edx),%edx
 328:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 32c:	89 f2                	mov    %esi,%edx
 32e:	89 c6                	mov    %eax,%esi
 330:	39 d1                	cmp    %edx,%ecx
 332:	76 df                	jbe    313 <printint+0x2c>
  if(neg)
 334:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 338:	74 2f                	je     369 <printint+0x82>
    buf[i++] = '-';
 33a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 33f:	8d 5f 02             	lea    0x2(%edi),%ebx
 342:	8b 75 d0             	mov    -0x30(%ebp),%esi
 345:	eb 15                	jmp    35c <printint+0x75>
  neg = 0;
 347:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 34e:	eb be                	jmp    30e <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 350:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 355:	89 f0                	mov    %esi,%eax
 357:	e8 71 ff ff ff       	call   2cd <putc>
  while(--i >= 0)
 35c:	83 eb 01             	sub    $0x1,%ebx
 35f:	79 ef                	jns    350 <printint+0x69>
}
 361:	83 c4 2c             	add    $0x2c,%esp
 364:	5b                   	pop    %ebx
 365:	5e                   	pop    %esi
 366:	5f                   	pop    %edi
 367:	5d                   	pop    %ebp
 368:	c3                   	ret    
 369:	8b 75 d0             	mov    -0x30(%ebp),%esi
 36c:	eb ee                	jmp    35c <printint+0x75>

0000036e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 36e:	f3 0f 1e fb          	endbr32 
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	57                   	push   %edi
 376:	56                   	push   %esi
 377:	53                   	push   %ebx
 378:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 37b:	8d 45 10             	lea    0x10(%ebp),%eax
 37e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 381:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 386:	bb 00 00 00 00       	mov    $0x0,%ebx
 38b:	eb 14                	jmp    3a1 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 38d:	89 fa                	mov    %edi,%edx
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	e8 36 ff ff ff       	call   2cd <putc>
 397:	eb 05                	jmp    39e <printf+0x30>
      }
    } else if(state == '%'){
 399:	83 fe 25             	cmp    $0x25,%esi
 39c:	74 25                	je     3c3 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 39e:	83 c3 01             	add    $0x1,%ebx
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3a8:	84 c0                	test   %al,%al
 3aa:	0f 84 23 01 00 00    	je     4d3 <printf+0x165>
    c = fmt[i] & 0xff;
 3b0:	0f be f8             	movsbl %al,%edi
 3b3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3b6:	85 f6                	test   %esi,%esi
 3b8:	75 df                	jne    399 <printf+0x2b>
      if(c == '%'){
 3ba:	83 f8 25             	cmp    $0x25,%eax
 3bd:	75 ce                	jne    38d <printf+0x1f>
        state = '%';
 3bf:	89 c6                	mov    %eax,%esi
 3c1:	eb db                	jmp    39e <printf+0x30>
      if(c == 'd'){
 3c3:	83 f8 64             	cmp    $0x64,%eax
 3c6:	74 49                	je     411 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3c8:	83 f8 78             	cmp    $0x78,%eax
 3cb:	0f 94 c1             	sete   %cl
 3ce:	83 f8 70             	cmp    $0x70,%eax
 3d1:	0f 94 c2             	sete   %dl
 3d4:	08 d1                	or     %dl,%cl
 3d6:	75 63                	jne    43b <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3d8:	83 f8 73             	cmp    $0x73,%eax
 3db:	0f 84 84 00 00 00    	je     465 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3e1:	83 f8 63             	cmp    $0x63,%eax
 3e4:	0f 84 b7 00 00 00    	je     4a1 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3ea:	83 f8 25             	cmp    $0x25,%eax
 3ed:	0f 84 cc 00 00 00    	je     4bf <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3f3:	ba 25 00 00 00       	mov    $0x25,%edx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	e8 cd fe ff ff       	call   2cd <putc>
        putc(fd, c);
 400:	89 fa                	mov    %edi,%edx
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	e8 c3 fe ff ff       	call   2cd <putc>
      }
      state = 0;
 40a:	be 00 00 00 00       	mov    $0x0,%esi
 40f:	eb 8d                	jmp    39e <printf+0x30>
        printint(fd, *ap, 10, 1);
 411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 414:	8b 17                	mov    (%edi),%edx
 416:	83 ec 0c             	sub    $0xc,%esp
 419:	6a 01                	push   $0x1
 41b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	e8 bf fe ff ff       	call   2e7 <printint>
        ap++;
 428:	83 c7 04             	add    $0x4,%edi
 42b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 42e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 431:	be 00 00 00 00       	mov    $0x0,%esi
 436:	e9 63 ff ff ff       	jmp    39e <printf+0x30>
        printint(fd, *ap, 16, 0);
 43b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 43e:	8b 17                	mov    (%edi),%edx
 440:	83 ec 0c             	sub    $0xc,%esp
 443:	6a 00                	push   $0x0
 445:	b9 10 00 00 00       	mov    $0x10,%ecx
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	e8 95 fe ff ff       	call   2e7 <printint>
        ap++;
 452:	83 c7 04             	add    $0x4,%edi
 455:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 458:	83 c4 10             	add    $0x10,%esp
      state = 0;
 45b:	be 00 00 00 00       	mov    $0x0,%esi
 460:	e9 39 ff ff ff       	jmp    39e <printf+0x30>
        s = (char*)*ap;
 465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 468:	8b 30                	mov    (%eax),%esi
        ap++;
 46a:	83 c0 04             	add    $0x4,%eax
 46d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 470:	85 f6                	test   %esi,%esi
 472:	75 28                	jne    49c <printf+0x12e>
          s = "(null)";
 474:	be 53 06 00 00       	mov    $0x653,%esi
 479:	8b 7d 08             	mov    0x8(%ebp),%edi
 47c:	eb 0d                	jmp    48b <printf+0x11d>
          putc(fd, *s);
 47e:	0f be d2             	movsbl %dl,%edx
 481:	89 f8                	mov    %edi,%eax
 483:	e8 45 fe ff ff       	call   2cd <putc>
          s++;
 488:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 48b:	0f b6 16             	movzbl (%esi),%edx
 48e:	84 d2                	test   %dl,%dl
 490:	75 ec                	jne    47e <printf+0x110>
      state = 0;
 492:	be 00 00 00 00       	mov    $0x0,%esi
 497:	e9 02 ff ff ff       	jmp    39e <printf+0x30>
 49c:	8b 7d 08             	mov    0x8(%ebp),%edi
 49f:	eb ea                	jmp    48b <printf+0x11d>
        putc(fd, *ap);
 4a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a4:	0f be 17             	movsbl (%edi),%edx
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	e8 1e fe ff ff       	call   2cd <putc>
        ap++;
 4af:	83 c7 04             	add    $0x4,%edi
 4b2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4b5:	be 00 00 00 00       	mov    $0x0,%esi
 4ba:	e9 df fe ff ff       	jmp    39e <printf+0x30>
        putc(fd, c);
 4bf:	89 fa                	mov    %edi,%edx
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	e8 04 fe ff ff       	call   2cd <putc>
      state = 0;
 4c9:	be 00 00 00 00       	mov    $0x0,%esi
 4ce:	e9 cb fe ff ff       	jmp    39e <printf+0x30>
    }
  }
}
 4d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5f                   	pop    %edi
 4d9:	5d                   	pop    %ebp
 4da:	c3                   	ret    

000004db <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4db:	f3 0f 1e fb          	endbr32 
 4df:	55                   	push   %ebp
 4e0:	89 e5                	mov    %esp,%ebp
 4e2:	57                   	push   %edi
 4e3:	56                   	push   %esi
 4e4:	53                   	push   %ebx
 4e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4e8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4eb:	a1 00 09 00 00       	mov    0x900,%eax
 4f0:	eb 02                	jmp    4f4 <free+0x19>
 4f2:	89 d0                	mov    %edx,%eax
 4f4:	39 c8                	cmp    %ecx,%eax
 4f6:	73 04                	jae    4fc <free+0x21>
 4f8:	39 08                	cmp    %ecx,(%eax)
 4fa:	77 12                	ja     50e <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4fc:	8b 10                	mov    (%eax),%edx
 4fe:	39 c2                	cmp    %eax,%edx
 500:	77 f0                	ja     4f2 <free+0x17>
 502:	39 c8                	cmp    %ecx,%eax
 504:	72 08                	jb     50e <free+0x33>
 506:	39 ca                	cmp    %ecx,%edx
 508:	77 04                	ja     50e <free+0x33>
 50a:	89 d0                	mov    %edx,%eax
 50c:	eb e6                	jmp    4f4 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 50e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 511:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 514:	8b 10                	mov    (%eax),%edx
 516:	39 d7                	cmp    %edx,%edi
 518:	74 19                	je     533 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 51a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 51d:	8b 50 04             	mov    0x4(%eax),%edx
 520:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 523:	39 ce                	cmp    %ecx,%esi
 525:	74 1b                	je     542 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 527:	89 08                	mov    %ecx,(%eax)
  freep = p;
 529:	a3 00 09 00 00       	mov    %eax,0x900
}
 52e:	5b                   	pop    %ebx
 52f:	5e                   	pop    %esi
 530:	5f                   	pop    %edi
 531:	5d                   	pop    %ebp
 532:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 533:	03 72 04             	add    0x4(%edx),%esi
 536:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 539:	8b 10                	mov    (%eax),%edx
 53b:	8b 12                	mov    (%edx),%edx
 53d:	89 53 f8             	mov    %edx,-0x8(%ebx)
 540:	eb db                	jmp    51d <free+0x42>
    p->s.size += bp->s.size;
 542:	03 53 fc             	add    -0x4(%ebx),%edx
 545:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 548:	8b 53 f8             	mov    -0x8(%ebx),%edx
 54b:	89 10                	mov    %edx,(%eax)
 54d:	eb da                	jmp    529 <free+0x4e>

0000054f <morecore>:

static Header*
morecore(uint nu)
{
 54f:	55                   	push   %ebp
 550:	89 e5                	mov    %esp,%ebp
 552:	53                   	push   %ebx
 553:	83 ec 04             	sub    $0x4,%esp
 556:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 558:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 55d:	77 05                	ja     564 <morecore+0x15>
    nu = 4096;
 55f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 564:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 56b:	83 ec 0c             	sub    $0xc,%esp
 56e:	50                   	push   %eax
 56f:	e8 31 fd ff ff       	call   2a5 <sbrk>
  if(p == (char*)-1)
 574:	83 c4 10             	add    $0x10,%esp
 577:	83 f8 ff             	cmp    $0xffffffff,%eax
 57a:	74 1c                	je     598 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 57c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 57f:	83 c0 08             	add    $0x8,%eax
 582:	83 ec 0c             	sub    $0xc,%esp
 585:	50                   	push   %eax
 586:	e8 50 ff ff ff       	call   4db <free>
  return freep;
 58b:	a1 00 09 00 00       	mov    0x900,%eax
 590:	83 c4 10             	add    $0x10,%esp
}
 593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 596:	c9                   	leave  
 597:	c3                   	ret    
    return 0;
 598:	b8 00 00 00 00       	mov    $0x0,%eax
 59d:	eb f4                	jmp    593 <morecore+0x44>

0000059f <malloc>:

void*
malloc(uint nbytes)
{
 59f:	f3 0f 1e fb          	endbr32 
 5a3:	55                   	push   %ebp
 5a4:	89 e5                	mov    %esp,%ebp
 5a6:	53                   	push   %ebx
 5a7:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	8d 58 07             	lea    0x7(%eax),%ebx
 5b0:	c1 eb 03             	shr    $0x3,%ebx
 5b3:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5b6:	8b 0d 00 09 00 00    	mov    0x900,%ecx
 5bc:	85 c9                	test   %ecx,%ecx
 5be:	74 04                	je     5c4 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c0:	8b 01                	mov    (%ecx),%eax
 5c2:	eb 4b                	jmp    60f <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5c4:	c7 05 00 09 00 00 04 	movl   $0x904,0x900
 5cb:	09 00 00 
 5ce:	c7 05 04 09 00 00 04 	movl   $0x904,0x904
 5d5:	09 00 00 
    base.s.size = 0;
 5d8:	c7 05 08 09 00 00 00 	movl   $0x0,0x908
 5df:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5e2:	b9 04 09 00 00       	mov    $0x904,%ecx
 5e7:	eb d7                	jmp    5c0 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5e9:	74 1a                	je     605 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5eb:	29 da                	sub    %ebx,%edx
 5ed:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5f0:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5f3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5f6:	89 0d 00 09 00 00    	mov    %ecx,0x900
      return (void*)(p + 1);
 5fc:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5ff:	83 c4 04             	add    $0x4,%esp
 602:	5b                   	pop    %ebx
 603:	5d                   	pop    %ebp
 604:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 605:	8b 10                	mov    (%eax),%edx
 607:	89 11                	mov    %edx,(%ecx)
 609:	eb eb                	jmp    5f6 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60b:	89 c1                	mov    %eax,%ecx
 60d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 60f:	8b 50 04             	mov    0x4(%eax),%edx
 612:	39 da                	cmp    %ebx,%edx
 614:	73 d3                	jae    5e9 <malloc+0x4a>
    if(p == freep)
 616:	39 05 00 09 00 00    	cmp    %eax,0x900
 61c:	75 ed                	jne    60b <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 61e:	89 d8                	mov    %ebx,%eax
 620:	e8 2a ff ff ff       	call   54f <morecore>
 625:	85 c0                	test   %eax,%eax
 627:	75 e2                	jne    60b <malloc+0x6c>
 629:	eb d4                	jmp    5ff <malloc+0x60>
