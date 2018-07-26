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
grid = [[0, 1, 1, 1, 1],
        [0, 1, 0, 0, 0],
        [0, 1, 0, 1, 0],
        [0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0]]
init = [0, 0]
goal = [len(grid)-1, len(grid[0])-1]
cost = 1

delta = [[-1, 0], # go up
         [ 0,-1], # go left
         [ 1, 0], # go down
         [ 0, 1]] # go right

delta_name = ['^', '<', 'v', '>']

def findRoute(when,route,n):
    x=goal[0]
    y=goal[1]
    route[x][y]='*'
    time=n-1

    for i in range(n):
        for i in range(len(delta)):
            xHold=x+delta[i][0]
            yHold=y+delta[i][1]
            if(xHold<len(grid) and yHold<len(grid[0]) and xHold>=0 and yHold>=0):
                if(time==when[xHold][yHold]):
                    route[xHold][yHold]=delta_name[int((i+len(delta_name)/2)%len(delta_name))]
                    x=xHold
                    y=yHold
                    time-=1
                    break
    return route

def search(grid,init,goal,cost):
    # ----------------------------------------
    # insert code here
    # ----------------------------------------

    # I am just doing breadth first search
    done=deepcopy(grid)
    when=[[-1 for j in i] for i in grid]
    route=[[" " for j in i] for i in grid]
    #print(when)
    done[0][0]=1
    x=init[0]
    y=init[1]
    z=[]
    h=0+abs(goal[0]-x)+abs(goal[1]-y)
    ele=[0,x,y,h]
    z.append(ele)
    count=0
    when[x][y]=count

    while ( (len(z)!=0)):
        #z.sort()
        temp=z.pop(0) # this pops the first element
        Totalmin=temp[0]+1+goal[0]+goal[1]
        for i in range(len(delta)):
            x=temp[1]+delta[i][0]
            y=temp[2]+delta[i][1]
            if(x<len(grid) and y<len(grid[0]) and x>=0 and y>=0 and done[x][y]==0 and Totalmin>1+temp[0]+abs(goal[0]-x)+abs(goal[1]-y)):
                Totalmin=1+temp[0]+abs(goal[0]-x)+abs(goal[1]-y)

        for i in range(len(delta)):

            x=temp[1]+delta[i][0]
            y=temp[2]+delta[i][1]
            if(1+temp[0]+abs(goal[0]-x)+abs(goal[1]-y)>Totalmin):
                #print(x,y,Totalmin,1+temp[0]+abs(goal[0]-x)+abs(goal[1]-y))
                continue
            tempCost=temp[0]+1
            h=tempCost+abs(goal[0]-x)+abs(goal[1]-y)
            if(x<len(grid) and y<len(grid[0]) and x>=0 and y>=0 and done[x][y]==0 and Totalmin==1+temp[0]+abs(goal[0]-x)+abs(goal[1]-y)):
                z.append([tempCost,x,y,h])
                count+=1
                when[x][y]=count
                done[x][y]=1
                if(x==goal[0] and y==goal[1]):
                    route=findRoute(when,route,tempCost)
                    # this for loop is for printing the route
                    for path in when:
                        print (path)
                    return [tempCost,x,y]
        #print(Totalmin,x,y,z)
                #print(z)
    # this for loop is for printing the visited nodes
    for path in when:
        print (path)
    return 'fail'

print(search(grid,init,goal,cost))
