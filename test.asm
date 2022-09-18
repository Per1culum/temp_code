;1. 该系统能提供信息录入、查询、最终成绩排序功能及分数统计信息显示
;（各个总成绩分数段的人数、平均分、最高分、最低分）。
;2. 信息录入包括：学生的姓名、学号、及 16 次作业成绩和一次大作业成
;绩。（通过键盘输入）
;3. 该系统能自动计算学生的最终成绩，按照平时作业成绩占 40%，大作业
;成绩占 60%计算。
;4. 查询功能的查询方式需在显示界面有提示是按姓名查询还是学号查询。
;5. 成绩排序默认按照从底到高排序。排序显示要求同时显示学生的姓名、
;学号、平时成绩、大作业成绩、总成绩、及排名。
;6. 各个总成绩分数段的人数的统计按照：90-100 一个分数段；80-89 一个
;分数段；60-79 一个分数段；60 以下一个分数段。


assume cs:code,ds:data,ss:stack
data segment
	show db 'Please enter a number(1-6) to choose function ',0dh,0ah
		db'-------------------------------------------',0dh,0ah
		db'| function1:Input name id and grade(00)*17|',0dh,0ah  ;输入学生的学号，姓名和历次成绩
		db'| function2:Enter id to search  grade     |',0dh,0ah  ;输入学号查询学生成绩
		db'| function3:Enter name to search  grade   |',0dh,0ah  ;输入姓名查询学生成绩
		db'| function4:Grade sorting                 |',0dh,0ah  ;对系统内的学生成绩进行排序，从低到高，并打印出来
		db'| function5:Analisis grade                |',0dh,0ah  ;统计各个分数段的人数（基于总成绩）
		db'| function6:Quit                          |',0dh,0ah  ;退出系统
		db'-------------------------------------------',0dh,0ah,'$'
		
	tips db'Please input your choice:','$'           ;提示语
	funtable dw function1,function2,function3,function4,function5,function6  ;各个功能的地址表
	idtable dw id1,id2,id3,id4,id5,id6,id7,id8,id9,id10,id11,id12,id13,id14,id15,id16,id17,id18,id19,id20,id21
	nametable dw name1,name2,name3,name4,name5,name6,name7,name8,name9,name10,name11,name12,name13,name14,name15,name16,name17,name18,name19,name20,name21

	name1 db 10                                      ;放置20个学生的姓名
		  db ?                                       ;最后一个是用来暂时存放查找输入的
		  db 10 dup('$')                             ;之所以在字符串前面有两个字节，是因为int 21h的09h中断例程的文本说明有一个样例就是这么写的
	name2 db 10
		  db ?
		  db 10 dup('$')
	name3 db 10
		  db ?
		  db 10 dup('$')
	name4 db 10
		  db ?
		  db 10 dup('$')
	name5 db 10
		  db ?
		  db 10 dup('$')
	name6 db 10
		  db ?
		  db 10 dup('$')
	name7 db 10
		  db ?
		  db 10 dup('$')
	name8 db 10
		  db ?
		  db 10 dup('$')
	name9 db 10
		  db ?
		  db 10 dup('$')
	name10 db 10
		  db ?
		  db 10 dup('$')
	name11 db 10
		  db ?
		  db 10 dup('$')
	name12 db 10
		  db ?
		  db 10 dup('$')
	name13 db 10
		  db ?
		  db 10 dup('$')		  
	name14 db 10
		  db ?
		  db 10 dup('$')	
	name15 db 10
		  db ?
		  db 10 dup('$')	
	name16 db 10
		  db ?
		  db 10 dup('$')	
	name17 db 10
		  db ?
		  db 10 dup('$')	
	name18 db 10
		  db ?
		  db 10 dup('$')	
	name19 db 10
		  db ?
		  db 10 dup('$')	
	name20 db 10
		  db ?
		  db 10 dup('$')	
	name21 db 10
		   db ?
		   db 10 dup('$')
	
	ID1 db 10                                        ;20个学生的学号，同样最后一个是暂时数据 
		db ?
		db 10 dup('$')
	ID2 db 10
		db ?
		db 10 dup('$')
	ID3 db 10
		db ?
		db 10 dup('$')
	ID4 db 10
		db ?
		db 10 dup('$')
	ID5 db 10
		db ?
		db 10 dup('$')
	ID6 db 10
		db ?
		db 10 dup('$')
	ID7 db 10
		db ?
		db 10 dup('$')
	ID8 db 10
		db ?
		db 10 dup('$')
	ID9 db 10
		db ?
		db 10 dup('$')
	ID10 db 10
		db ?
		db 10 dup('$')
	ID11 db 10
		db ?
		db 10 dup('$')
	ID12 db 10
		db ?
		db 10 dup('$')
	ID13 db 10
		db ?
		db 10 dup('$')
	ID14 db 10
		db ?
		db 10 dup('$')
	ID15 db 10
		db ?
		db 10 dup('$')
	ID16 db 10
		db ?
		db 10 dup('$')
	ID17 db 10
		db ?
		db 10 dup('$')
	ID18 db 10
		db ?
		db 10 dup('$')		
	ID19 db 10
		db ?
		db 10 dup('$')	
	ID20 db 10
		db ?
		db 10 dup('$')	
	ID21 db 10
		db ?
		db 10 dup('$')			
	
	stucnt dw 0                                      ;学生数量
	temp dw 0                                        ;用来暂时存放输入的成绩

	
	highestgrade dw 0                 ;三个空间分别存放最高成绩，最低成绩，平均成绩
	lowestgrade dw 100
	averagegrade dw 0

	rank dw 20 dup(0)                 ;存放排名的空间
	tempgrade dw 0                    ;一些预留的空间
	tempgrade3 dw 0

	;一些提示语，0dh,0ah,是用来换行的
	tip0 db '             usgrade        testgrade       finalgrade        rank',0dh,0ah,'$'
	tip1 db 'please input student name(less than 8 chars):','$'
	tip2 db 'please input student id(less than 8 chars):','$'
	tip3 db 'please input the name your want to search:','$'
	tip4 db 'please input the id your want to search:','$'
	tip5 db 'the information you input is error!',0dh,0ah,'$'
	tip6 db 'please input the number of student:','$'
	tip7 db 'the choice you input is error!',0dh,0ah,'$'
	tip8 db 'please input the grade:','$'
	tip9 db 'Done!',0dh,0ah,'$'
	tip10 db 'please input the big test grade:','$'
	tip11 db 'please input the choice:','$'
	tip12 db 'you found the name!',0dh,0ah,'$'
	tip13 db 'you found the id!',0dh,0ah,'$'
	tip14 db 'thanks for your suppose!','$'
	tip15 db 'Welcome to the student management system!','$'

	;一些输出时会用到的字符串，已编辑格式
	show0 db '            0-59:','$'
	show1 db '           60-79:','$'
	show2 db '           80-89:','$'
	show3 db '          90-100:','$'
	show4 db 'id  :','$'
	show5 db '    average grade:','$'
	show6 db '    highest grade:','$'
	show7 db '     lowest grade:','$'
	show8 db 'name:','$'
	show9 db '      usgrade:','$'
	show10 db '      testgrade:','$'
	show11 db '    finalgrade:','$'
	show12 db 'id:','$'
	show13 db 'name:','$'
	showtab db '			','$'
	showtab1 db '		','$'


	count2 dw 10                                 ;输入学生数的时候使用
	count3 dw 0,0,0,0,'$'						;保存四个分数段中的人数
	count1 dw 4,2,1

	grade1 dw 20 dup(?)                       ;三个空间分别存放平时成绩，大作业成绩和总成绩
	grade2 dw 20 dup(?)
	grade3 dw 20 dup(?)


	divnum dw 1000,100,10,1                     ;除数
	result db 0,0,0,0,'$'						;存放结果
	ctmp dw 0                                   ;预留的功能使用
