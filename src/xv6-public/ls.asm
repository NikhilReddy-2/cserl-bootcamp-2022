
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	83 ec 0c             	sub    $0xc,%esp
   f:	53                   	push   %ebx
  10:	e8 2f 03 00 00       	call   344 <strlen>
  15:	01 d8                	add    %ebx,%eax
  17:	83 c4 10             	add    $0x10,%esp
  1a:	39 d8                	cmp    %ebx,%eax
  1c:	72 0a                	jb     28 <fmtname+0x28>
  1e:	80 38 2f             	cmpb   $0x2f,(%eax)
  21:	74 05                	je     28 <fmtname+0x28>
  23:	83 e8 01             	sub    $0x1,%eax
  26:	eb f2                	jmp    1a <fmtname+0x1a>
    ;
  p++;
  28:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2b:	83 ec 0c             	sub    $0xc,%esp
  2e:	53                   	push   %ebx
  2f:	e8 10 03 00 00       	call   344 <strlen>
  34:	83 c4 10             	add    $0x10,%esp
  37:	83 f8 0d             	cmp    $0xd,%eax
  3a:	76 09                	jbe    45 <fmtname+0x45>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3c:	89 d8                	mov    %ebx,%eax
  3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  41:	5b                   	pop    %ebx
  42:	5e                   	pop    %esi
  43:	5d                   	pop    %ebp
  44:	c3                   	ret    
  memmove(buf, p, strlen(p));
  45:	83 ec 0c             	sub    $0xc,%esp
  48:	53                   	push   %ebx
  49:	e8 f6 02 00 00       	call   344 <strlen>
  4e:	83 c4 0c             	add    $0xc,%esp
  51:	50                   	push   %eax
  52:	53                   	push   %ebx
  53:	68 18 0c 00 00       	push   $0xc18
  58:	e8 18 04 00 00       	call   475 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  5d:	89 1c 24             	mov    %ebx,(%esp)
  60:	e8 df 02 00 00       	call   344 <strlen>
  65:	89 c6                	mov    %eax,%esi
  67:	89 1c 24             	mov    %ebx,(%esp)
  6a:	e8 d5 02 00 00       	call   344 <strlen>
  6f:	83 c4 0c             	add    $0xc,%esp
  72:	ba 0e 00 00 00       	mov    $0xe,%edx
  77:	29 f2                	sub    %esi,%edx
  79:	52                   	push   %edx
  7a:	6a 20                	push   $0x20
  7c:	05 18 0c 00 00       	add    $0xc18,%eax
  81:	50                   	push   %eax
  82:	e8 d9 02 00 00       	call   360 <memset>
  return buf;
  87:	83 c4 10             	add    $0x10,%esp
  8a:	bb 18 0c 00 00       	mov    $0xc18,%ebx
  8f:	eb ab                	jmp    3c <fmtname+0x3c>

00000091 <ls>:

void
ls(char *path)
{
  91:	f3 0f 1e fb          	endbr32 
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	57                   	push   %edi
  99:	56                   	push   %esi
  9a:	53                   	push   %ebx
  9b:	81 ec 54 02 00 00    	sub    $0x254,%esp
  a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  a4:	6a 00                	push   $0x0
  a6:	53                   	push   %ebx
  a7:	e8 41 04 00 00       	call   4ed <open>
  ac:	83 c4 10             	add    $0x10,%esp
  af:	85 c0                	test   %eax,%eax
  b1:	0f 88 8c 00 00 00    	js     143 <ls+0xb2>
  b7:	89 c7                	mov    %eax,%edi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  c2:	50                   	push   %eax
  c3:	57                   	push   %edi
  c4:	e8 3c 04 00 00       	call   505 <fstat>
  c9:	83 c4 10             	add    $0x10,%esp
  cc:	85 c0                	test   %eax,%eax
  ce:	0f 88 84 00 00 00    	js     158 <ls+0xc7>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d4:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
  db:	0f bf f0             	movswl %ax,%esi
  de:	66 83 f8 01          	cmp    $0x1,%ax
  e2:	0f 84 8d 00 00 00    	je     175 <ls+0xe4>
  e8:	66 83 f8 02          	cmp    $0x2,%ax
  ec:	75 41                	jne    12f <ls+0x9e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  ee:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
  f4:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  fa:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 100:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 106:	83 ec 0c             	sub    $0xc,%esp
 109:	53                   	push   %ebx
 10a:	e8 f1 fe ff ff       	call   0 <fmtname>
 10f:	83 c4 08             	add    $0x8,%esp
 112:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 118:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 11e:	56                   	push   %esi
 11f:	50                   	push   %eax
 120:	68 e4 08 00 00       	push   $0x8e4
 125:	6a 01                	push   $0x1
 127:	e8 d2 04 00 00       	call   5fe <printf>
    break;
 12c:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 12f:	83 ec 0c             	sub    $0xc,%esp
 132:	57                   	push   %edi
 133:	e8 9d 03 00 00       	call   4d5 <close>
 138:	83 c4 10             	add    $0x10,%esp
}
 13b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13e:	5b                   	pop    %ebx
 13f:	5e                   	pop    %esi
 140:	5f                   	pop    %edi
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 143:	83 ec 04             	sub    $0x4,%esp
 146:	53                   	push   %ebx
 147:	68 bc 08 00 00       	push   $0x8bc
 14c:	6a 02                	push   $0x2
 14e:	e8 ab 04 00 00       	call   5fe <printf>
    return;
 153:	83 c4 10             	add    $0x10,%esp
 156:	eb e3                	jmp    13b <ls+0xaa>
    printf(2, "ls: cannot stat %s\n", path);
 158:	83 ec 04             	sub    $0x4,%esp
 15b:	53                   	push   %ebx
 15c:	68 d0 08 00 00       	push   $0x8d0
 161:	6a 02                	push   $0x2
 163:	e8 96 04 00 00       	call   5fe <printf>
    close(fd);
 168:	89 3c 24             	mov    %edi,(%esp)
 16b:	e8 65 03 00 00       	call   4d5 <close>
    return;
 170:	83 c4 10             	add    $0x10,%esp
 173:	eb c6                	jmp    13b <ls+0xaa>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 175:	83 ec 0c             	sub    $0xc,%esp
 178:	53                   	push   %ebx
 179:	e8 c6 01 00 00       	call   344 <strlen>
 17e:	83 c0 10             	add    $0x10,%eax
 181:	83 c4 10             	add    $0x10,%esp
 184:	3d 00 02 00 00       	cmp    $0x200,%eax
 189:	76 14                	jbe    19f <ls+0x10e>
      printf(1, "ls: path too long\n");
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	68 f1 08 00 00       	push   $0x8f1
 193:	6a 01                	push   $0x1
 195:	e8 64 04 00 00       	call   5fe <printf>
      break;
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	eb 90                	jmp    12f <ls+0x9e>
    strcpy(buf, path);
 19f:	83 ec 08             	sub    $0x8,%esp
 1a2:	53                   	push   %ebx
 1a3:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
 1a9:	56                   	push   %esi
 1aa:	e8 41 01 00 00       	call   2f0 <strcpy>
    p = buf+strlen(buf);
 1af:	89 34 24             	mov    %esi,(%esp)
 1b2:	e8 8d 01 00 00       	call   344 <strlen>
 1b7:	01 c6                	add    %eax,%esi
    *p++ = '/';
 1b9:	8d 46 01             	lea    0x1(%esi),%eax
 1bc:	89 85 ac fd ff ff    	mov    %eax,-0x254(%ebp)
 1c2:	c6 06 2f             	movb   $0x2f,(%esi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c5:	83 c4 10             	add    $0x10,%esp
 1c8:	eb 19                	jmp    1e3 <ls+0x152>
        printf(1, "ls: cannot stat %s\n", buf);
 1ca:	83 ec 04             	sub    $0x4,%esp
 1cd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1d3:	50                   	push   %eax
 1d4:	68 d0 08 00 00       	push   $0x8d0
 1d9:	6a 01                	push   $0x1
 1db:	e8 1e 04 00 00       	call   5fe <printf>
        continue;
 1e0:	83 c4 10             	add    $0x10,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e3:	83 ec 04             	sub    $0x4,%esp
 1e6:	6a 10                	push   $0x10
 1e8:	8d 85 d8 fd ff ff    	lea    -0x228(%ebp),%eax
 1ee:	50                   	push   %eax
 1ef:	57                   	push   %edi
 1f0:	e8 d0 02 00 00       	call   4c5 <read>
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	83 f8 10             	cmp    $0x10,%eax
 1fb:	0f 85 2e ff ff ff    	jne    12f <ls+0x9e>
      if(de.inum == 0)
 201:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 208:	00 
 209:	74 d8                	je     1e3 <ls+0x152>
      memmove(p, de.name, DIRSIZ);
 20b:	83 ec 04             	sub    $0x4,%esp
 20e:	6a 0e                	push   $0xe
 210:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 216:	50                   	push   %eax
 217:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
 21d:	e8 53 02 00 00       	call   475 <memmove>
      p[DIRSIZ] = 0;
 222:	c6 46 0f 00          	movb   $0x0,0xf(%esi)
      if(stat(buf, &st) < 0){
 226:	83 c4 08             	add    $0x8,%esp
 229:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 22f:	50                   	push   %eax
 230:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 236:	50                   	push   %eax
 237:	e8 bf 01 00 00       	call   3fb <stat>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	85 c0                	test   %eax,%eax
 241:	78 87                	js     1ca <ls+0x139>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 243:	8b 9d d4 fd ff ff    	mov    -0x22c(%ebp),%ebx
 249:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
 24f:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 255:	0f b7 8d c4 fd ff ff 	movzwl -0x23c(%ebp),%ecx
 25c:	66 89 8d b0 fd ff ff 	mov    %cx,-0x250(%ebp)
 263:	83 ec 0c             	sub    $0xc,%esp
 266:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 26c:	50                   	push   %eax
 26d:	e8 8e fd ff ff       	call   0 <fmtname>
 272:	89 c2                	mov    %eax,%edx
 274:	83 c4 08             	add    $0x8,%esp
 277:	53                   	push   %ebx
 278:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 27e:	0f bf 85 b0 fd ff ff 	movswl -0x250(%ebp),%eax
 285:	50                   	push   %eax
 286:	52                   	push   %edx
 287:	68 e4 08 00 00       	push   $0x8e4
 28c:	6a 01                	push   $0x1
 28e:	e8 6b 03 00 00       	call   5fe <printf>
 293:	83 c4 20             	add    $0x20,%esp
 296:	e9 48 ff ff ff       	jmp    1e3 <ls+0x152>

0000029b <main>:

int
main(int argc, char *argv[])
{
 29b:	f3 0f 1e fb          	endbr32 
 29f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2a3:	83 e4 f0             	and    $0xfffffff0,%esp
 2a6:	ff 71 fc             	pushl  -0x4(%ecx)
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	57                   	push   %edi
 2ad:	56                   	push   %esi
 2ae:	53                   	push   %ebx
 2af:	51                   	push   %ecx
 2b0:	83 ec 08             	sub    $0x8,%esp
 2b3:	8b 31                	mov    (%ecx),%esi
 2b5:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
 2b8:	83 fe 01             	cmp    $0x1,%esi
 2bb:	7e 07                	jle    2c4 <main+0x29>
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 2bd:	bb 01 00 00 00       	mov    $0x1,%ebx
 2c2:	eb 23                	jmp    2e7 <main+0x4c>
    ls(".");
 2c4:	83 ec 0c             	sub    $0xc,%esp
 2c7:	68 04 09 00 00       	push   $0x904
 2cc:	e8 c0 fd ff ff       	call   91 <ls>
    exit();
 2d1:	e8 d7 01 00 00       	call   4ad <exit>
    ls(argv[i]);
 2d6:	83 ec 0c             	sub    $0xc,%esp
 2d9:	ff 34 9f             	pushl  (%edi,%ebx,4)
 2dc:	e8 b0 fd ff ff       	call   91 <ls>
  for(i=1; i<argc; i++)
 2e1:	83 c3 01             	add    $0x1,%ebx
 2e4:	83 c4 10             	add    $0x10,%esp
 2e7:	39 f3                	cmp    %esi,%ebx
 2e9:	7c eb                	jl     2d6 <main+0x3b>
  exit();
 2eb:	e8 bd 01 00 00       	call   4ad <exit>

000002f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	56                   	push   %esi
 2f8:	53                   	push   %ebx
 2f9:	8b 75 08             	mov    0x8(%ebp),%esi
 2fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ff:	89 f0                	mov    %esi,%eax
 301:	89 d1                	mov    %edx,%ecx
 303:	83 c2 01             	add    $0x1,%edx
 306:	89 c3                	mov    %eax,%ebx
 308:	83 c0 01             	add    $0x1,%eax
 30b:	0f b6 09             	movzbl (%ecx),%ecx
 30e:	88 0b                	mov    %cl,(%ebx)
 310:	84 c9                	test   %cl,%cl
 312:	75 ed                	jne    301 <strcpy+0x11>
    ;
  return os;
}
 314:	89 f0                	mov    %esi,%eax
 316:	5b                   	pop    %ebx
 317:	5e                   	pop    %esi
 318:	5d                   	pop    %ebp
 319:	c3                   	ret    

0000031a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 31a:	f3 0f 1e fb          	endbr32 
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	8b 4d 08             	mov    0x8(%ebp),%ecx
 324:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 327:	0f b6 01             	movzbl (%ecx),%eax
 32a:	84 c0                	test   %al,%al
 32c:	74 0c                	je     33a <strcmp+0x20>
 32e:	3a 02                	cmp    (%edx),%al
 330:	75 08                	jne    33a <strcmp+0x20>
    p++, q++;
 332:	83 c1 01             	add    $0x1,%ecx
 335:	83 c2 01             	add    $0x1,%edx
 338:	eb ed                	jmp    327 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 33a:	0f b6 c0             	movzbl %al,%eax
 33d:	0f b6 12             	movzbl (%edx),%edx
 340:	29 d0                	sub    %edx,%eax
}
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    

00000344 <strlen>:

uint
strlen(const char *s)
{
 344:	f3 0f 1e fb          	endbr32 
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 34e:	b8 00 00 00 00       	mov    $0x0,%eax
 353:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 357:	74 05                	je     35e <strlen+0x1a>
 359:	83 c0 01             	add    $0x1,%eax
 35c:	eb f5                	jmp    353 <strlen+0xf>
    ;
  return n;
}
 35e:	5d                   	pop    %ebp
 35f:	c3                   	ret    

00000360 <memset>:

void*
memset(void *dst, int c, uint n)
{
 360:	f3 0f 1e fb          	endbr32 
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 36b:	89 d7                	mov    %edx,%edi
 36d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	fc                   	cld    
 374:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 376:	89 d0                	mov    %edx,%eax
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    

0000037b <strchr>:

char*
strchr(const char *s, char c)
{
 37b:	f3 0f 1e fb          	endbr32 
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 389:	0f b6 10             	movzbl (%eax),%edx
 38c:	84 d2                	test   %dl,%dl
 38e:	74 09                	je     399 <strchr+0x1e>
    if(*s == c)
 390:	38 ca                	cmp    %cl,%dl
 392:	74 0a                	je     39e <strchr+0x23>
  for(; *s; s++)
 394:	83 c0 01             	add    $0x1,%eax
 397:	eb f0                	jmp    389 <strchr+0xe>
      return (char*)s;
  return 0;
 399:	b8 00 00 00 00       	mov    $0x0,%eax
}
 39e:	5d                   	pop    %ebp
 39f:	c3                   	ret    

000003a0 <gets>:

char*
gets(char *buf, int max)
{
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	57                   	push   %edi
 3a8:	56                   	push   %esi
 3a9:	53                   	push   %ebx
 3aa:	83 ec 1c             	sub    $0x1c,%esp
 3ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b0:	bb 00 00 00 00       	mov    $0x0,%ebx
 3b5:	89 de                	mov    %ebx,%esi
 3b7:	83 c3 01             	add    $0x1,%ebx
 3ba:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3bd:	7d 2e                	jge    3ed <gets+0x4d>
    cc = read(0, &c, 1);
 3bf:	83 ec 04             	sub    $0x4,%esp
 3c2:	6a 01                	push   $0x1
 3c4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3c7:	50                   	push   %eax
 3c8:	6a 00                	push   $0x0
 3ca:	e8 f6 00 00 00       	call   4c5 <read>
    if(cc < 1)
 3cf:	83 c4 10             	add    $0x10,%esp
 3d2:	85 c0                	test   %eax,%eax
 3d4:	7e 17                	jle    3ed <gets+0x4d>
      break;
    buf[i++] = c;
 3d6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3da:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 3dd:	3c 0a                	cmp    $0xa,%al
 3df:	0f 94 c2             	sete   %dl
 3e2:	3c 0d                	cmp    $0xd,%al
 3e4:	0f 94 c0             	sete   %al
 3e7:	08 c2                	or     %al,%dl
 3e9:	74 ca                	je     3b5 <gets+0x15>
    buf[i++] = c;
 3eb:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3ed:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3f1:	89 f8                	mov    %edi,%eax
 3f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    

000003fb <stat>:

int
stat(const char *n, struct stat *st)
{
 3fb:	f3 0f 1e fb          	endbr32 
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	56                   	push   %esi
 403:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 404:	83 ec 08             	sub    $0x8,%esp
 407:	6a 00                	push   $0x0
 409:	ff 75 08             	pushl  0x8(%ebp)
 40c:	e8 dc 00 00 00       	call   4ed <open>
  if(fd < 0)
 411:	83 c4 10             	add    $0x10,%esp
 414:	85 c0                	test   %eax,%eax
 416:	78 24                	js     43c <stat+0x41>
 418:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 41a:	83 ec 08             	sub    $0x8,%esp
 41d:	ff 75 0c             	pushl  0xc(%ebp)
 420:	50                   	push   %eax
 421:	e8 df 00 00 00       	call   505 <fstat>
 426:	89 c6                	mov    %eax,%esi
  close(fd);
 428:	89 1c 24             	mov    %ebx,(%esp)
 42b:	e8 a5 00 00 00       	call   4d5 <close>
  return r;
 430:	83 c4 10             	add    $0x10,%esp
}
 433:	89 f0                	mov    %esi,%eax
 435:	8d 65 f8             	lea    -0x8(%ebp),%esp
 438:	5b                   	pop    %ebx
 439:	5e                   	pop    %esi
 43a:	5d                   	pop    %ebp
 43b:	c3                   	ret    
    return -1;
 43c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 441:	eb f0                	jmp    433 <stat+0x38>

00000443 <atoi>:

int
atoi(const char *s)
{
 443:	f3 0f 1e fb          	endbr32 
 447:	55                   	push   %ebp
 448:	89 e5                	mov    %esp,%ebp
 44a:	53                   	push   %ebx
 44b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 44e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 453:	0f b6 01             	movzbl (%ecx),%eax
 456:	8d 58 d0             	lea    -0x30(%eax),%ebx
 459:	80 fb 09             	cmp    $0x9,%bl
 45c:	77 12                	ja     470 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 45e:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 461:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 464:	83 c1 01             	add    $0x1,%ecx
 467:	0f be c0             	movsbl %al,%eax
 46a:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 46e:	eb e3                	jmp    453 <atoi+0x10>
  return n;
}
 470:	89 d0                	mov    %edx,%eax
 472:	5b                   	pop    %ebx
 473:	5d                   	pop    %ebp
 474:	c3                   	ret    

00000475 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 475:	f3 0f 1e fb          	endbr32 
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	56                   	push   %esi
 47d:	53                   	push   %ebx
 47e:	8b 75 08             	mov    0x8(%ebp),%esi
 481:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 484:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 487:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 489:	8d 58 ff             	lea    -0x1(%eax),%ebx
 48c:	85 c0                	test   %eax,%eax
 48e:	7e 0f                	jle    49f <memmove+0x2a>
    *dst++ = *src++;
 490:	0f b6 01             	movzbl (%ecx),%eax
 493:	88 02                	mov    %al,(%edx)
 495:	8d 49 01             	lea    0x1(%ecx),%ecx
 498:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 49b:	89 d8                	mov    %ebx,%eax
 49d:	eb ea                	jmp    489 <memmove+0x14>
  return vdst;
}
 49f:	89 f0                	mov    %esi,%eax
 4a1:	5b                   	pop    %ebx
 4a2:	5e                   	pop    %esi
 4a3:	5d                   	pop    %ebp
 4a4:	c3                   	ret    

000004a5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4a5:	b8 01 00 00 00       	mov    $0x1,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <exit>:
SYSCALL(exit)
 4ad:	b8 02 00 00 00       	mov    $0x2,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <wait>:
SYSCALL(wait)
 4b5:	b8 03 00 00 00       	mov    $0x3,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <pipe>:
SYSCALL(pipe)
 4bd:	b8 04 00 00 00       	mov    $0x4,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <read>:
SYSCALL(read)
 4c5:	b8 05 00 00 00       	mov    $0x5,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <write>:
SYSCALL(write)
 4cd:	b8 10 00 00 00       	mov    $0x10,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <close>:
SYSCALL(close)
 4d5:	b8 15 00 00 00       	mov    $0x15,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <kill>:
SYSCALL(kill)
 4dd:	b8 06 00 00 00       	mov    $0x6,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <exec>:
SYSCALL(exec)
 4e5:	b8 07 00 00 00       	mov    $0x7,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <open>:
SYSCALL(open)
 4ed:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <mknod>:
SYSCALL(mknod)
 4f5:	b8 11 00 00 00       	mov    $0x11,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <unlink>:
SYSCALL(unlink)
 4fd:	b8 12 00 00 00       	mov    $0x12,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <fstat>:
SYSCALL(fstat)
 505:	b8 08 00 00 00       	mov    $0x8,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <link>:
SYSCALL(link)
 50d:	b8 13 00 00 00       	mov    $0x13,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <mkdir>:
SYSCALL(mkdir)
 515:	b8 14 00 00 00       	mov    $0x14,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <chdir>:
SYSCALL(chdir)
 51d:	b8 09 00 00 00       	mov    $0x9,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <dup>:
SYSCALL(dup)
 525:	b8 0a 00 00 00       	mov    $0xa,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <getpid>:
SYSCALL(getpid)
 52d:	b8 0b 00 00 00       	mov    $0xb,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <sbrk>:
SYSCALL(sbrk)
 535:	b8 0c 00 00 00       	mov    $0xc,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <sleep>:
SYSCALL(sleep)
 53d:	b8 0d 00 00 00       	mov    $0xd,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <uptime>:
SYSCALL(uptime)
 545:	b8 0e 00 00 00       	mov    $0xe,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <get_siblings_info>:
SYSCALL(get_siblings_info)
 54d:	b8 16 00 00 00       	mov    $0x16,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <get_ancestors>:
SYSCALL(get_ancestors)
 555:	b8 17 00 00 00       	mov    $0x17,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 55d:	55                   	push   %ebp
 55e:	89 e5                	mov    %esp,%ebp
 560:	83 ec 1c             	sub    $0x1c,%esp
 563:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 566:	6a 01                	push   $0x1
 568:	8d 55 f4             	lea    -0xc(%ebp),%edx
 56b:	52                   	push   %edx
 56c:	50                   	push   %eax
 56d:	e8 5b ff ff ff       	call   4cd <write>
}
 572:	83 c4 10             	add    $0x10,%esp
 575:	c9                   	leave  
 576:	c3                   	ret    

00000577 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 577:	55                   	push   %ebp
 578:	89 e5                	mov    %esp,%ebp
 57a:	57                   	push   %edi
 57b:	56                   	push   %esi
 57c:	53                   	push   %ebx
 57d:	83 ec 2c             	sub    $0x2c,%esp
 580:	89 45 d0             	mov    %eax,-0x30(%ebp)
 583:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 585:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 589:	0f 95 c2             	setne  %dl
 58c:	89 f0                	mov    %esi,%eax
 58e:	c1 e8 1f             	shr    $0x1f,%eax
 591:	84 c2                	test   %al,%dl
 593:	74 42                	je     5d7 <printint+0x60>
    neg = 1;
    x = -xx;
 595:	f7 de                	neg    %esi
    neg = 1;
 597:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 59e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 5a3:	89 f0                	mov    %esi,%eax
 5a5:	ba 00 00 00 00       	mov    $0x0,%edx
 5aa:	f7 f1                	div    %ecx
 5ac:	89 df                	mov    %ebx,%edi
 5ae:	83 c3 01             	add    $0x1,%ebx
 5b1:	0f b6 92 10 09 00 00 	movzbl 0x910(%edx),%edx
 5b8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 5bc:	89 f2                	mov    %esi,%edx
 5be:	89 c6                	mov    %eax,%esi
 5c0:	39 d1                	cmp    %edx,%ecx
 5c2:	76 df                	jbe    5a3 <printint+0x2c>
  if(neg)
 5c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 5c8:	74 2f                	je     5f9 <printint+0x82>
    buf[i++] = '-';
 5ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 5cf:	8d 5f 02             	lea    0x2(%edi),%ebx
 5d2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5d5:	eb 15                	jmp    5ec <printint+0x75>
  neg = 0;
 5d7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 5de:	eb be                	jmp    59e <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 5e0:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 5e5:	89 f0                	mov    %esi,%eax
 5e7:	e8 71 ff ff ff       	call   55d <putc>
  while(--i >= 0)
 5ec:	83 eb 01             	sub    $0x1,%ebx
 5ef:	79 ef                	jns    5e0 <printint+0x69>
}
 5f1:	83 c4 2c             	add    $0x2c,%esp
 5f4:	5b                   	pop    %ebx
 5f5:	5e                   	pop    %esi
 5f6:	5f                   	pop    %edi
 5f7:	5d                   	pop    %ebp
 5f8:	c3                   	ret    
 5f9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5fc:	eb ee                	jmp    5ec <printint+0x75>

