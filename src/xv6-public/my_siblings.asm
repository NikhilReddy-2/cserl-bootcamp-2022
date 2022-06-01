
_my_siblings:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

#define MAX_SZ 1000

int main(int argc, const char **argv)
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
  15:	83 ec 24             	sub    $0x24,%esp
  18:	8b 79 04             	mov    0x4(%ecx),%edi
	int n;
	n = atoi(argv[1]);
  1b:	ff 77 04             	pushl  0x4(%edi)
  1e:	e8 b3 02 00 00       	call   2d6 <atoi>
  23:	89 c6                	mov    %eax,%esi
	int procType[n];
  25:	8d 04 85 00 00 00 00 	lea    0x0(,%eax,4),%eax
  2c:	8d 48 0f             	lea    0xf(%eax),%ecx
  2f:	89 ca                	mov    %ecx,%edx
  31:	83 e2 f0             	and    $0xfffffff0,%edx
  34:	83 c4 10             	add    $0x10,%esp
  37:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  3d:	89 e3                	mov    %esp,%ebx
  3f:	29 cb                	sub    %ecx,%ebx
  41:	89 d9                	mov    %ebx,%ecx
  43:	39 cc                	cmp    %ecx,%esp
  45:	74 10                	je     57 <main+0x57>
  47:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  4d:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  54:	00 
  55:	eb ec                	jmp    43 <main+0x43>
  57:	89 d1                	mov    %edx,%ecx
  59:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
  5f:	29 cc                	sub    %ecx,%esp
  61:	85 c9                	test   %ecx,%ecx
  63:	74 05                	je     6a <main+0x6a>
  65:	83 4c 0c fc 00       	orl    $0x0,-0x4(%esp,%ecx,1)
  6a:	89 e2                	mov    %esp,%edx
  6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int pids[n];
  72:	83 c0 0f             	add    $0xf,%eax
  75:	89 c2                	mov    %eax,%edx
  77:	83 e2 f0             	and    $0xfffffff0,%edx
  7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  7f:	89 e1                	mov    %esp,%ecx
  81:	29 c1                	sub    %eax,%ecx
  83:	89 c8                	mov    %ecx,%eax
  85:	39 c4                	cmp    %eax,%esp
  87:	74 10                	je     99 <main+0x99>
  89:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8f:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  96:	00 
  97:	eb ec                	jmp    85 <main+0x85>
  99:	89 d0                	mov    %edx,%eax
  9b:	25 ff 0f 00 00       	and    $0xfff,%eax
  a0:	29 c4                	sub    %eax,%esp
  a2:	85 c0                	test   %eax,%eax
  a4:	74 05                	je     ab <main+0xab>
  a6:	83 4c 04 fc 00       	orl    $0x0,-0x4(%esp,%eax,1)
  ab:	89 65 e0             	mov    %esp,-0x20(%ebp)
	int i;
	// Set the Process types
	for(i=0; i<n; i++)
  ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  b3:	eb 18                	jmp    cd <main+0xcd>
	{
		procType[i] = atoi(argv[i+2]);
  b5:	83 ec 0c             	sub    $0xc,%esp
  b8:	ff 74 9f 08          	pushl  0x8(%edi,%ebx,4)
  bc:	e8 15 02 00 00       	call   2d6 <atoi>
  c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  c4:	89 04 99             	mov    %eax,(%ecx,%ebx,4)
	for(i=0; i<n; i++)
  c7:	83 c3 01             	add    $0x1,%ebx
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	39 f3                	cmp    %esi,%ebx
  cf:	7c e4                	jl     b5 <main+0xb5>
	}
	// Execute the children programmes
	for(i=0;i<n;i++)
  d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  d9:	eb 2b                	jmp    106 <main+0x106>
	{
		int ret;
		ret = fork();
		if(ret == 0)
		{
			if(procType[i] == 0)
  db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  de:	8b 04 98             	mov    (%eax,%ebx,4),%eax
  e1:	85 c0                	test   %eax,%eax
  e3:	74 0a                	je     ef <main+0xef>
			{
				sleep(10000);
			}
			else if (procType[i] == 1)
  e5:	83 f8 01             	cmp    $0x1,%eax
  e8:	74 17                	je     101 <main+0x101>
			{
				while(1){}
			}
			exit();
  ea:	e8 51 02 00 00       	call   340 <exit>
				sleep(10000);
  ef:	83 ec 0c             	sub    $0xc,%esp
  f2:	68 10 27 00 00       	push   $0x2710
  f7:	e8 d4 02 00 00       	call   3d0 <sleep>
  fc:	83 c4 10             	add    $0x10,%esp
  ff:	eb e9                	jmp    ea <main+0xea>
				while(1){}
 101:	eb fe                	jmp    101 <main+0x101>
	for(i=0;i<n;i++)
 103:	83 c3 01             	add    $0x1,%ebx
 106:	39 f3                	cmp    %esi,%ebx
 108:	7d 10                	jge    11a <main+0x11a>
		ret = fork();
 10a:	e8 29 02 00 00       	call   338 <fork>
		if(ret == 0)
 10f:	85 c0                	test   %eax,%eax
 111:	74 c8                	je     db <main+0xdb>
		}
		else if(ret>0) pids[i] = ret;
 113:	7e ee                	jle    103 <main+0x103>
 115:	89 04 9f             	mov    %eax,(%edi,%ebx,4)
 118:	eb e9                	jmp    103 <main+0x103>
	}

	int ret;
	ret = fork();
 11a:	e8 19 02 00 00       	call   338 <fork>
	if(ret == 0)
 11f:	85 c0                	test   %eax,%eax
 121:	75 14                	jne    137 <main+0x137>
	{
		sleep(100);
 123:	83 ec 0c             	sub    $0xc,%esp
 126:	6a 64                	push   $0x64
 128:	e8 a3 02 00 00       	call   3d0 <sleep>
		get_siblings_info();
 12d:	e8 ae 02 00 00       	call   3e0 <get_siblings_info>
		exit();
 132:	e8 09 02 00 00       	call   340 <exit>
	}

	// Wait for the last child
	sleep(200);
 137:	83 ec 0c             	sub    $0xc,%esp
 13a:	68 c8 00 00 00       	push   $0xc8
 13f:	e8 8c 02 00 00       	call   3d0 <sleep>
	wait();
 144:	e8 ff 01 00 00       	call   348 <wait>

	for (i = 0; i < n; i++)
 149:	83 c4 10             	add    $0x10,%esp
 14c:	bb 00 00 00 00       	mov    $0x0,%ebx
 151:	eb 14                	jmp    167 <main+0x167>
	{
		kill(pids[i]);
 153:	83 ec 0c             	sub    $0xc,%esp
 156:	8b 45 e0             	mov    -0x20(%ebp),%eax
 159:	ff 34 98             	pushl  (%eax,%ebx,4)
 15c:	e8 0f 02 00 00       	call   370 <kill>
	for (i = 0; i < n; i++)
 161:	83 c3 01             	add    $0x1,%ebx
 164:	83 c4 10             	add    $0x10,%esp
 167:	39 f3                	cmp    %esi,%ebx
 169:	7c e8                	jl     153 <main+0x153>
	}

	for(i = 0; i< n; i++)
 16b:	bb 00 00 00 00       	mov    $0x0,%ebx
 170:	eb 08                	jmp    17a <main+0x17a>
		wait();
 172:	e8 d1 01 00 00       	call   348 <wait>
	for(i = 0; i< n; i++)
 177:	83 c3 01             	add    $0x1,%ebx
 17a:	39 f3                	cmp    %esi,%ebx
 17c:	7c f4                	jl     172 <main+0x172>

	exit();
 17e:	e8 bd 01 00 00       	call   340 <exit>

