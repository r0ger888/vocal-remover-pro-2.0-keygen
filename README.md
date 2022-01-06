Alright, here's the solution on MD5-keygenning Vocal Remover Pro 2.0:

- in the app, i've found 4 hardcored strings which are VOCALREMOVERPRO , ABBY , AUDI RS5 and PORSCHE CAYMAN .
- in masm32, just got the mail string through the unset variable with GetDlgItemText (addr Mailbuff)
- as soon as the app requires to have the mail string lowercase only , just added the CharLower function so it can generate serials with MD5 encryption for the mail string with lowercase chars only;
- i've encrypted each of these four hardcored strings with MD5 by initiating different variables and by MD5Init,MD5Update and MD5Final functions.
- then i've converted each of these encrypted messages from hexadecimal values to proper chars in the serial field. (invoke Hex2ch,addr MD5Digest,addr MD5Mailhash1,16)
for VOCALREMOVERPRO and AUDI RS5 , the MD5 encryption should be initiated from the first position of the mail string only. (invoke lstrcpyn,addr part1,addr MD5Mailhash1,5) and as for ABBY and PORSCHE CAYMAN , i've initiated the MD5 encryption from the 28th position of the mail string. (invoke lstrcpyn,addr part2,addr MD5Mailhash2+28,5)
- and the serial should have four chars (from the MD5-encrypted strings) each of the four parts of serial .
- plus , after i've built the whole MD5 serial with lstrcat and applied on the serial field, created a subroutine which cleans the memory out of the MD5-generated serials with RtlZeroMemory on all the variables i've used for MD5 encryptions.
and yeah,sry if it looks more complex (and a bit messy).. it's just my first attempt on MD5 keygenning .