000005fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5fe:	f3 0f 1e fb          	endbr32 
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	57                   	push   %edi
 606:	56                   	push   %esi
 607:	53                   	push   %ebx
 608:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 60b:	8d 45 10             	lea    0x10(%ebp),%eax
 60e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 611:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 616:	bb 00 00 00 00       	mov    $0x0,%ebx
 61b:	eb 14                	jmp    631 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 61d:	89 fa                	mov    %edi,%edx
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	e8 36 ff ff ff       	call   55d <putc>
 627:	eb 05                	jmp    62e <printf+0x30>
      }
    } else if(state == '%'){
 629:	83 fe 25             	cmp    $0x25,%esi
 62c:	74 25                	je     653 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 62e:	83 c3 01             	add    $0x1,%ebx
 631:	8b 45 0c             	mov    0xc(%ebp),%eax
 634:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 638:	84 c0                	test   %al,%al
 63a:	0f 84 23 01 00 00    	je     763 <printf+0x165>
    c = fmt[i] & 0xff;
 640:	0f be f8             	movsbl %al,%edi
 643:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 646:	85 f6                	test   %esi,%esi
 648:	75 df                	jne    629 <printf+0x2b>
      if(c == '%'){
 64a:	83 f8 25             	cmp    $0x25,%eax
 64d:	75 ce                	jne    61d <printf+0x1f>
        state = '%';
 64f:	89 c6                	mov    %eax,%esi
 651:	eb db                	jmp    62e <printf+0x30>
      if(c == 'd'){
 653:	83 f8 64             	cmp    $0x64,%eax
 656:	74 49                	je     6a1 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 658:	83 f8 78             	cmp    $0x78,%eax
 65b:	0f 94 c1             	sete   %cl
 65e:	83 f8 70             	cmp    $0x70,%eax
 661:	0f 94 c2             	sete   %dl
 664:	08 d1                	or     %dl,%cl
 666:	75 63                	jne    6cb <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 668:	83 f8 73             	cmp    $0x73,%eax
 66b:	0f 84 84 00 00 00    	je     6f5 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 671:	83 f8 63             	cmp    $0x63,%eax
 674:	0f 84 b7 00 00 00    	je     731 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 67a:	83 f8 25             	cmp    $0x25,%eax
 67d:	0f 84 cc 00 00 00    	je     74f <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 683:	ba 25 00 00 00       	mov    $0x25,%edx
 688:	8b 45 08             	mov    0x8(%ebp),%eax
 68b:	e8 cd fe ff ff       	call   55d <putc>
        putc(fd, c);
 690:	89 fa                	mov    %edi,%edx
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	e8 c3 fe ff ff       	call   55d <putc>
      }
      state = 0;
 69a:	be 00 00 00 00       	mov    $0x0,%esi
 69f:	eb 8d                	jmp    62e <printf+0x30>
        printint(fd, *ap, 10, 1);
 6a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6a4:	8b 17                	mov    (%edi),%edx
 6a6:	83 ec 0c             	sub    $0xc,%esp
 6a9:	6a 01                	push   $0x1
 6ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6b0:	8b 45 08             	mov    0x8(%ebp),%eax
 6b3:	e8 bf fe ff ff       	call   577 <printint>
        ap++;
 6b8:	83 c7 04             	add    $0x4,%edi
 6bb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6be:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6c1:	be 00 00 00 00       	mov    $0x0,%esi
 6c6:	e9 63 ff ff ff       	jmp    62e <printf+0x30>
        printint(fd, *ap, 16, 0);
 6cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6ce:	8b 17                	mov    (%edi),%edx
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	6a 00                	push   $0x0
 6d5:	b9 10 00 00 00       	mov    $0x10,%ecx
 6da:	8b 45 08             	mov    0x8(%ebp),%eax
 6dd:	e8 95 fe ff ff       	call   577 <printint>
        ap++;
 6e2:	83 c7 04             	add    $0x4,%edi
 6e5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6eb:	be 00 00 00 00       	mov    $0x0,%esi
 6f0:	e9 39 ff ff ff       	jmp    62e <printf+0x30>
        s = (char*)*ap;
 6f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f8:	8b 30                	mov    (%eax),%esi
        ap++;
 6fa:	83 c0 04             	add    $0x4,%eax
 6fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 700:	85 f6                	test   %esi,%esi
 702:	75 28                	jne    72c <printf+0x12e>
          s = "(null)";
 704:	be 06 09 00 00       	mov    $0x906,%esi
 709:	8b 7d 08             	mov    0x8(%ebp),%edi
 70c:	eb 0d                	jmp    71b <printf+0x11d>
          putc(fd, *s);
 70e:	0f be d2             	movsbl %dl,%edx
 711:	89 f8                	mov    %edi,%eax
 713:	e8 45 fe ff ff       	call   55d <putc>
          s++;
 718:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 71b:	0f b6 16             	movzbl (%esi),%edx
 71e:	84 d2                	test   %dl,%dl
 720:	75 ec                	jne    70e <printf+0x110>
      state = 0;
 722:	be 00 00 00 00       	mov    $0x0,%esi
 727:	e9 02 ff ff ff       	jmp    62e <printf+0x30>
 72c:	8b 7d 08             	mov    0x8(%ebp),%edi
 72f:	eb ea                	jmp    71b <printf+0x11d>
        putc(fd, *ap);
 731:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 734:	0f be 17             	movsbl (%edi),%edx
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	e8 1e fe ff ff       	call   55d <putc>
        ap++;
 73f:	83 c7 04             	add    $0x4,%edi
 742:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 745:	be 00 00 00 00       	mov    $0x0,%esi
 74a:	e9 df fe ff ff       	jmp    62e <printf+0x30>
        putc(fd, c);
 74f:	89 fa                	mov    %edi,%edx
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	e8 04 fe ff ff       	call   55d <putc>
      state = 0;
 759:	be 00 00 00 00       	mov    $0x0,%esi
 75e:	e9 cb fe ff ff       	jmp    62e <printf+0x30>
    }
  }
}
 763:	8d 65 f4             	lea    -0xc(%ebp),%esp
 766:	5b                   	pop    %ebx
 767:	5e                   	pop    %esi
 768:	5f                   	pop    %edi
 769:	5d                   	pop    %ebp
 76a:	c3                   	ret    

