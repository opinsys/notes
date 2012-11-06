require(["cs!app/main"], function(boot) {
  console.log("main app loaded");
  if (window.startNotes) {
    console.log("starting main app");
    boot();
  }
});

