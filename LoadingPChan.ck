for(0 => int i; i < MBus.PBusSize; i++)
    MBus.PChan1[i] => CIO.Out[i];

for(0 => int i; i < MBus.PBusSize; i++){
    MBus.PChan2[i].gain(0);
    MBus.PChan2[i] => CIO.Out[i];
}
