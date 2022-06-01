
_debug:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char *argv[]){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
    
    int ret = fork();
  15:	e8 e7 01 00 00       	call   201 <fork>
    if(ret == 0) {
  1a:	85 c0                	test   %eax,%eax
  1c:	75 14                	jne    32 <main+0x32>
      printf(1, "In child\n");
  1e:	83 ec 08             	sub    $0x8,%esp
  21:	68 18 06 00 00       	push   $0x618
  26:	6a 01                	push   $0x1
  28:	e8 2d 03 00 00       	call   35a <printf>
      exit();
  2d:	e8 d7 01 00 00       	call   209 <exit>
    }else{
      int reaped_pid = wait();
  32:	e8 da 01 00 00       	call   211 <wait>
      printf(1, "Child with pid %d reaped\n", reaped_pid);
  37:	83 ec 04             	sub    $0x4,%esp
  3a:	50                   	push   %eax
  3b:	68 22 06 00 00       	push   $0x622
  40:	6a 01                	push   $0x1
  42:	e8 13 03 00 00       	call   35a <printf>
    }
    
    exit();
  47:	e8 bd 01 00 00       	call   209 <exit>

0000004c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  4c:	f3 0f 1e fb          	endbr32 
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	8b 75 08             	mov    0x8(%ebp),%esi
  58:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5b:	89 f0                	mov    %esi,%eax
  5d:	89 d1                	mov    %edx,%ecx
  5f:	83 c2 01             	add    $0x1,%edx
  62:	89 c3                	mov    %eax,%ebx
  64:	83 c0 01             	add    $0x1,%eax
  67:	0f b6 09             	movzbl (%ecx),%ecx
  6a:	88 0b                	mov    %cl,(%ebx)
  6c:	84 c9                	test   %cl,%cl
  6e:	75 ed                	jne    5d <strcpy+0x11>
    ;
  return os;
}
  70:	89 f0                	mov    %esi,%eax
  72:	5b                   	pop    %ebx
  73:	5e                   	pop    %esi
  74:	5d                   	pop    %ebp
  75:	c3                   	ret    

00000076 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  76:	f3 0f 1e fb          	endbr32 
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  83:	0f b6 01             	movzbl (%ecx),%eax
  86:	84 c0                	test   %al,%al
  88:	74 0c                	je     96 <strcmp+0x20>
  8a:	3a 02                	cmp    (%edx),%al
  8c:	75 08                	jne    96 <strcmp+0x20>
    p++, q++;
  8e:	83 c1 01             	add    $0x1,%ecx
  91:	83 c2 01             	add    $0x1,%edx
  94:	eb ed                	jmp    83 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  96:	0f b6 c0             	movzbl %al,%eax
  99:	0f b6 12             	movzbl (%edx),%edx
  9c:	29 d0                	sub    %edx,%eax
}
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <strlen>:

uint
strlen(const char *s)
{
  a0:	f3 0f 1e fb          	endbr32 
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  aa:	b8 00 00 00 00       	mov    $0x0,%eax
  af:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  b3:	74 05                	je     ba <strlen+0x1a>
  b5:	83 c0 01             	add    $0x1,%eax
  b8:	eb f5                	jmp    af <strlen+0xf>
    ;
  return n;
}
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    

000000bc <memset>:

void*
memset(void *dst, int c, uint n)
{
  bc:	f3 0f 1e fb          	endbr32 
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	89 d7                	mov    %edx,%edi
  c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	89 d0                	mov    %edx,%eax
  d4:	5f                   	pop    %edi
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    

000000d7 <strchr>:

char*
strchr(const char *s, char c)
{
  d7:	f3 0f 1e fb          	endbr32 
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  e5:	0f b6 10             	movzbl (%eax),%edx
  e8:	84 d2                	test   %dl,%dl
  ea:	74 09                	je     f5 <strchr+0x1e>
    if(*s == c)
  ec:	38 ca                	cmp    %cl,%dl
  ee:	74 0a                	je     fa <strchr+0x23>
  for(; *s; s++)
  f0:	83 c0 01             	add    $0x1,%eax
  f3:	eb f0                	jmp    e5 <strchr+0xe>
      return (char*)s;
  return 0;
  f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	f3 0f 1e fb          	endbr32 
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	83 ec 1c             	sub    $0x1c,%esp
 109:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10c:	bb 00 00 00 00       	mov    $0x0,%ebx
 111:	89 de                	mov    %ebx,%esi
 113:	83 c3 01             	add    $0x1,%ebx
 116:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 119:	7d 2e                	jge    149 <gets+0x4d>
    cc = read(0, &c, 1);
 11b:	83 ec 04             	sub    $0x4,%esp
 11e:	6a 01                	push   $0x1
 120:	8d 45 e7             	lea    -0x19(%ebp),%eax
 123:	50                   	push   %eax
 124:	6a 00                	push   $0x0
 126:	e8 f6 00 00 00       	call   221 <read>
    if(cc < 1)
 12b:	83 c4 10             	add    $0x10,%esp
 12e:	85 c0                	test   %eax,%eax
 130:	7e 17                	jle    149 <gets+0x4d>
      break;
    buf[i++] = c;
 132:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 136:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 139:	3c 0a                	cmp    $0xa,%al
 13b:	0f 94 c2             	sete   %dl
 13e:	3c 0d                	cmp    $0xd,%al
 140:	0f 94 c0             	sete   %al
 143:	08 c2                	or     %al,%dl
 145:	74 ca                	je     111 <gets+0x15>
    buf[i++] = c;
 147:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 149:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 14d:	89 f8                	mov    %edi,%eax
 14f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 152:	5b                   	pop    %ebx
 153:	5e                   	pop    %esi
 154:	5f                   	pop    %edi
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    

00000157 <stat>:

int
stat(const char *n, struct stat *st)
{
 157:	f3 0f 1e fb          	endbr32 
 15b:	55                   	push   %ebp
 15c:	89 e5                	mov    %esp,%ebp
 15e:	56                   	push   %esi
 15f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 160:	83 ec 08             	sub    $0x8,%esp
 163:	6a 00                	push   $0x0
 165:	ff 75 08             	pushl  0x8(%ebp)
 168:	e8 dc 00 00 00       	call   249 <open>
  if(fd < 0)
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	78 24                	js     198 <stat+0x41>
 174:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 176:	83 ec 08             	sub    $0x8,%esp
 179:	ff 75 0c             	pushl  0xc(%ebp)
 17c:	50                   	push   %eax
 17d:	e8 df 00 00 00       	call   261 <fstat>
 182:	89 c6                	mov    %eax,%esi
  close(fd);
 184:	89 1c 24             	mov    %ebx,(%esp)
 187:	e8 a5 00 00 00       	call   231 <close>
  return r;
 18c:	83 c4 10             	add    $0x10,%esp
}
 18f:	89 f0                	mov    %esi,%eax
 191:	8d 65 f8             	lea    -0x8(%ebp),%esp
 194:	5b                   	pop    %ebx
 195:	5e                   	pop    %esi
 196:	5d                   	pop    %ebp
 197:	c3                   	ret    
    return -1;
 198:	be ff ff ff ff       	mov    $0xffffffff,%esi
 19d:	eb f0                	jmp    18f <stat+0x38>

0000019f <atoi>:

int
atoi(const char *s)
{
 19f:	f3 0f 1e fb          	endbr32 
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	53                   	push   %ebx
 1a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1aa:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1af:	0f b6 01             	movzbl (%ecx),%eax
 1b2:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1b5:	80 fb 09             	cmp    $0x9,%bl
 1b8:	77 12                	ja     1cc <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1ba:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1bd:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1c0:	83 c1 01             	add    $0x1,%ecx
 1c3:	0f be c0             	movsbl %al,%eax
 1c6:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1ca:	eb e3                	jmp    1af <atoi+0x10>
  return n;
}
 1cc:	89 d0                	mov    %edx,%eax
 1ce:	5b                   	pop    %ebx
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    

000001d1 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d1:	f3 0f 1e fb          	endbr32 
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	56                   	push   %esi
 1d9:	53                   	push   %ebx
 1da:	8b 75 08             	mov    0x8(%ebp),%esi
 1dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1e0:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1e3:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1e8:	85 c0                	test   %eax,%eax
 1ea:	7e 0f                	jle    1fb <memmove+0x2a>
    *dst++ = *src++;
 1ec:	0f b6 01             	movzbl (%ecx),%eax
 1ef:	88 02                	mov    %al,(%edx)
 1f1:	8d 49 01             	lea    0x1(%ecx),%ecx
 1f4:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1f7:	89 d8                	mov    %ebx,%eax
 1f9:	eb ea                	jmp    1e5 <memmove+0x14>
  return vdst;
}
 1fb:	89 f0                	mov    %esi,%eax
 1fd:	5b                   	pop    %ebx
 1fe:	5e                   	pop    %esi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    

00000201 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 201:	b8 01 00 00 00       	mov    $0x1,%eax
 206:	cd 40                	int    $0x40
 208:	c3                   	ret    

00000209 <exit>:
SYSCALL(exit)
 209:	b8 02 00 00 00       	mov    $0x2,%eax
 20e:	cd 40                	int    $0x40
 210:	c3                   	ret    

00000211 <wait>:
SYSCALL(wait)
 211:	b8 03 00 00 00       	mov    $0x3,%eax
 216:	cd 40                	int    $0x40
 218:	c3                   	ret    

00000219 <pipe>:
SYSCALL(pipe)
 219:	b8 04 00 00 00       	mov    $0x4,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	ret    

00000221 <read>:
SYSCALL(read)
 221:	b8 05 00 00 00       	mov    $0x5,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <write>:
SYSCALL(write)
 229:	b8 10 00 00 00       	mov    $0x10,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <close>:
SYSCALL(close)
 231:	b8 15 00 00 00       	mov    $0x15,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <kill>:
SYSCALL(kill)
 239:	b8 06 00 00 00       	mov    $0x6,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <exec>:
SYSCALL(exec)
 241:	b8 07 00 00 00       	mov    $0x7,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <open>:
SYSCALL(open)
 249:	b8 0f 00 00 00       	mov    $0xf,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <mknod>:
SYSCALL(mknod)
 251:	b8 11 00 00 00       	mov    $0x11,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <unlink>:
SYSCALL(unlink)
 259:	b8 12 00 00 00       	mov    $0x12,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <fstat>:
SYSCALL(fstat)
 261:	b8 08 00 00 00       	mov    $0x8,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <link>:
SYSCALL(link)
 269:	b8 13 00 00 00       	mov    $0x13,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <mkdir>:
SYSCALL(mkdir)
 271:	b8 14 00 00 00       	mov    $0x14,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <chdir>:
SYSCALL(chdir)
 279:	b8 09 00 00 00       	mov    $0x9,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <dup>:
SYSCALL(dup)
 281:	b8 0a 00 00 00       	mov    $0xa,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <getpid>:
SYSCALL(getpid)
 289:	b8 0b 00 00 00       	mov    $0xb,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <sbrk>:
SYSCALL(sbrk)
 291:	b8 0c 00 00 00       	mov    $0xc,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <sleep>:
SYSCALL(sleep)
 299:	b8 0d 00 00 00       	mov    $0xd,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <uptime>:
SYSCALL(uptime)
 2a1:	b8 0e 00 00 00       	mov    $0xe,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2a9:	b8 16 00 00 00       	mov    $0x16,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <get_ancestors>:
SYSCALL(get_ancestors)
 2b1:	b8 17 00 00 00       	mov    $0x17,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2b9:	55                   	push   %ebp
 2ba:	89 e5                	mov    %esp,%ebp
 2bc:	83 ec 1c             	sub    $0x1c,%esp
 2bf:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2c2:	6a 01                	push   $0x1
 2c4:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2c7:	52                   	push   %edx
 2c8:	50                   	push   %eax
 2c9:	e8 5b ff ff ff       	call   229 <write>
}
 2ce:	83 c4 10             	add    $0x10,%esp
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	57                   	push   %edi
 2d7:	56                   	push   %esi
 2d8:	53                   	push   %ebx
 2d9:	83 ec 2c             	sub    $0x2c,%esp
 2dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2df:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e5:	0f 95 c2             	setne  %dl
 2e8:	89 f0                	mov    %esi,%eax
 2ea:	c1 e8 1f             	shr    $0x1f,%eax
 2ed:	84 c2                	test   %al,%dl
 2ef:	74 42                	je     333 <printint+0x60>
    neg = 1;
    x = -xx;
 2f1:	f7 de                	neg    %esi
    neg = 1;
 2f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ff:	89 f0                	mov    %esi,%eax
 301:	ba 00 00 00 00       	mov    $0x0,%edx
 306:	f7 f1                	div    %ecx
 308:	89 df                	mov    %ebx,%edi
 30a:	83 c3 01             	add    $0x1,%ebx
 30d:	0f b6 92 44 06 00 00 	movzbl 0x644(%edx),%edx
 314:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 318:	89 f2                	mov    %esi,%edx
 31a:	89 c6                	mov    %eax,%esi
 31c:	39 d1                	cmp    %edx,%ecx
 31e:	76 df                	jbe    2ff <printint+0x2c>
  if(neg)
 320:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 324:	74 2f                	je     355 <printint+0x82>
    buf[i++] = '-';
 326:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 32b:	8d 5f 02             	lea    0x2(%edi),%ebx
 32e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 331:	eb 15                	jmp    348 <printint+0x75>
  neg = 0;
 333:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 33a:	eb be                	jmp    2fa <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 33c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 341:	89 f0                	mov    %esi,%eax
 343:	e8 71 ff ff ff       	call   2b9 <putc>
  while(--i >= 0)
 348:	83 eb 01             	sub    $0x1,%ebx
 34b:	79 ef                	jns    33c <printint+0x69>
}
 34d:	83 c4 2c             	add    $0x2c,%esp
 350:	5b                   	pop    %ebx
 351:	5e                   	pop    %esi
 352:	5f                   	pop    %edi
 353:	5d                   	pop    %ebp
 354:	c3                   	ret    
 355:	8b 75 d0             	mov    -0x30(%ebp),%esi
 358:	eb ee                	jmp    348 <printint+0x75>

