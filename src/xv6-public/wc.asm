
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	57                   	push   %edi
   8:	56                   	push   %esi
   9:	53                   	push   %ebx
   a:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  14:	be 00 00 00 00       	mov    $0x0,%esi
  19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	68 00 02 00 00       	push   $0x200
  2f:	68 80 0a 00 00       	push   $0xa80
  34:	ff 75 08             	pushl  0x8(%ebp)
  37:	e8 03 03 00 00       	call   33f <read>
  3c:	89 c7                	mov    %eax,%edi
  3e:	83 c4 10             	add    $0x10,%esp
  41:	85 c0                	test   %eax,%eax
  43:	7e 54                	jle    99 <wc+0x99>
    for(i=0; i<n; i++){
  45:	bb 00 00 00 00       	mov    $0x0,%ebx
  4a:	eb 22                	jmp    6e <wc+0x6e>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	0f be c0             	movsbl %al,%eax
  52:	50                   	push   %eax
  53:	68 28 07 00 00       	push   $0x728
  58:	e8 98 01 00 00       	call   1f5 <strchr>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	85 c0                	test   %eax,%eax
  62:	74 22                	je     86 <wc+0x86>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  6b:	83 c3 01             	add    $0x1,%ebx
  6e:	39 fb                	cmp    %edi,%ebx
  70:	7d b5                	jge    27 <wc+0x27>
      c++;
  72:	83 c6 01             	add    $0x1,%esi
      if(buf[i] == '\n')
  75:	0f b6 83 80 0a 00 00 	movzbl 0xa80(%ebx),%eax
  7c:	3c 0a                	cmp    $0xa,%al
  7e:	75 cc                	jne    4c <wc+0x4c>
        l++;
  80:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  84:	eb c6                	jmp    4c <wc+0x4c>
      else if(!inword){
  86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8a:	75 df                	jne    6b <wc+0x6b>
        w++;
  8c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
        inword = 1;
  90:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  97:	eb d2                	jmp    6b <wc+0x6b>
      }
    }
  }
  if(n < 0){
  99:	78 24                	js     bf <wc+0xbf>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	ff 75 0c             	pushl  0xc(%ebp)
  a1:	56                   	push   %esi
  a2:	ff 75 dc             	pushl  -0x24(%ebp)
  a5:	ff 75 e0             	pushl  -0x20(%ebp)
  a8:	68 3e 07 00 00       	push   $0x73e
  ad:	6a 01                	push   $0x1
  af:	e8 b4 03 00 00       	call   468 <printf>
}
  b4:	83 c4 20             	add    $0x20,%esp
  b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ba:	5b                   	pop    %ebx
  bb:	5e                   	pop    %esi
  bc:	5f                   	pop    %edi
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    
    printf(1, "wc: read error\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 2e 07 00 00       	push   $0x72e
  c7:	6a 01                	push   $0x1
  c9:	e8 9a 03 00 00       	call   468 <printf>
    exit();
  ce:	e8 54 02 00 00       	call   327 <exit>

000000d3 <main>:

int
main(int argc, char *argv[])
{
  d3:	f3 0f 1e fb          	endbr32 
  d7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  db:	83 e4 f0             	and    $0xfffffff0,%esp
  de:	ff 71 fc             	pushl  -0x4(%ecx)
  e1:	55                   	push   %ebp
  e2:	89 e5                	mov    %esp,%ebp
  e4:	57                   	push   %edi
  e5:	56                   	push   %esi
  e6:	53                   	push   %ebx
  e7:	51                   	push   %ecx
  e8:	83 ec 18             	sub    $0x18,%esp
  eb:	8b 01                	mov    (%ecx),%eax
  ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  f0:	8b 51 04             	mov    0x4(%ecx),%edx
  f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  f6:	83 f8 01             	cmp    $0x1,%eax
  f9:	7e 40                	jle    13b <main+0x68>
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  fb:	be 01 00 00 00       	mov    $0x1,%esi
 100:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 103:	7d 60                	jge    165 <main+0x92>
    if((fd = open(argv[i], 0)) < 0){
 105:	8b 45 e0             	mov    -0x20(%ebp),%eax
 108:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	6a 00                	push   $0x0
 110:	ff 37                	pushl  (%edi)
 112:	e8 50 02 00 00       	call   367 <open>
 117:	89 c3                	mov    %eax,%ebx
 119:	83 c4 10             	add    $0x10,%esp
 11c:	85 c0                	test   %eax,%eax
 11e:	78 2f                	js     14f <main+0x7c>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 120:	83 ec 08             	sub    $0x8,%esp
 123:	ff 37                	pushl  (%edi)
 125:	50                   	push   %eax
 126:	e8 d5 fe ff ff       	call   0 <wc>
    close(fd);
 12b:	89 1c 24             	mov    %ebx,(%esp)
 12e:	e8 1c 02 00 00       	call   34f <close>
  for(i = 1; i < argc; i++){
 133:	83 c6 01             	add    $0x1,%esi
 136:	83 c4 10             	add    $0x10,%esp
 139:	eb c5                	jmp    100 <main+0x2d>
    wc(0, "");
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	68 3d 07 00 00       	push   $0x73d
 143:	6a 00                	push   $0x0
 145:	e8 b6 fe ff ff       	call   0 <wc>
    exit();
 14a:	e8 d8 01 00 00       	call   327 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 14f:	83 ec 04             	sub    $0x4,%esp
 152:	ff 37                	pushl  (%edi)
 154:	68 4b 07 00 00       	push   $0x74b
 159:	6a 01                	push   $0x1
 15b:	e8 08 03 00 00       	call   468 <printf>
      exit();
 160:	e8 c2 01 00 00       	call   327 <exit>
  }
  exit();
 165:	e8 bd 01 00 00       	call   327 <exit>

0000016a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 16a:	f3 0f 1e fb          	endbr32 
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
 173:	8b 75 08             	mov    0x8(%ebp),%esi
 176:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 179:	89 f0                	mov    %esi,%eax
 17b:	89 d1                	mov    %edx,%ecx
 17d:	83 c2 01             	add    $0x1,%edx
 180:	89 c3                	mov    %eax,%ebx
 182:	83 c0 01             	add    $0x1,%eax
 185:	0f b6 09             	movzbl (%ecx),%ecx
 188:	88 0b                	mov    %cl,(%ebx)
 18a:	84 c9                	test   %cl,%cl
 18c:	75 ed                	jne    17b <strcpy+0x11>
    ;
  return os;
}
 18e:	89 f0                	mov    %esi,%eax
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    

00000194 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 194:	f3 0f 1e fb          	endbr32 
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 19e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1a1:	0f b6 01             	movzbl (%ecx),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 0c                	je     1b4 <strcmp+0x20>
 1a8:	3a 02                	cmp    (%edx),%al
 1aa:	75 08                	jne    1b4 <strcmp+0x20>
    p++, q++;
 1ac:	83 c1 01             	add    $0x1,%ecx
 1af:	83 c2 01             	add    $0x1,%edx
 1b2:	eb ed                	jmp    1a1 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1b4:	0f b6 c0             	movzbl %al,%eax
 1b7:	0f b6 12             	movzbl (%edx),%edx
 1ba:	29 d0                	sub    %edx,%eax
}
 1bc:	5d                   	pop    %ebp
 1bd:	c3                   	ret    

000001be <strlen>:

uint
strlen(const char *s)
{
 1be:	f3 0f 1e fb          	endbr32 
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1c8:	b8 00 00 00 00       	mov    $0x0,%eax
 1cd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1d1:	74 05                	je     1d8 <strlen+0x1a>
 1d3:	83 c0 01             	add    $0x1,%eax
 1d6:	eb f5                	jmp    1cd <strlen+0xf>
    ;
  return n;
}
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    

000001da <memset>:

void*
memset(void *dst, int c, uint n)
{
 1da:	f3 0f 1e fb          	endbr32 
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	57                   	push   %edi
 1e2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e5:	89 d7                	mov    %edx,%edi
 1e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f0:	89 d0                	mov    %edx,%eax
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <strchr>:

char*
strchr(const char *s, char c)
{
 1f5:	f3 0f 1e fb          	endbr32 
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 203:	0f b6 10             	movzbl (%eax),%edx
 206:	84 d2                	test   %dl,%dl
 208:	74 09                	je     213 <strchr+0x1e>
    if(*s == c)
 20a:	38 ca                	cmp    %cl,%dl
 20c:	74 0a                	je     218 <strchr+0x23>
  for(; *s; s++)
 20e:	83 c0 01             	add    $0x1,%eax
 211:	eb f0                	jmp    203 <strchr+0xe>
      return (char*)s;
  return 0;
 213:	b8 00 00 00 00       	mov    $0x0,%eax
}
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    

0000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	f3 0f 1e fb          	endbr32 
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	57                   	push   %edi
 222:	56                   	push   %esi
 223:	53                   	push   %ebx
 224:	83 ec 1c             	sub    $0x1c,%esp
 227:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22a:	bb 00 00 00 00       	mov    $0x0,%ebx
 22f:	89 de                	mov    %ebx,%esi
 231:	83 c3 01             	add    $0x1,%ebx
 234:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 237:	7d 2e                	jge    267 <gets+0x4d>
    cc = read(0, &c, 1);
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	6a 01                	push   $0x1
 23e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 241:	50                   	push   %eax
 242:	6a 00                	push   $0x0
 244:	e8 f6 00 00 00       	call   33f <read>
    if(cc < 1)
 249:	83 c4 10             	add    $0x10,%esp
 24c:	85 c0                	test   %eax,%eax
 24e:	7e 17                	jle    267 <gets+0x4d>
      break;
    buf[i++] = c;
 250:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 254:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 257:	3c 0a                	cmp    $0xa,%al
 259:	0f 94 c2             	sete   %dl
 25c:	3c 0d                	cmp    $0xd,%al
 25e:	0f 94 c0             	sete   %al
 261:	08 c2                	or     %al,%dl
 263:	74 ca                	je     22f <gets+0x15>
    buf[i++] = c;
 265:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 267:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 26b:	89 f8                	mov    %edi,%eax
 26d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5f                   	pop    %edi
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    

00000275 <stat>:

int
stat(const char *n, struct stat *st)
{
 275:	f3 0f 1e fb          	endbr32 
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	56                   	push   %esi
 27d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27e:	83 ec 08             	sub    $0x8,%esp
 281:	6a 00                	push   $0x0
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 dc 00 00 00       	call   367 <open>
  if(fd < 0)
 28b:	83 c4 10             	add    $0x10,%esp
 28e:	85 c0                	test   %eax,%eax
 290:	78 24                	js     2b6 <stat+0x41>
 292:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 294:	83 ec 08             	sub    $0x8,%esp
 297:	ff 75 0c             	pushl  0xc(%ebp)
 29a:	50                   	push   %eax
 29b:	e8 df 00 00 00       	call   37f <fstat>
 2a0:	89 c6                	mov    %eax,%esi
  close(fd);
 2a2:	89 1c 24             	mov    %ebx,(%esp)
 2a5:	e8 a5 00 00 00       	call   34f <close>
  return r;
 2aa:	83 c4 10             	add    $0x10,%esp
}
 2ad:	89 f0                	mov    %esi,%eax
 2af:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b2:	5b                   	pop    %ebx
 2b3:	5e                   	pop    %esi
 2b4:	5d                   	pop    %ebp
 2b5:	c3                   	ret    
    return -1;
 2b6:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2bb:	eb f0                	jmp    2ad <stat+0x38>

000002bd <atoi>:

int
atoi(const char *s)
{
 2bd:	f3 0f 1e fb          	endbr32 
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	53                   	push   %ebx
 2c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2c8:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2cd:	0f b6 01             	movzbl (%ecx),%eax
 2d0:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2d3:	80 fb 09             	cmp    $0x9,%bl
 2d6:	77 12                	ja     2ea <atoi+0x2d>
    n = n*10 + *s++ - '0';
 2d8:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 2db:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 2de:	83 c1 01             	add    $0x1,%ecx
 2e1:	0f be c0             	movsbl %al,%eax
 2e4:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 2e8:	eb e3                	jmp    2cd <atoi+0x10>
  return n;
}
 2ea:	89 d0                	mov    %edx,%eax
 2ec:	5b                   	pop    %ebx
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret    

000002ef <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ef:	f3 0f 1e fb          	endbr32 
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
 2f6:	56                   	push   %esi
 2f7:	53                   	push   %ebx
 2f8:	8b 75 08             	mov    0x8(%ebp),%esi
 2fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2fe:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 301:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 303:	8d 58 ff             	lea    -0x1(%eax),%ebx
 306:	85 c0                	test   %eax,%eax
 308:	7e 0f                	jle    319 <memmove+0x2a>
    *dst++ = *src++;
 30a:	0f b6 01             	movzbl (%ecx),%eax
 30d:	88 02                	mov    %al,(%edx)
 30f:	8d 49 01             	lea    0x1(%ecx),%ecx
 312:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 315:	89 d8                	mov    %ebx,%eax
 317:	eb ea                	jmp    303 <memmove+0x14>
  return vdst;
}
 319:	89 f0                	mov    %esi,%eax
 31b:	5b                   	pop    %ebx
 31c:	5e                   	pop    %esi
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    

0000031f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31f:	b8 01 00 00 00       	mov    $0x1,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <exit>:
SYSCALL(exit)
 327:	b8 02 00 00 00       	mov    $0x2,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <wait>:
SYSCALL(wait)
 32f:	b8 03 00 00 00       	mov    $0x3,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <pipe>:
SYSCALL(pipe)
 337:	b8 04 00 00 00       	mov    $0x4,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <read>:
SYSCALL(read)
 33f:	b8 05 00 00 00       	mov    $0x5,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <write>:
SYSCALL(write)
 347:	b8 10 00 00 00       	mov    $0x10,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <close>:
SYSCALL(close)
 34f:	b8 15 00 00 00       	mov    $0x15,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <kill>:
SYSCALL(kill)
 357:	b8 06 00 00 00       	mov    $0x6,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <exec>:
SYSCALL(exec)
 35f:	b8 07 00 00 00       	mov    $0x7,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <open>:
SYSCALL(open)
 367:	b8 0f 00 00 00       	mov    $0xf,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <mknod>:
SYSCALL(mknod)
 36f:	b8 11 00 00 00       	mov    $0x11,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <unlink>:
SYSCALL(unlink)
 377:	b8 12 00 00 00       	mov    $0x12,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <fstat>:
SYSCALL(fstat)
 37f:	b8 08 00 00 00       	mov    $0x8,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <link>:
SYSCALL(link)
 387:	b8 13 00 00 00       	mov    $0x13,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <mkdir>:
SYSCALL(mkdir)
 38f:	b8 14 00 00 00       	mov    $0x14,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <chdir>:
SYSCALL(chdir)
 397:	b8 09 00 00 00       	mov    $0x9,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <dup>:
SYSCALL(dup)
 39f:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <getpid>:
SYSCALL(getpid)
 3a7:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <sbrk>:
SYSCALL(sbrk)
 3af:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <sleep>:
SYSCALL(sleep)
 3b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <uptime>:
SYSCALL(uptime)
 3bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	83 ec 1c             	sub    $0x1c,%esp
 3cd:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3d0:	6a 01                	push   $0x1
 3d2:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3d5:	52                   	push   %edx
 3d6:	50                   	push   %eax
 3d7:	e8 6b ff ff ff       	call   347 <write>
}
 3dc:	83 c4 10             	add    $0x10,%esp
 3df:	c9                   	leave  
 3e0:	c3                   	ret    

