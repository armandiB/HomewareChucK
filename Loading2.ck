me.dir() => string path;
Parse.RemoveLastSplits(path, "/", 2, 1) => string curPath;
ParamsM.SetCurrentPath(curPath);

CIO.ReadFile(curPath + "Library/Calibration/Offsets.txt");