0000035a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 35a:	f3 0f 1e fb          	endbr32 
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	57                   	push   %edi
 362:	56                   	push   %esi
 363:	53                   	push   %ebx
 364:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 367:	8d 45 10             	lea    0x10(%ebp),%eax
 36a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 36d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 372:	bb 00 00 00 00       	mov    $0x0,%ebx
 377:	eb 14                	jmp    38d <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 379:	89 fa                	mov    %edi,%edx
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	e8 36 ff ff ff       	call   2b9 <putc>
 383:	eb 05                	jmp    38a <printf+0x30>
      }
    } else if(state == '%'){
 385:	83 fe 25             	cmp    $0x25,%esi
 388:	74 25                	je     3af <printf+0x55>
  for(i = 0; fmt[i]; i++){
 38a:	83 c3 01             	add    $0x1,%ebx
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 394:	84 c0                	test   %al,%al
 396:	0f 84 23 01 00 00    	je     4bf <printf+0x165>
    c = fmt[i] & 0xff;
 39c:	0f be f8             	movsbl %al,%edi
 39f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3a2:	85 f6                	test   %esi,%esi
 3a4:	75 df                	jne    385 <printf+0x2b>
      if(c == '%'){
 3a6:	83 f8 25             	cmp    $0x25,%eax
 3a9:	75 ce                	jne    379 <printf+0x1f>
        state = '%';
 3ab:	89 c6                	mov    %eax,%esi
 3ad:	eb db                	jmp    38a <printf+0x30>
      if(c == 'd'){
 3af:	83 f8 64             	cmp    $0x64,%eax
 3b2:	74 49                	je     3fd <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3b4:	83 f8 78             	cmp    $0x78,%eax
 3b7:	0f 94 c1             	sete   %cl
 3ba:	83 f8 70             	cmp    $0x70,%eax
 3bd:	0f 94 c2             	sete   %dl
 3c0:	08 d1                	or     %dl,%cl
 3c2:	75 63                	jne    427 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3c4:	83 f8 73             	cmp    $0x73,%eax
 3c7:	0f 84 84 00 00 00    	je     451 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3cd:	83 f8 63             	cmp    $0x63,%eax
 3d0:	0f 84 b7 00 00 00    	je     48d <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3d6:	83 f8 25             	cmp    $0x25,%eax
 3d9:	0f 84 cc 00 00 00    	je     4ab <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3df:	ba 25 00 00 00       	mov    $0x25,%edx
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	e8 cd fe ff ff       	call   2b9 <putc>
        putc(fd, c);
 3ec:	89 fa                	mov    %edi,%edx
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	e8 c3 fe ff ff       	call   2b9 <putc>
      }
      state = 0;
 3f6:	be 00 00 00 00       	mov    $0x0,%esi
 3fb:	eb 8d                	jmp    38a <printf+0x30>
        printint(fd, *ap, 10, 1);
 3fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 400:	8b 17                	mov    (%edi),%edx
 402:	83 ec 0c             	sub    $0xc,%esp
 405:	6a 01                	push   $0x1
 407:	b9 0a 00 00 00       	mov    $0xa,%ecx
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	e8 bf fe ff ff       	call   2d3 <printint>
        ap++;
 414:	83 c7 04             	add    $0x4,%edi
 417:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 41d:	be 00 00 00 00       	mov    $0x0,%esi
 422:	e9 63 ff ff ff       	jmp    38a <printf+0x30>
        printint(fd, *ap, 16, 0);
 427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42a:	8b 17                	mov    (%edi),%edx
 42c:	83 ec 0c             	sub    $0xc,%esp
 42f:	6a 00                	push   $0x0
 431:	b9 10 00 00 00       	mov    $0x10,%ecx
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	e8 95 fe ff ff       	call   2d3 <printint>
        ap++;
 43e:	83 c7 04             	add    $0x4,%edi
 441:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 444:	83 c4 10             	add    $0x10,%esp
      state = 0;
 447:	be 00 00 00 00       	mov    $0x0,%esi
 44c:	e9 39 ff ff ff       	jmp    38a <printf+0x30>
        s = (char*)*ap;
 451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 454:	8b 30                	mov    (%eax),%esi
        ap++;
 456:	83 c0 04             	add    $0x4,%eax
 459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 45c:	85 f6                	test   %esi,%esi
 45e:	75 28                	jne    488 <printf+0x12e>
          s = "(null)";
 460:	be 3c 06 00 00       	mov    $0x63c,%esi
 465:	8b 7d 08             	mov    0x8(%ebp),%edi
 468:	eb 0d                	jmp    477 <printf+0x11d>
          putc(fd, *s);
 46a:	0f be d2             	movsbl %dl,%edx
 46d:	89 f8                	mov    %edi,%eax
 46f:	e8 45 fe ff ff       	call   2b9 <putc>
          s++;
 474:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 477:	0f b6 16             	movzbl (%esi),%edx
 47a:	84 d2                	test   %dl,%dl
 47c:	75 ec                	jne    46a <printf+0x110>
      state = 0;
 47e:	be 00 00 00 00       	mov    $0x0,%esi
 483:	e9 02 ff ff ff       	jmp    38a <printf+0x30>
 488:	8b 7d 08             	mov    0x8(%ebp),%edi
 48b:	eb ea                	jmp    477 <printf+0x11d>
        putc(fd, *ap);
 48d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 490:	0f be 17             	movsbl (%edi),%edx
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	e8 1e fe ff ff       	call   2b9 <putc>
        ap++;
 49b:	83 c7 04             	add    $0x4,%edi
 49e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4a1:	be 00 00 00 00       	mov    $0x0,%esi
 4a6:	e9 df fe ff ff       	jmp    38a <printf+0x30>
        putc(fd, c);
 4ab:	89 fa                	mov    %edi,%edx
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	e8 04 fe ff ff       	call   2b9 <putc>
      state = 0;
 4b5:	be 00 00 00 00       	mov    $0x0,%esi
 4ba:	e9 cb fe ff ff       	jmp    38a <printf+0x30>
    }
  }
}
 4bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c2:	5b                   	pop    %ebx
 4c3:	5e                   	pop    %esi
 4c4:	5f                   	pop    %edi
 4c5:	5d                   	pop    %ebp
 4c6:	c3                   	ret    

