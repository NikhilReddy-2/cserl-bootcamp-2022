
_echo:     file format elf32-i386


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
  15:	83 ec 08             	sub    $0x8,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  1d:	b8 01 00 00 00       	mov    $0x1,%eax
  22:	eb 1a                	jmp    3e <main+0x3e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  24:	ba 10 06 00 00       	mov    $0x610,%edx
  29:	52                   	push   %edx
  2a:	ff 34 87             	pushl  (%edi,%eax,4)
  2d:	68 14 06 00 00       	push   $0x614
  32:	6a 01                	push   $0x1
  34:	e8 1a 03 00 00       	call   353 <printf>
  39:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  3c:	89 d8                	mov    %ebx,%eax
  3e:	39 f0                	cmp    %esi,%eax
  40:	7d 0e                	jge    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  42:	8d 58 01             	lea    0x1(%eax),%ebx
  45:	39 f3                	cmp    %esi,%ebx
  47:	7d db                	jge    24 <main+0x24>
  49:	ba 12 06 00 00       	mov    $0x612,%edx
  4e:	eb d9                	jmp    29 <main+0x29>
  exit();
  50:	e8 bd 01 00 00       	call   212 <exit>

00000055 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  55:	f3 0f 1e fb          	endbr32 
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	56                   	push   %esi
  5d:	53                   	push   %ebx
  5e:	8b 75 08             	mov    0x8(%ebp),%esi
  61:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  64:	89 f0                	mov    %esi,%eax
  66:	89 d1                	mov    %edx,%ecx
  68:	83 c2 01             	add    $0x1,%edx
  6b:	89 c3                	mov    %eax,%ebx
  6d:	83 c0 01             	add    $0x1,%eax
  70:	0f b6 09             	movzbl (%ecx),%ecx
  73:	88 0b                	mov    %cl,(%ebx)
  75:	84 c9                	test   %cl,%cl
  77:	75 ed                	jne    66 <strcpy+0x11>
    ;
  return os;
}
  79:	89 f0                	mov    %esi,%eax
  7b:	5b                   	pop    %ebx
  7c:	5e                   	pop    %esi
  7d:	5d                   	pop    %ebp
  7e:	c3                   	ret    

0000007f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7f:	f3 0f 1e fb          	endbr32 
  83:	55                   	push   %ebp
  84:	89 e5                	mov    %esp,%ebp
  86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  89:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8c:	0f b6 01             	movzbl (%ecx),%eax
  8f:	84 c0                	test   %al,%al
  91:	74 0c                	je     9f <strcmp+0x20>
  93:	3a 02                	cmp    (%edx),%al
  95:	75 08                	jne    9f <strcmp+0x20>
    p++, q++;
  97:	83 c1 01             	add    $0x1,%ecx
  9a:	83 c2 01             	add    $0x1,%edx
  9d:	eb ed                	jmp    8c <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  9f:	0f b6 c0             	movzbl %al,%eax
  a2:	0f b6 12             	movzbl (%edx),%edx
  a5:	29 d0                	sub    %edx,%eax
}
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strlen>:

uint
strlen(const char *s)
{
  a9:	f3 0f 1e fb          	endbr32 
  ad:	55                   	push   %ebp
  ae:	89 e5                	mov    %esp,%ebp
  b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b3:	b8 00 00 00 00       	mov    $0x0,%eax
  b8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  bc:	74 05                	je     c3 <strlen+0x1a>
  be:	83 c0 01             	add    $0x1,%eax
  c1:	eb f5                	jmp    b8 <strlen+0xf>
    ;
  return n;
}
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c5:	f3 0f 1e fb          	endbr32 
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  cc:	57                   	push   %edi
  cd:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d0:	89 d7                	mov    %edx,%edi
  d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  d8:	fc                   	cld    
  d9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  db:	89 d0                	mov    %edx,%eax
  dd:	5f                   	pop    %edi
  de:	5d                   	pop    %ebp
  df:	c3                   	ret    

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	f3 0f 1e fb          	endbr32 
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	84 d2                	test   %dl,%dl
  f3:	74 09                	je     fe <strchr+0x1e>
    if(*s == c)
  f5:	38 ca                	cmp    %cl,%dl
  f7:	74 0a                	je     103 <strchr+0x23>
  for(; *s; s++)
  f9:	83 c0 01             	add    $0x1,%eax
  fc:	eb f0                	jmp    ee <strchr+0xe>
      return (char*)s;
  return 0;
  fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <gets>:

char*
gets(char *buf, int max)
{
 105:	f3 0f 1e fb          	endbr32 
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	57                   	push   %edi
 10d:	56                   	push   %esi
 10e:	53                   	push   %ebx
 10f:	83 ec 1c             	sub    $0x1c,%esp
 112:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 115:	bb 00 00 00 00       	mov    $0x0,%ebx
 11a:	89 de                	mov    %ebx,%esi
 11c:	83 c3 01             	add    $0x1,%ebx
 11f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 122:	7d 2e                	jge    152 <gets+0x4d>
    cc = read(0, &c, 1);
 124:	83 ec 04             	sub    $0x4,%esp
 127:	6a 01                	push   $0x1
 129:	8d 45 e7             	lea    -0x19(%ebp),%eax
 12c:	50                   	push   %eax
 12d:	6a 00                	push   $0x0
 12f:	e8 f6 00 00 00       	call   22a <read>
    if(cc < 1)
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	7e 17                	jle    152 <gets+0x4d>
      break;
    buf[i++] = c;
 13b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 13f:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 142:	3c 0a                	cmp    $0xa,%al
 144:	0f 94 c2             	sete   %dl
 147:	3c 0d                	cmp    $0xd,%al
 149:	0f 94 c0             	sete   %al
 14c:	08 c2                	or     %al,%dl
 14e:	74 ca                	je     11a <gets+0x15>
    buf[i++] = c;
 150:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 152:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 156:	89 f8                	mov    %edi,%eax
 158:	8d 65 f4             	lea    -0xc(%ebp),%esp
 15b:	5b                   	pop    %ebx
 15c:	5e                   	pop    %esi
 15d:	5f                   	pop    %edi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <stat>:

int
stat(const char *n, struct stat *st)
{
 160:	f3 0f 1e fb          	endbr32 
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	56                   	push   %esi
 168:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 169:	83 ec 08             	sub    $0x8,%esp
 16c:	6a 00                	push   $0x0
 16e:	ff 75 08             	pushl  0x8(%ebp)
 171:	e8 dc 00 00 00       	call   252 <open>
  if(fd < 0)
 176:	83 c4 10             	add    $0x10,%esp
 179:	85 c0                	test   %eax,%eax
 17b:	78 24                	js     1a1 <stat+0x41>
 17d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	ff 75 0c             	pushl  0xc(%ebp)
 185:	50                   	push   %eax
 186:	e8 df 00 00 00       	call   26a <fstat>
 18b:	89 c6                	mov    %eax,%esi
  close(fd);
 18d:	89 1c 24             	mov    %ebx,(%esp)
 190:	e8 a5 00 00 00       	call   23a <close>
  return r;
 195:	83 c4 10             	add    $0x10,%esp
}
 198:	89 f0                	mov    %esi,%eax
 19a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 19d:	5b                   	pop    %ebx
 19e:	5e                   	pop    %esi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    
    return -1;
 1a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1a6:	eb f0                	jmp    198 <stat+0x38>

000001a8 <atoi>:

int
atoi(const char *s)
{
 1a8:	f3 0f 1e fb          	endbr32 
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	53                   	push   %ebx
 1b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1b3:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1b8:	0f b6 01             	movzbl (%ecx),%eax
 1bb:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1be:	80 fb 09             	cmp    $0x9,%bl
 1c1:	77 12                	ja     1d5 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1c3:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1c6:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1c9:	83 c1 01             	add    $0x1,%ecx
 1cc:	0f be c0             	movsbl %al,%eax
 1cf:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1d3:	eb e3                	jmp    1b8 <atoi+0x10>
  return n;
}
 1d5:	89 d0                	mov    %edx,%eax
 1d7:	5b                   	pop    %ebx
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    

000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	f3 0f 1e fb          	endbr32 
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	56                   	push   %esi
 1e2:	53                   	push   %ebx
 1e3:	8b 75 08             	mov    0x8(%ebp),%esi
 1e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1e9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1ec:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1f1:	85 c0                	test   %eax,%eax
 1f3:	7e 0f                	jle    204 <memmove+0x2a>
    *dst++ = *src++;
 1f5:	0f b6 01             	movzbl (%ecx),%eax
 1f8:	88 02                	mov    %al,(%edx)
 1fa:	8d 49 01             	lea    0x1(%ecx),%ecx
 1fd:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 200:	89 d8                	mov    %ebx,%eax
 202:	eb ea                	jmp    1ee <memmove+0x14>
  return vdst;
}
 204:	89 f0                	mov    %esi,%eax
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    