00000183 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 183:	f3 0f 1e fb          	endbr32 
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	56                   	push   %esi
 18b:	53                   	push   %ebx
 18c:	8b 75 08             	mov    0x8(%ebp),%esi
 18f:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 192:	89 f0                	mov    %esi,%eax
 194:	89 d1                	mov    %edx,%ecx
 196:	83 c2 01             	add    $0x1,%edx
 199:	89 c3                	mov    %eax,%ebx
 19b:	83 c0 01             	add    $0x1,%eax
 19e:	0f b6 09             	movzbl (%ecx),%ecx
 1a1:	88 0b                	mov    %cl,(%ebx)
 1a3:	84 c9                	test   %cl,%cl
 1a5:	75 ed                	jne    194 <strcpy+0x11>
    ;
  return os;
}
 1a7:	89 f0                	mov    %esi,%eax
 1a9:	5b                   	pop    %ebx
 1aa:	5e                   	pop    %esi
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    

000001ad <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ad:	f3 0f 1e fb          	endbr32 
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1ba:	0f b6 01             	movzbl (%ecx),%eax
 1bd:	84 c0                	test   %al,%al
 1bf:	74 0c                	je     1cd <strcmp+0x20>
 1c1:	3a 02                	cmp    (%edx),%al
 1c3:	75 08                	jne    1cd <strcmp+0x20>
    p++, q++;
 1c5:	83 c1 01             	add    $0x1,%ecx
 1c8:	83 c2 01             	add    $0x1,%edx
 1cb:	eb ed                	jmp    1ba <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1cd:	0f b6 c0             	movzbl %al,%eax
 1d0:	0f b6 12             	movzbl (%edx),%edx
 1d3:	29 d0                	sub    %edx,%eax
}
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    