000003e1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e1:	55                   	push   %ebp
 3e2:	89 e5                	mov    %esp,%ebp
 3e4:	57                   	push   %edi
 3e5:	56                   	push   %esi
 3e6:	53                   	push   %ebx
 3e7:	83 ec 2c             	sub    $0x2c,%esp
 3ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3ed:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3f3:	0f 95 c2             	setne  %dl
 3f6:	89 f0                	mov    %esi,%eax
 3f8:	c1 e8 1f             	shr    $0x1f,%eax
 3fb:	84 c2                	test   %al,%dl
 3fd:	74 42                	je     441 <printint+0x60>
    neg = 1;
    x = -xx;
 3ff:	f7 de                	neg    %esi
    neg = 1;
 401:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 408:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 40d:	89 f0                	mov    %esi,%eax
 40f:	ba 00 00 00 00       	mov    $0x0,%edx
 414:	f7 f1                	div    %ecx
 416:	89 df                	mov    %ebx,%edi
 418:	83 c3 01             	add    $0x1,%ebx
 41b:	0f b6 92 68 07 00 00 	movzbl 0x768(%edx),%edx
 422:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 426:	89 f2                	mov    %esi,%edx
 428:	89 c6                	mov    %eax,%esi
 42a:	39 d1                	cmp    %edx,%ecx
 42c:	76 df                	jbe    40d <printint+0x2c>
  if(neg)
 42e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 432:	74 2f                	je     463 <printint+0x82>
    buf[i++] = '-';
 434:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 439:	8d 5f 02             	lea    0x2(%edi),%ebx
 43c:	8b 75 d0             	mov    -0x30(%ebp),%esi
 43f:	eb 15                	jmp    456 <printint+0x75>
  neg = 0;
 441:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 448:	eb be                	jmp    408 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 44a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 44f:	89 f0                	mov    %esi,%eax
 451:	e8 71 ff ff ff       	call   3c7 <putc>
  while(--i >= 0)
 456:	83 eb 01             	sub    $0x1,%ebx
 459:	79 ef                	jns    44a <printint+0x69>
}
 45b:	83 c4 2c             	add    $0x2c,%esp
 45e:	5b                   	pop    %ebx
 45f:	5e                   	pop    %esi
 460:	5f                   	pop    %edi
 461:	5d                   	pop    %ebp
 462:	c3                   	ret    
 463:	8b 75 d0             	mov    -0x30(%ebp),%esi
 466:	eb ee                	jmp    456 <printint+0x75>

