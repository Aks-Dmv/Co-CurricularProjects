# ----------
# User Instructions:
#
# Define a function, search() that returns a list
# in the form of [optimal path length, row, col]. For
# the grid shown below, your function should output
# [11, 4, 5].
#
# If there is no valid path from the start point
# to the goal, your function should return the string
# 'fail'
# ----------

# Grid format:
#   0 = Navigable space
#   1 = Occupied space

from copy import deepcopy
"""
grid = [[0, 0, 1, 0, 0, 0],
        [0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 1, 0],
        [0, 0, 1, 1, 1, 0],
        [0, 0, 0, 0, 1, 0]]
"""
grid = [[0, 1, 0, 1, 1],
        [0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0],
        [0, 1, 0, 1, 0],
        [1, 0, 1, 0, 0]]
init = [0, 0]
goal = [len(grid)-1, len(grid[0])-1]
cost = 1

delta = [[-1, 0], # go up
         [ 0,-1], # go left
         [ 1, 0], # go down
         [ 0, 1]] # go right

delta_name = ['^', '<', 'v', '>']

def findRoute(when,route,n):
    x=0
    y=0
    route[goal[0]][goal[1]]='*'
    time=n-1

    for i in range(n-1):
        for i in range(len(delta)):
            xHold=x+delta[i][0]
            yHold=y+delta[i][1]
            if(xHold<len(grid) and yHold<len(grid[0]) and xHold>=0 and yHold>=0):
                if(time==when[xHold][yHold]):
                    route[x][y]=delta_name[i]
                    x=xHold
                    y=yHold
                    time-=1
                    break
    return route

def dpProgram(grid,goal,cost):
    # ----------------------------------------
    # insert code here
    # ----------------------------------------

    # I am just doing breadth first search
    done=deepcopy(grid)

    dp=[[-1 for j in i] for i in grid]
    route=[[" " for j in i] for i in grid]
    #print(when)

    dp[goal[0]][goal[1]]=0
    x=goal[0]
    y=goal[1]
    done[x][y]=1
    z=[]
    ele=[0,x,y]
    z.append(ele)
    count=0

    while ( (len(z)!=0)):
        print(z)
        temp=z.pop(0) # this pops the first element
        print(temp[0])
        TotalMin=temp[0]+1
        for i in range(len(delta)):
            x=temp[1]+delta[i][0]
            y=temp[2]+delta[i][1]

            tempCost=temp[0]+1
            if(x<len(grid) and y<len(grid[0]) and x>=0 and y>=0 and done[x][y]==0):
                z.append([tempCost,x,y])
                print(tempCost,TotalMin)
                if(TotalMin>tempCost):
                    TotalMin=tempCost
                print(tempCost,TotalMin)
                count+=1
                done[x][y]=1
        dp[temp[1]][temp[2]]=TotalMin
                #print(z)
    route=findRoute(dp,route,dp[0][0])
    for path in route:
        print (path)
    return 'Done'

print(dpProgram(grid,goal,cost))
