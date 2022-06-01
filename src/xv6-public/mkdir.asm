
_mkdir:     file format elf32-i386


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
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 39                	mov    (%ecx),%edi
  1a:	8b 41 04             	mov    0x4(%ecx),%eax
  1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int i;

  if(argc < 2){
  20:	83 ff 01             	cmp    $0x1,%edi
  23:	7e 25                	jle    4a <main+0x4a>
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  25:	bb 01 00 00 00       	mov    $0x1,%ebx
  2a:	39 fb                	cmp    %edi,%ebx
  2c:	7d 44                	jge    72 <main+0x72>
    if(mkdir(argv[i]) < 0){
  2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  31:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  34:	83 ec 0c             	sub    $0xc,%esp
  37:	ff 36                	pushl  (%esi)
  39:	e8 5e 02 00 00       	call   29c <mkdir>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	85 c0                	test   %eax,%eax
  43:	78 19                	js     5e <main+0x5e>
  for(i = 1; i < argc; i++){
  45:	83 c3 01             	add    $0x1,%ebx
  48:	eb e0                	jmp    2a <main+0x2a>
    printf(2, "Usage: mkdir files...\n");
  4a:	83 ec 08             	sub    $0x8,%esp
  4d:	68 44 06 00 00       	push   $0x644
  52:	6a 02                	push   $0x2
  54:	e8 2c 03 00 00       	call   385 <printf>
    exit();
  59:	e8 d6 01 00 00       	call   234 <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5e:	83 ec 04             	sub    $0x4,%esp
  61:	ff 36                	pushl  (%esi)
  63:	68 5b 06 00 00       	push   $0x65b
  68:	6a 02                	push   $0x2
  6a:	e8 16 03 00 00       	call   385 <printf>
      break;
  6f:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  72:	e8 bd 01 00 00       	call   234 <exit>

00000077 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  77:	f3 0f 1e fb          	endbr32 
  7b:	55                   	push   %ebp
  7c:	89 e5                	mov    %esp,%ebp
  7e:	56                   	push   %esi
  7f:	53                   	push   %ebx
  80:	8b 75 08             	mov    0x8(%ebp),%esi
  83:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  86:	89 f0                	mov    %esi,%eax
  88:	89 d1                	mov    %edx,%ecx
  8a:	83 c2 01             	add    $0x1,%edx
  8d:	89 c3                	mov    %eax,%ebx
  8f:	83 c0 01             	add    $0x1,%eax
  92:	0f b6 09             	movzbl (%ecx),%ecx
  95:	88 0b                	mov    %cl,(%ebx)
  97:	84 c9                	test   %cl,%cl
  99:	75 ed                	jne    88 <strcpy+0x11>
    ;
  return os;
}
  9b:	89 f0                	mov    %esi,%eax
  9d:	5b                   	pop    %ebx
  9e:	5e                   	pop    %esi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a1:	f3 0f 1e fb          	endbr32 
  a5:	55                   	push   %ebp
  a6:	89 e5                	mov    %esp,%ebp
  a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ae:	0f b6 01             	movzbl (%ecx),%eax
  b1:	84 c0                	test   %al,%al
  b3:	74 0c                	je     c1 <strcmp+0x20>
  b5:	3a 02                	cmp    (%edx),%al
  b7:	75 08                	jne    c1 <strcmp+0x20>
    p++, q++;
  b9:	83 c1 01             	add    $0x1,%ecx
  bc:	83 c2 01             	add    $0x1,%edx
  bf:	eb ed                	jmp    ae <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  c1:	0f b6 c0             	movzbl %al,%eax
  c4:	0f b6 12             	movzbl (%edx),%edx
  c7:	29 d0                	sub    %edx,%eax
}
  c9:	5d                   	pop    %ebp
  ca:	c3                   	ret    

000000cb <strlen>:

uint
strlen(const char *s)
{
  cb:	f3 0f 1e fb          	endbr32 
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d5:	b8 00 00 00 00       	mov    $0x0,%eax
  da:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  de:	74 05                	je     e5 <strlen+0x1a>
  e0:	83 c0 01             	add    $0x1,%eax
  e3:	eb f5                	jmp    da <strlen+0xf>
    ;
  return n;
}
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    

000000e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e7:	f3 0f 1e fb          	endbr32 
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	57                   	push   %edi
  ef:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f2:	89 d7                	mov    %edx,%edi
  f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	fc                   	cld    
  fb:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fd:	89 d0                	mov    %edx,%eax
  ff:	5f                   	pop    %edi
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	f3 0f 1e fb          	endbr32 
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 110:	0f b6 10             	movzbl (%eax),%edx
 113:	84 d2                	test   %dl,%dl
 115:	74 09                	je     120 <strchr+0x1e>
    if(*s == c)
 117:	38 ca                	cmp    %cl,%dl
 119:	74 0a                	je     125 <strchr+0x23>
  for(; *s; s++)
 11b:	83 c0 01             	add    $0x1,%eax
 11e:	eb f0                	jmp    110 <strchr+0xe>
      return (char*)s;
  return 0;
 120:	b8 00 00 00 00       	mov    $0x0,%eax
}
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <gets>:

char*
gets(char *buf, int max)
{
 127:	f3 0f 1e fb          	endbr32 
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	56                   	push   %esi
 130:	53                   	push   %ebx
 131:	83 ec 1c             	sub    $0x1c,%esp
 134:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	bb 00 00 00 00       	mov    $0x0,%ebx
 13c:	89 de                	mov    %ebx,%esi
 13e:	83 c3 01             	add    $0x1,%ebx
 141:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 144:	7d 2e                	jge    174 <gets+0x4d>
    cc = read(0, &c, 1);
 146:	83 ec 04             	sub    $0x4,%esp
 149:	6a 01                	push   $0x1
 14b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 14e:	50                   	push   %eax
 14f:	6a 00                	push   $0x0
 151:	e8 f6 00 00 00       	call   24c <read>
    if(cc < 1)
 156:	83 c4 10             	add    $0x10,%esp
 159:	85 c0                	test   %eax,%eax
 15b:	7e 17                	jle    174 <gets+0x4d>
      break;
    buf[i++] = c;
 15d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 161:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 164:	3c 0a                	cmp    $0xa,%al
 166:	0f 94 c2             	sete   %dl
 169:	3c 0d                	cmp    $0xd,%al
 16b:	0f 94 c0             	sete   %al
 16e:	08 c2                	or     %al,%dl
 170:	74 ca                	je     13c <gets+0x15>
    buf[i++] = c;
 172:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 174:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 178:	89 f8                	mov    %edi,%eax
 17a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17d:	5b                   	pop    %ebx
 17e:	5e                   	pop    %esi
 17f:	5f                   	pop    %edi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    

00000182 <stat>:

int
stat(const char *n, struct stat *st)
{
 182:	f3 0f 1e fb          	endbr32 
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	56                   	push   %esi
 18a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	6a 00                	push   $0x0
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 dc 00 00 00       	call   274 <open>
  if(fd < 0)
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	78 24                	js     1c3 <stat+0x41>
 19f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a1:	83 ec 08             	sub    $0x8,%esp
 1a4:	ff 75 0c             	pushl  0xc(%ebp)
 1a7:	50                   	push   %eax
 1a8:	e8 df 00 00 00       	call   28c <fstat>
 1ad:	89 c6                	mov    %eax,%esi
  close(fd);
 1af:	89 1c 24             	mov    %ebx,(%esp)
 1b2:	e8 a5 00 00 00       	call   25c <close>
  return r;
 1b7:	83 c4 10             	add    $0x10,%esp
}
 1ba:	89 f0                	mov    %esi,%eax
 1bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bf:	5b                   	pop    %ebx
 1c0:	5e                   	pop    %esi
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
    return -1;
 1c3:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c8:	eb f0                	jmp    1ba <stat+0x38>

000001ca <atoi>:

int
atoi(const char *s)
{
 1ca:	f3 0f 1e fb          	endbr32 
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	53                   	push   %ebx
 1d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1d5:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1da:	0f b6 01             	movzbl (%ecx),%eax
 1dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1e0:	80 fb 09             	cmp    $0x9,%bl
 1e3:	77 12                	ja     1f7 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1e5:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1e8:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1eb:	83 c1 01             	add    $0x1,%ecx
 1ee:	0f be c0             	movsbl %al,%eax
 1f1:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1f5:	eb e3                	jmp    1da <atoi+0x10>
  return n;
}
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	5b                   	pop    %ebx
 1fa:	5d                   	pop    %ebp
 1fb:	c3                   	ret    

000001fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fc:	f3 0f 1e fb          	endbr32 
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
 205:	8b 75 08             	mov    0x8(%ebp),%esi
 208:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 20b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 20e:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 210:	8d 58 ff             	lea    -0x1(%eax),%ebx
 213:	85 c0                	test   %eax,%eax
 215:	7e 0f                	jle    226 <memmove+0x2a>
    *dst++ = *src++;
 217:	0f b6 01             	movzbl (%ecx),%eax
 21a:	88 02                	mov    %al,(%edx)
 21c:	8d 49 01             	lea    0x1(%ecx),%ecx
 21f:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 222:	89 d8                	mov    %ebx,%eax
 224:	eb ea                	jmp    210 <memmove+0x14>
  return vdst;
}
 226:	89 f0                	mov    %esi,%eax
 228:	5b                   	pop    %ebx
 229:	5e                   	pop    %esi
 22a:	5d                   	pop    %ebp
 22b:	c3                   	ret    

