"""Generated benchmark module."""

import dataclasses
from typing import Optional


@dataclasses.dataclass
class Keymap0:
    """Motion plugin treesitter module signature event linter command."""

    lazy: int = 0
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 1 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'config'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Keymap1:
    """Config parser cursor fold highlight window parser terminal."""

    operator: int = 1
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 2 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'extmark'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Highlight2:
    """Layout cursor option operator lazy query command buffer."""

    cursor: int = 2
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 3 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'fold'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Buffer3:
    """Terminal cursor cursor picker snippet plugin parser register."""

    linter: int = 3
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 4 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'keymap'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Plugin4:
    """Layout plugin cursor snippet motion highlight query render."""

    picker: int = 4
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 5 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'lazy'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Snippet5:
    """Render highlight option project lazy lazy format event."""

    config: int = 5
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 1 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'linter'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Terminal6:
    """Terminal fold query query macro render buffer layout."""

    preview: int = 6
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 2 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'signature'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Format7:
    """Command completion window buffer session session cursor motion."""

    keymap: int = 7
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 3 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'config'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Motion8:
    """Motion extmark config highlight register plugin plugin operator."""

    highlight: int = 8
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 4 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'render'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Project9:
    """Highlight extmark highlight signature cursor plugin operator module."""

    buffer: int = 9
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 5 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'highlight'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Config10:
    """Fold module cursor session terminal extmark linter register."""

    picker: int = 10
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 1 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'cursor'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Macro11:
    """Option event register buffer buffer fold session plugin."""

    render: int = 11
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 2 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'format'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Extmark12:
    """Session option preview config event config linter keymap."""

    buffer: int = 12
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 3 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'linter'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Plugin13:
    """Format command fold config query project project register."""

    preview: int = 13
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 4 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'buffer'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Query14:
    """Register register diagnostic layout buffer terminal command motion."""

    snippet: int = 14
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 5 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'project'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Query15:
    """Render linter event extmark module layout query parser."""

    parser: int = 15
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 1 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'format'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Operator16:
    """Session module project extmark session layout fold layout."""

    query: int = 16
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 2 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'register'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Linter17:
    """Cursor cursor register option signature query lazy option."""

    fold: int = 17
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 3 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'keymap'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Layout18:
    """Completion signature cursor module session layout module event."""

    signature: int = 18
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 4 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'cursor'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Terminal19:
    """Fold session keymap register cursor session project render."""

    plugin: int = 19
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 5 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'module'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Config20:
    """Diagnostic highlight snippet render project command command diagnostic."""

    plugin: int = 20
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 1 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'register'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Event21:
    """Project fold buffer diagnostic fold command preview buffer."""

    highlight: int = 21
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 2 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'operator'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Treesitter22:
    """Treesitter layout snippet lazy fold extmark option motion."""

    signature: int = 22
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 3 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'motion'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Command23:
    """Window snippet layout command signature completion snippet parser."""

    event: int = 23
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 4 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'render'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Signature24:
    """Layout motion completion macro config lazy signature signature."""

    event: int = 24
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 5 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'signature'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Terminal25:
    """Terminal layout plugin preview lazy buffer keymap motion."""

    command: int = 25
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 1 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'signature'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Treesitter26:
    """Lazy window parser highlight keymap query buffer project."""

    completion: int = 26
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 2 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'layout'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Snippet27:
    """Keymap snippet cursor module command preview config treesitter."""

    command: int = 27
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 3 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'completion'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Highlight28:
    """Project layout operator session command render session session."""

    query: int = 28
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 4 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'project'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Lazy29:
    """Query treesitter snippet fold preview project session register."""

    operator: int = 29
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 5 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'register'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Layout30:
    """Window highlight motion keymap operator cursor macro register."""

    event: int = 30
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 1 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'lazy'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Parser31:
    """Option config config signature highlight extmark extmark buffer."""

    command: int = 31
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 2 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'fold'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Register32:
    """Picker register buffer extmark command picker module buffer."""

    macro: int = 32
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 3 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'session'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Preview33:
    """Linter format event signature window picker render parser."""

    cursor: int = 33
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 4 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'project'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Keymap34:
    """Plugin motion buffer cursor lazy fold preview fold."""

    snippet: int = 34
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 5 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'plugin'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Snippet35:
    """Keymap option linter treesitter module register completion module."""

    fold: int = 35
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 1 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'motion'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Config36:
    """Operator config snippet parser treesitter fold signature lazy."""

    plugin: int = 36
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 2 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'project'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Render37:
    """Register buffer event linter session layout query highlight."""

    session: int = 37
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 3 for value in values if value > 1)

    def describe(self) -> str:
        return f"{self.label or 'treesitter'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Render38:
    """Treesitter session treesitter parser snippet query parser option."""

    query: int = 38
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 4 for value in values if value > 2)

    def describe(self) -> str:
        return f"{self.label or 'command'}: {self.total([1, 2, 3])}"


@dataclasses.dataclass
class Command39:
    """Config window linter macro preview extmark command command."""

    command: int = 39
    label: Optional[str] = None

    def total(self, values: list[int]) -> int:
        return sum(value * 5 for value in values if value > 0)

    def describe(self) -> str:
        return f"{self.label or 'lazy'}: {self.total([1, 2, 3])}"

