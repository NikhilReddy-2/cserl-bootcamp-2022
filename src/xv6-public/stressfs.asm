
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
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
  14:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  1a:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  21:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  28:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2e:	68 dc 06 00 00       	push   $0x6dc
  33:	6a 01                	push   $0x1
  35:	e8 e4 03 00 00       	call   41e <printf>
  memset(data, 'a', sizeof(data));
  3a:	83 c4 0c             	add    $0xc,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 40 01 00 00       	call   190 <memset>

  for(i = 0; i < 4; i++)
  50:	83 c4 10             	add    $0x10,%esp
  53:	bb 00 00 00 00       	mov    $0x0,%ebx
  58:	83 fb 03             	cmp    $0x3,%ebx
  5b:	7f 0e                	jg     6b <main+0x6b>
    if(fork() > 0)
  5d:	e8 73 02 00 00       	call   2d5 <fork>
  62:	85 c0                	test   %eax,%eax
  64:	7f 05                	jg     6b <main+0x6b>
  for(i = 0; i < 4; i++)
  66:	83 c3 01             	add    $0x1,%ebx
  69:	eb ed                	jmp    58 <main+0x58>
      break;

  printf(1, "write %d\n", i);
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	53                   	push   %ebx
  6f:	68 ef 06 00 00       	push   $0x6ef
  74:	6a 01                	push   $0x1
  76:	e8 a3 03 00 00       	call   41e <printf>

  path[8] += i;
  7b:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  7e:	83 c4 08             	add    $0x8,%esp
  81:	68 02 02 00 00       	push   $0x202
  86:	8d 45 de             	lea    -0x22(%ebp),%eax
  89:	50                   	push   %eax
  8a:	e8 8e 02 00 00       	call   31d <open>
  8f:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  91:	83 c4 10             	add    $0x10,%esp
  94:	bb 00 00 00 00       	mov    $0x0,%ebx
  99:	eb 1b                	jmp    b6 <main+0xb6>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  9b:	83 ec 04             	sub    $0x4,%esp
  9e:	68 00 02 00 00       	push   $0x200
  a3:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  a9:	50                   	push   %eax
  aa:	56                   	push   %esi
  ab:	e8 4d 02 00 00       	call   2fd <write>
  for(i = 0; i < 20; i++)
  b0:	83 c3 01             	add    $0x1,%ebx
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	83 fb 13             	cmp    $0x13,%ebx
  b9:	7e e0                	jle    9b <main+0x9b>
  close(fd);
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	56                   	push   %esi
  bf:	e8 41 02 00 00       	call   305 <close>

  printf(1, "read\n");
  c4:	83 c4 08             	add    $0x8,%esp
  c7:	68 f9 06 00 00       	push   $0x6f9
  cc:	6a 01                	push   $0x1
  ce:	e8 4b 03 00 00       	call   41e <printf>

  fd = open(path, O_RDONLY);
  d3:	83 c4 08             	add    $0x8,%esp
  d6:	6a 00                	push   $0x0
  d8:	8d 45 de             	lea    -0x22(%ebp),%eax
  db:	50                   	push   %eax
  dc:	e8 3c 02 00 00       	call   31d <open>
  e1:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  eb:	eb 1b                	jmp    108 <main+0x108>
    read(fd, data, sizeof(data));
  ed:	83 ec 04             	sub    $0x4,%esp
  f0:	68 00 02 00 00       	push   $0x200
  f5:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  fb:	50                   	push   %eax
  fc:	56                   	push   %esi
  fd:	e8 f3 01 00 00       	call   2f5 <read>
  for (i = 0; i < 20; i++)
 102:	83 c3 01             	add    $0x1,%ebx
 105:	83 c4 10             	add    $0x10,%esp
 108:	83 fb 13             	cmp    $0x13,%ebx
 10b:	7e e0                	jle    ed <main+0xed>
  close(fd);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	56                   	push   %esi
 111:	e8 ef 01 00 00       	call   305 <close>

  wait();
 116:	e8 ca 01 00 00       	call   2e5 <wait>

  exit();
 11b:	e8 bd 01 00 00       	call   2dd <exit>

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	56                   	push   %esi
 128:	53                   	push   %ebx
 129:	8b 75 08             	mov    0x8(%ebp),%esi
 12c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12f:	89 f0                	mov    %esi,%eax
 131:	89 d1                	mov    %edx,%ecx
 133:	83 c2 01             	add    $0x1,%edx
 136:	89 c3                	mov    %eax,%ebx
 138:	83 c0 01             	add    $0x1,%eax
 13b:	0f b6 09             	movzbl (%ecx),%ecx
 13e:	88 0b                	mov    %cl,(%ebx)
 140:	84 c9                	test   %cl,%cl
 142:	75 ed                	jne    131 <strcpy+0x11>
    ;
  return os;
}
 144:	89 f0                	mov    %esi,%eax
 146:	5b                   	pop    %ebx
 147:	5e                   	pop    %esi
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    