0000076b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76b:	f3 0f 1e fb          	endbr32 
 76f:	55                   	push   %ebp
 770:	89 e5                	mov    %esp,%ebp
 772:	57                   	push   %edi
 773:	56                   	push   %esi
 774:	53                   	push   %ebx
 775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 778:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77b:	a1 28 0c 00 00       	mov    0xc28,%eax
 780:	eb 02                	jmp    784 <free+0x19>
 782:	89 d0                	mov    %edx,%eax
 784:	39 c8                	cmp    %ecx,%eax
 786:	73 04                	jae    78c <free+0x21>
 788:	39 08                	cmp    %ecx,(%eax)
 78a:	77 12                	ja     79e <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	8b 10                	mov    (%eax),%edx
 78e:	39 c2                	cmp    %eax,%edx
 790:	77 f0                	ja     782 <free+0x17>
 792:	39 c8                	cmp    %ecx,%eax
 794:	72 08                	jb     79e <free+0x33>
 796:	39 ca                	cmp    %ecx,%edx
 798:	77 04                	ja     79e <free+0x33>
 79a:	89 d0                	mov    %edx,%eax
 79c:	eb e6                	jmp    784 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 79e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7a1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	39 d7                	cmp    %edx,%edi
 7a8:	74 19                	je     7c3 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ad:	8b 50 04             	mov    0x4(%eax),%edx
 7b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7b3:	39 ce                	cmp    %ecx,%esi
 7b5:	74 1b                	je     7d2 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7b7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7b9:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 7be:	5b                   	pop    %ebx
 7bf:	5e                   	pop    %esi
 7c0:	5f                   	pop    %edi
 7c1:	5d                   	pop    %ebp
 7c2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 7c3:	03 72 04             	add    0x4(%edx),%esi
 7c6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c9:	8b 10                	mov    (%eax),%edx
 7cb:	8b 12                	mov    (%edx),%edx
 7cd:	89 53 f8             	mov    %edx,-0x8(%ebx)
 7d0:	eb db                	jmp    7ad <free+0x42>
    p->s.size += bp->s.size;
 7d2:	03 53 fc             	add    -0x4(%ebx),%edx
 7d5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7db:	89 10                	mov    %edx,(%eax)
 7dd:	eb da                	jmp    7b9 <free+0x4e>

