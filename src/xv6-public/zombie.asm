
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  15:	e8 cd 01 00 00       	call   1e7 <fork>
  1a:	85 c0                	test   %eax,%eax
  1c:	7f 05                	jg     23 <main+0x23>
    sleep(5);  // Let child exit before parent.
  exit();
  1e:	e8 cc 01 00 00       	call   1ef <exit>
    sleep(5);  // Let child exit before parent.
  23:	83 ec 0c             	sub    $0xc,%esp
  26:	6a 05                	push   $0x5
  28:	e8 52 02 00 00       	call   27f <sleep>
  2d:	83 c4 10             	add    $0x10,%esp
  30:	eb ec                	jmp    1e <main+0x1e>

00000032 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  32:	f3 0f 1e fb          	endbr32 
  36:	55                   	push   %ebp
  37:	89 e5                	mov    %esp,%ebp
  39:	56                   	push   %esi
  3a:	53                   	push   %ebx
  3b:	8b 75 08             	mov    0x8(%ebp),%esi
  3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  41:	89 f0                	mov    %esi,%eax
  43:	89 d1                	mov    %edx,%ecx
  45:	83 c2 01             	add    $0x1,%edx
  48:	89 c3                	mov    %eax,%ebx
  4a:	83 c0 01             	add    $0x1,%eax
  4d:	0f b6 09             	movzbl (%ecx),%ecx
  50:	88 0b                	mov    %cl,(%ebx)
  52:	84 c9                	test   %cl,%cl
  54:	75 ed                	jne    43 <strcpy+0x11>
    ;
  return os;
}
  56:	89 f0                	mov    %esi,%eax
  58:	5b                   	pop    %ebx
  59:	5e                   	pop    %esi
  5a:	5d                   	pop    %ebp
  5b:	c3                   	ret    

0000005c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5c:	f3 0f 1e fb          	endbr32 
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  66:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  69:	0f b6 01             	movzbl (%ecx),%eax
  6c:	84 c0                	test   %al,%al
  6e:	74 0c                	je     7c <strcmp+0x20>
  70:	3a 02                	cmp    (%edx),%al
  72:	75 08                	jne    7c <strcmp+0x20>
    p++, q++;
  74:	83 c1 01             	add    $0x1,%ecx
  77:	83 c2 01             	add    $0x1,%edx
  7a:	eb ed                	jmp    69 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  7c:	0f b6 c0             	movzbl %al,%eax
  7f:	0f b6 12             	movzbl (%edx),%edx
  82:	29 d0                	sub    %edx,%eax
}
  84:	5d                   	pop    %ebp
  85:	c3                   	ret    

00000086 <strlen>:

uint
strlen(const char *s)
{
  86:	f3 0f 1e fb          	endbr32 
  8a:	55                   	push   %ebp
  8b:	89 e5                	mov    %esp,%ebp
  8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  90:	b8 00 00 00 00       	mov    $0x0,%eax
  95:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  99:	74 05                	je     a0 <strlen+0x1a>
  9b:	83 c0 01             	add    $0x1,%eax
  9e:	eb f5                	jmp    95 <strlen+0xf>
    ;
  return n;
}
  a0:	5d                   	pop    %ebp
  a1:	c3                   	ret    

000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	f3 0f 1e fb          	endbr32 
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  a9:	57                   	push   %edi
  aa:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ad:	89 d7                	mov    %edx,%edi
  af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	fc                   	cld    
  b6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b8:	89 d0                	mov    %edx,%eax
  ba:	5f                   	pop    %edi
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strchr>:

char*
strchr(const char *s, char c)
{
  bd:	f3 0f 1e fb          	endbr32 
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  cb:	0f b6 10             	movzbl (%eax),%edx
  ce:	84 d2                	test   %dl,%dl
  d0:	74 09                	je     db <strchr+0x1e>
    if(*s == c)
  d2:	38 ca                	cmp    %cl,%dl
  d4:	74 0a                	je     e0 <strchr+0x23>
  for(; *s; s++)
  d6:	83 c0 01             	add    $0x1,%eax
  d9:	eb f0                	jmp    cb <strchr+0xe>
      return (char*)s;
  return 0;
  db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    

000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	f3 0f 1e fb          	endbr32 
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  e9:	57                   	push   %edi
  ea:	56                   	push   %esi
  eb:	53                   	push   %ebx
  ec:	83 ec 1c             	sub    $0x1c,%esp
  ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  f7:	89 de                	mov    %ebx,%esi
  f9:	83 c3 01             	add    $0x1,%ebx
  fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  ff:	7d 2e                	jge    12f <gets+0x4d>
    cc = read(0, &c, 1);
 101:	83 ec 04             	sub    $0x4,%esp
 104:	6a 01                	push   $0x1
 106:	8d 45 e7             	lea    -0x19(%ebp),%eax
 109:	50                   	push   %eax
 10a:	6a 00                	push   $0x0
 10c:	e8 f6 00 00 00       	call   207 <read>
    if(cc < 1)
 111:	83 c4 10             	add    $0x10,%esp
 114:	85 c0                	test   %eax,%eax
 116:	7e 17                	jle    12f <gets+0x4d>
      break;
    buf[i++] = c;
 118:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11c:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 11f:	3c 0a                	cmp    $0xa,%al
 121:	0f 94 c2             	sete   %dl
 124:	3c 0d                	cmp    $0xd,%al
 126:	0f 94 c0             	sete   %al
 129:	08 c2                	or     %al,%dl
 12b:	74 ca                	je     f7 <gets+0x15>
    buf[i++] = c;
 12d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 12f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 133:	89 f8                	mov    %edi,%eax
 135:	8d 65 f4             	lea    -0xc(%ebp),%esp
 138:	5b                   	pop    %ebx
 139:	5e                   	pop    %esi
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <stat>:

int
stat(const char *n, struct stat *st)
{
 13d:	f3 0f 1e fb          	endbr32 
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 146:	83 ec 08             	sub    $0x8,%esp
 149:	6a 00                	push   $0x0
 14b:	ff 75 08             	pushl  0x8(%ebp)
 14e:	e8 dc 00 00 00       	call   22f <open>
  if(fd < 0)
 153:	83 c4 10             	add    $0x10,%esp
 156:	85 c0                	test   %eax,%eax
 158:	78 24                	js     17e <stat+0x41>
 15a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	ff 75 0c             	pushl  0xc(%ebp)
 162:	50                   	push   %eax
 163:	e8 df 00 00 00       	call   247 <fstat>
 168:	89 c6                	mov    %eax,%esi
  close(fd);
 16a:	89 1c 24             	mov    %ebx,(%esp)
 16d:	e8 a5 00 00 00       	call   217 <close>
  return r;
 172:	83 c4 10             	add    $0x10,%esp
}
 175:	89 f0                	mov    %esi,%eax
 177:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17a:	5b                   	pop    %ebx
 17b:	5e                   	pop    %esi
 17c:	5d                   	pop    %ebp
 17d:	c3                   	ret    
    return -1;
 17e:	be ff ff ff ff       	mov    $0xffffffff,%esi
 183:	eb f0                	jmp    175 <stat+0x38>

00000185 <atoi>:

int
atoi(const char *s)
{
 185:	f3 0f 1e fb          	endbr32 
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	53                   	push   %ebx
 18d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 190:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 195:	0f b6 01             	movzbl (%ecx),%eax
 198:	8d 58 d0             	lea    -0x30(%eax),%ebx
 19b:	80 fb 09             	cmp    $0x9,%bl
 19e:	77 12                	ja     1b2 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1a0:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1a3:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1a6:	83 c1 01             	add    $0x1,%ecx
 1a9:	0f be c0             	movsbl %al,%eax
 1ac:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1b0:	eb e3                	jmp    195 <atoi+0x10>
  return n;
}
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	5b                   	pop    %ebx
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    

000001b7 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1b7:	f3 0f 1e fb          	endbr32 
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	56                   	push   %esi
 1bf:	53                   	push   %ebx
 1c0:	8b 75 08             	mov    0x8(%ebp),%esi
 1c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c9:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1cb:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1ce:	85 c0                	test   %eax,%eax
 1d0:	7e 0f                	jle    1e1 <memmove+0x2a>
    *dst++ = *src++;
 1d2:	0f b6 01             	movzbl (%ecx),%eax
 1d5:	88 02                	mov    %al,(%edx)
 1d7:	8d 49 01             	lea    0x1(%ecx),%ecx
 1da:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1dd:	89 d8                	mov    %ebx,%eax
 1df:	eb ea                	jmp    1cb <memmove+0x14>
  return vdst;
}
 1e1:	89 f0                	mov    %esi,%eax
 1e3:	5b                   	pop    %ebx
 1e4:	5e                   	pop    %esi
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e7:	b8 01 00 00 00       	mov    $0x1,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret    

