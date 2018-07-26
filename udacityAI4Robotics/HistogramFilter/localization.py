import numpy as np
from copy import deepcopy
# a generic discrete probability distribution
def genProbDistri(n):
    p=[]
    for i in range(n):
        p.append(1.0/n)

    p=np.array(p)
    return p


def calcPostAfterSensor(world,seen,p,pMiss,pHit):
    correctSense=(world==seen)
    correctSense=correctSense*(pHit-pMiss)+pMiss
    #the above calculates the probability of the location being seen
    p=p*correctSense
    p=p/sum(p)
    #the above then multiplies and normalizes the probability of finding the
    #seen item
    return p

def sequentialSensing(world,seen,p,pMiss,pHit,h):
    for i in seen:
        p=calcPostAfterSensor(world,i,p,pMiss,pHit)
        #robot moves 1 step after each iteration
        q=move(p,1)
        p=convolution(q,h)
        #convolution calculates the response of the environment to
        #inaccuracies in movement
    return p

def move(p,U):
    q=[p[(i-U)%len(p)] for i in range(len(p))]
    return q

def convolution(x,h):
    # to find the mid
    # I am trying to code a convolution
    y=deepcopy(x)
    mid=int(len(h)/2)
    for j in range(len(x)):
        y[j]=np.sum([x[(j+i-mid)%len(x)]*h[i] for i in range(len(h))])
    return y


p=genProbDistri(5)
world=np.array(['green', 'red', 'red', 'green', 'green'])
seen = ['red', 'red']
pHit=0.6
pMiss=0.2
h=np.array([0.1,0.8,0.1])
test=np.array([0.0,1.0,0.0,0.0,0.0])

print(sequentialSensing(world,seen,p,pMiss,pHit,h))