000001d7 <strlen>:

uint
strlen(const char *s)
{
 1d7:	f3 0f 1e fb          	endbr32 
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e1:	b8 00 00 00 00       	mov    $0x0,%eax
 1e6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1ea:	74 05                	je     1f1 <strlen+0x1a>
 1ec:	83 c0 01             	add    $0x1,%eax
 1ef:	eb f5                	jmp    1e6 <strlen+0xf>
    ;
  return n;
}
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    

000001f3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f3:	f3 0f 1e fb          	endbr32 
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	57                   	push   %edi
 1fb:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1fe:	89 d7                	mov    %edx,%edi
 200:	8b 4d 10             	mov    0x10(%ebp),%ecx
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	fc                   	cld    
 207:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 209:	89 d0                	mov    %edx,%eax
 20b:	5f                   	pop    %edi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    

0000020e <strchr>:

char*
strchr(const char *s, char c)
{
 20e:	f3 0f 1e fb          	endbr32 
 212:	55                   	push   %ebp
 213:	89 e5                	mov    %esp,%ebp
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 21c:	0f b6 10             	movzbl (%eax),%edx
 21f:	84 d2                	test   %dl,%dl
 221:	74 09                	je     22c <strchr+0x1e>
    if(*s == c)
 223:	38 ca                	cmp    %cl,%dl
 225:	74 0a                	je     231 <strchr+0x23>
  for(; *s; s++)
 227:	83 c0 01             	add    $0x1,%eax
 22a:	eb f0                	jmp    21c <strchr+0xe>
      return (char*)s;
  return 0;
 22c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    

00000233 <gets>:

char*
gets(char *buf, int max)
{
 233:	f3 0f 1e fb          	endbr32 
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	57                   	push   %edi
 23b:	56                   	push   %esi
 23c:	53                   	push   %ebx
 23d:	83 ec 1c             	sub    $0x1c,%esp
 240:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 243:	bb 00 00 00 00       	mov    $0x0,%ebx
 248:	89 de                	mov    %ebx,%esi
 24a:	83 c3 01             	add    $0x1,%ebx
 24d:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 250:	7d 2e                	jge    280 <gets+0x4d>
    cc = read(0, &c, 1);
 252:	83 ec 04             	sub    $0x4,%esp
 255:	6a 01                	push   $0x1
 257:	8d 45 e7             	lea    -0x19(%ebp),%eax
 25a:	50                   	push   %eax
 25b:	6a 00                	push   $0x0
 25d:	e8 f6 00 00 00       	call   358 <read>
    if(cc < 1)
 262:	83 c4 10             	add    $0x10,%esp
 265:	85 c0                	test   %eax,%eax
 267:	7e 17                	jle    280 <gets+0x4d>
      break;
    buf[i++] = c;
 269:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 26d:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 270:	3c 0a                	cmp    $0xa,%al
 272:	0f 94 c2             	sete   %dl
 275:	3c 0d                	cmp    $0xd,%al
 277:	0f 94 c0             	sete   %al
 27a:	08 c2                	or     %al,%dl
 27c:	74 ca                	je     248 <gets+0x15>
    buf[i++] = c;
 27e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 280:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 284:	89 f8                	mov    %edi,%eax
 286:	8d 65 f4             	lea    -0xc(%ebp),%esp
 289:	5b                   	pop    %ebx
 28a:	5e                   	pop    %esi
 28b:	5f                   	pop    %edi
 28c:	5d                   	pop    %ebp
 28d:	c3                   	ret    

0000028e <stat>:

int
stat(const char *n, struct stat *st)
{
 28e:	f3 0f 1e fb          	endbr32 
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	56                   	push   %esi
 296:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 297:	83 ec 08             	sub    $0x8,%esp
 29a:	6a 00                	push   $0x0
 29c:	ff 75 08             	pushl  0x8(%ebp)
 29f:	e8 dc 00 00 00       	call   380 <open>
  if(fd < 0)
 2a4:	83 c4 10             	add    $0x10,%esp
 2a7:	85 c0                	test   %eax,%eax
 2a9:	78 24                	js     2cf <stat+0x41>
 2ab:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	50                   	push   %eax
 2b4:	e8 df 00 00 00       	call   398 <fstat>
 2b9:	89 c6                	mov    %eax,%esi
  close(fd);
 2bb:	89 1c 24             	mov    %ebx,(%esp)
 2be:	e8 a5 00 00 00       	call   368 <close>
  return r;
 2c3:	83 c4 10             	add    $0x10,%esp
}
 2c6:	89 f0                	mov    %esi,%eax
 2c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2cb:	5b                   	pop    %ebx
 2cc:	5e                   	pop    %esi
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    
    return -1;
 2cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2d4:	eb f0                	jmp    2c6 <stat+0x38>

000002d6 <atoi>:

int
atoi(const char *s)
{
 2d6:	f3 0f 1e fb          	endbr32 
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	53                   	push   %ebx
 2de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2e1:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2e6:	0f b6 01             	movzbl (%ecx),%eax
 2e9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2ec:	80 fb 09             	cmp    $0x9,%bl
 2ef:	77 12                	ja     303 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 2f1:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 2f4:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 2f7:	83 c1 01             	add    $0x1,%ecx
 2fa:	0f be c0             	movsbl %al,%eax
 2fd:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 301:	eb e3                	jmp    2e6 <atoi+0x10>
  return n;
}
 303:	89 d0                	mov    %edx,%eax
 305:	5b                   	pop    %ebx
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    

00000308 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 308:	f3 0f 1e fb          	endbr32 
 30c:	55                   	push   %ebp
 30d:	89 e5                	mov    %esp,%ebp
 30f:	56                   	push   %esi
 310:	53                   	push   %ebx
 311:	8b 75 08             	mov    0x8(%ebp),%esi
 314:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 317:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 31a:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 31c:	8d 58 ff             	lea    -0x1(%eax),%ebx
 31f:	85 c0                	test   %eax,%eax
 321:	7e 0f                	jle    332 <memmove+0x2a>
    *dst++ = *src++;
 323:	0f b6 01             	movzbl (%ecx),%eax
 326:	88 02                	mov    %al,(%edx)
 328:	8d 49 01             	lea    0x1(%ecx),%ecx
 32b:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 32e:	89 d8                	mov    %ebx,%eax
 330:	eb ea                	jmp    31c <memmove+0x14>
  return vdst;
}
 332:	89 f0                	mov    %esi,%eax
 334:	5b                   	pop    %ebx
 335:	5e                   	pop    %esi
 336:	5d                   	pop    %ebp
 337:	c3                   	ret    

00000338 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 338:	b8 01 00 00 00       	mov    $0x1,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <exit>:
SYSCALL(exit)
 340:	b8 02 00 00 00       	mov    $0x2,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <wait>:
SYSCALL(wait)
 348:	b8 03 00 00 00       	mov    $0x3,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <pipe>:
SYSCALL(pipe)
 350:	b8 04 00 00 00       	mov    $0x4,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <read>:
SYSCALL(read)
 358:	b8 05 00 00 00       	mov    $0x5,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <write>:
SYSCALL(write)
 360:	b8 10 00 00 00       	mov    $0x10,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <close>:
SYSCALL(close)
 368:	b8 15 00 00 00       	mov    $0x15,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <kill>:
SYSCALL(kill)
 370:	b8 06 00 00 00       	mov    $0x6,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <exec>:
SYSCALL(exec)
 378:	b8 07 00 00 00       	mov    $0x7,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <open>:
SYSCALL(open)
 380:	b8 0f 00 00 00       	mov    $0xf,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <mknod>:
SYSCALL(mknod)
 388:	b8 11 00 00 00       	mov    $0x11,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <unlink>:
SYSCALL(unlink)
 390:	b8 12 00 00 00       	mov    $0x12,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <fstat>:
SYSCALL(fstat)
 398:	b8 08 00 00 00       	mov    $0x8,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <link>:
SYSCALL(link)
 3a0:	b8 13 00 00 00       	mov    $0x13,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <mkdir>:
SYSCALL(mkdir)
 3a8:	b8 14 00 00 00       	mov    $0x14,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <chdir>:
SYSCALL(chdir)
 3b0:	b8 09 00 00 00       	mov    $0x9,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <dup>:
SYSCALL(dup)
 3b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <getpid>:
SYSCALL(getpid)
 3c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <sbrk>:
SYSCALL(sbrk)
 3c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <sleep>:
SYSCALL(sleep)
 3d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <uptime>:
SYSCALL(uptime)
 3d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <get_siblings_info>:
SYSCALL(get_siblings_info)
 3e0:	b8 16 00 00 00       	mov    $0x16,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <get_ancestors>:
SYSCALL(get_ancestors)
 3e8:	b8 17 00 00 00       	mov    $0x17,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	83 ec 1c             	sub    $0x1c,%esp
 3f6:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3f9:	6a 01                	push   $0x1
 3fb:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3fe:	52                   	push   %edx
 3ff:	50                   	push   %eax
 400:	e8 5b ff ff ff       	call   360 <write>
}
 405:	83 c4 10             	add    $0x10,%esp
 408:	c9                   	leave  
 409:	c3                   	ret    

