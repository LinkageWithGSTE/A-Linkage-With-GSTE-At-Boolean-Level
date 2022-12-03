from z3 import *
MSBA = 3
MSBD = 7
LAST = 15


def all_smt(f, keys):
    res = []
    s = Solver()
    s.add(f)
    while sat == s.check():
        m = s.model()
        partial_model = [(k == m.eval(k)) for k in keys]
        subs = []
        res_t = []
        for k in keys:
            if '[' not in str(k):
                subs.append((k,m.eval(k)))
        for k in keys:
            if '[' in str(k):
                t = str(substitute(k,subs))
                t = t.split('[')
                name = t[0]
                idx = str(eval(t[1].strip("]"))%(LAST+1))
                value = str(m.eval(k)).strip("\"")
                res_t.append("a %s %s %s"%(name,idx,value))
            else:
                value = str(m.eval(k))
                if value=="True" or value=="False":
                    res_t.append("b %s %s" % (str(k), str(m.eval(k))))
                else:
                    res_t.append("bv %s %s" % (str(k), str(m.eval(k))))
        res.append(res_t)
        s.add(Not(And(partial_model)))
    return res



write_addr = BitVec('write_addr', MSBA + 1)
mem = Array('mem', BitVecSort(MSBA + 1), StringSort())
D = StringVal('D')

vertexs = [
    (0, True,[])
]
# i: 0 .. LAST+1
# 2*i+1
for i in range(1,LAST + 2):
    if i == 1:
        f = (write_addr==(i-1))
        keys = [write_addr]
    else:
        f = And(
            write_addr == (i-1),
            Select(mem, (write_addr - 1)) == D
        )
        keys = [write_addr,mem[write_addr - 1]]
    vertexs.append(
        (i,f,keys)
    )


with open("sol","w") as file:
    file.write("\n")
    for i,vertex in enumerate(vertexs):
        (vid,f,keys) = vertex
        if f is True:
            continue
        file.write("%d\n" % vid)
        res = all_smt(f,keys)
        for item in res:
            file.write(",".join(item)+"\n")
        if i!=(len(vertexs)-1):
            file.write(';\n')