00000468 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 468:	f3 0f 1e fb          	endbr32 
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	57                   	push   %edi
 470:	56                   	push   %esi
 471:	53                   	push   %ebx
 472:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 475:	8d 45 10             	lea    0x10(%ebp),%eax
 478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 47b:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 480:	bb 00 00 00 00       	mov    $0x0,%ebx
 485:	eb 14                	jmp    49b <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 487:	89 fa                	mov    %edi,%edx
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	e8 36 ff ff ff       	call   3c7 <putc>
 491:	eb 05                	jmp    498 <printf+0x30>
      }
    } else if(state == '%'){
 493:	83 fe 25             	cmp    $0x25,%esi
 496:	74 25                	je     4bd <printf+0x55>
  for(i = 0; fmt[i]; i++){
 498:	83 c3 01             	add    $0x1,%ebx
 49b:	8b 45 0c             	mov    0xc(%ebp),%eax
 49e:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4a2:	84 c0                	test   %al,%al
 4a4:	0f 84 23 01 00 00    	je     5cd <printf+0x165>
    c = fmt[i] & 0xff;
 4aa:	0f be f8             	movsbl %al,%edi
 4ad:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4b0:	85 f6                	test   %esi,%esi
 4b2:	75 df                	jne    493 <printf+0x2b>
      if(c == '%'){
 4b4:	83 f8 25             	cmp    $0x25,%eax
 4b7:	75 ce                	jne    487 <printf+0x1f>
        state = '%';
 4b9:	89 c6                	mov    %eax,%esi
 4bb:	eb db                	jmp    498 <printf+0x30>
      if(c == 'd'){
 4bd:	83 f8 64             	cmp    $0x64,%eax
 4c0:	74 49                	je     50b <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c2:	83 f8 78             	cmp    $0x78,%eax
 4c5:	0f 94 c1             	sete   %cl
 4c8:	83 f8 70             	cmp    $0x70,%eax
 4cb:	0f 94 c2             	sete   %dl
 4ce:	08 d1                	or     %dl,%cl
 4d0:	75 63                	jne    535 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4d2:	83 f8 73             	cmp    $0x73,%eax
 4d5:	0f 84 84 00 00 00    	je     55f <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4db:	83 f8 63             	cmp    $0x63,%eax
 4de:	0f 84 b7 00 00 00    	je     59b <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4e4:	83 f8 25             	cmp    $0x25,%eax
 4e7:	0f 84 cc 00 00 00    	je     5b9 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ed:	ba 25 00 00 00       	mov    $0x25,%edx
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	e8 cd fe ff ff       	call   3c7 <putc>
        putc(fd, c);
 4fa:	89 fa                	mov    %edi,%edx
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
 4ff:	e8 c3 fe ff ff       	call   3c7 <putc>
      }
      state = 0;
 504:	be 00 00 00 00       	mov    $0x0,%esi
 509:	eb 8d                	jmp    498 <printf+0x30>
        printint(fd, *ap, 10, 1);
 50b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 50e:	8b 17                	mov    (%edi),%edx
 510:	83 ec 0c             	sub    $0xc,%esp
 513:	6a 01                	push   $0x1
 515:	b9 0a 00 00 00       	mov    $0xa,%ecx
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
 51d:	e8 bf fe ff ff       	call   3e1 <printint>
        ap++;
 522:	83 c7 04             	add    $0x4,%edi
 525:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 528:	83 c4 10             	add    $0x10,%esp
      state = 0;
 52b:	be 00 00 00 00       	mov    $0x0,%esi
 530:	e9 63 ff ff ff       	jmp    498 <printf+0x30>
        printint(fd, *ap, 16, 0);
 535:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 538:	8b 17                	mov    (%edi),%edx
 53a:	83 ec 0c             	sub    $0xc,%esp
 53d:	6a 00                	push   $0x0
 53f:	b9 10 00 00 00       	mov    $0x10,%ecx
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	e8 95 fe ff ff       	call   3e1 <printint>
        ap++;
 54c:	83 c7 04             	add    $0x4,%edi
 54f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 552:	83 c4 10             	add    $0x10,%esp
      state = 0;
 555:	be 00 00 00 00       	mov    $0x0,%esi
 55a:	e9 39 ff ff ff       	jmp    498 <printf+0x30>
        s = (char*)*ap;
 55f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 562:	8b 30                	mov    (%eax),%esi
        ap++;
 564:	83 c0 04             	add    $0x4,%eax
 567:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 56a:	85 f6                	test   %esi,%esi
 56c:	75 28                	jne    596 <printf+0x12e>
          s = "(null)";
 56e:	be 5f 07 00 00       	mov    $0x75f,%esi
 573:	8b 7d 08             	mov    0x8(%ebp),%edi
 576:	eb 0d                	jmp    585 <printf+0x11d>
          putc(fd, *s);
 578:	0f be d2             	movsbl %dl,%edx
 57b:	89 f8                	mov    %edi,%eax
 57d:	e8 45 fe ff ff       	call   3c7 <putc>
          s++;
 582:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 585:	0f b6 16             	movzbl (%esi),%edx
 588:	84 d2                	test   %dl,%dl
 58a:	75 ec                	jne    578 <printf+0x110>
      state = 0;
 58c:	be 00 00 00 00       	mov    $0x0,%esi
 591:	e9 02 ff ff ff       	jmp    498 <printf+0x30>
 596:	8b 7d 08             	mov    0x8(%ebp),%edi
 599:	eb ea                	jmp    585 <printf+0x11d>
        putc(fd, *ap);
 59b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 59e:	0f be 17             	movsbl (%edi),%edx
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	e8 1e fe ff ff       	call   3c7 <putc>
        ap++;
 5a9:	83 c7 04             	add    $0x4,%edi
 5ac:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5af:	be 00 00 00 00       	mov    $0x0,%esi
 5b4:	e9 df fe ff ff       	jmp    498 <printf+0x30>
        putc(fd, c);
 5b9:	89 fa                	mov    %edi,%edx
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
 5be:	e8 04 fe ff ff       	call   3c7 <putc>
      state = 0;
 5c3:	be 00 00 00 00       	mov    $0x0,%esi
 5c8:	e9 cb fe ff ff       	jmp    498 <printf+0x30>
    }
  }
}
 5cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d0:	5b                   	pop    %ebx
 5d1:	5e                   	pop    %esi
 5d2:	5f                   	pop    %edi
 5d3:	5d                   	pop    %ebp
 5d4:	c3                   	ret    