0000020a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 20a:	b8 01 00 00 00       	mov    $0x1,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <exit>:
SYSCALL(exit)
 212:	b8 02 00 00 00       	mov    $0x2,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <wait>:
SYSCALL(wait)
 21a:	b8 03 00 00 00       	mov    $0x3,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <pipe>:
SYSCALL(pipe)
 222:	b8 04 00 00 00       	mov    $0x4,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <read>:
SYSCALL(read)
 22a:	b8 05 00 00 00       	mov    $0x5,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <write>:
SYSCALL(write)
 232:	b8 10 00 00 00       	mov    $0x10,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <close>:
SYSCALL(close)
 23a:	b8 15 00 00 00       	mov    $0x15,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <kill>:
SYSCALL(kill)
 242:	b8 06 00 00 00       	mov    $0x6,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <exec>:
SYSCALL(exec)
 24a:	b8 07 00 00 00       	mov    $0x7,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <open>:
SYSCALL(open)
 252:	b8 0f 00 00 00       	mov    $0xf,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <mknod>:
SYSCALL(mknod)
 25a:	b8 11 00 00 00       	mov    $0x11,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <unlink>:
SYSCALL(unlink)
 262:	b8 12 00 00 00       	mov    $0x12,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <fstat>:
SYSCALL(fstat)
 26a:	b8 08 00 00 00       	mov    $0x8,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <link>:
SYSCALL(link)
 272:	b8 13 00 00 00       	mov    $0x13,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <mkdir>:
SYSCALL(mkdir)
 27a:	b8 14 00 00 00       	mov    $0x14,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <chdir>:
SYSCALL(chdir)
 282:	b8 09 00 00 00       	mov    $0x9,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <dup>:
SYSCALL(dup)
 28a:	b8 0a 00 00 00       	mov    $0xa,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <getpid>:
SYSCALL(getpid)
 292:	b8 0b 00 00 00       	mov    $0xb,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <sbrk>:
SYSCALL(sbrk)
 29a:	b8 0c 00 00 00       	mov    $0xc,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <sleep>:
SYSCALL(sleep)
 2a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <uptime>:
SYSCALL(uptime)
 2aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 1c             	sub    $0x1c,%esp
 2b8:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2bb:	6a 01                	push   $0x1
 2bd:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2c0:	52                   	push   %edx
 2c1:	50                   	push   %eax
 2c2:	e8 6b ff ff ff       	call   232 <write>
}
 2c7:	83 c4 10             	add    $0x10,%esp
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	57                   	push   %edi
 2d0:	56                   	push   %esi
 2d1:	53                   	push   %ebx
 2d2:	83 ec 2c             	sub    $0x2c,%esp
 2d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2d8:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2de:	0f 95 c2             	setne  %dl
 2e1:	89 f0                	mov    %esi,%eax
 2e3:	c1 e8 1f             	shr    $0x1f,%eax
 2e6:	84 c2                	test   %al,%dl
 2e8:	74 42                	je     32c <printint+0x60>
    neg = 1;
    x = -xx;
 2ea:	f7 de                	neg    %esi
    neg = 1;
 2ec:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f8:	89 f0                	mov    %esi,%eax
 2fa:	ba 00 00 00 00       	mov    $0x0,%edx
 2ff:	f7 f1                	div    %ecx
 301:	89 df                	mov    %ebx,%edi
 303:	83 c3 01             	add    $0x1,%ebx
 306:	0f b6 92 20 06 00 00 	movzbl 0x620(%edx),%edx
 30d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 311:	89 f2                	mov    %esi,%edx
 313:	89 c6                	mov    %eax,%esi
 315:	39 d1                	cmp    %edx,%ecx
 317:	76 df                	jbe    2f8 <printint+0x2c>
  if(neg)
 319:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 31d:	74 2f                	je     34e <printint+0x82>
    buf[i++] = '-';
 31f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 324:	8d 5f 02             	lea    0x2(%edi),%ebx
 327:	8b 75 d0             	mov    -0x30(%ebp),%esi
 32a:	eb 15                	jmp    341 <printint+0x75>
  neg = 0;
 32c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 333:	eb be                	jmp    2f3 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 335:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 33a:	89 f0                	mov    %esi,%eax
 33c:	e8 71 ff ff ff       	call   2b2 <putc>
  while(--i >= 0)
 341:	83 eb 01             	sub    $0x1,%ebx
 344:	79 ef                	jns    335 <printint+0x69>
}
 346:	83 c4 2c             	add    $0x2c,%esp
 349:	5b                   	pop    %ebx
 34a:	5e                   	pop    %esi
 34b:	5f                   	pop    %edi
 34c:	5d                   	pop    %ebp
 34d:	c3                   	ret    
 34e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 351:	eb ee                	jmp    341 <printint+0x75>

