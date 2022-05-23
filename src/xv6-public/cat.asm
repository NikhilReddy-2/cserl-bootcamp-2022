
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	68 00 02 00 00       	push   $0x200
  14:	68 00 0a 00 00       	push   $0xa00
  19:	56                   	push   %esi
  1a:	e8 b6 02 00 00       	call   2d5 <read>
  1f:	89 c3                	mov    %eax,%ebx
  21:	83 c4 10             	add    $0x10,%esp
  24:	85 c0                	test   %eax,%eax
  26:	7e 2b                	jle    53 <cat+0x53>
    if (write(1, buf, n) != n) {
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	53                   	push   %ebx
  2c:	68 00 0a 00 00       	push   $0xa00
  31:	6a 01                	push   $0x1
  33:	e8 a5 02 00 00       	call   2dd <write>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 d8                	cmp    %ebx,%eax
  3d:	74 cd                	je     c <cat+0xc>
      printf(1, "cat: write error\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 bc 06 00 00       	push   $0x6bc
  47:	6a 01                	push   $0x1
  49:	e8 b0 03 00 00       	call   3fe <printf>
      exit();
  4e:	e8 6a 02 00 00       	call   2bd <exit>
    }
  }
  if(n < 0){
  53:	78 07                	js     5c <cat+0x5c>
    printf(1, "cat: read error\n");
    exit();
  }
}
  55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  58:	5b                   	pop    %ebx
  59:	5e                   	pop    %esi
  5a:	5d                   	pop    %ebp
  5b:	c3                   	ret    
    printf(1, "cat: read error\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 ce 06 00 00       	push   $0x6ce
  64:	6a 01                	push   $0x1
  66:	e8 93 03 00 00       	call   3fe <printf>
    exit();
  6b:	e8 4d 02 00 00       	call   2bd <exit>

00000070 <main>:

int
main(int argc, char *argv[])
{
  70:	f3 0f 1e fb          	endbr32 
  74:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  78:	83 e4 f0             	and    $0xfffffff0,%esp
  7b:	ff 71 fc             	pushl  -0x4(%ecx)
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	57                   	push   %edi
  82:	56                   	push   %esi
  83:	53                   	push   %ebx
  84:	51                   	push   %ecx
  85:	83 ec 18             	sub    $0x18,%esp
  88:	8b 01                	mov    (%ecx),%eax
  8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8d:	8b 51 04             	mov    0x4(%ecx),%edx
  90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  93:	83 f8 01             	cmp    $0x1,%eax
  96:	7e 3e                	jle    d6 <main+0x66>
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  98:	be 01 00 00 00       	mov    $0x1,%esi
  9d:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  a0:	7d 59                	jge    fb <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
  a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a5:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	6a 00                	push   $0x0
  ad:	ff 37                	pushl  (%edi)
  af:	e8 49 02 00 00       	call   2fd <open>
  b4:	89 c3                	mov    %eax,%ebx
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	85 c0                	test   %eax,%eax
  bb:	78 28                	js     e5 <main+0x75>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	50                   	push   %eax
  c1:	e8 3a ff ff ff       	call   0 <cat>
    close(fd);
  c6:	89 1c 24             	mov    %ebx,(%esp)
  c9:	e8 17 02 00 00       	call   2e5 <close>
  for(i = 1; i < argc; i++){
  ce:	83 c6 01             	add    $0x1,%esi
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	eb c7                	jmp    9d <main+0x2d>
    cat(0);
  d6:	83 ec 0c             	sub    $0xc,%esp
  d9:	6a 00                	push   $0x0
  db:	e8 20 ff ff ff       	call   0 <cat>
    exit();
  e0:	e8 d8 01 00 00       	call   2bd <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e5:	83 ec 04             	sub    $0x4,%esp
  e8:	ff 37                	pushl  (%edi)
  ea:	68 df 06 00 00       	push   $0x6df
  ef:	6a 01                	push   $0x1
  f1:	e8 08 03 00 00       	call   3fe <printf>
      exit();
  f6:	e8 c2 01 00 00       	call   2bd <exit>
  }
  exit();
  fb:	e8 bd 01 00 00       	call   2bd <exit>

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	56                   	push   %esi
 108:	53                   	push   %ebx
 109:	8b 75 08             	mov    0x8(%ebp),%esi
 10c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10f:	89 f0                	mov    %esi,%eax
 111:	89 d1                	mov    %edx,%ecx
 113:	83 c2 01             	add    $0x1,%edx
 116:	89 c3                	mov    %eax,%ebx
 118:	83 c0 01             	add    $0x1,%eax
 11b:	0f b6 09             	movzbl (%ecx),%ecx
 11e:	88 0b                	mov    %cl,(%ebx)
 120:	84 c9                	test   %cl,%cl
 122:	75 ed                	jne    111 <strcpy+0x11>
    ;
  return os;
}
 124:	89 f0                	mov    %esi,%eax
 126:	5b                   	pop    %ebx
 127:	5e                   	pop    %esi
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    

0000012a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12a:	f3 0f 1e fb          	endbr32 
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	8b 4d 08             	mov    0x8(%ebp),%ecx
 134:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 137:	0f b6 01             	movzbl (%ecx),%eax
 13a:	84 c0                	test   %al,%al
 13c:	74 0c                	je     14a <strcmp+0x20>
 13e:	3a 02                	cmp    (%edx),%al
 140:	75 08                	jne    14a <strcmp+0x20>
    p++, q++;
 142:	83 c1 01             	add    $0x1,%ecx
 145:	83 c2 01             	add    $0x1,%edx
 148:	eb ed                	jmp    137 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 14a:	0f b6 c0             	movzbl %al,%eax
 14d:	0f b6 12             	movzbl (%edx),%edx
 150:	29 d0                	sub    %edx,%eax
}
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    

