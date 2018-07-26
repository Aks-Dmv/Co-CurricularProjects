import numpy as np
from copy import deepcopy
import random
import pickle

X=3
Blank=2
O=1
Actions=np.array(range(9))

def invert(numbs):
    return 4 - numbs

random.seed(42)

def invertState(st):
    newA= invert(deepcopy(st.a))

    return State(a=newA)
############
def playAction(a,action):
    a[action]=X
    #The bot plays as X always
##########
def XorO(a):
    if(a==X):
        return 'X'
    elif(a==O):
        return 'O'
    else:
        return ' '

def displayBoard(a):
    #print('_   _   _')
    for i in range(0,7,3):
        print(XorO(a[i]),'|',XorO(a[i+1]),'|',XorO(a[i+2]),'     ',i,'|',i+1,'|',i+2)

#used for displaying
############

def checkCorrectCoord(a,pos):
    if(not(pos>-1 and pos<9)):
        return False
    # 3 is my blank space
    if(not(a[pos]==Blank)):
        return False

    return True

def checkDiag(a,pos,XO):
    temp=False
    if(a[4]==a[4+pos] and a[4+pos]==a[4-pos] and a[4]==XO):
        temp=True
    return temp

def checkLose(oldA):
    XO=X
    for j in range(9):
        if(checkCorrectCoord(oldA,j)):
            a=deepcopy(oldA)
            playAction(a,j)
            if(checkWin(a)):
                return True
    return False

def checkDraw(oldA):
    if((oldA==Blank).sum()==0):
        #no zero in oldA
        #and I didn't win
        return True
    else:
        return False

def checkWin(a):
    Won=False
    XO=X
    for i in range(3):
        if(a[3*i]==a[3*i+1] and a[3*i+1]==a[3*i+2] and a[3*i]==XO):
            #print(a[3*i],a[3*1],a[3*2])
            #print('row at ',3*i)
            Won=True
        if(a[i]==a[i+3] and a[i+3]==a[i+6] and a[i]==XO):
            #print('col at ',i)
            Won=True
        #checking for diagonols
    if(checkDiag(a,2,XO)):
        Won=True
    if(checkDiag(a,4,XO)):
        Won=True

    return Won


class State:

    def __init__(self,a):
        self.a=a

    def __eq__(self,other):
        return isinstance(other,State) and self.a.all()==other.a.all()

    def __hash__(self):
        return hash(str(self.a))

    def __str__(self):
        return f"State(a={self.a})"




start_state=State(a=np.zeros(9)+Blank)


def act(state,action):

    if(not(checkCorrectCoord(state.a,action))):
        reward=-5
        isDone=True
        newA=deepcopy(state.a)
        #No change in state
        return State(a=newA), reward, isDone
    else:
        newA=deepcopy(state.a)
        playAction(newA,action)
        if(checkWin(newA)):
            reward=5
            isDone=True
        elif(checkLose(invert(newA))):
            reward=-5
            isDone=False
        elif(checkDraw(newA)):
            reward=3
            isDone=True
        else:
            reward=1
            isDone=False
        return State(a=newA), reward, isDone




NStates=19683
NEpisodes=50000

MaxEpisodeSteps = 100

MinAlpha = 0.05

alphas = np.linspace(1.0, MinAlpha, NEpisodes)
gamma = 0.8
eps = 0.5


pickle_in = open("q0.pickle","rb")
q_table = pickle.load(pickle_in)

def q(state,action=None):
    if state not in q_table:
        q_table[state] = np.zeros(len(Actions))

    if action is None:
        return q_table[state]

    return q_table[state][action]

def choose_action(state):
    if random.uniform(0, 1) < eps:
        return random.choice(Actions)
    else:
        return np.argmax(q(state))

def training(state,total_reward,ac):
    action = ac
    next_state, reward, done = act(state, action)
    #displayBoard(state.a)
    print("")
    total_reward += reward
    #print(total_reward)
    displayBoard(state.a)
    print(state)
    print("old q state and reward",q(state),reward,alpha * (reward + gamma *  np.max(q(next_state)) - q(state, action)))
    q(state)[action] = q(state, action) + \
            alpha * (reward + gamma *  np.max(q(next_state)) - q(state, action))

    print(q(state)," this is q(state)",action)
    state = next_state
    #print(state.a)

    return state,total_reward, done

def recursiveCall(state,total_reward,e):
    for ac in Actions:
        if(not(checkCorrectCoord(state.a,ac))):
            continue
        new_state,total_reward,done=training(state,total_reward,ac)
        #print("the new state is")
        #print(new_state.a)
        #displayBoard(new_state.a)
        #print("the new invert state is")
        yo=invertState(new_state)
        #print(yo.a)
        #displayBoard(yo.a)
        print(f"Episode {e + ac}: total reward -> {total_reward}")
        if(not(done)):
            recursiveCall(yo,total_reward,(e+ac)*10)

state = start_state
total_reward = 0
alpha = alphas[0]
#for i in range(5):
"""
recursiveCall(state,total_reward,0)

pickle_out = open("q1.pickle","wb")
pickle.dump(q_table, pickle_out)
pickle_out.close()

recursiveCall(state,total_reward,1)

pickle_out = open("q2.pickle","wb")
pickle.dump(q_table, pickle_out)
pickle_out.close()
"""

for e in range(NEpisodes):

    state = start_state
    total_reward = 0
    alpha = alphas[e]

    for _ in range(MaxEpisodeSteps):
        if(NEpisodes%7000 and eps>0):
            eps=eps-0.1
        action = choose_action(state)
        """
        if(MaxEpisodeSteps%2==0):
            if(MaxEpisodeSteps==0):
                action=[4.]
        """
        next_state, reward, done = act(state, action)
        displayBoard(state.a)
        print("\n")
        total_reward += reward

        q(state)[action] = q(state, action) + \
                alpha * (reward + gamma *  np.max(q(next_state)) - q(state, action))
        state = invertState(next_state)
        print(q(state)," this is q(state)",displayBoard(state.a))
        if done:
            break
    displayBoard(state.a)
    print(f"Episode {e + 1}: total reward -> {total_reward}")

pickle_out = open("q3.pickle","wb")
pickle.dump(q_table, pickle_out)
pickle_out.close()