0000014a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14a:	f3 0f 1e fb          	endbr32 
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	8b 4d 08             	mov    0x8(%ebp),%ecx
 154:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 157:	0f b6 01             	movzbl (%ecx),%eax
 15a:	84 c0                	test   %al,%al
 15c:	74 0c                	je     16a <strcmp+0x20>
 15e:	3a 02                	cmp    (%edx),%al
 160:	75 08                	jne    16a <strcmp+0x20>
    p++, q++;
 162:	83 c1 01             	add    $0x1,%ecx
 165:	83 c2 01             	add    $0x1,%edx
 168:	eb ed                	jmp    157 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 16a:	0f b6 c0             	movzbl %al,%eax
 16d:	0f b6 12             	movzbl (%edx),%edx
 170:	29 d0                	sub    %edx,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    

00000174 <strlen>:

uint
strlen(const char *s)
{
 174:	f3 0f 1e fb          	endbr32 
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 17e:	b8 00 00 00 00       	mov    $0x0,%eax
 183:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 187:	74 05                	je     18e <strlen+0x1a>
 189:	83 c0 01             	add    $0x1,%eax
 18c:	eb f5                	jmp    183 <strlen+0xf>
    ;
  return n;
}
 18e:	5d                   	pop    %ebp
 18f:	c3                   	ret    

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	57                   	push   %edi
 198:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 19b:	89 d7                	mov    %edx,%edi
 19d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	fc                   	cld    
 1a4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a6:	89 d0                	mov    %edx,%eax
 1a8:	5f                   	pop    %edi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <strchr>:

char*
strchr(const char *s, char c)
{
 1ab:	f3 0f 1e fb          	endbr32 
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1b9:	0f b6 10             	movzbl (%eax),%edx
 1bc:	84 d2                	test   %dl,%dl
 1be:	74 09                	je     1c9 <strchr+0x1e>
    if(*s == c)
 1c0:	38 ca                	cmp    %cl,%dl
 1c2:	74 0a                	je     1ce <strchr+0x23>
  for(; *s; s++)
 1c4:	83 c0 01             	add    $0x1,%eax
 1c7:	eb f0                	jmp    1b9 <strchr+0xe>
      return (char*)s;
  return 0;
 1c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
 1d8:	56                   	push   %esi
 1d9:	53                   	push   %ebx
 1da:	83 ec 1c             	sub    $0x1c,%esp
 1dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e0:	bb 00 00 00 00       	mov    $0x0,%ebx
 1e5:	89 de                	mov    %ebx,%esi
 1e7:	83 c3 01             	add    $0x1,%ebx
 1ea:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ed:	7d 2e                	jge    21d <gets+0x4d>
    cc = read(0, &c, 1);
 1ef:	83 ec 04             	sub    $0x4,%esp
 1f2:	6a 01                	push   $0x1
 1f4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1f7:	50                   	push   %eax
 1f8:	6a 00                	push   $0x0
 1fa:	e8 f6 00 00 00       	call   2f5 <read>
    if(cc < 1)
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	85 c0                	test   %eax,%eax
 204:	7e 17                	jle    21d <gets+0x4d>
      break;
    buf[i++] = c;
 206:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 20a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 20d:	3c 0a                	cmp    $0xa,%al
 20f:	0f 94 c2             	sete   %dl
 212:	3c 0d                	cmp    $0xd,%al
 214:	0f 94 c0             	sete   %al
 217:	08 c2                	or     %al,%dl
 219:	74 ca                	je     1e5 <gets+0x15>
    buf[i++] = c;
 21b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 21d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 221:	89 f8                	mov    %edi,%eax
 223:	8d 65 f4             	lea    -0xc(%ebp),%esp
 226:	5b                   	pop    %ebx
 227:	5e                   	pop    %esi
 228:	5f                   	pop    %edi
 229:	5d                   	pop    %ebp
 22a:	c3                   	ret    

0000022b <stat>:

int
stat(const char *n, struct stat *st)
{
 22b:	f3 0f 1e fb          	endbr32 
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	56                   	push   %esi
 233:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	83 ec 08             	sub    $0x8,%esp
 237:	6a 00                	push   $0x0
 239:	ff 75 08             	pushl  0x8(%ebp)
 23c:	e8 dc 00 00 00       	call   31d <open>
  if(fd < 0)
 241:	83 c4 10             	add    $0x10,%esp
 244:	85 c0                	test   %eax,%eax
 246:	78 24                	js     26c <stat+0x41>
 248:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 24a:	83 ec 08             	sub    $0x8,%esp
 24d:	ff 75 0c             	pushl  0xc(%ebp)
 250:	50                   	push   %eax
 251:	e8 df 00 00 00       	call   335 <fstat>
 256:	89 c6                	mov    %eax,%esi
  close(fd);
 258:	89 1c 24             	mov    %ebx,(%esp)
 25b:	e8 a5 00 00 00       	call   305 <close>
  return r;
 260:	83 c4 10             	add    $0x10,%esp
}
 263:	89 f0                	mov    %esi,%eax
 265:	8d 65 f8             	lea    -0x8(%ebp),%esp
 268:	5b                   	pop    %ebx
 269:	5e                   	pop    %esi
 26a:	5d                   	pop    %ebp
 26b:	c3                   	ret    
    return -1;
 26c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 271:	eb f0                	jmp    263 <stat+0x38>

00000273 <atoi>:

int
atoi(const char *s)
{
 273:	f3 0f 1e fb          	endbr32 
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	53                   	push   %ebx
 27b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 27e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 283:	0f b6 01             	movzbl (%ecx),%eax
 286:	8d 58 d0             	lea    -0x30(%eax),%ebx
 289:	80 fb 09             	cmp    $0x9,%bl
 28c:	77 12                	ja     2a0 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 28e:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 291:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 294:	83 c1 01             	add    $0x1,%ecx
 297:	0f be c0             	movsbl %al,%eax
 29a:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 29e:	eb e3                	jmp    283 <atoi+0x10>
  return n;
}
 2a0:	89 d0                	mov    %edx,%eax
 2a2:	5b                   	pop    %ebx
 2a3:	5d                   	pop    %ebp
 2a4:	c3                   	ret    

000002a5 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a5:	f3 0f 1e fb          	endbr32 
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	56                   	push   %esi
 2ad:	53                   	push   %ebx
 2ae:	8b 75 08             	mov    0x8(%ebp),%esi
 2b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2b4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 2b7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2b9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2bc:	85 c0                	test   %eax,%eax
 2be:	7e 0f                	jle    2cf <memmove+0x2a>
    *dst++ = *src++;
 2c0:	0f b6 01             	movzbl (%ecx),%eax
 2c3:	88 02                	mov    %al,(%edx)
 2c5:	8d 49 01             	lea    0x1(%ecx),%ecx
 2c8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2cb:	89 d8                	mov    %ebx,%eax
 2cd:	eb ea                	jmp    2b9 <memmove+0x14>
  return vdst;
}
 2cf:	89 f0                	mov    %esi,%eax
 2d1:	5b                   	pop    %ebx
 2d2:	5e                   	pop    %esi
 2d3:	5d                   	pop    %ebp
 2d4:	c3                   	ret    

000002d5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d5:	b8 01 00 00 00       	mov    $0x1,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <exit>:
SYSCALL(exit)
 2dd:	b8 02 00 00 00       	mov    $0x2,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <wait>:
SYSCALL(wait)
 2e5:	b8 03 00 00 00       	mov    $0x3,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <pipe>:
SYSCALL(pipe)
 2ed:	b8 04 00 00 00       	mov    $0x4,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <read>:
SYSCALL(read)
 2f5:	b8 05 00 00 00       	mov    $0x5,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <write>:
SYSCALL(write)
 2fd:	b8 10 00 00 00       	mov    $0x10,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <close>:
SYSCALL(close)
 305:	b8 15 00 00 00       	mov    $0x15,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <kill>:
SYSCALL(kill)
 30d:	b8 06 00 00 00       	mov    $0x6,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <exec>:
SYSCALL(exec)
 315:	b8 07 00 00 00       	mov    $0x7,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <open>:
SYSCALL(open)
 31d:	b8 0f 00 00 00       	mov    $0xf,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <mknod>:
SYSCALL(mknod)
 325:	b8 11 00 00 00       	mov    $0x11,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <unlink>:
SYSCALL(unlink)
 32d:	b8 12 00 00 00       	mov    $0x12,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <fstat>:
SYSCALL(fstat)
 335:	b8 08 00 00 00       	mov    $0x8,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <link>:
SYSCALL(link)
 33d:	b8 13 00 00 00       	mov    $0x13,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <mkdir>:
SYSCALL(mkdir)
 345:	b8 14 00 00 00       	mov    $0x14,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <chdir>:
SYSCALL(chdir)
 34d:	b8 09 00 00 00       	mov    $0x9,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <dup>:
SYSCALL(dup)
 355:	b8 0a 00 00 00       	mov    $0xa,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <getpid>:
SYSCALL(getpid)
 35d:	b8 0b 00 00 00       	mov    $0xb,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <sbrk>:
SYSCALL(sbrk)
 365:	b8 0c 00 00 00       	mov    $0xc,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <sleep>:
SYSCALL(sleep)
 36d:	b8 0d 00 00 00       	mov    $0xd,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <uptime>:
SYSCALL(uptime)
 375:	b8 0e 00 00 00       	mov    $0xe,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
 380:	83 ec 1c             	sub    $0x1c,%esp
 383:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 386:	6a 01                	push   $0x1
 388:	8d 55 f4             	lea    -0xc(%ebp),%edx
 38b:	52                   	push   %edx
 38c:	50                   	push   %eax
 38d:	e8 6b ff ff ff       	call   2fd <write>
}
 392:	83 c4 10             	add    $0x10,%esp
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	57                   	push   %edi
 39b:	56                   	push   %esi
 39c:	53                   	push   %ebx
 39d:	83 ec 2c             	sub    $0x2c,%esp
 3a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3a3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a9:	0f 95 c2             	setne  %dl
 3ac:	89 f0                	mov    %esi,%eax
 3ae:	c1 e8 1f             	shr    $0x1f,%eax
 3b1:	84 c2                	test   %al,%dl
 3b3:	74 42                	je     3f7 <printint+0x60>
    neg = 1;
    x = -xx;
 3b5:	f7 de                	neg    %esi
    neg = 1;
 3b7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3be:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3c3:	89 f0                	mov    %esi,%eax
 3c5:	ba 00 00 00 00       	mov    $0x0,%edx
 3ca:	f7 f1                	div    %ecx
 3cc:	89 df                	mov    %ebx,%edi
 3ce:	83 c3 01             	add    $0x1,%ebx
 3d1:	0f b6 92 08 07 00 00 	movzbl 0x708(%edx),%edx
 3d8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3dc:	89 f2                	mov    %esi,%edx
 3de:	89 c6                	mov    %eax,%esi
 3e0:	39 d1                	cmp    %edx,%ecx
 3e2:	76 df                	jbe    3c3 <printint+0x2c>
  if(neg)
 3e4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3e8:	74 2f                	je     419 <printint+0x82>
    buf[i++] = '-';
 3ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ef:	8d 5f 02             	lea    0x2(%edi),%ebx
 3f2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3f5:	eb 15                	jmp    40c <printint+0x75>
  neg = 0;
 3f7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3fe:	eb be                	jmp    3be <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 400:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 405:	89 f0                	mov    %esi,%eax
 407:	e8 71 ff ff ff       	call   37d <putc>
  while(--i >= 0)
 40c:	83 eb 01             	sub    $0x1,%ebx
 40f:	79 ef                	jns    400 <printint+0x69>
}
 411:	83 c4 2c             	add    $0x2c,%esp
 414:	5b                   	pop    %ebx
 415:	5e                   	pop    %esi
 416:	5f                   	pop    %edi
 417:	5d                   	pop    %ebp
 418:	c3                   	ret    
 419:	8b 75 d0             	mov    -0x30(%ebp),%esi
 41c:	eb ee                	jmp    40c <printint+0x75>