00000154 <strlen>:

uint
strlen(const char *s)
{
 154:	f3 0f 1e fb          	endbr32 
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 15e:	b8 00 00 00 00       	mov    $0x0,%eax
 163:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 167:	74 05                	je     16e <strlen+0x1a>
 169:	83 c0 01             	add    $0x1,%eax
 16c:	eb f5                	jmp    163 <strlen+0xf>
    ;
  return n;
}
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	57                   	push   %edi
 178:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 17b:	89 d7                	mov    %edx,%edi
 17d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	fc                   	cld    
 184:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 186:	89 d0                	mov    %edx,%eax
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    

0000018b <strchr>:

char*
strchr(const char *s, char c)
{
 18b:	f3 0f 1e fb          	endbr32 
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	8b 45 08             	mov    0x8(%ebp),%eax
 195:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 199:	0f b6 10             	movzbl (%eax),%edx
 19c:	84 d2                	test   %dl,%dl
 19e:	74 09                	je     1a9 <strchr+0x1e>
    if(*s == c)
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 0a                	je     1ae <strchr+0x23>
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	eb f0                	jmp    199 <strchr+0xe>
      return (char*)s;
  return 0;
 1a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ae:	5d                   	pop    %ebp
 1af:	c3                   	ret    

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	83 ec 1c             	sub    $0x1c,%esp
 1bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	bb 00 00 00 00       	mov    $0x0,%ebx
 1c5:	89 de                	mov    %ebx,%esi
 1c7:	83 c3 01             	add    $0x1,%ebx
 1ca:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cd:	7d 2e                	jge    1fd <gets+0x4d>
    cc = read(0, &c, 1);
 1cf:	83 ec 04             	sub    $0x4,%esp
 1d2:	6a 01                	push   $0x1
 1d4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1d7:	50                   	push   %eax
 1d8:	6a 00                	push   $0x0
 1da:	e8 f6 00 00 00       	call   2d5 <read>
    if(cc < 1)
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	85 c0                	test   %eax,%eax
 1e4:	7e 17                	jle    1fd <gets+0x4d>
      break;
    buf[i++] = c;
 1e6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ea:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1ed:	3c 0a                	cmp    $0xa,%al
 1ef:	0f 94 c2             	sete   %dl
 1f2:	3c 0d                	cmp    $0xd,%al
 1f4:	0f 94 c0             	sete   %al
 1f7:	08 c2                	or     %al,%dl
 1f9:	74 ca                	je     1c5 <gets+0x15>
    buf[i++] = c;
 1fb:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1fd:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 201:	89 f8                	mov    %edi,%eax
 203:	8d 65 f4             	lea    -0xc(%ebp),%esp
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5f                   	pop    %edi
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    

0000020b <stat>:

int
stat(const char *n, struct stat *st)
{
 20b:	f3 0f 1e fb          	endbr32 
 20f:	55                   	push   %ebp
 210:	89 e5                	mov    %esp,%ebp
 212:	56                   	push   %esi
 213:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 214:	83 ec 08             	sub    $0x8,%esp
 217:	6a 00                	push   $0x0
 219:	ff 75 08             	pushl  0x8(%ebp)
 21c:	e8 dc 00 00 00       	call   2fd <open>
  if(fd < 0)
 221:	83 c4 10             	add    $0x10,%esp
 224:	85 c0                	test   %eax,%eax
 226:	78 24                	js     24c <stat+0x41>
 228:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22a:	83 ec 08             	sub    $0x8,%esp
 22d:	ff 75 0c             	pushl  0xc(%ebp)
 230:	50                   	push   %eax
 231:	e8 df 00 00 00       	call   315 <fstat>
 236:	89 c6                	mov    %eax,%esi
  close(fd);
 238:	89 1c 24             	mov    %ebx,(%esp)
 23b:	e8 a5 00 00 00       	call   2e5 <close>
  return r;
 240:	83 c4 10             	add    $0x10,%esp
}
 243:	89 f0                	mov    %esi,%eax
 245:	8d 65 f8             	lea    -0x8(%ebp),%esp
 248:	5b                   	pop    %ebx
 249:	5e                   	pop    %esi
 24a:	5d                   	pop    %ebp
 24b:	c3                   	ret    
    return -1;
 24c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 251:	eb f0                	jmp    243 <stat+0x38>

00000253 <atoi>:

int
atoi(const char *s)
{
 253:	f3 0f 1e fb          	endbr32 
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	53                   	push   %ebx
 25b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 25e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 263:	0f b6 01             	movzbl (%ecx),%eax
 266:	8d 58 d0             	lea    -0x30(%eax),%ebx
 269:	80 fb 09             	cmp    $0x9,%bl
 26c:	77 12                	ja     280 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 26e:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 271:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 274:	83 c1 01             	add    $0x1,%ecx
 277:	0f be c0             	movsbl %al,%eax
 27a:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 27e:	eb e3                	jmp    263 <atoi+0x10>
  return n;
}
 280:	89 d0                	mov    %edx,%eax
 282:	5b                   	pop    %ebx
 283:	5d                   	pop    %ebp
 284:	c3                   	ret    

00000285 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 285:	f3 0f 1e fb          	endbr32 
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	56                   	push   %esi
 28d:	53                   	push   %ebx
 28e:	8b 75 08             	mov    0x8(%ebp),%esi
 291:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 294:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 297:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 299:	8d 58 ff             	lea    -0x1(%eax),%ebx
 29c:	85 c0                	test   %eax,%eax
 29e:	7e 0f                	jle    2af <memmove+0x2a>
    *dst++ = *src++;
 2a0:	0f b6 01             	movzbl (%ecx),%eax
 2a3:	88 02                	mov    %al,(%edx)
 2a5:	8d 49 01             	lea    0x1(%ecx),%ecx
 2a8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2ab:	89 d8                	mov    %ebx,%eax
 2ad:	eb ea                	jmp    299 <memmove+0x14>
  return vdst;
}
 2af:	89 f0                	mov    %esi,%eax
 2b1:	5b                   	pop    %ebx
 2b2:	5e                   	pop    %esi
 2b3:	5d                   	pop    %ebp
 2b4:	c3                   	ret    