000004c7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c7:	f3 0f 1e fb          	endbr32 
 4cb:	55                   	push   %ebp
 4cc:	89 e5                	mov    %esp,%ebp
 4ce:	57                   	push   %edi
 4cf:	56                   	push   %esi
 4d0:	53                   	push   %ebx
 4d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d7:	a1 e4 08 00 00       	mov    0x8e4,%eax
 4dc:	eb 02                	jmp    4e0 <free+0x19>
 4de:	89 d0                	mov    %edx,%eax
 4e0:	39 c8                	cmp    %ecx,%eax
 4e2:	73 04                	jae    4e8 <free+0x21>
 4e4:	39 08                	cmp    %ecx,(%eax)
 4e6:	77 12                	ja     4fa <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e8:	8b 10                	mov    (%eax),%edx
 4ea:	39 c2                	cmp    %eax,%edx
 4ec:	77 f0                	ja     4de <free+0x17>
 4ee:	39 c8                	cmp    %ecx,%eax
 4f0:	72 08                	jb     4fa <free+0x33>
 4f2:	39 ca                	cmp    %ecx,%edx
 4f4:	77 04                	ja     4fa <free+0x33>
 4f6:	89 d0                	mov    %edx,%eax
 4f8:	eb e6                	jmp    4e0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4fa:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4fd:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 500:	8b 10                	mov    (%eax),%edx
 502:	39 d7                	cmp    %edx,%edi
 504:	74 19                	je     51f <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 506:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 509:	8b 50 04             	mov    0x4(%eax),%edx
 50c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 50f:	39 ce                	cmp    %ecx,%esi
 511:	74 1b                	je     52e <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 513:	89 08                	mov    %ecx,(%eax)
  freep = p;
 515:	a3 e4 08 00 00       	mov    %eax,0x8e4
}
 51a:	5b                   	pop    %ebx
 51b:	5e                   	pop    %esi
 51c:	5f                   	pop    %edi
 51d:	5d                   	pop    %ebp
 51e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 51f:	03 72 04             	add    0x4(%edx),%esi
 522:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 525:	8b 10                	mov    (%eax),%edx
 527:	8b 12                	mov    (%edx),%edx
 529:	89 53 f8             	mov    %edx,-0x8(%ebx)
 52c:	eb db                	jmp    509 <free+0x42>
    p->s.size += bp->s.size;
 52e:	03 53 fc             	add    -0x4(%ebx),%edx
 531:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 534:	8b 53 f8             	mov    -0x8(%ebx),%edx
 537:	89 10                	mov    %edx,(%eax)
 539:	eb da                	jmp    515 <free+0x4e>