0000041e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 41e:	f3 0f 1e fb          	endbr32 
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	57                   	push   %edi
 426:	56                   	push   %esi
 427:	53                   	push   %ebx
 428:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 42b:	8d 45 10             	lea    0x10(%ebp),%eax
 42e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 431:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 436:	bb 00 00 00 00       	mov    $0x0,%ebx
 43b:	eb 14                	jmp    451 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 43d:	89 fa                	mov    %edi,%edx
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	e8 36 ff ff ff       	call   37d <putc>
 447:	eb 05                	jmp    44e <printf+0x30>
      }
    } else if(state == '%'){
 449:	83 fe 25             	cmp    $0x25,%esi
 44c:	74 25                	je     473 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 44e:	83 c3 01             	add    $0x1,%ebx
 451:	8b 45 0c             	mov    0xc(%ebp),%eax
 454:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 458:	84 c0                	test   %al,%al
 45a:	0f 84 23 01 00 00    	je     583 <printf+0x165>
    c = fmt[i] & 0xff;
 460:	0f be f8             	movsbl %al,%edi
 463:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 466:	85 f6                	test   %esi,%esi
 468:	75 df                	jne    449 <printf+0x2b>
      if(c == '%'){
 46a:	83 f8 25             	cmp    $0x25,%eax
 46d:	75 ce                	jne    43d <printf+0x1f>
        state = '%';
 46f:	89 c6                	mov    %eax,%esi
 471:	eb db                	jmp    44e <printf+0x30>
      if(c == 'd'){
 473:	83 f8 64             	cmp    $0x64,%eax
 476:	74 49                	je     4c1 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 478:	83 f8 78             	cmp    $0x78,%eax
 47b:	0f 94 c1             	sete   %cl
 47e:	83 f8 70             	cmp    $0x70,%eax
 481:	0f 94 c2             	sete   %dl
 484:	08 d1                	or     %dl,%cl
 486:	75 63                	jne    4eb <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 488:	83 f8 73             	cmp    $0x73,%eax
 48b:	0f 84 84 00 00 00    	je     515 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 491:	83 f8 63             	cmp    $0x63,%eax
 494:	0f 84 b7 00 00 00    	je     551 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 49a:	83 f8 25             	cmp    $0x25,%eax
 49d:	0f 84 cc 00 00 00    	je     56f <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4a3:	ba 25 00 00 00       	mov    $0x25,%edx
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
 4ab:	e8 cd fe ff ff       	call   37d <putc>
        putc(fd, c);
 4b0:	89 fa                	mov    %edi,%edx
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	e8 c3 fe ff ff       	call   37d <putc>
      }
      state = 0;
 4ba:	be 00 00 00 00       	mov    $0x0,%esi
 4bf:	eb 8d                	jmp    44e <printf+0x30>
        printint(fd, *ap, 10, 1);
 4c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4c4:	8b 17                	mov    (%edi),%edx
 4c6:	83 ec 0c             	sub    $0xc,%esp
 4c9:	6a 01                	push   $0x1
 4cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	e8 bf fe ff ff       	call   397 <printint>
        ap++;
 4d8:	83 c7 04             	add    $0x4,%edi
 4db:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4de:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e1:	be 00 00 00 00       	mov    $0x0,%esi
 4e6:	e9 63 ff ff ff       	jmp    44e <printf+0x30>
        printint(fd, *ap, 16, 0);
 4eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ee:	8b 17                	mov    (%edi),%edx
 4f0:	83 ec 0c             	sub    $0xc,%esp
 4f3:	6a 00                	push   $0x0
 4f5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	e8 95 fe ff ff       	call   397 <printint>
        ap++;
 502:	83 c7 04             	add    $0x4,%edi
 505:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 508:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50b:	be 00 00 00 00       	mov    $0x0,%esi
 510:	e9 39 ff ff ff       	jmp    44e <printf+0x30>
        s = (char*)*ap;
 515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 518:	8b 30                	mov    (%eax),%esi
        ap++;
 51a:	83 c0 04             	add    $0x4,%eax
 51d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 520:	85 f6                	test   %esi,%esi
 522:	75 28                	jne    54c <printf+0x12e>
          s = "(null)";
 524:	be ff 06 00 00       	mov    $0x6ff,%esi
 529:	8b 7d 08             	mov    0x8(%ebp),%edi
 52c:	eb 0d                	jmp    53b <printf+0x11d>
          putc(fd, *s);
 52e:	0f be d2             	movsbl %dl,%edx
 531:	89 f8                	mov    %edi,%eax
 533:	e8 45 fe ff ff       	call   37d <putc>
          s++;
 538:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 53b:	0f b6 16             	movzbl (%esi),%edx
 53e:	84 d2                	test   %dl,%dl
 540:	75 ec                	jne    52e <printf+0x110>
      state = 0;
 542:	be 00 00 00 00       	mov    $0x0,%esi
 547:	e9 02 ff ff ff       	jmp    44e <printf+0x30>
 54c:	8b 7d 08             	mov    0x8(%ebp),%edi
 54f:	eb ea                	jmp    53b <printf+0x11d>
        putc(fd, *ap);
 551:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 554:	0f be 17             	movsbl (%edi),%edx
 557:	8b 45 08             	mov    0x8(%ebp),%eax
 55a:	e8 1e fe ff ff       	call   37d <putc>
        ap++;
 55f:	83 c7 04             	add    $0x4,%edi
 562:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 565:	be 00 00 00 00       	mov    $0x0,%esi
 56a:	e9 df fe ff ff       	jmp    44e <printf+0x30>
        putc(fd, c);
 56f:	89 fa                	mov    %edi,%edx
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	e8 04 fe ff ff       	call   37d <putc>
      state = 0;
 579:	be 00 00 00 00       	mov    $0x0,%esi
 57e:	e9 cb fe ff ff       	jmp    44e <printf+0x30>
    }
  }
}
 583:	8d 65 f4             	lea    -0xc(%ebp),%esp
 586:	5b                   	pop    %ebx
 587:	5e                   	pop    %esi
 588:	5f                   	pop    %edi
 589:	5d                   	pop    %ebp
 58a:	c3                   	ret    