000002b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b5:	b8 01 00 00 00       	mov    $0x1,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <exit>:
SYSCALL(exit)
 2bd:	b8 02 00 00 00       	mov    $0x2,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <wait>:
SYSCALL(wait)
 2c5:	b8 03 00 00 00       	mov    $0x3,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <pipe>:
SYSCALL(pipe)
 2cd:	b8 04 00 00 00       	mov    $0x4,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <read>:
SYSCALL(read)
 2d5:	b8 05 00 00 00       	mov    $0x5,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <write>:
SYSCALL(write)
 2dd:	b8 10 00 00 00       	mov    $0x10,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <close>:
SYSCALL(close)
 2e5:	b8 15 00 00 00       	mov    $0x15,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <kill>:
SYSCALL(kill)
 2ed:	b8 06 00 00 00       	mov    $0x6,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <exec>:
SYSCALL(exec)
 2f5:	b8 07 00 00 00       	mov    $0x7,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <open>:
SYSCALL(open)
 2fd:	b8 0f 00 00 00       	mov    $0xf,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <mknod>:
SYSCALL(mknod)
 305:	b8 11 00 00 00       	mov    $0x11,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <unlink>:
SYSCALL(unlink)
 30d:	b8 12 00 00 00       	mov    $0x12,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <fstat>:
SYSCALL(fstat)
 315:	b8 08 00 00 00       	mov    $0x8,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <link>:
SYSCALL(link)
 31d:	b8 13 00 00 00       	mov    $0x13,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <mkdir>:
SYSCALL(mkdir)
 325:	b8 14 00 00 00       	mov    $0x14,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <chdir>:
SYSCALL(chdir)
 32d:	b8 09 00 00 00       	mov    $0x9,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <dup>:
SYSCALL(dup)
 335:	b8 0a 00 00 00       	mov    $0xa,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <getpid>:
SYSCALL(getpid)
 33d:	b8 0b 00 00 00       	mov    $0xb,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <sbrk>:
SYSCALL(sbrk)
 345:	b8 0c 00 00 00       	mov    $0xc,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <sleep>:
SYSCALL(sleep)
 34d:	b8 0d 00 00 00       	mov    $0xd,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <uptime>:
SYSCALL(uptime)
 355:	b8 0e 00 00 00       	mov    $0xe,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 1c             	sub    $0x1c,%esp
 363:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 366:	6a 01                	push   $0x1
 368:	8d 55 f4             	lea    -0xc(%ebp),%edx
 36b:	52                   	push   %edx
 36c:	50                   	push   %eax
 36d:	e8 6b ff ff ff       	call   2dd <write>
}
 372:	83 c4 10             	add    $0x10,%esp
 375:	c9                   	leave  
 376:	c3                   	ret    

00000377 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	57                   	push   %edi
 37b:	56                   	push   %esi
 37c:	53                   	push   %ebx
 37d:	83 ec 2c             	sub    $0x2c,%esp
 380:	89 45 d0             	mov    %eax,-0x30(%ebp)
 383:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 385:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 389:	0f 95 c2             	setne  %dl
 38c:	89 f0                	mov    %esi,%eax
 38e:	c1 e8 1f             	shr    $0x1f,%eax
 391:	84 c2                	test   %al,%dl
 393:	74 42                	je     3d7 <printint+0x60>
    neg = 1;
    x = -xx;
 395:	f7 de                	neg    %esi
    neg = 1;
 397:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 39e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3a3:	89 f0                	mov    %esi,%eax
 3a5:	ba 00 00 00 00       	mov    $0x0,%edx
 3aa:	f7 f1                	div    %ecx
 3ac:	89 df                	mov    %ebx,%edi
 3ae:	83 c3 01             	add    $0x1,%ebx
 3b1:	0f b6 92 fc 06 00 00 	movzbl 0x6fc(%edx),%edx
 3b8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3bc:	89 f2                	mov    %esi,%edx
 3be:	89 c6                	mov    %eax,%esi
 3c0:	39 d1                	cmp    %edx,%ecx
 3c2:	76 df                	jbe    3a3 <printint+0x2c>
  if(neg)
 3c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3c8:	74 2f                	je     3f9 <printint+0x82>
    buf[i++] = '-';
 3ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3cf:	8d 5f 02             	lea    0x2(%edi),%ebx
 3d2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3d5:	eb 15                	jmp    3ec <printint+0x75>
  neg = 0;
 3d7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3de:	eb be                	jmp    39e <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 3e0:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3e5:	89 f0                	mov    %esi,%eax
 3e7:	e8 71 ff ff ff       	call   35d <putc>
  while(--i >= 0)
 3ec:	83 eb 01             	sub    $0x1,%ebx
 3ef:	79 ef                	jns    3e0 <printint+0x69>
}
 3f1:	83 c4 2c             	add    $0x2c,%esp
 3f4:	5b                   	pop    %ebx
 3f5:	5e                   	pop    %esi
 3f6:	5f                   	pop    %edi
 3f7:	5d                   	pop    %ebp
 3f8:	c3                   	ret    
 3f9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3fc:	eb ee                	jmp    3ec <printint+0x75>

