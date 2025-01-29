% Add path to scripts/functions
addpath('functions')

% Data directory location  
data_dir = "..\data";

% Make 'figures' folder
mkdir("..\figures")

% Re_c 
plot_re_c()

% Sample steady region plot
plot_steady_region(data_dir)

% Settling_times
% U_inf = 0.4-0.8 [m/s]
f3 = figure(3);
set(f3, 'renderer', 'painters')
t1 = tiledlayout(1, 3);
ax1 = nexttile;
plot_settling_times('0.4')
ax2 = nexttile;
plot_settling_times('0.6')
ax3 = nexttile;
plot_settling_times('0.8')
legend(legendUnq(), 'Location', 'eastoutside')

linkaxes([ax1 ax2 ax3], 'y')
xlabel(t1,'Time [s]')
ylabel(t1,'u [ms^{-1}]')
legend('Location','eastoutside')

t1.TileSpacing = 'compact';
t1.Padding = 'compact';
saveas(f3, "./../figures/0.4-0.8_settling.png")

% U_inf = 1.0-1.4 [m/s]
f4 = figure(4);
set(f4, 'renderer', 'painters')
t2 = tiledlayout(1, 3);
ax4 = nexttile;
plot_settling_times('1.0')
ax5 = nexttile;
plot_settling_times('1.2')
ax6 = nexttile;
plot_settling_times('1.4')
legend(legendUnq(), 'Location', 'eastoutside')

linkaxes([ax4 ax5 ax6], 'y')
xlabel(t2,'Time [s]')
ylabel(t2,'u [ms^{-1}]')
legend('Location','eastoutside')

t2.TileSpacing = 'compact';
t2.Padding = 'compact';
saveas(f4, "./../figures/1.0-1.4_settling.png")

% U_inf = 1.6-2.0 [m/s]
f5 = figure(5);
set(f5, 'renderer', 'painters')
t3 = tiledlayout(1, 3);
ax7 = nexttile;
plot_settling_times('1.6')
ax8 = nexttile;
plot_settling_times('1.8')
ax9 = nexttile;
plot_settling_times('2.0')
legend(legendUnq(), 'Location', 'eastoutside')

linkaxes([ax7 ax8 ax9], 'y')
xlabel(t3,'Time [s]')
ylabel(t3,'u [ms^{-1}]')
legend('Location','eastoutside')

t3.TileSpacing = 'compact';
t3.Padding = 'compact';
saveas(f5, "./../figures/1.6-2.0_settling.png")

% 0.4-2.0_perf
plot_perf_curves(data_dir, '0.4-2.0_perf')

% 0.4-2.0_perf (with blockage correction)
plot_blockage_curves(data_dir, '0.4-2.0_perf');

% Re_dep_4.0
plot_multi_re_curves(data_dir, 'Re_dep_4.0')

% 1.6-2.0_perf
plot_multi_perf_curves(data_dir)

% uncertainty_runs
plot_unc_runs(data_dir)

% Shaded error bars on performance curves
plot_shaded_perf(data_dir, 2)