0000053b <morecore>:

static Header*
morecore(uint nu)
{
 53b:	55                   	push   %ebp
 53c:	89 e5                	mov    %esp,%ebp
 53e:	53                   	push   %ebx
 53f:	83 ec 04             	sub    $0x4,%esp
 542:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 544:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 549:	77 05                	ja     550 <morecore+0x15>
    nu = 4096;
 54b:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 550:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 557:	83 ec 0c             	sub    $0xc,%esp
 55a:	50                   	push   %eax
 55b:	e8 31 fd ff ff       	call   291 <sbrk>
  if(p == (char*)-1)
 560:	83 c4 10             	add    $0x10,%esp
 563:	83 f8 ff             	cmp    $0xffffffff,%eax
 566:	74 1c                	je     584 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 568:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 56b:	83 c0 08             	add    $0x8,%eax
 56e:	83 ec 0c             	sub    $0xc,%esp
 571:	50                   	push   %eax
 572:	e8 50 ff ff ff       	call   4c7 <free>
  return freep;
 577:	a1 e4 08 00 00       	mov    0x8e4,%eax
 57c:	83 c4 10             	add    $0x10,%esp
}
 57f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 582:	c9                   	leave  
 583:	c3                   	ret    
    return 0;
 584:	b8 00 00 00 00       	mov    $0x0,%eax
 589:	eb f4                	jmp    57f <morecore+0x44>

