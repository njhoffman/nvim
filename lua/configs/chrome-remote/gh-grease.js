//──────────────────────────────────────────────────────────────────────────────

// ==UserScript==
// @name         Github: Disable codeview Textarea
// @author       Duologic
// @match        https://*.github.com/*
// @run-at       document-end
// ==/UserScript==

console.log("...trying to remove stupid github interface components");
const remove = function(el) {
  el.remove();
};
const disable = function(el) {
  el.disabled = true;
};
const elements = [
  ["textarea", "#read-only-cursor-text-area", disable],
  ["symbols panel", "#__primerPortalRoot__", remove],
  ["fold buttons", "#copilot-button-positioner [role='button']", remove],
];

document.onload = function() {
  for (var el in elements) {
    const node = document.querySelector(el[1]);
    if (node) {
      console.log("element found: " + el[1] + " - " + node.nodeName);
      el[3](node);
      // document.querySelector("#copilot-button-positioner [role='button']");
      // document.querySelector("#copilot-button-positioner > *");
    }
  }
};

const nodeContainsElement = function(node, el) {
  if (node.querySelector && node.querySelector([2])) {
    console.log(`${node.nodeName} contains ${el[1]}: ${el[2]}`);
    return el;
  }
};

function callback(mutationList, observer) {
  mutationList.forEach((mutation) => {
    mutation.addedNodes.forEach((node) => {
      // if (node.nodeName && node.nodeNmae != "") {
      //   console.log(node.nodeName);
      // }
      for (var el in elements) {
        if (nodeContainsElement(el)) {
          console.log("mutation match: ", el);
          el[3]();
        }
      }
    });
  });
}

const trackMutations = function() {
  const observer = new MutationObserver(callback);
  observer.observe(document.body, { childList: true, subtree: true });
};

trackMutations();
