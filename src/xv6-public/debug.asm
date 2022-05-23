
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
  21:	68 08 06 00 00       	push   $0x608
  26:	6a 01                	push   $0x1
  28:	e8 1d 03 00 00       	call   34a <printf>
      exit();
  2d:	e8 d7 01 00 00       	call   209 <exit>
    }else{
      int reaped_pid = wait();
  32:	e8 da 01 00 00       	call   211 <wait>
      printf(1, "Child with pid %d reaped\n", reaped_pid);
  37:	83 ec 04             	sub    $0x4,%esp
  3a:	50                   	push   %eax
  3b:	68 12 06 00 00       	push   $0x612
  40:	6a 01                	push   $0x1
  42:	e8 03 03 00 00       	call   34a <printf>
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

000002a9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	83 ec 1c             	sub    $0x1c,%esp
 2af:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2b2:	6a 01                	push   $0x1
 2b4:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2b7:	52                   	push   %edx
 2b8:	50                   	push   %eax
 2b9:	e8 6b ff ff ff       	call   229 <write>
}
 2be:	83 c4 10             	add    $0x10,%esp
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	57                   	push   %edi
 2c7:	56                   	push   %esi
 2c8:	53                   	push   %ebx
 2c9:	83 ec 2c             	sub    $0x2c,%esp
 2cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2cf:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d5:	0f 95 c2             	setne  %dl
 2d8:	89 f0                	mov    %esi,%eax
 2da:	c1 e8 1f             	shr    $0x1f,%eax
 2dd:	84 c2                	test   %al,%dl
 2df:	74 42                	je     323 <printint+0x60>
    neg = 1;
    x = -xx;
 2e1:	f7 de                	neg    %esi
    neg = 1;
 2e3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ef:	89 f0                	mov    %esi,%eax
 2f1:	ba 00 00 00 00       	mov    $0x0,%edx
 2f6:	f7 f1                	div    %ecx
 2f8:	89 df                	mov    %ebx,%edi
 2fa:	83 c3 01             	add    $0x1,%ebx
 2fd:	0f b6 92 34 06 00 00 	movzbl 0x634(%edx),%edx
 304:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 308:	89 f2                	mov    %esi,%edx
 30a:	89 c6                	mov    %eax,%esi
 30c:	39 d1                	cmp    %edx,%ecx
 30e:	76 df                	jbe    2ef <printint+0x2c>
  if(neg)
 310:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 314:	74 2f                	je     345 <printint+0x82>
    buf[i++] = '-';
 316:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 31b:	8d 5f 02             	lea    0x2(%edi),%ebx
 31e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 321:	eb 15                	jmp    338 <printint+0x75>
  neg = 0;
 323:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 32a:	eb be                	jmp    2ea <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 32c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 331:	89 f0                	mov    %esi,%eax
 333:	e8 71 ff ff ff       	call   2a9 <putc>
  while(--i >= 0)
 338:	83 eb 01             	sub    $0x1,%ebx
 33b:	79 ef                	jns    32c <printint+0x69>
}
 33d:	83 c4 2c             	add    $0x2c,%esp
 340:	5b                   	pop    %ebx
 341:	5e                   	pop    %esi
 342:	5f                   	pop    %edi
 343:	5d                   	pop    %ebp
 344:	c3                   	ret    
 345:	8b 75 d0             	mov    -0x30(%ebp),%esi
 348:	eb ee                	jmp    338 <printint+0x75>

