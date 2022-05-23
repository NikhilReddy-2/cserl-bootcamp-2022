
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	57                   	push   %edi
   8:	56                   	push   %esi
   9:	53                   	push   %ebx
   a:	83 ec 0c             	sub    $0xc,%esp
   d:	8b 75 08             	mov    0x8(%ebp),%esi
  10:	8b 7d 0c             	mov    0xc(%ebp),%edi
  13:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  16:	83 ec 08             	sub    $0x8,%esp
  19:	53                   	push   %ebx
  1a:	57                   	push   %edi
  1b:	e8 2c 00 00 00       	call   4c <matchhere>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	75 18                	jne    3f <matchstar+0x3f>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  27:	0f b6 13             	movzbl (%ebx),%edx
  2a:	84 d2                	test   %dl,%dl
  2c:	74 16                	je     44 <matchstar+0x44>
  2e:	83 c3 01             	add    $0x1,%ebx
  31:	0f be d2             	movsbl %dl,%edx
  34:	39 f2                	cmp    %esi,%edx
  36:	74 de                	je     16 <matchstar+0x16>
  38:	83 fe 2e             	cmp    $0x2e,%esi
  3b:	74 d9                	je     16 <matchstar+0x16>
  3d:	eb 05                	jmp    44 <matchstar+0x44>
      return 1;
  3f:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  47:	5b                   	pop    %ebx
  48:	5e                   	pop    %esi
  49:	5f                   	pop    %edi
  4a:	5d                   	pop    %ebp
  4b:	c3                   	ret    

