clc;
clear;

%%
Tgeo = 287.15;  %[K] temperature of the water entering in the HP from geothermal system
KTC = 760;      %overall heat transfer coefficient (heat exchanger water/air in the AHU) [W/K]
COPMAX = 6;      %maximum COP value [-]
COPMIN = 3;      %minimum COP value [-]
PelMAX = 6000;	%maximum limiting value for Pel [W]
Toutmax = 333;      %maximum value for T_out [K]
mMAX = 5;        %maximum value for the water mass flow rate [kg/s]
delta_t = 1;%180%;   %time step [s]
DTemp = 5;     %temperature difference between T_out(t) and T_in(t) [K]
c_w = 4186;      %specific heat capacity of water  [J/kg K]
c_air = 1000;	%specific heat capacity of air\ [J/kg\ K]
C_m_int = 9422312;	%average heat capacity of inner greenhouse masses [J/K]
m_g = 732;       %mass of air in the greenhouse [kg]
b_g = 151.5;     %land area of the greenhouse [m^2]
S_g = 362;       %lateral and top surface area of the glass of the greenhouse [m^2]
Smint = 385;     %surface area of the components inside the greenhouse (lateral and top surface area of the glass of the greenhouse and benches and soil [m^2]
K = 3.3;         %overall heat transfer coefficient per unit surface of the greenhouse envelope [W/m2K]
hmint = 8;        %convective heat transfer coefficient [W/m2K]
C_g = c_air * m_g;   %heat capacity of greenhouse air [J/K]
delta = 0.35;