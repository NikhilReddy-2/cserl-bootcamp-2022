
_cmd:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "stddef.h"


int main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8b 31                	mov    (%ecx),%esi
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
	if(argc<=1){
  1c:	83 fe 01             	cmp    $0x1,%esi
  1f:	7e 07                	jle    28 <main+0x28>
        exit();
    }
    char **args = argv;
    for(int i=1;i<argc;i++){
  21:	b8 01 00 00 00       	mov    $0x1,%eax
  26:	eb 0f                	jmp    37 <main+0x37>
        exit();
  28:	e8 f6 01 00 00       	call   223 <exit>
        args[i-1] = argv[i];
  2d:	8b 14 83             	mov    (%ebx,%eax,4),%edx
  30:	89 54 83 fc          	mov    %edx,-0x4(%ebx,%eax,4)
    for(int i=1;i<argc;i++){
  34:	83 c0 01             	add    $0x1,%eax
  37:	39 f0                	cmp    %esi,%eax
  39:	7c f2                	jl     2d <main+0x2d>
    }
    args[argc-1] = NULL;
  3b:	c7 44 b3 fc 00 00 00 	movl   $0x0,-0x4(%ebx,%esi,4)
  42:	00 

    // Implement your code here
	int pid = fork();
  43:	e8 d3 01 00 00       	call   21b <fork>
	if(pid == 0){
  48:	85 c0                	test   %eax,%eax
  4a:	75 13                	jne    5f <main+0x5f>
		exec(args[0],args);
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	53                   	push   %ebx
  50:	ff 33                	pushl  (%ebx)
  52:	e8 04 02 00 00       	call   25b <exec>
  57:	83 c4 10             	add    $0x10,%esp
	}else{
		wait();
	}
    //
    exit();
  5a:	e8 c4 01 00 00       	call   223 <exit>
		wait();
  5f:	e8 c7 01 00 00       	call   22b <wait>
  64:	eb f4                	jmp    5a <main+0x5a>

00000066 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  66:	f3 0f 1e fb          	endbr32 
  6a:	55                   	push   %ebp
  6b:	89 e5                	mov    %esp,%ebp
  6d:	56                   	push   %esi
  6e:	53                   	push   %ebx
  6f:	8b 75 08             	mov    0x8(%ebp),%esi
  72:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  75:	89 f0                	mov    %esi,%eax
  77:	89 d1                	mov    %edx,%ecx
  79:	83 c2 01             	add    $0x1,%edx
  7c:	89 c3                	mov    %eax,%ebx
  7e:	83 c0 01             	add    $0x1,%eax
  81:	0f b6 09             	movzbl (%ecx),%ecx
  84:	88 0b                	mov    %cl,(%ebx)
  86:	84 c9                	test   %cl,%cl
  88:	75 ed                	jne    77 <strcpy+0x11>
    ;
  return os;
}
  8a:	89 f0                	mov    %esi,%eax
  8c:	5b                   	pop    %ebx
  8d:	5e                   	pop    %esi
  8e:	5d                   	pop    %ebp
  8f:	c3                   	ret    

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9d:	0f b6 01             	movzbl (%ecx),%eax
  a0:	84 c0                	test   %al,%al
  a2:	74 0c                	je     b0 <strcmp+0x20>
  a4:	3a 02                	cmp    (%edx),%al
  a6:	75 08                	jne    b0 <strcmp+0x20>
    p++, q++;
  a8:	83 c1 01             	add    $0x1,%ecx
  ab:	83 c2 01             	add    $0x1,%edx
  ae:	eb ed                	jmp    9d <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  b0:	0f b6 c0             	movzbl %al,%eax
  b3:	0f b6 12             	movzbl (%edx),%edx
  b6:	29 d0                	sub    %edx,%eax
}
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    

000000ba <strlen>:

uint
strlen(const char *s)
{
  ba:	f3 0f 1e fb          	endbr32 
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c4:	b8 00 00 00 00       	mov    $0x0,%eax
  c9:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  cd:	74 05                	je     d4 <strlen+0x1a>
  cf:	83 c0 01             	add    $0x1,%eax
  d2:	eb f5                	jmp    c9 <strlen+0xf>
    ;
  return n;
}
  d4:	5d                   	pop    %ebp
  d5:	c3                   	ret    

000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	f3 0f 1e fb          	endbr32 
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	57                   	push   %edi
  de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e1:	89 d7                	mov    %edx,%edi
  e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	fc                   	cld    
  ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ec:	89 d0                	mov    %edx,%eax
  ee:	5f                   	pop    %edi
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <strchr>:

char*
strchr(const char *s, char c)
{
  f1:	f3 0f 1e fb          	endbr32 
  f5:	55                   	push   %ebp
  f6:	89 e5                	mov    %esp,%ebp
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	84 d2                	test   %dl,%dl
 104:	74 09                	je     10f <strchr+0x1e>
    if(*s == c)
 106:	38 ca                	cmp    %cl,%dl
 108:	74 0a                	je     114 <strchr+0x23>
  for(; *s; s++)
 10a:	83 c0 01             	add    $0x1,%eax
 10d:	eb f0                	jmp    ff <strchr+0xe>
      return (char*)s;
  return 0;
 10f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 114:	5d                   	pop    %ebp
 115:	c3                   	ret    

00000116 <gets>:

char*
gets(char *buf, int max)
{
 116:	f3 0f 1e fb          	endbr32 
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	57                   	push   %edi
 11e:	56                   	push   %esi
 11f:	53                   	push   %ebx
 120:	83 ec 1c             	sub    $0x1c,%esp
 123:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 126:	bb 00 00 00 00       	mov    $0x0,%ebx
 12b:	89 de                	mov    %ebx,%esi
 12d:	83 c3 01             	add    $0x1,%ebx
 130:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 133:	7d 2e                	jge    163 <gets+0x4d>
    cc = read(0, &c, 1);
 135:	83 ec 04             	sub    $0x4,%esp
 138:	6a 01                	push   $0x1
 13a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 13d:	50                   	push   %eax
 13e:	6a 00                	push   $0x0
 140:	e8 f6 00 00 00       	call   23b <read>
    if(cc < 1)
 145:	83 c4 10             	add    $0x10,%esp
 148:	85 c0                	test   %eax,%eax
 14a:	7e 17                	jle    163 <gets+0x4d>
      break;
    buf[i++] = c;
 14c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 150:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 153:	3c 0a                	cmp    $0xa,%al
 155:	0f 94 c2             	sete   %dl
 158:	3c 0d                	cmp    $0xd,%al
 15a:	0f 94 c0             	sete   %al
 15d:	08 c2                	or     %al,%dl
 15f:	74 ca                	je     12b <gets+0x15>
    buf[i++] = c;
 161:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 163:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 167:	89 f8                	mov    %edi,%eax
 169:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16c:	5b                   	pop    %ebx
 16d:	5e                   	pop    %esi
 16e:	5f                   	pop    %edi
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    

00000171 <stat>:

int
stat(const char *n, struct stat *st)
{
 171:	f3 0f 1e fb          	endbr32 
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	56                   	push   %esi
 179:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17a:	83 ec 08             	sub    $0x8,%esp
 17d:	6a 00                	push   $0x0
 17f:	ff 75 08             	pushl  0x8(%ebp)
 182:	e8 dc 00 00 00       	call   263 <open>
  if(fd < 0)
 187:	83 c4 10             	add    $0x10,%esp
 18a:	85 c0                	test   %eax,%eax
 18c:	78 24                	js     1b2 <stat+0x41>
 18e:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 190:	83 ec 08             	sub    $0x8,%esp
 193:	ff 75 0c             	pushl  0xc(%ebp)
 196:	50                   	push   %eax
 197:	e8 df 00 00 00       	call   27b <fstat>
 19c:	89 c6                	mov    %eax,%esi
  close(fd);
 19e:	89 1c 24             	mov    %ebx,(%esp)
 1a1:	e8 a5 00 00 00       	call   24b <close>
  return r;
 1a6:	83 c4 10             	add    $0x10,%esp
}
 1a9:	89 f0                	mov    %esi,%eax
 1ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ae:	5b                   	pop    %ebx
 1af:	5e                   	pop    %esi
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    
    return -1;
 1b2:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b7:	eb f0                	jmp    1a9 <stat+0x38>

000001b9 <atoi>:

int
atoi(const char *s)
{
 1b9:	f3 0f 1e fb          	endbr32 
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	53                   	push   %ebx
 1c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1c4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c9:	0f b6 01             	movzbl (%ecx),%eax
 1cc:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1cf:	80 fb 09             	cmp    $0x9,%bl
 1d2:	77 12                	ja     1e6 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1d4:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1d7:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1da:	83 c1 01             	add    $0x1,%ecx
 1dd:	0f be c0             	movsbl %al,%eax
 1e0:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1e4:	eb e3                	jmp    1c9 <atoi+0x10>
  return n;
}
 1e6:	89 d0                	mov    %edx,%eax
 1e8:	5b                   	pop    %ebx
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret    

000001eb <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1eb:	f3 0f 1e fb          	endbr32 
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	56                   	push   %esi
 1f3:	53                   	push   %ebx
 1f4:	8b 75 08             	mov    0x8(%ebp),%esi
 1f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1fa:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1fd:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
 202:	85 c0                	test   %eax,%eax
 204:	7e 0f                	jle    215 <memmove+0x2a>
    *dst++ = *src++;
 206:	0f b6 01             	movzbl (%ecx),%eax
 209:	88 02                	mov    %al,(%edx)
 20b:	8d 49 01             	lea    0x1(%ecx),%ecx
 20e:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 211:	89 d8                	mov    %ebx,%eax
 213:	eb ea                	jmp    1ff <memmove+0x14>
  return vdst;
}
 215:	89 f0                	mov    %esi,%eax
 217:	5b                   	pop    %ebx
 218:	5e                   	pop    %esi
 219:	5d                   	pop    %ebp
 21a:	c3                   	ret    

0000021b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 21b:	b8 01 00 00 00       	mov    $0x1,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <exit>:
SYSCALL(exit)
 223:	b8 02 00 00 00       	mov    $0x2,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <wait>:
SYSCALL(wait)
 22b:	b8 03 00 00 00       	mov    $0x3,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <pipe>:
SYSCALL(pipe)
 233:	b8 04 00 00 00       	mov    $0x4,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <read>:
SYSCALL(read)
 23b:	b8 05 00 00 00       	mov    $0x5,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <write>:
SYSCALL(write)
 243:	b8 10 00 00 00       	mov    $0x10,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <close>:
SYSCALL(close)
 24b:	b8 15 00 00 00       	mov    $0x15,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <kill>:
SYSCALL(kill)
 253:	b8 06 00 00 00       	mov    $0x6,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <exec>:
SYSCALL(exec)
 25b:	b8 07 00 00 00       	mov    $0x7,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <open>:
SYSCALL(open)
 263:	b8 0f 00 00 00       	mov    $0xf,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <mknod>:
SYSCALL(mknod)
 26b:	b8 11 00 00 00       	mov    $0x11,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <unlink>:
SYSCALL(unlink)
 273:	b8 12 00 00 00       	mov    $0x12,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <fstat>:
SYSCALL(fstat)
 27b:	b8 08 00 00 00       	mov    $0x8,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <link>:
SYSCALL(link)
 283:	b8 13 00 00 00       	mov    $0x13,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <mkdir>:
SYSCALL(mkdir)
 28b:	b8 14 00 00 00       	mov    $0x14,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <chdir>:
SYSCALL(chdir)
 293:	b8 09 00 00 00       	mov    $0x9,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <dup>:
SYSCALL(dup)
 29b:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <getpid>:
SYSCALL(getpid)
 2a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <sbrk>:
SYSCALL(sbrk)
 2ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <sleep>:
SYSCALL(sleep)
 2b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <uptime>:
SYSCALL(uptime)
 2bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2c3:	b8 16 00 00 00       	mov    $0x16,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <get_ancestors>:
SYSCALL(get_ancestors)
 2cb:	b8 17 00 00 00       	mov    $0x17,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 1c             	sub    $0x1c,%esp
 2d9:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2dc:	6a 01                	push   $0x1
 2de:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2e1:	52                   	push   %edx
 2e2:	50                   	push   %eax
 2e3:	e8 5b ff ff ff       	call   243 <write>
}
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	57                   	push   %edi
 2f1:	56                   	push   %esi
 2f2:	53                   	push   %ebx
 2f3:	83 ec 2c             	sub    $0x2c,%esp
 2f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2f9:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2ff:	0f 95 c2             	setne  %dl
 302:	89 f0                	mov    %esi,%eax
 304:	c1 e8 1f             	shr    $0x1f,%eax
 307:	84 c2                	test   %al,%dl
 309:	74 42                	je     34d <printint+0x60>
    neg = 1;
    x = -xx;
 30b:	f7 de                	neg    %esi
    neg = 1;
 30d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 314:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 319:	89 f0                	mov    %esi,%eax
 31b:	ba 00 00 00 00       	mov    $0x0,%edx
 320:	f7 f1                	div    %ecx
 322:	89 df                	mov    %ebx,%edi
 324:	83 c3 01             	add    $0x1,%ebx
 327:	0f b6 92 3c 06 00 00 	movzbl 0x63c(%edx),%edx
 32e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 332:	89 f2                	mov    %esi,%edx
 334:	89 c6                	mov    %eax,%esi
 336:	39 d1                	cmp    %edx,%ecx
 338:	76 df                	jbe    319 <printint+0x2c>
  if(neg)
 33a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 33e:	74 2f                	je     36f <printint+0x82>
    buf[i++] = '-';
 340:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 345:	8d 5f 02             	lea    0x2(%edi),%ebx
 348:	8b 75 d0             	mov    -0x30(%ebp),%esi
 34b:	eb 15                	jmp    362 <printint+0x75>
  neg = 0;
 34d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 354:	eb be                	jmp    314 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 356:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 35b:	89 f0                	mov    %esi,%eax
 35d:	e8 71 ff ff ff       	call   2d3 <putc>
  while(--i >= 0)
 362:	83 eb 01             	sub    $0x1,%ebx
 365:	79 ef                	jns    356 <printint+0x69>
}
 367:	83 c4 2c             	add    $0x2c,%esp
 36a:	5b                   	pop    %ebx
 36b:	5e                   	pop    %esi
 36c:	5f                   	pop    %edi
 36d:	5d                   	pop    %ebp
 36e:	c3                   	ret    
 36f:	8b 75 d0             	mov    -0x30(%ebp),%esi
 372:	eb ee                	jmp    362 <printint+0x75>

