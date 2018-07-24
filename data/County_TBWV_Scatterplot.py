# This script was produced by glue and can be used to further customize a
# particular plot.

### Package imports

from glue.core.state import load
import matplotlib.pyplot as plt

### Set up data

data_collection = load('Documents/GitHub/County_TBWV_Scatterplot.py.data')

### Set up viewer

fig = plt.figure()
ax = fig.add_subplot(1, 1, 1, aspect='auto')

### Set up layers

## Layer 1: fracfocus_registry_texas

layer_data = data_collection[0]

# Get main data values
x = layer_data['col16']
y = layer_data['col13']

ax.plot(x, y, 'o', color='0.35', markersize=3, alpha=0.8, zorder=1, mec='none')

### Finalize viewer

# Set limits
ax.set_xlim(-3.1500000000000004, 55.15)
ax.set_ylim(-2294838.35, 48191605.35)

# Set scale (log or linear)
ax.set_xscale('linear')
ax.set_yscale('linear')

# Set axis label properties
ax.set_xlabel('County', weight='normal', size=10)
ax.set_ylabel('Total Base Water Volume', weight='normal', size=10)

# Set tick label properties
ax.tick_params('x', labelsize=8)
ax.tick_params('y', labelsize=8)

# Save figure
fig.savefig('glue_plot.png')
plt.close(fig)
