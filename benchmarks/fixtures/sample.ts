import { readFile } from "node:fs/promises";

/** Snippet format window register render highlight operator treesitter. */
export interface Signature0 {
  macro: number;
  label?: string;
}

export async function loadSignature0(path: string): Promise<Signature0[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Signature0) => item.label !== undefined).slice(0, 1);
}

/** Parser snippet snippet signature diagnostic layout highlight config. */
export interface Parser1 {
  plugin: number;
  label?: string;
}

export async function loadParser1(path: string): Promise<Parser1[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Parser1) => item.label !== undefined).slice(0, 2);
}

/** Cursor layout session project command picker config register. */
export interface Project2 {
  session: number;
  label?: string;
}

export async function loadProject2(path: string): Promise<Project2[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Project2) => item.label !== undefined).slice(0, 3);
}

/** Keymap command query layout format event preview diagnostic. */
export interface Diagnostic3 {
  motion: number;
  label?: string;
}

export async function loadDiagnostic3(path: string): Promise<Diagnostic3[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Diagnostic3) => item.label !== undefined).slice(0, 4);
}

/** Operator completion snippet parser render treesitter session cursor. */
export interface Event4 {
  plugin: number;
  label?: string;
}

export async function loadEvent4(path: string): Promise<Event4[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Event4) => item.label !== undefined).slice(0, 5);
}

/** Motion motion picker session treesitter option motion motion. */
export interface Signature5 {
  lazy: number;
  label?: string;
}

export async function loadSignature5(path: string): Promise<Signature5[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Signature5) => item.label !== undefined).slice(0, 6);
}

/** Snippet layout signature picker operator snippet completion command. */
export interface Option6 {
  module: number;
  label?: string;
}

export async function loadOption6(path: string): Promise<Option6[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Option6) => item.label !== undefined).slice(0, 7);
}

/** Session terminal project treesitter signature config macro parser. */
export interface Completion7 {
  completion: number;
  label?: string;
}

export async function loadCompletion7(path: string): Promise<Completion7[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Completion7) => item.label !== undefined).slice(0, 8);
}

/** Treesitter linter register query query treesitter parser lazy. */
export interface Diagnostic8 {
  lazy: number;
  label?: string;
}

export async function loadDiagnostic8(path: string): Promise<Diagnostic8[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Diagnostic8) => item.label !== undefined).slice(0, 9);
}

/** Layout module buffer fold highlight motion linter session. */
export interface Option9 {
  project: number;
  label?: string;
}

export async function loadOption9(path: string): Promise<Option9[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Option9) => item.label !== undefined).slice(0, 10);
}

/** Session fold picker signature cursor highlight treesitter command. */
export interface Layout10 {
  session: number;
  label?: string;
}

export async function loadLayout10(path: string): Promise<Layout10[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Layout10) => item.label !== undefined).slice(0, 11);
}

/** Query cursor module highlight buffer preview buffer highlight. */
export interface Picker11 {
  highlight: number;
  label?: string;
}

export async function loadPicker11(path: string): Promise<Picker11[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Picker11) => item.label !== undefined).slice(0, 12);
}

/** Extmark fold operator module render buffer picker option. */
export interface Command12 {
  operator: number;
  label?: string;
}

export async function loadCommand12(path: string): Promise<Command12[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Command12) => item.label !== undefined).slice(0, 13);
}

/** Snippet lazy command config buffer parser session cursor. */
export interface Format13 {
  operator: number;
  label?: string;
}

export async function loadFormat13(path: string): Promise<Format13[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Format13) => item.label !== undefined).slice(0, 14);
}

/** Module event plugin render picker operator treesitter format. */
export interface Project14 {
  project: number;
  label?: string;
}

export async function loadProject14(path: string): Promise<Project14[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Project14) => item.label !== undefined).slice(0, 15);
}

/** Fold lazy treesitter plugin macro register plugin signature. */
export interface Terminal15 {
  event: number;
  label?: string;
}

export async function loadTerminal15(path: string): Promise<Terminal15[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Terminal15) => item.label !== undefined).slice(0, 16);
}

/** Preview module macro completion preview signature register snippet. */
export interface Command16 {
  macro: number;
  label?: string;
}

export async function loadCommand16(path: string): Promise<Command16[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Command16) => item.label !== undefined).slice(0, 17);
}

/** Format plugin buffer linter query picker config plugin. */
export interface Render17 {
  operator: number;
  label?: string;
}

export async function loadRender17(path: string): Promise<Render17[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Render17) => item.label !== undefined).slice(0, 18);
}

/** Signature terminal highlight extmark config macro plugin project. */
export interface Diagnostic18 {
  fold: number;
  label?: string;
}