0000058b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 58b:	f3 0f 1e fb          	endbr32 
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	57                   	push   %edi
 593:	56                   	push   %esi
 594:	53                   	push   %ebx
 595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 598:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59b:	a1 b0 09 00 00       	mov    0x9b0,%eax
 5a0:	eb 02                	jmp    5a4 <free+0x19>
 5a2:	89 d0                	mov    %edx,%eax
 5a4:	39 c8                	cmp    %ecx,%eax
 5a6:	73 04                	jae    5ac <free+0x21>
 5a8:	39 08                	cmp    %ecx,(%eax)
 5aa:	77 12                	ja     5be <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ac:	8b 10                	mov    (%eax),%edx
 5ae:	39 c2                	cmp    %eax,%edx
 5b0:	77 f0                	ja     5a2 <free+0x17>
 5b2:	39 c8                	cmp    %ecx,%eax
 5b4:	72 08                	jb     5be <free+0x33>
 5b6:	39 ca                	cmp    %ecx,%edx
 5b8:	77 04                	ja     5be <free+0x33>
 5ba:	89 d0                	mov    %edx,%eax
 5bc:	eb e6                	jmp    5a4 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5be:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5c1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5c4:	8b 10                	mov    (%eax),%edx
 5c6:	39 d7                	cmp    %edx,%edi
 5c8:	74 19                	je     5e3 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5cd:	8b 50 04             	mov    0x4(%eax),%edx
 5d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5d3:	39 ce                	cmp    %ecx,%esi
 5d5:	74 1b                	je     5f2 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5d7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5d9:	a3 b0 09 00 00       	mov    %eax,0x9b0
}
 5de:	5b                   	pop    %ebx
 5df:	5e                   	pop    %esi
 5e0:	5f                   	pop    %edi
 5e1:	5d                   	pop    %ebp
 5e2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5e3:	03 72 04             	add    0x4(%edx),%esi
 5e6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e9:	8b 10                	mov    (%eax),%edx
 5eb:	8b 12                	mov    (%edx),%edx
 5ed:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5f0:	eb db                	jmp    5cd <free+0x42>
    p->s.size += bp->s.size;
 5f2:	03 53 fc             	add    -0x4(%ebx),%edx
 5f5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5f8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5fb:	89 10                	mov    %edx,(%eax)
 5fd:	eb da                	jmp    5d9 <free+0x4e>