00000374 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 374:	f3 0f 1e fb          	endbr32 
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	57                   	push   %edi
 37c:	56                   	push   %esi
 37d:	53                   	push   %ebx
 37e:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 381:	8d 45 10             	lea    0x10(%ebp),%eax
 384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 387:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 38c:	bb 00 00 00 00       	mov    $0x0,%ebx
 391:	eb 14                	jmp    3a7 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 393:	89 fa                	mov    %edi,%edx
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	e8 36 ff ff ff       	call   2d3 <putc>
 39d:	eb 05                	jmp    3a4 <printf+0x30>
      }
    } else if(state == '%'){
 39f:	83 fe 25             	cmp    $0x25,%esi
 3a2:	74 25                	je     3c9 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 3a4:	83 c3 01             	add    $0x1,%ebx
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3ae:	84 c0                	test   %al,%al
 3b0:	0f 84 23 01 00 00    	je     4d9 <printf+0x165>
    c = fmt[i] & 0xff;
 3b6:	0f be f8             	movsbl %al,%edi
 3b9:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3bc:	85 f6                	test   %esi,%esi
 3be:	75 df                	jne    39f <printf+0x2b>
      if(c == '%'){
 3c0:	83 f8 25             	cmp    $0x25,%eax
 3c3:	75 ce                	jne    393 <printf+0x1f>
        state = '%';
 3c5:	89 c6                	mov    %eax,%esi
 3c7:	eb db                	jmp    3a4 <printf+0x30>
      if(c == 'd'){
 3c9:	83 f8 64             	cmp    $0x64,%eax
 3cc:	74 49                	je     417 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3ce:	83 f8 78             	cmp    $0x78,%eax
 3d1:	0f 94 c1             	sete   %cl
 3d4:	83 f8 70             	cmp    $0x70,%eax
 3d7:	0f 94 c2             	sete   %dl
 3da:	08 d1                	or     %dl,%cl
 3dc:	75 63                	jne    441 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3de:	83 f8 73             	cmp    $0x73,%eax
 3e1:	0f 84 84 00 00 00    	je     46b <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3e7:	83 f8 63             	cmp    $0x63,%eax
 3ea:	0f 84 b7 00 00 00    	je     4a7 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3f0:	83 f8 25             	cmp    $0x25,%eax
 3f3:	0f 84 cc 00 00 00    	je     4c5 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3f9:	ba 25 00 00 00       	mov    $0x25,%edx
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	e8 cd fe ff ff       	call   2d3 <putc>
        putc(fd, c);
 406:	89 fa                	mov    %edi,%edx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	e8 c3 fe ff ff       	call   2d3 <putc>
      }
      state = 0;
 410:	be 00 00 00 00       	mov    $0x0,%esi
 415:	eb 8d                	jmp    3a4 <printf+0x30>
        printint(fd, *ap, 10, 1);
 417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 41a:	8b 17                	mov    (%edi),%edx
 41c:	83 ec 0c             	sub    $0xc,%esp
 41f:	6a 01                	push   $0x1
 421:	b9 0a 00 00 00       	mov    $0xa,%ecx
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	e8 bf fe ff ff       	call   2ed <printint>
        ap++;
 42e:	83 c7 04             	add    $0x4,%edi
 431:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 434:	83 c4 10             	add    $0x10,%esp
      state = 0;
 437:	be 00 00 00 00       	mov    $0x0,%esi
 43c:	e9 63 ff ff ff       	jmp    3a4 <printf+0x30>
        printint(fd, *ap, 16, 0);
 441:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 444:	8b 17                	mov    (%edi),%edx
 446:	83 ec 0c             	sub    $0xc,%esp
 449:	6a 00                	push   $0x0
 44b:	b9 10 00 00 00       	mov    $0x10,%ecx
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	e8 95 fe ff ff       	call   2ed <printint>
        ap++;
 458:	83 c7 04             	add    $0x4,%edi
 45b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 45e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 461:	be 00 00 00 00       	mov    $0x0,%esi
 466:	e9 39 ff ff ff       	jmp    3a4 <printf+0x30>
        s = (char*)*ap;
 46b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 46e:	8b 30                	mov    (%eax),%esi
        ap++;
 470:	83 c0 04             	add    $0x4,%eax
 473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 476:	85 f6                	test   %esi,%esi
 478:	75 28                	jne    4a2 <printf+0x12e>
          s = "(null)";
 47a:	be 34 06 00 00       	mov    $0x634,%esi
 47f:	8b 7d 08             	mov    0x8(%ebp),%edi
 482:	eb 0d                	jmp    491 <printf+0x11d>
          putc(fd, *s);
 484:	0f be d2             	movsbl %dl,%edx
 487:	89 f8                	mov    %edi,%eax
 489:	e8 45 fe ff ff       	call   2d3 <putc>
          s++;
 48e:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 491:	0f b6 16             	movzbl (%esi),%edx
 494:	84 d2                	test   %dl,%dl
 496:	75 ec                	jne    484 <printf+0x110>
      state = 0;
 498:	be 00 00 00 00       	mov    $0x0,%esi
 49d:	e9 02 ff ff ff       	jmp    3a4 <printf+0x30>
 4a2:	8b 7d 08             	mov    0x8(%ebp),%edi
 4a5:	eb ea                	jmp    491 <printf+0x11d>
        putc(fd, *ap);
 4a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4aa:	0f be 17             	movsbl (%edi),%edx
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	e8 1e fe ff ff       	call   2d3 <putc>
        ap++;
 4b5:	83 c7 04             	add    $0x4,%edi
 4b8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4bb:	be 00 00 00 00       	mov    $0x0,%esi
 4c0:	e9 df fe ff ff       	jmp    3a4 <printf+0x30>
        putc(fd, c);
 4c5:	89 fa                	mov    %edi,%edx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	e8 04 fe ff ff       	call   2d3 <putc>
      state = 0;
 4cf:	be 00 00 00 00       	mov    $0x0,%esi
 4d4:	e9 cb fe ff ff       	jmp    3a4 <printf+0x30>
    }
  }
}
 4d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4dc:	5b                   	pop    %ebx
 4dd:	5e                   	pop    %esi
 4de:	5f                   	pop    %edi
 4df:	5d                   	pop    %ebp
 4e0:	c3                   	ret    

