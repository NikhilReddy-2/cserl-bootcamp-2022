
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 2){
  1d:	83 fe 01             	cmp    $0x1,%esi
  20:	7e 07                	jle    29 <main+0x29>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  22:	bb 01 00 00 00       	mov    $0x1,%ebx
  27:	eb 2d                	jmp    56 <main+0x56>
    printf(2, "usage: kill pid...\n");
  29:	83 ec 08             	sub    $0x8,%esp
  2c:	68 1c 06 00 00       	push   $0x61c
  31:	6a 02                	push   $0x2
  33:	e8 25 03 00 00       	call   35d <printf>
    exit();
  38:	e8 df 01 00 00       	call   21c <exit>
    kill(atoi(argv[i]));
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	ff 34 9f             	pushl  (%edi,%ebx,4)
  43:	e8 6a 01 00 00       	call   1b2 <atoi>
  48:	89 04 24             	mov    %eax,(%esp)
  4b:	e8 fc 01 00 00       	call   24c <kill>
  for(i=1; i<argc; i++)
  50:	83 c3 01             	add    $0x1,%ebx
  53:	83 c4 10             	add    $0x10,%esp
  56:	39 f3                	cmp    %esi,%ebx
  58:	7c e3                	jl     3d <main+0x3d>
  exit();
  5a:	e8 bd 01 00 00       	call   21c <exit>

0000005f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5f:	f3 0f 1e fb          	endbr32 
  63:	55                   	push   %ebp
  64:	89 e5                	mov    %esp,%ebp
  66:	56                   	push   %esi
  67:	53                   	push   %ebx
  68:	8b 75 08             	mov    0x8(%ebp),%esi
  6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	89 f0                	mov    %esi,%eax
  70:	89 d1                	mov    %edx,%ecx
  72:	83 c2 01             	add    $0x1,%edx
  75:	89 c3                	mov    %eax,%ebx
  77:	83 c0 01             	add    $0x1,%eax
  7a:	0f b6 09             	movzbl (%ecx),%ecx
  7d:	88 0b                	mov    %cl,(%ebx)
  7f:	84 c9                	test   %cl,%cl
  81:	75 ed                	jne    70 <strcpy+0x11>
    ;
  return os;
}
  83:	89 f0                	mov    %esi,%eax
  85:	5b                   	pop    %ebx
  86:	5e                   	pop    %esi
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    

00000089 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  89:	f3 0f 1e fb          	endbr32 
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  93:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  96:	0f b6 01             	movzbl (%ecx),%eax
  99:	84 c0                	test   %al,%al
  9b:	74 0c                	je     a9 <strcmp+0x20>
  9d:	3a 02                	cmp    (%edx),%al
  9f:	75 08                	jne    a9 <strcmp+0x20>
    p++, q++;
  a1:	83 c1 01             	add    $0x1,%ecx
  a4:	83 c2 01             	add    $0x1,%edx
  a7:	eb ed                	jmp    96 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  a9:	0f b6 c0             	movzbl %al,%eax
  ac:	0f b6 12             	movzbl (%edx),%edx
  af:	29 d0                	sub    %edx,%eax
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strlen>:

uint
strlen(const char *s)
{
  b3:	f3 0f 1e fb          	endbr32 
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
  c2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  c6:	74 05                	je     cd <strlen+0x1a>
  c8:	83 c0 01             	add    $0x1,%eax
  cb:	eb f5                	jmp    c2 <strlen+0xf>
    ;
  return n;
}
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    

000000cf <memset>:

void*
memset(void *dst, int c, uint n)
{
  cf:	f3 0f 1e fb          	endbr32 
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	57                   	push   %edi
  d7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  da:	89 d7                	mov    %edx,%edi
  dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  df:	8b 45 0c             	mov    0xc(%ebp),%eax
  e2:	fc                   	cld    
  e3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e5:	89 d0                	mov    %edx,%eax
  e7:	5f                   	pop    %edi
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	f3 0f 1e fb          	endbr32 
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f8:	0f b6 10             	movzbl (%eax),%edx
  fb:	84 d2                	test   %dl,%dl
  fd:	74 09                	je     108 <strchr+0x1e>
    if(*s == c)
  ff:	38 ca                	cmp    %cl,%dl
 101:	74 0a                	je     10d <strchr+0x23>
  for(; *s; s++)
 103:	83 c0 01             	add    $0x1,%eax
 106:	eb f0                	jmp    f8 <strchr+0xe>
      return (char*)s;
  return 0;
 108:	b8 00 00 00 00       	mov    $0x0,%eax
}
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    

0000010f <gets>:

char*
gets(char *buf, int max)
{
 10f:	f3 0f 1e fb          	endbr32 
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	57                   	push   %edi
 117:	56                   	push   %esi
 118:	53                   	push   %ebx
 119:	83 ec 1c             	sub    $0x1c,%esp
 11c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11f:	bb 00 00 00 00       	mov    $0x0,%ebx
 124:	89 de                	mov    %ebx,%esi
 126:	83 c3 01             	add    $0x1,%ebx
 129:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12c:	7d 2e                	jge    15c <gets+0x4d>
    cc = read(0, &c, 1);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	6a 01                	push   $0x1
 133:	8d 45 e7             	lea    -0x19(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 00                	push   $0x0
 139:	e8 f6 00 00 00       	call   234 <read>
    if(cc < 1)
 13e:	83 c4 10             	add    $0x10,%esp
 141:	85 c0                	test   %eax,%eax
 143:	7e 17                	jle    15c <gets+0x4d>
      break;
    buf[i++] = c;
 145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 149:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 14c:	3c 0a                	cmp    $0xa,%al
 14e:	0f 94 c2             	sete   %dl
 151:	3c 0d                	cmp    $0xd,%al
 153:	0f 94 c0             	sete   %al
 156:	08 c2                	or     %al,%dl
 158:	74 ca                	je     124 <gets+0x15>
    buf[i++] = c;
 15a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 15c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 160:	89 f8                	mov    %edi,%eax
 162:	8d 65 f4             	lea    -0xc(%ebp),%esp
 165:	5b                   	pop    %ebx
 166:	5e                   	pop    %esi
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    

0000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	f3 0f 1e fb          	endbr32 
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 173:	83 ec 08             	sub    $0x8,%esp
 176:	6a 00                	push   $0x0
 178:	ff 75 08             	pushl  0x8(%ebp)
 17b:	e8 dc 00 00 00       	call   25c <open>
  if(fd < 0)
 180:	83 c4 10             	add    $0x10,%esp
 183:	85 c0                	test   %eax,%eax
 185:	78 24                	js     1ab <stat+0x41>
 187:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 189:	83 ec 08             	sub    $0x8,%esp
 18c:	ff 75 0c             	pushl  0xc(%ebp)
 18f:	50                   	push   %eax
 190:	e8 df 00 00 00       	call   274 <fstat>
 195:	89 c6                	mov    %eax,%esi
  close(fd);
 197:	89 1c 24             	mov    %ebx,(%esp)
 19a:	e8 a5 00 00 00       	call   244 <close>
  return r;
 19f:	83 c4 10             	add    $0x10,%esp
}
 1a2:	89 f0                	mov    %esi,%eax
 1a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a7:	5b                   	pop    %ebx
 1a8:	5e                   	pop    %esi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    
    return -1;
 1ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b0:	eb f0                	jmp    1a2 <stat+0x38>

000001b2 <atoi>:

int
atoi(const char *s)
{
 1b2:	f3 0f 1e fb          	endbr32 
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	53                   	push   %ebx
 1ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1bd:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c2:	0f b6 01             	movzbl (%ecx),%eax
 1c5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1c8:	80 fb 09             	cmp    $0x9,%bl
 1cb:	77 12                	ja     1df <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1cd:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1d0:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1d3:	83 c1 01             	add    $0x1,%ecx
 1d6:	0f be c0             	movsbl %al,%eax
 1d9:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1dd:	eb e3                	jmp    1c2 <atoi+0x10>
  return n;
}
 1df:	89 d0                	mov    %edx,%eax
 1e1:	5b                   	pop    %ebx
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    

000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	f3 0f 1e fb          	endbr32 
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	56                   	push   %esi
 1ec:	53                   	push   %ebx
 1ed:	8b 75 08             	mov    0x8(%ebp),%esi
 1f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1f3:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1f6:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1f8:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1fb:	85 c0                	test   %eax,%eax
 1fd:	7e 0f                	jle    20e <memmove+0x2a>
    *dst++ = *src++;
 1ff:	0f b6 01             	movzbl (%ecx),%eax
 202:	88 02                	mov    %al,(%edx)
 204:	8d 49 01             	lea    0x1(%ecx),%ecx
 207:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 20a:	89 d8                	mov    %ebx,%eax
 20c:	eb ea                	jmp    1f8 <memmove+0x14>
  return vdst;
}
 20e:	89 f0                	mov    %esi,%eax
 210:	5b                   	pop    %ebx
 211:	5e                   	pop    %esi
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    