data ends

stack segment'stack'							;建立一个栈，用来在必要的时候暂存寄存器内容
	dw 100h dup(0)
stack ends

code segment

;以下是一些宏，用来让程序简单一点
;------------------------------------------------------------------
out_dx macro str								;输出整行字符串
	push dx
	push ax
	lea dx,str
	mov ah,09h
	int 21h
	pop ax
	pop dx
endm
;--------------------------------------------------------------------
changeline macro								;换行
	push ax
	push dx
	mov ah,02h
	mov dl,0dh
	int 21h
	mov dl,0ah
	int 21h
	pop dx
	pop ax
endm
;----------------------------------------------------------------
out_dx2 macro str                         ;可递增的输出字符串
	push dx
	push ax
	mov dx,str
	add dx,2
	mov ah,9h
	int 21h
	pop ax
	pop dx
endm

;------------------------------------------------------------------
menu macro                                 ;显示一下菜单
	changeline
	out_dx show
endm

;-----------------------------------------------------------------
inputstunum macro
	local lp1,lp2                               ;输入学生数量的宏
	push si                                     ;思想是输入12，储存形式为1*10+2
	push ax
	push bx

	out_dx tip6
	mov bx,0
lp1:
	mov al,01h                                  ;功能号和清除缓存区
	mov ah,0ch
	int 21h
    sub al,30h                                  ;改变为数字
	jb lp2                                      ;小于，跳转
	cmp al,9                                    ;大于，跳转
	ja lp2

	mov ah,0                                    
	xchg ax,bx
	mul count2[0]                                 ;al*10，
	xchg ax,bx
	add bx,ax
	jmp lp1