0000022c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 22c:	b8 01 00 00 00       	mov    $0x1,%eax
 231:	cd 40                	int    $0x40
 233:	c3                   	ret    

00000234 <exit>:
SYSCALL(exit)
 234:	b8 02 00 00 00       	mov    $0x2,%eax
 239:	cd 40                	int    $0x40
 23b:	c3                   	ret    

0000023c <wait>:
SYSCALL(wait)
 23c:	b8 03 00 00 00       	mov    $0x3,%eax
 241:	cd 40                	int    $0x40
 243:	c3                   	ret    

00000244 <pipe>:
SYSCALL(pipe)
 244:	b8 04 00 00 00       	mov    $0x4,%eax
 249:	cd 40                	int    $0x40
 24b:	c3                   	ret    

0000024c <read>:
SYSCALL(read)
 24c:	b8 05 00 00 00       	mov    $0x5,%eax
 251:	cd 40                	int    $0x40
 253:	c3                   	ret    

00000254 <write>:
SYSCALL(write)
 254:	b8 10 00 00 00       	mov    $0x10,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	ret    

0000025c <close>:
SYSCALL(close)
 25c:	b8 15 00 00 00       	mov    $0x15,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <kill>:
SYSCALL(kill)
 264:	b8 06 00 00 00       	mov    $0x6,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <exec>:
SYSCALL(exec)
 26c:	b8 07 00 00 00       	mov    $0x7,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <open>:
SYSCALL(open)
 274:	b8 0f 00 00 00       	mov    $0xf,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <mknod>:
SYSCALL(mknod)
 27c:	b8 11 00 00 00       	mov    $0x11,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <unlink>:
SYSCALL(unlink)
 284:	b8 12 00 00 00       	mov    $0x12,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <fstat>:
SYSCALL(fstat)
 28c:	b8 08 00 00 00       	mov    $0x8,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <link>:
SYSCALL(link)
 294:	b8 13 00 00 00       	mov    $0x13,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <mkdir>:
SYSCALL(mkdir)
 29c:	b8 14 00 00 00       	mov    $0x14,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <chdir>:
SYSCALL(chdir)
 2a4:	b8 09 00 00 00       	mov    $0x9,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <dup>:
SYSCALL(dup)
 2ac:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <getpid>:
SYSCALL(getpid)
 2b4:	b8 0b 00 00 00       	mov    $0xb,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <sbrk>:
SYSCALL(sbrk)
 2bc:	b8 0c 00 00 00       	mov    $0xc,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <sleep>:
SYSCALL(sleep)
 2c4:	b8 0d 00 00 00       	mov    $0xd,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <uptime>:
SYSCALL(uptime)
 2cc:	b8 0e 00 00 00       	mov    $0xe,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2d4:	b8 16 00 00 00       	mov    $0x16,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <get_ancestors>:
SYSCALL(get_ancestors)
 2dc:	b8 17 00 00 00       	mov    $0x17,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	83 ec 1c             	sub    $0x1c,%esp
 2ea:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2ed:	6a 01                	push   $0x1
 2ef:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2f2:	52                   	push   %edx
 2f3:	50                   	push   %eax
 2f4:	e8 5b ff ff ff       	call   254 <write>
}
 2f9:	83 c4 10             	add    $0x10,%esp
 2fc:	c9                   	leave  
 2fd:	c3                   	ret    

000002fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2fe:	55                   	push   %ebp
 2ff:	89 e5                	mov    %esp,%ebp
 301:	57                   	push   %edi
 302:	56                   	push   %esi
 303:	53                   	push   %ebx
 304:	83 ec 2c             	sub    $0x2c,%esp
 307:	89 45 d0             	mov    %eax,-0x30(%ebp)
 30a:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 30c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 310:	0f 95 c2             	setne  %dl
 313:	89 f0                	mov    %esi,%eax
 315:	c1 e8 1f             	shr    $0x1f,%eax
 318:	84 c2                	test   %al,%dl
 31a:	74 42                	je     35e <printint+0x60>
    neg = 1;
    x = -xx;
 31c:	f7 de                	neg    %esi
    neg = 1;
 31e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 325:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 32a:	89 f0                	mov    %esi,%eax
 32c:	ba 00 00 00 00       	mov    $0x0,%edx
 331:	f7 f1                	div    %ecx
 333:	89 df                	mov    %ebx,%edi
 335:	83 c3 01             	add    $0x1,%ebx
 338:	0f b6 92 80 06 00 00 	movzbl 0x680(%edx),%edx
 33f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 343:	89 f2                	mov    %esi,%edx
 345:	89 c6                	mov    %eax,%esi
 347:	39 d1                	cmp    %edx,%ecx
 349:	76 df                	jbe    32a <printint+0x2c>
  if(neg)
 34b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 34f:	74 2f                	je     380 <printint+0x82>
    buf[i++] = '-';
 351:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 356:	8d 5f 02             	lea    0x2(%edi),%ebx
 359:	8b 75 d0             	mov    -0x30(%ebp),%esi
 35c:	eb 15                	jmp    373 <printint+0x75>
  neg = 0;
 35e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 365:	eb be                	jmp    325 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 367:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 36c:	89 f0                	mov    %esi,%eax
 36e:	e8 71 ff ff ff       	call   2e4 <putc>
  while(--i >= 0)
 373:	83 eb 01             	sub    $0x1,%ebx
 376:	79 ef                	jns    367 <printint+0x69>
}
 378:	83 c4 2c             	add    $0x2c,%esp
 37b:	5b                   	pop    %ebx
 37c:	5e                   	pop    %esi
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    
 380:	8b 75 d0             	mov    -0x30(%ebp),%esi
 383:	eb ee                	jmp    373 <printint+0x75>