00000214 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 214:	b8 01 00 00 00       	mov    $0x1,%eax
 219:	cd 40                	int    $0x40
 21b:	c3                   	ret    

0000021c <exit>:
SYSCALL(exit)
 21c:	b8 02 00 00 00       	mov    $0x2,%eax
 221:	cd 40                	int    $0x40
 223:	c3                   	ret    

00000224 <wait>:
SYSCALL(wait)
 224:	b8 03 00 00 00       	mov    $0x3,%eax
 229:	cd 40                	int    $0x40
 22b:	c3                   	ret    

0000022c <pipe>:
SYSCALL(pipe)
 22c:	b8 04 00 00 00       	mov    $0x4,%eax
 231:	cd 40                	int    $0x40
 233:	c3                   	ret    

00000234 <read>:
SYSCALL(read)
 234:	b8 05 00 00 00       	mov    $0x5,%eax
 239:	cd 40                	int    $0x40
 23b:	c3                   	ret    

0000023c <write>:
SYSCALL(write)
 23c:	b8 10 00 00 00       	mov    $0x10,%eax
 241:	cd 40                	int    $0x40
 243:	c3                   	ret    

00000244 <close>:
SYSCALL(close)
 244:	b8 15 00 00 00       	mov    $0x15,%eax
 249:	cd 40                	int    $0x40
 24b:	c3                   	ret    

0000024c <kill>:
SYSCALL(kill)
 24c:	b8 06 00 00 00       	mov    $0x6,%eax
 251:	cd 40                	int    $0x40
 253:	c3                   	ret    

00000254 <exec>:
SYSCALL(exec)
 254:	b8 07 00 00 00       	mov    $0x7,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	ret    

0000025c <open>:
SYSCALL(open)
 25c:	b8 0f 00 00 00       	mov    $0xf,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <mknod>:
SYSCALL(mknod)
 264:	b8 11 00 00 00       	mov    $0x11,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <unlink>:
SYSCALL(unlink)
 26c:	b8 12 00 00 00       	mov    $0x12,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <fstat>:
SYSCALL(fstat)
 274:	b8 08 00 00 00       	mov    $0x8,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <link>:
SYSCALL(link)
 27c:	b8 13 00 00 00       	mov    $0x13,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <mkdir>:
SYSCALL(mkdir)
 284:	b8 14 00 00 00       	mov    $0x14,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <chdir>:
SYSCALL(chdir)
 28c:	b8 09 00 00 00       	mov    $0x9,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <dup>:
SYSCALL(dup)
 294:	b8 0a 00 00 00       	mov    $0xa,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <getpid>:
SYSCALL(getpid)
 29c:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <sbrk>:
SYSCALL(sbrk)
 2a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <sleep>:
SYSCALL(sleep)
 2ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <uptime>:
SYSCALL(uptime)
 2b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 1c             	sub    $0x1c,%esp
 2c2:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2c5:	6a 01                	push   $0x1
 2c7:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2ca:	52                   	push   %edx
 2cb:	50                   	push   %eax
 2cc:	e8 6b ff ff ff       	call   23c <write>
}
 2d1:	83 c4 10             	add    $0x10,%esp
 2d4:	c9                   	leave  
 2d5:	c3                   	ret    

000002d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2d6:	55                   	push   %ebp
 2d7:	89 e5                	mov    %esp,%ebp
 2d9:	57                   	push   %edi
 2da:	56                   	push   %esi
 2db:	53                   	push   %ebx
 2dc:	83 ec 2c             	sub    $0x2c,%esp
 2df:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2e2:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e8:	0f 95 c2             	setne  %dl
 2eb:	89 f0                	mov    %esi,%eax
 2ed:	c1 e8 1f             	shr    $0x1f,%eax
 2f0:	84 c2                	test   %al,%dl
 2f2:	74 42                	je     336 <printint+0x60>
    neg = 1;
    x = -xx;
 2f4:	f7 de                	neg    %esi
    neg = 1;
 2f6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 302:	89 f0                	mov    %esi,%eax
 304:	ba 00 00 00 00       	mov    $0x0,%edx
 309:	f7 f1                	div    %ecx
 30b:	89 df                	mov    %ebx,%edi
 30d:	83 c3 01             	add    $0x1,%ebx
 310:	0f b6 92 38 06 00 00 	movzbl 0x638(%edx),%edx
 317:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 31b:	89 f2                	mov    %esi,%edx
 31d:	89 c6                	mov    %eax,%esi
 31f:	39 d1                	cmp    %edx,%ecx
 321:	76 df                	jbe    302 <printint+0x2c>
  if(neg)
 323:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 327:	74 2f                	je     358 <printint+0x82>
    buf[i++] = '-';
 329:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 32e:	8d 5f 02             	lea    0x2(%edi),%ebx
 331:	8b 75 d0             	mov    -0x30(%ebp),%esi
 334:	eb 15                	jmp    34b <printint+0x75>
  neg = 0;
 336:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 33d:	eb be                	jmp    2fd <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 33f:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 344:	89 f0                	mov    %esi,%eax
 346:	e8 71 ff ff ff       	call   2bc <putc>
  while(--i >= 0)
 34b:	83 eb 01             	sub    $0x1,%ebx
 34e:	79 ef                	jns    33f <printint+0x69>
}
 350:	83 c4 2c             	add    $0x2c,%esp
 353:	5b                   	pop    %ebx
 354:	5e                   	pop    %esi
 355:	5f                   	pop    %edi
 356:	5d                   	pop    %ebp
 357:	c3                   	ret    
 358:	8b 75 d0             	mov    -0x30(%ebp),%esi
 35b:	eb ee                	jmp    34b <printint+0x75>