0000040a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40a:	55                   	push   %ebp
 40b:	89 e5                	mov    %esp,%ebp
 40d:	57                   	push   %edi
 40e:	56                   	push   %esi
 40f:	53                   	push   %ebx
 410:	83 ec 2c             	sub    $0x2c,%esp
 413:	89 45 d0             	mov    %eax,-0x30(%ebp)
 416:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 418:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 41c:	0f 95 c2             	setne  %dl
 41f:	89 f0                	mov    %esi,%eax
 421:	c1 e8 1f             	shr    $0x1f,%eax
 424:	84 c2                	test   %al,%dl
 426:	74 42                	je     46a <printint+0x60>
    neg = 1;
    x = -xx;
 428:	f7 de                	neg    %esi
    neg = 1;
 42a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 431:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 436:	89 f0                	mov    %esi,%eax
 438:	ba 00 00 00 00       	mov    $0x0,%edx
 43d:	f7 f1                	div    %ecx
 43f:	89 df                	mov    %ebx,%edi
 441:	83 c3 01             	add    $0x1,%ebx
 444:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
 44b:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 44f:	89 f2                	mov    %esi,%edx
 451:	89 c6                	mov    %eax,%esi
 453:	39 d1                	cmp    %edx,%ecx
 455:	76 df                	jbe    436 <printint+0x2c>
  if(neg)
 457:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 45b:	74 2f                	je     48c <printint+0x82>
    buf[i++] = '-';
 45d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 462:	8d 5f 02             	lea    0x2(%edi),%ebx
 465:	8b 75 d0             	mov    -0x30(%ebp),%esi
 468:	eb 15                	jmp    47f <printint+0x75>
  neg = 0;
 46a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 471:	eb be                	jmp    431 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 473:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 478:	89 f0                	mov    %esi,%eax
 47a:	e8 71 ff ff ff       	call   3f0 <putc>
  while(--i >= 0)
 47f:	83 eb 01             	sub    $0x1,%ebx
 482:	79 ef                	jns    473 <printint+0x69>
}
 484:	83 c4 2c             	add    $0x2c,%esp
 487:	5b                   	pop    %ebx
 488:	5e                   	pop    %esi
 489:	5f                   	pop    %edi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    
 48c:	8b 75 d0             	mov    -0x30(%ebp),%esi
 48f:	eb ee                	jmp    47f <printint+0x75>

