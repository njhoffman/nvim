//──────────────────────────────────────────────────────────────────────────────
const summarize_event = function(ev) {
  var output = `${ev.type}`;
  if (typeof ev.listener == "function") {
    output = `${output}  (function)`;
  } else if (ev.listener instanceof HTMLElement) {
    output = `${output}  ${ev.listener.constructor.name} ${ev.listener.nodeName} ${ev.listener.nodeType}`;
    // Object.values(ev.listener)
  } else {
    output = `${output} ${ev.listener.toString()}`;
  }

  for (var evKey in ev) {
    if (evKey != "listener") {
      if (typeof ev[evKey] === "boolean" && ev[evKey] === true) {
        output = `${output} ${evKey}`;
      } else if (typeof ev[evKey] === "object") {
        output = `${output} ${evKey} ${ev[evKey].toString()}`;
      }
    }
  }
  console.log(output);
};

const primary_events = [
  "DOMContentLoaded",
  "blur",
  "change",
  "click",
  "codeEditor:ready",
  "contextmenu",
  "dblclick",
  "focus",
  "focusin",
  "focusout",
  "keydown",
  "keypress",
  "scroll",
  "submit",
];
