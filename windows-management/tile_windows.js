(function () { 'use strict';
var Finder = Application('Finder');
var SystemEvents = Application('System Events');
SystemEvents.includeStandardAdditions = true;

// Get screen bounds via Finder: returns [left, top, right, bottom]
function getScreenBounds() {
    // Finder.desktop.window().bounds() or Finder.desktop.window().bounds() style
    // Use .window() for the desktop window and get its bounds array
    return Finder.desktop.window().bounds();
}

// Get frontmost process (System Events process object)
function getFrontProcess() {
    var procs = SystemEvents.processes.whose({ frontmost: true });
    if (procs.length === 0) return null;
    return procs[0];
}

// Set position and size of front window (if possible)
function setFrontWindowRect(x, y, w, h) {
    var proc = getFrontProcess();
    if (!proc) return;
    if (proc.windows.length === 0) return;
    try {
        var win = proc.windows[0];
        win.position = [Math.round(x), Math.round(y)];
        win.size = [Math.round(w), Math.round(h)];
    } catch (e) {
        // some apps / windows won't accept programmatic resize; ignore errors
    }
}

function tileLeft() {
    var sb = getScreenBounds();
    var left = sb[0], top = sb[1], right = sb[2], bottom = sb[3];
    var sw = right - left, sh = bottom - top;
    var w = Math.floor(sw / 2), h = sh;
    setFrontWindowRect(left, top, w, h);
}

function tileRight() {
    var sb = getScreenBounds();
    var left = sb[0], top = sb[1], right = sb[2], bottom = sb[3];
    var sw = right - left, sh = bottom - top;
    var w = Math.floor(sw / 2), h = sh;
    var x = left + (sw - w);
    setFrontWindowRect(x, top, w, h);
}

function centerTwoThirds() {
    var sb = getScreenBounds();
    var left = sb[0], top = sb[1], right = sb[2], bottom = sb[3];
    var sw = right - left, sh = bottom - top;
    var w = Math.round(sw * 2 / 3), h = sh;
    var x = left + Math.round((sw - w) / 2);
    setFrontWindowRect(x, top, w, h);
}

var args = $.NSProcessInfo.processInfo.arguments 
var argv = []
var argc = args.count
for (var i = 4; i < argc; i++) {
    // skip 3-word run command at top and this file's name
    console.log($(args.objectAtIndex(i)).js)       // print each argument
    argv.push(ObjC.unwrap(args.objectAtIndex(i)))  // collect arguments
}

switch(argv[0]) {
    case 'left':
        tileLeft();
        break;
    case 'right':
        tileRight();
        break;
    case 'center':
        centerTwoThirds();
        break;
    default:
        // do nothing
        break;
}

// Call whichever you want:
// tileLeft();
// tileRight();
// centerTwoThirds();
})();