00000491 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 491:	f3 0f 1e fb          	endbr32 
 495:	55                   	push   %ebp
 496:	89 e5                	mov    %esp,%ebp
 498:	57                   	push   %edi
 499:	56                   	push   %esi
 49a:	53                   	push   %ebx
 49b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 49e:	8d 45 10             	lea    0x10(%ebp),%eax
 4a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4a4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4a9:	bb 00 00 00 00       	mov    $0x0,%ebx
 4ae:	eb 14                	jmp    4c4 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4b0:	89 fa                	mov    %edi,%edx
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	e8 36 ff ff ff       	call   3f0 <putc>
 4ba:	eb 05                	jmp    4c1 <printf+0x30>
      }
    } else if(state == '%'){
 4bc:	83 fe 25             	cmp    $0x25,%esi
 4bf:	74 25                	je     4e6 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4c1:	83 c3 01             	add    $0x1,%ebx
 4c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c7:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4cb:	84 c0                	test   %al,%al
 4cd:	0f 84 23 01 00 00    	je     5f6 <printf+0x165>
    c = fmt[i] & 0xff;
 4d3:	0f be f8             	movsbl %al,%edi
 4d6:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4d9:	85 f6                	test   %esi,%esi
 4db:	75 df                	jne    4bc <printf+0x2b>
      if(c == '%'){
 4dd:	83 f8 25             	cmp    $0x25,%eax
 4e0:	75 ce                	jne    4b0 <printf+0x1f>
        state = '%';
 4e2:	89 c6                	mov    %eax,%esi
 4e4:	eb db                	jmp    4c1 <printf+0x30>
      if(c == 'd'){
 4e6:	83 f8 64             	cmp    $0x64,%eax
 4e9:	74 49                	je     534 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4eb:	83 f8 78             	cmp    $0x78,%eax
 4ee:	0f 94 c1             	sete   %cl
 4f1:	83 f8 70             	cmp    $0x70,%eax
 4f4:	0f 94 c2             	sete   %dl
 4f7:	08 d1                	or     %dl,%cl
 4f9:	75 63                	jne    55e <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4fb:	83 f8 73             	cmp    $0x73,%eax
 4fe:	0f 84 84 00 00 00    	je     588 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 504:	83 f8 63             	cmp    $0x63,%eax
 507:	0f 84 b7 00 00 00    	je     5c4 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 50d:	83 f8 25             	cmp    $0x25,%eax
 510:	0f 84 cc 00 00 00    	je     5e2 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 516:	ba 25 00 00 00       	mov    $0x25,%edx
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	e8 cd fe ff ff       	call   3f0 <putc>
        putc(fd, c);
 523:	89 fa                	mov    %edi,%edx
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	e8 c3 fe ff ff       	call   3f0 <putc>
      }
      state = 0;
 52d:	be 00 00 00 00       	mov    $0x0,%esi
 532:	eb 8d                	jmp    4c1 <printf+0x30>
        printint(fd, *ap, 10, 1);
 534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 537:	8b 17                	mov    (%edi),%edx
 539:	83 ec 0c             	sub    $0xc,%esp
 53c:	6a 01                	push   $0x1
 53e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	e8 bf fe ff ff       	call   40a <printint>
        ap++;
 54b:	83 c7 04             	add    $0x4,%edi
 54e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 551:	83 c4 10             	add    $0x10,%esp
      state = 0;
 554:	be 00 00 00 00       	mov    $0x0,%esi
 559:	e9 63 ff ff ff       	jmp    4c1 <printf+0x30>
        printint(fd, *ap, 16, 0);
 55e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 561:	8b 17                	mov    (%edi),%edx
 563:	83 ec 0c             	sub    $0xc,%esp
 566:	6a 00                	push   $0x0
 568:	b9 10 00 00 00       	mov    $0x10,%ecx
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	e8 95 fe ff ff       	call   40a <printint>
        ap++;
 575:	83 c7 04             	add    $0x4,%edi
 578:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 57b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 57e:	be 00 00 00 00       	mov    $0x0,%esi
 583:	e9 39 ff ff ff       	jmp    4c1 <printf+0x30>
        s = (char*)*ap;
 588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58b:	8b 30                	mov    (%eax),%esi
        ap++;
 58d:	83 c0 04             	add    $0x4,%eax
 590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 593:	85 f6                	test   %esi,%esi
 595:	75 28                	jne    5bf <printf+0x12e>
          s = "(null)";
 597:	be 50 07 00 00       	mov    $0x750,%esi
 59c:	8b 7d 08             	mov    0x8(%ebp),%edi
 59f:	eb 0d                	jmp    5ae <printf+0x11d>
          putc(fd, *s);
 5a1:	0f be d2             	movsbl %dl,%edx
 5a4:	89 f8                	mov    %edi,%eax
 5a6:	e8 45 fe ff ff       	call   3f0 <putc>
          s++;
 5ab:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5ae:	0f b6 16             	movzbl (%esi),%edx
 5b1:	84 d2                	test   %dl,%dl
 5b3:	75 ec                	jne    5a1 <printf+0x110>
      state = 0;
 5b5:	be 00 00 00 00       	mov    $0x0,%esi
 5ba:	e9 02 ff ff ff       	jmp    4c1 <printf+0x30>
 5bf:	8b 7d 08             	mov    0x8(%ebp),%edi
 5c2:	eb ea                	jmp    5ae <printf+0x11d>
        putc(fd, *ap);
 5c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5c7:	0f be 17             	movsbl (%edi),%edx
 5ca:	8b 45 08             	mov    0x8(%ebp),%eax
 5cd:	e8 1e fe ff ff       	call   3f0 <putc>
        ap++;
 5d2:	83 c7 04             	add    $0x4,%edi
 5d5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5d8:	be 00 00 00 00       	mov    $0x0,%esi
 5dd:	e9 df fe ff ff       	jmp    4c1 <printf+0x30>
        putc(fd, c);
 5e2:	89 fa                	mov    %edi,%edx
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	e8 04 fe ff ff       	call   3f0 <putc>
      state = 0;
 5ec:	be 00 00 00 00       	mov    $0x0,%esi
 5f1:	e9 cb fe ff ff       	jmp    4c1 <printf+0x30>
    }
  }
}
 5f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f9:	5b                   	pop    %ebx
 5fa:	5e                   	pop    %esi
 5fb:	5f                   	pop    %edi
 5fc:	5d                   	pop    %ebp
 5fd:	c3                   	ret    