00000353 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 353:	f3 0f 1e fb          	endbr32 
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	57                   	push   %edi
 35b:	56                   	push   %esi
 35c:	53                   	push   %ebx
 35d:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 360:	8d 45 10             	lea    0x10(%ebp),%eax
 363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 366:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 36b:	bb 00 00 00 00       	mov    $0x0,%ebx
 370:	eb 14                	jmp    386 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 372:	89 fa                	mov    %edi,%edx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	e8 36 ff ff ff       	call   2b2 <putc>
 37c:	eb 05                	jmp    383 <printf+0x30>
      }
    } else if(state == '%'){
 37e:	83 fe 25             	cmp    $0x25,%esi
 381:	74 25                	je     3a8 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 383:	83 c3 01             	add    $0x1,%ebx
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 38d:	84 c0                	test   %al,%al
 38f:	0f 84 23 01 00 00    	je     4b8 <printf+0x165>
    c = fmt[i] & 0xff;
 395:	0f be f8             	movsbl %al,%edi
 398:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 39b:	85 f6                	test   %esi,%esi
 39d:	75 df                	jne    37e <printf+0x2b>
      if(c == '%'){
 39f:	83 f8 25             	cmp    $0x25,%eax
 3a2:	75 ce                	jne    372 <printf+0x1f>
        state = '%';
 3a4:	89 c6                	mov    %eax,%esi
 3a6:	eb db                	jmp    383 <printf+0x30>
      if(c == 'd'){
 3a8:	83 f8 64             	cmp    $0x64,%eax
 3ab:	74 49                	je     3f6 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3ad:	83 f8 78             	cmp    $0x78,%eax
 3b0:	0f 94 c1             	sete   %cl
 3b3:	83 f8 70             	cmp    $0x70,%eax
 3b6:	0f 94 c2             	sete   %dl
 3b9:	08 d1                	or     %dl,%cl
 3bb:	75 63                	jne    420 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3bd:	83 f8 73             	cmp    $0x73,%eax
 3c0:	0f 84 84 00 00 00    	je     44a <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3c6:	83 f8 63             	cmp    $0x63,%eax
 3c9:	0f 84 b7 00 00 00    	je     486 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3cf:	83 f8 25             	cmp    $0x25,%eax
 3d2:	0f 84 cc 00 00 00    	je     4a4 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3d8:	ba 25 00 00 00       	mov    $0x25,%edx
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	e8 cd fe ff ff       	call   2b2 <putc>
        putc(fd, c);
 3e5:	89 fa                	mov    %edi,%edx
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	e8 c3 fe ff ff       	call   2b2 <putc>
      }
      state = 0;
 3ef:	be 00 00 00 00       	mov    $0x0,%esi
 3f4:	eb 8d                	jmp    383 <printf+0x30>
        printint(fd, *ap, 10, 1);
 3f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f9:	8b 17                	mov    (%edi),%edx
 3fb:	83 ec 0c             	sub    $0xc,%esp
 3fe:	6a 01                	push   $0x1
 400:	b9 0a 00 00 00       	mov    $0xa,%ecx
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	e8 bf fe ff ff       	call   2cc <printint>
        ap++;
 40d:	83 c7 04             	add    $0x4,%edi
 410:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 413:	83 c4 10             	add    $0x10,%esp
      state = 0;
 416:	be 00 00 00 00       	mov    $0x0,%esi
 41b:	e9 63 ff ff ff       	jmp    383 <printf+0x30>
        printint(fd, *ap, 16, 0);
 420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 423:	8b 17                	mov    (%edi),%edx
 425:	83 ec 0c             	sub    $0xc,%esp
 428:	6a 00                	push   $0x0
 42a:	b9 10 00 00 00       	mov    $0x10,%ecx
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	e8 95 fe ff ff       	call   2cc <printint>
        ap++;
 437:	83 c7 04             	add    $0x4,%edi
 43a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 43d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 440:	be 00 00 00 00       	mov    $0x0,%esi
 445:	e9 39 ff ff ff       	jmp    383 <printf+0x30>
        s = (char*)*ap;
 44a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 44d:	8b 30                	mov    (%eax),%esi
        ap++;
 44f:	83 c0 04             	add    $0x4,%eax
 452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 455:	85 f6                	test   %esi,%esi
 457:	75 28                	jne    481 <printf+0x12e>
          s = "(null)";
 459:	be 19 06 00 00       	mov    $0x619,%esi
 45e:	8b 7d 08             	mov    0x8(%ebp),%edi
 461:	eb 0d                	jmp    470 <printf+0x11d>
          putc(fd, *s);
 463:	0f be d2             	movsbl %dl,%edx
 466:	89 f8                	mov    %edi,%eax
 468:	e8 45 fe ff ff       	call   2b2 <putc>
          s++;
 46d:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 470:	0f b6 16             	movzbl (%esi),%edx
 473:	84 d2                	test   %dl,%dl
 475:	75 ec                	jne    463 <printf+0x110>
      state = 0;
 477:	be 00 00 00 00       	mov    $0x0,%esi
 47c:	e9 02 ff ff ff       	jmp    383 <printf+0x30>
 481:	8b 7d 08             	mov    0x8(%ebp),%edi
 484:	eb ea                	jmp    470 <printf+0x11d>
        putc(fd, *ap);
 486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 489:	0f be 17             	movsbl (%edi),%edx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	e8 1e fe ff ff       	call   2b2 <putc>
        ap++;
 494:	83 c7 04             	add    $0x4,%edi
 497:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 49a:	be 00 00 00 00       	mov    $0x0,%esi
 49f:	e9 df fe ff ff       	jmp    383 <printf+0x30>
        putc(fd, c);
 4a4:	89 fa                	mov    %edi,%edx
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	e8 04 fe ff ff       	call   2b2 <putc>
      state = 0;
 4ae:	be 00 00 00 00       	mov    $0x0,%esi
 4b3:	e9 cb fe ff ff       	jmp    383 <printf+0x30>
    }
  }
}
 4b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bb:	5b                   	pop    %ebx
 4bc:	5e                   	pop    %esi
 4bd:	5f                   	pop    %edi
 4be:	5d                   	pop    %ebp
 4bf:	c3                   	ret    