0000034a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 34a:	f3 0f 1e fb          	endbr32 
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	57                   	push   %edi
 352:	56                   	push   %esi
 353:	53                   	push   %ebx
 354:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 357:	8d 45 10             	lea    0x10(%ebp),%eax
 35a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 35d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 362:	bb 00 00 00 00       	mov    $0x0,%ebx
 367:	eb 14                	jmp    37d <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 369:	89 fa                	mov    %edi,%edx
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	e8 36 ff ff ff       	call   2a9 <putc>
 373:	eb 05                	jmp    37a <printf+0x30>
      }
    } else if(state == '%'){
 375:	83 fe 25             	cmp    $0x25,%esi
 378:	74 25                	je     39f <printf+0x55>
  for(i = 0; fmt[i]; i++){
 37a:	83 c3 01             	add    $0x1,%ebx
 37d:	8b 45 0c             	mov    0xc(%ebp),%eax
 380:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 384:	84 c0                	test   %al,%al
 386:	0f 84 23 01 00 00    	je     4af <printf+0x165>
    c = fmt[i] & 0xff;
 38c:	0f be f8             	movsbl %al,%edi
 38f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 392:	85 f6                	test   %esi,%esi
 394:	75 df                	jne    375 <printf+0x2b>
      if(c == '%'){
 396:	83 f8 25             	cmp    $0x25,%eax
 399:	75 ce                	jne    369 <printf+0x1f>
        state = '%';
 39b:	89 c6                	mov    %eax,%esi
 39d:	eb db                	jmp    37a <printf+0x30>
      if(c == 'd'){
 39f:	83 f8 64             	cmp    $0x64,%eax
 3a2:	74 49                	je     3ed <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3a4:	83 f8 78             	cmp    $0x78,%eax
 3a7:	0f 94 c1             	sete   %cl
 3aa:	83 f8 70             	cmp    $0x70,%eax
 3ad:	0f 94 c2             	sete   %dl
 3b0:	08 d1                	or     %dl,%cl
 3b2:	75 63                	jne    417 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3b4:	83 f8 73             	cmp    $0x73,%eax
 3b7:	0f 84 84 00 00 00    	je     441 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3bd:	83 f8 63             	cmp    $0x63,%eax
 3c0:	0f 84 b7 00 00 00    	je     47d <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3c6:	83 f8 25             	cmp    $0x25,%eax
 3c9:	0f 84 cc 00 00 00    	je     49b <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3cf:	ba 25 00 00 00       	mov    $0x25,%edx
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	e8 cd fe ff ff       	call   2a9 <putc>
        putc(fd, c);
 3dc:	89 fa                	mov    %edi,%edx
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	e8 c3 fe ff ff       	call   2a9 <putc>
      }
      state = 0;
 3e6:	be 00 00 00 00       	mov    $0x0,%esi
 3eb:	eb 8d                	jmp    37a <printf+0x30>
        printint(fd, *ap, 10, 1);
 3ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f0:	8b 17                	mov    (%edi),%edx
 3f2:	83 ec 0c             	sub    $0xc,%esp
 3f5:	6a 01                	push   $0x1
 3f7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	e8 bf fe ff ff       	call   2c3 <printint>
        ap++;
 404:	83 c7 04             	add    $0x4,%edi
 407:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 40a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 40d:	be 00 00 00 00       	mov    $0x0,%esi
 412:	e9 63 ff ff ff       	jmp    37a <printf+0x30>
        printint(fd, *ap, 16, 0);
 417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 41a:	8b 17                	mov    (%edi),%edx
 41c:	83 ec 0c             	sub    $0xc,%esp
 41f:	6a 00                	push   $0x0
 421:	b9 10 00 00 00       	mov    $0x10,%ecx
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	e8 95 fe ff ff       	call   2c3 <printint>
        ap++;
 42e:	83 c7 04             	add    $0x4,%edi
 431:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 434:	83 c4 10             	add    $0x10,%esp
      state = 0;
 437:	be 00 00 00 00       	mov    $0x0,%esi
 43c:	e9 39 ff ff ff       	jmp    37a <printf+0x30>
        s = (char*)*ap;
 441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 444:	8b 30                	mov    (%eax),%esi
        ap++;
 446:	83 c0 04             	add    $0x4,%eax
 449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 44c:	85 f6                	test   %esi,%esi
 44e:	75 28                	jne    478 <printf+0x12e>
          s = "(null)";
 450:	be 2c 06 00 00       	mov    $0x62c,%esi
 455:	8b 7d 08             	mov    0x8(%ebp),%edi
 458:	eb 0d                	jmp    467 <printf+0x11d>
          putc(fd, *s);
 45a:	0f be d2             	movsbl %dl,%edx
 45d:	89 f8                	mov    %edi,%eax
 45f:	e8 45 fe ff ff       	call   2a9 <putc>
          s++;
 464:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 467:	0f b6 16             	movzbl (%esi),%edx
 46a:	84 d2                	test   %dl,%dl
 46c:	75 ec                	jne    45a <printf+0x110>
      state = 0;
 46e:	be 00 00 00 00       	mov    $0x0,%esi
 473:	e9 02 ff ff ff       	jmp    37a <printf+0x30>
 478:	8b 7d 08             	mov    0x8(%ebp),%edi
 47b:	eb ea                	jmp    467 <printf+0x11d>
        putc(fd, *ap);
 47d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 480:	0f be 17             	movsbl (%edi),%edx
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	e8 1e fe ff ff       	call   2a9 <putc>
        ap++;
 48b:	83 c7 04             	add    $0x4,%edi
 48e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 491:	be 00 00 00 00       	mov    $0x0,%esi
 496:	e9 df fe ff ff       	jmp    37a <printf+0x30>
        putc(fd, c);
 49b:	89 fa                	mov    %edi,%edx
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
 4a0:	e8 04 fe ff ff       	call   2a9 <putc>
      state = 0;
 4a5:	be 00 00 00 00       	mov    $0x0,%esi
 4aa:	e9 cb fe ff ff       	jmp    37a <printf+0x30>
    }
  }
}
 4af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b2:	5b                   	pop    %ebx
 4b3:	5e                   	pop    %esi
 4b4:	5f                   	pop    %edi
 4b5:	5d                   	pop    %ebp
 4b6:	c3                   	ret    