000005fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fe:	f3 0f 1e fb          	endbr32 
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	57                   	push   %edi
 606:	56                   	push   %esi
 607:	53                   	push   %ebx
 608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60e:	a1 04 0a 00 00       	mov    0xa04,%eax
 613:	eb 02                	jmp    617 <free+0x19>
 615:	89 d0                	mov    %edx,%eax
 617:	39 c8                	cmp    %ecx,%eax
 619:	73 04                	jae    61f <free+0x21>
 61b:	39 08                	cmp    %ecx,(%eax)
 61d:	77 12                	ja     631 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61f:	8b 10                	mov    (%eax),%edx
 621:	39 c2                	cmp    %eax,%edx
 623:	77 f0                	ja     615 <free+0x17>
 625:	39 c8                	cmp    %ecx,%eax
 627:	72 08                	jb     631 <free+0x33>
 629:	39 ca                	cmp    %ecx,%edx
 62b:	77 04                	ja     631 <free+0x33>
 62d:	89 d0                	mov    %edx,%eax
 62f:	eb e6                	jmp    617 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 631:	8b 73 fc             	mov    -0x4(%ebx),%esi
 634:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 637:	8b 10                	mov    (%eax),%edx
 639:	39 d7                	cmp    %edx,%edi
 63b:	74 19                	je     656 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 63d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 640:	8b 50 04             	mov    0x4(%eax),%edx
 643:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 646:	39 ce                	cmp    %ecx,%esi
 648:	74 1b                	je     665 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 64a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 64c:	a3 04 0a 00 00       	mov    %eax,0xa04
}
 651:	5b                   	pop    %ebx
 652:	5e                   	pop    %esi
 653:	5f                   	pop    %edi
 654:	5d                   	pop    %ebp
 655:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 656:	03 72 04             	add    0x4(%edx),%esi
 659:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 65c:	8b 10                	mov    (%eax),%edx
 65e:	8b 12                	mov    (%edx),%edx
 660:	89 53 f8             	mov    %edx,-0x8(%ebx)
 663:	eb db                	jmp    640 <free+0x42>
    p->s.size += bp->s.size;
 665:	03 53 fc             	add    -0x4(%ebx),%edx
 668:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 66b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 66e:	89 10                	mov    %edx,(%eax)
 670:	eb da                	jmp    64c <free+0x4e>