000001ef <exit>:
SYSCALL(exit)
 1ef:	b8 02 00 00 00       	mov    $0x2,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret    

000001f7 <wait>:
SYSCALL(wait)
 1f7:	b8 03 00 00 00       	mov    $0x3,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <pipe>:
SYSCALL(pipe)
 1ff:	b8 04 00 00 00       	mov    $0x4,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <read>:
SYSCALL(read)
 207:	b8 05 00 00 00       	mov    $0x5,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <write>:
SYSCALL(write)
 20f:	b8 10 00 00 00       	mov    $0x10,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <close>:
SYSCALL(close)
 217:	b8 15 00 00 00       	mov    $0x15,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <kill>:
SYSCALL(kill)
 21f:	b8 06 00 00 00       	mov    $0x6,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <exec>:
SYSCALL(exec)
 227:	b8 07 00 00 00       	mov    $0x7,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <open>:
SYSCALL(open)
 22f:	b8 0f 00 00 00       	mov    $0xf,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <mknod>:
SYSCALL(mknod)
 237:	b8 11 00 00 00       	mov    $0x11,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <unlink>:
SYSCALL(unlink)
 23f:	b8 12 00 00 00       	mov    $0x12,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <fstat>:
SYSCALL(fstat)
 247:	b8 08 00 00 00       	mov    $0x8,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <link>:
SYSCALL(link)
 24f:	b8 13 00 00 00       	mov    $0x13,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <mkdir>:
SYSCALL(mkdir)
 257:	b8 14 00 00 00       	mov    $0x14,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <chdir>:
SYSCALL(chdir)
 25f:	b8 09 00 00 00       	mov    $0x9,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <dup>:
SYSCALL(dup)
 267:	b8 0a 00 00 00       	mov    $0xa,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <getpid>:
SYSCALL(getpid)
 26f:	b8 0b 00 00 00       	mov    $0xb,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <sbrk>:
SYSCALL(sbrk)
 277:	b8 0c 00 00 00       	mov    $0xc,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <sleep>:
SYSCALL(sleep)
 27f:	b8 0d 00 00 00       	mov    $0xd,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <uptime>:
SYSCALL(uptime)
 287:	b8 0e 00 00 00       	mov    $0xe,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	83 ec 1c             	sub    $0x1c,%esp
 295:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 298:	6a 01                	push   $0x1
 29a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 29d:	52                   	push   %edx
 29e:	50                   	push   %eax
 29f:	e8 6b ff ff ff       	call   20f <write>
}
 2a4:	83 c4 10             	add    $0x10,%esp
 2a7:	c9                   	leave  
 2a8:	c3                   	ret    

000002a9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	57                   	push   %edi
 2ad:	56                   	push   %esi
 2ae:	53                   	push   %ebx
 2af:	83 ec 2c             	sub    $0x2c,%esp
 2b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2b5:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2bb:	0f 95 c2             	setne  %dl
 2be:	89 f0                	mov    %esi,%eax
 2c0:	c1 e8 1f             	shr    $0x1f,%eax
 2c3:	84 c2                	test   %al,%dl
 2c5:	74 42                	je     309 <printint+0x60>
    neg = 1;
    x = -xx;
 2c7:	f7 de                	neg    %esi
    neg = 1;
 2c9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2d5:	89 f0                	mov    %esi,%eax
 2d7:	ba 00 00 00 00       	mov    $0x0,%edx
 2dc:	f7 f1                	div    %ecx
 2de:	89 df                	mov    %ebx,%edi
 2e0:	83 c3 01             	add    $0x1,%ebx
 2e3:	0f b6 92 f8 05 00 00 	movzbl 0x5f8(%edx),%edx
 2ea:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2ee:	89 f2                	mov    %esi,%edx
 2f0:	89 c6                	mov    %eax,%esi
 2f2:	39 d1                	cmp    %edx,%ecx
 2f4:	76 df                	jbe    2d5 <printint+0x2c>
  if(neg)
 2f6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 2fa:	74 2f                	je     32b <printint+0x82>
    buf[i++] = '-';
 2fc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 301:	8d 5f 02             	lea    0x2(%edi),%ebx
 304:	8b 75 d0             	mov    -0x30(%ebp),%esi
 307:	eb 15                	jmp    31e <printint+0x75>
  neg = 0;
 309:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 310:	eb be                	jmp    2d0 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 312:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 317:	89 f0                	mov    %esi,%eax
 319:	e8 71 ff ff ff       	call   28f <putc>
  while(--i >= 0)
 31e:	83 eb 01             	sub    $0x1,%ebx
 321:	79 ef                	jns    312 <printint+0x69>
}
 323:	83 c4 2c             	add    $0x2c,%esp
 326:	5b                   	pop    %ebx
 327:	5e                   	pop    %esi
 328:	5f                   	pop    %edi
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    
 32b:	8b 75 d0             	mov    -0x30(%ebp),%esi
 32e:	eb ee                	jmp    31e <printint+0x75>