00000385 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 385:	f3 0f 1e fb          	endbr32 
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	57                   	push   %edi
 38d:	56                   	push   %esi
 38e:	53                   	push   %ebx
 38f:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 392:	8d 45 10             	lea    0x10(%ebp),%eax
 395:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 398:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 39d:	bb 00 00 00 00       	mov    $0x0,%ebx
 3a2:	eb 14                	jmp    3b8 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3a4:	89 fa                	mov    %edi,%edx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	e8 36 ff ff ff       	call   2e4 <putc>
 3ae:	eb 05                	jmp    3b5 <printf+0x30>
      }
    } else if(state == '%'){
 3b0:	83 fe 25             	cmp    $0x25,%esi
 3b3:	74 25                	je     3da <printf+0x55>
  for(i = 0; fmt[i]; i++){
 3b5:	83 c3 01             	add    $0x1,%ebx
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3bf:	84 c0                	test   %al,%al
 3c1:	0f 84 23 01 00 00    	je     4ea <printf+0x165>
    c = fmt[i] & 0xff;
 3c7:	0f be f8             	movsbl %al,%edi
 3ca:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3cd:	85 f6                	test   %esi,%esi
 3cf:	75 df                	jne    3b0 <printf+0x2b>
      if(c == '%'){
 3d1:	83 f8 25             	cmp    $0x25,%eax
 3d4:	75 ce                	jne    3a4 <printf+0x1f>
        state = '%';
 3d6:	89 c6                	mov    %eax,%esi
 3d8:	eb db                	jmp    3b5 <printf+0x30>
      if(c == 'd'){
 3da:	83 f8 64             	cmp    $0x64,%eax
 3dd:	74 49                	je     428 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3df:	83 f8 78             	cmp    $0x78,%eax
 3e2:	0f 94 c1             	sete   %cl
 3e5:	83 f8 70             	cmp    $0x70,%eax
 3e8:	0f 94 c2             	sete   %dl
 3eb:	08 d1                	or     %dl,%cl
 3ed:	75 63                	jne    452 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3ef:	83 f8 73             	cmp    $0x73,%eax
 3f2:	0f 84 84 00 00 00    	je     47c <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3f8:	83 f8 63             	cmp    $0x63,%eax
 3fb:	0f 84 b7 00 00 00    	je     4b8 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 401:	83 f8 25             	cmp    $0x25,%eax
 404:	0f 84 cc 00 00 00    	je     4d6 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 40a:	ba 25 00 00 00       	mov    $0x25,%edx
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	e8 cd fe ff ff       	call   2e4 <putc>
        putc(fd, c);
 417:	89 fa                	mov    %edi,%edx
 419:	8b 45 08             	mov    0x8(%ebp),%eax
 41c:	e8 c3 fe ff ff       	call   2e4 <putc>
      }
      state = 0;
 421:	be 00 00 00 00       	mov    $0x0,%esi
 426:	eb 8d                	jmp    3b5 <printf+0x30>
        printint(fd, *ap, 10, 1);
 428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42b:	8b 17                	mov    (%edi),%edx
 42d:	83 ec 0c             	sub    $0xc,%esp
 430:	6a 01                	push   $0x1
 432:	b9 0a 00 00 00       	mov    $0xa,%ecx
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	e8 bf fe ff ff       	call   2fe <printint>
        ap++;
 43f:	83 c7 04             	add    $0x4,%edi
 442:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 445:	83 c4 10             	add    $0x10,%esp
      state = 0;
 448:	be 00 00 00 00       	mov    $0x0,%esi
 44d:	e9 63 ff ff ff       	jmp    3b5 <printf+0x30>
        printint(fd, *ap, 16, 0);
 452:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 455:	8b 17                	mov    (%edi),%edx
 457:	83 ec 0c             	sub    $0xc,%esp
 45a:	6a 00                	push   $0x0
 45c:	b9 10 00 00 00       	mov    $0x10,%ecx
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	e8 95 fe ff ff       	call   2fe <printint>
        ap++;
 469:	83 c7 04             	add    $0x4,%edi
 46c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 46f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 472:	be 00 00 00 00       	mov    $0x0,%esi
 477:	e9 39 ff ff ff       	jmp    3b5 <printf+0x30>
        s = (char*)*ap;
 47c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47f:	8b 30                	mov    (%eax),%esi
        ap++;
 481:	83 c0 04             	add    $0x4,%eax
 484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 487:	85 f6                	test   %esi,%esi
 489:	75 28                	jne    4b3 <printf+0x12e>
          s = "(null)";
 48b:	be 77 06 00 00       	mov    $0x677,%esi
 490:	8b 7d 08             	mov    0x8(%ebp),%edi
 493:	eb 0d                	jmp    4a2 <printf+0x11d>
          putc(fd, *s);
 495:	0f be d2             	movsbl %dl,%edx
 498:	89 f8                	mov    %edi,%eax
 49a:	e8 45 fe ff ff       	call   2e4 <putc>
          s++;
 49f:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4a2:	0f b6 16             	movzbl (%esi),%edx
 4a5:	84 d2                	test   %dl,%dl
 4a7:	75 ec                	jne    495 <printf+0x110>
      state = 0;
 4a9:	be 00 00 00 00       	mov    $0x0,%esi
 4ae:	e9 02 ff ff ff       	jmp    3b5 <printf+0x30>
 4b3:	8b 7d 08             	mov    0x8(%ebp),%edi
 4b6:	eb ea                	jmp    4a2 <printf+0x11d>
        putc(fd, *ap);
 4b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4bb:	0f be 17             	movsbl (%edi),%edx
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	e8 1e fe ff ff       	call   2e4 <putc>
        ap++;
 4c6:	83 c7 04             	add    $0x4,%edi
 4c9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4cc:	be 00 00 00 00       	mov    $0x0,%esi
 4d1:	e9 df fe ff ff       	jmp    3b5 <printf+0x30>
        putc(fd, c);
 4d6:	89 fa                	mov    %edi,%edx
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	e8 04 fe ff ff       	call   2e4 <putc>
      state = 0;
 4e0:	be 00 00 00 00       	mov    $0x0,%esi
 4e5:	e9 cb fe ff ff       	jmp    3b5 <printf+0x30>
    }
  }
}
 4ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ed:	5b                   	pop    %ebx
 4ee:	5e                   	pop    %esi
 4ef:	5f                   	pop    %edi
 4f0:	5d                   	pop    %ebp
 4f1:	c3                   	ret    

