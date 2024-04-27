addiu  $1,  $0,  1 		
addiu  $2,  $0,  2		
addiu  $3,  $0,  3		
addiu  $4,  $0,  4	
add    $4, $1, $4
sub    $5, $4, $2
or     $7, $1, $2
sll    $2, $7, 0x0004 
sll    $3, $2, 0x0004 
sra    $2, $2, 0x0001 
sra    $3, $3, 0x0004 

halt