0000035d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 35d:	f3 0f 1e fb          	endbr32 
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	57                   	push   %edi
 365:	56                   	push   %esi
 366:	53                   	push   %ebx
 367:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 36a:	8d 45 10             	lea    0x10(%ebp),%eax
 36d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 370:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 375:	bb 00 00 00 00       	mov    $0x0,%ebx
 37a:	eb 14                	jmp    390 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 37c:	89 fa                	mov    %edi,%edx
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	e8 36 ff ff ff       	call   2bc <putc>
 386:	eb 05                	jmp    38d <printf+0x30>
      }
    } else if(state == '%'){
 388:	83 fe 25             	cmp    $0x25,%esi
 38b:	74 25                	je     3b2 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 38d:	83 c3 01             	add    $0x1,%ebx
 390:	8b 45 0c             	mov    0xc(%ebp),%eax
 393:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 397:	84 c0                	test   %al,%al
 399:	0f 84 23 01 00 00    	je     4c2 <printf+0x165>
    c = fmt[i] & 0xff;
 39f:	0f be f8             	movsbl %al,%edi
 3a2:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3a5:	85 f6                	test   %esi,%esi
 3a7:	75 df                	jne    388 <printf+0x2b>
      if(c == '%'){
 3a9:	83 f8 25             	cmp    $0x25,%eax
 3ac:	75 ce                	jne    37c <printf+0x1f>
        state = '%';
 3ae:	89 c6                	mov    %eax,%esi
 3b0:	eb db                	jmp    38d <printf+0x30>
      if(c == 'd'){
 3b2:	83 f8 64             	cmp    $0x64,%eax
 3b5:	74 49                	je     400 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3b7:	83 f8 78             	cmp    $0x78,%eax
 3ba:	0f 94 c1             	sete   %cl
 3bd:	83 f8 70             	cmp    $0x70,%eax
 3c0:	0f 94 c2             	sete   %dl
 3c3:	08 d1                	or     %dl,%cl
 3c5:	75 63                	jne    42a <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3c7:	83 f8 73             	cmp    $0x73,%eax
 3ca:	0f 84 84 00 00 00    	je     454 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3d0:	83 f8 63             	cmp    $0x63,%eax
 3d3:	0f 84 b7 00 00 00    	je     490 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3d9:	83 f8 25             	cmp    $0x25,%eax
 3dc:	0f 84 cc 00 00 00    	je     4ae <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3e2:	ba 25 00 00 00       	mov    $0x25,%edx
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	e8 cd fe ff ff       	call   2bc <putc>
        putc(fd, c);
 3ef:	89 fa                	mov    %edi,%edx
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	e8 c3 fe ff ff       	call   2bc <putc>
      }
      state = 0;
 3f9:	be 00 00 00 00       	mov    $0x0,%esi
 3fe:	eb 8d                	jmp    38d <printf+0x30>
        printint(fd, *ap, 10, 1);
 400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 403:	8b 17                	mov    (%edi),%edx
 405:	83 ec 0c             	sub    $0xc,%esp
 408:	6a 01                	push   $0x1
 40a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	e8 bf fe ff ff       	call   2d6 <printint>
        ap++;
 417:	83 c7 04             	add    $0x4,%edi
 41a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 420:	be 00 00 00 00       	mov    $0x0,%esi
 425:	e9 63 ff ff ff       	jmp    38d <printf+0x30>
        printint(fd, *ap, 16, 0);
 42a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42d:	8b 17                	mov    (%edi),%edx
 42f:	83 ec 0c             	sub    $0xc,%esp
 432:	6a 00                	push   $0x0
 434:	b9 10 00 00 00       	mov    $0x10,%ecx
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	e8 95 fe ff ff       	call   2d6 <printint>
        ap++;
 441:	83 c7 04             	add    $0x4,%edi
 444:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 447:	83 c4 10             	add    $0x10,%esp
      state = 0;
 44a:	be 00 00 00 00       	mov    $0x0,%esi
 44f:	e9 39 ff ff ff       	jmp    38d <printf+0x30>
        s = (char*)*ap;
 454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 457:	8b 30                	mov    (%eax),%esi
        ap++;
 459:	83 c0 04             	add    $0x4,%eax
 45c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 45f:	85 f6                	test   %esi,%esi
 461:	75 28                	jne    48b <printf+0x12e>
          s = "(null)";
 463:	be 30 06 00 00       	mov    $0x630,%esi
 468:	8b 7d 08             	mov    0x8(%ebp),%edi
 46b:	eb 0d                	jmp    47a <printf+0x11d>
          putc(fd, *s);
 46d:	0f be d2             	movsbl %dl,%edx
 470:	89 f8                	mov    %edi,%eax
 472:	e8 45 fe ff ff       	call   2bc <putc>
          s++;
 477:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 47a:	0f b6 16             	movzbl (%esi),%edx
 47d:	84 d2                	test   %dl,%dl
 47f:	75 ec                	jne    46d <printf+0x110>
      state = 0;
 481:	be 00 00 00 00       	mov    $0x0,%esi
 486:	e9 02 ff ff ff       	jmp    38d <printf+0x30>
 48b:	8b 7d 08             	mov    0x8(%ebp),%edi
 48e:	eb ea                	jmp    47a <printf+0x11d>
        putc(fd, *ap);
 490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 493:	0f be 17             	movsbl (%edi),%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	e8 1e fe ff ff       	call   2bc <putc>
        ap++;
 49e:	83 c7 04             	add    $0x4,%edi
 4a1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4a4:	be 00 00 00 00       	mov    $0x0,%esi
 4a9:	e9 df fe ff ff       	jmp    38d <printf+0x30>
        putc(fd, c);
 4ae:	89 fa                	mov    %edi,%edx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	e8 04 fe ff ff       	call   2bc <putc>
      state = 0;
 4b8:	be 00 00 00 00       	mov    $0x0,%esi
 4bd:	e9 cb fe ff ff       	jmp    38d <printf+0x30>
    }
  }
}
 4c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c5:	5b                   	pop    %ebx
 4c6:	5e                   	pop    %esi
 4c7:	5f                   	pop    %edi
 4c8:	5d                   	pop    %ebp
 4c9:	c3                   	ret    

