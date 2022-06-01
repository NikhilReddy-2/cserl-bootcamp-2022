
_my_ancestors:     file format elf32-i386


Disassembly of section .text:

00000000 <recurse>:
#include "user.h"

int n;
int out[100];

void recurse(int depth) {
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (depth == 0) {
   c:	85 f6                	test   %esi,%esi
   e:	74 76                	je     86 <recurse+0x86>
		exit();
	}
	else {
		int ret;
		int i;
		for (i=0; i<5; i++) {
  10:	bb 00 00 00 00       	mov    $0x0,%ebx
  15:	83 fb 04             	cmp    $0x4,%ebx
  18:	0f 8f bb 00 00 00    	jg     d9 <recurse+0xd9>
			ret = fork();
  1e:	e8 df 02 00 00       	call   302 <fork>
			if (ret == 0) {
  23:	85 c0                	test   %eax,%eax
  25:	0f 84 a9 00 00 00    	je     d4 <recurse+0xd4>
				exit();
			}
			else {
				wait();
  2b:	e8 e2 02 00 00       	call   312 <wait>
		for (i=0; i<5; i++) {
  30:	83 c3 01             	add    $0x1,%ebx
  33:	eb e0                	jmp    15 <recurse+0x15>
			out[i] = 0;
  35:	c7 04 85 80 0a 00 00 	movl   $0x0,0xa80(,%eax,4)
  3c:	00 00 00 00 
		for(int i=0;i<100;i++){
  40:	83 c0 01             	add    $0x1,%eax
  43:	83 f8 63             	cmp    $0x63,%eax
  46:	7e ed                	jle    35 <recurse+0x35>
		int ret = get_ancestors(n, out);
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 80 0a 00 00       	push   $0xa80
  50:	ff 35 60 0a 00 00    	pushl  0xa60
  56:	e8 57 03 00 00       	call   3b2 <get_ancestors>
  5b:	89 c3                	mov    %eax,%ebx
		printf(1, "Process: %d \n", getpid());
  5d:	e8 28 03 00 00       	call   38a <getpid>
  62:	83 c4 0c             	add    $0xc,%esp
  65:	50                   	push   %eax
  66:	68 18 07 00 00       	push   $0x718
  6b:	6a 01                	push   $0x1
  6d:	e8 e9 03 00 00       	call   45b <printf>
		printf(1, "Ancestors: ");
  72:	83 c4 08             	add    $0x8,%esp
  75:	68 26 07 00 00       	push   $0x726
  7a:	6a 01                	push   $0x1
  7c:	e8 da 03 00 00       	call   45b <printf>
		for(int i=0;i<100 && out[i]!=0;i++){
  81:	83 c4 10             	add    $0x10,%esp
  84:	eb 1a                	jmp    a0 <recurse+0xa0>
		for(int i=0;i<100;i++){
  86:	89 f0                	mov    %esi,%eax
  88:	eb b9                	jmp    43 <recurse+0x43>
			printf(1, "%d ", out[i]);
  8a:	83 ec 04             	sub    $0x4,%esp
  8d:	50                   	push   %eax
  8e:	68 32 07 00 00       	push   $0x732
  93:	6a 01                	push   $0x1
  95:	e8 c1 03 00 00       	call   45b <printf>
		for(int i=0;i<100 && out[i]!=0;i++){
  9a:	83 c6 01             	add    $0x1,%esi
  9d:	83 c4 10             	add    $0x10,%esp
  a0:	83 fe 63             	cmp    $0x63,%esi
  a3:	7f 0b                	jg     b0 <recurse+0xb0>
  a5:	8b 04 b5 80 0a 00 00 	mov    0xa80(,%esi,4),%eax
  ac:	85 c0                	test   %eax,%eax
  ae:	75 da                	jne    8a <recurse+0x8a>
		printf(1,"\n");
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	68 47 07 00 00       	push   $0x747
  b8:	6a 01                	push   $0x1
  ba:	e8 9c 03 00 00       	call   45b <printf>
		printf(1, "Return value: %d \n", ret);
  bf:	83 c4 0c             	add    $0xc,%esp
  c2:	53                   	push   %ebx
  c3:	68 36 07 00 00       	push   $0x736
  c8:	6a 01                	push   $0x1
  ca:	e8 8c 03 00 00       	call   45b <printf>
		exit();
  cf:	e8 36 02 00 00       	call   30a <exit>
				exit();
  d4:	e8 31 02 00 00       	call   30a <exit>
			}
		}
		ret = fork();
  d9:	e8 24 02 00 00       	call   302 <fork>
		if (ret == 0) {
  de:	85 c0                	test   %eax,%eax
  e0:	74 0c                	je     ee <recurse+0xee>
			recurse(depth-1);
			exit();
		}
		else {
			wait();
  e2:	e8 2b 02 00 00       	call   312 <wait>
		}
	}
}
  e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ea:	5b                   	pop    %ebx
  eb:	5e                   	pop    %esi
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret    
			recurse(depth-1);
  ee:	83 ec 0c             	sub    $0xc,%esp
  f1:	83 ee 01             	sub    $0x1,%esi
  f4:	56                   	push   %esi
  f5:	e8 06 ff ff ff       	call   0 <recurse>
			exit();
  fa:	e8 0b 02 00 00       	call   30a <exit>

000000ff <main>:

int
main(int argc, char *argv[])
{
  ff:	f3 0f 1e fb          	endbr32 
 103:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 107:	83 e4 f0             	and    $0xfffffff0,%esp
 10a:	ff 71 fc             	pushl  -0x4(%ecx)
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	56                   	push   %esi
 111:	53                   	push   %ebx
 112:	51                   	push   %ecx
 113:	83 ec 0c             	sub    $0xc,%esp
 116:	8b 71 04             	mov    0x4(%ecx),%esi
  int i;

  if(argc <= 1){
 119:	83 39 01             	cmpl   $0x1,(%ecx)
 11c:	7e 2a                	jle    148 <main+0x49>
    exit();
  }

  i = atoi(argv[1]);
 11e:	83 ec 0c             	sub    $0xc,%esp
 121:	ff 76 04             	pushl  0x4(%esi)
 124:	e8 77 01 00 00       	call   2a0 <atoi>
 129:	89 c3                	mov    %eax,%ebx
  n = atoi(argv[2]);
 12b:	83 c4 04             	add    $0x4,%esp
 12e:	ff 76 08             	pushl  0x8(%esi)
 131:	e8 6a 01 00 00       	call   2a0 <atoi>
 136:	a3 60 0a 00 00       	mov    %eax,0xa60

  recurse(i);
 13b:	89 1c 24             	mov    %ebx,(%esp)
 13e:	e8 bd fe ff ff       	call   0 <recurse>



  exit();
 143:	e8 c2 01 00 00       	call   30a <exit>
    exit();
 148:	e8 bd 01 00 00       	call   30a <exit>

0000014d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 14d:	f3 0f 1e fb          	endbr32 
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	56                   	push   %esi
 155:	53                   	push   %ebx
 156:	8b 75 08             	mov    0x8(%ebp),%esi
 159:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15c:	89 f0                	mov    %esi,%eax
 15e:	89 d1                	mov    %edx,%ecx
 160:	83 c2 01             	add    $0x1,%edx
 163:	89 c3                	mov    %eax,%ebx
 165:	83 c0 01             	add    $0x1,%eax
 168:	0f b6 09             	movzbl (%ecx),%ecx
 16b:	88 0b                	mov    %cl,(%ebx)
 16d:	84 c9                	test   %cl,%cl
 16f:	75 ed                	jne    15e <strcpy+0x11>
    ;
  return os;
}
 171:	89 f0                	mov    %esi,%eax
 173:	5b                   	pop    %ebx
 174:	5e                   	pop    %esi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    

00000177 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 177:	f3 0f 1e fb          	endbr32 
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 181:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 184:	0f b6 01             	movzbl (%ecx),%eax
 187:	84 c0                	test   %al,%al
 189:	74 0c                	je     197 <strcmp+0x20>
 18b:	3a 02                	cmp    (%edx),%al
 18d:	75 08                	jne    197 <strcmp+0x20>
    p++, q++;
 18f:	83 c1 01             	add    $0x1,%ecx
 192:	83 c2 01             	add    $0x1,%edx
 195:	eb ed                	jmp    184 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 197:	0f b6 c0             	movzbl %al,%eax
 19a:	0f b6 12             	movzbl (%edx),%edx
 19d:	29 d0                	sub    %edx,%eax
}
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    

000001a1 <strlen>:

uint
strlen(const char *s)
{
 1a1:	f3 0f 1e fb          	endbr32 
 1a5:	55                   	push   %ebp
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ab:	b8 00 00 00 00       	mov    $0x0,%eax
 1b0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1b4:	74 05                	je     1bb <strlen+0x1a>
 1b6:	83 c0 01             	add    $0x1,%eax
 1b9:	eb f5                	jmp    1b0 <strlen+0xf>
    ;
  return n;
}
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	f3 0f 1e fb          	endbr32 
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	57                   	push   %edi
 1c5:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c8:	89 d7                	mov    %edx,%edi
 1ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d0:	fc                   	cld    
 1d1:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d3:	89 d0                	mov    %edx,%eax
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <strchr>:

char*
strchr(const char *s, char c)
{
 1d8:	f3 0f 1e fb          	endbr32 
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1e6:	0f b6 10             	movzbl (%eax),%edx
 1e9:	84 d2                	test   %dl,%dl
 1eb:	74 09                	je     1f6 <strchr+0x1e>
    if(*s == c)
 1ed:	38 ca                	cmp    %cl,%dl
 1ef:	74 0a                	je     1fb <strchr+0x23>
  for(; *s; s++)
 1f1:	83 c0 01             	add    $0x1,%eax
 1f4:	eb f0                	jmp    1e6 <strchr+0xe>
      return (char*)s;
  return 0;
 1f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    

000001fd <gets>:

char*
gets(char *buf, int max)
{
 1fd:	f3 0f 1e fb          	endbr32 
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	57                   	push   %edi
 205:	56                   	push   %esi
 206:	53                   	push   %ebx
 207:	83 ec 1c             	sub    $0x1c,%esp
 20a:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	bb 00 00 00 00       	mov    $0x0,%ebx
 212:	89 de                	mov    %ebx,%esi
 214:	83 c3 01             	add    $0x1,%ebx
 217:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 21a:	7d 2e                	jge    24a <gets+0x4d>
    cc = read(0, &c, 1);
 21c:	83 ec 04             	sub    $0x4,%esp
 21f:	6a 01                	push   $0x1
 221:	8d 45 e7             	lea    -0x19(%ebp),%eax
 224:	50                   	push   %eax
 225:	6a 00                	push   $0x0
 227:	e8 f6 00 00 00       	call   322 <read>
    if(cc < 1)
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	85 c0                	test   %eax,%eax
 231:	7e 17                	jle    24a <gets+0x4d>
      break;
    buf[i++] = c;
 233:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 237:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 23a:	3c 0a                	cmp    $0xa,%al
 23c:	0f 94 c2             	sete   %dl
 23f:	3c 0d                	cmp    $0xd,%al
 241:	0f 94 c0             	sete   %al
 244:	08 c2                	or     %al,%dl
 246:	74 ca                	je     212 <gets+0x15>
    buf[i++] = c;
 248:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 24a:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 24e:	89 f8                	mov    %edi,%eax
 250:	8d 65 f4             	lea    -0xc(%ebp),%esp
 253:	5b                   	pop    %ebx
 254:	5e                   	pop    %esi
 255:	5f                   	pop    %edi
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    

00000258 <stat>:

int
stat(const char *n, struct stat *st)
{
 258:	f3 0f 1e fb          	endbr32 
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	56                   	push   %esi
 260:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 261:	83 ec 08             	sub    $0x8,%esp
 264:	6a 00                	push   $0x0
 266:	ff 75 08             	pushl  0x8(%ebp)
 269:	e8 dc 00 00 00       	call   34a <open>
  if(fd < 0)
 26e:	83 c4 10             	add    $0x10,%esp
 271:	85 c0                	test   %eax,%eax
 273:	78 24                	js     299 <stat+0x41>
 275:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 277:	83 ec 08             	sub    $0x8,%esp
 27a:	ff 75 0c             	pushl  0xc(%ebp)
 27d:	50                   	push   %eax
 27e:	e8 df 00 00 00       	call   362 <fstat>
 283:	89 c6                	mov    %eax,%esi
  close(fd);
 285:	89 1c 24             	mov    %ebx,(%esp)
 288:	e8 a5 00 00 00       	call   332 <close>
  return r;
 28d:	83 c4 10             	add    $0x10,%esp
}
 290:	89 f0                	mov    %esi,%eax
 292:	8d 65 f8             	lea    -0x8(%ebp),%esp
 295:	5b                   	pop    %ebx
 296:	5e                   	pop    %esi
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    
    return -1;
 299:	be ff ff ff ff       	mov    $0xffffffff,%esi
 29e:	eb f0                	jmp    290 <stat+0x38>

000002a0 <atoi>:

int
atoi(const char *s)
{
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	53                   	push   %ebx
 2a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2ab:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2b0:	0f b6 01             	movzbl (%ecx),%eax
 2b3:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2b6:	80 fb 09             	cmp    $0x9,%bl
 2b9:	77 12                	ja     2cd <atoi+0x2d>
    n = n*10 + *s++ - '0';
 2bb:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 2be:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 2c1:	83 c1 01             	add    $0x1,%ecx
 2c4:	0f be c0             	movsbl %al,%eax
 2c7:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 2cb:	eb e3                	jmp    2b0 <atoi+0x10>
  return n;
}
 2cd:	89 d0                	mov    %edx,%eax
 2cf:	5b                   	pop    %ebx
 2d0:	5d                   	pop    %ebp
 2d1:	c3                   	ret    

000002d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d2:	f3 0f 1e fb          	endbr32 
 2d6:	55                   	push   %ebp
 2d7:	89 e5                	mov    %esp,%ebp
 2d9:	56                   	push   %esi
 2da:	53                   	push   %ebx
 2db:	8b 75 08             	mov    0x8(%ebp),%esi
 2de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2e1:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 2e4:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2e6:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2e9:	85 c0                	test   %eax,%eax
 2eb:	7e 0f                	jle    2fc <memmove+0x2a>
    *dst++ = *src++;
 2ed:	0f b6 01             	movzbl (%ecx),%eax
 2f0:	88 02                	mov    %al,(%edx)
 2f2:	8d 49 01             	lea    0x1(%ecx),%ecx
 2f5:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2f8:	89 d8                	mov    %ebx,%eax
 2fa:	eb ea                	jmp    2e6 <memmove+0x14>
  return vdst;
}
 2fc:	89 f0                	mov    %esi,%eax
 2fe:	5b                   	pop    %ebx
 2ff:	5e                   	pop    %esi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    

00000302 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 302:	b8 01 00 00 00       	mov    $0x1,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <exit>:
SYSCALL(exit)
 30a:	b8 02 00 00 00       	mov    $0x2,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <wait>:
SYSCALL(wait)
 312:	b8 03 00 00 00       	mov    $0x3,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <pipe>:
SYSCALL(pipe)
 31a:	b8 04 00 00 00       	mov    $0x4,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <read>:
SYSCALL(read)
 322:	b8 05 00 00 00       	mov    $0x5,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <write>:
SYSCALL(write)
 32a:	b8 10 00 00 00       	mov    $0x10,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <close>:
SYSCALL(close)
 332:	b8 15 00 00 00       	mov    $0x15,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <kill>:
SYSCALL(kill)
 33a:	b8 06 00 00 00       	mov    $0x6,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <exec>:
SYSCALL(exec)
 342:	b8 07 00 00 00       	mov    $0x7,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <open>:
SYSCALL(open)
 34a:	b8 0f 00 00 00       	mov    $0xf,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <mknod>:
SYSCALL(mknod)
 352:	b8 11 00 00 00       	mov    $0x11,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <unlink>:
SYSCALL(unlink)
 35a:	b8 12 00 00 00       	mov    $0x12,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <fstat>:
SYSCALL(fstat)
 362:	b8 08 00 00 00       	mov    $0x8,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <link>:
SYSCALL(link)
 36a:	b8 13 00 00 00       	mov    $0x13,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <mkdir>:
SYSCALL(mkdir)
 372:	b8 14 00 00 00       	mov    $0x14,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <chdir>:
SYSCALL(chdir)
 37a:	b8 09 00 00 00       	mov    $0x9,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <dup>:
SYSCALL(dup)
 382:	b8 0a 00 00 00       	mov    $0xa,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <getpid>:
SYSCALL(getpid)
 38a:	b8 0b 00 00 00       	mov    $0xb,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <sbrk>:
SYSCALL(sbrk)
 392:	b8 0c 00 00 00       	mov    $0xc,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <sleep>:
SYSCALL(sleep)
 39a:	b8 0d 00 00 00       	mov    $0xd,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <uptime>:
SYSCALL(uptime)
 3a2:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <get_siblings_info>:
SYSCALL(get_siblings_info)
 3aa:	b8 16 00 00 00       	mov    $0x16,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <get_ancestors>:
SYSCALL(get_ancestors)
 3b2:	b8 17 00 00 00       	mov    $0x17,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	83 ec 1c             	sub    $0x1c,%esp
 3c0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3c3:	6a 01                	push   $0x1
 3c5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3c8:	52                   	push   %edx
 3c9:	50                   	push   %eax
 3ca:	e8 5b ff ff ff       	call   32a <write>
}
 3cf:	83 c4 10             	add    $0x10,%esp
 3d2:	c9                   	leave  
 3d3:	c3                   	ret    

000003d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	57                   	push   %edi
 3d8:	56                   	push   %esi
 3d9:	53                   	push   %ebx
 3da:	83 ec 2c             	sub    $0x2c,%esp
 3dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3e0:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3e6:	0f 95 c2             	setne  %dl
 3e9:	89 f0                	mov    %esi,%eax
 3eb:	c1 e8 1f             	shr    $0x1f,%eax
 3ee:	84 c2                	test   %al,%dl
 3f0:	74 42                	je     434 <printint+0x60>
    neg = 1;
    x = -xx;
 3f2:	f7 de                	neg    %esi
    neg = 1;
 3f4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 400:	89 f0                	mov    %esi,%eax
 402:	ba 00 00 00 00       	mov    $0x0,%edx
 407:	f7 f1                	div    %ecx
 409:	89 df                	mov    %ebx,%edi
 40b:	83 c3 01             	add    $0x1,%ebx
 40e:	0f b6 92 50 07 00 00 	movzbl 0x750(%edx),%edx
 415:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 419:	89 f2                	mov    %esi,%edx
 41b:	89 c6                	mov    %eax,%esi
 41d:	39 d1                	cmp    %edx,%ecx
 41f:	76 df                	jbe    400 <printint+0x2c>
  if(neg)
 421:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 425:	74 2f                	je     456 <printint+0x82>
    buf[i++] = '-';
 427:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 42c:	8d 5f 02             	lea    0x2(%edi),%ebx
 42f:	8b 75 d0             	mov    -0x30(%ebp),%esi
 432:	eb 15                	jmp    449 <printint+0x75>
  neg = 0;
 434:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 43b:	eb be                	jmp    3fb <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 43d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 442:	89 f0                	mov    %esi,%eax
 444:	e8 71 ff ff ff       	call   3ba <putc>
  while(--i >= 0)
 449:	83 eb 01             	sub    $0x1,%ebx
 44c:	79 ef                	jns    43d <printint+0x69>
}
 44e:	83 c4 2c             	add    $0x2c,%esp
 451:	5b                   	pop    %ebx
 452:	5e                   	pop    %esi
 453:	5f                   	pop    %edi
 454:	5d                   	pop    %ebp
 455:	c3                   	ret    
 456:	8b 75 d0             	mov    -0x30(%ebp),%esi
 459:	eb ee                	jmp    449 <printint+0x75>

0000045b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 45b:	f3 0f 1e fb          	endbr32 
 45f:	55                   	push   %ebp
 460:	89 e5                	mov    %esp,%ebp
 462:	57                   	push   %edi
 463:	56                   	push   %esi
 464:	53                   	push   %ebx
 465:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 468:	8d 45 10             	lea    0x10(%ebp),%eax
 46b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 46e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 473:	bb 00 00 00 00       	mov    $0x0,%ebx
 478:	eb 14                	jmp    48e <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 47a:	89 fa                	mov    %edi,%edx
 47c:	8b 45 08             	mov    0x8(%ebp),%eax
 47f:	e8 36 ff ff ff       	call   3ba <putc>
 484:	eb 05                	jmp    48b <printf+0x30>
      }
    } else if(state == '%'){
 486:	83 fe 25             	cmp    $0x25,%esi
 489:	74 25                	je     4b0 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 48b:	83 c3 01             	add    $0x1,%ebx
 48e:	8b 45 0c             	mov    0xc(%ebp),%eax
 491:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 495:	84 c0                	test   %al,%al
 497:	0f 84 23 01 00 00    	je     5c0 <printf+0x165>
    c = fmt[i] & 0xff;
 49d:	0f be f8             	movsbl %al,%edi
 4a0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4a3:	85 f6                	test   %esi,%esi
 4a5:	75 df                	jne    486 <printf+0x2b>
      if(c == '%'){
 4a7:	83 f8 25             	cmp    $0x25,%eax
 4aa:	75 ce                	jne    47a <printf+0x1f>
        state = '%';
 4ac:	89 c6                	mov    %eax,%esi
 4ae:	eb db                	jmp    48b <printf+0x30>
      if(c == 'd'){
 4b0:	83 f8 64             	cmp    $0x64,%eax
 4b3:	74 49                	je     4fe <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4b5:	83 f8 78             	cmp    $0x78,%eax
 4b8:	0f 94 c1             	sete   %cl
 4bb:	83 f8 70             	cmp    $0x70,%eax
 4be:	0f 94 c2             	sete   %dl
 4c1:	08 d1                	or     %dl,%cl
 4c3:	75 63                	jne    528 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c5:	83 f8 73             	cmp    $0x73,%eax
 4c8:	0f 84 84 00 00 00    	je     552 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ce:	83 f8 63             	cmp    $0x63,%eax
 4d1:	0f 84 b7 00 00 00    	je     58e <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d7:	83 f8 25             	cmp    $0x25,%eax
 4da:	0f 84 cc 00 00 00    	je     5ac <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4e0:	ba 25 00 00 00       	mov    $0x25,%edx
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	e8 cd fe ff ff       	call   3ba <putc>
        putc(fd, c);
 4ed:	89 fa                	mov    %edi,%edx
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	e8 c3 fe ff ff       	call   3ba <putc>
      }
      state = 0;
 4f7:	be 00 00 00 00       	mov    $0x0,%esi
 4fc:	eb 8d                	jmp    48b <printf+0x30>
        printint(fd, *ap, 10, 1);
 4fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 501:	8b 17                	mov    (%edi),%edx
 503:	83 ec 0c             	sub    $0xc,%esp
 506:	6a 01                	push   $0x1
 508:	b9 0a 00 00 00       	mov    $0xa,%ecx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	e8 bf fe ff ff       	call   3d4 <printint>
        ap++;
 515:	83 c7 04             	add    $0x4,%edi
 518:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 51b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51e:	be 00 00 00 00       	mov    $0x0,%esi
 523:	e9 63 ff ff ff       	jmp    48b <printf+0x30>
        printint(fd, *ap, 16, 0);
 528:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 52b:	8b 17                	mov    (%edi),%edx
 52d:	83 ec 0c             	sub    $0xc,%esp
 530:	6a 00                	push   $0x0
 532:	b9 10 00 00 00       	mov    $0x10,%ecx
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	e8 95 fe ff ff       	call   3d4 <printint>
        ap++;
 53f:	83 c7 04             	add    $0x4,%edi
 542:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 545:	83 c4 10             	add    $0x10,%esp
      state = 0;
 548:	be 00 00 00 00       	mov    $0x0,%esi
 54d:	e9 39 ff ff ff       	jmp    48b <printf+0x30>
        s = (char*)*ap;
 552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 555:	8b 30                	mov    (%eax),%esi
        ap++;
 557:	83 c0 04             	add    $0x4,%eax
 55a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 55d:	85 f6                	test   %esi,%esi
 55f:	75 28                	jne    589 <printf+0x12e>
          s = "(null)";
 561:	be 49 07 00 00       	mov    $0x749,%esi
 566:	8b 7d 08             	mov    0x8(%ebp),%edi
 569:	eb 0d                	jmp    578 <printf+0x11d>
          putc(fd, *s);
 56b:	0f be d2             	movsbl %dl,%edx
 56e:	89 f8                	mov    %edi,%eax
 570:	e8 45 fe ff ff       	call   3ba <putc>
          s++;
 575:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 578:	0f b6 16             	movzbl (%esi),%edx
 57b:	84 d2                	test   %dl,%dl
 57d:	75 ec                	jne    56b <printf+0x110>
      state = 0;
 57f:	be 00 00 00 00       	mov    $0x0,%esi
 584:	e9 02 ff ff ff       	jmp    48b <printf+0x30>
 589:	8b 7d 08             	mov    0x8(%ebp),%edi
 58c:	eb ea                	jmp    578 <printf+0x11d>
        putc(fd, *ap);
 58e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 591:	0f be 17             	movsbl (%edi),%edx
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	e8 1e fe ff ff       	call   3ba <putc>
        ap++;
 59c:	83 c7 04             	add    $0x4,%edi
 59f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5a2:	be 00 00 00 00       	mov    $0x0,%esi
 5a7:	e9 df fe ff ff       	jmp    48b <printf+0x30>
        putc(fd, c);
 5ac:	89 fa                	mov    %edi,%edx
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	e8 04 fe ff ff       	call   3ba <putc>
      state = 0;
 5b6:	be 00 00 00 00       	mov    $0x0,%esi
 5bb:	e9 cb fe ff ff       	jmp    48b <printf+0x30>
    }
  }
}
 5c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c3:	5b                   	pop    %ebx
 5c4:	5e                   	pop    %esi
 5c5:	5f                   	pop    %edi
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret    