00000672 <morecore>:

static Header*
morecore(uint nu)
{
 672:	55                   	push   %ebp
 673:	89 e5                	mov    %esp,%ebp
 675:	53                   	push   %ebx
 676:	83 ec 04             	sub    $0x4,%esp
 679:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 67b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 680:	77 05                	ja     687 <morecore+0x15>
    nu = 4096;
 682:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 687:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 68e:	83 ec 0c             	sub    $0xc,%esp
 691:	50                   	push   %eax
 692:	e8 31 fd ff ff       	call   3c8 <sbrk>
  if(p == (char*)-1)
 697:	83 c4 10             	add    $0x10,%esp
 69a:	83 f8 ff             	cmp    $0xffffffff,%eax
 69d:	74 1c                	je     6bb <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 69f:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6a2:	83 c0 08             	add    $0x8,%eax
 6a5:	83 ec 0c             	sub    $0xc,%esp
 6a8:	50                   	push   %eax
 6a9:	e8 50 ff ff ff       	call   5fe <free>
  return freep;
 6ae:	a1 04 0a 00 00       	mov    0xa04,%eax
 6b3:	83 c4 10             	add    $0x10,%esp
}
 6b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6b9:	c9                   	leave  
 6ba:	c3                   	ret    
    return 0;
 6bb:	b8 00 00 00 00       	mov    $0x0,%eax
 6c0:	eb f4                	jmp    6b6 <morecore+0x44>