lp2:
	lea si,stucnt
	mov word ptr [si],bx

	pop bx
	pop ax
	pop si
endm
	
;-----------------------------------------------------------
inputname macro var1                            ;宏指令输入名字
	push ax
	push dx
	mov dx,nametable[var1]
	mov al,0ah                                  ;功能号a
	mov ah,0ch                                  ;清除缓存区
	int 21H
	changeline
	pop dx
	pop ax
endm

;-----------------------------------------------------------
inputid macro var1                            ;宏指令输入学号
	push ax
	push dx
	mov dx,idtable[var1]
	mov al,0ah                                  ;功能号a
	mov ah,0ch                                  ;清除缓存区
	int 21H
	changeline
	pop dx
	pop ax
endm
	
;-----------------------------------------------------------
inputgrade macro var1
	local n1,n2                                 ;输入学生成绩的宏
	push si                                     ;思想是输入12，储存形式为1*10+2
	push ax
	push bx

	mov bx,0
n1:
	mov al,01h                                  ;功能号和清除缓存区
	mov ah,0ch
	int 21h

    sub al,30h                                  ;改变为数字
	jl n2                                      ;小于，跳转
	cmp al,9                                    ;大于，跳转
	jg n2
	cbw

	xchg ax,bx
	mul count2[0]                                  
	xchg ax,bx
	add bx,ax
	dec count1[2]
	cmp count1[2],0
	ja n1
n2:
	mov count1[2],2
	lea si,var1
	mov word ptr [si],bx
	changeline
	pop bx
	pop ax
	pop si
endm

;-------------------------------------------------------------------
start:
	mov ax,data
	mov ds,ax
	mov es,ax
	out_dx tip15
start0:
	menu
	changeline
	out_dx tip11
	mov al,01h									 ;输入数字，结果放在al中
	mov ah,0ch
	int 21h										 ;输入选项（1-6）

	sub al,30h									 ;小于0，跳回去从新输入
	cmp al,0
	jb exit0
	
	cmp al,6									 ;大于6，跳回去重新输入
	ja exit0

	dec al
	add al,al
	mov ah,0
	mov bx,ax
	changeline
	call funtable[bx]
	jmp start0
	
	mov ax,4c00h
	int 21h

exit0:
	changeline                
	out_dx tip7									 ;提示输入的选择有误
	jmp start0


;----------------------------------------------------------------------------------
function1 proc near
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	inputstunum 									;设置待录入的学生数量，放在stucnt中
	mov ax,0
	mov bx,0
	mov cx,stucnt
	mov dx,0
	mov di,0
	mov si,0
f1s0:	
	changeline
	out_dx tip2                                     ;输入学生的学号
	inputid si

	out_dx tip1
	inputname si                                     ;输入学生姓名
	changeline

	mov ctmp,cx                                      ;先把人数存起来
	mov cx,16										 ;16次作业相加
	mov ax,0

