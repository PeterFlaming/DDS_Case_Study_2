# This script was produced by glue and can be used to further customize a
# particular plot.

### Package imports

from glue.core.state import load
import matplotlib.pyplot as plt
import numpy as np

### Set up data

data_collection = load('Documents/GitHub/Wells_by_County_Histogram.py.data')

### Set up viewer

fig = plt.figure()
ax = fig.add_subplot(1, 1, 1, aspect='auto')

### Set up layers

## Layer 1: fracfocus_registry_texas

layer_data = data_collection[0]

# Get main data values
x = layer_data['col16']

# Set up histogram bins
hist_n_bin = 30
hist_x_min = np.nanmin(x)
hist_x_max = 52.5

x = x[(x >= hist_x_min) & (x <= hist_x_max)]

ax.hist(x, alpha=0.8, color='0.35', zorder=1, edgecolor='none', range=[hist_x_min, hist_x_max], bins=hist_n_bin)

### Finalize viewer

# Set limits
ax.set_xlim(0.0, 52.5)
ax.set_ylim(0, 210.0)

# Set scale (log or linear)
ax.set_xscale('linear')
ax.set_yscale('linear')

# Set axis label properties
ax.set_xlabel('County Name', weight='normal', size=10)
ax.set_ylabel('Number', weight='normal', size=10)

# Set tick label properties
ax.tick_params('x', labelsize=8)
ax.tick_params('y', labelsize=8)

# Save figure
fig.savefig('glue_plot.png')
plt.close(fig)
