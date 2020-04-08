Std.srand(1);

OdeCV lorenz;
lorenz.setMode("lorenz");
lorenz.init(3);
lorenz.out[0] => MBus.PChan0[ParamsM.IntensityOut];
lorenz.out[1] => MBus.PChan0[ParamsM.TBDCVOut];
lorenz.out[2] => MBus.PChan0[ParamsM.TBDCVOut2];

float lParams[0];
lParams << 10 << 8/3 << 0.5 ; //try rho = 14, 28, 99.96
Chaos.PrintLorenzCriticalPoints(lParams);
lorenz.setParams(lParams)
float lInit[0]; lInit << 2 << 3 << 4;
lorenz.setLastValues(lInit);

lorenz.done => now;

//lorenz._fadeTo(lorenz2, 10::second);
