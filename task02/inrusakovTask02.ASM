;Rusakov Ivan BSE194 Var.2
format PE console

entry start

include 'win32a.inc'
;----------------------------------------------Main Variables------------------------------------------
section '.data' data readable writeable

        strVecSize db 'Enter size of array A: ', 0
        strIncorSize db 'Wrong size of array = %d', 10, 0

        strElemA db 'A[%d]: ', 0
        strScanInt db '%d', 0
        strVecElemAOut db 'A[%d] = %d  ', 0
        strVecElemBOut db 'B[%d] = %d  ', 0
        strResultA db 'Origin Array A: ', 0
        strResultB db 'Modified Array B: ', 0
        strNone db 'Empty!',0
        strResultBEnd db ')', 10, 0
        endl db '', 10, 0


        vec_sizeA dd 0                  ;A array size
        vecA rd 100                     ;A array

        vec_sizeB dd 0                  ;B array size
        vecB rd 100                     ;B array

        i dd ?                          ;Iterator

        tmpA dd ?
        tmpB dd ?
        first_element dd 0
        second_element dd 0
        k dd ?

section '.code' code readable executable
;----------------------------------------------Main Code part------------------------------------------
start:
;Input string()
      push strVecSize
      call [printf]
      add esp, 4
;Input A array size()
      push vec_sizeA
      push strScanInt
      call [scanf]
      add esp, 8

;Filling A array()
      call initializeArray_A     ;Initialization of A array
      call enterElemsArray_A     ;Input A elements

;Filling B array with elemnts of A array()
      call first_iteration       ;Calculating amount of elems in B array
      call enteringElementsB     ;Moving correct A elements to B
      cinvoke printf, endl

;A outputing()
      call outputingElementsA    ;A output
      cinvoke printf, endl

;B outputing()
      call outputingElementsB    ;B output

finish:
      call [getch]
      push 0
      call [ExitProcess]


;------------------------------------Filling A array()----------------------------------
initializeArray_A:
      mov eax, [vec_sizeA]

      cmp eax, -1
      jg getVector

      ;If size of vector is incorrect
      push [vec_sizeA]
      push strIncorSize
      call [printf]
      jmp finish ; end

      getVector: ; Init array
                xor ecx, ecx    ; ecx = 0
                mov ebx, vecA   ; ebx = &vec
ret

enterElemsArray_A:
      mov eax, [vec_sizeA]
      mov [k], eax
      dec [k]

      VectorLoop:
                 mov [tmpA], ebx
                 cmp ecx, [vec_sizeA]
                 jge endInputVector

                 ; Input element
                 mov [i], ecx
                 push ecx
                 push strElemA
                 call [printf]
                 add esp, 8

                 ; push ebx
                 push [tmpA]
                 push strScanInt
                 call [scanf]
                 add esp, 8

                 cmp [i], 0
                 je firstElement
                 jmp endFirstElement

                 firstElement:
                        mov eax, [ebx]
                        mov [first_element], eax

                 endFirstElement:
                 mov eax, [k]
                 cmp [i], eax
                 je secondElement
                 jmp endSecondElement

                 secondElement:
                 mov eax, [ebx]
                 mov [second_element], eax
                 endSecondElement:
                         mov ecx, [i]
                         inc ecx
                         mov ebx, [tmpA]
                         add ebx, 4
                         jmp VectorLoop ; end

                 endInputVector:
ret

;------------------------------------Filling B array()----------------------------------
first_iteration:
      xor ecx, ecx
      mov edx, vecB
      mov ebx, vecA

      mov eax, [vec_sizeA]
      mov [vec_sizeB], eax

      VectorLoop2:
                  mov [tmpA], ebx
                  cmp ecx, [vec_sizeA]
                  jge endInputVector2      ; to end of loop

                  mov [i], ecx
                  mov eax, [ebx]
                  cmp eax, [first_element]
                  je flagOfComparison1
                  jmp flagOfComparison2

                  flagOfComparison1:
                        dec [vec_sizeB]
                        jmp comparisonExit

                  flagOfComparison2:
                        cmp eax, [second_element]
                        je decrementation
                        jmp comparisonExit
                        decrementation:
                                dec [vec_sizeB]
                                jmp comparisonExit

                  comparisonExit:
                        mov ecx, [i]
                        inc ecx
                        mov ebx, [tmpA]
                        add ebx, 4
                        jmp VectorLoop2 ; end

                  endInputVector2:
ret

enteringElementsB:
      xor ecx, ecx     ;ecx = 0
      mov edx, vecB
      mov ebx, vecA

      VectorLoop3:
                mov [tmpB], edx
                mov [tmpA], ebx
                cmp ecx, [vec_sizeA]
                jge endInputVector3

                ; Input element
                mov [i], ecx
                mov eax, [ebx]
                cmp eax, [first_element]
                jne flagOfComparison11
                jmp comparisonExit2

                flagOfComparison11:
                        cmp eax, [second_element]
                        jne decrementation3
                        jmp comparisonExit2

                decrementation3:
                        mov dword [edx], eax
                        mov edx, [tmpB]
                        add edx, 4
                        jmp comparisonExit2

                comparisonExit2:
                        mov ecx, [i]
                        inc ecx
                        mov ebx, [tmpA]
                        add ebx, 4
                        jmp VectorLoop3 ; end
      endInputVector3:
ret


;------------------------------------Outputing A array()----------------------------------
outputingElementsA:
      cinvoke printf, strResultA

      xor ecx, ecx   ;ecx = 0
      mov ebx, vecA
      cmp ecx, [vec_sizeA]
      je aIsEmpty

      putVecLoop4:
                mov [tmpA], ebx
                cmp ecx, [vec_sizeA]
                je endOutputVector4
                mov [i], ecx

                ; output element
                cinvoke printf, strVecElemAOut, ecx, dword [ebx]

                mov ecx, [i]
                inc ecx
                mov ebx, [tmpA]
                add ebx, 4
                jmp putVecLoop4

      aIsEmpty:
      cinvoke printf, strNone
      jmp endOutputVector4
      endOutputVector4:
ret

;------------------------------------Outputing B array()----------------------------------
outputingElementsB:
      cinvoke printf, strResultB

      xor ecx, ecx        ;ecx = 0
      mov edx, vecB
      cmp ecx, [vec_sizeB]
      je bIsEmpty


      putVecLoop5:

                mov [tmpB], edx
                cmp ecx, [vec_sizeB]
                je endOutputVector5
                mov [i], ecx

                ; output element
                cinvoke printf, strVecElemBOut, ecx, dword [edx]

                mov ecx, [i]
                inc ecx
                mov edx, [tmpB]
                add edx, 4
                jmp putVecLoop5
      bIsEmpty:
      cinvoke printf, strNone
      jmp endOutputVector5

      endOutputVector5:
ret


;------------------------------------Include Section----------------------------------
section '.idata' import data readable

library kernel, 'kernel32.dll',\
      msvcrt, 'msvcrt.dll',\
      user32,'USER32.DLL'
      include 'api\user32.inc'
      include 'api\kernel32.inc'

import kernel,\
      ExitProcess, 'ExitProcess',\
      HeapCreate,'HeapCreate',\
      HeapAlloc,'HeapAlloc'
      include 'api\kernel32.inc'

import msvcrt,\
      printf, 'printf',\
      scanf, 'scanf',\
      getch, '_getch'