000004e1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4e1:	f3 0f 1e fb          	endbr32 
 4e5:	55                   	push   %ebp
 4e6:	89 e5                	mov    %esp,%ebp
 4e8:	57                   	push   %edi
 4e9:	56                   	push   %esi
 4ea:	53                   	push   %ebx
 4eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f1:	a1 e4 08 00 00       	mov    0x8e4,%eax
 4f6:	eb 02                	jmp    4fa <free+0x19>
 4f8:	89 d0                	mov    %edx,%eax
 4fa:	39 c8                	cmp    %ecx,%eax
 4fc:	73 04                	jae    502 <free+0x21>
 4fe:	39 08                	cmp    %ecx,(%eax)
 500:	77 12                	ja     514 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 502:	8b 10                	mov    (%eax),%edx
 504:	39 c2                	cmp    %eax,%edx
 506:	77 f0                	ja     4f8 <free+0x17>
 508:	39 c8                	cmp    %ecx,%eax
 50a:	72 08                	jb     514 <free+0x33>
 50c:	39 ca                	cmp    %ecx,%edx
 50e:	77 04                	ja     514 <free+0x33>
 510:	89 d0                	mov    %edx,%eax
 512:	eb e6                	jmp    4fa <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 514:	8b 73 fc             	mov    -0x4(%ebx),%esi
 517:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 51a:	8b 10                	mov    (%eax),%edx
 51c:	39 d7                	cmp    %edx,%edi
 51e:	74 19                	je     539 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 520:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 523:	8b 50 04             	mov    0x4(%eax),%edx
 526:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 529:	39 ce                	cmp    %ecx,%esi
 52b:	74 1b                	je     548 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 52d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 52f:	a3 e4 08 00 00       	mov    %eax,0x8e4
}
 534:	5b                   	pop    %ebx
 535:	5e                   	pop    %esi
 536:	5f                   	pop    %edi
 537:	5d                   	pop    %ebp
 538:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 539:	03 72 04             	add    0x4(%edx),%esi
 53c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 53f:	8b 10                	mov    (%eax),%edx
 541:	8b 12                	mov    (%edx),%edx
 543:	89 53 f8             	mov    %edx,-0x8(%ebx)
 546:	eb db                	jmp    523 <free+0x42>
    p->s.size += bp->s.size;
 548:	03 53 fc             	add    -0x4(%ebx),%edx
 54b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 54e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 551:	89 10                	mov    %edx,(%eax)
 553:	eb da                	jmp    52f <free+0x4e>