000004ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4ca:	f3 0f 1e fb          	endbr32 
 4ce:	55                   	push   %ebp
 4cf:	89 e5                	mov    %esp,%ebp
 4d1:	57                   	push   %edi
 4d2:	56                   	push   %esi
 4d3:	53                   	push   %ebx
 4d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d7:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4da:	a1 e4 08 00 00       	mov    0x8e4,%eax
 4df:	eb 02                	jmp    4e3 <free+0x19>
 4e1:	89 d0                	mov    %edx,%eax
 4e3:	39 c8                	cmp    %ecx,%eax
 4e5:	73 04                	jae    4eb <free+0x21>
 4e7:	39 08                	cmp    %ecx,(%eax)
 4e9:	77 12                	ja     4fd <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4eb:	8b 10                	mov    (%eax),%edx
 4ed:	39 c2                	cmp    %eax,%edx
 4ef:	77 f0                	ja     4e1 <free+0x17>
 4f1:	39 c8                	cmp    %ecx,%eax
 4f3:	72 08                	jb     4fd <free+0x33>
 4f5:	39 ca                	cmp    %ecx,%edx
 4f7:	77 04                	ja     4fd <free+0x33>
 4f9:	89 d0                	mov    %edx,%eax
 4fb:	eb e6                	jmp    4e3 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4fd:	8b 73 fc             	mov    -0x4(%ebx),%esi
 500:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 503:	8b 10                	mov    (%eax),%edx
 505:	39 d7                	cmp    %edx,%edi
 507:	74 19                	je     522 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 509:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 50c:	8b 50 04             	mov    0x4(%eax),%edx
 50f:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 512:	39 ce                	cmp    %ecx,%esi
 514:	74 1b                	je     531 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 516:	89 08                	mov    %ecx,(%eax)
  freep = p;
 518:	a3 e4 08 00 00       	mov    %eax,0x8e4
}
 51d:	5b                   	pop    %ebx
 51e:	5e                   	pop    %esi
 51f:	5f                   	pop    %edi
 520:	5d                   	pop    %ebp
 521:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 522:	03 72 04             	add    0x4(%edx),%esi
 525:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 528:	8b 10                	mov    (%eax),%edx
 52a:	8b 12                	mov    (%edx),%edx
 52c:	89 53 f8             	mov    %edx,-0x8(%ebx)
 52f:	eb db                	jmp    50c <free+0x42>
    p->s.size += bp->s.size;
 531:	03 53 fc             	add    -0x4(%ebx),%edx
 534:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 537:	8b 53 f8             	mov    -0x8(%ebx),%edx
 53a:	89 10                	mov    %edx,(%eax)
 53c:	eb da                	jmp    518 <free+0x4e>