000004c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c0:	f3 0f 1e fb          	endbr32 
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	57                   	push   %edi
 4c8:	56                   	push   %esi
 4c9:	53                   	push   %ebx
 4ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4cd:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d0:	a1 cc 08 00 00       	mov    0x8cc,%eax
 4d5:	eb 02                	jmp    4d9 <free+0x19>
 4d7:	89 d0                	mov    %edx,%eax
 4d9:	39 c8                	cmp    %ecx,%eax
 4db:	73 04                	jae    4e1 <free+0x21>
 4dd:	39 08                	cmp    %ecx,(%eax)
 4df:	77 12                	ja     4f3 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e1:	8b 10                	mov    (%eax),%edx
 4e3:	39 c2                	cmp    %eax,%edx
 4e5:	77 f0                	ja     4d7 <free+0x17>
 4e7:	39 c8                	cmp    %ecx,%eax
 4e9:	72 08                	jb     4f3 <free+0x33>
 4eb:	39 ca                	cmp    %ecx,%edx
 4ed:	77 04                	ja     4f3 <free+0x33>
 4ef:	89 d0                	mov    %edx,%eax
 4f1:	eb e6                	jmp    4d9 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4f3:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4f6:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f9:	8b 10                	mov    (%eax),%edx
 4fb:	39 d7                	cmp    %edx,%edi
 4fd:	74 19                	je     518 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4ff:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 502:	8b 50 04             	mov    0x4(%eax),%edx
 505:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 508:	39 ce                	cmp    %ecx,%esi
 50a:	74 1b                	je     527 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 50c:	89 08                	mov    %ecx,(%eax)
  freep = p;
 50e:	a3 cc 08 00 00       	mov    %eax,0x8cc
}
 513:	5b                   	pop    %ebx
 514:	5e                   	pop    %esi
 515:	5f                   	pop    %edi
 516:	5d                   	pop    %ebp
 517:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 518:	03 72 04             	add    0x4(%edx),%esi
 51b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 51e:	8b 10                	mov    (%eax),%edx
 520:	8b 12                	mov    (%edx),%edx
 522:	89 53 f8             	mov    %edx,-0x8(%ebx)
 525:	eb db                	jmp    502 <free+0x42>
    p->s.size += bp->s.size;
 527:	03 53 fc             	add    -0x4(%ebx),%edx
 52a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 52d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 530:	89 10                	mov    %edx,(%eax)
 532:	eb da                	jmp    50e <free+0x4e>

