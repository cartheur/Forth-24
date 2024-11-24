#line 1 "prim"
\ Gforth primitives

\ Authors: Bernd Paysan, Anton Ertl, Neal Crook, Jens Wilke, David Kühling, Gerald Wodni
\ Copyright (C) 1995,1996,1997,1998,2000,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023 Free Software Foundation, Inc.

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


\ WARNING: This file is processed by m4. Make sure your identifiers
\ don't collide with m4's (e.g. by undefining them).
\ 
\ 
\ 
\ This file contains primitive specifications in the following format:
\ 
\ forth name	( stack effect )	category	[pronunciation]
\ [""glossary entry""]
\ C code
\ [:
\ Forth code]
\ 
\ Note: Fields in brackets are optional.  Word specifications have to
\ be separated by at least one empty line
\
\ Both pronounciation and stack items (in the stack effect) must
\ conform to the C identifier syntax or the C compiler will complain.
\ If you don't have a pronounciation field, the Forth name is used,
\ and has to conform to the C identifier syntax.
\ 
\ These specifications are automatically translated into C-code for the
\ interpreter and into some other files. I hope that your C compiler has
\ decent optimization, otherwise the automatically generated code will
\ be somewhat slow. The Forth version of the code is included for manual
\ compilers, so they will need to compile only the important words.
\ 
\ Note that stack pointer adjustment is performed according to stack
\ effect by automatically generated code and NEXT is automatically
\ appended to the C code. Also, you can use the names in the stack
\ effect in the C code. Stack access is automatic. One exception: if
\ your code does not fall through, the results are not stored into the
\ stack. Use different names on both sides of the '--', if you change a
\ value (some stores to the stack are optimized away).
\
\ For superinstructions the syntax is:
\
\ forth-name [/ c-name] = forth-name forth-name ...
\
\ 
\ The stack variables have the following types:
\ 
\ name matches	type
\ f.*		Bool
\ c.*		Char
\ [nw].*	Cell
\ u.*		UCell
\ d.*		DCell
\ ud.*		UDCell
\ r.*		Float
\ a_.*		Cell *
\ c_.*		Char *
\ f_.*		Float *
\ df_.*		DFloat *
\ sf_.*		SFloat *
\ xt.*		XT
\ f83name.*	F83Name *

\E stack data-stack   sp Cell
\E stack fp-stack     fp Float
\E stack return-stack rp Cell
\E
\E [IFDEF] prim-stacks here to prim-stacks data-stack , return-stack , fp-stack , 0 , [THEN]
\E    \ for output-stack-effects
\E
\E get-current prefixes set-current
\E 
\E s" Bool"		single data-stack type-prefix f
\E s" Char"		single data-stack type-prefix c
\E s" Cell"		single data-stack type-prefix n
\E s" Cell"		single data-stack type-prefix w
\E s" Cell"		single data-stack type-prefix x
\E s" UCell"		single data-stack type-prefix u
\E s" DCell"		double data-stack type-prefix d
\E s" UDCell"		double data-stack type-prefix ud
\E s" Float"		single fp-stack   type-prefix r
\E s" Cell *"		single data-stack type-prefix a_
\E s" Char *"		single data-stack type-prefix c_
\E s" Float *"		single data-stack type-prefix f_
\E s" DFloat *"		single data-stack type-prefix df_
\E s" SFloat *"		single data-stack type-prefix sf_
\E s" Xt"		single data-stack type-prefix xt
\E s" struct F83Name *"	single data-stack type-prefix f83name
\E s" struct Longname *" single data-stack type-prefix longname
\E 
\E data-stack   stack-prefix S:
\E fp-stack     stack-prefix F:
\E return-stack stack-prefix R:
\E inst-stream  stack-prefix #
\E 
\E set-current
\E store-optimization on
\E ' noop tail-nextp2 ! \ now INST_TAIL just stores, but does not jump
\E
\E include-skipped-insts on \ static superinsts include cells for components
\E                            \ useful for dynamic programming and
\E                            \ superinsts across entry points

\ 
\ 
\ 
\ In addition the following names can be used:
\ ip	the instruction pointer
\ sp	the data stack pointer
\ rp	the parameter stack pointer
\ lp	the locals stack pointer
\ NEXT	executes NEXT
\ cfa	
\ NEXT1	executes NEXT1
\ FLAG(x)	makes a Forth flag from a C flag
\ 
\ 
\ 
\ Percentages in comments are from Koopmans book: average/maximum use
\ (taken from four, not very representative benchmarks)
\ 
\ 
\ 
\ To do:
\ 
\ throw execute, cfa and NEXT1 out?
\ macroize *ip, ip++, *ip++ (pipelining)?

\ Stack caching setup

#line 1 "cache0.vmg"
\ stack cache setup

\ Author: Anton Ertl
\ Copyright (C) 2003,2007,2019 Free Software Foundation, Inc.

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

\E register IPTOS Cell
\E register spa Cell
\E register spb Cell
\E register spc Cell
\E register spd Cell

\E create IPregs IPTOS ,
\E create regs spc , spb , spa ,

\E IPregs 1 0 stack-state IPss1
\E regs 3 th 0  0 stack-state ss0
\E regs 2 th 1  0 stack-state ss1
\E regs 1 th 2  1 stack-state ss2
\E regs 0 th 3  2 stack-state ss3

\ the first of these is the default state
\E state S0
\E state S1
\E state S2
\E state S3

\E ss0 data-stack S0 set-ss
\E ss1 data-stack S1 set-ss
\E ss2 data-stack S2 set-ss
\E ss3 data-stack S3 set-ss

\E IPss1 inst-stream S0 set-ss
\E IPss1 inst-stream S1 set-ss
\E IPss1 inst-stream S2 set-ss
\E IPss1 inst-stream S3 set-ss

\E data-stack to cache-stack
\E here 4 cache-states 2! s0 , s1 , s2 , s3 ,

\ !! the following should be automatic
\E S0 to state-default
\E state-default to state-in
\E state-default to state-out
#line 147 "prim"


\ these m4 macros would collide with identifiers




\ define m4 macro forloop (taken from /usr/share/doc/m4/examples/forloop2.m4)
#line 166 "prim"

#line 168

\F 0 [if]

\ run-time routines for non-primitives.  They are defined as
\ primitives, because that simplifies things.

(docol)	( -- R:a_retaddr )	gforth-internal	paren_docol
""run-time routine for colon definitions""
#ifdef DEBUG
    {
      CFA_TO_NAME(CFA);
      if(len>0x1F)
	debugp(stderr,"%08lx: call %08lx noname\n",(Cell)ip,(Cell)CFA);
      else
	debugp(stderr,"%08lx: call %08lx %.*s\n",(Cell)ip,(Cell)CFA,
	       len,name);
    }
#endif
a_retaddr = (Cell *)IP;
SET_IP((Xt *)PFA(CFA));

(docon) ( -- w )	gforth-internal	paren_docon
""run-time routine for constants""
w = *(Cell *)PFA(CFA);

(dovar) ( -- a_body )	gforth-internal	paren_dovar
""run-time routine for variables and CREATEd words""
a_body = PFA(CFA);

(douser) ( -- a_user )	gforth-internal	paren_douser
""run-time routine for constants""
a_user = (Cell *)(((Address)up)+*(Cell *)PFA(CFA));

(dodefer) ( -- )	gforth-internal	paren_dodefer
""run-time routine for deferred words""
ip=IP; /* undo any ip updating that may have been performed by NEXT_P0 */
SUPER_END; /* !! probably unnecessary and may lead to measurement errors */
VM_JUMP(EXEC1(*(Xt *)PFA(CFA)));

(dofield) ( n1 -- n2 )	gforth-internal	paren_field
""run-time routine for fields""
n2 = n1 + *(Cell *)PFA(CFA);

(dovalue) ( -- w )	gforth-internal	paren_doval
""run-time routine for constants""
w = *(Cell *)PFA(CFA);

(dodoes) ( -- a_body )  gforth-internal       paren_dodoes
a_body = PFA(CFA);
ip=IP; /* undo any ip updating that may have been performed by NEXT_P0 */
SUPER_END; /* !! probably unnecessary and may lead to measurement errors */
VM_JUMP(EXEC1(EXTRA_CODEXT(CFA)));

(doabicode) ( ... -- ...)	gforth-internal	paren_doabicode
""run-time routine for @code{ABI-code} definitions""
abifunc *f = (abifunc *)PFA(CFA);
Float *fp_mem = fp;
sp = (*f)(sp, &fp_mem);
fp = fp_mem;

(do;abicode) ( ... -- ... ) gforth-internal paren_do_semicolon_abi_code
""run-time routine for @code{;abi-code}-defined words""
Float *fp_mem = fp;
Address body = (Address)PFA(CFA);
semiabifunc *f = (semiabifunc *)EXTRA_CODE(CFA);
sp = (*f)(sp, &fp_mem, body);
fp = fp_mem;

\F [endif]

\g control

noop	( -- )		gforth
:
 ;

