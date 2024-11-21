import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

import csv

with open('csv to diagramm.csv', newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=';', quotechar='|')

    g = []
    for row in reader:
        g.append(row)
    h = dict()
    for q in g[1:]:
        if q[2] not in h.keys():
            h[q[2]] = [[] for _ in range(4)]
        for w in range(4):
            h[q[2]][w].append(int(q[4+w]))
    dt = []
    for q in list(h.values()):
        for w in q:
            dt.append(w)
    labels = []
    for q in h.keys():
        labels.append("")
        labels.append("         "+q)
        labels.append("")
        labels.append("")

    colors = ['cyan', 'yellow', 'lawngreen', 'violet']*4
    leg = []
    for q in range(4):
        leg.append(mpatches.Patch(color=colors[q], label=g[0][4+q][1:-1]))

    fig, ax = plt.subplots()
    ax.set_ylabel('Сделки')
    ax.legend(handles=leg)

    bplot = ax.boxplot(dt,
                       patch_artist=True,  # fill with color
                       tick_labels=labels)  # will be used to label x-ticks

    # fill with colors
    for patch, color in zip(bplot['boxes'], colors):
        patch.set_facecolor(color)
    plt.show()