000007df <morecore>:

static Header*
morecore(uint nu)
{
 7df:	55                   	push   %ebp
 7e0:	89 e5                	mov    %esp,%ebp
 7e2:	53                   	push   %ebx
 7e3:	83 ec 04             	sub    $0x4,%esp
 7e6:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 7e8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 7ed:	77 05                	ja     7f4 <morecore+0x15>
    nu = 4096;
 7ef:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 7f4:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	50                   	push   %eax
 7ff:	e8 31 fd ff ff       	call   535 <sbrk>
  if(p == (char*)-1)
 804:	83 c4 10             	add    $0x10,%esp
 807:	83 f8 ff             	cmp    $0xffffffff,%eax
 80a:	74 1c                	je     828 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 80c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 80f:	83 c0 08             	add    $0x8,%eax
 812:	83 ec 0c             	sub    $0xc,%esp
 815:	50                   	push   %eax
 816:	e8 50 ff ff ff       	call   76b <free>
  return freep;
 81b:	a1 28 0c 00 00       	mov    0xc28,%eax
 820:	83 c4 10             	add    $0x10,%esp
}
 823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 826:	c9                   	leave  
 827:	c3                   	ret    
    return 0;
 828:	b8 00 00 00 00       	mov    $0x0,%eax
 82d:	eb f4                	jmp    823 <morecore+0x44>

