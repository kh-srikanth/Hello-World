from random import random
from random import randint
ll, ul, pd, n, B, pop = [100, 100, 50], [600, 400, 200], 600, 3, [
    [0.75, 0.05, 0.075], [0.05, 0.15, 0.1], [0.075, 0.1, 0.45]], 4
p = [[ll[i]+(ul[i]-ll[i])*random() for i in range(n)] for j in range(pop)]
print('Intial population')
for i in range(pop):
    print(p[i][:])


def cost(p):  # cost function defn
    # a, b, c = [0.00156, 0.00194, 0.00482], [
    #     7.92, 7.85, 7.97], [561, 310, 78]
    of = []
    for i in range(pop):
        off = 0
        for j in range(n):
            off = (off+p[i][j])
        of.append(abs(off-pd))
    print('Obj function:\n', of)
    return of


def check_lim():  # check limits of varia
    for j in range(pop):
        for i in range(n):
            if p[j][i] > ul[i]:
                p[j][i] = ul[i]
            if p[j][i] < ll[i]:
                p[j][i] = ll[i]
    print('P after checking limits')
    for i in range(pop):
        print(p[i][:])
    return p


def find_teacher():
    # find teacher location
    of = cost(p)
    t = 0
    for i in range(pop):
        if of[t] >= of[i]:
            t = i
    print('Teachers location in popoulation:', t)
    return(t)


def teaching_component(t):
    pm = []
    for i in range(n):
        s = 0
        for j in range(pop):
            s = s+p[j][i]
        s = s/pop
        pm.append(s)
    dtm = [random()*(p[t][i]-(round(random())+1)*pm[i])
           for i in range(n)]  # Teaching compo calc
    return(dtm)


def update(p1, p2):  # retains pop members with best obj in p1
    of1, of2 = cost(p1), cost(p2)
    for i in range(pop):
        if of1[i] > of2[i]:
            p1[i][:] = p2[i][:]
            print(i)
    return(p1)


for it in range(100):
    t = find_teacher()
    dtm = teaching_component(t)
    print('teaching compo:\n', dtm)
    pt = [[p[j][i]+dtm[i] for i in range(n)] for j in range(pop)]
    p = update(p, pt)
    print('After teacher phase:')
    p = check_lim()
    of = cost(p)
    st, i = [], 0
    while i != pop:
        a = randint(0, pop-1)
        if i != a:
            i += 1
            st.append(a)
    print(st)
    ps = [[0 for i in range(n)] for j in range(pop)]
    for i in range(pop):
        ps[i][:] = p[st[i]][:]
    pst = [[0 for i in range(n)] for j in range(pop)]
    ofs = cost(ps)
    for i in range(pop):
        for j in range(n):
            if of[i] <= ofs[i]:
                pst[i][j] = p[i][j]+random()*(p[i][j]-ps[i][j])
            if of[i] > ofs[i]:
                pst[i][j] = p[i][j]+random()*(ps[i][j]-p[i][j])
    print(pst)
    of = cost(p)
    ofst = cost(pst)
    p = update(p, pst)
    p = check_lim()
    of = cost(p)
