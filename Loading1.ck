me.dir() => string path;

Parse.RemoveLastSplits(path, "/", 2, 1) => string curPath;

Machine.add(curPath + "External/lick/import.ck");
1::second => now;

Machine.add(path + "IO/0_CIO.ck");
Machine.add(path + "Math/0_MathU.ck");
Machine.add(path + "Math/0_PlompConsonance.ck");
Machine.add(path + "Basic/0_FloatSeries.ck");
Machine.add(path + "Basic/0_FloatDur.ck");
Machine.add(path + "CV/0_StepPlayer.ck");
Machine.add(path + "CV/0_Interpolator.ck");
Machine.add(path + "CV/0_GEnvelope.ck");
Machine.add(path + "CV/0_GainGesture.ck");
Machine.add(path + "CV/0_BeatPlayer.ck");
Machine.add(path + "CV/0_EventBank.ck");
Machine.add(path + "Audio/0_SineBank.ck");
Machine.add(path + "Audio/0_Pan2G.ck");
Machine.add(path + "IO/0-_ControlG");
Machine.add(path + "Functors/0_SqrtFunctor.ck");
Machine.add(path + "Processing/0_AnalyzerG.ck");
Machine.add(path + "Basic/0-001_ParamsM.ck");
Machine.add(path + "Math/0-010_RandomGen.ck");
Machine.add(path + "Sampler/0-010_SamplePlayer.ck");
Machine.add(path + "Sampler/0-010_Looper.ck");
Machine.add(path + "IO/0-050_MBus.ck");
Machine.add(path + "IO/0-050_Recording.ck");
Machine.add(path + "IO/0-060_IOU.ck");
Machine.add(path + "Math/0-100_Chaos.ck");
Machine.add(path + "Processing/0-100_Xenakeur.ck");
Machine.add(path + "Audio/0-100_SineCloud.ck");
Machine.add(path + "Sampler/0-100_SPBundle.ck");
Machine.add(path + "Spatializer/0-100_Spatializer.ck");
Machine.add(path + "Gaz/0-100_GazParamsOut.ck");
Machine.add(path + "Gaz/0-101_GazParams.ck");
Machine.add(path + "Gaz/0-102_GazParamsFreqOut.ck");
Machine.add(path + "Gaz/0-103_GazParamsSpaceOut.ck");
Machine.add(path + "Gaz/0-104_GazParamsRecOut.ck");
Machine.add(path + "CV/0-200_OdeCV.ck");
Machine.add(path + "Preset/0-295_GainOut.ck");
Machine.add(path + "Preset/0-300_GeneralOut.ck");
Machine.add(path + "Preset/0-350_SinOut.ck");
Machine.add(path + "Preset/0-350_StepOut.ck");
Machine.add(path + "Preset/0-360_SinGeneralOut.ck");
Machine.add(path + "Preset/0-360_StepGeneralOut.ck");
Machine.add(path + "IO/0-600_OutGen.ck");
Machine.add(path + "CV/0-700_PitchHandler.ck");
Machine.add(path + "Preset/0-710_PitchHandlerOut.ck");
Machine.add(path + "Preset/0-720_PitchHandlerGeneralOut.ck");
Machine.add(path + "Preset/0-900_Preset.ck");
Machine.add(path + "Math/1_EGroup.ck");
Machine.add(path + "Math/1-300_ExtFunction.ck");
Machine.add(path + "Math/1-500_EGroupExt.ck");
Machine.add(path + "Math/1-500_ESet.ck");
Machine.add(path + "Math/2_GScale.ck");
Machine.add(path + "Math/2_GTriad.ck");
Machine.add(path + "Math/2_ToneCircle.ck");
Machine.add(path + "Math/3_CyclicGroup.ck");

Machine.add(path + "Objects/10-001_AK.ck");
Machine.add(path + "Objects/10-002_PrimePitches.ck");
Machine.add(path + "Objects/10-003_XenakeurConics.ck");
Machine.add(path + "Objects/10-004_Cumulus.ck");
Machine.add(path + "Objects/10-005_Stratus.ck");
Machine.add(path + "Objects/10-006_Cirrus.ck");

//Machine.add(path + "Functions/20_TestTriads_20190711.ck");
Machine.add(path + "Functions/20_Sandbox_AK_20190808.ck");

//Machine.add(path + "Scores/Presets/30-001_TypicalPreset_20191002.ck");
Machine.add(path + "Scores/Presets/30-002_TypicalPresetTrack_20191004.ck");
Machine.add(path + "Scores/Presets/30-003_PrimePitchesPreset_20191003.ck");
Machine.add(path + "Scores/Presets/30-004_XenakeurPreset0_20191029.ck");

Machine.add(path + "Scores/Sandboxes/20190905_Sandbox_H0l0.ck");
Machine.add(path + "Scores/Sandboxes/20191002_Default_Sandbox.ck");

Machine.add(path + "Loading2.ck");