000004b7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4b7:	f3 0f 1e fb          	endbr32 
 4bb:	55                   	push   %ebp
 4bc:	89 e5                	mov    %esp,%ebp
 4be:	57                   	push   %edi
 4bf:	56                   	push   %esi
 4c0:	53                   	push   %ebx
 4c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c7:	a1 d4 08 00 00       	mov    0x8d4,%eax
 4cc:	eb 02                	jmp    4d0 <free+0x19>
 4ce:	89 d0                	mov    %edx,%eax
 4d0:	39 c8                	cmp    %ecx,%eax
 4d2:	73 04                	jae    4d8 <free+0x21>
 4d4:	39 08                	cmp    %ecx,(%eax)
 4d6:	77 12                	ja     4ea <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d8:	8b 10                	mov    (%eax),%edx
 4da:	39 c2                	cmp    %eax,%edx
 4dc:	77 f0                	ja     4ce <free+0x17>
 4de:	39 c8                	cmp    %ecx,%eax
 4e0:	72 08                	jb     4ea <free+0x33>
 4e2:	39 ca                	cmp    %ecx,%edx
 4e4:	77 04                	ja     4ea <free+0x33>
 4e6:	89 d0                	mov    %edx,%eax
 4e8:	eb e6                	jmp    4d0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4ea:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ed:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f0:	8b 10                	mov    (%eax),%edx
 4f2:	39 d7                	cmp    %edx,%edi
 4f4:	74 19                	je     50f <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4f6:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4f9:	8b 50 04             	mov    0x4(%eax),%edx
 4fc:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4ff:	39 ce                	cmp    %ecx,%esi
 501:	74 1b                	je     51e <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 503:	89 08                	mov    %ecx,(%eax)
  freep = p;
 505:	a3 d4 08 00 00       	mov    %eax,0x8d4
}
 50a:	5b                   	pop    %ebx
 50b:	5e                   	pop    %esi
 50c:	5f                   	pop    %edi
 50d:	5d                   	pop    %ebp
 50e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 50f:	03 72 04             	add    0x4(%edx),%esi
 512:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 515:	8b 10                	mov    (%eax),%edx
 517:	8b 12                	mov    (%edx),%edx
 519:	89 53 f8             	mov    %edx,-0x8(%ebx)
 51c:	eb db                	jmp    4f9 <free+0x42>
    p->s.size += bp->s.size;
 51e:	03 53 fc             	add    -0x4(%ebx),%edx
 521:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 524:	8b 53 f8             	mov    -0x8(%ebx),%edx
 527:	89 10                	mov    %edx,(%eax)
 529:	eb da                	jmp    505 <free+0x4e>

