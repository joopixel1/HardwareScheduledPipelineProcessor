addi $16, $0, 0xf0f0
addi $19, $0, 0xf0f0
addi $17, $0, 0x0f0f

beq $16, $19, Lal
li $1, 0xffffffff

Lal:
beq $16, $17, Te
li $2, 0xffffffff

Te:
bne $16, $19, Un
li $3, 0xffffffff

Un:
bne $16, $17, Jus
li $4, 0xffffffff


Jus:
slti $6, $0, 0x00ff
slti $7, $0, 0x0ff0
j T

funct:
jr $31
 
T:
jal funct
li $5, 0xffffffff


halt