000005c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c8:	f3 0f 1e fb          	endbr32 
 5cc:	55                   	push   %ebp
 5cd:	89 e5                	mov    %esp,%ebp
 5cf:	57                   	push   %edi
 5d0:	56                   	push   %esi
 5d1:	53                   	push   %ebx
 5d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d8:	a1 40 0a 00 00       	mov    0xa40,%eax
 5dd:	eb 02                	jmp    5e1 <free+0x19>
 5df:	89 d0                	mov    %edx,%eax
 5e1:	39 c8                	cmp    %ecx,%eax
 5e3:	73 04                	jae    5e9 <free+0x21>
 5e5:	39 08                	cmp    %ecx,(%eax)
 5e7:	77 12                	ja     5fb <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e9:	8b 10                	mov    (%eax),%edx
 5eb:	39 c2                	cmp    %eax,%edx
 5ed:	77 f0                	ja     5df <free+0x17>
 5ef:	39 c8                	cmp    %ecx,%eax
 5f1:	72 08                	jb     5fb <free+0x33>
 5f3:	39 ca                	cmp    %ecx,%edx
 5f5:	77 04                	ja     5fb <free+0x33>
 5f7:	89 d0                	mov    %edx,%eax
 5f9:	eb e6                	jmp    5e1 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5fb:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5fe:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 601:	8b 10                	mov    (%eax),%edx
 603:	39 d7                	cmp    %edx,%edi
 605:	74 19                	je     620 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 607:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 60a:	8b 50 04             	mov    0x4(%eax),%edx
 60d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 610:	39 ce                	cmp    %ecx,%esi
 612:	74 1b                	je     62f <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 614:	89 08                	mov    %ecx,(%eax)
  freep = p;
 616:	a3 40 0a 00 00       	mov    %eax,0xa40
}
 61b:	5b                   	pop    %ebx
 61c:	5e                   	pop    %esi
 61d:	5f                   	pop    %edi
 61e:	5d                   	pop    %ebp
 61f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 620:	03 72 04             	add    0x4(%edx),%esi
 623:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 626:	8b 10                	mov    (%eax),%edx
 628:	8b 12                	mov    (%edx),%edx
 62a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 62d:	eb db                	jmp    60a <free+0x42>
    p->s.size += bp->s.size;
 62f:	03 53 fc             	add    -0x4(%ebx),%edx
 632:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 635:	8b 53 f8             	mov    -0x8(%ebx),%edx
 638:	89 10                	mov    %edx,(%eax)
 63a:	eb da                	jmp    616 <free+0x4e>