000004f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f2:	f3 0f 1e fb          	endbr32 
 4f6:	55                   	push   %ebp
 4f7:	89 e5                	mov    %esp,%ebp
 4f9:	57                   	push   %edi
 4fa:	56                   	push   %esi
 4fb:	53                   	push   %ebx
 4fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ff:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 502:	a1 2c 09 00 00       	mov    0x92c,%eax
 507:	eb 02                	jmp    50b <free+0x19>
 509:	89 d0                	mov    %edx,%eax
 50b:	39 c8                	cmp    %ecx,%eax
 50d:	73 04                	jae    513 <free+0x21>
 50f:	39 08                	cmp    %ecx,(%eax)
 511:	77 12                	ja     525 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 513:	8b 10                	mov    (%eax),%edx
 515:	39 c2                	cmp    %eax,%edx
 517:	77 f0                	ja     509 <free+0x17>
 519:	39 c8                	cmp    %ecx,%eax
 51b:	72 08                	jb     525 <free+0x33>
 51d:	39 ca                	cmp    %ecx,%edx
 51f:	77 04                	ja     525 <free+0x33>
 521:	89 d0                	mov    %edx,%eax
 523:	eb e6                	jmp    50b <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 525:	8b 73 fc             	mov    -0x4(%ebx),%esi
 528:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 52b:	8b 10                	mov    (%eax),%edx
 52d:	39 d7                	cmp    %edx,%edi
 52f:	74 19                	je     54a <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 531:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 534:	8b 50 04             	mov    0x4(%eax),%edx
 537:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 53a:	39 ce                	cmp    %ecx,%esi
 53c:	74 1b                	je     559 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 53e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 540:	a3 2c 09 00 00       	mov    %eax,0x92c
}
 545:	5b                   	pop    %ebx
 546:	5e                   	pop    %esi
 547:	5f                   	pop    %edi
 548:	5d                   	pop    %ebp
 549:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 54a:	03 72 04             	add    0x4(%edx),%esi
 54d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 550:	8b 10                	mov    (%eax),%edx
 552:	8b 12                	mov    (%edx),%edx
 554:	89 53 f8             	mov    %edx,-0x8(%ebx)
 557:	eb db                	jmp    534 <free+0x42>
    p->s.size += bp->s.size;
 559:	03 53 fc             	add    -0x4(%ebx),%edx
 55c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 55f:	8b 53 f8             	mov    -0x8(%ebx),%edx
 562:	89 10                	mov    %edx,(%eax)
 564:	eb da                	jmp    540 <free+0x4e>