000005ff <morecore>:

static Header*
morecore(uint nu)
{
 5ff:	55                   	push   %ebp
 600:	89 e5                	mov    %esp,%ebp
 602:	53                   	push   %ebx
 603:	83 ec 04             	sub    $0x4,%esp
 606:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 608:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 60d:	77 05                	ja     614 <morecore+0x15>
    nu = 4096;
 60f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 614:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 61b:	83 ec 0c             	sub    $0xc,%esp
 61e:	50                   	push   %eax
 61f:	e8 41 fd ff ff       	call   365 <sbrk>
  if(p == (char*)-1)
 624:	83 c4 10             	add    $0x10,%esp
 627:	83 f8 ff             	cmp    $0xffffffff,%eax
 62a:	74 1c                	je     648 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 62c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 62f:	83 c0 08             	add    $0x8,%eax
 632:	83 ec 0c             	sub    $0xc,%esp
 635:	50                   	push   %eax
 636:	e8 50 ff ff ff       	call   58b <free>
  return freep;
 63b:	a1 b0 09 00 00       	mov    0x9b0,%eax
 640:	83 c4 10             	add    $0x10,%esp
}
 643:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 646:	c9                   	leave  
 647:	c3                   	ret    
    return 0;
 648:	b8 00 00 00 00       	mov    $0x0,%eax
 64d:	eb f4                	jmp    643 <morecore+0x44>

0000064f <malloc>:

void*
malloc(uint nbytes)
{
 64f:	f3 0f 1e fb          	endbr32 
 653:	55                   	push   %ebp
 654:	89 e5                	mov    %esp,%ebp
 656:	53                   	push   %ebx
 657:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	8d 58 07             	lea    0x7(%eax),%ebx
 660:	c1 eb 03             	shr    $0x3,%ebx
 663:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 666:	8b 0d b0 09 00 00    	mov    0x9b0,%ecx
 66c:	85 c9                	test   %ecx,%ecx
 66e:	74 04                	je     674 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 670:	8b 01                	mov    (%ecx),%eax
 672:	eb 4b                	jmp    6bf <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 674:	c7 05 b0 09 00 00 b4 	movl   $0x9b4,0x9b0
 67b:	09 00 00 
 67e:	c7 05 b4 09 00 00 b4 	movl   $0x9b4,0x9b4
 685:	09 00 00 
    base.s.size = 0;
 688:	c7 05 b8 09 00 00 00 	movl   $0x0,0x9b8
 68f:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 692:	b9 b4 09 00 00       	mov    $0x9b4,%ecx
 697:	eb d7                	jmp    670 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 699:	74 1a                	je     6b5 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 69b:	29 da                	sub    %ebx,%edx
 69d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6a0:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6a3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6a6:	89 0d b0 09 00 00    	mov    %ecx,0x9b0
      return (void*)(p + 1);
 6ac:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6af:	83 c4 04             	add    $0x4,%esp
 6b2:	5b                   	pop    %ebx
 6b3:	5d                   	pop    %ebp
 6b4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6b5:	8b 10                	mov    (%eax),%edx
 6b7:	89 11                	mov    %edx,(%ecx)
 6b9:	eb eb                	jmp    6a6 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6bb:	89 c1                	mov    %eax,%ecx
 6bd:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6bf:	8b 50 04             	mov    0x4(%eax),%edx
 6c2:	39 da                	cmp    %ebx,%edx
 6c4:	73 d3                	jae    699 <malloc+0x4a>
    if(p == freep)
 6c6:	39 05 b0 09 00 00    	cmp    %eax,0x9b0
 6cc:	75 ed                	jne    6bb <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 6ce:	89 d8                	mov    %ebx,%eax
 6d0:	e8 2a ff ff ff       	call   5ff <morecore>
 6d5:	85 c0                	test   %eax,%eax
 6d7:	75 e2                	jne    6bb <malloc+0x6c>
 6d9:	eb d4                	jmp    6af <malloc+0x60>