000005d5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d5:	f3 0f 1e fb          	endbr32 
 5d9:	55                   	push   %ebp
 5da:	89 e5                	mov    %esp,%ebp
 5dc:	57                   	push   %edi
 5dd:	56                   	push   %esi
 5de:	53                   	push   %ebx
 5df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e2:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e5:	a1 60 0a 00 00       	mov    0xa60,%eax
 5ea:	eb 02                	jmp    5ee <free+0x19>
 5ec:	89 d0                	mov    %edx,%eax
 5ee:	39 c8                	cmp    %ecx,%eax
 5f0:	73 04                	jae    5f6 <free+0x21>
 5f2:	39 08                	cmp    %ecx,(%eax)
 5f4:	77 12                	ja     608 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f6:	8b 10                	mov    (%eax),%edx
 5f8:	39 c2                	cmp    %eax,%edx
 5fa:	77 f0                	ja     5ec <free+0x17>
 5fc:	39 c8                	cmp    %ecx,%eax
 5fe:	72 08                	jb     608 <free+0x33>
 600:	39 ca                	cmp    %ecx,%edx
 602:	77 04                	ja     608 <free+0x33>
 604:	89 d0                	mov    %edx,%eax
 606:	eb e6                	jmp    5ee <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 608:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	8b 10                	mov    (%eax),%edx
 610:	39 d7                	cmp    %edx,%edi
 612:	74 19                	je     62d <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 614:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 617:	8b 50 04             	mov    0x4(%eax),%edx
 61a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61d:	39 ce                	cmp    %ecx,%esi
 61f:	74 1b                	je     63c <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 621:	89 08                	mov    %ecx,(%eax)
  freep = p;
 623:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 628:	5b                   	pop    %ebx
 629:	5e                   	pop    %esi
 62a:	5f                   	pop    %edi
 62b:	5d                   	pop    %ebp
 62c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 62d:	03 72 04             	add    0x4(%edx),%esi
 630:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 633:	8b 10                	mov    (%eax),%edx
 635:	8b 12                	mov    (%edx),%edx
 637:	89 53 f8             	mov    %edx,-0x8(%ebx)
 63a:	eb db                	jmp    617 <free+0x42>
    p->s.size += bp->s.size;
 63c:	03 53 fc             	add    -0x4(%ebx),%edx
 63f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 642:	8b 53 f8             	mov    -0x8(%ebx),%edx
 645:	89 10                	mov    %edx,(%eax)
 647:	eb da                	jmp    623 <free+0x4e>

