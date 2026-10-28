# record_grid

**One capability bit from GBT V8, packaged standalone.** No. 72 of 341,
`data` domain (Data).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 行式记录网格：陌生文本结构画像/草案骨架/逐行解析/回写自证/词表校验（op=profile|draft|parse|emit|verify|vocab|presets）

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-record-grid.git
cd gbt-record-grid
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_record_grid info                  # capability card
python -m gbt_record_grid spec --json           # machine-readable contract
python -m gbt_record_grid check --payload '{"text": "<在此填写>", "path": "./example.txt"}'
python -m gbt_record_grid run   --payload '{"text": "<在此填写>", "path": "./example.txt"}'
```

Real `info` output from this machine:

```text
record_grid  (data)  v1.0.0
----------------------------------------
行式记录网格：陌生文本结构画像/草案骨架/逐行解析/回写自证/词表校验（op=profile|draft|parse|emit|verify|vocab|presets）

gated      : False
external   : False
multi-op   : True
params     : text, path
             要画像/解析的内容：内联 text 或框架内相对路径 path（二选一）；parse 另需 plan 或 plan_name；emit 还要 records（记录列表）
values     : (multi-op, but the registry does not enumerate them)
```

Wire a real implementation:

```python
from gbt_record_grid import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({"text": "<在此填写>", "path": "./example.txt"}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| `text` | yes | declared required by the registry |
| `path` | yes | declared required by the registry |

Registry hint (`params_hint`): 要画像/解析的内容：内联 text 或框架内相对路径 path（二选一）；parse 另需 plan 或 plan_name；emit 还要 records（记录列表）

**注册表标注 `multi_op: true`，但没有枚举具体取值。**本包不替它编造取值清单——这种缺口应当在注册表源头补，而不是在文档里圆。

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
23 passed, 1 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `record_grid` |
| domain | `data` |
| handler | `record_grid` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [data/record_grid](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/data/record_grid.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