0000082f <malloc>:

void*
malloc(uint nbytes)
{
 82f:	f3 0f 1e fb          	endbr32 
 833:	55                   	push   %ebp
 834:	89 e5                	mov    %esp,%ebp
 836:	53                   	push   %ebx
 837:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83a:	8b 45 08             	mov    0x8(%ebp),%eax
 83d:	8d 58 07             	lea    0x7(%eax),%ebx
 840:	c1 eb 03             	shr    $0x3,%ebx
 843:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 846:	8b 0d 28 0c 00 00    	mov    0xc28,%ecx
 84c:	85 c9                	test   %ecx,%ecx
 84e:	74 04                	je     854 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	8b 01                	mov    (%ecx),%eax
 852:	eb 4b                	jmp    89f <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 854:	c7 05 28 0c 00 00 2c 	movl   $0xc2c,0xc28
 85b:	0c 00 00 
 85e:	c7 05 2c 0c 00 00 2c 	movl   $0xc2c,0xc2c
 865:	0c 00 00 
    base.s.size = 0;
 868:	c7 05 30 0c 00 00 00 	movl   $0x0,0xc30
 86f:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 872:	b9 2c 0c 00 00       	mov    $0xc2c,%ecx
 877:	eb d7                	jmp    850 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 879:	74 1a                	je     895 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 87b:	29 da                	sub    %ebx,%edx
 87d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 880:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 883:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 886:	89 0d 28 0c 00 00    	mov    %ecx,0xc28
      return (void*)(p + 1);
 88c:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 88f:	83 c4 04             	add    $0x4,%esp
 892:	5b                   	pop    %ebx
 893:	5d                   	pop    %ebp
 894:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 895:	8b 10                	mov    (%eax),%edx
 897:	89 11                	mov    %edx,(%ecx)
 899:	eb eb                	jmp    886 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89b:	89 c1                	mov    %eax,%ecx
 89d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 89f:	8b 50 04             	mov    0x4(%eax),%edx
 8a2:	39 da                	cmp    %ebx,%edx
 8a4:	73 d3                	jae    879 <malloc+0x4a>
    if(p == freep)
 8a6:	39 05 28 0c 00 00    	cmp    %eax,0xc28
 8ac:	75 ed                	jne    89b <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 8ae:	89 d8                	mov    %ebx,%eax
 8b0:	e8 2a ff ff ff       	call   7df <morecore>
 8b5:	85 c0                	test   %eax,%eax
 8b7:	75 e2                	jne    89b <malloc+0x6c>
 8b9:	eb d4                	jmp    88f <malloc+0x60>
