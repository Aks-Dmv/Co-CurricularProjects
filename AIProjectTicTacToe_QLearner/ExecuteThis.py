import numpy as np
import sys
from copy import deepcopy
import pickle
import random
Actions=np.array(range(9))
def playAction(a,action,XO):
    a[action]=XO

def invert(numbs):
    return 4 - numbs

class State:

    def __init__(self,a):
        self.a=a

    def __eq__(self,other):
        return isinstance(other,State) and self.a.all()==other.a.all()

    def __hash__(self):
        return hash(str(self.a))



def XorO(a):
    if(a==1):
        return 'X'
    elif(a==-1):
        return 'O'
    else:
        return ' '

def checkDiagL(a,pos,XO):
    temp=False
    if(a[4]==a[4+pos] and a[4+pos]==a[4-pos] and a[4]==XO):
        temp=True
    return temp

def checkLose(oldA,XO):
    Lose=False
    for j in range(9):
        if(checkCorrectCoord(oldA,j)):
            a=deepcopy(oldA)
            #print(a)
            playAction(a,j,-XO)
            for i in range(3):
                if(a[3*i]==a[3*i+1] and a[3*i+1]==a[3*i+2] and a[3*i]==-XO):
                    Lose=True
                if(a[i]==a[i+3] and a[i+3]==a[i+6] and a[i]==-XO):
                    Lose=True
                #checking for diagonols
            if(checkDiagL(a,2,-XO)):
                Lose=True
            if(checkDiagL(a,4,-XO)):
                Lose=True

    return Lose

def checkXOStartInput(YN):
    if(not(YN==1 or YN==-1)):
        print('Sorry not 1 or -1')
        sys.exit()

def displayBoard(a):
    #print('_   _   _')
    for i in range(0,7,3):
        print(XorO(a[i]),'|',XorO(a[i+1]),'|',XorO(a[i+2]),'     ',i,'|',i+1,'|',i+2)

def checkCorrectCoord(a,pos):
    if(not(pos>-1 and pos<9)):
        return False

    elif(not(a[pos]==0)):
        return False

    else:
        return True

def playerMove(YN,a):
    if(YN==1):
        XO='X'
    else:
        XO='O'
    print('Which spot do you want to place',XO)
    displayBoard(a)
    pos=int(input("choose from 0-8 "))

    print("\n\n")
    if(not(checkCorrectCoord(a,pos))):
        print('That spot is already Taken')
        print('YOU LOSE')
        sys.exit()
    a[pos]=YN



def q_st(state,action=None):
    if state not in q_table:
        q_table[state] = np.zeros(len(Actions))

    if action is None:
        return q_table[state]

    return q_table[state][action]
#a=[ 1.,  3.,  2.,  2.,  1.,  2.,  2.,  2.,  2.]
#st=State(a=np.array(a))

def theMove(qa,a):
    arr=np.flatnonzero(qa == qa.max())
    #print(arr)
    if(not(a[arr].any()==0)):
        arr=np.delete(np.array(range(9)), arr, 0)
    i=np.random.choice(arr)
    #print(i)
    return i

def compMove(YN,aaa):
    aa=aaa+2
    if (YN==-1):
        st=State(a=aa)
        i=theMove(q_st(st),aaa)
        playAction(aaa,i,-YN)

    else:
        #print("test")
        newA=invert(deepcopy(aa))
        st=State(a=newA)
        i=theMove(q_st(st),aaa)
        playAction(aaa,i,-YN)



def checkDiag(a,pos):
    if(a[4]==a[4+pos] and a[4+pos]==a[4-pos]):
        #print('diag at ',pos+4)
        XOWon(a,4)

def Won(symb):
    print("")
    print("")
    print("")
    print("-------------------------")
    print("        GAME OVER")
    print("         ",symb,'WON')
    print("-------------------------")
    print("")
    print("")
    print("")

    displayBoard(a)
    sys.exit()

def XOWon(a,pos):
    if(a[pos]==1):
        Won('X')
    elif(a[pos]==-1):
        Won('O')

def checkWin(a):
    for i in range(3):
        if(a[3*i]==a[3*i+1] and a[3*i+1]==a[3*i+2]):
            #print(a[3*i],a[3*1],a[3*2])
            #print('row at ',3*i)
            XOWon(a,3*i)
        if(a[i]==a[i+3] and a[i+3]==a[i+6]):
            #print('col at ',i)
            XOWon(a,i)

        #checking for diagonols
    checkDiag(a,2)
    checkDiag(a,4)
print('This is a tic tac toe simulator')
print('This was made by Akshay Dharmavaram')
a=np.zeros(9)

print('for an AI project')
print('')
print('X starts first')
YN1=int(input("If you want to be O press 1 else -1 "))
YN=-YN1
print("")
print('The board is on the left and the positions are on the right')
#displayBoard(a)

#print(not(YN==1 or YN==0))



checkXOStartInput(YN)
Diff=int(input("how difficult do you want: 0,1,2,3? "))
if(Diff==0):
    pickle_in = open("QStatesSavedModel0.pickle","rb")
    q_table = pickle.load(pickle_in)
if(Diff==1):
    pickle_in = open("QStatesSavedModel1.pickle","rb")
    q_table = pickle.load(pickle_in)
if(Diff==2):
    pickle_in = open("QStatesSavedModel2.pickle","rb")
    q_table = pickle.load(pickle_in)
if(Diff==3):
    pickle_in = open("QStatesSavedModel3.pickle","rb")
    q_table = pickle.load(pickle_in)
##print("testing out here")
##b=np.array([1, 0, -1, 0, -1, 1, 0, 0, -1])
##displayBoard(b)
##print("")

MovesDone=0
if(YN==1):
    playerMove(YN,a)
    MovesDone+=1
while(MovesDone<9):
    compMove(YN,a)
    MovesDone+=1
    #print(a)
    #displayBoard(a)
    checkWin(a)

    if(MovesDone>8):
        break
    playerMove(YN,a)
    MovesDone+=1
    checkWin(a)
    if(checkLose(a,YN)):
        print("YOU LOST")