00000534 <morecore>:

static Header*
morecore(uint nu)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	53                   	push   %ebx
 538:	83 ec 04             	sub    $0x4,%esp
 53b:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 53d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 542:	77 05                	ja     549 <morecore+0x15>
    nu = 4096;
 544:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 549:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	50                   	push   %eax
 554:	e8 41 fd ff ff       	call   29a <sbrk>
  if(p == (char*)-1)
 559:	83 c4 10             	add    $0x10,%esp
 55c:	83 f8 ff             	cmp    $0xffffffff,%eax
 55f:	74 1c                	je     57d <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 561:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 564:	83 c0 08             	add    $0x8,%eax
 567:	83 ec 0c             	sub    $0xc,%esp
 56a:	50                   	push   %eax
 56b:	e8 50 ff ff ff       	call   4c0 <free>
  return freep;
 570:	a1 cc 08 00 00       	mov    0x8cc,%eax
 575:	83 c4 10             	add    $0x10,%esp
}
 578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 57b:	c9                   	leave  
 57c:	c3                   	ret    
    return 0;
 57d:	b8 00 00 00 00       	mov    $0x0,%eax
 582:	eb f4                	jmp    578 <morecore+0x44>

00000584 <malloc>:

void*
malloc(uint nbytes)
{
 584:	f3 0f 1e fb          	endbr32 
 588:	55                   	push   %ebp
 589:	89 e5                	mov    %esp,%ebp
 58b:	53                   	push   %ebx
 58c:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	8d 58 07             	lea    0x7(%eax),%ebx
 595:	c1 eb 03             	shr    $0x3,%ebx
 598:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 59b:	8b 0d cc 08 00 00    	mov    0x8cc,%ecx
 5a1:	85 c9                	test   %ecx,%ecx
 5a3:	74 04                	je     5a9 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a5:	8b 01                	mov    (%ecx),%eax
 5a7:	eb 4b                	jmp    5f4 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5a9:	c7 05 cc 08 00 00 d0 	movl   $0x8d0,0x8cc
 5b0:	08 00 00 
 5b3:	c7 05 d0 08 00 00 d0 	movl   $0x8d0,0x8d0
 5ba:	08 00 00 
    base.s.size = 0;
 5bd:	c7 05 d4 08 00 00 00 	movl   $0x0,0x8d4
 5c4:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5c7:	b9 d0 08 00 00       	mov    $0x8d0,%ecx
 5cc:	eb d7                	jmp    5a5 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5ce:	74 1a                	je     5ea <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5d0:	29 da                	sub    %ebx,%edx
 5d2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5d5:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5d8:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5db:	89 0d cc 08 00 00    	mov    %ecx,0x8cc
      return (void*)(p + 1);
 5e1:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5e4:	83 c4 04             	add    $0x4,%esp
 5e7:	5b                   	pop    %ebx
 5e8:	5d                   	pop    %ebp
 5e9:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5ea:	8b 10                	mov    (%eax),%edx
 5ec:	89 11                	mov    %edx,(%ecx)
 5ee:	eb eb                	jmp    5db <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f0:	89 c1                	mov    %eax,%ecx
 5f2:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5f4:	8b 50 04             	mov    0x4(%eax),%edx
 5f7:	39 da                	cmp    %ebx,%edx
 5f9:	73 d3                	jae    5ce <malloc+0x4a>
    if(p == freep)
 5fb:	39 05 cc 08 00 00    	cmp    %eax,0x8cc
 601:	75 ed                	jne    5f0 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 603:	89 d8                	mov    %ebx,%eax
 605:	e8 2a ff ff ff       	call   534 <morecore>
 60a:	85 c0                	test   %eax,%eax
 60c:	75 e2                	jne    5f0 <malloc+0x6c>
 60e:	eb d4                	jmp    5e4 <malloc+0x60>