0000063c <morecore>:

static Header*
morecore(uint nu)
{
 63c:	55                   	push   %ebp
 63d:	89 e5                	mov    %esp,%ebp
 63f:	53                   	push   %ebx
 640:	83 ec 04             	sub    $0x4,%esp
 643:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 645:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 64a:	77 05                	ja     651 <morecore+0x15>
    nu = 4096;
 64c:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 651:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 658:	83 ec 0c             	sub    $0xc,%esp
 65b:	50                   	push   %eax
 65c:	e8 31 fd ff ff       	call   392 <sbrk>
  if(p == (char*)-1)
 661:	83 c4 10             	add    $0x10,%esp
 664:	83 f8 ff             	cmp    $0xffffffff,%eax
 667:	74 1c                	je     685 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 669:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 66c:	83 c0 08             	add    $0x8,%eax
 66f:	83 ec 0c             	sub    $0xc,%esp
 672:	50                   	push   %eax
 673:	e8 50 ff ff ff       	call   5c8 <free>
  return freep;
 678:	a1 40 0a 00 00       	mov    0xa40,%eax
 67d:	83 c4 10             	add    $0x10,%esp
}
 680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 683:	c9                   	leave  
 684:	c3                   	ret    
    return 0;
 685:	b8 00 00 00 00       	mov    $0x0,%eax
 68a:	eb f4                	jmp    680 <morecore+0x44>