000006c2 <malloc>:

void*
malloc(uint nbytes)
{
 6c2:	f3 0f 1e fb          	endbr32 
 6c6:	55                   	push   %ebp
 6c7:	89 e5                	mov    %esp,%ebp
 6c9:	53                   	push   %ebx
 6ca:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	8d 58 07             	lea    0x7(%eax),%ebx
 6d3:	c1 eb 03             	shr    $0x3,%ebx
 6d6:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6d9:	8b 0d 04 0a 00 00    	mov    0xa04,%ecx
 6df:	85 c9                	test   %ecx,%ecx
 6e1:	74 04                	je     6e7 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e3:	8b 01                	mov    (%ecx),%eax
 6e5:	eb 4b                	jmp    732 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6e7:	c7 05 04 0a 00 00 08 	movl   $0xa08,0xa04
 6ee:	0a 00 00 
 6f1:	c7 05 08 0a 00 00 08 	movl   $0xa08,0xa08
 6f8:	0a 00 00 
    base.s.size = 0;
 6fb:	c7 05 0c 0a 00 00 00 	movl   $0x0,0xa0c
 702:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 705:	b9 08 0a 00 00       	mov    $0xa08,%ecx
 70a:	eb d7                	jmp    6e3 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 70c:	74 1a                	je     728 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 70e:	29 da                	sub    %ebx,%edx
 710:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 713:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 716:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 719:	89 0d 04 0a 00 00    	mov    %ecx,0xa04
      return (void*)(p + 1);
 71f:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 722:	83 c4 04             	add    $0x4,%esp
 725:	5b                   	pop    %ebx
 726:	5d                   	pop    %ebp
 727:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 728:	8b 10                	mov    (%eax),%edx
 72a:	89 11                	mov    %edx,(%ecx)
 72c:	eb eb                	jmp    719 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	89 c1                	mov    %eax,%ecx
 730:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 732:	8b 50 04             	mov    0x4(%eax),%edx
 735:	39 da                	cmp    %ebx,%edx
 737:	73 d3                	jae    70c <malloc+0x4a>
    if(p == freep)
 739:	39 05 04 0a 00 00    	cmp    %eax,0xa04
 73f:	75 ed                	jne    72e <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 741:	89 d8                	mov    %ebx,%eax
 743:	e8 2a ff ff ff       	call   672 <morecore>
 748:	85 c0                	test   %eax,%eax
 74a:	75 e2                	jne    72e <malloc+0x6c>
 74c:	eb d4                	jmp    722 <malloc+0x60>