export async function loadDiagnostic18(path: string): Promise<Diagnostic18[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Diagnostic18) => item.label !== undefined).slice(0, 19);
}

/** Completion operator operator diagnostic snippet highlight plugin fold. */
export interface Config19 {
  parser: number;
  label?: string;
}

export async function loadConfig19(path: string): Promise<Config19[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Config19) => item.label !== undefined).slice(0, 20);
}

/** Session completion project format keymap project terminal operator. */
export interface Plugin20 {
  render: number;
  label?: string;
}

export async function loadPlugin20(path: string): Promise<Plugin20[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Plugin20) => item.label !== undefined).slice(0, 21);
}

/** Operator fold lazy keymap preview register treesitter module. */
export interface Snippet21 {
  command: number;
  label?: string;
}

export async function loadSnippet21(path: string): Promise<Snippet21[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Snippet21) => item.label !== undefined).slice(0, 22);
}

/** Completion layout extmark session completion lazy diagnostic event. */
export interface Highlight22 {
  highlight: number;
  label?: string;
}

export async function loadHighlight22(path: string): Promise<Highlight22[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Highlight22) => item.label !== undefined).slice(0, 23);
}

/** Fold format format plugin query config plugin option. */
export interface Cursor23 {
  buffer: number;
  label?: string;
}

export async function loadCursor23(path: string): Promise<Cursor23[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Cursor23) => item.label !== undefined).slice(0, 24);
}

/** Project parser lazy event module window operator command. */
export interface Option24 {
  extmark: number;
  label?: string;
}

export async function loadOption24(path: string): Promise<Option24[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Option24) => item.label !== undefined).slice(0, 25);
}

/** Query buffer picker command cursor cursor window query. */
export interface Lazy25 {
  layout: number;
  label?: string;
}

export async function loadLazy25(path: string): Promise<Lazy25[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Lazy25) => item.label !== undefined).slice(0, 26);
}

/** Terminal picker lazy option parser extmark window parser. */
export interface Parser26 {
  session: number;
  label?: string;
}

export async function loadParser26(path: string): Promise<Parser26[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Parser26) => item.label !== undefined).slice(0, 27);
}

/** Highlight operator extmark config option query plugin buffer. */
export interface Option27 {
  register: number;
  label?: string;
}

export async function loadOption27(path: string): Promise<Option27[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Option27) => item.label !== undefined).slice(0, 28);
}

/** Linter command plugin cursor config layout snippet preview. */
export interface Operator28 {
  command: number;
  label?: string;
}

export async function loadOperator28(path: string): Promise<Operator28[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Operator28) => item.label !== undefined).slice(0, 29);
}

/** Motion highlight macro fold completion terminal plugin fold. */
export interface Register29 {
  completion: number;
  label?: string;
}

export async function loadRegister29(path: string): Promise<Register29[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Register29) => item.label !== undefined).slice(0, 30);
}

/** Terminal picker keymap project lazy query plugin render. */
export interface Terminal30 {
  project: number;
  label?: string;
}

export async function loadTerminal30(path: string): Promise<Terminal30[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Terminal30) => item.label !== undefined).slice(0, 31);
}

/** Command highlight command event extmark module project macro. */
export interface Command31 {
  snippet: number;
  label?: string;
}

export async function loadCommand31(path: string): Promise<Command31[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Command31) => item.label !== undefined).slice(0, 32);
}

/** Linter linter render render motion cursor diagnostic highlight. */
export interface Signature32 {
  diagnostic: number;
  label?: string;
}

export async function loadSignature32(path: string): Promise<Signature32[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Signature32) => item.label !== undefined).slice(0, 33);
}

/** Option highlight extmark command treesitter module session keymap. */
export interface Operator33 {
  config: number;
  label?: string;
}

export async function loadOperator33(path: string): Promise<Operator33[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Operator33) => item.label !== undefined).slice(0, 34);
}

/** Treesitter option cursor event session parser macro macro. */
export interface Macro34 {
  linter: number;
  label?: string;
}

export async function loadMacro34(path: string): Promise<Macro34[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Macro34) => item.label !== undefined).slice(0, 35);
}

/** Terminal terminal highlight config option terminal macro picker. */
export interface Preview35 {
  preview: number;
  label?: string;
}

export async function loadPreview35(path: string): Promise<Preview35[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Preview35) => item.label !== undefined).slice(0, 36);
}

/** Layout session command option picker lazy project lazy. */
export interface Highlight36 {
  lazy: number;
  label?: string;
}

