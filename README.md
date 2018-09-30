# National-Anthem-Box
Coded on a Nexys 3 FPGA Board, displays one of four countries’ (Germany, Russia, France and Romania) flags on a VGA screen and plays their national anthems on a buzzer. Generated frequencies using square waves to compose music and coded a VGA driver to display country flags. Additionally program has a 13 notes (C4 to C5) organ in itself.

------------------

Main file is national_anthem_box.vhd and it starts two subfiles:

For display: ee240_vgadriver.vhd 

For sound: note_sys.vhd 