f1s1:
	out_dx tip8                               ;提示出入成绩
	inputgrade tempgrade                      ;输入的成绩暂时放在tempgrade中
	add ax,tempgrade                          ;把16次平时成绩加起来
	mov tempgrade,0
	loop f1s1

	mov cx,ctmp                                ;除以16得到平时成绩
	mov bl,16                                  ;放在grade1中
	div bl
	mov dl,al
	mov dh,0
	mov grade1[si],dx

	mov tempgrade3,dx                           ;这里其实是x4，为了简便加了4次
	add tempgrade3,dx							;(平时x4+大作业x6）/10
	add tempgrade3,dx
    add tempgrade3,dx

	out_dx tip10                                 ;要求输入大作业成绩，存放再tempgrade
	inputgrade tempgrade
	mov dx,tempgrade
	mov tempgrade,0
	mov grade2[si],dx                            ;对应位置的大作业成绩

	add tempgrade3,dx                             ;大作业x6，加上去
	add tempgrade3,dx
	add tempgrade3,dx
	add tempgrade3,dx
	add tempgrade3,dx
	add tempgrade3,dx	


	mov ax,tempgrade3
	mov bl,10
	div bl                                        ;除以10，得到最终成绩
	mov dl,al
	mov dh,0
	mov grade3[si],dx                             ;存入最终成绩

	;计算各个分数段的人数
	cmp dx,60                                     ;跳转到相应的计数部分
	jl f1s2                                       ;（有符号数）

	cmp dx,80
	jl f1s3

	cmp dx,90
	jl f1s4

	inc count3[6]                                ;count3是各个分数段的统计人数，
	jmp f1s5
f1s2:
	inc count3[0]
	jmp f1s5
f1s3:
	inc count3[2]
	jmp f1s5
f1s4:
	inc count3[4]
	jmp f1s5

f1s5:
	add averagegrade,dx                           ;总分累加
	cmp dx,highestgrade
	jng f1s6                                      ;不大于
	call highmove
f1s6:
	cmp dx,lowestgrade
	jnl f1s7
	call lowmove
f1s7:
	add si,2                                       ;更改偏移量
	dec cx
	jcxz f1ret
	jmp near ptr f1s0                              ;外部循环，使用jmp near
f1ret:
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	out_dx tip9
	ret
highmove:
	mov highestgrade,dx                           ;必要时改变最低成绩和最高成绩
	ret
lowmove:
	mov lowestgrade,dx
	ret

function1 endp

;-----------------------------------------------------------
function2 proc near                   ;输入学号查询学生信息
	push ax
	push bx
	push cx
	push si
	push di
	
	mov ax,0
	mov bx,0
	mov cx,stucnt
	mov di,0
	mov si,0
	out_dx tip4
	inputid 40                        ;id21
f2s0:
	mov ctmp,cx
	mov cx,10                         ;字符串长度为10，按位比较
	lea di,ID21
	add di,2
	mov si,idtable[bx]
	add si,2
	repz cmpsb

	jz f2s1
	add bx,2
	mov cx,ctmp
	loop f2s0

	changeline
	out_dx tip5                       ;找不到该学号，退出
	jmp f2s2

f2s1:
	out_dx tip13                                     ;提示查找成功

	out_dx show8									 ;输出名字
	out_dx2 nametable[bx]
	changeline

	out_dx show9                                     ;依次输出平时成绩，大作业成绩，总成绩
	mov ax,grade1[bx]
	call OUTPUT

	out_dx show10
	mov ax,grade2[bx]
	call OUTPUT

	out_dx show11
	mov ax,grade3[bx]
	call OUTPUT	

	changeline                                         ;比较完要把暂存空间重置

f2s2:
	mov bx,idtable[40]
	inc bx
	mov byte ptr [bx],0
	inc bx
	mov cx,10
f2s3:
	mov byte ptr [bx],'$'
	inc bx
	loop f2s3
	
	pop di
	pop si
	pop cx
	pop bx
	pop ax
	ret
function2 endp

;-----------------------------------------------------------
function3 proc near                        ;按姓名查询学生信息
	push ax
	push bx
	push cx
	push di
	push si

	mov ax,0
	mov bx,0
	mov cx,stucnt                         ;人数作为循环次数
	mov di,0
	mov si,0

	out_dx tip3
	inputname 40                          ;name21
f3s0:
	mov ctmp,cx
	mov cx,10                             ;姓名最长为10
	lea di,name21
	add di,2
	mov si,nametable[bx]
	add si,2
	repz cmpsb

	jz f3s1                                ;查找成功，跳转
	add bx,2
	mov cx,ctmp
	loop f3s0

	out_dx tip5                            ;查找失败，退出
	jmp f3s2

f3s1:
	out_dx tip12

	out_dx show12                          ;打印平时成绩，大作业成绩，总成绩
	out_dx2 idtable[bx]
	changeline

	out_dx show9
	mov ax,grade1[bx]
	call OUTPUT

	out_dx show10
	mov ax,grade2[bx]
	call OUTPUT

	out_dx show11
	mov ax,grade3[bx]
	call OUTPUT	

	changeline                                         ;比较完要把暂存空间重置
f3s2:
	mov bx,nametable[40]
	inc bx
	mov byte ptr [bx],0
	inc bx
	mov cx,10
f3s3:
	mov byte ptr [bx],'$'
	inc bx
	loop f3s3

	pop si
	pop di
	pop cx
	pop bx
	pop ax
	ret
function3 endp

;--------------------------------------------------------------
function4 proc near                       ;成绩排序，从低到高，显示姓名学号，成绩，排名
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ax,0
	mov bx,0
	mov dx,stucnt                          ;设置比较次数为学生人数-1
	sub dx,1                               ;因为是基于冒泡排序的，所以外循环次数要先-1
	mov di,0
	mov si,0

sort1:
	mov bl,0                               ;交换标志，也可以使用标志寄存器
	cmp dx,0							   
	jle sortexit
	mov cx,dx                              ;内循环次数
	mov si,0                               ;从第0位开始

sort2:
	mov ax,grade3[si]
	cmp ax,grade3[si+2]                     ;该字形数据与后一位字形数据比较
	jle dontchange                          ;小于或等于则不交换

	xchg ax,grade3[si+2]                    ;总成绩交换
	mov grade3[si],ax

	mov ax,grade2[si]                       ;交换大作业成绩
	xchg ax,grade2[si+2]
	mov grade2[si],ax	
	
	mov ax,grade1[si]                       ;交换平时作业成绩
	xchg ax,grade1[si+2]
	mov grade1[si],ax	

	mov ax,nametable[si]                    ;交换姓名
	xchg ax,nametable[si+2]
	mov nametable[si],ax

	mov ax,idtable[si]                       ;交换学号
	xchg ax,idtable[si+2]
	mov idtable[si],ax	
	mov bl,0ffh                              ;随便修改一下交换标志

dontchange:
	add si,2
	loop sort2
	dec dx
	cmp bl,0                                 ;检查交换标志
	jmp sort1	                             ;作为是否继续比较排序的标志
sortexit:
	mov bx,0
	mov cx,stucnt
rk:
	mov rank[bx],cx
	add bx,2
	loop rk

	mov bx,0
	mov cx,stucnt
	out_dx tip0
f4show:
	mov ah,1
	int 21H

	changeline                                ;输出学号，姓名，成绩，排名
	out_dx show12
	out_dx2 idtable[bx]
	changeline

	out_dx show8
	out_dx2 nametable[bx]
	changeline

	out_dx showtab1
	mov ax,grade1[bx]
	call OUTPUT
	out_dx showtab1

	mov ax,grade2[bx]
	call OUTPUT
	out_dx showtab1

	mov ax,grade3[bx]
	call OUTPUT
	out_dx showtab1

	mov ax,rank[bx]
	call OUTPUT
	out_dx showtab1

	add bx,2
	dec cx
	jcxz f4ret
	jmp near ptr f4show
f4ret:

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
function4 endp

;---------------------------------------------------------------
function5 proc near                     ;统计展示各个分数段的人数，基于总成绩
	push ax                             ;同时展示最高分，最低分和平均分
	push bx
	push dx
	
	mov ax,0
	mov bx,stucnt
	mov dx,0

	out_dx show5                                    ;show5 6 7分别输出平均成绩，最高成绩，最低成绩
	mov ax,averagegrade
	div bl
	mov dl,al
	mov dh,0
	mov ax,dx
	call OUTPUT
	changeline

	out_dx show6
	mov ax,highestgrade
	call OUTPUT
	changeline

	out_dx show7
	mov ax,lowestgrade
	call OUTPUT
	changeline	
	
	;以下打印各个分数段的人数
	out_dx show0
	mov ax,count3[0]                                 ;这里是function1统计好的人数
	call OUTPUT
	changeline

	out_dx show1
	mov ax,count3[2]
	call OUTPUT
	changeline

	out_dx show2
	mov ax,count3[4]
	call OUTPUT
	changeline

	out_dx show3
	mov ax,count3[6]
	call OUTPUT
	changeline	

	pop dx
	pop bx
	pop ax
	ret
function5 endp


;---------------------------------------------------------------
function6 proc near
	changeline                               ;感谢您的支持，退出程序
	out_dx tip14
	mov ax,4c00h
	int 21h
	ret
function6 endp

;----------------------------------------------------------------
OUTPUT proc near
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov si,OFFSET divnum                     ;获得除数的偏移地址
	mov di,OFFSET result                     ;获得存放结果的偏移地址
	mov cx,4
s0:
	mov dx,0                                 ;32位被除数和16位除数，结果商16位再ax,余数在dx
	div word ptr [si]

	add al,30h                                ;转化位ascii码
	mov byte ptr [di],al
	inc di
	add si,2
	mov ax,dx                                 ;余数给ax
	loop s0

	mov cx,3                                  ;循环(cx)==3
	mov di,OFFSET result

s1:
	cmp byte ptr [di],'0'
	jne s2                                     ;>0，可以跳出
	inc di
	loop s1

s2:
	mov dx,di
	mov ah,9
	int 21H

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
OUTPUT endp

code ends
end start