00000566 <morecore>:

static Header*
morecore(uint nu)
{
 566:	55                   	push   %ebp
 567:	89 e5                	mov    %esp,%ebp
 569:	53                   	push   %ebx
 56a:	83 ec 04             	sub    $0x4,%esp
 56d:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 56f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 574:	77 05                	ja     57b <morecore+0x15>
    nu = 4096;
 576:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 57b:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 582:	83 ec 0c             	sub    $0xc,%esp
 585:	50                   	push   %eax
 586:	e8 31 fd ff ff       	call   2bc <sbrk>
  if(p == (char*)-1)
 58b:	83 c4 10             	add    $0x10,%esp
 58e:	83 f8 ff             	cmp    $0xffffffff,%eax
 591:	74 1c                	je     5af <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 593:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 596:	83 c0 08             	add    $0x8,%eax
 599:	83 ec 0c             	sub    $0xc,%esp
 59c:	50                   	push   %eax
 59d:	e8 50 ff ff ff       	call   4f2 <free>
  return freep;
 5a2:	a1 2c 09 00 00       	mov    0x92c,%eax
 5a7:	83 c4 10             	add    $0x10,%esp
}
 5aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ad:	c9                   	leave  
 5ae:	c3                   	ret    
    return 0;
 5af:	b8 00 00 00 00       	mov    $0x0,%eax
 5b4:	eb f4                	jmp    5aa <morecore+0x44>

000005b6 <malloc>:

void*
malloc(uint nbytes)
{
 5b6:	f3 0f 1e fb          	endbr32 
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	53                   	push   %ebx
 5be:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	8d 58 07             	lea    0x7(%eax),%ebx
 5c7:	c1 eb 03             	shr    $0x3,%ebx
 5ca:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5cd:	8b 0d 2c 09 00 00    	mov    0x92c,%ecx
 5d3:	85 c9                	test   %ecx,%ecx
 5d5:	74 04                	je     5db <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d7:	8b 01                	mov    (%ecx),%eax
 5d9:	eb 4b                	jmp    626 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5db:	c7 05 2c 09 00 00 30 	movl   $0x930,0x92c
 5e2:	09 00 00 
 5e5:	c7 05 30 09 00 00 30 	movl   $0x930,0x930
 5ec:	09 00 00 
    base.s.size = 0;
 5ef:	c7 05 34 09 00 00 00 	movl   $0x0,0x934
 5f6:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5f9:	b9 30 09 00 00       	mov    $0x930,%ecx
 5fe:	eb d7                	jmp    5d7 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 600:	74 1a                	je     61c <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 602:	29 da                	sub    %ebx,%edx
 604:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 607:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 60a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 60d:	89 0d 2c 09 00 00    	mov    %ecx,0x92c
      return (void*)(p + 1);
 613:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 616:	83 c4 04             	add    $0x4,%esp
 619:	5b                   	pop    %ebx
 61a:	5d                   	pop    %ebp
 61b:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 61c:	8b 10                	mov    (%eax),%edx
 61e:	89 11                	mov    %edx,(%ecx)
 620:	eb eb                	jmp    60d <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 622:	89 c1                	mov    %eax,%ecx
 624:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 626:	8b 50 04             	mov    0x4(%eax),%edx
 629:	39 da                	cmp    %ebx,%edx
 62b:	73 d3                	jae    600 <malloc+0x4a>
    if(p == freep)
 62d:	39 05 2c 09 00 00    	cmp    %eax,0x92c
 633:	75 ed                	jne    622 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 635:	89 d8                	mov    %ebx,%eax
 637:	e8 2a ff ff ff       	call   566 <morecore>
 63c:	85 c0                	test   %eax,%eax
 63e:	75 e2                	jne    622 <malloc+0x6c>
 640:	eb d4                	jmp    616 <malloc+0x60>