000003fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3fe:	f3 0f 1e fb          	endbr32 
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	57                   	push   %edi
 406:	56                   	push   %esi
 407:	53                   	push   %ebx
 408:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 40b:	8d 45 10             	lea    0x10(%ebp),%eax
 40e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 411:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 416:	bb 00 00 00 00       	mov    $0x0,%ebx
 41b:	eb 14                	jmp    431 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 41d:	89 fa                	mov    %edi,%edx
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	e8 36 ff ff ff       	call   35d <putc>
 427:	eb 05                	jmp    42e <printf+0x30>
      }
    } else if(state == '%'){
 429:	83 fe 25             	cmp    $0x25,%esi
 42c:	74 25                	je     453 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 42e:	83 c3 01             	add    $0x1,%ebx
 431:	8b 45 0c             	mov    0xc(%ebp),%eax
 434:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 438:	84 c0                	test   %al,%al
 43a:	0f 84 23 01 00 00    	je     563 <printf+0x165>
    c = fmt[i] & 0xff;
 440:	0f be f8             	movsbl %al,%edi
 443:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 446:	85 f6                	test   %esi,%esi
 448:	75 df                	jne    429 <printf+0x2b>
      if(c == '%'){
 44a:	83 f8 25             	cmp    $0x25,%eax
 44d:	75 ce                	jne    41d <printf+0x1f>
        state = '%';
 44f:	89 c6                	mov    %eax,%esi
 451:	eb db                	jmp    42e <printf+0x30>
      if(c == 'd'){
 453:	83 f8 64             	cmp    $0x64,%eax
 456:	74 49                	je     4a1 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 458:	83 f8 78             	cmp    $0x78,%eax
 45b:	0f 94 c1             	sete   %cl
 45e:	83 f8 70             	cmp    $0x70,%eax
 461:	0f 94 c2             	sete   %dl
 464:	08 d1                	or     %dl,%cl
 466:	75 63                	jne    4cb <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 468:	83 f8 73             	cmp    $0x73,%eax
 46b:	0f 84 84 00 00 00    	je     4f5 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 471:	83 f8 63             	cmp    $0x63,%eax
 474:	0f 84 b7 00 00 00    	je     531 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 47a:	83 f8 25             	cmp    $0x25,%eax
 47d:	0f 84 cc 00 00 00    	je     54f <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 483:	ba 25 00 00 00       	mov    $0x25,%edx
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	e8 cd fe ff ff       	call   35d <putc>
        putc(fd, c);
 490:	89 fa                	mov    %edi,%edx
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	e8 c3 fe ff ff       	call   35d <putc>
      }
      state = 0;
 49a:	be 00 00 00 00       	mov    $0x0,%esi
 49f:	eb 8d                	jmp    42e <printf+0x30>
        printint(fd, *ap, 10, 1);
 4a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a4:	8b 17                	mov    (%edi),%edx
 4a6:	83 ec 0c             	sub    $0xc,%esp
 4a9:	6a 01                	push   $0x1
 4ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	e8 bf fe ff ff       	call   377 <printint>
        ap++;
 4b8:	83 c7 04             	add    $0x4,%edi
 4bb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4be:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c1:	be 00 00 00 00       	mov    $0x0,%esi
 4c6:	e9 63 ff ff ff       	jmp    42e <printf+0x30>
        printint(fd, *ap, 16, 0);
 4cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ce:	8b 17                	mov    (%edi),%edx
 4d0:	83 ec 0c             	sub    $0xc,%esp
 4d3:	6a 00                	push   $0x0
 4d5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	e8 95 fe ff ff       	call   377 <printint>
        ap++;
 4e2:	83 c7 04             	add    $0x4,%edi
 4e5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4eb:	be 00 00 00 00       	mov    $0x0,%esi
 4f0:	e9 39 ff ff ff       	jmp    42e <printf+0x30>
        s = (char*)*ap;
 4f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f8:	8b 30                	mov    (%eax),%esi
        ap++;
 4fa:	83 c0 04             	add    $0x4,%eax
 4fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 500:	85 f6                	test   %esi,%esi
 502:	75 28                	jne    52c <printf+0x12e>
          s = "(null)";
 504:	be f4 06 00 00       	mov    $0x6f4,%esi
 509:	8b 7d 08             	mov    0x8(%ebp),%edi
 50c:	eb 0d                	jmp    51b <printf+0x11d>
          putc(fd, *s);
 50e:	0f be d2             	movsbl %dl,%edx
 511:	89 f8                	mov    %edi,%eax
 513:	e8 45 fe ff ff       	call   35d <putc>
          s++;
 518:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 51b:	0f b6 16             	movzbl (%esi),%edx
 51e:	84 d2                	test   %dl,%dl
 520:	75 ec                	jne    50e <printf+0x110>
      state = 0;
 522:	be 00 00 00 00       	mov    $0x0,%esi
 527:	e9 02 ff ff ff       	jmp    42e <printf+0x30>
 52c:	8b 7d 08             	mov    0x8(%ebp),%edi
 52f:	eb ea                	jmp    51b <printf+0x11d>
        putc(fd, *ap);
 531:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 534:	0f be 17             	movsbl (%edi),%edx
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	e8 1e fe ff ff       	call   35d <putc>
        ap++;
 53f:	83 c7 04             	add    $0x4,%edi
 542:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 545:	be 00 00 00 00       	mov    $0x0,%esi
 54a:	e9 df fe ff ff       	jmp    42e <printf+0x30>
        putc(fd, c);
 54f:	89 fa                	mov    %edi,%edx
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	e8 04 fe ff ff       	call   35d <putc>
      state = 0;
 559:	be 00 00 00 00       	mov    $0x0,%esi
 55e:	e9 cb fe ff ff       	jmp    42e <printf+0x30>
    }
  }
}
 563:	8d 65 f4             	lea    -0xc(%ebp),%esp
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5f                   	pop    %edi
 569:	5d                   	pop    %ebp
 56a:	c3                   	ret    

