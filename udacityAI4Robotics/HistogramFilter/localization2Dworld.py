import numpy as np
from copy import deepcopy
# a generic discrete probability distribution
def genProbDistri(world):
    I=len(world)
    J=len(world[0])
    p=[]
    for i in range(I):
        q=[]
        for j in range(J):
            q.append(1.0/(I*J))
        p.append(q)
    p=np.array(p)
    return p


def calcPostAfterSensor(world,seen,p,pMiss,pHit):
    correctSense=sense(world,seen)
    correctSense=correctSense*(pHit-pMiss)+pMiss
    #the above calculates the probability of the location being seen
    p=p*correctSense
    p=p/sum(sum(p))
    #the above then multiplies and normalizes the probability of finding the
    #seen item
    return p

def sequentialSensing(world,seen,p,pMiss,pHit,h,motion):
    for i in range(len(seen)):
        p=move(p,motion[i],h)
        #p=convolution(q,h)
        #convolution calculates the response of the environment to
        #inaccuracies in movement
        p=calcPostAfterSensor(world,seen[i],p,pMiss,pHit)
        #robot moves 1 step after each iteration

    return p

def sense(world,seen):
    p=np.zeros([len(world),len(world[0])])
    for i in range(len(world)):
        for j in range(len(world[0])):
            p[i][j]=world[i][j]==seen
    return p

def move(p,U,h):
    q=deepcopy(p)
    for i in range(len(p)):
        for j in range(len(p[0])):
            q[i][j]=p[(i-U[0])%len(p)][(j-U[1])%len(p[0])]*h+(1-h)*p[i][j]


    return q

def convolution(x,h):
    # to find the mid
    # I am trying to code a convolution
    y=deepcopy(x)
    mid=int(len(h)/2)
    print(mid)
    for j in range(len(x)):
        y[j]=np.sum([x[(j+i-mid)%len(x)]*h[i] for i in range(len(h))])
    print(y[j])
    return y
"""
def probOfSensorRight(correctSense,sensor_right):
    p=deepcopy(correctSense)
    for i in range(len(correctSense)):
        for j in range(len(correctSense[0])):
            print(correctSense[i][j])
            p[i][j]=correctSense[i][j]*(sensor_right-(1-sensor_right))+(1-sensor_right)
    return p
"""

colors = [['R','G','G','R','R'],
          ['R','R','G','R','R'],
          ['R','R','G','G','R'],
          ['R','R','R','R','R']]
world=np.array(colors)
"""
world=np.array( [['green', 'green', 'green'],
                ['green', 'red', 'red'],
                ['green', 'green', 'green']])
"""
sensor_right=0.7
pMove=0.8
sensed=['G','G','G','G','G']
motion = [[0,0],[0,1],[1,0],[1,0],[0,1]]
moved=deepcopy(world)
p=genProbDistri(world)
p=sequentialSensing(moved,sensed,p,1-sensor_right,sensor_right,pMove,motion)


print(p)

"""

seen = ['R', 'R']
pHit=0.6
pMiss=0.2
h=np.array([0.1,0.8,0.1])
test=np.array([0.0,1.0,0.0,0.0,0.0])
print(sequentialSensing(world,seen,p,pMiss,pHit,h))
"""