0000052b <morecore>:

static Header*
morecore(uint nu)
{
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	53                   	push   %ebx
 52f:	83 ec 04             	sub    $0x4,%esp
 532:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 534:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 539:	77 05                	ja     540 <morecore+0x15>
    nu = 4096;
 53b:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 540:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 547:	83 ec 0c             	sub    $0xc,%esp
 54a:	50                   	push   %eax
 54b:	e8 41 fd ff ff       	call   291 <sbrk>
  if(p == (char*)-1)
 550:	83 c4 10             	add    $0x10,%esp
 553:	83 f8 ff             	cmp    $0xffffffff,%eax
 556:	74 1c                	je     574 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 558:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 55b:	83 c0 08             	add    $0x8,%eax
 55e:	83 ec 0c             	sub    $0xc,%esp
 561:	50                   	push   %eax
 562:	e8 50 ff ff ff       	call   4b7 <free>
  return freep;
 567:	a1 d4 08 00 00       	mov    0x8d4,%eax
 56c:	83 c4 10             	add    $0x10,%esp
}
 56f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 572:	c9                   	leave  
 573:	c3                   	ret    
    return 0;
 574:	b8 00 00 00 00       	mov    $0x0,%eax
 579:	eb f4                	jmp    56f <morecore+0x44>

0000057b <malloc>:

void*
malloc(uint nbytes)
{
 57b:	f3 0f 1e fb          	endbr32 
 57f:	55                   	push   %ebp
 580:	89 e5                	mov    %esp,%ebp
 582:	53                   	push   %ebx
 583:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	8d 58 07             	lea    0x7(%eax),%ebx
 58c:	c1 eb 03             	shr    $0x3,%ebx
 58f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 592:	8b 0d d4 08 00 00    	mov    0x8d4,%ecx
 598:	85 c9                	test   %ecx,%ecx
 59a:	74 04                	je     5a0 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 59c:	8b 01                	mov    (%ecx),%eax
 59e:	eb 4b                	jmp    5eb <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5a0:	c7 05 d4 08 00 00 d8 	movl   $0x8d8,0x8d4
 5a7:	08 00 00 
 5aa:	c7 05 d8 08 00 00 d8 	movl   $0x8d8,0x8d8
 5b1:	08 00 00 
    base.s.size = 0;
 5b4:	c7 05 dc 08 00 00 00 	movl   $0x0,0x8dc
 5bb:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5be:	b9 d8 08 00 00       	mov    $0x8d8,%ecx
 5c3:	eb d7                	jmp    59c <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5c5:	74 1a                	je     5e1 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c7:	29 da                	sub    %ebx,%edx
 5c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5cc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5cf:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5d2:	89 0d d4 08 00 00    	mov    %ecx,0x8d4
      return (void*)(p + 1);
 5d8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5db:	83 c4 04             	add    $0x4,%esp
 5de:	5b                   	pop    %ebx
 5df:	5d                   	pop    %ebp
 5e0:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5e1:	8b 10                	mov    (%eax),%edx
 5e3:	89 11                	mov    %edx,(%ecx)
 5e5:	eb eb                	jmp    5d2 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e7:	89 c1                	mov    %eax,%ecx
 5e9:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5eb:	8b 50 04             	mov    0x4(%eax),%edx
 5ee:	39 da                	cmp    %ebx,%edx
 5f0:	73 d3                	jae    5c5 <malloc+0x4a>
    if(p == freep)
 5f2:	39 05 d4 08 00 00    	cmp    %eax,0x8d4
 5f8:	75 ed                	jne    5e7 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 5fa:	89 d8                	mov    %ebx,%eax
 5fc:	e8 2a ff ff ff       	call   52b <morecore>
 601:	85 c0                	test   %eax,%eax
 603:	75 e2                	jne    5e7 <malloc+0x6c>
 605:	eb d4                	jmp    5db <malloc+0x60>
