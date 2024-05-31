// ==UserScript==
// @name         Github: Disable codeview Textarea
// @author       Duologic
// @match        https://*.github.com/*
// @run-at       document-end
// ==/UserScript==

console.log("...trying to remove stupid github interface components");

const summarize_event = function(ev) {
  var output = `${ev.type}`;
  if (type(ev.listener) == "function") {
    output = `${output}  (function)`;
  } else if (ev.listener instanceof HTMLElement) {
    output = `${output}  ${ev.listener.constructor.name} ${ev.listener.nodeName} ${ev.listener.nodeType}`;
    // Object.values(ev.listener)
  } else {
    output = `${output} ${ev.listener.toString()}`;
  }

  for (var evKey in ev) {
    if (evKey != "listener") {
      if (type(ev[evKey]) === "boolean" && ev[evKey] === true) {
        output = `${output} ${evKey}`;
      } else if (type(ev[evKey]) === "object") {
        output = `${output} ${evKey} ${ev[$evKey].toString()}`;
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

const get_events = function(rootNode, events) {
  for (var eventType in getEventListeners(rootNode || document)) {
    getEventListeners(document)[eventType].forEach(function(ev) {
      summarize_event(ev);
      ev.remove();
    });
  }
};

const remove = function(el) {
  el.remove();
};
const disable = function(el) {
  el.disabled = true;
};

const elements = [
  ["textarea", "#read-only-cursor-text-area", disable],
  ["symbols panel", "#__primerPortalRoot__", remove],
  ["fold buttons", "#copilot-button-positioner > *", remove],
];

const nodeContainsElement = function(node, el) {
  if (node.querySelector && node.querySelector([2])) {
    console.log(`${node.nodeName} contains ${el[1]}: ${el[2]}`);
    return el;
  }
};

function callback(mutationList, observer) {
  mutationList.forEach((mutation) => {
    mutation.addedNodes.forEach((node) => {
      console.log(node.nodeName);
      for (var el in elements) {
        // if (nodeContainsElement(el)) {
        //   el[3]()
        // }
      }
    });
  });
}

const trackMutations = function() {
  const observer = new MutationObserver(callback);
  observer.observe(document.body, { childList: true, subtree: true });
};