call	( #a_callee -- R:a_retaddr )	new
""Call callee (a variant of docol with inline argument).""
#ifdef DEBUG
    {
      CFA_TO_NAME((Cell *)a_callee);
      if(len>0x1F)
	debugp(stderr,"%08lx: call %08lx noname\n",(Cell)ip,(Cell)a_callee);
      else
	debugp(stderr,"%08lx: call %08lx %.*s\n",(Cell)ip,(Cell)a_callee,
	       len,name);
    }
#endif
a_retaddr = (Cell *)IP;
SET_IP((Xt *)a_callee);

execute	( xt -- )		core
""Perform the semantics represented by the execution token, @i{xt}.""
#ifdef DEBUG
debugp(stderr, "execute %08x\n", xt);
#endif
ip=IP;
SUPER_END;
VM_JUMP(EXEC1(xt));

perform	( a_addr -- )	gforth
""@code{@@ execute}.""
/* and pfe */
ip=IP;
SUPER_END;
VM_JUMP(EXEC1(*(Xt *)a_addr));
:
 @ execute ;

;s	( R:w -- )		gforth	semis
""The primitive compiled by @code{EXIT}.""
SET_IP((Xt *)w);

execute-;s ( xt R:w -- )	gforth-internal execute_semis
""The primitive compiled by @code{EXECUTE-EXIT}.""
#ifdef DEBUG
debugp(stderr, "execute-;s %08x\n", xt);
#endif
SET_IP((Xt *)w);
SUPER_END;
VM_JUMP(EXEC1(xt));

unloop	( R:w1 R:w2 -- )	core
/* !! alias for 2rdrop */
:
 r> rdrop rdrop >r ;

lit-perform	( #a_addr -- )	new	lit_perform
ip=IP;
SUPER_END;
VM_JUMP(EXEC1(*(Xt *)a_addr));

does-xt ( #a_cfa -- a_body )	new	extra_xt
a_body = PFA(a_cfa);
#ifdef DEBUG
    {
      CFA_TO_NAME(a_cfa);
      debugp(stderr,"%08lx: does %08lx %.*s exec %p\n",
	     (Cell)ip,(Cell)a_cfa,len,name,EXTRA_CODE(a_cfa));
    }
#endif
SUPER_END;
VM_JUMP(EXEC1(EXTRA_CODEXT(a_cfa)));

\+glocals

branch-lp+!# ( #a_target #nlocals -- )	gforth-internal	branch_lp_plus_store_number
/* this will probably not be used */
lp += nlocals;
ALIVE_DEBUGGING(lp[-1]);
SET_IP((Xt *)a_target);

\+

branch	( #a_target -- )	gforth-internal
SET_IP((Xt *)a_target);
:
 r> @ >r ;

\ condbranch(forthname,stackeffect,restline,code1,code2,forthcode)
\ this is non-syntactical: code must open a brace that is closed by the macro
#line 348


?branch (  #a_target f -- ) gforth-internal question_branch
#line 350
 if (f==0) {
#line 350
 SET_IP((Xt *)a_target);
#line 350
/* 0=0 */
#line 350
}
#line 350
/* 0=0 */
#line 350
:
#line 350
 0= dup 0=          \ !f f
#line 350
 r> tuck cell+      \ !f branchoffset f IP+
#line 350
 and -rot @ and or  \ f&IP+|!f&branch
#line 350
 >r ;
#line 350

#line 350
\+glocals
#line 350

#line 350
?branch-lp+!# (  #a_target #nlocals f -- ) gforth-internal question_branch_lp_plus_store_number
#line 350
	if (f==0) {
#line 350
	lp += nlocals;
#line 350
ALIVE_DEBUGGING(lp[-1]);
#line 350
SET_IP((Xt *)a_target);
#line 350
/* 0=0 */
#line 350
}
#line 350
/* 0=0 */
#line 350

#line 350
\+
#line 356


\ we don't need an lp_plus_store version of the ?dup-stuff, because it
\ is only used in if's (yet)

\+xconds

?dup-?branch ( #a_target f -- S:... ) gforth-internal question_dupe_question_branch
""The run-time procedure compiled by @code{?DUP-IF}.""
if (f==0) {
  SET_IP((Xt *)a_target);
} else {
  sp--;
  sp[0]=f;
}

?dup-0=-?branch ( #a_target f -- S:... ) gforth-internal question_dupe_zero_equals_question_branch
""The run-time procedure compiled by @code{?DUP-0=-IF}.""
if (f!=0) {
  sp--;
  sp[0]=f;
  SET_IP((Xt *)a_target);
}

\+
\fhas? skiploopprims 0= [IF]

(next) (  #a_target R:n1 -- R:n2 ) gforth-internal paren_next
#line 383
n2=n1-1;
#line 383
 if (n1) {
#line 383
 SET_IP((Xt *)a_target);
#line 383
/* 0=0 */
#line 383
}
#line 383
/* 0=0 */
#line 383
:
#line 383
 r> r> dup 1- >r
#line 383
 IF @ >r ELSE cell+ >r THEN ;
#line 383

#line 383
\+glocals
#line 383

#line 383
(next)-lp+!# (  #a_target #nlocals R:n1 -- R:n2 ) gforth-internal paren_next_lp_plus_store_number
#line 383
n2=n1-1;
#line 383
	if (n1) {
#line 383
	lp += nlocals;
#line 383
ALIVE_DEBUGGING(lp[-1]);
#line 383
SET_IP((Xt *)a_target);
#line 383
/* 0=0 */
#line 383
}
#line 383
/* 0=0 */
#line 383

#line 383
\+
#line 388


(loop) (  #a_target R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_loop
#line 390
n2=n1+1;
#line 390
 if (n2 != nlimit) {
#line 390
 SET_IP((Xt *)a_target);
#line 390
/* 0=0 */
#line 390
}
#line 390
/* 0=0 */
#line 390
:
#line 390
 r> r> 1+ r> 2dup =
#line 390
 IF >r 1- >r cell+ >r
#line 390
 ELSE >r >r @ >r THEN ;
#line 390

#line 390
\+glocals
#line 390

#line 390
(loop)-lp+!# (  #a_target #nlocals R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_loop_lp_plus_store_number
#line 390
n2=n1+1;
#line 390
	if (n2 != nlimit) {
#line 390
	lp += nlocals;
#line 390
ALIVE_DEBUGGING(lp[-1]);
#line 390
SET_IP((Xt *)a_target);
#line 390
/* 0=0 */
#line 390
}
#line 390
/* 0=0 */
#line 390

#line 390
\+
#line 396


(+loop) (  #a_target n R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_plus_loop
#line 398
/* sign bit manipulation and test: (x^y)<0 is equivalent to (x<0) != (y<0) */
#line 398
/* dependent upon two's complement arithmetic */
#line 398
Cell olddiff = (n1-nlimit)
#line 398
#ifdef HAVE___BUILTIN_ADD_OVERFLOW
#line 398
               ^(0x80UL<<((sizeof(Cell)-1)*8))
#line 398
#endif
#line 398
;
#line 398
n2=n1+n;	
#line 398
 if (
#line 398
#ifdef HAVE___BUILTIN_ADD_OVERFLOW
#line 398
!__builtin_add_overflow(olddiff,n,&olddiff)
#line 398
#else
#line 398
     ((olddiff^(olddiff+n))    /* the limit is not crossed */
#line 398
      &(olddiff^n))            /* OR it is a wrap-around effect */
#line 398
     >=0
#line 398
#endif
#line 398
) {
#line 398
 SET_IP((Xt *)a_target);
#line 398
/* 0=0 */
#line 398
}
#line 398
/* 0=0 */
#line 398
:
#line 398
 r> swap
#line 398
 r> r> 2dup - >r
#line 398
 2 pick r@ + r@ xor 0< 0=
#line 398
 3 pick r> xor 0< 0= or
#line 398
 IF    >r + >r @ >r
#line 398
 ELSE  >r >r drop cell+ >r THEN ;
#line 398

#line 398
\+glocals
#line 398

#line 398
(+loop)-lp+!# (  #a_target #nlocals n R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_plus_loop_lp_plus_store_number
#line 398
/* sign bit manipulation and test: (x^y)<0 is equivalent to (x<0) != (y<0) */
#line 398
/* dependent upon two's complement arithmetic */
#line 398
Cell olddiff = (n1-nlimit)
#line 398
#ifdef HAVE___BUILTIN_ADD_OVERFLOW
#line 398
               ^(0x80UL<<((sizeof(Cell)-1)*8))
#line 398
#endif
#line 398
;
#line 398
n2=n1+n;	
#line 398
	if (
#line 398
#ifdef HAVE___BUILTIN_ADD_OVERFLOW
#line 398
!__builtin_add_overflow(olddiff,n,&olddiff)
#line 398
#else
#line 398
     ((olddiff^(olddiff+n))    /* the limit is not crossed */
#line 398
      &(olddiff^n))            /* OR it is a wrap-around effect */
#line 398
     >=0
#line 398
#endif
#line 398
) {
#line 398
	lp += nlocals;
#line 398
ALIVE_DEBUGGING(lp[-1]);
#line 398
SET_IP((Xt *)a_target);
#line 398
/* 0=0 */
#line 398
}
#line 398
/* 0=0 */
#line 398

#line 398
\+
#line 422


\+xconds

(-loop) (  #a_target u R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_minus_loop
#line 426
n2=n1-u;
#line 426
 if ((nlimit-n2)>=u) {
#line 426
 SET_IP((Xt *)a_target);
#line 426
/* 0=0 */
#line 426
}
#line 426
/* 0=0 */
#line 426

#line 426

#line 426
\+glocals
#line 426

#line 426
(-loop)-lp+!# (  #a_target #nlocals u R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_minus_loop_lp_plus_store_number
#line 426
n2=n1-u;
#line 426
	if ((nlimit-n2)>=u) {
#line 426
	lp += nlocals;
#line 426
ALIVE_DEBUGGING(lp[-1]);
#line 426
SET_IP((Xt *)a_target);
#line 426
/* 0=0 */
#line 426
}
#line 426
/* 0=0 */
#line 426

#line 426
\+
#line 429


(/loop) (  #a_target u R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_slash_loop
#line 431
n2=n1+u;
#line 431
 if (n2-nlimit>=u) {
#line 431
 SET_IP((Xt *)a_target);
#line 431
/* 0=0 */
#line 431
}
#line 431
/* 0=0 */
#line 431

#line 431

#line 431
\+glocals
#line 431

#line 431
(/loop)-lp+!# (  #a_target #nlocals u R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_slash_loop_lp_plus_store_number
#line 431
n2=n1+u;
#line 431
	if (n2-nlimit>=u) {
#line 431
	lp += nlocals;
#line 431
ALIVE_DEBUGGING(lp[-1]);
#line 431
SET_IP((Xt *)a_target);
#line 431
/* 0=0 */
#line 431
}
#line 431
/* 0=0 */
#line 431

#line 431
\+
#line 434


(s+loop) (  #a_target n R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_symmetric_plus_loop
#line 436
""The run-time procedure compiled by S+LOOP. It loops until the index
#line 436
crosses the boundary between limit and limit-sign(n). I.e. a symmetric
#line 436
version of (+LOOP).""
#line 436
/* !! check this thoroughly */
#line 436
Cell diff = n1-nlimit;
#line 436
Cell newdiff = diff+n;
#line 436
if (n<0) {
#line 436
    diff = -diff;
#line 436
    newdiff = -newdiff;
#line 436
}
#line 436
n2=n1+n;
#line 436
 if (((~diff)|newdiff)<0) { /* use | to avoid two branches for gforth-native */
#line 436
 SET_IP((Xt *)a_target);
#line 436
/* 0=0 */
#line 436
}
#line 436
/* 0=0 */
#line 436

#line 436

#line 436
\+glocals
#line 436

#line 436
(s+loop)-lp+!# (  #a_target #nlocals n R:nlimit R:n1 -- R:nlimit R:n2 ) gforth-internal paren_symmetric_plus_loop_lp_plus_store_number
#line 436
""The run-time procedure compiled by S+LOOP. It loops until the index
#line 436
crosses the boundary between limit and limit-sign(n). I.e. a symmetric
#line 436
version of (+LOOP).""
#line 436
/* !! check this thoroughly */
#line 436
Cell diff = n1-nlimit;
#line 436
Cell newdiff = diff+n;
#line 436
if (n<0) {
#line 436
    diff = -diff;
#line 436
    newdiff = -newdiff;
#line 436
}
#line 436
n2=n1+n;
#line 436
	if (((~diff)|newdiff)<0) { /* use | to avoid two branches for gforth-native */
#line 436
	lp += nlocals;
#line 436
ALIVE_DEBUGGING(lp[-1]);
#line 436
SET_IP((Xt *)a_target);
#line 436
/* 0=0 */
#line 436
}
#line 436
/* 0=0 */
#line 436

#line 436
\+
#line 449


\+

(for)   ( ncount -- R:nlimit R:ncount )      gforth-internal paren_for
/* or (for) = >r -- collides with unloop! */
nlimit=0;
:
 r> swap 0 >r >r >r ;

(do)    ( nlimit nstart -- R:nlimit R:nstart )  gforth-internal   paren_do
:
 r> swap rot >r >r >r ;

(?do) ( #a_target nlimit nstart -- R:nlimit R:nstart ) gforth-internal paren_question_do
if (nstart == nlimit) {
    SET_IP((Xt *)a_target);
}
:
  2dup =
  IF   r> swap rot >r >r
       @ >r
  ELSE r> swap rot >r >r
       cell+ >r
  THEN ;				\ --> CORE-EXT

\+xconds

(+do) ( #a_target nlimit nstart -- R:nlimit R:nstart ) gforth-internal paren_plus_do
if (nstart >= nlimit) {
  SET_IP((Xt *)a_target);
}
:
 swap 2dup
 r> swap >r swap >r
 >=
 IF
     @
 ELSE
     cell+
 THEN  >r ;

(u+do) ( #a_target ulimit ustart -- R:ulimit R:ustart ) gforth-internal paren_u_plus_do
if (ustart >= ulimit) {
  SET_IP((Xt *)a_target);
}
:
 swap 2dup
 r> swap >r swap >r
 u>=
 IF
     @
 ELSE
     cell+
 THEN  >r ;

(-do) ( #a_target nlimit nstart -- R:nlimit R:nstart ) gforth-internal paren_minus_do
if (nstart <= nlimit) {
SET_IP((Xt *)a_target);
}
:
 swap 2dup
 r> swap >r swap >r
 <=
 IF
     @
 ELSE
     cell+
 THEN  >r ;

(u-do) ( #a_target ulimit ustart -- R:ulimit R:ustart ) gforth-internal paren_u_minus_do
if (ustart <= ulimit) {
SET_IP((Xt *)a_target);
}
:
 swap 2dup
 r> swap >r swap >r
 u<=
 IF
     @
 ELSE
     cell+
 THEN  >r ;

(-[do) ( #a_target nlimit nstart -- R:nlimit R:nstart ) gforth-internal paren_minus_bracket_do
if (nstart < nlimit) {
SET_IP((Xt *)a_target);
}
:
 swap 2dup
 r> swap >r swap >r
 <
 IF
     @
 ELSE
     cell+
 THEN  >r ;

(u-[do) ( #a_target ulimit ustart -- R:ulimit R:ustart ) gforth-internal paren_u_minus_bracket_do
if (ustart < ulimit) {
SET_IP((Xt *)a_target);
}
:
 swap 2dup
 r> swap >r swap >r
 u<
 IF
     @
 ELSE
     cell+
 THEN  >r ;


(try) ( ... #a_recovery -- R:a_recovery R:a_sp R:c_op R:f_fp R:c_lp R:a_oldhandler ) gforth-internal paren_try
a_oldhandler = SPs->handler;
a_sp = sp;
c_op = op;
f_fp = fp;
c_lp = lp;
SPs->handler = rp-6;
SPs->first_throw |= -(Cell)(SPs->first_throw == 0);

uncatch ( R:a_recovery R:a_sp R:c_op R:f_fp R:c_lp R:a_oldhandler -- ) gforth-internal
SPs->handler = a_oldhandler;

fast-throw ( ... wball -- ... wball ) gforth-experimental fast_throw
""Lightweight @code{throw} variant: only for non-zero balls, and
does not store a backtrace or deal with missing @code{catch}.""
rp = SPs->handler;
lp = (Address)rp[1];
fp = (Float *)rp[2];
op = (Char *)rp[3];
sp = (Cell *)rp[4];
SET_IP((Xt *)rp[5]);

\+

\ don't make any assumptions where the return stack is!!
\ implement this in machine code if it should run quickly!

i	( R:n -- R:n n )		core
""@i{n} is the index of the innermost counted loop.""
:
\ rp@ cell+ @ ;
  r> r> tuck >r >r ;

i'	( R:w R:w2 -- R:w R:w2 w )		gforth		i_tick
""The limit of the innermost counted loop""
:
\ rp@ cell+ cell+ @ ;
  r> r> r> dup itmp ! >r >r >r itmp @ ;
variable itmp

j	( R:n R:w1 R:w2 -- n R:n R:w1 R:w2 )	core
""@i{n} is the index of the next-to-innermost counted loop.""
:
\ rp@ cell+ cell+ cell+ @ ;
  r> r> r> r> dup itmp ! >r >r >r >r itmp @ ;
[IFUNDEF] itmp variable itmp [THEN]

k	( R:n R:w1 R:w2 R:w3 R:w4 -- n R:n R:w1 R:w2 R:w3 R:w4 )	gforth
""@i{n} is the index of the third-innermost counted loop.""
:
\ rp@ [ 5 cells ] Literal + @ ;
  r> r> r> r> r> r> dup itmp ! >r >r >r >r >r >r itmp @ ;
[IFUNDEF] itmp variable itmp [THEN]

bounds	  ( u1 u2 -- u3 u1 )	gforth
""Given a memory block represented by starting address @i{addr} and length @i{u} in aus, produce the end address @i{addr+u} and the start address in the right order for @code{u+do} or @code{?do}.""
u3=u1+u2;
:
 over + swap ;

delta-i	( r:ulimit r:u -- r:ulimit r:u u2 )	gforth	delta_i
""@i{u2}=@code{I'}-@code{I} (difference between limit and index).""
u2=ulimit-u;
:
 r> i' i - swap >r ;

r'@   ( r:w r:w2 -- r:w r:w2 w )	gforth	r_tick_fetch
""The second item on the return stack""
:
  r> r> r> dup itmp ! >r >r >r itmp @ ;
[IFUNDEF] itmp variable itmp [THEN]

rpick#	  ( #u -- w )	gforth-internal	rpick_num
w = rp[u];

\f[THEN]

\ digit is high-level: 0/0%

\g strings

move	( c_from c_to ucount -- )		core
""Copy the contents of @i{ucount} aus at @i{c-from} to
@i{c-to}. @code{move} works correctly even if the two areas overlap.""
/* !! note that the standard specifies addr, not c-addr */
memmove(c_to,c_from,ucount);
/* make an Ifdef for bsd and others? */
:
 >r 2dup u< IF r> cmove> ELSE r> cmove THEN ;

cmove	( c_from c_to u -- )	string	c_move
""Copy the contents of @i{ucount} characters from data space at
@i{c-from} to @i{c-to}. The copy proceeds @code{char}-by-@code{char}
from low address to high address; i.e., for overlapping areas it is
safe if @i{c-to}<=@i{c-from}.""
cmove(c_from,c_to,u);
:
 bounds ?DO  dup c@ I c! 1+  LOOP  drop ;

cmove>	( c_from c_to u -- )	string	c_move_up
""Copy the contents of @i{ucount} characters from data space at
@i{c-from} to @i{c-to}. The copy proceeds @code{char}-by-@code{char}
from high address to low address; i.e., for overlapping areas it is
safe if @i{c-to}>=@i{c-from}.""
cmove_up(c_from,c_to,u);
:
 dup 0= IF  drop 2drop exit  THEN
 rot over + -rot bounds swap 1-
 DO  1- dup c@ I c!  -1 +LOOP  drop ;

fill	( c_addr u c -- )	core
""Store @i{c} in @i{u} chars starting at @i{c-addr}.""
memset(c_addr,c,u);
:
 -rot bounds
 ?DO  dup I c!  LOOP  drop ;

compare	( c_addr1 u1 c_addr2 u2 -- n )	string
""Compare two strings lexicographically, based on the values of the
bytes in the strings (i.e., case-sensitive and without locale-specific
collation order). If they are equal, @i{n} is 0; if the string in
@i{c_addr1 u1} is smaller, @i{n} is -1; if it is larger, @i{n} is 1.""
n = compare(c_addr1, u1, c_addr2, u2);
:
 rot 2dup swap - >r min swap -text dup
 IF  rdrop  ELSE  drop r> sgn  THEN ;
: -text ( c_addr1 u c_addr2 -- n )
 swap bounds
 ?DO  dup c@ I c@ = WHILE  1+  LOOP  drop 0
 ELSE  c@ I c@ - unloop  THEN  sgn ;
: sgn ( n -- -1/0/1 )
 dup 0= IF EXIT THEN  0< 2* 1+ ;

\ -text is only used by replaced primitives now; move it elsewhere
\ -text	( c_addr1 u c_addr2 -- n )	new	dash_text
\ n = memcmp(c_addr1, c_addr2, u);
\ if (n<0)
\   n = -1;
\ else if (n>0)
\   n = 1;
\ :
\  swap bounds
\  ?DO  dup c@ I c@ = WHILE  1+  LOOP  drop 0
\  ELSE  c@ I c@ - unloop  THEN  sgn ;
\ : sgn ( n -- -1/0/1 )
\  dup 0= IF EXIT THEN  0< 2* 1+ ;

toupper	( c1 -- c2 )	gforth
""If @i{c1} is a lower-case ASCII character, @i{c2}
is the equivalent upper-case character, otherwise @i{c2} is @i{c1}.""
c2 = ('a'<=c1 && c1<='z') ? c1+('A'-'a') : c1;
:
 dup 'a' - [ char z char a - 1 + ] Literal u<  bl and - ;

capscompare	( c_addr1 u1 c_addr2 u2 -- n )	gforth
""Compare two strings lexicographically, based on the values of the
bytes in the strings, but comparing ASCII characters
case-insensitively, and non-ASCII characters case-sensitively and
without locale-specific collation order. If they are equal, @i{n} is
0; if the first string is smaller, @i{n} is -1; if the first string is
larger, @i{n} is 1. ""
/* close ' to keep fontify happy */ 
n = capscompare(c_addr1, u1, c_addr2, u2);

/string	( c_addr1 u1 n -- c_addr2 u2 )	string	slash_string
""Adjust the string specified by @i{c-addr1, u1} to remove @i{n}
characters from the start of the string.""
c_addr2 = c_addr1+n;
u2 = u1-n;
:
 tuck - >r + r> ;

safe/string	( c_addr1 u1 n -- c_addr2 u2 )	gforth	safe_slash_string
""Adjust the string specified by @i{c-addr1, u1} to remove @i{n}
characters from the start of the string.  Unlike @code{/string},
@code{safe/string} removes at least 0 and at most @i{u1} characters.""
if(n<0) {
  n=0;
}
if(((UCell)n)>u1) {
  n=u1;
}
c_addr2 = c_addr1+n;
u2 = u1-n;
:
 0 max over umin /string ;

\g arith

lit	( #w -- w )		gforth-internal
:
 r> dup @ swap cell+ >r ;

+	( n1 n2 -- n )		core	plus
n = n1+n2;

\ lit+ / lit_plus = lit +

lit+	( n1 #n2 -- n )		gforth-internal	lit_plus
#ifdef DEBUG
debugp(stderr, "lit+ %08x\n", n2);
#endif
n=n1+n2;

\ PFE-0.9.14 has it differently, but the next release will have it as follows
under+	( n1 n2 n3 -- n n2 )	gforth	under_plus
""add @i{n3} to @i{n1} (giving @i{n})""
n = n1+n3;
:
 rot + swap ;

-	( n1 n2 -- n )		core	minus
n = n1-n2;
:
 negate + ;

negate	( n1 -- n2 )		core
/* use minus as alias */
n2 = -n1;
:
 invert 1+ ;

1+	( n1 -- n2 )		core		one_plus
n2 = n1+1;
:
 1 + ;

1-	( n1 -- n2 )		core		one_minus
n2 = n1-1;
:
 1 - ;

max	( n1 n2 -- n )	core
if (n1<n2)
  n = n2;
else
  n = n1;
:
 2dup < IF swap THEN drop ;

min	( n1 n2 -- n )	core
if (n1<n2)
  n = n1;
else
  n = n2;
:
 2dup > IF swap THEN drop ;

abs	( n -- u )	core
if (n<0)
  u = -n;
else
  u = n;
:
 dup 0< IF negate THEN ;

*	( n1 n2 -- n )		core	star
n = n1*n2;
:
 um* drop ;

/f	( n1 n2 -- n )		gforth	slash_f
if (CHECK_DIVISION_SW && n2 == -1 && n1 == CELL_MIN)
  throw(BALL_RESULTRANGE);
if (CHECK_DIVISION_SW && n2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(n2);
n=n1/n2;
if ((n1^n2)<0 && (n1%n2 != 0))
  n--;
:
 /modf nip ;

modf	( n1 n2 -- n )		gforth
if (CHECK_DIVISION_SW && n2 == -1 && n1 == CELL_MIN)
  throw(BALL_RESULTRANGE);
if (CHECK_DIVISION_SW && n2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(n2);
n = n1%n2;
if ((Cell)((n1^n2) < 0) && (Cell)(n != 0))
  n += n2; 
:
 /modf drop ;

/modf	( n1 n2 -- n3 n4 )		gforth		slash_mod_f
""n1=n2*n4+n3; n3 is the modulus, n4 the quotient""
if (CHECK_DIVISION_SW && n2 == -1 && n1 == CELL_MIN)
  throw(BALL_RESULTRANGE);
if (CHECK_DIVISION_SW && n2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(n2);
n4 = n1/n2;
n3 = n1%n2;
if ((n1^n2)<0 && n3!=0) {
  n4 -= 1;
  n3 += n2;
}
:
 >r s>d r> fm/mod ;

*/modf  ( n1 n2 n3 -- n4 n5 )   gforth  star_slash_mod_f
""n1*n2=n3*n5+n4, with the intermediate result (n1*n2) being
double; n4 is the modulus, n5 the quotient""
#ifdef BUGGY_LL_MUL
DCell d = mmul(n1,n2);
#else
DCell d = (DCell)n1 * (DCell)n2;
#endif
#ifdef ASM_SM_SLASH_REM
SAVE_DIVISOR(n3);
ASM_SM_SLASH_REM(DLO(d), DHI(d), n3, n4, n5);
if ((DHI(d)^n3)<0 && n4!=0) {
  if (CHECK_DIVISION && n5 == CELL_MIN)
    throw(BALL_RESULTRANGE);
  n5--;
  n4 += n3;
}
#else
DCell r = fmdiv(d,n3);
n4=DHI(r);
n5=DLO(r);
#endif
:
 >r m* r> fm/mod ;

*/f	( n1 n2 n3 -- n4 )	gforth	star_slash_f
""n4=(n1*n2)/n3, with the intermediate result being double""
#ifdef BUGGY_LL_MUL
DCell d = mmul(n1,n2);
#else
DCell d = (DCell)n1 * (DCell)n2;
#endif
#ifdef ASM_SM_SLASH_REM
Cell remainder;
SAVE_DIVISOR(n3);
ASM_SM_SLASH_REM(DLO(d), DHI(d), n3, remainder, n4);
if ((DHI(d)^n3)<0 && remainder!=0) {
  if (CHECK_DIVISION && n4 == CELL_MIN)
    throw(BALL_RESULTRANGE);
  n4--;
}
#else
DCell r = fmdiv(d,n3);
n4=DLO(r);
#endif
:
 */modf nip ;

/s	( n1 n2 -- n )		gforth	slash_s
if (CHECK_DIVISION_SW && n2 == -1 && n1 == CELL_MIN)
  throw(BALL_RESULTRANGE);
if (CHECK_DIVISION_SW && n2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(n2);
n = n1/n2;
:
 /mods nip ;

mods	( n1 n2 -- n )		gforth  mod_s
if (CHECK_DIVISION_SW && n2 == -1 && n1 == CELL_MIN)
  throw(BALL_RESULTRANGE);
if (CHECK_DIVISION_SW && n2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(n2);
n = n1%n2;
:
 /mods drop ;

/mods	( n1 n2 -- n3 n4 )		gforth		slash_mod_s
""n1=n2*n4+n3; n3 is the remainder, n4 the quotient""
if (CHECK_DIVISION_SW && n2 == -1 && n1 == CELL_MIN)
  throw(BALL_RESULTRANGE);
if (CHECK_DIVISION_SW && n2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(n2);
n4 = n1/n2;
n3 = n1%n2;
:
 >r s>d r> sm/rem ;

*/mods	( n1 n2 n3 -- n4 n5 )	gforth	star_slash_mod_s
""n1*n2=n3*n5+n4, with the intermediate result (n1*n2) being double;
n4 is the remainder, n5 the quotient""
#ifdef BUGGY_LL_MUL
DCell d = mmul(n1,n2);
#else
DCell d = (DCell)n1 * (DCell)n2;
#endif
#ifdef ASM_SM_SLASH_REM
SAVE_DIVISOR(n3);
ASM_SM_SLASH_REM(DLO(d), DHI(d), n3, n4, n5);
#else
DCell r = smdiv(d,n3);
n4=DHI(r);
n5=DLO(r);
#endif
:
 >r m* r> sm/rem ;

*/s	( n1 n2 n3 -- n4 )	gforth	star_slash_s
""n4=(n1*n2)/n3, with the intermediate result being double""
#ifdef BUGGY_LL_MUL
DCell d = mmul(n1,n2);
#else
DCell d = (DCell)n1 * (DCell)n2;
#endif
#ifdef ASM_SM_SLASH_REM
Cell remainder;
SAVE_DIVISOR(n3);
ASM_SM_SLASH_REM(DLO(d), DHI(d), n3, remainder, n4);
#else
DCell r = smdiv(d,n3);
n4=DLO(r);
#endif
:
 */mods nip ;

2*	( n1 -- n2 )		core		two_star
""Shift left by 1; also works on unsigned numbers""
n2 = 2*n1;
:
 dup + ;

2/	( n1 -- n2 )		core		two_slash
""Arithmetic shift right by 1.  For signed numbers this is a floored
division by 2 (note that @code{/} is symmetric on some systems, but
@code{2/} always floors).""
n2 = n1>>1;
:
 dup MINI and IF 1 ELSE 0 THEN
 [ bits/char cell * 1- ] literal 
 0 DO 2* swap dup 2* >r MINI and 
     IF 1 ELSE 0 THEN or r> swap
 LOOP nip ;

fm/mod	( d1 n1 -- n2 n3 )		core		f_m_slash_mod
""Floored division: @i{d1} = @i{n3}*@i{n1}+@i{n2}, @i{n1}>@i{n2}>=0 or 0>=@i{n2}>@i{n1}.""
#ifdef ASM_SM_SLASH_REM
  SAVE_DIVISOR(n1);
  ASM_SM_SLASH_REM(DLO(d1), DHI(d1), n1, n2, n3);
  if ((DHI(d1)^n1)<0 && n2!=0) {
    if (CHECK_DIVISION && n3 == CELL_MIN)
      throw(BALL_RESULTRANGE);
    n3--;
    n2 += n1;
  }
#else /* !defined(ASM_SM_SLASH_REM) */
  DCell r = fmdiv(d1,n1);
  n2=DHI(r);
  n3=DLO(r);
#endif /* !defined(ASM_SM_SLASH_REM) */
:
 dup >r dup 0< IF  negate >r dnegate r>  THEN
 >r dup 0< r@ and + r> um/mod
 r> 0< IF  swap negate swap  THEN ;

sm/rem	( d1 n1 -- n2 n3 )		core		s_m_slash_rem
""Symmetric division: @i{d1} = @i{n3}*@i{n1}+@i{n2}, sign(@i{n2})=sign(@i{d1}) or 0.""
#ifdef ASM_SM_SLASH_REM
SAVE_DIVISOR(n1);
ASM_SM_SLASH_REM(DLO(d1), DHI(d1), n1, n2, n3);
#else /* !defined(ASM_SM_SLASH_REM) */
DCell r = smdiv(d1,n1);
n2=DHI(r);
n3=DLO(r);
#endif /* !defined(ASM_SM_SLASH_REM) */
:
 over >r dup >r abs -rot
 dabs rot um/mod
 r> r@ xor 0< IF       negate       THEN
 r>        0< IF  swap negate swap  THEN ;

m*	( n1 n2 -- d )		core	m_star
d = mmul(n1,n2);
:
 2dup      0< and >r
 2dup swap 0< and >r
 um* r> - r> - ;

um*	( u1 u2 -- ud )		core	u_m_star
/* use u* as alias */
ud = ummul(u1,u2);
:
   0 -rot dup [ 8 cells ] literal -
   DO
	dup 0< I' and d2*+ drop
   LOOP ;
: d2*+ ( ud u -- ud+u c )
   over MINI and >r
   >r 2dup d+ r> 0 d+ r> ;

um/mod	( ud u1 -- u2 u3 )		core	u_m_slash_mod
""ud=u3*u1+u2, 0<=u2<u1""
#ifdef ASM_UM_SLASH_MOD
SAVE_DIVISOR(u1);
ASM_UM_SLASH_MOD(DLO(ud), DHI(ud), u1, u2, u3);
#else /* !defined(ASM_UM_SLASH_MOD) */
UDCell r = umdiv(ud,u1);
u2=DHI(r);
u3=DLO(r);
#endif /* !defined(ASM_UM_SLASH_MOD) */
:
   0 swap [ 8 cells 1 + ] literal 0
   ?DO /modstep
   LOOP drop swap 1 rshift or swap ;
: /modstep ( ud c R: u -- ud-?u c R: u )
   >r over r@ u< 0= or IF r@ - 1 ELSE 0 THEN  d2*+ r> ;
: d2*+ ( ud u -- ud+u c )
   over MINI and >r 
   >r 2dup d+ r> 0 d+ r> ;

u/-stage2m	( u1 a_reci -- uquotient ) gforth u_slash_stage2m
""@i{Uquotient} is the result of dividing @i{u1} by the divisor represented
by @i{a-reci}, which was computed by @code{u/-stage1m}.""
stagediv_t *reci = (stagediv_t *)a_reci;
uquotient = uslashstage2(u1,reci);

umod-stage2m	( u1 a_reci -- umodulus ) gforth u_mod_stage2m
""@i{Umodulus} is the remainder of dividing @i{u1} by the divisor represented
by @i{a-reci}, which was computed by @code{u/-stage1m}.""
stagediv_t *reci = (stagediv_t *)a_reci;
UCell uquotient = uslashstage2(u1,reci);
umodulus = u1 - uquotient*reci->divisor;

u/mod-stage2m	( u1 a_reci -- umodulus uquotient ) gforth u_slash_mod_stage2m
""@i{Uquotient} is the quotient and @i{umodulus} is the remainder of
dividing @i{u1} by the divisor represented by @i{a-reci}, which was
computed by @code{u/-stage1m}.""
stagediv_t *reci = (stagediv_t *)a_reci;
uquotient = uslashstage2(u1,reci);
umodulus = u1 - uquotient*reci->divisor;

/f-stage2m	( n1 a_reci -- nquotient ) gforth slash_f_stage2m
""@i{Nquotient} is the result of dividing @i{n1} by the divisor represented
by @i{a-reci}, which was computed by @code{/f-stage1m}.""
nquotient = slashfstage2(n1,((stagediv_t *)a_reci));

modf-stage2m	( n1 a_reci -- umodulus ) gforth mod_f_stage2m
""@i{Umodulus} is the remainder of dividing @i{n1} by the divisor represented
by @i{a-reci}, which was computed by @code{/f-stage1m}.""
stagediv_t *reci = (stagediv_t *)a_reci;
Cell nquotient = slashfstage2(n1,reci);
umodulus = n1 - nquotient*reci->divisor;

/modf-stage2m	( n1 a_reci -- umodulus nquotient ) gforth slash_mod_f_stage2m
""@i{Nquotient} is the quotient and @i{umodulus} is the remainder of
dividing @i{n1} by the divisor represented by @i{a-reci}, which was
computed by @code{/f-stage1m}.""
stagediv_t *reci = (stagediv_t *)a_reci;
nquotient = slashfstage2(n1,reci);
umodulus = n1 - nquotient*reci->divisor;

m+	( d1 n -- d2 )		double		m_plus
#ifdef BUGGY_LL_ADD
DLO_IS(d2, DLO(d1)+n);
DHI_IS(d2, DHI(d1) - (n<0) + (DLO(d2)<DLO(d1)));
#else
d2 = d1+n;
#endif
:
 s>d d+ ;

d+	( ud1 ud2 -- ud )		double	d_plus
ud=dadd(ud1,ud2);
:
 rot + >r tuck + swap over u> r> swap - ;

d-	( d1 d2 -- d )		double		d_minus
#ifdef BUGGY_LL_ADD
DLO_IS(d, DLO(d1) - DLO(d2));
DHI_IS(d, DHI(d1)-DHI(d2)-(DLO(d1)<DLO(d2)));
#else
d = d1-d2;
#endif
:
 dnegate d+ ;

dnegate	( d1 -- d2 )		double	d_negate
/* use dminus as alias */
#ifdef BUGGY_LL_ADD
d2 = dnegate(d1);
#else
d2 = -d1;
#endif
:
 invert swap negate tuck 0= - ;

d2*	( d1 -- d2 )		double		d_two_star
""Shift double-cell left by 1; also works on unsigned numbers""
d2 = DLSHIFT(d1,1);
:
 2dup d+ ;

d2/	( d1 -- d2 )		double		d_two_slash
""Arithmetic shift right by 1.  For signed numbers this is a floored
division by 2.""
#ifdef BUGGY_LL_SHIFT
DHI_IS(d2, DHI(d1)>>1);
DLO_IS(d2, (DLO(d1)>>1) | (DHI(d1)<<(CELL_BITS-1)));
#else
d2 = d1>>1;
#endif
:
 dup 1 and >r 2/ swap 2/ [ 1 8 cells 1- lshift 1- ] Literal and
 r> IF  [ 1 8 cells 1- lshift ] Literal + THEN  swap ;

and	( w1 w2 -- w )		core
w = w1&w2;

or	( w1 w2 -- w )		core
w = w1|w2;
:
 invert swap invert and invert ;

xor	( w1 w2 -- w )		core	x_or
w = w1^w2;

invert	( w1 -- w2 )		core
w2 = ~w1;
:
 MAXU xor ;

rshift	( u1 u -- u2 )		core	r_shift
""Shift @i{u1} (cell) right by @i{u} bits,
filling the shifted-in bits with zero (logical/unsigned shift).""
#ifdef BROKEN_SHIFT
  u2 = rshift(u1, u);
#else
  u2 = u1 >> u;
#endif
:
    0 ?DO 2/ MAXI and LOOP ;

lshift	( u1 u -- u2 )		core	l_shift
""Shift @i{u1} left by @i{u} bits.""
#ifdef BROKEN_SHIFT
  u2 = lshift(u1, u);
#else
  u2 = u1 << u;
#endif
:
    0 ?DO 2* LOOP ;

umax	( u1 u2 -- u )	gforth
if (u1<u2)
  u = u2;
else
  u = u1;
:
 2dup u> select ;

umin	( u1 u2 -- u )	gforth
if (u1<u2)
  u = u1;
else
  u = u2;
:
 2dup u< select ;

mux   ( u1 u2 u3 -- u )	   gforth
""Multiplex: For every bit in @i{u3}: for a 1 bit, select the
corresponding bit from @i{u1}, otherwise the corresponding bit from @i{u2}.
E.g., @code{%0011 %1100 %1010 mux} gives @code{%0110}""
u = (u3 & u1) | (~u3 & u2);
:
 tuck invert and rot rot and or ;

select ( u1 u2 f -- u )	   gforth
""If @i{f} is false, @i{u} is @i{u2}, otherwise @i{u1}.""
u = f ? u1 : u2;
:
 IF swap THEN nip ;

dlshift	 ( ud1 u -- ud2 )	gforth dlshift
""Shift @i{ud1} (double-cell) left by @i{u} bits.""
#ifdef BUGGY_LL_SHIFT
if(u>=CELL_BITS) {
  u &= CELL_BITS-1;
  DHI_IS(ud2, (DLO(ud1) << u));
  DLO_IS(ud2, 0);
} else {
  DHI_IS(ud2, ((DHI(ud1) << u) | (DLO(ud1) >> (CELL_BITS-u))));
  DLO_IS(ud2, (DLO(ud1) << u));
}
#else
  ud2 = ud1 << u;
#endif

drshift	 ( ud1 u -- ud2 )	gforth drshift
""Shift @i{ud1} (double-cell) right by @i{u} bits,
filling the shifted-in bits with zero (logical/unsigned shift).""
#ifdef BUGGY_LL_SHIFT
if(u>=CELL_BITS) {
  u &= CELL_BITS-1;
  DHI_IS(ud2, 0);
  DLO_IS(ud2, (DHI(ud1) >> u));
} else {
  DHI_IS(ud2, (DHI(ud1) >> u));
  DLO_IS(ud2, ((DLO(ud1) >> u) | (DHI(ud1) << (CELL_BITS-u))));
}
#else
  ud2 = ud1 >> u;
#endif

rol	( u1 u -- u2 )		gforth rol
""Rotate all bits of @i{u1} left by @i{u} bits.""
u2 = (u1 << u) | (u1 >> (CELL_BITS-u));

ror	( u1 u -- u2 )		gforth ror
""Rotate all bits of @i{u1} right by @i{u} bits.""
u2 = (u1 >> u) | (u1 << (CELL_BITS-u));

wrol	( u1 u -- u2 )		gforth wrol
""Rotate the least significant 16 bits of @i{u1} left by @i{u} bits,
set the other bits to 0.""
u2 = (((uint16_t)u1 << u) | ((uint16_t)u1 >> (16-u))) & 0xFFFF;

wror	( u1 u -- u2 )		gforth wror
""Rotate the least significant 16 bits of @i{u1} right by @i{u} bits,
set the other bits to 0.""
u2 = (((uint16_t)u1 >> u) | ((uint16_t)u1 << (16-u))) & 0xFFFF;

lrol	( u1 u -- u2 )		gforth lrol
""Rotate the least significant 32 bits of @i{u1} left by @i{u} bits,
set the other bits to 0.""
u2 = (((uint32_t)u1 << u) | ((uint32_t)u1 >> (32-u))) & 0xFFFFFFFF;

lror	( u1 u -- u2 )		gforth lror
""Rotate the least significant 32 bits of @i{u1} right by @i{u} bits,
set the other bits to 0.""
u2 = (((uint32_t)u1 >> u) | ((uint32_t)u1 << (32-u))) & 0xFFFFFFFF;

drol	( ud1 u -- ud2 )	gforth drol
""Rotate all bits of @i{ud1} (double-cell) left by @i{u} bits.""
#ifdef BUGGY_LL_SHIFT
unsigned int u1 = u & (CELL_BITS-1);
UCell uh, ul;
uh=u1 ? ((DHI(ud1) << u1) | ((UCell)(DLO(ud1)) >> (CELL_BITS-u1))) : DHI(ud1);
ul=u1 ? ((DLO(ud1) << u1) | ((UCell)(DHI(ud1)) >> (CELL_BITS-u1))) : DLO(ud1);
if(u & CELL_BITS) {
  DHI_IS(ud2, ul);
  DLO_IS(ud2, uh);
} else {
  DHI_IS(ud2, uh);
  DLO_IS(ud2, ul);
}
#else
u &= 2*CELL_BITS-1;
ud2 = (ud1 << u) | (ud1 >> (2*CELL_BITS-u));
#endif

dror	( ud1 u -- ud2 )	gforth dror
""Rotate all bits of @i{ud1} (double-cell) right by @i{u} bits.""
#ifdef BUGGY_LL_SHIFT
unsigned int u1 = u & (CELL_BITS-1);
UCell uh, ul;
uh=u1 ? (((UCell)(DHI(ud1)) >> u1) | (DLO(ud1) << (CELL_BITS-u1))) : DHI(ud1);
ul=u1 ? (((UCell)(DLO(ud1)) >> u1) | (DHI(ud1) << (CELL_BITS-u1))) : DLO(ud1);
if(u & CELL_BITS) {
  DHI_IS(ud2, ul);
  DLO_IS(ud2, uh);
} else {
  DHI_IS(ud2, uh);
  DLO_IS(ud2, ul);
}
#else
u &= 2*CELL_BITS-1;
ud2 = (ud1 >> u) | (ud1 << (2*CELL_BITS-u));
#endif

du/mod	( d u -- n u1 )	gforth du_slash_mod
""d=n*u+u1, 0<=u1<u; PolyForth style mixed division""
Cell up = DHI(d);
Cell correct = -(up < 0);
up += correct & u;
DHI_IS(d, up);
#ifdef ASM_UM_SLASH_MOD
SAVE_DIVISOR(u);
ASM_UM_SLASH_MOD(DLO(d), DHI(d), u, n, u1);
#else /* !defined(ASM_UM_SLASH_MOD) */
{
UDCell r = umdiv(*(UDCell*)&d,u);
n=DHI(r);
u1=DLO(r);
}
#endif /* !defined(ASM_UM_SLASH_MOD) */
:
 >r dup 0< r@ and + r> um/mod ;

u/	( u1 u2 -- u )		gforth	u_slash
if (CHECK_DIVISION_SW && u2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(u2);
u = u1/u2;
:
 u/mod nip ;

umod	( u1 u2 -- u )		gforth
if (CHECK_DIVISION_SW && u2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(u2);
u = u1%u2;
:
 u/mod drop ;

u/mod	( u1 u2 -- u3 u4 )		gforth		u_slash_mod
""u1=u2*u4+u3; u3 is the modulus, u4 the quotient""
if (CHECK_DIVISION_SW && u2 == 0)
  throw(BALL_DIVZERO);
SAVE_DIVISOR(u2);
u4 = u1/u2;
u3 = u1%u2;
:
 0 swap um/mod ;

u*/mod	( u1 u2 u3 -- u4 u5 )	gforth	u_star_slash_mod
""u1*u2=u3*u5+u4, with the intermediate result (u1*u2) being double.""
#ifdef BUGGY_LL_MUL
UDCell ud = ummul(u1,u2);
#else
UDCell ud = (UDCell)u1 * (UDCell)u2;
#endif
#ifdef ASM_UM_SLASH_MOD
SAVE_DIVISOR(u3);
ASM_UM_SLASH_MOD(DLO(ud), DHI(ud), u3, u4, u5);
#else
UDCell r = umdiv(ud,u3);
u4=DHI(r);
u5=DLO(r);
#endif
:
 >r um* r> um/mod ;

u*/	( u1 u2 u3 -- u4 )	gforth	u_star_slash
""u4=(u1*u2)/u3, with the intermediate result being double.""
#ifdef BUGGY_LL_MUL
UDCell ud = ummul(u1,u2);
#else
UDCell ud = (UDCell)u1 * (UDCell)u2;
#endif
#ifdef ASM_SM_SLASH_REM
UCell remainder;
SAVE_DIVISOR(u3);
ASM_UM_SLASH_MOD(DLO(ud), DHI(ud), u3, remainder, u4);
#else
UDCell r = umdiv(ud,u3);
u4=DLO(r);
#endif
:
 */mods nip ;

arshift	( n1 u -- n2 )		gforth	ar_shift
""Shift @i{n1} (cell) right by @i{u} bits, filling the shifted-in bits
from the sign bit of @i{n1} (arithmetic shift).""
n2 = n1 >> u;
:
 0 ?DO 2/ LOOP ;

darshift ( d1 u -- d2 )	gforth darshift
""Shift @i{d1} (double-cell) right by @i{u} bits, filling the shifted-in bits
from the sign bit of @i{d1} (arithmetic shift).""
#ifdef BUGGY_LL_SHIFT
if(u>=CELL_BITS) {
  u &= CELL_BITS-1;
  DHI_IS(d2, 0);
  DLO_IS(d2, (DHI(d1) >> u));
} else {
  DHI_IS(d2, (DHI(d1) >> u));
  DLO_IS(d2, ((DLO(d1) >> u) | (DHI(d1) << (CELL_BITS-u))));
}
#else
  d2 = d1 >> u;
#endif

\g compare

\ comparisons(prefix, args, prefix, arg1, arg2, wordsets...)
#line 1488


0=	( n -- f )		core	zero_equals
#line 1490
f = FLAG(n==0);
#line 1490
:
#line 1490
    [ char 0x char 0 = [IF]
#line 1490
	] IF false ELSE true THEN [
#line 1490
    [ELSE]
#line 1490
	] xor 0= [
#line 1490
    [THEN] ] ;
#line 1490

#line 1490
0<>	( n -- f )		core-ext	zero_not_equals
#line 1490
f = FLAG(n!=0);
#line 1490
:
#line 1490
    [ char 0x char 0 = [IF]
#line 1490
	] IF true ELSE false THEN [
#line 1490
    [ELSE]
#line 1490
	] xor 0<> [
#line 1490
    [THEN] ] ;
#line 1490

#line 1490
0<	( n -- f )		core	zero_less_than
#line 1490
f = FLAG(n<0);
#line 1490
:
#line 1490
    [ char 0x char 0 = [IF]
#line 1490
	] MINI and 0<> [
#line 1490
    [ELSE] char 0x char u = [IF]
#line 1490
	]   2dup xor 0<  IF nip ELSE - THEN 0<  [
#line 1490
	[ELSE]
#line 1490
	    ] MINI xor >r MINI xor r> u< [
#line 1490
	[THEN]
#line 1490
    [THEN] ] ;
#line 1490

#line 1490
0>	( n -- f )		core-ext	zero_greater_than
#line 1490
f = FLAG(n>0);
#line 1490
:
#line 1490
    [ char 0x char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 1490
    0< ;
#line 1490

#line 1490
0<=	( n -- f )		gforth	zero_less_or_equal
#line 1490
f = FLAG(n<=0);
#line 1490
:
#line 1490
    0> 0= ;
#line 1490

#line 1490
0>=	( n -- f )		gforth	zero_greater_or_equal
#line 1490
f = FLAG(n>=0);
#line 1490
:
#line 1490
    [ char 0x char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 1490
    0<= ;
#line 1490

#line 1490

=	( n1 n2 -- f )		core	equals
#line 1491
f = FLAG(n1==n2);
#line 1491
:
#line 1491
    [ char x char 0 = [IF]
#line 1491
	] IF false ELSE true THEN [
#line 1491
    [ELSE]
#line 1491
	] xor 0= [
#line 1491
    [THEN] ] ;
#line 1491

#line 1491
<>	( n1 n2 -- f )		core-ext	not_equals
#line 1491
f = FLAG(n1!=n2);
#line 1491
:
#line 1491
    [ char x char 0 = [IF]
#line 1491
	] IF true ELSE false THEN [
#line 1491
    [ELSE]
#line 1491
	] xor 0<> [
#line 1491
    [THEN] ] ;
#line 1491

#line 1491
<	( n1 n2 -- f )		core	less_than
#line 1491
f = FLAG(n1<n2);
#line 1491
:
#line 1491
    [ char x char 0 = [IF]
#line 1491
	] MINI and 0<> [
#line 1491
    [ELSE] char x char u = [IF]
#line 1491
	]   2dup xor 0<  IF nip ELSE - THEN 0<  [
#line 1491
	[ELSE]
#line 1491
	    ] MINI xor >r MINI xor r> u< [
#line 1491
	[THEN]
#line 1491
    [THEN] ] ;
#line 1491

#line 1491
>	( n1 n2 -- f )		core	greater_than
#line 1491
f = FLAG(n1>n2);
#line 1491
:
#line 1491
    [ char x char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 1491
    < ;
#line 1491

#line 1491
<=	( n1 n2 -- f )		gforth	less_or_equal
#line 1491
f = FLAG(n1<=n2);
#line 1491
:
#line 1491
    > 0= ;
#line 1491

#line 1491
>=	( n1 n2 -- f )		gforth	greater_or_equal
#line 1491
f = FLAG(n1>=n2);
#line 1491
:
#line 1491
    [ char x char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 1491
    <= ;
#line 1491

#line 1491

u=	( u1 u2 -- f )		gforth-internal	u_equals
#line 1492
f = FLAG(u1==u2);
#line 1492
:
#line 1492
    [ char ux char 0 = [IF]
#line 1492
	] IF false ELSE true THEN [
#line 1492
    [ELSE]
#line 1492
	] xor 0= [
#line 1492
    [THEN] ] ;
#line 1492

#line 1492
u<>	( u1 u2 -- f )		gforth-internal	u_not_equals
#line 1492
f = FLAG(u1!=u2);
#line 1492
:
#line 1492
    [ char ux char 0 = [IF]
#line 1492
	] IF true ELSE false THEN [
#line 1492
    [ELSE]
#line 1492
	] xor 0<> [
#line 1492
    [THEN] ] ;
#line 1492

#line 1492
u<	( u1 u2 -- f )		core	u_less_than
#line 1492
f = FLAG(u1<u2);
#line 1492
:
#line 1492
    [ char ux char 0 = [IF]
#line 1492
	] MINI and 0<> [
#line 1492
    [ELSE] char ux char u = [IF]
#line 1492
	]   2dup xor 0<  IF nip ELSE - THEN 0<  [
#line 1492
	[ELSE]
#line 1492
	    ] MINI xor >r MINI xor r> u< [
#line 1492
	[THEN]
#line 1492
    [THEN] ] ;
#line 1492

#line 1492
u>	( u1 u2 -- f )		core-ext	u_greater_than
#line 1492
f = FLAG(u1>u2);
#line 1492
:
#line 1492
    [ char ux char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 1492
    u< ;
#line 1492

#line 1492
u<=	( u1 u2 -- f )		gforth	u_less_or_equal
#line 1492
f = FLAG(u1<=u2);
#line 1492
:
#line 1492
    u> 0= ;
#line 1492

#line 1492
u>=	( u1 u2 -- f )		gforth	u_greater_or_equal
#line 1492
f = FLAG(u1>=u2);
#line 1492
:
#line 1492
    [ char ux char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 1492
    u<= ;
#line 1492

#line 1492


\ dcomparisons(prefix, args, prefix, arg1, arg2, wordsets...)
#line 1538


\+dcomps

d=	( d1 d2 -- f )		double	d_equals
#line 1542
#ifdef BUGGY_LL_CMP
#line 1542
f = FLAG(d1.lo==d2.lo && d1.hi==d2.hi);
#line 1542
#else
#line 1542
f = FLAG(d1==d2);
#line 1542
#endif
#line 1542

#line 1542
d<>	( d1 d2 -- f )		gforth	d_not_equals
#line 1542
#ifdef BUGGY_LL_CMP
#line 1542
f = FLAG(d1.lo!=d2.lo || d1.hi!=d2.hi);
#line 1542
#else
#line 1542
f = FLAG(d1!=d2);
#line 1542
#endif
#line 1542

#line 1542
d<	( d1 d2 -- f )		double	d_less_than
#line 1542
#ifdef BUGGY_LL_CMP
#line 1542
f = FLAG(d1.hi==d2.hi ? d1.lo<d2.lo : d1.hi<d2.hi);
#line 1542
#else
#line 1542
f = FLAG(d1<d2);
#line 1542
#endif
#line 1542

#line 1542
d>	( d1 d2 -- f )		gforth	d_greater_than
#line 1542
#ifdef BUGGY_LL_CMP
#line 1542
f = FLAG(d1.hi==d2.hi ? d1.lo>d2.lo : d1.hi>d2.hi);
#line 1542
#else
#line 1542
f = FLAG(d1>d2);
#line 1542
#endif
#line 1542

#line 1542
d<=	( d1 d2 -- f )		gforth	d_less_or_equal
#line 1542
#ifdef BUGGY_LL_CMP
#line 1542
f = FLAG(d1.hi==d2.hi ? d1.lo<=d2.lo : d1.hi<=d2.hi);
#line 1542
#else
#line 1542
f = FLAG(d1<=d2);
#line 1542
#endif
#line 1542

#line 1542
d>=	( d1 d2 -- f )		gforth	d_greater_or_equal
#line 1542
#ifdef BUGGY_LL_CMP
#line 1542
f = FLAG(d1.hi==d2.hi ? d1.lo>=d2.lo : d1.hi>=d2.hi);
#line 1542
#else
#line 1542
f = FLAG(d1>=d2);
#line 1542
#endif
#line 1542

#line 1542

d0=	( d -- f )		double	d_zero_equals
#line 1543
#ifdef BUGGY_LL_CMP
#line 1543
f = FLAG(d.lo==DZERO.lo && d.hi==DZERO.hi);
#line 1543
#else
#line 1543
f = FLAG(d==DZERO);
#line 1543
#endif
#line 1543

#line 1543
d0<>	( d -- f )		gforth	d_zero_not_equals
#line 1543
#ifdef BUGGY_LL_CMP
#line 1543
f = FLAG(d.lo!=DZERO.lo || d.hi!=DZERO.hi);
#line 1543
#else
#line 1543
f = FLAG(d!=DZERO);
#line 1543
#endif
#line 1543

#line 1543
d0<	( d -- f )		double	d_zero_less_than
#line 1543
#ifdef BUGGY_LL_CMP
#line 1543
f = FLAG(d.hi==DZERO.hi ? d.lo<DZERO.lo : d.hi<DZERO.hi);
#line 1543
#else
#line 1543
f = FLAG(d<DZERO);
#line 1543
#endif
#line 1543

#line 1543
d0>	( d -- f )		gforth	d_zero_greater_than
#line 1543
#ifdef BUGGY_LL_CMP
#line 1543
f = FLAG(d.hi==DZERO.hi ? d.lo>DZERO.lo : d.hi>DZERO.hi);
#line 1543
#else
#line 1543
f = FLAG(d>DZERO);
#line 1543
#endif
#line 1543

#line 1543
d0<=	( d -- f )		gforth	d_zero_less_or_equal
#line 1543
#ifdef BUGGY_LL_CMP
#line 1543
f = FLAG(d.hi==DZERO.hi ? d.lo<=DZERO.lo : d.hi<=DZERO.hi);
#line 1543
#else
#line 1543
f = FLAG(d<=DZERO);
#line 1543
#endif
#line 1543

#line 1543
d0>=	( d -- f )		gforth	d_zero_greater_or_equal
#line 1543
#ifdef BUGGY_LL_CMP
#line 1543
f = FLAG(d.hi==DZERO.hi ? d.lo>=DZERO.lo : d.hi>=DZERO.hi);
#line 1543
#else
#line 1543
f = FLAG(d>=DZERO);
#line 1543
#endif
#line 1543

#line 1543

du=	( ud1 ud2 -- f )		gforth-internal	d_u_equals
#line 1544
#ifdef BUGGY_LL_CMP
#line 1544
f = FLAG(ud1.lo==ud2.lo && ud1.hi==ud2.hi);
#line 1544
#else
#line 1544
f = FLAG(ud1==ud2);
#line 1544
#endif
#line 1544

#line 1544
du<>	( ud1 ud2 -- f )		gforth-internal	d_u_not_equals
#line 1544
#ifdef BUGGY_LL_CMP
#line 1544
f = FLAG(ud1.lo!=ud2.lo || ud1.hi!=ud2.hi);
#line 1544
#else
#line 1544
f = FLAG(ud1!=ud2);
#line 1544
#endif
#line 1544

#line 1544
du<	( ud1 ud2 -- f )		double-ext	d_u_less_than
#line 1544
#ifdef BUGGY_LL_CMP
#line 1544
f = FLAG(ud1.hi==ud2.hi ? ud1.lo<ud2.lo : ud1.hi<ud2.hi);
#line 1544
#else
#line 1544
f = FLAG(ud1<ud2);
#line 1544
#endif
#line 1544

#line 1544
du>	( ud1 ud2 -- f )		gforth	d_u_greater_than
#line 1544
#ifdef BUGGY_LL_CMP
#line 1544
f = FLAG(ud1.hi==ud2.hi ? ud1.lo>ud2.lo : ud1.hi>ud2.hi);
#line 1544
#else
#line 1544
f = FLAG(ud1>ud2);
#line 1544
#endif
#line 1544

#line 1544
du<=	( ud1 ud2 -- f )		gforth	d_u_less_or_equal
#line 1544
#ifdef BUGGY_LL_CMP
#line 1544
f = FLAG(ud1.hi==ud2.hi ? ud1.lo<=ud2.lo : ud1.hi<=ud2.hi);
#line 1544
#else
#line 1544
f = FLAG(ud1<=ud2);
#line 1544
#endif
#line 1544

#line 1544
du>=	( ud1 ud2 -- f )		gforth	d_u_greater_or_equal
#line 1544
#ifdef BUGGY_LL_CMP
#line 1544
f = FLAG(ud1.hi==ud2.hi ? ud1.lo>=ud2.lo : ud1.hi>=ud2.hi);
#line 1544
#else
#line 1544
f = FLAG(ud1>=ud2);
#line 1544
#endif
#line 1544

#line 1544


\+

within	( u1 u2 u3 -- f )		core-ext
""u2<u3 and u1 in [u2,u3) or: u2>=u3 and u1 not in [u3,u2).  This works for
unsigned and signed numbers (but not a mixture).  Another way to think
about this word is to consider the numbers as a circle (wrapping
around from @code{max-u} to 0 for unsigned, and from @code{max-n} to
min-n for signed numbers); now consider the range from u2 towards
increasing numbers up to and excluding u3 (giving an empty range if
u2=u3); if u1 is in this range, @code{within} returns true.""
f = FLAG(u1-u2 < u3-u2);
:
 over - >r - r> u< ;

\g stack

up!	( a_addr -- )	gforth-internal	up_store
gforth_UP=up=(user_area*)a_addr;
:
 up ! ;
Variable UP

sp@	( S:... -- a_addr )		gforth		sp_fetch
a_addr = sp;

sp!	( a_addr -- S:... )		gforth		sp_store
sp = a_addr;

rp@	( -- a_addr )		gforth		rp_fetch
a_addr = rp;

rp!	( a_addr -- )		gforth		rp_store
rp = a_addr;

\+floating

fp@	( f:... -- f_addr )	gforth	fp_fetch
f_addr = fp;

fp!	( f_addr -- f:... )	gforth	fp_store
fp = f_addr;

\+

>r	( w -- R:w )		core	to_r
:
 (>r) ;
: (>r)  rp@ cell+ @ rp@ ! rp@ cell+ ! ;

r>	( R:w -- w )		core	r_from
:
 rp@ cell+ @ rp@ @ rp@ cell+ ! (rdrop) rp@ ! ;
Create (rdrop) ' ;s A,

rdrop	( R:w -- )		gforth
ALIVE_DEBUGGING(w);
:
 r> r> drop >r ;

2>r	( w1 w2 -- R:w1 R:w2 )	core-ext	two_to_r
:
 swap r> swap >r swap >r >r ;

2r>	( R:w1 R:w2 -- w1 w2 )	core-ext	two_r_from
:
 r> r> swap r> swap >r swap ;

2r@	( R:w1 R:w2 -- R:w1 R:w2 w1 w2 )	core-ext	two_r_fetch
:
 i' j ;

2rdrop	( R:w1 R:w2 -- )		gforth	two_r_drop
ALIVE_DEBUGGING(w1);
:
 r> r> drop r> drop >r ;

f>r	( r -- )    gforth-experimental	f_to_r
Float rval[1] = { r };
rp -= sizeof(Float)/sizeof(Cell);
memcpy(rp, rval, sizeof(Float));

fr>	( -- r )    gforth-experimental	f_r_from
Float rval[1];
memcpy(rval, rp, sizeof(Float));
rp += sizeof(Float)/sizeof(Cell);
r = rval[0];

fr@	( -- r )    gforth-experimental	f_r_fetch
Float rval[1];
memcpy(rval, rp, sizeof(Float));
r = rval[0];

over	( w1 w2 -- w1 w2 w1 )		core
:
 sp@ cell+ @ ;

drop	( w -- )		core
ALIVE_DEBUGGING(w);
:
 IF THEN ;

swap	( w1 w2 -- w2 w1 )		core
:
 >r (swap) ! r> (swap) @ ;
Variable (swap)

dup	( w -- w w )		core	dupe
:
 sp@ @ ;

rot	( w1 w2 w3 -- w2 w3 w1 )	core	rote
:
[ defined? (swap) [IF] ]
    (swap) ! (rot) ! >r (rot) @ (swap) @ r> ;
Variable (rot)
[ELSE] ]
    >r swap r> swap ;
[THEN]

-rot	( w1 w2 w3 -- w3 w1 w2 )	gforth	not_rote
:
 rot rot ;

nip	( w1 w2 -- w2 )		core-ext
:
 swap drop ;

tuck	( w1 w2 -- w2 w1 w2 )	core-ext
:
 swap over ;

?dup	( w -- S:... w )	core	question_dupe
""Actually the stack effect is: @code{( 0 -- 0  |  x\0 -- x x )}.  It performs a
@code{dup} if x is nonzero.""
if (w!=0) {
  *--sp = w;
}
:
 dup IF dup THEN ;

pick	( S:... u -- S:... w )		core-ext
""Actually the stack effect is @code{ x0 ... xu u -- x0 ... xu x0 }.""
w = sp[u];
:
 1+ cells sp@ + @ ;

third	  ( w1 w2 w3 -- w1 w2 w3 w1 )	gforth

fourth	  ( w1 w2 w3 w4 -- w1 w2 w3 w4 w1 )	gforth

2drop	( w1 w2 -- )		core	two_drop
ALIVE_DEBUGGING(w1);
:
 drop drop ;

2dup	( w1 w2 -- w1 w2 w1 w2 )	core	two_dupe
:
 over over ;

2over	( w1 w2 w3 w4 -- w1 w2 w3 w4 w1 w2 )	core	two_over
:
 3 pick 3 pick ;

2swap	( w1 w2 w3 w4 -- w3 w4 w1 w2 )	core	two_swap
:
 rot >r rot r> ;

2rot	( w1 w2 w3 w4 w5 w6 -- w3 w4 w5 w6 w1 w2 )	double-ext	two_rote
:
 >r >r 2swap r> r> 2swap ;

2nip	( w1 w2 w3 w4 -- w3 w4 )	gforth	two_nip
:
 2swap 2drop ;

2tuck	( w1 w2 w3 w4 -- w3 w4 w1 w2 w3 w4 )	gforth	two_tuck
:
 2swap 2over ;

sps@	( -- w )   gforth-internal sps_fetch
w = (Cell)SPs;

\ toggle is high-level: 0.11/0.42%

\g memory

@	( a_addr -- w )		core	fetch
""@i{w} is the cell stored at @i{a_addr}.""
w = *a_addr;

\ lit@ / lit_fetch = lit @

lit@		( #a_addr -- w ) new	lit_fetch
w = *a_addr;

!	( w a_addr -- )		core	store
""Store @i{w} into the cell at @i{a-addr}.""
*a_addr = w;

+!	( n a_addr -- )		core	plus_store
""Add @i{n} to the cell at @i{a-addr}.""
*a_addr += n;
:
 tuck @ + swap ! ;

c@	( c_addr -- c )		core	c_fetch
""@i{c} is the char stored at @i{c_addr}.""
c = *c_addr;
:
[ bigendian [IF] ]
    [ cell>bit 4 = [IF] ]
	dup [ 0 cell - ] Literal and @ swap 1 and
	IF  $FF and  ELSE  8>>  THEN  ;
    [ [ELSE] ]
	dup [ cell 1- ] literal and
	tuck - @ swap [ cell 1- ] literal xor
 	0 ?DO 8>> LOOP $FF and
    [ [THEN] ]
[ [ELSE] ]
    [ cell>bit 4 = [IF] ]
	dup [ 0 cell - ] Literal and @ swap 1 and
	IF  8>>  ELSE  $FF and  THEN
    [ [ELSE] ]
	dup [ cell  1- ] literal and 
	tuck - @ swap
	0 ?DO 8>> LOOP 255 and
    [ [THEN] ]
[ [THEN] ]
;
: 8>> 2/ 2/ 2/ 2/  2/ 2/ 2/ 2/ ;

c!	( c c_addr -- )		core	c_store
""Store @i{c} into the char at @i{c-addr}.""
*c_addr = c;
:
[ bigendian [IF] ]
    [ cell>bit 4 = [IF] ]
	tuck 1 and IF  $FF and  ELSE  8<<  THEN >r
	dup -2 and @ over 1 and cells masks + @ and
	r> or swap -2 and ! ;
	Create masks $00FF , $FF00 ,
    [ELSE] ]
	dup [ cell 1- ] literal and dup 
	[ cell 1- ] literal xor >r
	- dup @ $FF r@ 0 ?DO 8<< LOOP invert and
	rot $FF and r> 0 ?DO 8<< LOOP or swap ! ;
    [THEN]
[ELSE] ]
    [ cell>bit 4 = [IF] ]
	tuck 1 and IF  8<<  ELSE  $FF and  THEN >r
	dup -2 and @ over 1 and cells masks + @ and
	r> or swap -2 and ! ;
	Create masks $FF00 , $00FF ,
    [ELSE] ]
	dup [ cell 1- ] literal and dup >r
	- dup @ $FF r@ 0 ?DO 8<< LOOP invert and
	rot $FF and r> 0 ?DO 8<< LOOP or swap ! ;
    [THEN]
[THEN]
: 8<< 2* 2* 2* 2*  2* 2* 2* 2* ;

2!	( w1 w2 a_addr -- )		core	two_store
""Store @i{w2} into the cell at @i{c-addr} and @i{w1} into the next cell.""
a_addr[0] = w2;
a_addr[1] = w1;
:
 tuck ! cell+ ! ;

2@	( a_addr -- w1 w2 )		core	two_fetch
""@i{w2} is the content of the cell stored at @i{a-addr}, @i{w1} is
the content of the next cell.""
w2 = a_addr[0];
w1 = a_addr[1];
:
 dup cell+ @ swap @ ;

cell+	( a_addr1 -- a_addr2 )	core	cell_plus
""@code{1 cells +}""
a_addr2 = a_addr1+1;
:
 cell + ;

cells	( n1 -- n2 )		core
"" @i{n2} is the number of address units of @i{n1} cells.""
n2 = n1 * sizeof(Cell);
:
 [ cell
 2/ dup [IF] ] 2* [ [THEN]
 2/ dup [IF] ] 2* [ [THEN]
 2/ dup [IF] ] 2* [ [THEN]
 2/ dup [IF] ] 2* [ [THEN]
 drop ] ;

char+	( c_addr1 -- c_addr2 )	core	char_plus
""@code{1 chars +}.""
c_addr2 = c_addr1 + 1;
:
 1+ ;

count	( c_addr1 -- c_addr2 u )	core
""@i{c-addr2} is the first character and @i{u} the length of the
counted string at @i{c-addr1}.""
u = *c_addr1;
c_addr2 = c_addr1+1;
:
 dup 1+ swap c@ ;

cell/ ( n1 -- n2 )	gforth cell_divide
""@i{N2} is the number of cells that fit into @i{n1} aus, rounded
towards negative infinity.""
n2 = n1 >> (sizeof(Cell) == 8 ? 3 : 2);
:
 [ cell
 2/ dup [IF] ] 2/ [ [THEN]
 2/ dup [IF] ] 2/ [ [THEN]
 2/ dup [IF] ] 2/ [ [THEN]
 2/ dup [IF] ] 2/ [ [THEN]
 drop ] ;

cell-	( a_addr1 -- a_addr2 )	core	cell_minus
""@code{1 cells -}""
a_addr2 = a_addr1-1;
:
 cell - ;

inc#   ( #a_addr -- )	gforth-internal	one_plus_store
*a_addr += 1;
:
 1 r> dup cell+ >r @ +! ;

\g compiler

\+f83headerstring

(f83find)	( c_addr u f83name1 -- f83name2 )	new	paren_f83find
for (; f83name1 != NULL; f83name1 = (struct F83Name *)(f83name1->next))
  if ((UCell)F83NAME_COUNT(f83name1)==u &&
      memcasecmp(c_addr, f83name1->name, u)== 0 /* or inline? */)
    break;
f83name2=f83name1;
#ifdef DEBUG
fprintf(stderr, "F83find ");
fwrite(c_addr, u, 1, stderr);
fprintf(stderr, " found %08x\n", f83name2); 
#endif
:
    BEGIN  dup WHILE  (find-samelen)  dup  WHILE
	>r 2dup r@ cell+ char+ capscomp  0=
	IF  2drop r>  EXIT  THEN
	r> @
    REPEAT  THEN  nip nip ;
: (find-samelen) ( u f83name1 -- u f83name2/0 )
    BEGIN  2dup cell+ c@ $1F and <> WHILE  @  dup 0= UNTIL  THEN ;
: capscomp ( c_addr1 u c_addr2 -- n )
 swap bounds
 ?DO  dup c@ I c@ <>
     IF  dup c@ toupper I c@ toupper =
     ELSE  true  THEN  WHILE  1+  LOOP  drop 0
 ELSE  c@ toupper I c@ toupper - unloop  THEN  sgn ;
: sgn ( n -- -1/0/1 )
 dup 0= IF EXIT THEN  0< 2* 1+ ;

\-

(listlfind)	( c_addr u longname1 -- longname2 )	new	paren_listlfind
longname2=listlfind(c_addr, u, longname1);
:
    BEGIN  dup WHILE  (findl-samelen)  dup  WHILE
	>r 2dup r@ cell+ cell+ capscomp  0=
	IF  2drop r>  EXIT  THEN
	r> @
    REPEAT  THEN  nip nip ;
: (findl-samelen) ( u longname1 -- u longname2/0 )
    BEGIN  2dup cell+ @ lcount-mask and <> WHILE  @  dup 0= UNTIL  THEN ;
: capscomp ( c_addr1 u c_addr2 -- n )
 swap bounds
 ?DO  dup c@ I c@ <>
     IF  dup c@ toupper I c@ toupper =
     ELSE  true  THEN  WHILE  1+  LOOP  drop 0
 ELSE  c@ toupper I c@ toupper - unloop  THEN  sgn ;
: sgn ( n -- -1/0/1 )
 dup 0= IF EXIT THEN  0< 2* 1+ ;

\+hash

(hashlfind)	( c_addr u a_addr -- longname2 )	new	paren_hashlfind
longname2 = hashlfind(c_addr, u, a_addr);
:
 BEGIN  dup  WHILE
        2@ >r >r dup r@ cell+ @ lcount-mask and =
        IF  2dup r@ cell+ cell+ capscomp 0=
	    IF  2drop r> rdrop  EXIT  THEN  THEN
	rdrop r>
 REPEAT nip nip ;

(tablelfind)	( c_addr u a_addr -- longname2 )	new	paren_tablelfind
""A case-sensitive variant of @code{(hashfind)}""
longname2 = tablelfind(c_addr, u, a_addr);
:
 BEGIN  dup  WHILE
        2@ >r >r dup r@ cell+ @ lcount-mask and =
        IF  2dup r@ cell+ cell+ -text 0=
	    IF  2drop r> rdrop  EXIT  THEN  THEN
	rdrop r>
 REPEAT nip nip ;
: -text ( c_addr1 u c_addr2 -- n )
 swap bounds
 ?DO  dup c@ I c@ = WHILE  1+  LOOP  drop 0
 ELSE  c@ I c@ - unloop  THEN  sgn ;
: sgn ( n -- -1/0/1 )
 dup 0= IF EXIT THEN  0< 2* 1+ ;

(hashkey1)	( c_addr u ubits -- ukey )	gforth-internal	paren_hashkey1
""ukey is the hash key for the string c_addr u fitting in ubits bits""
ukey = hashkey1(c_addr, u, ubits);
:
 dup rot-values + c@ over 1 swap lshift 1- >r
 tuck - 2swap r> 0 2swap bounds
 ?DO  dup 4 pick lshift swap 3 pick rshift or
      I c@ toupper xor
      over and  LOOP
 nip nip nip ;
Create rot-values
  5 c, 0 c, 1 c, 2 c, 3 c,  4 c, 5 c, 5 c, 5 c, 5 c,
  3 c, 5 c, 5 c, 5 c, 5 c,  7 c, 5 c, 5 c, 5 c, 5 c,
  7 c, 5 c, 5 c, 5 c, 5 c,  6 c, 5 c, 5 c, 5 c, 5 c,
  7 c, 5 c, 5 c,

(hashkey2) ( c_addr u ubits -- ukey )	gforth-internal	paren_hashkey2
""A faster replacement for @code{(hashkey1)}""
ukey = hashkey2a(c_addr,u) >> (8*sizeof(UCell) - ubits);

hashkey2  ( c_addr u f a_addr -- )	gforth-internal	hashkey2
""Compute a 128 bit hash key of the string c_addr u, starting with the
key in a_addr.  If f is true, compute case insensitive.""
hashkey2(c_addr, u, f ? 0x2020202020202020LL : 0LL, (hash128*)a_addr);

\+

\+

(parse-white)	( c_addr1 u1 -- c_addr2 u2 )	gforth-internal	paren_parse_white
struct Cellpair r=parse_white(c_addr1, u1);
c_addr2 = (Char *)(r.n1);
u2 = r.n2;
:
 BEGIN  dup  WHILE  over c@ bl <=  WHILE  1 /string
 REPEAT  THEN  2dup
 BEGIN  dup  WHILE  over c@ bl >   WHILE  1 /string
 REPEAT  THEN  nip - ;

scan	 ( c_addr1 u1 c -- c_addr2 u2 )	gforth
""Skip all characters not equal to c.  The result starts with c or is
empty.  @code{Scan} is limited to single-byte (ASCII) characters.  Use
@code{search} to search for multi-byte characters.""
for (c_addr2=c_addr1; c_addr2!=c_addr1+u1 && *c_addr2 != c; c_addr2++)
  ;
u2 = (c_addr1+u1)-c_addr2;
#if 0
Char *c_addr3=memchr(c_addr1, c, u1);
if (u2!=0 && c_addr3!=c_addr2)
  fprintf(stderr,"\nscan: %p %ld %d -- %p %ld (memchr -> %p)",c_addr1,u1,c,c_addr2,u2,c_addr3);
#endif
:
    >r
    BEGIN
        dup
    WHILE
        over c@ r@ <>
    WHILE
        1 /string
    REPEAT  THEN
    rdrop ;

skip	( c_addr1 u1 c -- c_addr2 u2 )	gforth
""Skip all characters equal to c.  The result starts with the first
non-c character, or it is empty.  @code{Scan} is limited to
single-byte (ASCII) characters.""
for (c_addr2=c_addr1; c_addr2!=c_addr1+u1 && *c_addr2 == c; c_addr2++)
  ;
u2 = (c_addr1+u1)-c_addr2;
:
    >r
    BEGIN
        dup
    WHILE
        over c@ r@  =
    WHILE
        1 /string
    REPEAT  THEN
    rdrop ;

aligned	( c_addr -- a_addr )	core
"" @i{a-addr} is the smallest aligned address greater than or equal to @i{c-addr}.""
a_addr = (Cell *)((((Cell)c_addr)+(sizeof(Cell)-1))&(-sizeof(Cell)));
:
 [ cell 1- ] Literal + [ -1 cells ] Literal and ;

faligned	( c_addr -- f_addr )	floating	f_aligned
"" @i{f-addr} is the first float-aligned address greater than or equal to @i{c-addr}.""
f_addr = (Float *)((((Cell)c_addr)+(sizeof(Float)-1))&(-sizeof(Float)));
:
 [ 1 floats 1- ] Literal + [ -1 floats ] Literal and ;

\ threading stuff is currently only interesting if we have a compiler
\fhas? standardthreading has? compiler and [IF]
threading-method	( -- n )	gforth	threading_method
""0 if the engine is direct threaded. Note that this may change during
the lifetime of an image.""
#if defined(DOUBLY_INDIRECT)
n=2;
#else
# if defined(DIRECT_THREADED)
n=0;
# else
n=1;
# endif
#endif
:
 1 ;

debugging-method	( -- n )	gforth-internal	debugging_method
""true if the engine supports debugging""
#if defined(GFORTH_DEBUGGING)
n=-1;
#else
n=0;
#endif
:
 0 ;

die-on-signal	( -- a_addr )	gforth-internal die_on_signal
a_addr = &die_on_signal;

\f[THEN]

\g hostos

(key-file)	( wfileid -- n )	gforth-internal	paren_key_file
""Read one character @i{n} from @i{wfileid}.  This word disables
buffering for @i{wfileid}.  If you want to read characters from a
terminal in non-canonical (raw) mode, you have to put the terminal in
non-canonical mode yourself (using the C interface); the exception is
@code{stdin}: Gforth automatically puts it into non-canonical mode.  If
an error occurred, a negative ior is returned instead of a positive byte.""
#ifdef HAS_FILE
fflush(stdout);
n = key((FILE*)wfileid);
#else
n = key(stdin);
#endif

key?-file	( wfileid -- f )	        gforth	key_q_file
""@i{f} is true if at least one character can be read from @i{wfileid}
without blocking.  If you also want to use @code{read-file} or
@code{read-line} on the file, you have to call @code{key?-file} or
@code{key-file} first (these two words disable buffering).""
#ifdef HAS_FILE
fflush(stdout);
f = key_query((FILE*)wfileid);
#else
f = key_query(stdin);
#endif

stdin	( -- wfileid )	gforth
""The standard input file of the Gforth process.""
wfileid = (Cell)stdin;

stdout	( -- wfileid )	gforth
""The standard output file of the Gforth process.""
wfileid = (Cell)stdout;

stderr	( -- wfileid )	gforth
""The standard error output file of the Gforth process.""
wfileid = (Cell)stderr;

term-prep?	( -- f )	gforth-internal	term_prep_q
f=FLAG(terminal_prepped);

\+os

(form)	( -- urows ucols )	gforth-internal	paren_form
""The number of lines and columns in the terminal. These numbers may
change with the window size.  Note that it depends on the OS whether
this reflects the actual size and changes with the window size
(currently only on Unix-like OSs).  On other OSs you just get a
default, and can tell Gforth the terminal size by setting the
environment variables @code{COLUMNS} and @code{LINES} before starting
Gforth.""
/* we could block SIGWINCH here to get a consistent size, but I don't
 think this is necessary or always beneficial */
urows=rows;
ucols=cols;

isatty	( wfileid -- f )	gforth-internal	isatty
""checks if fd is a (pseudo-)terminal""
f = FLAG(isatty( fileno((FILE*)wfileid) ));

isfg	 ( wfileid -- f )	gforth-internal	isfg
""check if fd is controlled by us (we are the foreground process)""
pid_t fg = tcgetpgrp( fileno((FILE*)wfileid) );
if (fg == -1) {
   f=-1; // non-terminal file, is ours
} else
   f=FLAG(fg == getpgrp());

wcwidth	( u -- n )	gforth-internal
""The number of fixed-width characters per unicode character u""
n = wcwidth(u);

flush-icache	( c_addr u -- )	gforth	flush_icache
""Make sure that the instruction cache of the processor (if there is
one) does not contain stale data at @i{c-addr} and @i{u} bytes
afterwards. @code{END-CODE} performs a @code{flush-icache}
automatically. Caveat: @code{flush-icache} might not work on your
installation; this is usually the case if direct threading is not
supported on your machine (take a look at your @file{machine.h}) and
your machine has a separate instruction cache. In such cases,
@code{flush-icache} does nothing instead of flushing the instruction
cache.""
FLUSH_ICACHE((caddr_t)c_addr,u);

(bye)	( n -- )	gforth-internal	paren_bye
SUPER_END;
gforth_FP=fp;
gforth_SP=sp;
gforth_RP=rp;
gforth_LP=lp;
return (Label *)n;

(system)	( c_addr u -- wretval wior )	gforth-internal	paren_system
wretval = gforth_system(c_addr, u);  
wior = IOR(wretval==-1 || (wretval==127 && errno != 0));

getenv	( c_addr1 u1 -- c_addr2 u2 )	gforth
""The string @i{c-addr1 u1} specifies an environment variable. The string @i{c-addr2 u2}
is the host operating system's expansion of that environment variable. If the
environment variable does not exist, @i{c-addr2 u2} specifies a string 0 characters
in length.""
/* close ' to keep fontify happy */
char * string = cstr(c_addr1,u1);
c_addr2 = (Char *)getenv(string);
u2 = (c_addr2 == NULL ? 0 : strlen((char *)c_addr2));
free_l(string);

open-pipe	( c_addr u wfam -- wfileid wior )	gforth	open_pipe
char * string = cstr(c_addr,u);
fflush(stdout);
wfileid=(Cell)popen(string,pfileattr[wfam]); /* ~ expansion of 1st arg? */
wior = IOR(wfileid==0); /* !! the man page says that errno is not set reliably */
free_l(string);

close-pipe	( wfileid -- wretval wior )		gforth	close_pipe
wretval = pclose((FILE *)wfileid);
wior = IOR(wretval==-1);

>time&date&tz	( udtime -- nsec nmin nhour nday nmonth nyear fdst ndstoff c_addrtz utz )	gforth	to_time_and_date
""Convert time in seconds since 1.1.1970 0:00Z to the current time of day. Seconds, minutes and hours are numbered from 0.
Months are numbered from 1.""
#ifdef BUGGY_LONG_LONG
time_t now=(time_t)DLO(udtime);
#else
time_t now=(time_t)udtime;
#endif
struct tm ltime;
localtime_r(&now, &ltime); /* thread save version */
nyear =ltime.tm_year+1900;
nmonth=ltime.tm_mon+1;
nday  =ltime.tm_mday;
nhour =ltime.tm_hour;
nmin  =ltime.tm_min;
nsec  =ltime.tm_sec;
fdst  =FLAG(ltime.tm_isdst);
#ifdef __USE_MISC
ndstoff=ltime.tm_gmtoff;
c_addrtz=(Char *)ltime.tm_zone;
utz     =strlen(ltime.tm_zone);
#else
ndstoff = 0;
c_addrtz= 0;
utz     = 0;
#endif

(ms)	( u -- )	gforth-internal	paren_ms
""Wait at least @i{n} milli-second.""
gforth_ms(u);

heap-allocate	( u -- a_addr wior )	gforth-internal	heap_allocate
""Allocate @i{u} address units of contiguous data space. The initial
contents of the data space is undefined. If the allocation is successful,
@i{a-addr} is the start address of the allocated region and @i{wior}
is 0. If the allocation fails, @i{a-addr} is undefined and @i{wior}
is a non-zero I/O result code.""
a_addr = (Cell *)malloc_l(u?u:1);
wior = IOR(a_addr==NULL);

heap-free	( a_addr -- wior )	gforth-internal	heap_free
""Return the region of data space starting at @i{a-addr} to the system.
The region must originally have been obtained using @code{allocate} or
@code{resize}. If the operational is successful, @i{wior} is 0.
If the operation fails, @i{wior} is a non-zero I/O result code.""
free_l(a_addr);
wior = 0;

heap-resize	( a_addr1 u -- a_addr2 wior )	gforth-internal	heap_resize
""Change the size of the allocated area at @i{a-addr1} to @i{u}
address units, possibly moving the contents to a different
area. @i{a-addr2} is the address of the resulting area.
If the operation is successful, @i{wior} is 0.
If the operation fails, @i{wior} is a non-zero
I/O result code. If @i{a-addr1} is 0, Gforth's (but not the Standard)
@code{resize} @code{allocate}s @i{u} address units.""
/* the following check is not necessary on most OSs, but it is needed
   on SunOS 4.1.2. */
/* close ' to keep fontify happy */
if (a_addr1==NULL)
  a_addr2 = (Cell *)malloc_l(u);
else
  a_addr2 = (Cell *)realloc_l(a_addr1, (u ? u : 1));
wior = IOR(a_addr2==NULL);	/* !! Define a return code */
if(wior)
  a_addr2 = a_addr1; /* in case of an error, keep a_addr1 */

strerror	( n -- c_addr u )	gforth-internal
c_addr = (Char *)strerror(n);
u = strlen((char *)c_addr);

strsignal	( n -- c_addr u )	gforth-internal
c_addr = (Char *)strsignal(n);
u = strlen((char *)c_addr);

call-c	( ... w -- ... )	gforth	call_c
""Call the C function pointed to by @i{w}. The C function has to
access the stack itself. The stack pointers are exported into a ptrpair
structure passed to the C function, and returned in that form.""
IF_fpTOS(fp[0]=fpTOS);
GFORTH_CALL_C(&w, sp, fp);
IF_fpTOS(fpTOS=fp[0]);

call-c#	( ... #a_addr -- ... )	gforth-internal	call_c_direct
""Call the C function pointed to by the inline argument @i{w}. The C function
has to access the stack itself. The stack pointers are exported into a ptrpair
structure passed to the C function, and returned in that form.""
IF_fpTOS(fp[0]=fpTOS);
GFORTH_CALL_C(a_addr, sp, fp);
IF_fpTOS(fpTOS=fp[0]);

call-c@	( ... a_addr -- ... )	gforth-internal	call_c_fetch
""Call the C function pointed to by the pointer stored at @i{a_addr}. The C
function has to access the stack itself. The stack pointers are exported into
a ptrpair structure passed to the C function, and returned in that form.""
IF_fpTOS(fp[0]=fpTOS);
GFORTH_CALL_C(a_addr, sp, fp);
IF_fpTOS(fpTOS=fp[0]);

gforth-pointers ( -- a_addr )  gforth-internal gforth_pointers
a_addr = (Cell*)gforth_pointers;

winch? ( -- a_addr )	gforth-internal winch_query
#ifdef SIGWINCH
a_addr = &winch_addr;
#else
a_addr = NULL;
#endif

\+
\+file

close-file	( wfileid -- wior )		file	close_file
wior = IOR(fclose((FILE *)wfileid)==EOF);

open-file	( c_addr u wfam -- wfileid wior )	file	open_file
char * string = tilde_cstr(c_addr,u);
wfileid = opencreate_file(string, wfam, 0, &wior);
free_l(string);

create-file	( c_addr u wfam -- wfileid wior )	file	create_file
char * string = tilde_cstr(c_addr,u);
wfileid = opencreate_file(string, wfam, O_CREAT|O_TRUNC, &wior);
free_l(string);

delete-file	( c_addr u -- wior )		file	delete_file
char * string = tilde_cstr(c_addr,u);
wior = IOR(unlink(string)==-1);
free_l(string);

rename-file	( c_addr1 u1 c_addr2 u2 -- wior )	file-ext	rename_file
""Rename file @i{c_addr1 u1} to new name @i{c_addr2 u2}""
wior = rename_file(c_addr1, u1, c_addr2, u2);

file-position	( wfileid -- ud wior )	file	file_position
/* !! use tell and lseek? */
ud = OFF2UD(ftello((FILE *)wfileid));
wior = IOR(UD2OFF(ud)==-1);

reposition-file	( ud wfileid -- wior )	file	reposition_file
wior = IOR(fseeko((FILE *)wfileid, UD2OFF(ud), SEEK_SET)==-1);

file-size	( wfileid -- ud wior )	file	file_size
struct stat buf;
wior = IOR(fstat(fileno((FILE *)wfileid), &buf)==-1);
if (wior==0 && (S_ISREG(buf.st_mode) || S_ISDIR(buf.st_mode)))
  ud = OFF2UD(buf.st_size);
else {
  ud = OFF2UD(0);
  wior = -2057; /* wrong file type */
}

resize-file	( ud wfileid -- wior )	file	resize_file
wior = IOR(ftruncate(fileno((FILE *)wfileid), UD2OFF(ud))==-1);

read-file	( c_addr u1 wfileid -- u2 wior )	file	read_file
""Read @i{u1} characters from file @i{wfileid} into the buffer at
@i{c_addr}.  A non-zero @i{wior} indicates an error.  @i{U2} indicates
the length of the read data.  End-of-file is not an error and is
indicated by @i{u2}$<$@i{u1} and @i{wior}=0.""
/* !! fread does not guarantee enough */
u2 = 0;
do {
  u2 += fread(c_addr+u2, sizeof(Char), u1-u2, (FILE *)wfileid);
  if (u2>0)
    gf_regetc((FILE *)wfileid);
  if((wior = FILEIO(u2<u1 && ferror((FILE *)wfileid))))
    clearerr((FILE *)wfileid);
} while(wior==TOIOR(EINTR));

(read-line) ( c_addr u1 wfileid -- u2 flag u3 wior ) gforth-internal paren_read_line
struct Cellquad r = read_line(c_addr, u1, (FILE *)wfileid);
u2   = r.n1;
flag = r.n2;
u3   = r.n3;
wior = r.n4;

\+

write-file	( c_addr u1 wfileid -- wior )	file	write_file
/* !! fwrite does not guarantee enough */
#ifdef HAS_FILE
UCell u2 = 0;
do {
  u2 += fwrite(c_addr+u2, sizeof(Char), u1-u2, (FILE *)wfileid);
  if((wior = FILEIO(u2<u1 && ferror((FILE *)wfileid))))
    clearerr((FILE *)wfileid);
} while(wior==TOIOR(EINTR));
#else
TYPE(c_addr, u1);
#endif

emit-file	( c wfileid -- wior )	gforth	emit_file
#ifdef HAS_FILE
do {
  wior = FILEIO(putc(c, (FILE *)wfileid)==EOF);
  if (wior)
    clearerr((FILE *)wfileid);
} while(wior==TOIOR(EINTR));
#else
PUTC(c);
#endif

\+file

flush-file	( wfileid -- wior )		file-ext	flush_file
wior = IOR(fflush((FILE *) wfileid)==EOF);

file-status	( c_addr u -- wfam wior )	file-ext	file_status
struct Cellpair r = file_status(c_addr, u);
wfam = r.n1;
wior = r.n2;

file-eof?	( wfileid -- flag )	gforth	file_eof_query
""@var{Flag} is true if the end-of-file indicator for @var{wfileid} is set.""
flag = FLAG(feof((FILE *) wfileid));

open-dir	( c_addr u -- wdirid wior )	gforth	open_dir
""Open the directory specified by @i{c-addr, u}
and return @i{dir-id} for futher access to it.""
char * string = tilde_cstr(c_addr,u);
wdirid = (Cell)opendir(string);
wior =  IOR(wdirid == 0);
free_l(string);

read-dir	( c_addr u1 wdirid -- u2 flag wior )	gforth	read_dir
""Attempt to read the next entry from the directory specified
by @i{dir-id} to the buffer of length @i{u1} at address @i{c-addr}. 
If the attempt fails because there is no more entries,
@i{ior}=0, @i{flag}=0, @i{u2}=0, and the buffer is unmodified.
If the attempt to read the next entry fails because of any other reason, 
return @i{ior}<>0.
If the attempt succeeds, store file name to the buffer at @i{c-addr}
and return @i{ior}=0, @i{flag}=true and @i{u2} equal to the size of the file name.
If the length of the file name is greater than @i{u1}, 
store first @i{u1} characters from file name into the buffer and
indicate "name too long" with @i{ior}, @i{flag}=true, and @i{u2}=@i{u1}.""
struct dirent * dresult;
dresult=readdir((DIR *)wdirid);
wior = 0;
flag = -1;
if(dresult == NULL) {
  u2 = 0;
  flag = 0;
} else {
  u2 = strlen((char *)dresult->d_name);
  if(u2 > u1) {
    u2 = u1;
    wior = -512-ENAMETOOLONG;
  }
  memmove(c_addr, dresult->d_name, u2);
}

close-dir	( wdirid -- wior )	gforth	close_dir
""Close the directory specified by @i{dir-id}.""
wior = IOR(closedir((DIR *)wdirid));

filename-match	( c_addr1 u1 c_addr2 u2 -- flag )	gforth	match_file
""match the file name @var{c_addr1 u1} with the pattern @var{c_addr2 u2}.
Patterns match char by char except for the special characters '*' and '?',
which are wildcards for several ('*') or one ('?') character.""
char * string = cstr(c_addr1, u1);
char * pattern = cstr(c_addr2, u2);
flag = FLAG(!fnmatch(pattern, string, 0));
free_l(string);
free_l(pattern);

set-dir	( c_addr u -- wior )	gforth set_dir
""Change the current directory to @i{c-addr, u}.
Return an error if this is not possible""
char * string = tilde_cstr(c_addr, u);
wior = IOR(chdir(string));
free_l(string);

get-dir	( c_addr1 u1 -- c_addr2 u2 )	gforth get_dir
""Store the current directory in the buffer specified by @i{c-addr1, u1}.
If the buffer size is not sufficient, return 0 0""
c_addr2 = (Char *)getcwd((char *)c_addr1, u1);
if(c_addr2 != NULL) {
  u2 = strlen((char *)c_addr2);
} else {
  u2 = 0;
}

=mkdir ( c_addr u wmode -- wior )        gforth equals_mkdir
""Create directory @i{c-addr u} with mode @i{wmode}.""
char * string = tilde_cstr(c_addr,u);
wior = IOR(mkdir(string,wmode));
free_l(string);

\+

newline	( -- c_addr u )	gforth
""String containing the newline sequence of the host OS""
static const char newline[] = {
#if DIRSEP=='/'
/* Unix */
'\n'
#else
/* DOS, Win, OS/2 */
'\r','\n'
#endif
};
c_addr=(Char *)newline;
u=sizeof(newline);
:
 "newline count ;
Create "newline e? crlf [IF] 2 c, $0D c, [ELSE] 1 c, [THEN] $0A c,

\+os

utime	( -- dtime )	gforth
""Report the current time in microseconds since some epoch.  Use @code{#1000000 um/mod nip} to convert to seconds""
struct timeval time1;
gettimeofday(&time1,NULL);
dtime = timeval2us(&time1);

cputime ( -- duser dsystem ) gforth
""duser and dsystem are the respective user- and system-level CPU
times used since the start of the Forth system (excluding child
processes), in microseconds (the granularity may be much larger,
however).  On platforms without the getrusage call, it reports elapsed
time (since some epoch) for duser and 0 for dsystem.""
#ifdef HAVE_GETRUSAGE
struct rusage usage;
getrusage(RUSAGE_SELF, &usage);
duser = timeval2us(&usage.ru_utime);
dsystem = timeval2us(&usage.ru_stime);
#else
struct timeval time1;
gettimeofday(&time1,NULL);
duser = timeval2us(&time1);
dsystem = DZERO;
#endif

ntime	( -- dtime )	gforth
""Report the current time in nanoseconds since some epoch.""
struct timespec time1;
#ifdef HAVE_CLOCK_GETTIME
clock_gettime(CLOCK_REALTIME,&time1);
#else
struct timeval time2;
gettimeofday(&time2,NULL);
time1.tv_sec = time2.tv_sec;
time1.tv_nsec = time2.tv_usec*1000;
#endif
dtime = timespec2ns(&time1);

(ns)    ( uns nsec -- wior )	gforth-internal	paren_ns
""Wait for usec+uns, values precomputed in Forth""
if(nsec >= 0) {
#if HAVE_PSELECT
  struct timespec tout = { nsec, uns };
  wior=IOR(pselect(0, NULL, NULL, NULL, &tout, NULL) < 0);
#else
  struct timeval tout = { nsec, uns/1000 };
  wior=IOR(select(0, NULL, NULL, NULL, &tout) < 0);
#endif
} else {
  wior = 0;
}

\+

\+floating

\g floating

f=	( r1 r2 -- f )		gforth	f_equals
#line 2570
f = FLAG(r1==r2);
#line 2570
:
#line 2570
    [ char fx char 0 = [IF]
#line 2570
	] IF false ELSE true THEN [
#line 2570
    [ELSE]
#line 2570
	] xor 0= [
#line 2570
    [THEN] ] ;
#line 2570

#line 2570
f<>	( r1 r2 -- f )		gforth	f_not_equals
#line 2570
f = FLAG(r1!=r2);
#line 2570
:
#line 2570
    [ char fx char 0 = [IF]
#line 2570
	] IF true ELSE false THEN [
#line 2570
    [ELSE]
#line 2570
	] xor 0<> [
#line 2570
    [THEN] ] ;
#line 2570

#line 2570
f<	( r1 r2 -- f )		floating	f_less_than
#line 2570
f = FLAG(r1<r2);
#line 2570
:
#line 2570
    [ char fx char 0 = [IF]
#line 2570
	] MINI and 0<> [
#line 2570
    [ELSE] char fx char u = [IF]
#line 2570
	]   2dup xor 0<  IF nip ELSE - THEN 0<  [
#line 2570
	[ELSE]
#line 2570
	    ] MINI xor >r MINI xor r> u< [
#line 2570
	[THEN]
#line 2570
    [THEN] ] ;
#line 2570

#line 2570
f>	( r1 r2 -- f )		gforth	f_greater_than
#line 2570
f = FLAG(r1>r2);
#line 2570
:
#line 2570
    [ char fx char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 2570
    f< ;
#line 2570

#line 2570
f<=	( r1 r2 -- f )		gforth	f_less_or_equal
#line 2570
f = FLAG(r1<=r2);
#line 2570
:
#line 2570
    f> 0= ;
#line 2570

#line 2570
f>=	( r1 r2 -- f )		gforth	f_greater_or_equal
#line 2570
f = FLAG(r1>=r2);
#line 2570
:
#line 2570
    [ char fx char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 2570
    f<= ;
#line 2570

#line 2570

f0=	( r -- f )		floating	f_zero_equals
#line 2571
f = FLAG(r==0.);
#line 2571
:
#line 2571
    [ char f0x char 0 = [IF]
#line 2571
	] IF false ELSE true THEN [
#line 2571
    [ELSE]
#line 2571
	] xor 0= [
#line 2571
    [THEN] ] ;
#line 2571

#line 2571
f0<>	( r -- f )		gforth	f_zero_not_equals
#line 2571
f = FLAG(r!=0.);
#line 2571
:
#line 2571
    [ char f0x char 0 = [IF]
#line 2571
	] IF true ELSE false THEN [
#line 2571
    [ELSE]
#line 2571
	] xor 0<> [
#line 2571
    [THEN] ] ;
#line 2571

#line 2571
f0<	( r -- f )		floating	f_zero_less_than
#line 2571
f = FLAG(r<0.);
#line 2571
:
#line 2571
    [ char f0x char 0 = [IF]
#line 2571
	] MINI and 0<> [
#line 2571
    [ELSE] char f0x char u = [IF]
#line 2571
	]   2dup xor 0<  IF nip ELSE - THEN 0<  [
#line 2571
	[ELSE]
#line 2571
	    ] MINI xor >r MINI xor r> u< [
#line 2571
	[THEN]
#line 2571
    [THEN] ] ;
#line 2571

#line 2571
f0>	( r -- f )		gforth	f_zero_greater_than
#line 2571
f = FLAG(r>0.);
#line 2571
:
#line 2571
    [ char f0x char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 2571
    f0< ;
#line 2571

#line 2571
f0<=	( r -- f )		gforth	f_zero_less_or_equal
#line 2571
f = FLAG(r<=0.);
#line 2571
:
#line 2571
    f0> 0= ;
#line 2571

#line 2571
f0>=	( r -- f )		gforth	f_zero_greater_or_equal
#line 2571
f = FLAG(r>=0.);
#line 2571
:
#line 2571
    [ char f0x char 0 = [IF] ] negate [ [ELSE] ] swap [ [THEN] ]
#line 2571
    f0<= ;
#line 2571

#line 2571


s>f	( n -- r )		floating-ext	s_to_f
r = n;

d>f	( d -- r )		floating	d_to_f
#ifdef BUGGY_LL_D2F
extern double ldexp(double x, int exp);
if (DHI(d)<0) {
#ifdef BUGGY_LL_ADD
  DCell d2=dnegate(d);
#else
  DCell d2=-d;
#endif
  r = -(ldexp((Float)DHI(d2),CELL_BITS) + (Float)DLO(d2));
} else
  r = ldexp((Float)DHI(d),CELL_BITS) + (Float)DLO(d);
#else
r = d;
#endif

f>d	( r -- d )		floating	f_to_d
extern DCell double2ll(Float r);
d = double2ll(r);

f>s	( r -- n )		floating-ext	f_to_s
n = (Cell)r;

f!	( r f_addr -- )	floating	f_store
""Store @i{r} into the float at address @i{f-addr}.""
*f_addr = r;

f@	( f_addr -- r )	floating	f_fetch
""@i{r} is the float at address @i{f-addr}.""
r = *f_addr;

df@	( df_addr -- r )	floating-ext	d_f_fetch
""Fetch the double-precision IEEE floating-point value @i{r} from the address @i{df-addr}.""
#ifdef IEEE_FP
r = *df_addr;
#else
!! df@
#endif

df!	( r df_addr -- )	floating-ext	d_f_store
""Store @i{r} as double-precision IEEE floating-point value to the
address @i{df-addr}.""
#ifdef IEEE_FP
*df_addr = r;
#else
!! df!
#endif

sf@	( sf_addr -- r )	floating-ext	s_f_fetch
""Fetch the single-precision IEEE floating-point value @i{r} from the address @i{sf-addr}.""
#ifdef IEEE_FP
r = *sf_addr;
#else
!! sf@
#endif

sf!	( r sf_addr -- )	floating-ext	s_f_store
""Store @i{r} as single-precision IEEE floating-point value to the
address @i{sf-addr}.""
#ifdef IEEE_FP
*sf_addr = r;
#else
!! sf!
#endif

f+	( r1 r2 -- r3 )	floating	f_plus
r3 = r1+r2;

f-	( r1 r2 -- r3 )	floating	f_minus
r3 = r1-r2;

f*	( r1 r2 -- r3 )	floating	f_star
r3 = r1*r2;

f/	( r1 r2 -- r3 )	floating	f_slash
r3 = r1/r2;

f**	( r1 r2 -- r3 )	floating-ext	f_star_star
""@i{r3} = @i{r1}@sup{@i{r2}}""
CLOBBER_TOS_WORKAROUND_START;
r3 = pow(r1,r2);
CLOBBER_TOS_WORKAROUND_END;

fm*	( r1 n -- r2 )	gforth-internal	fm_star
r2 = r1*n;

fm/	( r1 n -- r2 )	gforth-internal	fm_slash
r2 = r1/n;

fm*/	( r1 n1 n2 -- r2 )	gforth-internal	fm_star_slash
r2 = (r1*n1)/n2;

f**2	( r1 -- r2 )	gforth-internal	fm_square
r2 = r1*r1;

fnegate	( r1 -- r2 )	floating	f_negate
r2 = - r1;

fdrop	( r -- )		floating	f_drop
ALIVE_DEBUGGING(r);

fdup	( r -- r r )	floating	f_dupe

fswap	( r1 r2 -- r2 r1 )	floating	f_swap

fover	( r1 r2 -- r1 r2 r1 )	floating	f_over

frot	( r1 r2 r3 -- r2 r3 r1 )	floating	f_rote

fnip	( r1 r2 -- r2 )	gforth	f_nip

ftuck	( r1 r2 -- r2 r1 r2 )	gforth	f_tuck

float+	( f_addr1 -- f_addr2 )	floating	float_plus
""@code{1 floats +}.""
f_addr2 = f_addr1+1;

floats	( n1 -- n2 )	floating
""@i{n2} is the number of address units of @i{n1} floats.""
n2 = n1*sizeof(Float);

floor	( r1 -- r2 )	floating
""Round towards the next smaller integral value, i.e., round toward negative infinity.""
/* !! unclear wording */
CLOBBER_TOS_WORKAROUND_START;
r2 = floor(r1);
CLOBBER_TOS_WORKAROUND_END;

fround	( r1 -- r2 )	floating	f_round
""Round to the nearest integral value.""
CLOBBER_TOS_WORKAROUND_START;
r2 = rint(r1);
CLOBBER_TOS_WORKAROUND_END;

fmax	( r1 r2 -- r3 )	floating	f_max
if (r1<r2)
  r3 = r2;
else
  r3 = r1;

fmin	( r1 r2 -- r3 )	floating	f_min
if (r1<r2)
  r3 = r1;
else
  r3 = r2;

represent	( r c_addr u -- n f1 f2 )	floating
""Convert the decimal significand (aka mantissa) of @i{r} into a
string in buffer @i{c-addr u}; @i{n} is the exponent, @i{f1} is true
if @i{r} is negative, and @i{f2} is true if @i{r} is valid (a finite
number in Gforth).""
#ifdef ECVT_FLAG
char sig[0x40];
size_t siglen;
int flag;
int decpt=0;
switch (fpclassify(r)) {
 case FP_INFINITE:  strncpy(sig, "infinite", 0x3f);  break;
 case FP_NAN:       strncpy(sig, "NaN", 0x3f); break;
 case FP_ZERO:
 case FP_SUBNORMAL:
 case FP_NORMAL:
   ecvt_r(r, u, &decpt, &flag, sig, 0x3f);
}
n=(r==0. ? 1 : decpt);
flag=signbit(r); /* not all ecvt()s do this as desired */
f1=FLAG(flag!=0);
f2=FLAG(isdigit((unsigned)(sig[0]))!=0);
siglen=strlen((char *)sig);
if (siglen>u) /* happens in glibc-2.1.3 if 999.. is rounded up */
  siglen=u;
if (!f2) /* workaround Cygwin trailing 0s for Inf and Nan */
  for (; sig[siglen-1]=='0'; siglen--);
    ;
memmove(c_addr,sig,siglen);
memset(c_addr+siglen,f2?'0':' ',u-siglen);
#else
struct Cellpair fs = represent(r, c_addr, u, &n);
f1 = fs.n1;
f2 = fs.n2;
#endif

>float	( c_addr u -- f:... flag )	floating	to_float
""Actual stack effect: ( c_addr u -- r t | f ).  Attempt to convert the
character string @i{c-addr u} to internal floating-point
representation. If the string represents a valid floating-point number,
@i{r} is placed on the floating-point stack and @i{flag} is
true. Otherwise, @i{flag} is false. A string of blanks is a special
case and represents the floating-point number 0.""
Float r;
flag = to_float(c_addr, u, &r, '.');
if (flag) {
  fp--;
  fp[0]=r;
}

fabs	( r1 -- r2 )	floating-ext	f_abs
r2 = fabs(r1);

facos	( r1 -- r2 )	floating-ext	f_a_cos
CLOBBER_TOS_WORKAROUND_START;
r2 = acos(r1);
CLOBBER_TOS_WORKAROUND_END;

fasin	( r1 -- r2 )	floating-ext	f_a_sine
CLOBBER_TOS_WORKAROUND_START;
r2 = asin(r1);
CLOBBER_TOS_WORKAROUND_END;

fatan	( r1 -- r2 )	floating-ext	f_a_tan
CLOBBER_TOS_WORKAROUND_START;
r2 = atan(r1);
CLOBBER_TOS_WORKAROUND_END;

fatan2	( r1 r2 -- r3 )	floating-ext	f_a_tan_two
""@i{r1/r2}=tan(@i{r3}). Forth-2012 does not require, but probably
intends this to be the inverse of @code{fsincos}. In Gforth it is.""
CLOBBER_TOS_WORKAROUND_START;
r3 = atan2(r1,r2);
CLOBBER_TOS_WORKAROUND_END;

fcos	( r1 -- r2 )	floating-ext	f_cos
CLOBBER_TOS_WORKAROUND_START;
r2 = cos(r1);
CLOBBER_TOS_WORKAROUND_END;

fexp	( r1 -- r2 )	floating-ext	f_e_x_p
""@i{r2} = e@sup{@i{r1}}""
CLOBBER_TOS_WORKAROUND_START;
r2 = exp(r1);
CLOBBER_TOS_WORKAROUND_END;

fexpm1	( r1 -- r2 )	floating-ext	f_e_x_p_m_one
""@i{r2}=e@sup{@i{r1}}@minus{}1""
#ifdef HAVE_EXPM1
extern double
#ifdef NeXT
              const
#endif
                    expm1(double);
CLOBBER_TOS_WORKAROUND_START;
r2 = expm1(r1);
#else
r2 = exp(r1)-1.;
#endif
CLOBBER_TOS_WORKAROUND_END;

fln	( r1 -- r2 )	floating-ext	f_l_n
""Natural logarithm: @i{r1} = e@sup{@i{r2}}""
CLOBBER_TOS_WORKAROUND_START;
r2 = log(r1);
CLOBBER_TOS_WORKAROUND_END;

flnp1	( r1 -- r2 )	floating-ext	f_l_n_p_one
""Inverse of @code{fexpm1}: @i{r1}+1 = e@sup{r2}""
#ifdef HAVE_LOG1P
extern double
#ifdef NeXT
              const
#endif
                    log1p(double);
CLOBBER_TOS_WORKAROUND_START;
r2 = log1p(r1);
#else
r2 = log(r1+1.);
#endif
CLOBBER_TOS_WORKAROUND_END;

flog	( r1 -- r2 )	floating-ext	f_log
""The decimal logarithm: @i{r1} = 10@sup{@i{r2}}""
CLOBBER_TOS_WORKAROUND_START;
r2 = log10(r1);
CLOBBER_TOS_WORKAROUND_END;

falog	( r1 -- r2 )	floating-ext	f_a_log
""@i{r2}=10@sup{@i{r1}}""
extern double exp10(double);
CLOBBER_TOS_WORKAROUND_START;
r2 = exp10(r1);
CLOBBER_TOS_WORKAROUND_END;

fsin	( r1 -- r2 )	floating-ext	f_sine
CLOBBER_TOS_WORKAROUND_START;
r2 = sin(r1);
CLOBBER_TOS_WORKAROUND_END;

fsincos	( r1 -- r2 r3 )	floating-ext	f_sine_cos
""@i{r2}=sin(@i{r1}), @i{r3}=cos(@i{r1})""
CLOBBER_TOS_WORKAROUND_START;
sincos(r1, &r2, &r3);
CLOBBER_TOS_WORKAROUND_END;

fsqrt	( r1 -- r2 )	floating-ext	f_square_root
CLOBBER_TOS_WORKAROUND_START;
r2 = sqrt(r1);
CLOBBER_TOS_WORKAROUND_END;

ftan	( r1 -- r2 )	floating-ext	f_tan
CLOBBER_TOS_WORKAROUND_START;
r2 = tan(r1);
CLOBBER_TOS_WORKAROUND_END;
:
 fsincos f/ ;

fsinh	( r1 -- r2 )	floating-ext	f_cinch
CLOBBER_TOS_WORKAROUND_START;
r2 = sinh(r1);
CLOBBER_TOS_WORKAROUND_END;
:
 fexpm1 fdup fdup 1. d>f f+ f/ f+ f2/ ;

fcosh	( r1 -- r2 )	floating-ext	f_cosh
CLOBBER_TOS_WORKAROUND_START;
r2 = cosh(r1);
CLOBBER_TOS_WORKAROUND_END;
:
 fexp fdup 1/f f+ f2/ ;

ftanh	( r1 -- r2 )	floating-ext	f_tan_h
CLOBBER_TOS_WORKAROUND_START;
r2 = tanh(r1);
CLOBBER_TOS_WORKAROUND_END;
:
 f2* fexpm1 fdup 2. d>f f+ f/ ;

fasinh	( r1 -- r2 )	floating-ext	f_a_cinch
CLOBBER_TOS_WORKAROUND_START;
r2 = asinh(r1);
CLOBBER_TOS_WORKAROUND_END;
:
 fdup fdup f* 1. d>f f+ fsqrt f/ fatanh ;

facosh	( r1 -- r2 )	floating-ext	f_a_cosh
CLOBBER_TOS_WORKAROUND_START;
r2 = acosh(r1);
CLOBBER_TOS_WORKAROUND_END;
:
 fdup fdup f* 1. d>f f- fsqrt f+ fln ;

fatanh	( r1 -- r2 )	floating-ext	f_a_tan_h
CLOBBER_TOS_WORKAROUND_START;
r2 = atanh(r1);
CLOBBER_TOS_WORKAROUND_END;
:
 fdup f0< >r fabs 1. d>f fover f- f/  f2* flnp1 f2/
 r> IF  fnegate  THEN ;

sfloats	( n1 -- n2 )	floating-ext	s_floats
""@i{n2} is the number of address units of @i{n1}
single-precision IEEE floating-point numbers.""
n2 = n1*sizeof(SFloat);

dfloats	( n1 -- n2 )	floating-ext	d_floats
""@i{n2} is the number of address units of @i{n1}
double-precision IEEE floating-point numbers.""
n2 = n1*sizeof(DFloat);

sfaligned	( c_addr -- sf_addr )	floating-ext	s_f_aligned
""@i{sf-addr} is the first single-float-aligned address greater
than or equal to @i{c-addr}.""
sf_addr = (SFloat *)((((Cell)c_addr)+(sizeof(SFloat)-1))&(-sizeof(SFloat)));
:
 [ 1 sfloats 1- ] Literal + [ -1 sfloats ] Literal and ;

dfaligned	( c_addr -- df_addr )	floating-ext	d_f_aligned
""@i{df-addr} is the first double-float-aligned address greater
than or equal to @i{c-addr}.""
df_addr = (DFloat *)((((Cell)c_addr)+(sizeof(DFloat)-1))&(-sizeof(DFloat)));
:
 [ 1 dfloats 1- ] Literal + [ -1 dfloats ] Literal and ;

v*	( f_addr1 nstride1 f_addr2 nstride2 ucount -- r ) gforth v_star
""dot-product: r=v1*v2.  The first element of v1 is at f_addr1, the
next at f_addr1+nstride1 and so on (similar for v2). Both vectors have
ucount elements.""
r = v_star(f_addr1, nstride1, f_addr2, nstride2, ucount);
:
 >r swap 2swap swap 0e r> 0 ?DO
     dup f@ over + 2swap dup f@ f* f+ over + 2swap
 LOOP 2drop 2drop ; 

faxpy	( ra f_x nstridex f_y nstridey ucount -- )	gforth
""vy=ra*vx+vy, where @i{vy} is the vector starting at @i{f_y} with
stride @i{nstridey} bytes, and @i{vx} is the vector starting at
@i{f_x} with stride @i{nstridex}, and both vectors contain @i{ucount
elements}.""
faxpy(ra, f_x, nstridex, f_y, nstridey, ucount);
:
 >r swap 2swap swap r> 0 ?DO
     fdup dup f@ f* over + 2swap dup f@ f+ dup f! over + 2swap
 LOOP 2drop 2drop fdrop ;

>float1	( c_addr u c -- f:... flag )	gforth	to_float1
""Actual stack effect: ( c_addr u c -- r t | f ).  Attempt to convert the
character string @i{c-addr u} to internal floating-point
representation, with @i{c} being the decimal separator.
If the string represents a valid floating-point number,
@i{r} is placed on the floating-point stack and @i{flag} is
true. Otherwise, @i{flag} is false. A string of blanks is a special
case and represents the floating-point number 0.""
Float r;
flag = to_float(c_addr, u, &r, c);
if (flag) {
  fp--;
  fp[0]=r;
}

float/ ( n1 -- n2 )	gforth	float_divide
""@i{N2} is the number of floats that fit into @i{n1} aus, rounded
towards negative infinity.""
BUILD_BUG_ON(sizeof(Float)!=8);
n2 = n1 >> 3;

dfloat/ ( n1 -- n2 )	gforth	d_float_divide
""@i{N2} is the number of dfloats that fit into @i{n1} aus, rounded
towards negative infinity.""
BUILD_BUG_ON(sizeof(DFloat)!=8);
n2 = n1 >> 3;

sfloat/ ( n1 -- n2 )	gforth	s_float_divide
""@i{N2} is the number of sfloats that fit into @i{n1} aus, rounded
towards negative infinity.""
BUILD_BUG_ON(sizeof(SFloat)!=4);
n2 = n1 >> 2;

f-rot	( r1 r2 r3 -- r3 r1 r2 )	floating	f_not_rote

flit	( #w -- r )   gforth-internal
/* For 64 bit systems: a float is just one word */
union { Cell u; Float r; } cv;
cv.u = w;
r = cv.r;

flit0	( #w0 #w1 -- r )   gforth-internal
/* For 32 bit systems: a float is two words */
union { struct { Cell a, b;} d; Float r; } cv;
cv.d.a = w0;
cv.d.b = w1;
r = cv.r;

flit1	( #wpadding #w0 #w1 -- r )   gforth-internal
/* For 32 bit systems: a float is two words, padded for alignment */
union { struct { Cell a, b;} d; Float r; } cv;
cv.d.a = w0;
cv.d.b = w1;
r = cv.r;

\+

\ The following words access machine/OS/installation-dependent
\   Gforth internals
\ !! how about environmental queries DIRECT-THREADED,
\   INDIRECT-THREADED, TOS-CACHED, FTOS-CACHED, CODEFIELD-DOES */

\ local variable implementation primitives

\+glocals

\g locals

@localn ( noffset -- w )	gforth-internal	fetch_local_n
w = *(Cell *)(lp+noffset);

\ m4 macro definition: forlocal(upperbound,text) 
#line 3042



@local0 ( -- w )	gforth-internal	fetch_local_0
#line 3045
w = ((Cell *)lp)[0];
#line 3045

#line 3045
@local1 ( -- w )	gforth-internal	fetch_local_1
#line 3045
w = ((Cell *)lp)[1];
#line 3045

#line 3045
@local2 ( -- w )	gforth-internal	fetch_local_2
#line 3045
w = ((Cell *)lp)[2];
#line 3045

#line 3045
@local3 ( -- w )	gforth-internal	fetch_local_3
#line 3045
w = ((Cell *)lp)[3];
#line 3045

#line 3045
@local4 ( -- w )	gforth-internal	fetch_local_4
#line 3045
w = ((Cell *)lp)[4];
#line 3045

#line 3045
@local5 ( -- w )	gforth-internal	fetch_local_5
#line 3045
w = ((Cell *)lp)[5];
#line 3045

#line 3045
@local6 ( -- w )	gforth-internal	fetch_local_6
#line 3045
w = ((Cell *)lp)[6];
#line 3045

#line 3045
@local7 ( -- w )	gforth-internal	fetch_local_7
#line 3045
w = ((Cell *)lp)[7];
#line 3045



!localn ( w noffset -- )	gforth-internal	store_local_n
*(Cell *)(lp+noffset) = w;

!local0 ( w -- )	gforth-internal	store_local_0
#line 3051
((Cell *)lp)[0] = w;
#line 3051

#line 3051
!local1 ( w -- )	gforth-internal	store_local_1
#line 3051
((Cell *)lp)[1] = w;
#line 3051

#line 3051
!local2 ( w -- )	gforth-internal	store_local_2
#line 3051
((Cell *)lp)[2] = w;
#line 3051

#line 3051
!local3 ( w -- )	gforth-internal	store_local_3
#line 3051
((Cell *)lp)[3] = w;
#line 3051

#line 3051
!local4 ( w -- )	gforth-internal	store_local_4
#line 3051
((Cell *)lp)[4] = w;
#line 3051

#line 3051
!local5 ( w -- )	gforth-internal	store_local_5
#line 3051
((Cell *)lp)[5] = w;
#line 3051

#line 3051
!local6 ( w -- )	gforth-internal	store_local_6
#line 3051
((Cell *)lp)[6] = w;
#line 3051

#line 3051
!local7 ( w -- )	gforth-internal	store_local_7
#line 3051
((Cell *)lp)[7] = w;
#line 3051



+!localn ( w noffset -- )	gforth-internal	plus_store_local_n
*(Cell *)(lp+noffset) += w;

lp+n ( noffset -- c_addr )	gforth-internal	lp_plus_n
c_addr = (Char *)(lp+noffset);

\+floating

f@localn	( noffset -- r ) gforth	f_fetch_local_n
r = *(Float *)(lp+noffset);

\ if we define the following, we also should do prim-states for them;
\ the benefit of these is just one native instruction per VM inst
\ it does not justify the cost
\ #forlocal(`7',`f@local%i ( -- r ) gforth f_fetch_local_%i
\ #r = ((Float *)lp)[i];')
\ #
\ #forlocal(`7',`f!local%i ( r -- ) gforth f_store_local_%i
\ #((Float *)lp)[i] = r;')

\+

lp@ ( -- c_addr ) gforth lp_fetch
""@i{C_addr} is the current value of the locals stack pointer.""
c_addr = lp;

lp+!	( noffset -- )	gforth	lp_plus_store
""When used with negative @i{noffset} allocates memory on the
local stack; when used with a positive @i{noffset} drops memory from the local
stack""
lp += noffset;
ALIVE_DEBUGGING(lp[-1]);

lp-	( -- )	new	lp_minus
lp += -sizeof(Cell);

lp+	( -- )	new	lp_plus
lp += sizeof(Float);
ALIVE_DEBUGGING(lp[-1]);

lp+2	( -- )	new	lp_plus_two
lp += 2*sizeof(Float);
ALIVE_DEBUGGING(lp[-1]);

lp!	( c_addr -- )	gforth-internal	lp_store
lp = (Address)c_addr;

>l	( w -- )	gforth	to_l
lp -= sizeof(Cell);
*(Cell *)lp = w;

\+floating

f>l	( r -- )	gforth	f_to_l
lp -= sizeof(Float);
*(Float *)lp = r;

fpick	( f:... u -- f:... r )		gforth
""Actually the stack effect is @code{ r0 ... ru u -- r0 ... ru r0 }.""
r = fp[u];
:
 floats fp@ + f@ ;

fthird	  ( r1 r2 r3 -- r1 r2 r3 r1 )	gforth

ffourth	  ( r1 r2 r3 r4 -- r1 r2 r3 r4 r1 )	gforth

\+
\+

\+OS

\g syslib

open-lib	( c_addr1 u1 -- u2 )	gforth	open_lib
u2 = gforth_dlopen(c_addr1, u1);

open-lib2	( c_addr1 u1 -- u2 )	gforth-internal	open_lib2
u2 = gforth_dlopen2(c_addr1, u1);

lib-sym	( c_addr1 u1 u2 -- u3 )	gforth	lib_sym
char * string = cstr(c_addr1, u1);
#ifdef HAVE_LIBLTDL
u3 = (UCell) lt_dlsym((lt_dlhandle)u2, string);
#elif defined(HAVE_LIBDL) || defined(HAVE_DLOPEN)
u3 = (UCell) dlsym((void*)u2,string);
#else
#  ifdef _WIN32
u3 = (Cell) GetProcAddress((HMODULE)u2, string);
#  else
#warning Define lib-sym!
u3 = 0;
#  endif
#endif
free_l(string);

lib-sym2	( c_addr1 u1 u2 -- u3 )	gforth-internal	lib_sym2
u3 = gforth_dlsym2(c_addr1, u1, u2);

wcall	( ... u -- ... )	gforth-internal
gforth_FP=fp;
sp=(Cell*)(SYSCALL(Cell*(*)(Cell *, void *))u)(sp, &gforth_FP);
fp=gforth_FP;

w@ ( c_addr -- u )	gforth w_fetch
""@i{u} is the zero-extended 16-bit value stored at @i{c_addr}.""
#ifdef UNALIGNED_MEM
u = *(UWyde*)c_addr;
#else
UWyde wy;
memcpy((Char*)&wy, c_addr, 2);
u = wy;
#endif

w! ( w c_addr -- )	gforth w_store
""Store the bottom 16 bits of @i{w} at @i{c_addr}.""
#ifdef UNALIGNED_MEM
*(UWyde*)c_addr = w;
#else
UWyde wy = w;
memcpy(c_addr, (Char*)&wy, 2);
#endif

l@ ( c_addr -- u )	gforth l_fetch
""@i{u} is the zero-extended 32-bit value stored at @i{c_addr}.""
#ifdef UNALIGNED_MEM
u = *(UTetrabyte*)c_addr;
#else
UTetrabyte tb;
memcpy((Char*)&tb, c_addr, 4);
u = tb;
#endif

l! ( w c_addr -- )	gforth l_store
""Store the bottom 32 bits of @i{w} at @i{c_addr}.""
#ifdef UNALIGNED_MEM
*(UTetrabyte*)c_addr = w;
#else
UTetrabyte tb = w;
memcpy(c_addr, (Char*)&tb, 4);
#endif

lib-error ( -- c_addr u )       gforth  lib_error
""Error message for last failed @code{open-lib} or @code{lib-sym}.""
#ifdef HAVE_LIBLTDL
c_addr = (Char *)lt_dlerror();
u = (c_addr == NULL) ? 0 : strlen((char *)c_addr);
#elif defined(HAVE_LIBDL) || defined(HAVE_DLOPEN)
c_addr = (Char *)dlerror();
u = strlen((char *)c_addr);
#else
c_addr = "libltdl is not configured";
u = strlen((char *)c_addr);
#endif

close-lib ( u -- )   gforth-internal close_lib
gforth_dlclose(u);

close-lib2 ( u -- )   gforth-internal close_lib2
gforth_dlclose2(u);

\+

\g 64bit

\+64bit

x! ( w c_addr -- )	gforth x_store
""Store the bottom 64 bits of @i{w} at @i{c_addr}.""
#ifdef UNALIGNED_MEM
*(UOctabyte*)c_addr = w;
#else
UOctabyte ob = w;
memcpy(c_addr, (Char*)&ob, 8);
#endif

x@ ( c_addr -- u )	gforth x_fetch
""@i{u} is the zero-extended 64-bit value stored at @i{c_addr}.""
#ifdef UNALIGNED_MEM
u = *(UOctabyte*)c_addr;
#else
UOctabyte ob;
memcpy((Char*)&ob, c_addr, 8);
u = ob;
#endif

\+

\g memory

xd! ( ud c_addr -- )	gforth x_d_store
""Store the bottom 64 bits of @i{ud} at @i{c_addr}.""
#ifdef UNALIGNED_MEM
# if defined(BUGGY_LL_SIZE) || (SIZEOF_CHAR_P == 4)
#  ifdef WORDS_BIGENDIAN
((UTetrabyte*)c_addr)[0]=DHI(ud);
((UTetrabyte*)c_addr)[1]=DLO(ud);
#  else
((UTetrabyte*)c_addr)[1]=DHI(ud);
((UTetrabyte*)c_addr)[0]=DLO(ud);
#  endif
# else
*(UOctabyte*)c_addr = ud;
# endif
#else
# if defined(BUGGY_LL_SIZE) || (SIZEOF_CHAR_P == 4)
#  if (SIZEOF_CHAR_P == 4)
#   ifdef WORDS_BIGENDIAN
UTetrabyte tb[2];
tb[0]=DHI(ud);
tb[1]=DLO(ud);
memcpy(c_addr, (Char*)tb, 8);
#   else
UTetrabyte tb[2];
tb[1]=DHI(ud);
tb[0]=DLO(ud);
memcpy(c_addr, (Char*)tb, 8);
#   endif
#  else
UOctabyte ob=DLO(ud);
memcpy(c_addr, (Char*)&ob, 8);
#  endif
# else
UOctabyte ob=ud;
memcpy(c_addr, (Char*)&ob, 8);
# endif
#endif

xd@ ( c_addr -- ud )	gforth x_d_fetch
""@i{ud} is the zero-extended 64-bit value stored at @i{c_addr}.""
#ifdef UNALIGNED_MEM
# if defined(BUGGY_LL_SIZE) || (SIZEOF_CHAR_P == 4)
UTetrabyte tb[2];
tb[0] = ((UTetrabyte*)c_addr)[0];
tb[1] = ((UTetrabyte*)c_addr)[1];
#  ifdef WORDS_BIGENDIAN
D_IS(ud, tb[0], tb[1]);
#  else
D_IS(ud, tb[1], tb[0]);
#  endif
# else
ud = *(UOctabyte*)c_addr;
# endif
#else
# if defined(BUGGY_LL_SIZE) || (SIZEOF_CHAR_P == 4)
#  if (SIZEOF_CHAR_P == 4)
UTetrabyte tb[2];
memcpy((Char*)tb, c_addr, 8);
#   ifdef WORDS_BIGENDIAN
D_IS(ud, tb[0], tb[1]);
#   else
D_IS(ud, tb[1], tb[0]);
#   endif
#  else
UOctabyte ob;
memcpy((Char*)&ob, c_addr, 8);
D_IS(ud, 0, ob);
#  endif
# else
UOctabyte ob;
memcpy((Char*)&ob, c_addr, 8);
ud = ob;
# endif
#endif

w>< ( u1 -- u2 )  gforth-internal wordswap
u2=BSWAP16(u1);

l>< ( u1 -- u2 )  gforth-internal longswap
u2=BSWAP32(u1);

x>< ( u1 -- u2 )  gforth-internal extralongswap
u2=BSWAP64((uint64_t)u1);

xd>< ( ud1 -- ud2 )  gforth-internal extralongdswap
#if SIZEOF_CHAR_P == 8
D_IS(ud2, 0LL, BSWAP64(DLO(ud1)));
#else
# ifdef BUGGY_LL_SWAP
D_IS(ud2, BSWAP32(DLO(ud1)), BSWAP32(DHI(ud1)));
# else
ud2=BSWAP64(ud1);
# endif
#endif

c>s ( x -- n )  gforth c_to_s
""Sign-extend the 8-bit value in @i{x} to cell @i{n}.""
n=(signed char)x;

w>s ( x -- n )  gforth w_to_s
""Sign-extend the 16-bit value in @i{x} to cell @i{n}.""
n=(Wyde)x;

l>s ( x -- n )  gforth l_to_s
""Sign-extend the 32-bit value in @i{x} to cell @i{n}.""
n=(Tetrabyte)x;

>pow2 ( u1 -- u2 )  gforth to_pow2
""@i{u2} is the lowest power-of-2 number with @i{u2>=u1}.""
#ifdef HAVE___BUILTIN_CLZL
u2=(u1 == 1) ? u1 : // widely found bug for scanning 0
(((UCell)-1)>>__builtin_clzl(u1-1))+1;
#else
u1--;
u1 |= u1>>1;
u1 |= u1>>2;
u1 |= u1>>4;
u1 |= u1>>8;
u1 |= u1>>16;
#if SIZEOF_CHAR_P == 8
u1 |= u1>>32;
#endif
u2 = u1+1;
#endif

log2	( u -- n )	gforth
""@i{N} is the rounded-down binary logarithm of @i{u}, i.e., the index of
the first set bit; if @i{u}=0, @i{n}=-1.""
#ifdef HAVE___BUILTIN_CLZL
if (u==0)
   n=-1;
else
   n=(8*sizeof(long)-1)-__builtin_clzl(u);
#else /* !defined(HAVE___BUILTIN_CLZL) */
UCell s;
n = -(u==0);
#if SIZEOF_CHAR_P == 8
s = (u>0xffffffff) ? 32 : 0; n |= s; u >>= s;
#endif
s = (u>0xffff)     ? 16 : 0; n |= s; u >>= s;
s = (u>0xff)       ?  8 : 0; n |= s; u >>= s;
s = (u>0xf)        ?  4 : 0; n |= s; u >>= s;
s = (u>0x3)        ?  2 : 0; n |= s; u >>= s;
s = (u>0x1)        ?  1 : 0; n |= s;
#endif /* !defined(HAVE___BUILTIN_CLZL) */

u8@+?  ( c_addr u -- c_addr1 urest utfcp ) gforth-internal u8_fetch_plus_query
""@i{utfcp} is the decoded UTF-8 codepoint (@code{$FFFD} if invalid); @i{c_addr1 urest} is the rest of the string.""
DCell d1=utf8_fetch_plus(c_addr, u);
UCell u1 = DLO(d1);
c_addr1 = c_addr+u1;
urest = u-u1;
utfcp = DHI(d1);

\g atomic

!@ ( u1 a_addr -- u2 )	gforth-experimental store_fetch
""load @var{u2} from @var{a_addr}, and store @var{u1} there, as atomic operation""
#ifdef HAS_ATOMIC
u2 = __atomic_exchange_n(a_addr, u1, __ATOMIC_SEQ_CST);
#elif defined(HAS_SYNC)
u2 = __sync_lock_test_and_set(a_addr, u1);
#else
u2 = *a_addr;
*a_addr = u1;
#endif

+!@ ( u1 a_addr -- u2 )	gforth-experimental add_store_fetch
""load @var{u2} from @var{a_addr}, and increment this location by @var{u1}, as atomic operation""
#ifdef HAS_ATOMIC
u2 = __atomic_fetch_add(a_addr, u1, __ATOMIC_SEQ_CST);
#elif defined(HAS_SYNC)
u2 = __sync_fetch_and_add(a_addr, u1);
#else
u2 = *a_addr;
*a_addr += u1;
#endif

?!@ ( unew uold a_addr -- uprev )	gforth-experimental question_store_fetch
""load @var{uprev} from @var{a_addr}, compare it to @var{uold}, and if equal, store @var{unew} there, as atomic operation""
#ifdef HAS_ATOMIC
uprev = uold;
__atomic_compare_exchange_n(a_addr, &uprev, unew, 0,
			    __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
#elif defined(HAS_SYNC)
uprev = __sync_val_compare_and_swap(a_addr, uold, unew);
#else
uprev = *a_addr;
if(*a_addr == uold) *a_addr = unew;
#endif

barrier ( -- ) gforth-experimental
""All memory operations before the barrier are performed
before any memory operation after the barrier.""
#ifdef HAS_ATOMIC
__atomic_thread_fence(__ATOMIC_RELEASE);
#elif defined(HAS_SYNC)
__sync_synchronize();
#endif

\g peephole

\+peephole

forget-dyncode3 ( a_tc -- f ) gforth-internal forget_dyncode3
f = forget_dyncode3((Label *)a_tc);

decompile-prim3 ( a_tc -- useqlen ustart uend c_addr u nlen ) gforth-internal decompile_prim3
""a_tc is a threaded-code address; the contents of the cell at a_tc is
the code address of machine code of nlen bytes, corresponding to
the primitive or primitive sequence with the name(s) c_addr u, with
start state ustart and end state uend, and useqlen basic primitives in
the sequence.  If a_tc does not point to a dynamically-compiled primitive,
useqlen is 0.  If there is no primitive for a_tc, nlen is negative.""
DynamicInfo *di = decompile_prim3((Label *)a_tc);
const char *s = prim_names[di->prim];
useqlen = di->seqlen;
ustart = state_map(di->start_state);
uend = state_map(di->end_state);
c_addr = (Address)s;
u = strlen(s);
nlen = di->length;

@decompile-prim ( a_addr -- w ) gforth-internal fetch_decompile_prim
""w is the cell stored at a_addr, except if the cell at a_addr points to
dynamically generated native code or a static superinstruction; in that case
w is the static code address of the primitive at a_addr, i.e, what you would
get with neither dynamic native code generation nor static superinstructions.""
w = (Cell)fetch_decompile_prim(a_addr);

tag-offsets ( -- a_addr ) gforth-internal tag_offsets
extern Cell groups[32];
a_addr = groups;

compile-prims ( a_addr_code u c_addr_abits c_addr_tbits -- ) gforth-internal compile_prims
gforth_compile_range(a_addr_code, u, c_addr_abits, c_addr_tbits);

\+

\g primitive_centric

\ primitives for primitive-centric code
\ another one is does-exec

abi-call	( #a_callee ... -- ... ) gforth-internal abi_call
/* primitive for compiled ABI-CODE words */
abifunc *f = (abifunc *)a_callee;
Float *fp_mem = fp;
sp = (*f)(sp, &fp_mem);
fp = fp_mem;

;abi-code-exec ( #a_cfa ... -- ... ) gforth-internal semi_abi_code_exec
/* primitive for performing ;ABI-CODE words */
Float *fp_mem = fp;
semiabifunc *f = (semiabifunc *)EXTRA_CODE(a_cfa);
Address body = (Address)PFA(a_cfa);
sp = (*f)(sp, &fp_mem, body);
fp = fp_mem;

lit-execute	( #a_addr -- )	new	lit_execute
/* for ;code and code words; a static superinstruction would be more general, 
   but VM_JUMP is currently not supported there */
ip=IP;
SUPER_END;
VM_JUMP(EXEC1((Xt)a_addr));

\g object_pointer

\+objects

>o ( c_addr -- r:c_old )	new	to_o
""Set the current object to @var{c_addr}, the previous current object is pushed to the return stack""
c_old = op;
op = c_addr;

o> ( r:c_addr -- )		new	o_restore
""Restore the previous current object from the return stack""
op = c_addr;

o#exec	( #w -- )		new	o_lit_exec
""method invocation, use index -1 of current op as vtable""
ip=IP;
SUPER_END;
VM_JUMP(EXEC1(((Xt**)op)[-1][w]));

x#exec	( c_addr #w -- c_addr )		new	x_lit_exec
""method invocation using the stack""
#ifdef DEBUG
	   debugp(stderr,"%08lx: x#exec %08lx %04lx\n",(Cell)ip,(Cell)c_addr,(Cell)w);
#endif
ip=IP;
SUPER_END;
VM_JUMP(EXEC1(((Xt**)c_addr)[-1][w]));

u#exec	( #n #w -- )		new	u_lit_exec
""method invocation using a user address as current object""
ip=IP;
SUPER_END;
VM_JUMP(EXEC1((*(Xt***)(((Address)up)+n))[-1][w]));

u#+	( #n #w -- c_addr )	new	u_lit_plus
""instance variable using a user address as current object""
c_addr = (*(Address*)(((Address)up)+n))+w;

up@    ( -- a_addr )	new	up_fetch
""@i{Addr} is the start of the user area of the current task (@i{addr} also
serves as the @i{task} identifier of the current task).""
a_addr = (Cell*)up;

o      ( -- a_addr )	new	o
a_addr = (Cell*)op;

o+      ( n -- c_addr )	new	o_plus
c_addr = ((Char*)op)+n;

!o+      ( u n -- )	new	store_o_plus
*(Cell*)(((Char*)op)+n) = u;

@o+      ( n -- u )	new	fetch_o_plus
u = *(Cell*)(((Char*)op)+n);

sf!o+      ( r n -- )	new	sf_store_o_plus
*(SFloat*)(((Char*)op)+n) = r;

sf@o+      ( n -- r )	new	sf_fetch_o_plus
r = *(SFloat*)(((Char*)op)+n);

o0 ( -- sf_addr )	gforth-internal	o_0
#line 3571
sf_addr = ((SFloat *)op)+0;
#line 3571

#line 3571
o1 ( -- sf_addr )	gforth-internal	o_1
#line 3571
sf_addr = ((SFloat *)op)+1;
#line 3571

#line 3571
o2 ( -- sf_addr )	gforth-internal	o_2
#line 3571
sf_addr = ((SFloat *)op)+2;
#line 3571

#line 3571
o3 ( -- sf_addr )	gforth-internal	o_3
#line 3571
sf_addr = ((SFloat *)op)+3;
#line 3571

#line 3571
o4 ( -- sf_addr )	gforth-internal	o_4
#line 3571
sf_addr = ((SFloat *)op)+4;
#line 3571

#line 3571
o5 ( -- sf_addr )	gforth-internal	o_5
#line 3571
sf_addr = ((SFloat *)op)+5;
#line 3571

#line 3571
o6 ( -- sf_addr )	gforth-internal	o_6
#line 3571
sf_addr = ((SFloat *)op)+6;
#line 3571

#line 3571
o7 ( -- sf_addr )	gforth-internal	o_7
#line 3571
sf_addr = ((SFloat *)op)+7;
#line 3571

#line 3571
o8 ( -- sf_addr )	gforth-internal	o_8
#line 3571
sf_addr = ((SFloat *)op)+8;
#line 3571

#line 3571
o9 ( -- sf_addr )	gforth-internal	o_9
#line 3571
sf_addr = ((SFloat *)op)+9;
#line 3571

#line 3571
o10 ( -- sf_addr )	gforth-internal	o_10
#line 3571
sf_addr = ((SFloat *)op)+10;
#line 3571

#line 3571
o11 ( -- sf_addr )	gforth-internal	o_11
#line 3571
sf_addr = ((SFloat *)op)+11;
#line 3571

#line 3571
o12 ( -- sf_addr )	gforth-internal	o_12
#line 3571
sf_addr = ((SFloat *)op)+12;
#line 3571

#line 3571
o13 ( -- sf_addr )	gforth-internal	o_13
#line 3571
sf_addr = ((SFloat *)op)+13;
#line 3571

#line 3571
o14 ( -- sf_addr )	gforth-internal	o_14
#line 3571
sf_addr = ((SFloat *)op)+14;
#line 3571

#line 3571
o15 ( -- sf_addr )	gforth-internal	o_15
#line 3571
sf_addr = ((SFloat *)op)+15;
#line 3571

#line 3571
o16 ( -- sf_addr )	gforth-internal	o_16
#line 3571
sf_addr = ((SFloat *)op)+16;
#line 3571

#line 3571
o17 ( -- sf_addr )	gforth-internal	o_17
#line 3571
sf_addr = ((SFloat *)op)+17;
#line 3571

#line 3571
o18 ( -- sf_addr )	gforth-internal	o_18
#line 3571
sf_addr = ((SFloat *)op)+18;
#line 3571

#line 3571
o19 ( -- sf_addr )	gforth-internal	o_19
#line 3571
sf_addr = ((SFloat *)op)+19;
#line 3571

#line 3571
o20 ( -- sf_addr )	gforth-internal	o_20
#line 3571
sf_addr = ((SFloat *)op)+20;
#line 3571

#line 3571
o21 ( -- sf_addr )	gforth-internal	o_21
#line 3571
sf_addr = ((SFloat *)op)+21;
#line 3571

#line 3571
o22 ( -- sf_addr )	gforth-internal	o_22
#line 3571
sf_addr = ((SFloat *)op)+22;
#line 3571

#line 3571
o23 ( -- sf_addr )	gforth-internal	o_23
#line 3571
sf_addr = ((SFloat *)op)+23;
#line 3571

#line 3571
o24 ( -- sf_addr )	gforth-internal	o_24
#line 3571
sf_addr = ((SFloat *)op)+24;
#line 3571

#line 3571
o25 ( -- sf_addr )	gforth-internal	o_25
#line 3571
sf_addr = ((SFloat *)op)+25;
#line 3571

#line 3571
o26 ( -- sf_addr )	gforth-internal	o_26
#line 3571
sf_addr = ((SFloat *)op)+26;
#line 3571

#line 3571
o27 ( -- sf_addr )	gforth-internal	o_27
#line 3571
sf_addr = ((SFloat *)op)+27;
#line 3571

#line 3571
o28 ( -- sf_addr )	gforth-internal	o_28
#line 3571
sf_addr = ((SFloat *)op)+28;
#line 3571

#line 3571
o29 ( -- sf_addr )	gforth-internal	o_29
#line 3571
sf_addr = ((SFloat *)op)+29;
#line 3571

#line 3571
o30 ( -- sf_addr )	gforth-internal	o_30
#line 3571
sf_addr = ((SFloat *)op)+30;
#line 3571

#line 3571
o31 ( -- sf_addr )	gforth-internal	o_31
#line 3571
sf_addr = ((SFloat *)op)+31;
#line 3571



!o0 ( u -- )	gforth-internal	store_o_0
#line 3574
((Cell *)op)[0] = u;
#line 3574

#line 3574
!o1 ( u -- )	gforth-internal	store_o_1
#line 3574
((Cell *)op)[1] = u;
#line 3574

#line 3574
!o2 ( u -- )	gforth-internal	store_o_2
#line 3574
((Cell *)op)[2] = u;
#line 3574

#line 3574
!o3 ( u -- )	gforth-internal	store_o_3
#line 3574
((Cell *)op)[3] = u;
#line 3574

#line 3574
!o4 ( u -- )	gforth-internal	store_o_4
#line 3574
((Cell *)op)[4] = u;
#line 3574

#line 3574
!o5 ( u -- )	gforth-internal	store_o_5
#line 3574
((Cell *)op)[5] = u;
#line 3574

#line 3574
!o6 ( u -- )	gforth-internal	store_o_6
#line 3574
((Cell *)op)[6] = u;
#line 3574

#line 3574
!o7 ( u -- )	gforth-internal	store_o_7
#line 3574
((Cell *)op)[7] = u;
#line 3574

#line 3574
!o8 ( u -- )	gforth-internal	store_o_8
#line 3574
((Cell *)op)[8] = u;
#line 3574

#line 3574
!o9 ( u -- )	gforth-internal	store_o_9
#line 3574
((Cell *)op)[9] = u;
#line 3574

#line 3574
!o10 ( u -- )	gforth-internal	store_o_10
#line 3574
((Cell *)op)[10] = u;
#line 3574

#line 3574
!o11 ( u -- )	gforth-internal	store_o_11
#line 3574
((Cell *)op)[11] = u;
#line 3574

#line 3574
!o12 ( u -- )	gforth-internal	store_o_12
#line 3574
((Cell *)op)[12] = u;
#line 3574

#line 3574
!o13 ( u -- )	gforth-internal	store_o_13
#line 3574
((Cell *)op)[13] = u;
#line 3574

#line 3574
!o14 ( u -- )	gforth-internal	store_o_14
#line 3574
((Cell *)op)[14] = u;
#line 3574

#line 3574
!o15 ( u -- )	gforth-internal	store_o_15
#line 3574
((Cell *)op)[15] = u;
#line 3574



@o0 ( -- u )	gforth-internal	fetch_o_0
#line 3577
u = ((Cell *)op)[0];
#line 3577

#line 3577
@o1 ( -- u )	gforth-internal	fetch_o_1
#line 3577
u = ((Cell *)op)[1];
#line 3577

#line 3577
@o2 ( -- u )	gforth-internal	fetch_o_2
#line 3577
u = ((Cell *)op)[2];
#line 3577

#line 3577
@o3 ( -- u )	gforth-internal	fetch_o_3
#line 3577
u = ((Cell *)op)[3];
#line 3577

#line 3577
@o4 ( -- u )	gforth-internal	fetch_o_4
#line 3577
u = ((Cell *)op)[4];
#line 3577

#line 3577
@o5 ( -- u )	gforth-internal	fetch_o_5
#line 3577
u = ((Cell *)op)[5];
#line 3577

#line 3577
@o6 ( -- u )	gforth-internal	fetch_o_6
#line 3577
u = ((Cell *)op)[6];
#line 3577

#line 3577
@o7 ( -- u )	gforth-internal	fetch_o_7
#line 3577
u = ((Cell *)op)[7];
#line 3577

#line 3577
@o8 ( -- u )	gforth-internal	fetch_o_8
#line 3577
u = ((Cell *)op)[8];
#line 3577

#line 3577
@o9 ( -- u )	gforth-internal	fetch_o_9
#line 3577
u = ((Cell *)op)[9];
#line 3577

#line 3577
@o10 ( -- u )	gforth-internal	fetch_o_10
#line 3577
u = ((Cell *)op)[10];
#line 3577

#line 3577
@o11 ( -- u )	gforth-internal	fetch_o_11
#line 3577
u = ((Cell *)op)[11];
#line 3577

#line 3577
@o12 ( -- u )	gforth-internal	fetch_o_12
#line 3577
u = ((Cell *)op)[12];
#line 3577

#line 3577
@o13 ( -- u )	gforth-internal	fetch_o_13
#line 3577
u = ((Cell *)op)[13];
#line 3577

#line 3577
@o14 ( -- u )	gforth-internal	fetch_o_14
#line 3577
u = ((Cell *)op)[14];
#line 3577

#line 3577
@o15 ( -- u )	gforth-internal	fetch_o_15
#line 3577
u = ((Cell *)op)[15];
#line 3577



sf!o0 ( r -- )	gforth-internal	sf_store_o_0
#line 3580
((SFloat *)op)[0] = r;
#line 3580

#line 3580
sf!o1 ( r -- )	gforth-internal	sf_store_o_1
#line 3580
((SFloat *)op)[1] = r;
#line 3580

#line 3580
sf!o2 ( r -- )	gforth-internal	sf_store_o_2
#line 3580
((SFloat *)op)[2] = r;
#line 3580

#line 3580
sf!o3 ( r -- )	gforth-internal	sf_store_o_3
#line 3580
((SFloat *)op)[3] = r;
#line 3580

#line 3580
sf!o4 ( r -- )	gforth-internal	sf_store_o_4
#line 3580
((SFloat *)op)[4] = r;
#line 3580

#line 3580
sf!o5 ( r -- )	gforth-internal	sf_store_o_5
#line 3580
((SFloat *)op)[5] = r;
#line 3580

#line 3580
sf!o6 ( r -- )	gforth-internal	sf_store_o_6
#line 3580
((SFloat *)op)[6] = r;
#line 3580

#line 3580
sf!o7 ( r -- )	gforth-internal	sf_store_o_7
#line 3580
((SFloat *)op)[7] = r;
#line 3580

#line 3580
sf!o8 ( r -- )	gforth-internal	sf_store_o_8
#line 3580
((SFloat *)op)[8] = r;
#line 3580

#line 3580
sf!o9 ( r -- )	gforth-internal	sf_store_o_9
#line 3580
((SFloat *)op)[9] = r;
#line 3580

#line 3580
sf!o10 ( r -- )	gforth-internal	sf_store_o_10
#line 3580
((SFloat *)op)[10] = r;
#line 3580

#line 3580
sf!o11 ( r -- )	gforth-internal	sf_store_o_11
#line 3580
((SFloat *)op)[11] = r;
#line 3580

#line 3580
sf!o12 ( r -- )	gforth-internal	sf_store_o_12
#line 3580
((SFloat *)op)[12] = r;
#line 3580

#line 3580
sf!o13 ( r -- )	gforth-internal	sf_store_o_13
#line 3580
((SFloat *)op)[13] = r;
#line 3580

#line 3580
sf!o14 ( r -- )	gforth-internal	sf_store_o_14
#line 3580
((SFloat *)op)[14] = r;
#line 3580

#line 3580
sf!o15 ( r -- )	gforth-internal	sf_store_o_15
#line 3580
((SFloat *)op)[15] = r;
#line 3580

#line 3580
sf!o16 ( r -- )	gforth-internal	sf_store_o_16
#line 3580
((SFloat *)op)[16] = r;
#line 3580

#line 3580
sf!o17 ( r -- )	gforth-internal	sf_store_o_17
#line 3580
((SFloat *)op)[17] = r;
#line 3580

#line 3580
sf!o18 ( r -- )	gforth-internal	sf_store_o_18
#line 3580
((SFloat *)op)[18] = r;
#line 3580

#line 3580
sf!o19 ( r -- )	gforth-internal	sf_store_o_19
#line 3580
((SFloat *)op)[19] = r;
#line 3580

#line 3580
sf!o20 ( r -- )	gforth-internal	sf_store_o_20
#line 3580
((SFloat *)op)[20] = r;
#line 3580

#line 3580
sf!o21 ( r -- )	gforth-internal	sf_store_o_21
#line 3580
((SFloat *)op)[21] = r;
#line 3580

#line 3580
sf!o22 ( r -- )	gforth-internal	sf_store_o_22
#line 3580
((SFloat *)op)[22] = r;
#line 3580

#line 3580
sf!o23 ( r -- )	gforth-internal	sf_store_o_23
#line 3580
((SFloat *)op)[23] = r;
#line 3580

#line 3580
sf!o24 ( r -- )	gforth-internal	sf_store_o_24
#line 3580
((SFloat *)op)[24] = r;
#line 3580

#line 3580
sf!o25 ( r -- )	gforth-internal	sf_store_o_25
#line 3580
((SFloat *)op)[25] = r;
#line 3580

#line 3580
sf!o26 ( r -- )	gforth-internal	sf_store_o_26
#line 3580
((SFloat *)op)[26] = r;
#line 3580

#line 3580
sf!o27 ( r -- )	gforth-internal	sf_store_o_27
#line 3580
((SFloat *)op)[27] = r;
#line 3580

#line 3580
sf!o28 ( r -- )	gforth-internal	sf_store_o_28
#line 3580
((SFloat *)op)[28] = r;
#line 3580

#line 3580
sf!o29 ( r -- )	gforth-internal	sf_store_o_29
#line 3580
((SFloat *)op)[29] = r;
#line 3580

#line 3580
sf!o30 ( r -- )	gforth-internal	sf_store_o_30
#line 3580
((SFloat *)op)[30] = r;
#line 3580

#line 3580
sf!o31 ( r -- )	gforth-internal	sf_store_o_31
#line 3580
((SFloat *)op)[31] = r;
#line 3580



sf@o0 ( -- r )	gforth-internal	sf_fetch_o_0
#line 3583
r = ((SFloat *)op)[0];
#line 3583

#line 3583
sf@o1 ( -- r )	gforth-internal	sf_fetch_o_1
#line 3583
r = ((SFloat *)op)[1];
#line 3583

#line 3583
sf@o2 ( -- r )	gforth-internal	sf_fetch_o_2
#line 3583
r = ((SFloat *)op)[2];
#line 3583

#line 3583
sf@o3 ( -- r )	gforth-internal	sf_fetch_o_3
#line 3583
r = ((SFloat *)op)[3];
#line 3583

#line 3583
sf@o4 ( -- r )	gforth-internal	sf_fetch_o_4
#line 3583
r = ((SFloat *)op)[4];
#line 3583

#line 3583
sf@o5 ( -- r )	gforth-internal	sf_fetch_o_5
#line 3583
r = ((SFloat *)op)[5];
#line 3583

#line 3583
sf@o6 ( -- r )	gforth-internal	sf_fetch_o_6
#line 3583
r = ((SFloat *)op)[6];
#line 3583

#line 3583
sf@o7 ( -- r )	gforth-internal	sf_fetch_o_7
#line 3583
r = ((SFloat *)op)[7];
#line 3583

#line 3583
sf@o8 ( -- r )	gforth-internal	sf_fetch_o_8
#line 3583
r = ((SFloat *)op)[8];
#line 3583

#line 3583
sf@o9 ( -- r )	gforth-internal	sf_fetch_o_9
#line 3583
r = ((SFloat *)op)[9];
#line 3583

#line 3583
sf@o10 ( -- r )	gforth-internal	sf_fetch_o_10
#line 3583
r = ((SFloat *)op)[10];
#line 3583

#line 3583
sf@o11 ( -- r )	gforth-internal	sf_fetch_o_11
#line 3583
r = ((SFloat *)op)[11];
#line 3583

#line 3583
sf@o12 ( -- r )	gforth-internal	sf_fetch_o_12
#line 3583
r = ((SFloat *)op)[12];
#line 3583

#line 3583
sf@o13 ( -- r )	gforth-internal	sf_fetch_o_13
#line 3583
r = ((SFloat *)op)[13];
#line 3583

#line 3583
sf@o14 ( -- r )	gforth-internal	sf_fetch_o_14
#line 3583
r = ((SFloat *)op)[14];
#line 3583

#line 3583
sf@o15 ( -- r )	gforth-internal	sf_fetch_o_15
#line 3583
r = ((SFloat *)op)[15];
#line 3583

#line 3583
sf@o16 ( -- r )	gforth-internal	sf_fetch_o_16
#line 3583
r = ((SFloat *)op)[16];
#line 3583

#line 3583
sf@o17 ( -- r )	gforth-internal	sf_fetch_o_17
#line 3583
r = ((SFloat *)op)[17];
#line 3583

#line 3583
sf@o18 ( -- r )	gforth-internal	sf_fetch_o_18
#line 3583
r = ((SFloat *)op)[18];
#line 3583

#line 3583
sf@o19 ( -- r )	gforth-internal	sf_fetch_o_19
#line 3583
r = ((SFloat *)op)[19];
#line 3583

#line 3583
sf@o20 ( -- r )	gforth-internal	sf_fetch_o_20
#line 3583
r = ((SFloat *)op)[20];
#line 3583

#line 3583
sf@o21 ( -- r )	gforth-internal	sf_fetch_o_21
#line 3583
r = ((SFloat *)op)[21];
#line 3583

#line 3583
sf@o22 ( -- r )	gforth-internal	sf_fetch_o_22
#line 3583
r = ((SFloat *)op)[22];
#line 3583

#line 3583
sf@o23 ( -- r )	gforth-internal	sf_fetch_o_23
#line 3583
r = ((SFloat *)op)[23];
#line 3583

#line 3583
sf@o24 ( -- r )	gforth-internal	sf_fetch_o_24
#line 3583
r = ((SFloat *)op)[24];
#line 3583

#line 3583
sf@o25 ( -- r )	gforth-internal	sf_fetch_o_25
#line 3583
r = ((SFloat *)op)[25];
#line 3583

#line 3583
sf@o26 ( -- r )	gforth-internal	sf_fetch_o_26
#line 3583
r = ((SFloat *)op)[26];
#line 3583

#line 3583
sf@o27 ( -- r )	gforth-internal	sf_fetch_o_27
#line 3583
r = ((SFloat *)op)[27];
#line 3583

#line 3583
sf@o28 ( -- r )	gforth-internal	sf_fetch_o_28
#line 3583
r = ((SFloat *)op)[28];
#line 3583

#line 3583
sf@o29 ( -- r )	gforth-internal	sf_fetch_o_29
#line 3583
r = ((SFloat *)op)[29];
#line 3583

#line 3583
sf@o30 ( -- r )	gforth-internal	sf_fetch_o_30
#line 3583
r = ((SFloat *)op)[30];
#line 3583

#line 3583
sf@o31 ( -- r )	gforth-internal	sf_fetch_o_31
#line 3583
r = ((SFloat *)op)[31];
#line 3583



\+
\g static_super

#line 3590


\g end