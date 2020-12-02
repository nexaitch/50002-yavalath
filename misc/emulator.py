import array
#import keyboard
import sys
#import click
import os

import pygame, time
from pygame.locals import *

input_ = 0
submit = 29
player_0 = 1
player_1 = 10
selected = 19
turn = 28
valid = 32
working = 41

indices = {
    0: "input",
    29: "submit",
    1: "player_0",
    10: "player_1",
    19: "selected",
    28: "turn",
    32: "valid",
    41: "working"
    }

registers = [0] * 7
memory = [0] * 64

pc = 0

bitmask = 0xFFFF

def sext(n, width):
    if (n >= (1<<(width-1))): n -= (1<<width)
    return n

def get_register(n):
    if (n==7): return 0
    else: return registers[n]

def set_register(n, v):
    #print("R"+str(n), "<-", v)
    if (n<=6): registers[n] = v & bitmask

def add(ra, rb, rc):
    s = get_register(ra) + get_register(rb)
    set_register(rc, s)

def addc(ra, c, rc):
    s = get_register(ra) + c
    set_register(rc, s)

def and_(ra, rb, rc):
    s = get_register(ra) & get_register(rb)
    set_register(rc, s)
    
def shl(ra, rb, rc):
    s = get_register(ra) << get_register(rb)
    set_register(rc, s)

def shrc(ra, c, rc):
    s = get_register(ra) >> c
    set_register(rc, s)

def bf(ra, c):
    global pc
    if(get_register(ra) == 0):
        pc += c

def ld(ra, c, rc):
    addr = get_register(ra) + c
    set_register(rc, memory[addr & 63])

def st(ra, c, rc):
    c &= 63
    addr = get_register(ra) + c
    #print("storing", sext(get_register(rc), 16), "into", "{}[{}]".format(indices[c], get_register(ra)))
    memory[addr & 63] = get_register(rc)

def print_regs(*args):
    for i, v in enumerate(registers):
        print("R",str(i),": ",v,sep='')
    
def op(n, f):
    ra = (n>>6) & 7
    rb = (n>>3) & 7
    rc = (n>>9) & 7
    #print("R"+str(ra),"R"+str(rb),"R"+str(rc))
    f(ra, rb, rc)

def opc(n, f):
    ra = (n>>6) & 7
    c = (n) & 63
    c = sext(c, 6)
    rc = (n>>9) & 7
    #print("R"+str(ra),c,"R"+str(rc))
    f(ra, c, rc)

def branchop(n, f):
    rc = (n>>9) & 7
    c = n & 0x1FF
    c = sext(c,9)
    #print("R"+str(rc),c)
    f(rc, c)

types = [0, op, op, op, opc, opc, opc, branchop, opc, op]
fns = [0, add, shl, and_, addc, ld, st, bf, shrc, print_regs]

def read_instruction(i):
    opcode = (i >> 12) & 0xF
    #print(pc, fns[opcode].__name__, end=" ")
    types[opcode](i, fns[opcode])

valid_ = [0x1F, 0x3F, 0x7F, 0xFF, 0x1FF,
         0x1FE, 0x1FC, 0x1F8, 0x1F0]

for i, v in enumerate(valid_):
    memory[valid + i] = v

b = array.array("h")
filename = "yavalath.bin"
with open(filename, "rb") as f:
    b.fromfile(f, os.stat(filename).st_size//2)
if sys.byteorder != "little":
    b.byteswap()



ins = {pygame.K_h: 0b0110,
       pygame.K_l: 0b1110,
       pygame.K_y: 0b0101,
       pygame.K_u: 0b1001,
       pygame.K_b: 0b1011,
       pygame.K_n: 0b1111}

pygame.init()
screen = pygame.display.set_mode((640, 480))
pygame.display.set_caption('Pygame Keyboard Test')
pygame.mouse.set_visible(0)

ystep = 40
xstep = 40
x0 = xstep * 4
drift = xstep/2

def is_in(loc, row, col):
    return memory[loc+row] & (1<<col)

while True:

    for event in pygame.event.get():
      if event.type == pygame.KEYDOWN:
        if event.key in ins:
             #print ("key pressed", event.key)
             memory[input_] = ins[event.key]
        elif event.key == pygame.K_j:
            memory[submit] = 1
      elif event.type == pygame.QUIT:
        pygame.quit()
        exit(0)
    ##print(pc)
    inst = b[pc]
    ##print("{:016b}".format(inst))
    read_instruction(inst)
    #print(registers)

    pc += 1

    # output
    screen.fill((0,0,0))
    for r in range(9):
        for c in range(9):
            x = x0 - r*drift + c*xstep
            y = r*ystep
            if is_in(valid,r,c):
                pygame.draw.rect(screen, (200,200,200), pygame.Rect(x, y, xstep/2, ystep/2))
            if is_in(player_0,r,c):
                pygame.draw.rect(screen, (255,0,0), pygame.Rect(x, y, xstep/2, ystep/2))
            if is_in(player_1,r,c):
                pygame.draw.rect(screen, (0,0,255), pygame.Rect(x, y, xstep/2, ystep/2))
            if is_in(selected,r,c):
                pygame.draw.rect(screen, (255,0,255), pygame.Rect(x, y, xstep/4, ystep/4))
                
            
    
    pygame.display.flip()
    #time.sleep(0.1)

#while True:
    