00000330 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 330:	f3 0f 1e fb          	endbr32 
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	57                   	push   %edi
 338:	56                   	push   %esi
 339:	53                   	push   %ebx
 33a:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 33d:	8d 45 10             	lea    0x10(%ebp),%eax
 340:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 343:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 348:	bb 00 00 00 00       	mov    $0x0,%ebx
 34d:	eb 14                	jmp    363 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 34f:	89 fa                	mov    %edi,%edx
 351:	8b 45 08             	mov    0x8(%ebp),%eax
 354:	e8 36 ff ff ff       	call   28f <putc>
 359:	eb 05                	jmp    360 <printf+0x30>
      }
    } else if(state == '%'){
 35b:	83 fe 25             	cmp    $0x25,%esi
 35e:	74 25                	je     385 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 360:	83 c3 01             	add    $0x1,%ebx
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 36a:	84 c0                	test   %al,%al
 36c:	0f 84 23 01 00 00    	je     495 <printf+0x165>
    c = fmt[i] & 0xff;
 372:	0f be f8             	movsbl %al,%edi
 375:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 378:	85 f6                	test   %esi,%esi
 37a:	75 df                	jne    35b <printf+0x2b>
      if(c == '%'){
 37c:	83 f8 25             	cmp    $0x25,%eax
 37f:	75 ce                	jne    34f <printf+0x1f>
        state = '%';
 381:	89 c6                	mov    %eax,%esi
 383:	eb db                	jmp    360 <printf+0x30>
      if(c == 'd'){
 385:	83 f8 64             	cmp    $0x64,%eax
 388:	74 49                	je     3d3 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 38a:	83 f8 78             	cmp    $0x78,%eax
 38d:	0f 94 c1             	sete   %cl
 390:	83 f8 70             	cmp    $0x70,%eax
 393:	0f 94 c2             	sete   %dl
 396:	08 d1                	or     %dl,%cl
 398:	75 63                	jne    3fd <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 39a:	83 f8 73             	cmp    $0x73,%eax
 39d:	0f 84 84 00 00 00    	je     427 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3a3:	83 f8 63             	cmp    $0x63,%eax
 3a6:	0f 84 b7 00 00 00    	je     463 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3ac:	83 f8 25             	cmp    $0x25,%eax
 3af:	0f 84 cc 00 00 00    	je     481 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3b5:	ba 25 00 00 00       	mov    $0x25,%edx
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	e8 cd fe ff ff       	call   28f <putc>
        putc(fd, c);
 3c2:	89 fa                	mov    %edi,%edx
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	e8 c3 fe ff ff       	call   28f <putc>
      }
      state = 0;
 3cc:	be 00 00 00 00       	mov    $0x0,%esi
 3d1:	eb 8d                	jmp    360 <printf+0x30>
        printint(fd, *ap, 10, 1);
 3d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d6:	8b 17                	mov    (%edi),%edx
 3d8:	83 ec 0c             	sub    $0xc,%esp
 3db:	6a 01                	push   $0x1
 3dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	e8 bf fe ff ff       	call   2a9 <printint>
        ap++;
 3ea:	83 c7 04             	add    $0x4,%edi
 3ed:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3f3:	be 00 00 00 00       	mov    $0x0,%esi
 3f8:	e9 63 ff ff ff       	jmp    360 <printf+0x30>
        printint(fd, *ap, 16, 0);
 3fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 400:	8b 17                	mov    (%edi),%edx
 402:	83 ec 0c             	sub    $0xc,%esp
 405:	6a 00                	push   $0x0
 407:	b9 10 00 00 00       	mov    $0x10,%ecx
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	e8 95 fe ff ff       	call   2a9 <printint>
        ap++;
 414:	83 c7 04             	add    $0x4,%edi
 417:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 41d:	be 00 00 00 00       	mov    $0x0,%esi
 422:	e9 39 ff ff ff       	jmp    360 <printf+0x30>
        s = (char*)*ap;
 427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 42a:	8b 30                	mov    (%eax),%esi
        ap++;
 42c:	83 c0 04             	add    $0x4,%eax
 42f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 432:	85 f6                	test   %esi,%esi
 434:	75 28                	jne    45e <printf+0x12e>
          s = "(null)";
 436:	be f0 05 00 00       	mov    $0x5f0,%esi
 43b:	8b 7d 08             	mov    0x8(%ebp),%edi
 43e:	eb 0d                	jmp    44d <printf+0x11d>
          putc(fd, *s);
 440:	0f be d2             	movsbl %dl,%edx
 443:	89 f8                	mov    %edi,%eax
 445:	e8 45 fe ff ff       	call   28f <putc>
          s++;
 44a:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 44d:	0f b6 16             	movzbl (%esi),%edx
 450:	84 d2                	test   %dl,%dl
 452:	75 ec                	jne    440 <printf+0x110>
      state = 0;
 454:	be 00 00 00 00       	mov    $0x0,%esi
 459:	e9 02 ff ff ff       	jmp    360 <printf+0x30>
 45e:	8b 7d 08             	mov    0x8(%ebp),%edi
 461:	eb ea                	jmp    44d <printf+0x11d>
        putc(fd, *ap);
 463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 466:	0f be 17             	movsbl (%edi),%edx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	e8 1e fe ff ff       	call   28f <putc>
        ap++;
 471:	83 c7 04             	add    $0x4,%edi
 474:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 477:	be 00 00 00 00       	mov    $0x0,%esi
 47c:	e9 df fe ff ff       	jmp    360 <printf+0x30>
        putc(fd, c);
 481:	89 fa                	mov    %edi,%edx
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	e8 04 fe ff ff       	call   28f <putc>
      state = 0;
 48b:	be 00 00 00 00       	mov    $0x0,%esi
 490:	e9 cb fe ff ff       	jmp    360 <printf+0x30>
    }
  }
}
 495:	8d 65 f4             	lea    -0xc(%ebp),%esp
 498:	5b                   	pop    %ebx
 499:	5e                   	pop    %esi
 49a:	5f                   	pop    %edi
 49b:	5d                   	pop    %ebp
 49c:	c3                   	ret    

