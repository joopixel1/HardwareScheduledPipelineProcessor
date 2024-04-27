.data
.text
.globl main
main:
   # initialize registers $1 - $31 with positive non-zero value using addi which was first function verified
   addi $1, $0, 0x7FFFFFFF 
   addi $2, $0, 0x7FFFFFFF 
   addi $3, $0, 0x7FFFFFFF 
   addi $4, $0, 0x7FFFFFFF 
   addi $5, $0, 0x7FFFFFFF 
   addi $6, $0, 0x7FFFFFFF 
   addi $7, $0, 0x7FFFFFFF 
   addi $8, $0, 0x7FFFFFFF 
   addi $9, $0, 0x7FFFFFFF 
   addi $10, $0, 0x7FFFFFFF 
   addi $11, $0, 0x7FFFFFFF 
   addi $12, $0, 0x7FFFFFFF 
   addi $13, $0, 0x7FFFFFFF 
   addi $14, $0, 0x7FFFFFFF 
   addi $15, $0, 0x7FFFFFFF 
   addi $16, $0, 0x7FFFFFFF 
   addi $17, $0, 0x7FFFFFFF 
   addi $18, $0, 0x7FFFFFFF 
   addi $19, $0, 0x7FFFFFFF 
   addi $20, $0, 0x7FFFFFFF 
   addi $21, $0, 0x7FFFFFFF 
   addi $22, $0, 0x7FFFFFFF 
   addi $23, $0, 0x7FFFFFFF 
   addi $24, $0, 0x7FFFFFFF 
   addi $25, $0, 0x7FFFFFFF 
   addi $26, $0, 0x7FFFFFFF 
   addi $27, $0, 0x7FFFFFFF 
   addi $28, $0, 0x7FFFFFFF 
   addi $29, $0, 0x7FFFFFFF 
   addi $30, $0, 0x7FFFFFFF 
   addi $31, $0, 0x7FFFFFFF 
   # register 1 is initialized last as addi uses register 1 as a temporary register
   addi $1, $0, 0x7FFFFFFF 
   #End initialization   
   
   #Start test
   # each register will be right sifted register number of bits
   # confirm that each register still holds a positive value
   sra $1, $1, 1
   sra $2, $2, 2
   sra $3, $3, 3
   sra $4, $4, 4
   sra $5, $5, 5
   sra $6, $6, 6
   sra $7, $7, 7
   sra $8, $8, 8
   sra $9, $9, 9
   sra $10, $10, 10
   sra $11, $11, 11
   sra $12, $12, 12
   sra $13, $13, 13
   sra $14, $14, 14
   sra $15, $15, 15
   sra $16, $16, 16
   sra $17, $17, 17
   sra $18, $18, 18
   sra $19, $19, 19
   sra $20, $20, 20
   sra $21, $21, 21
   sra $22, $22, 22
   sra $23, $23, 23
   sra $24, $24, 24
   sra $25, $25, 25
   sra $26, $26, 26
   sra $27, $27, 27
   sra $28, $28, 28
   sra $29, $29, 29
   sra $30, $30, 30
   sra $31, $31, 31
   #End test

   # Exit program
   halt