00000555 <morecore>:

static Header*
morecore(uint nu)
{
 555:	55                   	push   %ebp
 556:	89 e5                	mov    %esp,%ebp
 558:	53                   	push   %ebx
 559:	83 ec 04             	sub    $0x4,%esp
 55c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 55e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 563:	77 05                	ja     56a <morecore+0x15>
    nu = 4096;
 565:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 56a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 571:	83 ec 0c             	sub    $0xc,%esp
 574:	50                   	push   %eax
 575:	e8 31 fd ff ff       	call   2ab <sbrk>
  if(p == (char*)-1)
 57a:	83 c4 10             	add    $0x10,%esp
 57d:	83 f8 ff             	cmp    $0xffffffff,%eax
 580:	74 1c                	je     59e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 582:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 585:	83 c0 08             	add    $0x8,%eax
 588:	83 ec 0c             	sub    $0xc,%esp
 58b:	50                   	push   %eax
 58c:	e8 50 ff ff ff       	call   4e1 <free>
  return freep;
 591:	a1 e4 08 00 00       	mov    0x8e4,%eax
 596:	83 c4 10             	add    $0x10,%esp
}
 599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 59c:	c9                   	leave  
 59d:	c3                   	ret    
    return 0;
 59e:	b8 00 00 00 00       	mov    $0x0,%eax
 5a3:	eb f4                	jmp    599 <morecore+0x44>