0000058b <malloc>:

void*
malloc(uint nbytes)
{
 58b:	f3 0f 1e fb          	endbr32 
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	53                   	push   %ebx
 593:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	8d 58 07             	lea    0x7(%eax),%ebx
 59c:	c1 eb 03             	shr    $0x3,%ebx
 59f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a2:	8b 0d e4 08 00 00    	mov    0x8e4,%ecx
 5a8:	85 c9                	test   %ecx,%ecx
 5aa:	74 04                	je     5b0 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ac:	8b 01                	mov    (%ecx),%eax
 5ae:	eb 4b                	jmp    5fb <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5b0:	c7 05 e4 08 00 00 e8 	movl   $0x8e8,0x8e4
 5b7:	08 00 00 
 5ba:	c7 05 e8 08 00 00 e8 	movl   $0x8e8,0x8e8
 5c1:	08 00 00 
    base.s.size = 0;
 5c4:	c7 05 ec 08 00 00 00 	movl   $0x0,0x8ec
 5cb:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5ce:	b9 e8 08 00 00       	mov    $0x8e8,%ecx
 5d3:	eb d7                	jmp    5ac <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5d5:	74 1a                	je     5f1 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5d7:	29 da                	sub    %ebx,%edx
 5d9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5dc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5df:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5e2:	89 0d e4 08 00 00    	mov    %ecx,0x8e4
      return (void*)(p + 1);
 5e8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5eb:	83 c4 04             	add    $0x4,%esp
 5ee:	5b                   	pop    %ebx
 5ef:	5d                   	pop    %ebp
 5f0:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5f1:	8b 10                	mov    (%eax),%edx
 5f3:	89 11                	mov    %edx,(%ecx)
 5f5:	eb eb                	jmp    5e2 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f7:	89 c1                	mov    %eax,%ecx
 5f9:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5fb:	8b 50 04             	mov    0x4(%eax),%edx
 5fe:	39 da                	cmp    %ebx,%edx
 600:	73 d3                	jae    5d5 <malloc+0x4a>
    if(p == freep)
 602:	39 05 e4 08 00 00    	cmp    %eax,0x8e4
 608:	75 ed                	jne    5f7 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 60a:	89 d8                	mov    %ebx,%eax
 60c:	e8 2a ff ff ff       	call   53b <morecore>
 611:	85 c0                	test   %eax,%eax
 613:	75 e2                	jne    5f7 <malloc+0x6c>
 615:	eb d4                	jmp    5eb <malloc+0x60>