0000056b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 56b:	f3 0f 1e fb          	endbr32 
 56f:	55                   	push   %ebp
 570:	89 e5                	mov    %esp,%ebp
 572:	57                   	push   %edi
 573:	56                   	push   %esi
 574:	53                   	push   %ebx
 575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 578:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 57b:	a1 e0 09 00 00       	mov    0x9e0,%eax
 580:	eb 02                	jmp    584 <free+0x19>
 582:	89 d0                	mov    %edx,%eax
 584:	39 c8                	cmp    %ecx,%eax
 586:	73 04                	jae    58c <free+0x21>
 588:	39 08                	cmp    %ecx,(%eax)
 58a:	77 12                	ja     59e <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58c:	8b 10                	mov    (%eax),%edx
 58e:	39 c2                	cmp    %eax,%edx
 590:	77 f0                	ja     582 <free+0x17>
 592:	39 c8                	cmp    %ecx,%eax
 594:	72 08                	jb     59e <free+0x33>
 596:	39 ca                	cmp    %ecx,%edx
 598:	77 04                	ja     59e <free+0x33>
 59a:	89 d0                	mov    %edx,%eax
 59c:	eb e6                	jmp    584 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 59e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5a4:	8b 10                	mov    (%eax),%edx
 5a6:	39 d7                	cmp    %edx,%edi
 5a8:	74 19                	je     5c3 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ad:	8b 50 04             	mov    0x4(%eax),%edx
 5b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b3:	39 ce                	cmp    %ecx,%esi
 5b5:	74 1b                	je     5d2 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5b7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5b9:	a3 e0 09 00 00       	mov    %eax,0x9e0
}
 5be:	5b                   	pop    %ebx
 5bf:	5e                   	pop    %esi
 5c0:	5f                   	pop    %edi
 5c1:	5d                   	pop    %ebp
 5c2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5c3:	03 72 04             	add    0x4(%edx),%esi
 5c6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5c9:	8b 10                	mov    (%eax),%edx
 5cb:	8b 12                	mov    (%edx),%edx
 5cd:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5d0:	eb db                	jmp    5ad <free+0x42>
    p->s.size += bp->s.size;
 5d2:	03 53 fc             	add    -0x4(%ebx),%edx
 5d5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5d8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5db:	89 10                	mov    %edx,(%eax)
 5dd:	eb da                	jmp    5b9 <free+0x4e>