0000068c <malloc>:

void*
malloc(uint nbytes)
{
 68c:	f3 0f 1e fb          	endbr32 
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	53                   	push   %ebx
 694:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	8d 58 07             	lea    0x7(%eax),%ebx
 69d:	c1 eb 03             	shr    $0x3,%ebx
 6a0:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6a3:	8b 0d 40 0a 00 00    	mov    0xa40,%ecx
 6a9:	85 c9                	test   %ecx,%ecx
 6ab:	74 04                	je     6b1 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ad:	8b 01                	mov    (%ecx),%eax
 6af:	eb 4b                	jmp    6fc <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6b1:	c7 05 40 0a 00 00 44 	movl   $0xa44,0xa40
 6b8:	0a 00 00 
 6bb:	c7 05 44 0a 00 00 44 	movl   $0xa44,0xa44
 6c2:	0a 00 00 
    base.s.size = 0;
 6c5:	c7 05 48 0a 00 00 00 	movl   $0x0,0xa48
 6cc:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6cf:	b9 44 0a 00 00       	mov    $0xa44,%ecx
 6d4:	eb d7                	jmp    6ad <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6d6:	74 1a                	je     6f2 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6d8:	29 da                	sub    %ebx,%edx
 6da:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6dd:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6e0:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6e3:	89 0d 40 0a 00 00    	mov    %ecx,0xa40
      return (void*)(p + 1);
 6e9:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ec:	83 c4 04             	add    $0x4,%esp
 6ef:	5b                   	pop    %ebx
 6f0:	5d                   	pop    %ebp
 6f1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6f2:	8b 10                	mov    (%eax),%edx
 6f4:	89 11                	mov    %edx,(%ecx)
 6f6:	eb eb                	jmp    6e3 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f8:	89 c1                	mov    %eax,%ecx
 6fa:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6fc:	8b 50 04             	mov    0x4(%eax),%edx
 6ff:	39 da                	cmp    %ebx,%edx
 701:	73 d3                	jae    6d6 <malloc+0x4a>
    if(p == freep)
 703:	39 05 40 0a 00 00    	cmp    %eax,0xa40
 709:	75 ed                	jne    6f8 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 70b:	89 d8                	mov    %ebx,%eax
 70d:	e8 2a ff ff ff       	call   63c <morecore>
 712:	85 c0                	test   %eax,%eax
 714:	75 e2                	jne    6f8 <malloc+0x6c>
 716:	eb d4                	jmp    6ec <malloc+0x60>
