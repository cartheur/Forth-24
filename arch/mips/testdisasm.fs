\ Authors: Anton Ertl, David Kühling
\ Copyright (C) 2000,2003,2007,2010,2014,2019,2021 Free Software Foundation, Inc.

\ This file is part of Gforth.

\ Gforth is free software; you can redistribute it and/or
\ modify it under the terms of the GNU General Public License
\ as published by the Free Software Foundation, either version 3
\ of the License, or (at your option) any later version.

\ This program is distributed in the hope that it will be useful,
\ but WITHOUT ANY WARRANTY; without even the implied warranty of
\ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
\ GNU General Public License for more details.

\ You should have received a copy of the GNU General Public License
\ along with this program. If not, see http://www.gnu.org/licenses/.

ALSO ASSEMBLER
CREATE START

$3FFF820 l,  \ 31 31 31 add,  
$10020 l,    \ 0 0 1 add,     
$200020 l,   \ 0 1 0 add,     
$820 l,	    \ 1 0 0 add,     
$210820 l,   \ 1 1 1 add,     
$23FFFFFF l, \ 31 31 -1 addi, 
$20000001 l, \ 0 0 1 addi,    
$20200000 l, \ 0 1 0 addi,    
$20010000 l, \ 1 0 0 addi,    
$20210001 l, \ 1 1 1 addi,    
$27FFFFFF l, \ 31 31 -1 addil,
$24000001 l, \ 0 0 1 addil,   
$24200000 l, \ 0 1 0 addil,   
$24010000 l, \ 1 0 0 addil,   
$24210001 l, \ 1 1 1 addil,   
$3FFF821 l,  \ 31 31 31 addl, 
$10021 l,    \ 0 0 1 addl,    
$200021 l,   \ 0 1 0 addl,    
$821 l,	    \ 1 0 0 addl,    
$210821 l,   \ 1 1 1 addl,    
$3FFF824 l,  \ 31 31 31 and,  
$10024 l,    \ 0 0 1 and,     
$200024 l,   \ 0 1 0 and,     
$824 l,	    \ 1 0 0 and,     
$210824 l,   \ 1 1 1 and,     
$33FFFFFF l, \ 31 31 $FFFF and
$30000001 l, \ 0 0 $1 andi,   
$30200000 l, \ 0 1 $0 andi,   
$30010000 l, \ 1 0 $0 andi,   
$30210001 l, \ 1 1 $1 andi,   
$4500FFFF l, \ -1 bczf,       
$45000001 l, \ 1 bczf,        
$4501FFFF l, \ -1 bczt,       
$45010001 l, \ 1 bczt,        
$13FFFFFF l, \ 31 31 -1 beq,  
$10000001 l, \ 0 0 1 beq,     
$10010000 l, \ 0 1 0 beq,     
$10200000 l, \ 1 0 0 beq,     
$10210001 l, \ 1 1 1 beq,     
$7E1FFFF l,  \ 31 -1 bgez,    
$4010001 l,  \ 0 1 bgez,      
$4210000 l,  \ 1 0 bgez,      
$4210001 l,  \ 1 1 bgez,      
$7F1FFFF l,  \ 31 -1 bgezal,  
$4110001 l,  \ 0 1 bgezal,    
$4310000 l,  \ 1 0 bgezal,    
$4310001 l,  \ 1 1 bgezal,    
$1FE0FFFF l, \ 31 -1 bgtz,    
$1C000001 l, \ 0 1 bgtz,      
$1C200000 l, \ 1 0 bgtz,      
$1C200001 l, \ 1 1 bgtz,      
$1BE0FFFF l, \ 31 -1 blez,    
$18000001 l, \ 0 1 blez,      
$18200000 l, \ 1 0 blez,      
$18200001 l, \ 1 1 blez,      
$7E0FFFF l,  \ 31 -1 bltz,    
$4000001 l,  \ 0 1 bltz,      
$4200000 l,  \ 1 0 bltz,      
$4200001 l,  \ 1 1 bltz,      
$7F0FFFF l,  \ 31 -1 bltzal,  
$4100001 l,  \ 0 1 bltzal,    
$4300000 l,  \ 1 0 bltzal,    
$4300001 l,  \ 1 1 bltzal,    
$17FFFFFF l, \ 31 31 -1 bne,  
$14000001 l, \ 0 0 1 bne,     
$14010000 l, \ 0 1 0 bne,     
$14200000 l, \ 1 0 0 bne,     
$14210001 l, \ 1 1 1 bne,     
$D l,	    \ break,         
$445FF800 l, \ 31 31 1 cfcz,  
$44400800 l, \ 0 1 1 cfcz,    
$44410000 l, \ 1 0 1 cfcz,    
$44410800 l, \ 1 1 1 cfcz,    
$44DFF800 l, \ 31 31 1 ctcz,  
$44C00800 l, \ 0 1 1 ctcz,    
$44C10000 l, \ 1 0 1 ctcz,    
$44C10800 l, \ 1 1 1 ctcz,    
$3FF001A l,  \ 31 31 div,     
$1001A l,    \ 0 1 div,       
$20001A l,   \ 1 0 div,       
$21001A l,   \ 1 1 div,       
$3FF001B l,  \ 31 31 divl,    
$1001B l,    \ 0 1 divl,      
$20001B l,   \ 1 0 divl,      
$21001B l,   \ 1 1 divl,      
$BFFFFFF l,  \ $43FFFFFF j,   
$8000001 l,  \ $40000001 j,   
$FFFFFFF l,  \ $43FFFFFF jal, 
$C000001 l,  \ $40000001 jal, 
$3E0F809 l,  \ 31 31 jalr,    
$200009 l,   \ 0 1 jalr,      
$809 l,	    \ 1 0 jalr,      
$200809 l,   \ 1 1 jalr,      
$3E00008 l,  \ 31 jr,         
$200008 l,   \ 1 jr,          
$83FFFFFF l, \ 31 -1 31 lb,   
$80200000 l, \ 0 0 1 lb,      
$80000001 l, \ 0 1 0 lb,      
$80010000 l, \ 1 0 0 lb,      
$80210001 l, \ 1 1 1 lb,      
$93FFFFFF l, \ 31 -1 31 lbl,  
$90200000 l, \ 0 0 1 lbl,     
$90000001 l, \ 0 1 0 lbl,     
$90010000 l, \ 1 0 0 lbl,     
$90210001 l, \ 1 1 1 lbl,     
$87FFFFFF l, \ 31 -1 31 lh,   
$84200000 l, \ 0 0 1 lh,      
$84000001 l, \ 0 1 0 lh,      
$84010000 l, \ 1 0 0 lh,      
$84210001 l, \ 1 1 1 lh,      
$97FFFFFF l, \ 31 -1 31 lhl,  
$94200000 l, \ 0 0 1 lhl,     
$94000001 l, \ 0 1 0 lhl,     
$94010000 l, \ 1 0 0 lhl,     
$94210001 l, \ 1 1 1 lhl,     
$3C1FFFFF l, \ 31 $FFFF lui,  
$3C000001 l, \ 0 $1 lui,      
$3C010000 l, \ 1 $0 lui,      
$3C010001 l, \ 1 $1 lui,      
$8FFFFFFF l, \ 31 -1 31 lw,   
$8C200000 l, \ 0 0 1 lw,      
$8C000001 l, \ 0 1 0 lw,      
$8C010000 l, \ 1 0 0 lw,      
$8C210001 l, \ 1 1 1 lw,      
$C7FFFFFF l, \ 31 -1 31 lwc1, 
$C4200000 l, \ 0 0 1 lwc1,    
$C4000001 l, \ 0 1 0 lwc1,    
$C4010000 l, \ 1 0 0 lwc1,    
$C4210001 l, \ 1 1 1 lwc1,    
$8BFFFFFF l, \ 31 -1 31 lwl,  
$88200000 l, \ 0 0 1 lwl,     
$88000001 l, \ 0 1 0 lwl,     
$88010000 l, \ 1 0 0 lwl,     
$88210001 l, \ 1 1 1 lwl,     
$9BFFFFFF l, \ 31 -1 31 lwr,  
$98200000 l, \ 0 0 1 lwr,     
$98000001 l, \ 0 1 0 lwr,     
$98010000 l, \ 1 0 0 lwr,     
$98210001 l, \ 1 1 1 lwr,     
$441FF800 l, \ 31 31 1 mfcz,  
$44000800 l, \ 0 1 1 mfcz,    
$44010000 l, \ 1 0 1 mfcz,    
$44010800 l, \ 1 1 1 mfcz,    
$F810 l,	    \ 31 mfhi,       
$810 l,	    \ 1 mfhi,        
$F812 l,	    \ 31 mflo,       
$812 l,	    \ 1 mflo,        
$449FF800 l, \ 31 31 1 mtcz,  
$44800800 l, \ 0 1 1 mtcz,    
$44810000 l, \ 1 0 1 mtcz,    
$44810800 l, \ 1 1 1 mtcz,    
$3E00011 l,  \ 31 mthi,       
$200011 l,   \ 1 mthi,        
$3E00013 l,  \ 31 mtlo,       
$200013 l,   \ 1 mtlo,        
$3FF0018 l,  \ 31 31 mult,    
$10018 l,    \ 0 1 mult,      
$200018 l,   \ 1 0 mult,      
$210018 l,   \ 1 1 mult,      
$3FF0019 l,  \ 31 31 multl,   
$10019 l,    \ 0 1 multl,     
$200019 l,   \ 1 0 multl,     
$210019 l,   \ 1 1 multl,     
$3FFF827 l,  \ 31 31 31 nor,  
$10027 l,    \ 0 0 1 nor,     
$200027 l,   \ 0 1 0 nor,     
$827 l,	    \ 1 0 0 nor,     
$210827 l,   \ 1 1 1 nor,     
$3FFF825 l,  \ 31 31 31 or,   
$10025 l,    \ 0 0 1 or,      
$200025 l,   \ 0 1 0 or,      
$825 l,	    \ 1 0 0 or,      
$210825 l,   \ 1 1 1 or,      
$37FFFFFF l, \ 31 31 $FFFF ori
$34000001 l, \ 0 0 $1 ori,    
$34200000 l, \ 0 1 $0 ori,    
$34010000 l, \ 1 0 $0 ori,    
$34210001 l, \ 1 1 $1 ori,    
$A3FFFFFF l, \ 31 -1 31 sb,   
$A0200000 l, \ 0 0 1 sb,      
$A0000001 l, \ 0 1 0 sb,      
$A0010000 l, \ 1 0 0 sb,      
$A0210001 l, \ 1 1 1 sb,      
$A7FFFFFF l, \ 31 -1 31 sh,   
$A4200000 l, \ 0 0 1 sh,      
$A4000001 l, \ 0 1 0 sh,      
$A4010000 l, \ 1 0 0 sh,      
$A4210001 l, \ 1 1 1 sh,      
$3FFF82A l,  \ 31 31 31 slt,  
$1002A l,    \ 0 0 1 slt,     
$20002A l,   \ 0 1 0 slt,     
$82A l,	    \ 1 0 0 slt,     
$21082A l,   \ 1 1 1 slt,     
$2BFFFFFF l, \ 31 31 -1 slti, 
$28000001 l, \ 0 0 1 slti,    
$28200000 l, \ 0 1 0 slti,    
$28010000 l, \ 1 0 0 slti,    
$28210001 l, \ 1 1 1 slti,    
$2FFFFFFF l, \ 31 31 -1 sltil,
$2C000001 l, \ 0 0 1 sltil,   
$2C200000 l, \ 0 1 0 sltil,   
$2C010000 l, \ 1 0 0 sltil,   
$2C210001 l, \ 1 1 1 sltil,   
$3FFF82B l,  \ 31 31 31 sltl, 
$1002B l,    \ 0 0 1 sltl,    
$20002B l,   \ 0 1 0 sltl,    
$82B l,	    \ 1 0 0 sltl,    
$21082B l,   \ 1 1 1 sltl,    
$3FFF822 l,  \ 31 31 31 sub,  
$10022 l,    \ 0 0 1 sub,     
$200022 l,   \ 0 1 0 sub,     
$822 l,	    \ 1 0 0 sub,     
$210822 l,   \ 1 1 1 sub,     
$3FFF823 l,  \ 31 31 31 subl, 
$10023 l,    \ 0 0 1 subl,    
$200023 l,   \ 0 1 0 subl,    
$823 l,	    \ 1 0 0 subl,    
$210823 l,   \ 1 1 1 subl,    
$AFFFFFFF l, \ 31 -1 31 sw,   
$AC200000 l, \ 0 0 1 sw,      
$AC000001 l, \ 0 1 0 sw,      
$AC010000 l, \ 1 0 0 sw,      
$AC210001 l, \ 1 1 1 sw,      
$E7FFFFFF l, \ 31 -1 31 swc1, 
$E4200000 l, \ 0 0 1 swc1,    
$E4000001 l, \ 0 1 0 swc1,    
$E4010000 l, \ 1 0 0 swc1,    
$E4210001 l, \ 1 1 1 swc1,    
$ABFFFFFF l, \ 31 -1 31 swl,  
$A8200000 l, \ 0 0 1 swl,     
$A8000001 l, \ 0 1 0 swl,     
$A8010000 l, \ 1 0 0 swl,     
$A8210001 l, \ 1 1 1 swl,     
$BBFFFFFF l, \ 31 -1 31 swr,  
$B8200000 l, \ 0 0 1 swr,     
$B8000001 l, \ 0 1 0 swr,     
$B8010000 l, \ 1 0 0 swr,     
$B8210001 l, \ 1 1 1 swr,     
$C l,	    \ syscall,       
$42000008 l, \ tlbl,          
$42000001 l, \ tlbr,          
$42000002 l, \ tlbwi,         
$42000006 l, \ tlbwr,         
$3FFF826 l,  \ 31 31 31 xor,  
$10026 l,    \ 0 0 1 xor,     
$200026 l,   \ 0 1 0 xor,     
$826 l,	    \ 1 0 0 xor,     
$210826 l,   \ 1 1 1 xor,     
$3BFFFFFF l, \ 31 31 $FFFF xor
$38000001 l, \ 0 0 $1 xori,   
$38200000 l, \ 0 1 $0 xori,   
$38010000 l, \ 1 0 $0 xori,   
$38210001 l, \ 1 1 $1 xori,   
$3E0F821 l,  \ 31 31 0 addl,  
$200021 l,   \ 0 1 0 addl,    
$821 l,	    \ 1 0 0 addl,    
$200821 l,   \ 1 1 0 addl,    
$7E10002 l,  \ 31 2 bgez,     
$3E0F821 l,  \ 31 31 0 addl,  
$1FF822 l,   \ 31 0 31 sub,   
$4210002 l,  \ 1 2 bgez,      
$200021 l,   \ 0 1 0 addl,    
$10022 l,    \ 0 0 1 sub,     
$4010002 l,  \ 0 2 bgez,      
$821 l,	    \ 1 0 0 addl,    
$822 l,	    \ 1 0 0 sub,     
$4210002 l,  \ 1 2 bgez,      
$200821 l,   \ 1 1 0 addl,    
$10822 l,    \ 1 0 1 sub,     
$1FF822 l,   \ 31 0 31 sub,   
$10022 l,    \ 0 0 1 sub,     
$822 l,	    \ 1 0 0 sub,     
$10822 l,    \ 1 0 1 sub,     
$1FF823 l,   \ 31 0 31 subl,  
$10023 l,    \ 0 0 1 subl,    
$823 l,	    \ 1 0 0 subl,    
$10823 l,    \ 1 0 1 subl,    
$3E0F827 l,  \ 31 31 0 nor,   
$200027 l,   \ 0 1 0 nor,     
$827 l,	    \ 1 0 0 nor,     
$200827 l,   \ 1 1 0 nor,     
$3FF082A l,  \ 1 31 31 slt,   
$1420FFFF l, \ 1 0 -1 bne,    
$82A l,	    \ 1 0 0 slt,     
$14200001 l, \ 1 0 1 bne,     
$1082A l,    \ 1 0 1 slt,     
$14200000 l, \ 1 0 0 bne,     
$20082A l,   \ 1 1 0 slt,     
$14200000 l, \ 1 0 0 bne,     
$21082A l,   \ 1 1 1 slt,     
$14200001 l, \ 1 0 1 bne,     
$3FF082A l,  \ 1 31 31 slt,   
$1020FFFF l, \ 1 0 -1 beq,    
$82A l,	    \ 1 0 0 slt,     
$10200001 l, \ 1 0 1 beq,     
$20082A l,   \ 1 1 0 slt,     
$10200000 l, \ 1 0 0 beq,     
$1082A l,    \ 1 0 1 slt,     
$10200000 l, \ 1 0 0 beq,     
$21082A l,   \ 1 1 1 slt,     
$10200001 l, \ 1 0 1 beq,     
$3FF082A l,  \ 1 31 31 slt,   
$1420FFFF l, \ 1 0 -1 bne,    
$82A l,	    \ 1 0 0 slt,     
$14200001 l, \ 1 0 1 bne,     
$20082A l,   \ 1 1 0 slt,     
$14200000 l, \ 1 0 0 bne,     
$1082A l,    \ 1 0 1 slt,     
$14200000 l, \ 1 0 0 bne,     
$21082A l,   \ 1 1 1 slt,     
$14200001 l, \ 1 0 1 bne,     
$3FF082B l,  \ 1 31 31 sltl,  
$1020FFFF l, \ 1 0 -1 beq,    
$82B l,	    \ 1 0 0 sltl,    
$10200001 l, \ 1 0 1 beq,     
$1082B l,    \ 1 0 1 sltl,    
$10200000 l, \ 1 0 0 beq,     
$20082B l,   \ 1 1 0 sltl,    
$10200000 l, \ 1 0 0 beq,     
$21082B l,   \ 1 1 1 sltl,    
$10200001 l, \ 1 0 1 beq,     
$3FF082B l,  \ 1 31 31 sltl,  
$1420FFFF l, \ 1 0 -1 bne,    
$82B l,	    \ 1 0 0 sltl,    
$14200001 l, \ 1 0 1 bne,     
$1082B l,    \ 1 0 1 sltl,    
$14200000 l, \ 1 0 0 bne,     
$20082B l,   \ 1 1 0 sltl,    
$14200000 l, \ 1 0 0 bne,     
$21082B l,   \ 1 1 1 sltl,    
$14200001 l, \ 1 0 1 bne,     
$3FF082B l,  \ 1 31 31 sltl,  
$1020FFFF l, \ 1 0 -1 beq,    
$82B l,	    \ 1 0 0 sltl,    
$10200001 l, \ 1 0 1 beq,     
$20082B l,   \ 1 1 0 sltl,    
$10200000 l, \ 1 0 0 beq,     
$1082B l,    \ 1 0 1 sltl,    
$10200000 l, \ 1 0 0 beq,     
$21082B l,   \ 1 1 1 sltl,    
$10200001 l, \ 1 0 1 beq,     
$3FF082B l,  \ 1 31 31 sltl,  
$1420FFFF l, \ 1 0 -1 bne,    
$82B l,	    \ 1 0 0 sltl,    
$14200001 l, \ 1 0 1 bne,     
$20082B l,   \ 1 1 0 sltl,    
$14200000 l, \ 1 0 0 bne,     
$1082B l,    \ 1 0 1 sltl,    
$14200000 l, \ 1 0 0 bne,     
$21082B l,   \ 1 1 1 sltl,    
$14200001 l, \ 1 0 1 bne,     
$3FF082B l,  \ 1 31 31 sltl,  
$1020FFFF l, \ 1 0 -1 beq,    
$82B l,	    \ 1 0 0 sltl,    
$10200001 l, \ 1 0 1 beq,     
$1082B l,    \ 1 0 1 sltl,    
$10200000 l, \ 1 0 0 beq,     
$20082B l,   \ 1 1 0 sltl,    
$10200000 l, \ 1 0 0 beq,     
$21082B l,   \ 1 1 1 sltl,    
$10200001 l, \ 1 0 1 beq,     
$70650802 l, \ 1 3 5 mul,
$70230000 l, \ 1 3 madd,
$70230001 l, \ 1 3 maddu,
$70230004 l, \ 1 3 msub,
$70230005 l, \ 1 3 msubu,
$70A31820 l, \ 3 5 clz,
$70A31821 l, \ 3 5 clo,
$65080A l, \ 1 3 5 movz
$65080B l, \ 1 3 5 movn
$684104d2 l, \ 	ldl	at,1234(v0)
$6c4104d2 l, \ 	ldr	at,1234(v0)
$c04104d2 l, \ 	ll	at,1234(v0)
$d04104d2 l, \ 	lld	at,1234(v0)
$dc4104d2 l, \ 	ld	at,1234(v0)
$e04104d2 l, \ 	sc	at,1234(v0)
$f04104d2 l, \ 	scd	at,1234(v0)
$fc4104d2 l, \ 	sd	at,1234(v0)
$50220001 l, \ 	beql	at,v0,0x608
$54220001 l, \ 	bnel	at,v0,0x60c
$58200001 l, \ 	blezl	at,0x610
$5c200001 l, \ 	bgtzl	at,0x614
$00640030 l, \ 	tge	v1,a0
$00640031 l, \ 	tgeu	v1,a0
$00640032 l, \ 	tlt	v1,a0
$00640033 l, \ 	tltu	v1,a0
$00640034 l, \ 	teq	v1,a0
$00640036 l, \ 	tne	v1,a0
$046804d2 l, \ 	tgei	v1,1234
$046904d2 l, \ 	tgeiu	v1,1234
$046a04d2 l, \ 	tlti	v1,1234
$046b04d2 l, \ 	tltiu	v1,1234
$046c04d2 l, \ 	teqi	v1,1234
$046e04d2 l, \ 	tnei	v1,1234
$0043082c l, \ 	dadd	at,v0,v1
$0043082d l, \ 	daddu	at,v0,v1
$0043082e l, \ 	dsub	at,v0,v1
$0043082f l, \ 	dsubu	at,v0,v1
$0022001c l, \ 	dmult	at,v0
$00220019 l, \ 	multu	at,v0
$0022001e l, \ 	ddiv	zero,at,v0
$03df001f l, \ 	ddivu	zero,s8,ra
$00620814 l, \ 	dsllv	at,v0,v1
$00620816 l, \ 	dsrlv	at,v0,v1
$00620817 l, \ 	dsrav	at,v0,v1
$00020c78 l, \ 	dsll	at,v0,0x11
$00020c7a l, \ 	dsrl	at,v0,0x11
$00020c7b l, \ 	dsra	at,v0,0x11
$00020c7c l, \ 	dsll32	at,v0,0x11
$00020c7e l, \ 	dsrl32	at,v0,0x11
$00020c7f l, \ 	dsra32	at,v0,0x11
$7c0a583b l, \ 	rdhwr	t2,$11
$7c0b5420 l, \ 	seb	t2,t3
$7c0b50a0 l, \ 	wsbh	t2,t3

START HERE OVER - discode
CR