000005a5 <malloc>:

void*
malloc(uint nbytes)
{
 5a5:	f3 0f 1e fb          	endbr32 
 5a9:	55                   	push   %ebp
 5aa:	89 e5                	mov    %esp,%ebp
 5ac:	53                   	push   %ebx
 5ad:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	8d 58 07             	lea    0x7(%eax),%ebx
 5b6:	c1 eb 03             	shr    $0x3,%ebx
 5b9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5bc:	8b 0d e4 08 00 00    	mov    0x8e4,%ecx
 5c2:	85 c9                	test   %ecx,%ecx
 5c4:	74 04                	je     5ca <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c6:	8b 01                	mov    (%ecx),%eax
 5c8:	eb 4b                	jmp    615 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5ca:	c7 05 e4 08 00 00 e8 	movl   $0x8e8,0x8e4
 5d1:	08 00 00 
 5d4:	c7 05 e8 08 00 00 e8 	movl   $0x8e8,0x8e8
 5db:	08 00 00 
    base.s.size = 0;
 5de:	c7 05 ec 08 00 00 00 	movl   $0x0,0x8ec
 5e5:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5e8:	b9 e8 08 00 00       	mov    $0x8e8,%ecx
 5ed:	eb d7                	jmp    5c6 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5ef:	74 1a                	je     60b <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5f1:	29 da                	sub    %ebx,%edx
 5f3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5f6:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5f9:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5fc:	89 0d e4 08 00 00    	mov    %ecx,0x8e4
      return (void*)(p + 1);
 602:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 605:	83 c4 04             	add    $0x4,%esp
 608:	5b                   	pop    %ebx
 609:	5d                   	pop    %ebp
 60a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 60b:	8b 10                	mov    (%eax),%edx
 60d:	89 11                	mov    %edx,(%ecx)
 60f:	eb eb                	jmp    5fc <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 611:	89 c1                	mov    %eax,%ecx
 613:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 615:	8b 50 04             	mov    0x4(%eax),%edx
 618:	39 da                	cmp    %ebx,%edx
 61a:	73 d3                	jae    5ef <malloc+0x4a>
    if(p == freep)
 61c:	39 05 e4 08 00 00    	cmp    %eax,0x8e4
 622:	75 ed                	jne    611 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 624:	89 d8                	mov    %ebx,%eax
 626:	e8 2a ff ff ff       	call   555 <morecore>
 62b:	85 c0                	test   %eax,%eax
 62d:	75 e2                	jne    611 <malloc+0x6c>
 62f:	eb d4                	jmp    605 <malloc+0x60>