0000004c <matchhere>:
{
  4c:	f3 0f 1e fb          	endbr32 
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	83 ec 08             	sub    $0x8,%esp
  56:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  59:	0f b6 02             	movzbl (%edx),%eax
  5c:	84 c0                	test   %al,%al
  5e:	74 68                	je     c8 <matchhere+0x7c>
  if(re[1] == '*')
  60:	0f b6 4a 01          	movzbl 0x1(%edx),%ecx
  64:	80 f9 2a             	cmp    $0x2a,%cl
  67:	74 1d                	je     86 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  69:	3c 24                	cmp    $0x24,%al
  6b:	74 31                	je     9e <matchhere+0x52>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  70:	0f b6 09             	movzbl (%ecx),%ecx
  73:	84 c9                	test   %cl,%cl
  75:	74 58                	je     cf <matchhere+0x83>
  77:	3c 2e                	cmp    $0x2e,%al
  79:	74 35                	je     b0 <matchhere+0x64>
  7b:	38 c8                	cmp    %cl,%al
  7d:	74 31                	je     b0 <matchhere+0x64>
  return 0;
  7f:	b8 00 00 00 00       	mov    $0x0,%eax
  84:	eb 47                	jmp    cd <matchhere+0x81>
    return matchstar(re[0], re+2, text);
  86:	83 ec 04             	sub    $0x4,%esp
  89:	ff 75 0c             	pushl  0xc(%ebp)
  8c:	83 c2 02             	add    $0x2,%edx
  8f:	52                   	push   %edx
  90:	0f be c0             	movsbl %al,%eax
  93:	50                   	push   %eax
  94:	e8 67 ff ff ff       	call   0 <matchstar>
  99:	83 c4 10             	add    $0x10,%esp
  9c:	eb 2f                	jmp    cd <matchhere+0x81>
  if(re[0] == '$' && re[1] == '\0')
  9e:	84 c9                	test   %cl,%cl
  a0:	75 cb                	jne    6d <matchhere+0x21>
    return *text == '\0';
  a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  a5:	80 38 00             	cmpb   $0x0,(%eax)
  a8:	0f 94 c0             	sete   %al
  ab:	0f b6 c0             	movzbl %al,%eax
  ae:	eb 1d                	jmp    cd <matchhere+0x81>
    return matchhere(re+1, text+1);
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  b6:	83 c0 01             	add    $0x1,%eax
  b9:	50                   	push   %eax
  ba:	83 c2 01             	add    $0x1,%edx
  bd:	52                   	push   %edx
  be:	e8 89 ff ff ff       	call   4c <matchhere>
  c3:	83 c4 10             	add    $0x10,%esp
  c6:	eb 05                	jmp    cd <matchhere+0x81>
    return 1;
  c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  cd:	c9                   	leave  
  ce:	c3                   	ret    
  return 0;
  cf:	b8 00 00 00 00       	mov    $0x0,%eax
  d4:	eb f7                	jmp    cd <matchhere+0x81>

000000d6 <match>:
{
  d6:	f3 0f 1e fb          	endbr32 
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	56                   	push   %esi
  de:	53                   	push   %ebx
  df:	8b 75 08             	mov    0x8(%ebp),%esi
  e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  e5:	80 3e 5e             	cmpb   $0x5e,(%esi)
  e8:	75 14                	jne    fe <match+0x28>
    return matchhere(re+1, text);
  ea:	83 ec 08             	sub    $0x8,%esp
  ed:	53                   	push   %ebx
  ee:	83 c6 01             	add    $0x1,%esi
  f1:	56                   	push   %esi
  f2:	e8 55 ff ff ff       	call   4c <matchhere>
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	eb 22                	jmp    11e <match+0x48>
  }while(*text++ != '\0');
  fc:	89 d3                	mov    %edx,%ebx
    if(matchhere(re, text))
  fe:	83 ec 08             	sub    $0x8,%esp
 101:	53                   	push   %ebx
 102:	56                   	push   %esi
 103:	e8 44 ff ff ff       	call   4c <matchhere>
 108:	83 c4 10             	add    $0x10,%esp
 10b:	85 c0                	test   %eax,%eax
 10d:	75 0a                	jne    119 <match+0x43>
  }while(*text++ != '\0');
 10f:	8d 53 01             	lea    0x1(%ebx),%edx
 112:	80 3b 00             	cmpb   $0x0,(%ebx)
 115:	75 e5                	jne    fc <match+0x26>
 117:	eb 05                	jmp    11e <match+0x48>
      return 1;
 119:	b8 01 00 00 00       	mov    $0x1,%eax
}
 11e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 121:	5b                   	pop    %ebx
 122:	5e                   	pop    %esi
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <grep>:
{
 125:	f3 0f 1e fb          	endbr32 
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
 12c:	57                   	push   %edi
 12d:	56                   	push   %esi
 12e:	53                   	push   %ebx
 12f:	83 ec 1c             	sub    $0x1c,%esp
 132:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
 135:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13c:	eb 53                	jmp    191 <grep+0x6c>
        *q = '\n';
 13e:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 141:	8d 43 01             	lea    0x1(%ebx),%eax
 144:	83 ec 04             	sub    $0x4,%esp
 147:	29 f0                	sub    %esi,%eax
 149:	50                   	push   %eax
 14a:	56                   	push   %esi
 14b:	6a 01                	push   $0x1
 14d:	e8 3c 03 00 00       	call   48e <write>
 152:	83 c4 10             	add    $0x10,%esp
      p = q+1;
 155:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 158:	83 ec 08             	sub    $0x8,%esp
 15b:	6a 0a                	push   $0xa
 15d:	56                   	push   %esi
 15e:	e8 d9 01 00 00       	call   33c <strchr>
 163:	89 c3                	mov    %eax,%ebx
 165:	83 c4 10             	add    $0x10,%esp
 168:	85 c0                	test   %eax,%eax
 16a:	74 16                	je     182 <grep+0x5d>
      *q = 0;
 16c:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 16f:	83 ec 08             	sub    $0x8,%esp
 172:	56                   	push   %esi
 173:	57                   	push   %edi
 174:	e8 5d ff ff ff       	call   d6 <match>
 179:	83 c4 10             	add    $0x10,%esp
 17c:	85 c0                	test   %eax,%eax
 17e:	74 d5                	je     155 <grep+0x30>
 180:	eb bc                	jmp    13e <grep+0x19>
    if(p == buf)
 182:	81 fe 20 0c 00 00    	cmp    $0xc20,%esi
 188:	74 5f                	je     1e9 <grep+0xc4>
    if(m > 0){
 18a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 18d:	85 c9                	test   %ecx,%ecx
 18f:	7f 38                	jg     1c9 <grep+0xa4>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 191:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 196:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 199:	29 c8                	sub    %ecx,%eax
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	50                   	push   %eax
 19f:	8d 81 20 0c 00 00    	lea    0xc20(%ecx),%eax
 1a5:	50                   	push   %eax
 1a6:	ff 75 0c             	pushl  0xc(%ebp)
 1a9:	e8 d8 02 00 00       	call   486 <read>
 1ae:	83 c4 10             	add    $0x10,%esp
 1b1:	85 c0                	test   %eax,%eax
 1b3:	7e 3d                	jle    1f2 <grep+0xcd>
    m += n;
 1b5:	01 45 e4             	add    %eax,-0x1c(%ebp)
 1b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    buf[m] = '\0';
 1bb:	c6 82 20 0c 00 00 00 	movb   $0x0,0xc20(%edx)
    p = buf;
 1c2:	be 20 0c 00 00       	mov    $0xc20,%esi
    while((q = strchr(p, '\n')) != 0){
 1c7:	eb 8f                	jmp    158 <grep+0x33>
      m -= p - buf;
 1c9:	89 f0                	mov    %esi,%eax
 1cb:	2d 20 0c 00 00       	sub    $0xc20,%eax
 1d0:	29 c1                	sub    %eax,%ecx
 1d2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
 1d5:	83 ec 04             	sub    $0x4,%esp
 1d8:	51                   	push   %ecx
 1d9:	56                   	push   %esi
 1da:	68 20 0c 00 00       	push   $0xc20
 1df:	e8 52 02 00 00       	call   436 <memmove>
 1e4:	83 c4 10             	add    $0x10,%esp
 1e7:	eb a8                	jmp    191 <grep+0x6c>
      m = 0;
 1e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1f0:	eb 9f                	jmp    191 <grep+0x6c>
}
 1f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f5:	5b                   	pop    %ebx
 1f6:	5e                   	pop    %esi
 1f7:	5f                   	pop    %edi
 1f8:	5d                   	pop    %ebp
 1f9:	c3                   	ret    

000001fa <main>:
{
 1fa:	f3 0f 1e fb          	endbr32 
 1fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 202:	83 e4 f0             	and    $0xfffffff0,%esp
 205:	ff 71 fc             	pushl  -0x4(%ecx)
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	57                   	push   %edi
 20c:	56                   	push   %esi
 20d:	53                   	push   %ebx
 20e:	51                   	push   %ecx
 20f:	83 ec 18             	sub    $0x18,%esp
 212:	8b 01                	mov    (%ecx),%eax
 214:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 217:	8b 51 04             	mov    0x4(%ecx),%edx
 21a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(argc <= 1){
 21d:	83 f8 01             	cmp    $0x1,%eax
 220:	7e 50                	jle    272 <main+0x78>
  pattern = argv[1];
 222:	8b 45 e0             	mov    -0x20(%ebp),%eax
 225:	8b 40 04             	mov    0x4(%eax),%eax
 228:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(argc <= 2){
 22b:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 22f:	7e 55                	jle    286 <main+0x8c>
  for(i = 2; i < argc; i++){
 231:	be 02 00 00 00       	mov    $0x2,%esi
 236:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 239:	7d 71                	jge    2ac <main+0xb2>
    if((fd = open(argv[i], 0)) < 0){
 23b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23e:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 241:	83 ec 08             	sub    $0x8,%esp
 244:	6a 00                	push   $0x0
 246:	ff 37                	pushl  (%edi)
 248:	e8 61 02 00 00       	call   4ae <open>
 24d:	89 c3                	mov    %eax,%ebx
 24f:	83 c4 10             	add    $0x10,%esp
 252:	85 c0                	test   %eax,%eax
 254:	78 40                	js     296 <main+0x9c>
    grep(pattern, fd);
 256:	83 ec 08             	sub    $0x8,%esp
 259:	50                   	push   %eax
 25a:	ff 75 dc             	pushl  -0x24(%ebp)
 25d:	e8 c3 fe ff ff       	call   125 <grep>
    close(fd);
 262:	89 1c 24             	mov    %ebx,(%esp)
 265:	e8 2c 02 00 00       	call   496 <close>
  for(i = 2; i < argc; i++){
 26a:	83 c6 01             	add    $0x1,%esi
 26d:	83 c4 10             	add    $0x10,%esp
 270:	eb c4                	jmp    236 <main+0x3c>
    printf(2, "usage: grep pattern [file ...]\n");
 272:	83 ec 08             	sub    $0x8,%esp
 275:	68 6c 08 00 00       	push   $0x86c
 27a:	6a 02                	push   $0x2
 27c:	e8 2e 03 00 00       	call   5af <printf>
    exit();
 281:	e8 e8 01 00 00       	call   46e <exit>
    grep(pattern, 0);
 286:	83 ec 08             	sub    $0x8,%esp
 289:	6a 00                	push   $0x0
 28b:	50                   	push   %eax
 28c:	e8 94 fe ff ff       	call   125 <grep>
    exit();
 291:	e8 d8 01 00 00       	call   46e <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 296:	83 ec 04             	sub    $0x4,%esp
 299:	ff 37                	pushl  (%edi)
 29b:	68 8c 08 00 00       	push   $0x88c
 2a0:	6a 01                	push   $0x1
 2a2:	e8 08 03 00 00       	call   5af <printf>
      exit();
 2a7:	e8 c2 01 00 00       	call   46e <exit>
  exit();
 2ac:	e8 bd 01 00 00       	call   46e <exit>

000002b1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2b1:	f3 0f 1e fb          	endbr32 
 2b5:	55                   	push   %ebp
 2b6:	89 e5                	mov    %esp,%ebp
 2b8:	56                   	push   %esi
 2b9:	53                   	push   %ebx
 2ba:	8b 75 08             	mov    0x8(%ebp),%esi
 2bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2c0:	89 f0                	mov    %esi,%eax
 2c2:	89 d1                	mov    %edx,%ecx
 2c4:	83 c2 01             	add    $0x1,%edx
 2c7:	89 c3                	mov    %eax,%ebx
 2c9:	83 c0 01             	add    $0x1,%eax
 2cc:	0f b6 09             	movzbl (%ecx),%ecx
 2cf:	88 0b                	mov    %cl,(%ebx)
 2d1:	84 c9                	test   %cl,%cl
 2d3:	75 ed                	jne    2c2 <strcpy+0x11>
    ;
  return os;
}
 2d5:	89 f0                	mov    %esi,%eax
 2d7:	5b                   	pop    %ebx
 2d8:	5e                   	pop    %esi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    

000002db <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2db:	f3 0f 1e fb          	endbr32 
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2e8:	0f b6 01             	movzbl (%ecx),%eax
 2eb:	84 c0                	test   %al,%al
 2ed:	74 0c                	je     2fb <strcmp+0x20>
 2ef:	3a 02                	cmp    (%edx),%al
 2f1:	75 08                	jne    2fb <strcmp+0x20>
    p++, q++;
 2f3:	83 c1 01             	add    $0x1,%ecx
 2f6:	83 c2 01             	add    $0x1,%edx
 2f9:	eb ed                	jmp    2e8 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 2fb:	0f b6 c0             	movzbl %al,%eax
 2fe:	0f b6 12             	movzbl (%edx),%edx
 301:	29 d0                	sub    %edx,%eax
}
 303:	5d                   	pop    %ebp
 304:	c3                   	ret    

00000305 <strlen>:

uint
strlen(const char *s)
{
 305:	f3 0f 1e fb          	endbr32 
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 30f:	b8 00 00 00 00       	mov    $0x0,%eax
 314:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 318:	74 05                	je     31f <strlen+0x1a>
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	eb f5                	jmp    314 <strlen+0xf>
    ;
  return n;
}
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    

00000321 <memset>:

void*
memset(void *dst, int c, uint n)
{
 321:	f3 0f 1e fb          	endbr32 
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	57                   	push   %edi
 329:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 32c:	89 d7                	mov    %edx,%edi
 32e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	fc                   	cld    
 335:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 337:	89 d0                	mov    %edx,%eax
 339:	5f                   	pop    %edi
 33a:	5d                   	pop    %ebp
 33b:	c3                   	ret    

0000033c <strchr>:

char*
strchr(const char *s, char c)
{
 33c:	f3 0f 1e fb          	endbr32 
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 34a:	0f b6 10             	movzbl (%eax),%edx
 34d:	84 d2                	test   %dl,%dl
 34f:	74 09                	je     35a <strchr+0x1e>
    if(*s == c)
 351:	38 ca                	cmp    %cl,%dl
 353:	74 0a                	je     35f <strchr+0x23>
  for(; *s; s++)
 355:	83 c0 01             	add    $0x1,%eax
 358:	eb f0                	jmp    34a <strchr+0xe>
      return (char*)s;
  return 0;
 35a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    

00000361 <gets>:

char*
gets(char *buf, int max)
{
 361:	f3 0f 1e fb          	endbr32 
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
 368:	57                   	push   %edi
 369:	56                   	push   %esi
 36a:	53                   	push   %ebx
 36b:	83 ec 1c             	sub    $0x1c,%esp
 36e:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 371:	bb 00 00 00 00       	mov    $0x0,%ebx
 376:	89 de                	mov    %ebx,%esi
 378:	83 c3 01             	add    $0x1,%ebx
 37b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 37e:	7d 2e                	jge    3ae <gets+0x4d>
    cc = read(0, &c, 1);
 380:	83 ec 04             	sub    $0x4,%esp
 383:	6a 01                	push   $0x1
 385:	8d 45 e7             	lea    -0x19(%ebp),%eax
 388:	50                   	push   %eax
 389:	6a 00                	push   $0x0
 38b:	e8 f6 00 00 00       	call   486 <read>
    if(cc < 1)
 390:	83 c4 10             	add    $0x10,%esp
 393:	85 c0                	test   %eax,%eax
 395:	7e 17                	jle    3ae <gets+0x4d>
      break;
    buf[i++] = c;
 397:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 39b:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 39e:	3c 0a                	cmp    $0xa,%al
 3a0:	0f 94 c2             	sete   %dl
 3a3:	3c 0d                	cmp    $0xd,%al
 3a5:	0f 94 c0             	sete   %al
 3a8:	08 c2                	or     %al,%dl
 3aa:	74 ca                	je     376 <gets+0x15>
    buf[i++] = c;
 3ac:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3ae:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3b2:	89 f8                	mov    %edi,%eax
 3b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b7:	5b                   	pop    %ebx
 3b8:	5e                   	pop    %esi
 3b9:	5f                   	pop    %edi
 3ba:	5d                   	pop    %ebp
 3bb:	c3                   	ret    

000003bc <stat>:

int
stat(const char *n, struct stat *st)
{
 3bc:	f3 0f 1e fb          	endbr32 
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	56                   	push   %esi
 3c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c5:	83 ec 08             	sub    $0x8,%esp
 3c8:	6a 00                	push   $0x0
 3ca:	ff 75 08             	pushl  0x8(%ebp)
 3cd:	e8 dc 00 00 00       	call   4ae <open>
  if(fd < 0)
 3d2:	83 c4 10             	add    $0x10,%esp
 3d5:	85 c0                	test   %eax,%eax
 3d7:	78 24                	js     3fd <stat+0x41>
 3d9:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3db:	83 ec 08             	sub    $0x8,%esp
 3de:	ff 75 0c             	pushl  0xc(%ebp)
 3e1:	50                   	push   %eax
 3e2:	e8 df 00 00 00       	call   4c6 <fstat>
 3e7:	89 c6                	mov    %eax,%esi
  close(fd);
 3e9:	89 1c 24             	mov    %ebx,(%esp)
 3ec:	e8 a5 00 00 00       	call   496 <close>
  return r;
 3f1:	83 c4 10             	add    $0x10,%esp
}
 3f4:	89 f0                	mov    %esi,%eax
 3f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
    return -1;
 3fd:	be ff ff ff ff       	mov    $0xffffffff,%esi
 402:	eb f0                	jmp    3f4 <stat+0x38>

00000404 <atoi>:

int
atoi(const char *s)
{
 404:	f3 0f 1e fb          	endbr32 
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	53                   	push   %ebx
 40c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 40f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 414:	0f b6 01             	movzbl (%ecx),%eax
 417:	8d 58 d0             	lea    -0x30(%eax),%ebx
 41a:	80 fb 09             	cmp    $0x9,%bl
 41d:	77 12                	ja     431 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 41f:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 422:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 425:	83 c1 01             	add    $0x1,%ecx
 428:	0f be c0             	movsbl %al,%eax
 42b:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 42f:	eb e3                	jmp    414 <atoi+0x10>
  return n;
}
 431:	89 d0                	mov    %edx,%eax
 433:	5b                   	pop    %ebx
 434:	5d                   	pop    %ebp
 435:	c3                   	ret    

00000436 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 436:	f3 0f 1e fb          	endbr32 
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	56                   	push   %esi
 43e:	53                   	push   %ebx
 43f:	8b 75 08             	mov    0x8(%ebp),%esi
 442:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 445:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 448:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 44a:	8d 58 ff             	lea    -0x1(%eax),%ebx
 44d:	85 c0                	test   %eax,%eax
 44f:	7e 0f                	jle    460 <memmove+0x2a>
    *dst++ = *src++;
 451:	0f b6 01             	movzbl (%ecx),%eax
 454:	88 02                	mov    %al,(%edx)
 456:	8d 49 01             	lea    0x1(%ecx),%ecx
 459:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 45c:	89 d8                	mov    %ebx,%eax
 45e:	eb ea                	jmp    44a <memmove+0x14>
  return vdst;
}
 460:	89 f0                	mov    %esi,%eax
 462:	5b                   	pop    %ebx
 463:	5e                   	pop    %esi
 464:	5d                   	pop    %ebp
 465:	c3                   	ret    

00000466 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 466:	b8 01 00 00 00       	mov    $0x1,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <exit>:
SYSCALL(exit)
 46e:	b8 02 00 00 00       	mov    $0x2,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <wait>:
SYSCALL(wait)
 476:	b8 03 00 00 00       	mov    $0x3,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <pipe>:
SYSCALL(pipe)
 47e:	b8 04 00 00 00       	mov    $0x4,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <read>:
SYSCALL(read)
 486:	b8 05 00 00 00       	mov    $0x5,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <write>:
SYSCALL(write)
 48e:	b8 10 00 00 00       	mov    $0x10,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <close>:
SYSCALL(close)
 496:	b8 15 00 00 00       	mov    $0x15,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <kill>:
SYSCALL(kill)
 49e:	b8 06 00 00 00       	mov    $0x6,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <exec>:
SYSCALL(exec)
 4a6:	b8 07 00 00 00       	mov    $0x7,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <open>:
SYSCALL(open)
 4ae:	b8 0f 00 00 00       	mov    $0xf,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <mknod>:
SYSCALL(mknod)
 4b6:	b8 11 00 00 00       	mov    $0x11,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <unlink>:
SYSCALL(unlink)
 4be:	b8 12 00 00 00       	mov    $0x12,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <fstat>:
SYSCALL(fstat)
 4c6:	b8 08 00 00 00       	mov    $0x8,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <link>:
SYSCALL(link)
 4ce:	b8 13 00 00 00       	mov    $0x13,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <mkdir>:
SYSCALL(mkdir)
 4d6:	b8 14 00 00 00       	mov    $0x14,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <chdir>:
SYSCALL(chdir)
 4de:	b8 09 00 00 00       	mov    $0x9,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <dup>:
SYSCALL(dup)
 4e6:	b8 0a 00 00 00       	mov    $0xa,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <getpid>:
SYSCALL(getpid)
 4ee:	b8 0b 00 00 00       	mov    $0xb,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <sbrk>:
SYSCALL(sbrk)
 4f6:	b8 0c 00 00 00       	mov    $0xc,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <sleep>:
SYSCALL(sleep)
 4fe:	b8 0d 00 00 00       	mov    $0xd,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <uptime>:
SYSCALL(uptime)
 506:	b8 0e 00 00 00       	mov    $0xe,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	83 ec 1c             	sub    $0x1c,%esp
 514:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 517:	6a 01                	push   $0x1
 519:	8d 55 f4             	lea    -0xc(%ebp),%edx
 51c:	52                   	push   %edx
 51d:	50                   	push   %eax
 51e:	e8 6b ff ff ff       	call   48e <write>
}
 523:	83 c4 10             	add    $0x10,%esp
 526:	c9                   	leave  
 527:	c3                   	ret    

00000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	57                   	push   %edi
 52c:	56                   	push   %esi
 52d:	53                   	push   %ebx
 52e:	83 ec 2c             	sub    $0x2c,%esp
 531:	89 45 d0             	mov    %eax,-0x30(%ebp)
 534:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 536:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 53a:	0f 95 c2             	setne  %dl
 53d:	89 f0                	mov    %esi,%eax
 53f:	c1 e8 1f             	shr    $0x1f,%eax
 542:	84 c2                	test   %al,%dl
 544:	74 42                	je     588 <printint+0x60>
    neg = 1;
    x = -xx;
 546:	f7 de                	neg    %esi
    neg = 1;
 548:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 54f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 554:	89 f0                	mov    %esi,%eax
 556:	ba 00 00 00 00       	mov    $0x0,%edx
 55b:	f7 f1                	div    %ecx
 55d:	89 df                	mov    %ebx,%edi
 55f:	83 c3 01             	add    $0x1,%ebx
 562:	0f b6 92 ac 08 00 00 	movzbl 0x8ac(%edx),%edx
 569:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 56d:	89 f2                	mov    %esi,%edx
 56f:	89 c6                	mov    %eax,%esi
 571:	39 d1                	cmp    %edx,%ecx
 573:	76 df                	jbe    554 <printint+0x2c>
  if(neg)
 575:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 579:	74 2f                	je     5aa <printint+0x82>
    buf[i++] = '-';
 57b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 580:	8d 5f 02             	lea    0x2(%edi),%ebx
 583:	8b 75 d0             	mov    -0x30(%ebp),%esi
 586:	eb 15                	jmp    59d <printint+0x75>
  neg = 0;
 588:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 58f:	eb be                	jmp    54f <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 591:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 596:	89 f0                	mov    %esi,%eax
 598:	e8 71 ff ff ff       	call   50e <putc>
  while(--i >= 0)
 59d:	83 eb 01             	sub    $0x1,%ebx
 5a0:	79 ef                	jns    591 <printint+0x69>
}
 5a2:	83 c4 2c             	add    $0x2c,%esp
 5a5:	5b                   	pop    %ebx
 5a6:	5e                   	pop    %esi
 5a7:	5f                   	pop    %edi
 5a8:	5d                   	pop    %ebp
 5a9:	c3                   	ret    
 5aa:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5ad:	eb ee                	jmp    59d <printint+0x75>

000005af <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5af:	f3 0f 1e fb          	endbr32 
 5b3:	55                   	push   %ebp
 5b4:	89 e5                	mov    %esp,%ebp
 5b6:	57                   	push   %edi
 5b7:	56                   	push   %esi
 5b8:	53                   	push   %ebx
 5b9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5bc:	8d 45 10             	lea    0x10(%ebp),%eax
 5bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5c2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5c7:	bb 00 00 00 00       	mov    $0x0,%ebx
 5cc:	eb 14                	jmp    5e2 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5ce:	89 fa                	mov    %edi,%edx
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	e8 36 ff ff ff       	call   50e <putc>
 5d8:	eb 05                	jmp    5df <printf+0x30>
      }
    } else if(state == '%'){
 5da:	83 fe 25             	cmp    $0x25,%esi
 5dd:	74 25                	je     604 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 5df:	83 c3 01             	add    $0x1,%ebx
 5e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 5e9:	84 c0                	test   %al,%al
 5eb:	0f 84 23 01 00 00    	je     714 <printf+0x165>
    c = fmt[i] & 0xff;
 5f1:	0f be f8             	movsbl %al,%edi
 5f4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5f7:	85 f6                	test   %esi,%esi
 5f9:	75 df                	jne    5da <printf+0x2b>
      if(c == '%'){
 5fb:	83 f8 25             	cmp    $0x25,%eax
 5fe:	75 ce                	jne    5ce <printf+0x1f>
        state = '%';
 600:	89 c6                	mov    %eax,%esi
 602:	eb db                	jmp    5df <printf+0x30>
      if(c == 'd'){
 604:	83 f8 64             	cmp    $0x64,%eax
 607:	74 49                	je     652 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 609:	83 f8 78             	cmp    $0x78,%eax
 60c:	0f 94 c1             	sete   %cl
 60f:	83 f8 70             	cmp    $0x70,%eax
 612:	0f 94 c2             	sete   %dl
 615:	08 d1                	or     %dl,%cl
 617:	75 63                	jne    67c <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 619:	83 f8 73             	cmp    $0x73,%eax
 61c:	0f 84 84 00 00 00    	je     6a6 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 622:	83 f8 63             	cmp    $0x63,%eax
 625:	0f 84 b7 00 00 00    	je     6e2 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 62b:	83 f8 25             	cmp    $0x25,%eax
 62e:	0f 84 cc 00 00 00    	je     700 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 634:	ba 25 00 00 00       	mov    $0x25,%edx
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	e8 cd fe ff ff       	call   50e <putc>
        putc(fd, c);
 641:	89 fa                	mov    %edi,%edx
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	e8 c3 fe ff ff       	call   50e <putc>
      }
      state = 0;
 64b:	be 00 00 00 00       	mov    $0x0,%esi
 650:	eb 8d                	jmp    5df <printf+0x30>
        printint(fd, *ap, 10, 1);
 652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 655:	8b 17                	mov    (%edi),%edx
 657:	83 ec 0c             	sub    $0xc,%esp
 65a:	6a 01                	push   $0x1
 65c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	e8 bf fe ff ff       	call   528 <printint>
        ap++;
 669:	83 c7 04             	add    $0x4,%edi
 66c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 66f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 672:	be 00 00 00 00       	mov    $0x0,%esi
 677:	e9 63 ff ff ff       	jmp    5df <printf+0x30>
        printint(fd, *ap, 16, 0);
 67c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 67f:	8b 17                	mov    (%edi),%edx
 681:	83 ec 0c             	sub    $0xc,%esp
 684:	6a 00                	push   $0x0
 686:	b9 10 00 00 00       	mov    $0x10,%ecx
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
 68e:	e8 95 fe ff ff       	call   528 <printint>
        ap++;
 693:	83 c7 04             	add    $0x4,%edi
 696:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 699:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69c:	be 00 00 00 00       	mov    $0x0,%esi
 6a1:	e9 39 ff ff ff       	jmp    5df <printf+0x30>
        s = (char*)*ap;
 6a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a9:	8b 30                	mov    (%eax),%esi
        ap++;
 6ab:	83 c0 04             	add    $0x4,%eax
 6ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 6b1:	85 f6                	test   %esi,%esi
 6b3:	75 28                	jne    6dd <printf+0x12e>
          s = "(null)";
 6b5:	be a2 08 00 00       	mov    $0x8a2,%esi
 6ba:	8b 7d 08             	mov    0x8(%ebp),%edi
 6bd:	eb 0d                	jmp    6cc <printf+0x11d>
          putc(fd, *s);
 6bf:	0f be d2             	movsbl %dl,%edx
 6c2:	89 f8                	mov    %edi,%eax
 6c4:	e8 45 fe ff ff       	call   50e <putc>
          s++;
 6c9:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 6cc:	0f b6 16             	movzbl (%esi),%edx
 6cf:	84 d2                	test   %dl,%dl
 6d1:	75 ec                	jne    6bf <printf+0x110>
      state = 0;
 6d3:	be 00 00 00 00       	mov    $0x0,%esi
 6d8:	e9 02 ff ff ff       	jmp    5df <printf+0x30>
 6dd:	8b 7d 08             	mov    0x8(%ebp),%edi
 6e0:	eb ea                	jmp    6cc <printf+0x11d>
        putc(fd, *ap);
 6e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6e5:	0f be 17             	movsbl (%edi),%edx
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	e8 1e fe ff ff       	call   50e <putc>
        ap++;
 6f0:	83 c7 04             	add    $0x4,%edi
 6f3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6f6:	be 00 00 00 00       	mov    $0x0,%esi
 6fb:	e9 df fe ff ff       	jmp    5df <printf+0x30>
        putc(fd, c);
 700:	89 fa                	mov    %edi,%edx
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	e8 04 fe ff ff       	call   50e <putc>
      state = 0;
 70a:	be 00 00 00 00       	mov    $0x0,%esi
 70f:	e9 cb fe ff ff       	jmp    5df <printf+0x30>
    }
  }
}
 714:	8d 65 f4             	lea    -0xc(%ebp),%esp
 717:	5b                   	pop    %ebx
 718:	5e                   	pop    %esi
 719:	5f                   	pop    %edi
 71a:	5d                   	pop    %ebp
 71b:	c3                   	ret    

0000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	f3 0f 1e fb          	endbr32 
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 729:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	a1 00 0c 00 00       	mov    0xc00,%eax
 731:	eb 02                	jmp    735 <free+0x19>
 733:	89 d0                	mov    %edx,%eax
 735:	39 c8                	cmp    %ecx,%eax
 737:	73 04                	jae    73d <free+0x21>
 739:	39 08                	cmp    %ecx,(%eax)
 73b:	77 12                	ja     74f <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73d:	8b 10                	mov    (%eax),%edx
 73f:	39 c2                	cmp    %eax,%edx
 741:	77 f0                	ja     733 <free+0x17>
 743:	39 c8                	cmp    %ecx,%eax
 745:	72 08                	jb     74f <free+0x33>
 747:	39 ca                	cmp    %ecx,%edx
 749:	77 04                	ja     74f <free+0x33>
 74b:	89 d0                	mov    %edx,%eax
 74d:	eb e6                	jmp    735 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 74f:	8b 73 fc             	mov    -0x4(%ebx),%esi
 752:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 755:	8b 10                	mov    (%eax),%edx
 757:	39 d7                	cmp    %edx,%edi
 759:	74 19                	je     774 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 75b:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 75e:	8b 50 04             	mov    0x4(%eax),%edx
 761:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 764:	39 ce                	cmp    %ecx,%esi
 766:	74 1b                	je     783 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 768:	89 08                	mov    %ecx,(%eax)
  freep = p;
 76a:	a3 00 0c 00 00       	mov    %eax,0xc00
}
 76f:	5b                   	pop    %ebx
 770:	5e                   	pop    %esi
 771:	5f                   	pop    %edi
 772:	5d                   	pop    %ebp
 773:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 774:	03 72 04             	add    0x4(%edx),%esi
 777:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 12                	mov    (%edx),%edx
 77e:	89 53 f8             	mov    %edx,-0x8(%ebx)
 781:	eb db                	jmp    75e <free+0x42>
    p->s.size += bp->s.size;
 783:	03 53 fc             	add    -0x4(%ebx),%edx
 786:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 789:	8b 53 f8             	mov    -0x8(%ebx),%edx
 78c:	89 10                	mov    %edx,(%eax)
 78e:	eb da                	jmp    76a <free+0x4e>

00000790 <morecore>:

static Header*
morecore(uint nu)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	53                   	push   %ebx
 794:	83 ec 04             	sub    $0x4,%esp
 797:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 799:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 79e:	77 05                	ja     7a5 <morecore+0x15>
    nu = 4096;
 7a0:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 7a5:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7ac:	83 ec 0c             	sub    $0xc,%esp
 7af:	50                   	push   %eax
 7b0:	e8 41 fd ff ff       	call   4f6 <sbrk>
  if(p == (char*)-1)
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	83 f8 ff             	cmp    $0xffffffff,%eax
 7bb:	74 1c                	je     7d9 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7bd:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7c0:	83 c0 08             	add    $0x8,%eax
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	50                   	push   %eax
 7c7:	e8 50 ff ff ff       	call   71c <free>
  return freep;
 7cc:	a1 00 0c 00 00       	mov    0xc00,%eax
 7d1:	83 c4 10             	add    $0x10,%esp
}
 7d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7d7:	c9                   	leave  
 7d8:	c3                   	ret    
    return 0;
 7d9:	b8 00 00 00 00       	mov    $0x0,%eax
 7de:	eb f4                	jmp    7d4 <morecore+0x44>

000007e0 <malloc>:

void*
malloc(uint nbytes)
{
 7e0:	f3 0f 1e fb          	endbr32 
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	53                   	push   %ebx
 7e8:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	8d 58 07             	lea    0x7(%eax),%ebx
 7f1:	c1 eb 03             	shr    $0x3,%ebx
 7f4:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7f7:	8b 0d 00 0c 00 00    	mov    0xc00,%ecx
 7fd:	85 c9                	test   %ecx,%ecx
 7ff:	74 04                	je     805 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 801:	8b 01                	mov    (%ecx),%eax
 803:	eb 4b                	jmp    850 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 805:	c7 05 00 0c 00 00 04 	movl   $0xc04,0xc00
 80c:	0c 00 00 
 80f:	c7 05 04 0c 00 00 04 	movl   $0xc04,0xc04
 816:	0c 00 00 
    base.s.size = 0;
 819:	c7 05 08 0c 00 00 00 	movl   $0x0,0xc08
 820:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 823:	b9 04 0c 00 00       	mov    $0xc04,%ecx
 828:	eb d7                	jmp    801 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 82a:	74 1a                	je     846 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 82c:	29 da                	sub    %ebx,%edx
 82e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 831:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 834:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 837:	89 0d 00 0c 00 00    	mov    %ecx,0xc00
      return (void*)(p + 1);
 83d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 840:	83 c4 04             	add    $0x4,%esp
 843:	5b                   	pop    %ebx
 844:	5d                   	pop    %ebp
 845:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	89 11                	mov    %edx,(%ecx)
 84a:	eb eb                	jmp    837 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	89 c1                	mov    %eax,%ecx
 84e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 850:	8b 50 04             	mov    0x4(%eax),%edx
 853:	39 da                	cmp    %ebx,%edx
 855:	73 d3                	jae    82a <malloc+0x4a>
    if(p == freep)
 857:	39 05 00 0c 00 00    	cmp    %eax,0xc00
 85d:	75 ed                	jne    84c <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 85f:	89 d8                	mov    %ebx,%eax
 861:	e8 2a ff ff ff       	call   790 <morecore>
 866:	85 c0                	test   %eax,%eax
 868:	75 e2                	jne    84c <malloc+0x6c>
 86a:	eb d4                	jmp    840 <malloc+0x60>