0000049d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 49d:	f3 0f 1e fb          	endbr32 
 4a1:	55                   	push   %ebp
 4a2:	89 e5                	mov    %esp,%ebp
 4a4:	57                   	push   %edi
 4a5:	56                   	push   %esi
 4a6:	53                   	push   %ebx
 4a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4aa:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ad:	a1 98 08 00 00       	mov    0x898,%eax
 4b2:	eb 02                	jmp    4b6 <free+0x19>
 4b4:	89 d0                	mov    %edx,%eax
 4b6:	39 c8                	cmp    %ecx,%eax
 4b8:	73 04                	jae    4be <free+0x21>
 4ba:	39 08                	cmp    %ecx,(%eax)
 4bc:	77 12                	ja     4d0 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4be:	8b 10                	mov    (%eax),%edx
 4c0:	39 c2                	cmp    %eax,%edx
 4c2:	77 f0                	ja     4b4 <free+0x17>
 4c4:	39 c8                	cmp    %ecx,%eax
 4c6:	72 08                	jb     4d0 <free+0x33>
 4c8:	39 ca                	cmp    %ecx,%edx
 4ca:	77 04                	ja     4d0 <free+0x33>
 4cc:	89 d0                	mov    %edx,%eax
 4ce:	eb e6                	jmp    4b6 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4d0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4d3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4d6:	8b 10                	mov    (%eax),%edx
 4d8:	39 d7                	cmp    %edx,%edi
 4da:	74 19                	je     4f5 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4dc:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4df:	8b 50 04             	mov    0x4(%eax),%edx
 4e2:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4e5:	39 ce                	cmp    %ecx,%esi
 4e7:	74 1b                	je     504 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4e9:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4eb:	a3 98 08 00 00       	mov    %eax,0x898
}
 4f0:	5b                   	pop    %ebx
 4f1:	5e                   	pop    %esi
 4f2:	5f                   	pop    %edi
 4f3:	5d                   	pop    %ebp
 4f4:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4f5:	03 72 04             	add    0x4(%edx),%esi
 4f8:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4fb:	8b 10                	mov    (%eax),%edx
 4fd:	8b 12                	mov    (%edx),%edx
 4ff:	89 53 f8             	mov    %edx,-0x8(%ebx)
 502:	eb db                	jmp    4df <free+0x42>
    p->s.size += bp->s.size;
 504:	03 53 fc             	add    -0x4(%ebx),%edx
 507:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 50a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 50d:	89 10                	mov    %edx,(%eax)
 50f:	eb da                	jmp    4eb <free+0x4e>