00000649 <morecore>:

static Header*
morecore(uint nu)
{
 649:	55                   	push   %ebp
 64a:	89 e5                	mov    %esp,%ebp
 64c:	53                   	push   %ebx
 64d:	83 ec 04             	sub    $0x4,%esp
 650:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 652:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 657:	77 05                	ja     65e <morecore+0x15>
    nu = 4096;
 659:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 65e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 665:	83 ec 0c             	sub    $0xc,%esp
 668:	50                   	push   %eax
 669:	e8 41 fd ff ff       	call   3af <sbrk>
  if(p == (char*)-1)
 66e:	83 c4 10             	add    $0x10,%esp
 671:	83 f8 ff             	cmp    $0xffffffff,%eax
 674:	74 1c                	je     692 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 676:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 679:	83 c0 08             	add    $0x8,%eax
 67c:	83 ec 0c             	sub    $0xc,%esp
 67f:	50                   	push   %eax
 680:	e8 50 ff ff ff       	call   5d5 <free>
  return freep;
 685:	a1 60 0a 00 00       	mov    0xa60,%eax
 68a:	83 c4 10             	add    $0x10,%esp
}
 68d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 690:	c9                   	leave  
 691:	c3                   	ret    
    return 0;
 692:	b8 00 00 00 00       	mov    $0x0,%eax
 697:	eb f4                	jmp    68d <morecore+0x44>