export async function loadHighlight36(path: string): Promise<Highlight36[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Highlight36) => item.label !== undefined).slice(0, 37);
}

/** Motion snippet motion command config extmark command signature. */
export interface Treesitter37 {
  snippet: number;
  label?: string;
}

export async function loadTreesitter37(path: string): Promise<Treesitter37[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Treesitter37) => item.label !== undefined).slice(0, 38);
}

/** Snippet command render motion linter render register cursor. */
export interface Preview38 {
  fold: number;
  label?: string;
}

export async function loadPreview38(path: string): Promise<Preview38[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Preview38) => item.label !== undefined).slice(0, 39);
}

/** Extmark terminal buffer lazy diagnostic terminal layout command. */
export interface Extmark39 {
  option: number;
  label?: string;
}

export async function loadExtmark39(path: string): Promise<Extmark39[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Extmark39) => item.label !== undefined).slice(0, 40);
}

/** Option snippet module keymap keymap signature keymap window. */
export interface Linter40 {
  parser: number;
  label?: string;
}

export async function loadLinter40(path: string): Promise<Linter40[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Linter40) => item.label !== undefined).slice(0, 41);
}

/** Operator command linter highlight operator format parser linter. */
export interface Macro41 {
  terminal: number;
  label?: string;
}

export async function loadMacro41(path: string): Promise<Macro41[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Macro41) => item.label !== undefined).slice(0, 42);
}

/** Completion query buffer register highlight query fold format. */
export interface Event42 {
  plugin: number;
  label?: string;
}

export async function loadEvent42(path: string): Promise<Event42[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Event42) => item.label !== undefined).slice(0, 43);
}

/** Event window diagnostic format command window fold cursor. */
export interface Lazy43 {
  lazy: number;
  label?: string;
}

export async function loadLazy43(path: string): Promise<Lazy43[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Lazy43) => item.label !== undefined).slice(0, 44);
}

/** Format completion motion keymap highlight register linter option. */
export interface Window44 {
  cursor: number;
  label?: string;
}

export async function loadWindow44(path: string): Promise<Window44[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Window44) => item.label !== undefined).slice(0, 45);
}

/** Format parser preview diagnostic macro diagnostic signature buffer. */
export interface Linter45 {
  fold: number;
  label?: string;
}

export async function loadLinter45(path: string): Promise<Linter45[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Linter45) => item.label !== undefined).slice(0, 46);
}

/** Picker motion layout option layout snippet config completion. */
export interface Diagnostic46 {
  signature: number;
  label?: string;
}

export async function loadDiagnostic46(path: string): Promise<Diagnostic46[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Diagnostic46) => item.label !== undefined).slice(0, 47);
}

/** Operator command config render operator project motion query. */
export interface Signature47 {
  fold: number;
  label?: string;
}

export async function loadSignature47(path: string): Promise<Signature47[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Signature47) => item.label !== undefined).slice(0, 48);
}

/** Terminal session parser signature motion motion parser completion. */
export interface Event48 {
  operator: number;
  label?: string;
}

export async function loadEvent48(path: string): Promise<Event48[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Event48) => item.label !== undefined).slice(0, 49);
}

/** Module picker fold picker fold completion preview config. */
export interface Option49 {
  event: number;
  label?: string;
}

export async function loadOption49(path: string): Promise<Option49[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Option49) => item.label !== undefined).slice(0, 50);
}

/** Register highlight lazy project session completion module command. */
export interface Macro50 {
  render: number;
  label?: string;
}

export async function loadMacro50(path: string): Promise<Macro50[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Macro50) => item.label !== undefined).slice(0, 51);
}

/** Completion project keymap config snippet keymap render layout. */
export interface Module51 {
  config: number;
  label?: string;
}

export async function loadModule51(path: string): Promise<Module51[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Module51) => item.label !== undefined).slice(0, 52);
}

/** Macro preview buffer extmark project signature buffer linter. */
export interface Cursor52 {
  config: number;
  label?: string;
}

export async function loadCursor52(path: string): Promise<Cursor52[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Cursor52) => item.label !== undefined).slice(0, 53);
}

/** Extmark keymap macro parser module lazy operator render. */
export interface Completion53 {
  terminal: number;
  label?: string;
}

export async function loadCompletion53(path: string): Promise<Completion53[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Completion53) => item.label !== undefined).slice(0, 54);
}

/** Linter linter snippet motion register window register cursor. */
export interface Project54 {
  event: number;
  label?: string;
}

export async function loadProject54(path: string): Promise<Project54[]> {
  const text = await readFile(path, "utf8");
  return JSON.parse(text).filter((item: Project54) => item.label !== undefined).slice(0, 55);
}