00000511 <morecore>:

static Header*
morecore(uint nu)
{
 511:	55                   	push   %ebp
 512:	89 e5                	mov    %esp,%ebp
 514:	53                   	push   %ebx
 515:	83 ec 04             	sub    $0x4,%esp
 518:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 51a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 51f:	77 05                	ja     526 <morecore+0x15>
    nu = 4096;
 521:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 526:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 52d:	83 ec 0c             	sub    $0xc,%esp
 530:	50                   	push   %eax
 531:	e8 41 fd ff ff       	call   277 <sbrk>
  if(p == (char*)-1)
 536:	83 c4 10             	add    $0x10,%esp
 539:	83 f8 ff             	cmp    $0xffffffff,%eax
 53c:	74 1c                	je     55a <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 53e:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 541:	83 c0 08             	add    $0x8,%eax
 544:	83 ec 0c             	sub    $0xc,%esp
 547:	50                   	push   %eax
 548:	e8 50 ff ff ff       	call   49d <free>
  return freep;
 54d:	a1 98 08 00 00       	mov    0x898,%eax
 552:	83 c4 10             	add    $0x10,%esp
}
 555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 558:	c9                   	leave  
 559:	c3                   	ret    
    return 0;
 55a:	b8 00 00 00 00       	mov    $0x0,%eax
 55f:	eb f4                	jmp    555 <morecore+0x44>

00000561 <malloc>:

void*
malloc(uint nbytes)
{
 561:	f3 0f 1e fb          	endbr32 
 565:	55                   	push   %ebp
 566:	89 e5                	mov    %esp,%ebp
 568:	53                   	push   %ebx
 569:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	8d 58 07             	lea    0x7(%eax),%ebx
 572:	c1 eb 03             	shr    $0x3,%ebx
 575:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 578:	8b 0d 98 08 00 00    	mov    0x898,%ecx
 57e:	85 c9                	test   %ecx,%ecx
 580:	74 04                	je     586 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 582:	8b 01                	mov    (%ecx),%eax
 584:	eb 4b                	jmp    5d1 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 586:	c7 05 98 08 00 00 9c 	movl   $0x89c,0x898
 58d:	08 00 00 
 590:	c7 05 9c 08 00 00 9c 	movl   $0x89c,0x89c
 597:	08 00 00 
    base.s.size = 0;
 59a:	c7 05 a0 08 00 00 00 	movl   $0x0,0x8a0
 5a1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5a4:	b9 9c 08 00 00       	mov    $0x89c,%ecx
 5a9:	eb d7                	jmp    582 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5ab:	74 1a                	je     5c7 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ad:	29 da                	sub    %ebx,%edx
 5af:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5b2:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5b5:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5b8:	89 0d 98 08 00 00    	mov    %ecx,0x898
      return (void*)(p + 1);
 5be:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5c1:	83 c4 04             	add    $0x4,%esp
 5c4:	5b                   	pop    %ebx
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5c7:	8b 10                	mov    (%eax),%edx
 5c9:	89 11                	mov    %edx,(%ecx)
 5cb:	eb eb                	jmp    5b8 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5cd:	89 c1                	mov    %eax,%ecx
 5cf:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5d1:	8b 50 04             	mov    0x4(%eax),%edx
 5d4:	39 da                	cmp    %ebx,%edx
 5d6:	73 d3                	jae    5ab <malloc+0x4a>
    if(p == freep)
 5d8:	39 05 98 08 00 00    	cmp    %eax,0x898
 5de:	75 ed                	jne    5cd <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 5e0:	89 d8                	mov    %ebx,%eax
 5e2:	e8 2a ff ff ff       	call   511 <morecore>
 5e7:	85 c0                	test   %eax,%eax
 5e9:	75 e2                	jne    5cd <malloc+0x6c>
 5eb:	eb d4                	jmp    5c1 <malloc+0x60>