00000699 <malloc>:

void*
malloc(uint nbytes)
{
 699:	f3 0f 1e fb          	endbr32 
 69d:	55                   	push   %ebp
 69e:	89 e5                	mov    %esp,%ebp
 6a0:	53                   	push   %ebx
 6a1:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	8d 58 07             	lea    0x7(%eax),%ebx
 6aa:	c1 eb 03             	shr    $0x3,%ebx
 6ad:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6b0:	8b 0d 60 0a 00 00    	mov    0xa60,%ecx
 6b6:	85 c9                	test   %ecx,%ecx
 6b8:	74 04                	je     6be <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ba:	8b 01                	mov    (%ecx),%eax
 6bc:	eb 4b                	jmp    709 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6be:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 6c5:	0a 00 00 
 6c8:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 6cf:	0a 00 00 
    base.s.size = 0;
 6d2:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 6d9:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6dc:	b9 64 0a 00 00       	mov    $0xa64,%ecx
 6e1:	eb d7                	jmp    6ba <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6e3:	74 1a                	je     6ff <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6e5:	29 da                	sub    %ebx,%edx
 6e7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6ea:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6ed:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6f0:	89 0d 60 0a 00 00    	mov    %ecx,0xa60
      return (void*)(p + 1);
 6f6:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6f9:	83 c4 04             	add    $0x4,%esp
 6fc:	5b                   	pop    %ebx
 6fd:	5d                   	pop    %ebp
 6fe:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6ff:	8b 10                	mov    (%eax),%edx
 701:	89 11                	mov    %edx,(%ecx)
 703:	eb eb                	jmp    6f0 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 705:	89 c1                	mov    %eax,%ecx
 707:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 709:	8b 50 04             	mov    0x4(%eax),%edx
 70c:	39 da                	cmp    %ebx,%edx
 70e:	73 d3                	jae    6e3 <malloc+0x4a>
    if(p == freep)
 710:	39 05 60 0a 00 00    	cmp    %eax,0xa60
 716:	75 ed                	jne    705 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 718:	89 d8                	mov    %ebx,%eax
 71a:	e8 2a ff ff ff       	call   649 <morecore>
 71f:	85 c0                	test   %eax,%eax
 721:	75 e2                	jne    705 <malloc+0x6c>
 723:	eb d4                	jmp    6f9 <malloc+0x60>