000005df <morecore>:

static Header*
morecore(uint nu)
{
 5df:	55                   	push   %ebp
 5e0:	89 e5                	mov    %esp,%ebp
 5e2:	53                   	push   %ebx
 5e3:	83 ec 04             	sub    $0x4,%esp
 5e6:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5e8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5ed:	77 05                	ja     5f4 <morecore+0x15>
    nu = 4096;
 5ef:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5f4:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5fb:	83 ec 0c             	sub    $0xc,%esp
 5fe:	50                   	push   %eax
 5ff:	e8 41 fd ff ff       	call   345 <sbrk>
  if(p == (char*)-1)
 604:	83 c4 10             	add    $0x10,%esp
 607:	83 f8 ff             	cmp    $0xffffffff,%eax
 60a:	74 1c                	je     628 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 60c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 60f:	83 c0 08             	add    $0x8,%eax
 612:	83 ec 0c             	sub    $0xc,%esp
 615:	50                   	push   %eax
 616:	e8 50 ff ff ff       	call   56b <free>
  return freep;
 61b:	a1 e0 09 00 00       	mov    0x9e0,%eax
 620:	83 c4 10             	add    $0x10,%esp
}
 623:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 626:	c9                   	leave  
 627:	c3                   	ret    
    return 0;
 628:	b8 00 00 00 00       	mov    $0x0,%eax
 62d:	eb f4                	jmp    623 <morecore+0x44>

0000062f <malloc>:

void*
malloc(uint nbytes)
{
 62f:	f3 0f 1e fb          	endbr32 
 633:	55                   	push   %ebp
 634:	89 e5                	mov    %esp,%ebp
 636:	53                   	push   %ebx
 637:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 63a:	8b 45 08             	mov    0x8(%ebp),%eax
 63d:	8d 58 07             	lea    0x7(%eax),%ebx
 640:	c1 eb 03             	shr    $0x3,%ebx
 643:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 646:	8b 0d e0 09 00 00    	mov    0x9e0,%ecx
 64c:	85 c9                	test   %ecx,%ecx
 64e:	74 04                	je     654 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 650:	8b 01                	mov    (%ecx),%eax
 652:	eb 4b                	jmp    69f <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 654:	c7 05 e0 09 00 00 e4 	movl   $0x9e4,0x9e0
 65b:	09 00 00 
 65e:	c7 05 e4 09 00 00 e4 	movl   $0x9e4,0x9e4
 665:	09 00 00 
    base.s.size = 0;
 668:	c7 05 e8 09 00 00 00 	movl   $0x0,0x9e8
 66f:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 672:	b9 e4 09 00 00       	mov    $0x9e4,%ecx
 677:	eb d7                	jmp    650 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 679:	74 1a                	je     695 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 67b:	29 da                	sub    %ebx,%edx
 67d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 680:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 683:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 686:	89 0d e0 09 00 00    	mov    %ecx,0x9e0
      return (void*)(p + 1);
 68c:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 68f:	83 c4 04             	add    $0x4,%esp
 692:	5b                   	pop    %ebx
 693:	5d                   	pop    %ebp
 694:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 695:	8b 10                	mov    (%eax),%edx
 697:	89 11                	mov    %edx,(%ecx)
 699:	eb eb                	jmp    686 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69b:	89 c1                	mov    %eax,%ecx
 69d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 69f:	8b 50 04             	mov    0x4(%eax),%edx
 6a2:	39 da                	cmp    %ebx,%edx
 6a4:	73 d3                	jae    679 <malloc+0x4a>
    if(p == freep)
 6a6:	39 05 e0 09 00 00    	cmp    %eax,0x9e0
 6ac:	75 ed                	jne    69b <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 6ae:	89 d8                	mov    %ebx,%eax
 6b0:	e8 2a ff ff ff       	call   5df <morecore>
 6b5:	85 c0                	test   %eax,%eax
 6b7:	75 e2                	jne    69b <malloc+0x6c>
 6b9:	eb d4                	jmp    68f <malloc+0x60>
