# from https://stackoverflow.com/a/55171754

import numpy as np
import time
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.animation import FuncAnimation
import scipy.io

mat = scipy.io.loadmat('pythonPlot.mat')
#print(mat['tmp'][0][0])

fig, ax = plt.subplots(subplot_kw=dict(projection="3d"))
scaling_factor = 0.15
rb1_c = (1,0,0,1)
rb2_c = (0,1,0,1)
rb3_c = (0,0,1,1)

#ax.text(0.1,0.1,0,s='Text')

def get_arrow(str_, ind_, s_f):
    ind = int(ind_)
    #print(ind)
    x = 0
    y = 0
    z = 0
    u = mat[str_][ind][0]*s_f
    v = mat[str_][ind][1]*s_f
    w = mat[str_][ind][2]*s_f
    return x,y,z,u,v,w

#quiver = ax.quiver(*get_arrow('tmp',0, scaling_factor))
#quiver_r1 = ax.quiver(*get_arrow('r1', 0, scaling_factor), colors=r1_c)

quiver_rb1 = ax.quiver(*get_arrow('rb1', 0, 1), colors=rb1_c)
quiver_rb2 = ax.quiver(*get_arrow('rb2', 0, 1), colors=rb2_c)
quiver_rb3 = ax.quiver(*get_arrow('rb3', 0, 1), colors=rb3_c)

#ax.quiver(0,0,0,0.5*scaling_factor,0,0,colors=(1,0,0,1));
#ax.quiver(0,0,0,0,0.5*scaling_factor,0,colors=(0,1,0,1));
#ax.quiver(0,0,0,0,0,0.5*scaling_factor,colors=(0,0,1,1),);

ax.set_xlim(-1*scaling_factor, 1*scaling_factor)
ax.set_ylim(-1*scaling_factor, 1*scaling_factor)
ax.set_zlim(-1*scaling_factor, 1*scaling_factor)
ax.set_ylabel("Y")
ax.set_xlabel("X")
ax.set_zlabel("Z")
title = ax.set_title("t = 0")
print(title)

def update(ind):
    #global quiver
    #global quiver_r1
    global quiver_rb1
    global quiver_rb2
    global quiver_rb3
    global title
    #global scaling_factor
    title.set_text("t = {:.2f}".format(ind/1000))
    time.sleep(0.2)
    #quiver.remove()
    quiver_rb1.remove()
    quiver_rb2.remove()
    quiver_rb3.remove()

    #quiver = ax.quiver(*get_arrow('tmp',ind, scaling_factor), arrow_length_ratio=0.1)
    quiver_rb1 = ax.quiver(*get_arrow('rb1',ind, 1), arrow_length_ratio=0.1,colors=rb1_c)
    quiver_rb2 = ax.quiver(*get_arrow('rb2',ind, 1), arrow_length_ratio=0.1,colors=rb2_c)
    quiver_rb3 = ax.quiver(*get_arrow('rb3',ind, 1), arrow_length_ratio=0.1,colors=rb3_c)

ani = FuncAnimation(fig, update, frames=np.linspace(0,200, 200), interval=2, repeat=True)
plt.show()