0000053e <morecore>:

static Header*
morecore(uint nu)
{
 53e:	55                   	push   %ebp
 53f:	89 e5                	mov    %esp,%ebp
 541:	53                   	push   %ebx
 542:	83 ec 04             	sub    $0x4,%esp
 545:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 547:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 54c:	77 05                	ja     553 <morecore+0x15>
    nu = 4096;
 54e:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 553:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 55a:	83 ec 0c             	sub    $0xc,%esp
 55d:	50                   	push   %eax
 55e:	e8 41 fd ff ff       	call   2a4 <sbrk>
  if(p == (char*)-1)
 563:	83 c4 10             	add    $0x10,%esp
 566:	83 f8 ff             	cmp    $0xffffffff,%eax
 569:	74 1c                	je     587 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 56b:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 56e:	83 c0 08             	add    $0x8,%eax
 571:	83 ec 0c             	sub    $0xc,%esp
 574:	50                   	push   %eax
 575:	e8 50 ff ff ff       	call   4ca <free>
  return freep;
 57a:	a1 e4 08 00 00       	mov    0x8e4,%eax
 57f:	83 c4 10             	add    $0x10,%esp
}
 582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 585:	c9                   	leave  
 586:	c3                   	ret    
    return 0;
 587:	b8 00 00 00 00       	mov    $0x0,%eax
 58c:	eb f4                	jmp    582 <morecore+0x44>

0000058e <malloc>:

void*
malloc(uint nbytes)
{
 58e:	f3 0f 1e fb          	endbr32 
 592:	55                   	push   %ebp
 593:	89 e5                	mov    %esp,%ebp
 595:	53                   	push   %ebx
 596:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	8d 58 07             	lea    0x7(%eax),%ebx
 59f:	c1 eb 03             	shr    $0x3,%ebx
 5a2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a5:	8b 0d e4 08 00 00    	mov    0x8e4,%ecx
 5ab:	85 c9                	test   %ecx,%ecx
 5ad:	74 04                	je     5b3 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5af:	8b 01                	mov    (%ecx),%eax
 5b1:	eb 4b                	jmp    5fe <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5b3:	c7 05 e4 08 00 00 e8 	movl   $0x8e8,0x8e4
 5ba:	08 00 00 
 5bd:	c7 05 e8 08 00 00 e8 	movl   $0x8e8,0x8e8
 5c4:	08 00 00 
    base.s.size = 0;
 5c7:	c7 05 ec 08 00 00 00 	movl   $0x0,0x8ec
 5ce:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5d1:	b9 e8 08 00 00       	mov    $0x8e8,%ecx
 5d6:	eb d7                	jmp    5af <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5d8:	74 1a                	je     5f4 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5da:	29 da                	sub    %ebx,%edx
 5dc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5df:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5e2:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5e5:	89 0d e4 08 00 00    	mov    %ecx,0x8e4
      return (void*)(p + 1);
 5eb:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5ee:	83 c4 04             	add    $0x4,%esp
 5f1:	5b                   	pop    %ebx
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5f4:	8b 10                	mov    (%eax),%edx
 5f6:	89 11                	mov    %edx,(%ecx)
 5f8:	eb eb                	jmp    5e5 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5fa:	89 c1                	mov    %eax,%ecx
 5fc:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5fe:	8b 50 04             	mov    0x4(%eax),%edx
 601:	39 da                	cmp    %ebx,%edx
 603:	73 d3                	jae    5d8 <malloc+0x4a>
    if(p == freep)
 605:	39 05 e4 08 00 00    	cmp    %eax,0x8e4
 60b:	75 ed                	jne    5fa <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 60d:	89 d8                	mov    %ebx,%eax
 60f:	e8 2a ff ff ff       	call   53e <morecore>
 614:	85 c0                	test   %eax,%eax
 616:	75 e2                	jne    5fa <malloc+0x6c>
 618:	eb d4                	jmp    5ee <malloc+0x60>
