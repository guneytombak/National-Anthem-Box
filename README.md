# National Anthem Box
Author: Guney Tombak (guneytombak@gmail.com)  
Professor: Dr. Şenol Mutlu 

Implemented for the final project of Digital System Design (EE 240) at Boğaziçi University, June 2017

Coded on a Nexys 3 FPGA Board, displays the flag of one of four countries (Germany, Russia, France, and Romania) on a VGA screen and plays their national anthems on a buzzer. 
The frequencies are generated using square waves to compose music and coded a VGA driver to display country flags. 
Additionally, the program has a 13 notes (C4 to C5) organ.

## Details

Main file: `national_anthem_box.vhd`  

For display: `ee240_vgadriver.vhd`  
For sound:  `note_sys.vhd`
